#BOOST_PP_ARRAY_REMOVE

The `BOOST_PP_ARRAY_REMOVE` macro removes an element from an `array`.

##Usage

```cpp
BOOST_PP_ARRAY_REMOVE(array, i)
```

##Arguments

- `array` :
	The `array` from which an element is to be removed.

- `i` :
	The zero-based position in `array` of the element to be removed.
	Valid values range from `0` to `BOOST_PP_ARRAY_SIZE(array) - 1`.

##Remarks

This macro uses `BOOST_PP_WHILE` interally.
Therefore, to use the `d` parameter passed from other macros that use `BOOST_PP_WHILE`, see `BOOST_PP_ARRAY_REMOVE_D`.

##See Also

- [`BOOST_PP_ARRAY_REMOVE_D`](array_remove_d.md)

##Requirements

**Header:** &lt;boost/preprocessor/array/remove.hpp&gt;

##Sample Code

```cpp
#include <boost/preprocessor/array/remove.hpp>

#define ARRAY (3, (a, b, d))

BOOST_PP_ARRAY_REMOVE(ARRAY, 2) // expands to (2, (a, b))
```
* BOOST_PP_ARRAY_REMOVE[link array_remove.md]

