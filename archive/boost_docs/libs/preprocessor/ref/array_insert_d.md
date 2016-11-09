#BOOST_PP_ARRAY_INSERT_D

The `BOOST_PP_ARRAY_INSERT_D` macro inserts an element into an `array`.
It reenters `BOOST_PP_WHILE` with maximum efficiency.

##Usage

```cpp
BOOST_PP_ARRAY_INSERT_D(d, array, i, elem)
```

##Arguments

- `d` :
	The next available `BOOST_PP_WHILE` iteration.

- `array` :
	The `array` into which an element is to be inserted.

- `i` :
	The zero-based position in `array` where an element is to be inserted.
	Valid values range from `0` to `BOOST_PP_ARRAY_SIZE(array)`.

- `elem` :
	The element to insert.

##Remarks

This macro inserts `elem` before the element at index `i`.

If the operation attempts to create an `array` that is larger than `BOOST_PP_LIMIT_TUPLE`, the result is undefined.

##See Also

- [`BOOST_PP_ARRAY_INSERT`](array_insert.md)

##Requirements

**Header:** &lt;boost/preprocessor/array/insert.hpp&gt;

