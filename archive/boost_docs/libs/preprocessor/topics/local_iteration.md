# Local Iteration

Local iteration is a simple vertical repetition construct.
It expands a macro with each number in a user-specified range.
Each expansion is on a separate line.

## Tutorial

This mechanism requires two pieces of information to operate:
a range to iterate over and a macro to expand on each iteration.
This information is obtained by the mechanism through two *named external arguments*.
These arguments are specified as user-defined macros named `BOOST_PP_LOCAL_LIMITS` and `BOOST_PP_LOCAL_MACRO`.

`BOOST_PP_LOCAL_LIMITS` specifies a range of values to iterate over.
It *must* expand to a *tuple* containing two elements--a lower and upper bound.
Both the upper and lower bounds must be numeric values in the range of *0* to `BOOST_PP_LIMIT_ITERATION`.
For example, if the user wishes a macro to be expanded with numbers ranging from *0* to *10*,
`BOOST_PP_LOCAL_LIMITS` would be defined like this:

```cpp
# define BOOST_PP_LOCAL_LIMITS (0, 10)
```

Note that there is whitespace after the name of the macro.
The macro *does not* take *two* arguments.
In the case above, if there was no whitespace, a preprocessing error would occur because *0* and *10* are invalid identifiers.

Both the upper and lower bounds specified in the `BOOST_PP_LOCAL_LIMITS` macro are *evaluated parameters*.
This implies that they can include simple arithmetic or logical expressions.
For instance, the above definition could easily have been written like this:

```cpp
# define N() 5
# define BOOST_PP_LOCAL_LIMITS (0, N() + 5)
```

Because of this, if the whitespace after the macro name is elided, it is possible for the definition to be syntactically valid:

```cpp
# define A 0
# define B 10
# define BOOST_PP_LOCAL_LIMITS(A, B)
	// note:  no whitespace  ^
```

If this happens, an error will occur inside the mechanism when it attempts to use this macro.
The error messages that result may be obscure, so always remember to include the whitespace.
A *correct* version of the above looks like this:

```cpp
# define A 0
# define B 10
# define BOOST_PP_LOCAL_LIMITS (A, B)
	// note:  has whitespace ^
```

`BOOST_PP_LOCAL_MACRO` is the macro that is expanded by the mechanism.
This macro is expanded on each iteration with the current number of the iteration.
It must defined as a unary macro *or* result in a macro that can be called with one argument:

```cpp
# define BOOST_PP_LOCAL_MACRO(n) \
	template<> struct sample<n> { }; \
	/**/
```

...or...

```cpp
# define SAMPLE(n) \
	template<> struct sample<n> { }; \
	/**/

# define BOOST_PP_LOCAL_MACRO SAMPLE
```

Once these two macros are defined, the local iteration is initiated by *including* `BOOST_PP_LOCAL_ITERATE()`.

```cpp
??=include BOOST_PP_LOCAL_ITERATE()
```

(The `??=` token is a trigraph for `#`.
I use the trigraph to make it clear that I am *including* a file rather than defining or expanding a macro, but it is not necessary.
Even the digraph version, `%:`, could be used.
Some compilers do not readily accept trigraphs and digraphs, so keep that in mind.
Other than that, use whichever one you prefer.)

In order to repeat the `sample` specialization, the pieces must be put together....

```cpp
# define BOOST_PP_LOCAL_MACRO(n) \
	template<> struct sample<n> { }; \
	/**/

# define BOOST_PP_LOCAL_LIMITS (0, 10)
??=include BOOST_PP_LOCAL_ITERATE()
```

This will result in a specialization of `sample` for each number in the range of *0* to *10*.
The output will look something like this:

```cpp
template<> struct sample<0> { };
template<> struct sample<1> { };
template<> struct sample<2> { };

// ...

template<> struct sample<10> { };
```

After the local-iteration is complete, both `BOOST_PP_LOCAL_LIMITS` and `BOOST_PP_LOCAL_MACRO` are automatically undefined.
If the values need to be retained for a future local-iteration, they must be defined indirectly:

```cpp
# define LIMITS (0, 10)

# define SAMPLE(n) \
	template<> struct sample<n> { }; \
	/**/

# define BOOST_PP_LOCAL_LIMITS LIMITS
# define BOOST_PP_LOCAL_MACRO(n) SAMPLE(n)

??=include BOOST_PP_LOCAL_ITERATE()
```

## See Also

- [`BOOST_PP_LOCAL_ITERATE`](../ref/local_iterate.md)
- [`BOOST_PP_LOCAL_LIMITS`](../ref/local_limits.md)
- [`BOOST_PP_LOCAL_MACRO`](../ref/local_macro.md)

---

Paul Mensonides

