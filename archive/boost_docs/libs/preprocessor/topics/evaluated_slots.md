# Evaluated Slots

The evaluated slot mechanism is a tool to fully evaluate a constant integral expression and avoid the lazy evaluation normally performed by the preprocessor.

## Tutorial

In order to understand the use of such a mechanism, I will start with a simple file-iteration example.
Consider the following scenario....

```cpp
for (int i = 0; i < 10; ++i) {
	for (int j = 0; j < i; ++j) {
		// ... use i and j
	}
}
```

The above is a simple runtime model of the following multidimensional file-iteration....

```cpp
// file.hpp
# if !BOOST_PP_IS_ITERATING
	#ifndef FILE_HPP_
	#define FILE_HPP_

	#include <boost/preprocessor/iteration/iterate.hpp>

	#define BOOST_PP_ITERATION_PARAMS_1 (3, (0, 9, "file.hpp"))
	#include BOOST_PP_ITERATE()

	#endif // FILE_HPP_
# elif BOOST_PP_ITERATION_DEPTH() == 1
	#define I BOOST_PP_ITERATION()

	#define BOOST_PP_ITERATION_PARAMS_2 (3, (0, I, "file.hpp"))
	#include BOOST_PP_ITERATE()

	#undef I
# elif BOOST_PP_ITERATION_DEPTH() == 2
	#define J BOOST_PP_ITERATION()

	// use I and J

	#undef J
# endif
```

There is a problem with the code above.
The writer expected *I* to refer the previous iteration frame.
However, that is not the case.
When the user refers to *I*, he is actually referring to `BOOST_PP_ITERATION()`, not the value of `BOOST_PP_ITERATION()` at the point of definition.
Instead, it refers to exactly the same value to which *J* refers.

The problem is that the preprocessor always evaluates everything with lazy evaluation.
To solve the problem, we need *I* to be *evaluated* here:

```cpp
// ...
# elif BOOST_PP_ITERATION_DEPTH() == 1
	#define I BOOST_PP_ITERATION()
// ...
```

Fortunately, the library offers a mechanism to do just that: evaluated slots.
The following code uses this mechanism to "fix" the example above...

```cpp
// ...
# elif BOOST_PP_ITERATION_DEPTH() == 1
	#define BOOST_PP_VALUE BOOST_PP_ITERATION()
	#include BOOST_PP_ASSIGN_SLOT(1)
	#define I BOOST_PP_SLOT(1)
// ...
```

There are two steps to the assignment of an evaluated slot.
First, the user must define the *named external argument* `BOOST_PP_VALUE`.
This value must be an integral constant expression.
Second, the user must *include* `BOOST_PP_ASSIGN_SLOT(x)`, where *x* is the particular slot to be assigned to (*1* to `BOOST_PP_LIMIT_SLOT_COUNT`).
This will evaluate `BOOST_PP_VALUE` and assign the result to the slot at index *x*.

To retrieve a slot's value, the user must use `BOOST_PP_SLOT(x)`.

In the case above, *I* is *still* lazily evaluated.
However, it now evaluates to `BOOST_PP_SLOT(1)`.
This value *will not change* unless there is a subsequent call to `BOOST_PP_ASSIGN_SLOT(1)`.

## Advanced Techniques

The slot mechanism can also be used to perform calculations:

```cpp
#include <iostream>

#include <boost/preprocessor/slot/slot.hpp>
#include <boost/preprocessor/stringize.hpp>

# define X() 4

# define BOOST_PP_VALUE 1 + 2 + 3 + X()
# include BOOST_PP_ASSIGN_SLOT(1)

# undef X

int main(void) {
	std::cout
		<< BOOST_PP_STRINGIZE(BOOST_PP_SLOT(1))
		<< &std::endl;
	return 0;
}
```

In essence, anything that can be evaluated in an `#if` (or `#elif`) preprocessor directive is available *except* the *defined* operator.

It is even possible to use a particular slot itself while reassigning it:

```cpp
# define BOOST_PP_VALUE 20
# include BOOST_PP_ASSIGN_SLOT(1)

# define BOOST_PP_VALUE 2 * BOOST_PP_SLOT(1)
# include BOOST_PP_ASSIGN_SLOT(1)

BOOST_PP_SLOT(1) // 40
```

## See Also

- [`BOOST_PP_ASSIGN_SLOT`](../ref/assign_slot.md)
- [`BOOST_PP_LIMIT_SLOT_COUNT`](../ref/limit_slot_count.md)
- [`BOOST_PP_SLOT`](../ref/slot.md)
- [`BOOST_PP_VALUE`](../ref/value.md)

---

Paul Mensonides

