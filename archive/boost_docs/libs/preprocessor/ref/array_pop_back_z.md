# BOOST_PP_ARRAY_POP_BACK_Z

The `BOOST_PP_ARRAY_POP_BACK_Z` macro pops an element from the end of an `array`.
It reenters `BOOST_PP_REPEAT` with maximum efficiency.

## Usage

```cpp
BOOST_PP_ARRAY_POP_BACK_Z(z, array)
```

## Arguments

- `z` :
	The next available `BOOST_PP_REPEAT` dimension.

- `array` :
	The `array` to pop an element from.

## Remarks

This macro returns `array` after removing the last element.
If `array` has no elements, the result of applying this macro is undefined.

## See Also

- [`BOOST_PP_ARRAY_POP_BACK`](array_pop_back.md)

## Requirements

**Header:** &lt;boost/preprocessor/array/pop_back.hpp&gt;

