#BOOST_PP_ARRAY_REVERSE

The `BOOST_PP_ARRAY_REVERSE` macro reverses the elements in an `array`.

##Usage

```cpp
BOOST_PP_ARRAY_REVERSE(array)
```

##Arguments

- `array` :
	The `array` whose elements are to be reversed.

##Requirements

Header: &lt;boost/preprocessor/array/reverse.hpp&gt;

##Sample Code

```cpp
#include <boost/preprocessor/array/reverse.hpp>

#define ARRAY (3, (a, b, c))

BOOST_PP_ARRAY_REVERSE(ARRAY) // expands to (3, (c, b, a))
```
* BOOST_PP_ARRAY_REVERSE[link array_reverse.md]

