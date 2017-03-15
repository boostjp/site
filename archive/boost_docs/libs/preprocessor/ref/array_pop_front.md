# BOOST_PP_ARRAY_POP_FRONT

The `BOOST_PP_ARRAY_POP_FRONT` macro pops an element from the end of an `array`.

## Usage

```cpp
BOOST_PP_ARRAY_POP_FRONT(array)
```

## Arguments

- `array` :
	The `array` to pop an element from.

## Remarks

This macro returns `array` after removing the first element.
If `array` has no elements, the result of applying this macro is undefined.

This macro uses `BOOST_PP_REPEAT` internally.
Therefore, to use the `z` parameter passed from other macros that use `BOOST_PP_REPEAT`, see `BOOST_PP_ARRAY_POP_FRONT_Z`

## See Also

- [`BOOST_PP_ARRAY_POP_FRONT_Z`](array_pop_front_z.md)

## Requirements

**Header:** &lt;boost/preprocessor/array/pop_front.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/array/pop_front.hpp>

# define ARRAY (3, (a, b, c))

BOOST_PP_ARRAY_POP_FRONT(ARRAY) // expands to (2, (b, c))
```
* BOOST_PP_ARRAY_POP_FRONT[link array_pop_front.md]

