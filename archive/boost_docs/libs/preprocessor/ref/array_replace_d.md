# BOOST_PP_ARRAY_REPLACE_D

The `BOOST_PP_ARRAY_REPLACE_D` macro replaces an element in an `array`.
It reenters `BOOST_PP_WHILE` with maximum efficiency.

## Usage

```cpp
BOOST_PP_ARRAY_REPLACE_D(d, array, i, elem)
```

## Arguments

- `d` :
	The next available `BOOST_PP_WHILE` iteration.

- `array` :
	An `array` to replace an element in.

- `i` :
	The zero-based position in `array` of the element to be replaced.
	Valid values range from `0` to `BOOST_PP_ARRAY_SIZE(array) - 1`.

- `elem` :
	The replacement element.

## See Also

- [`BOOST_PP_ARRAY_REPLACE`](array_replace.md)

## Requirements

Header: &lt;boost/preprocessor/array/replace.hpp&gt;

