#BOOST_PP_ARRAY_PUSH_BACK

The `BOOST_PP_ARRAY_PUSH_BACK` macro appends an element to the end of an `array`.

##Usage

```cpp
BOOST_PP_ARRAY_PUSH_BACK(array, elem)
```

##Arguments

- `array` :
	The `array` to append an element to.

- `elem` :
	The element to append.

##Requirements

**Header:** &lt;boost/preprocessor/array/push_back.hpp&gt;

##Sample Code

```cpp
#include <boost/preprocessor/array/push_back.hpp>

#define ARRAY (3, (a, b, c))

BOOST_PP_ARRAY_PUSH_BACK(ARRAY, d) // expands to (4, (a, b, c, d))
```
* BOOST_PP_ARRAY_PUSH_BACK[link array_push_back.md]

