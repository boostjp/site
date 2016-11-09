#BOOST_PP_ARRAY_POP_BACK

The `BOOST_PP_ARRAY_POP_BACK` macro pops an element from the end of an `array`.

##Usage

```cpp
BOOST_PP_ARRAY_POP_BACK(array)
```

##Arguments##

- `array` :
	The `array` to pop an element from.

##Remarks

This macro returns `array` after removing the last element.
If `array` has no elements, the result of applying this macro is undefined.

This macro uses `BOOST_PP_REPEAT` internally.
Therefore, to use the `z` parameter passed from other macros that use `BOOST_PP_REPEAT`, see `BOOST_PP_ARRAY_POP_BACK_Z`.

##See Also

- [`BOOST_PP_ARRAY_POP_BACK_Z`](array_pop_back_z.md)

##Requirements

**Header:** &lt;boost/preprocessor/array/pop_back.hpp&gt;

##Sample Code

```cpp
#include <boost/preprocessor/array/pop_back.hpp>

#define ARRAY (3, (a, b, c))

BOOST_PP_ARRAY_POP_BACK(ARRAY) // expands to (2, (a, b))
```
* BOOST_PP_ARRAY_POP_BACK[link array_pop_back.md]

