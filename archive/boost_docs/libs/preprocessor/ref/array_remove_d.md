# BOOST_PP_ARRAY_REMOVE_D

The `BOOST_PP_ARRAY_REMOVE_D` macro removes an element from an `array`.
It reenters `BOOST_PP_WHILE` with maximum efficiency.

## Usage

```cpp
BOOST_PP_ARRAY_REMOVE_D(d, array, i)
```

## Arguments

- `d` :
	The next available `BOOST_PP_WHILE` iteration.

- `array` :
	The `array` from which an element is to be removed.

- `i` :
	The zero-based position in `array` of the element to be removed.
	Valid values range from `0` to `BOOST_PP_ARRAY_SIZE(array) - 1`.

## See Also

- [`BOOST_PP_ARRAY_REMOVE`](array_remove.md)

## Requirements

**Header:** &lt;boost/preprocessor/array/remove.hpp&gt;

