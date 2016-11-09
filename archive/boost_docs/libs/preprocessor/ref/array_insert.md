#BOOST_PP_ARRAY_INSERT

The `BOOST_PP_ARRAY_INSERT` macro inserts an element into an *array*.

##Usage

```cpp
BOOST_PP_ARRAY_INSERT(array, i, elem)
```

##Arguments

- `array` :
	The `array` into which an element is to be inserted.

- `i` :
	The zero-based position in `array` where an element is to be inserted.
	Valid values range from ` to `BOOST_PP_ARRAY_SIZE(array)`.

- `elem` :
	The element to insert.

##Remarks

This macro inserts `elem` before the element at index `i`.

If the operation attempts to create an `array` that is larger than `BOOST_PP_LIMIT_TUPLE`, the result is undefined.

This macro uses `BOOST_PP_WHILE` interally.
Therefore, to use the `d` parameter passed from other macros that use `BOOST_PP_WHILE`, see `BOOST_PP_ARRAY_INSERT_D`.

##See Also

- [`BOOST_PP_ARRAY_INSERT_D`](array_insert_d.md)

##Requirements

**Header:** &lt;boost/preprocessor/array/insert.hpp&gt;

##Sample Code

```cpp
#include <boost/preprocessor/array/insert.hpp>

#define ARRAY (3, (a, b, d))

BOOST_PP_ARRAY_INSERT(ARRAY, 2, c) // expands to (4, (a, b, c, d))
```
* BOOST_PP_ARRAY_INSERT[link array_insert.md]

