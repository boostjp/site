# Reentrancy

Macro expansion in the preprocessor is entirely functional.
Therefore, there is no iteration.
Unfortunately, the preprocessor also disallows recursion.
This means that the library must fake iteration or recursion by defining sets of macros that are implemented similarly.

To illustrate, here is a simple concatenation macro:

```cpp
# define CONCAT(a, b) CONCAT_D(a, b)
# define CONCAT_D(a, b) a ## b

CONCAT(a, CONCAT(b, c)) // abc
```

This is fine for a simple case like the above, but what happens in a scenario like the following:

```cpp
# define AB(x, y) CONCAT(x, y)

CONCAT(A, B(p, q)) // CONCAT(p, q)
```

Because there is no recursion, the example above expands to `CONCAT(p, q)` rather than `pq`.

There are only two ways to "fix" the above.
First, it can be documented that `AB` uses `CONCAT` and disallow usage similar to the above.
Second, multiple concatenation macros can be provided....

```cpp
# define CONCAT_1(a, b) CONCAT_1_D(a, b)
# define CONCAT_1_D(a, b) a ## b

# define CONCAT_2(a, b) CONCAT_2_D(a, b)
# define CONCAT_2_D(a, b) a ## b

# define AB(x, y) CONCAT_2(x, y)

CONCAT_1(A, B(p, q)) // pq
```

This solves the problem.
However, it is now necessary to know that `AB` uses, not only *a* concatenation macro, but `CONCAT_2` specifically.

A better solution is to abstract *which* concatenation macro is used....

```cpp
# define AB(c, x, y) CONCAT_ ## c(x, y)

CONCAT_1(A, B(2, p, q)) // pq
```

This is an example of *generic reentrance*, in this case, into a fictional set of concatenation macros.
The `c` parameter represents the "state" of the concatenation construct, and as long as the user keeps track of this state, `AB` can be used inside of a concatenation macro.

The library has the same choices.
It either has to disallow a construct being inside itself or provide multiple, equivalent definitions of a construct and provide a uniform way to *reenter* that construct.
There are several contructs that *require* recursion (such as `BOOST_PP_WHILE`).
Consequently, the library chooses to provide several sets of macros with mechanisms to reenter the set at a macro that has not already been used.

In particular, the library must provide reentrance for `BOOST_PP_FOR`, `BOOST_PP_REPEAT`, and `BOOST_PP_WHILE`.
There are two mechanisms that are used to accomplish this: state parameters (like the above concatenation example) and *automatic recursion*.

## State Parameters

Each of the above constructs (`BOOST_PP_FOR`, `BOOST_PP_REPEAT`, and `BOOST_PP_WHILE`) has an associated state.&
This state provides the means to reenter the respective construct.

Several user-defined macros are passed to each of these constructs (for use as predicates, operations, etc.).
Every time a user-defined macro is invoked, it is passed the current state of the construct that invoked it so that the macro can reenter the respective set if necessary.

These states are used in one of two ways--either by concatenating to or passing to another macro.

There are three types of macros that use these state parameters.
First, the set itself which is reentered through concatenation.
Second, corresponding sets that act like they are a part of the the primary set.
These are also reentered through concatenation.
And third, macros that internally use the first or second type of macro.
These macros take the state as an additional argument.

The state of `BOOST_PP_WHILE` is symbolized by the letter *D*.
Two user-defined macros are passed to `BOOST_PP_WHILE` --a predicate and an operation.
When `BOOST_PP_WHILE` expands these macros, it passes along its state so that these macros can reenter the `BOOST_PP_WHILE` set.

Consider the following multiplication implementation that illustrates this technique:

```cpp
// The addition interface macro.
// The _D signifies that it reenters
// BOOST_PP_WHILE with concatenation.

# define ADD_D(d, x, y) \
	BOOST_PP_TUPLE_ELEM( \
		2, 0, \
		BOOST_PP_WHILE_ ## d(ADD_P, ADD_O, (x, y)) \
	) \
	/**/

// The predicate that is passed to BOOST_PP_WHILE.
// It returns "true" until "y" becomes zero.

# define ADD_P(d, xy) BOOST_PP_TUPLE_ELEM(2, 1, xy)

// The operation that is passed to BOOST_PP_WHILE.
// It increments "x" and decrements "y" which will
// eventually cause "y" to equal zero and therefore
// cause the predicate to return "false."

# define ADD_O(d, xy) \
	( \
		BOOST_PP_INC( \
			BOOST_PP_TUPLE_ELEM(2, 0, xy) \
		), \
		BOOST_PP_DEC( \
			BOOST_PP_TUPLE_ELEM(2, 1, xy) \
		) \
	) \
	/**/

// The multiplication interface macro.

# define MUL(x, y) \
	BOOST_PP_TUPLE_ELEM( \
		3, 0, \
		BOOST_PP_WHILE(MUL_P, MUL_O, (0, x, y)) \
	) \
	/**/

// The predicate that is passed to BOOST_PP_WHILE.
// It returns "true" until "y" becomes zero.

# define MUL_P(d, rxy) BOOST_PP_TUPLE_ELEM(3, 2, rxy)

// The operation that is passed to BOOST_PP_WHILE.
// It adds "x" to "r" and decrements "y" which will
// eventually cause "y" to equal zero and therefore
// cause the predicate to return "false."

# define MUL_O(d, rxy) \
	( \
		ADD_D( \
			d, /* pass the state on to ADD_D */ \
			BOOST_PP_TUPLE_ELEM(3, 0, rxy), \
			BOOST_PP_TUPLE_ELEM(3, 1, rxy) \
		), \
		BOOST_PP_TUPLE_ELEM(3, 1, rxy), \
		BOOST_PP_DEC( \
			BOOST_PP_TUPLE_ELEM(3, 2, rxy) \
		) \
	) \
	/**/

MUL(3, 2) // expands to 6
```

There are a couple things to note in the above implementation.
First, note how `ADD_D` reenters `BOOST_PP_WHILE` using the *d* state parameter.
Second, note how `MUL` 's operation, which is expanded by `BOOST_PP_WHILE`, passes the state on to `ADD_D`.
This illustrates state reentrance by both argument and concatenation.

For every macro in the library that uses `BOOST_PP_WHILE`, there is a state reentrant variant.
If that variant uses an argument rather than concatenation, it is suffixed by `_D` to symbolize its method of reentrance.
Examples or this include the library's own `BOOST_PP_ADD_D` and `BOOST_PP_MUL_D`.
If the variant uses concatenation, it is suffixed by an underscore.
It is completed by concatenation of the state.
This includes `BOOST_PP_WHILE` itself with `BOOST_PP_WHILE_` ## *d* and, for example, `BOOST_PP_LIST_FOLD_LEFT` with `BOOST_PP_LIST_FOLD_LEFT_` ## *d*.

The same set of conventions are used for `BOOST_PP_FOR` and `BOOST_PP_REPEAT`, but with the letters `R` and `Z`, respectively, to symbolize their states.

Also note that the above `MUL` implementation, though not immediately obvious, is using *all three* types of reentrance.
Not only is it using both types of *state* reentrance, it is also using *automatic recursion*....

## Automatic Recursion

Automatic recursion is a technique that vastly simplifies the use of reentrant constructs.
It is used by simply *not* using any state parameters at all.

The `MUL` example above uses automatic recursion when it uses `BOOST_PP_WHILE` by itself.
In other words, `MUL` can *still* be used inside `BOOST_PP_WHILE` even though it doesn't reenter `BOOST_PP_WHILE` by concatenating the state to `BOOST_PP_WHILE_`.

To accomplish this, the library uses a "trick."
Despite what it looks like, the macro `BOOST_PP_WHILE` does not take three arguments.
In fact, it takes no arguments at all.
Instead, the `BOOST_PP_WHILE` macro expands *to* a macro that takes three arguments.
It simply detects what the next available `BOOST_PP_WHILE_` ## *d* macro is and returns it.
This detection process is somewhat involved, so I won't go into *how* it works here, but suffice to say it *does* work.

Using automatic recursion to reenter various sets of macros is obviously much simpler.
It completely hides the underlying implementation details.
So, if it is so much easier to use, why do the state parameters still exist?
The reason is simple as well.
When state parameters are used, the state is *known* at all times.
This is not the case when automatic recursion is used.
The automatic recursion mechanism has to *deduce* the state at each point that it is used.
This implies a cost in macro complexity that in some situations--notably at deep macro depths--will slow some preprocessors to a crawl.

## Conclusion

It is really a tradeoff whether to use state parameters or automatic recursion for reentrancy.
The strengths of automatic recursion are ease of use and implementation encapsulation.
These come at a performance cost on some preprocessors in some situations.
The primary strength of state parameters, on the other hand, is efficiency.
Use of the state parameters is the only way to achieve *maximum* efficiency.
This efficiency comes at the cost of both code complexity and exposition of implementation.

## See Also

- [`BOOST_PP_FOR`](../ref/for.md)
- [`BOOST_PP_REPEAT`](../ref/repeat.md)
- [`BOOST_PP_WHILE`](../ref/while.md)

---

Paul Mensonides
	
