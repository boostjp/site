# BOOST_PP_ARRAY_REPLACE

The `BOOST_PP_ARRAY_REPLACE` macro replaces an element in an `array`.

## Usage

```cpp
BOOST_PP_ARRAY_REPLACE(array, i, elem)
```

## Arguments

- `array` :
	An `array` to replace an element in.

- `i` :
	The zero-based position in `array` of the element to be replaced.
	Valid values range from `0` to `BOOST_PP_ARRAY_SIZE(array) - 1`.

- `elem` :
	The replacement element.

## Remarks

This macro uses `BOOST_PP_WHILE` interally.
Therefore, to use the `d` parameter passed from other macros that use `BOOST_PP_WHILE`, see `BOOST_PP_ARRAY_REPLACE_D`.

## See Also

- [`BOOST_PP_ARRAY_REPLACE_D`](array_replace_d.md)

## Requirements

**Header:** &lt;boost/preprocessor/array/replace.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/array/replace.hpp>

# define ARRAY (3, (a, x, c))

BOOST_PP_ARRAY_REPLACE(ARRAY, 1, b) // expands to (3, (a, b, c))
```
* BOOST_PP_ARRAY_REPLACE[link array_replace.md]

