# BOOST_PP_ARRAY_PUSH_FRONT

The `BOOST_PP_ARRAY_PUSH_FRONT` macro appends an element to the beginning of an `array`.

## Usage

```cpp
BOOST_PP_ARRAY_PUSH_FRONT(array, elem)
```

## Arguments

- `array` :
	The `array` to append an element to.

- `elem` :
	The element to append.

## Requirements

**Header:** &lt;boost/preprocessor/array/push_front.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/array/push_front.hpp>

# define ARRAY (3, (b, c, d))

BOOST_PP_ARRAY_PUSH_FRONT(ARRAY, a) // expands to (4, (a, b, c, d))
```
* BOOST_PP_ARRAY_PUSH_FRONT[link array_push_front.md]

