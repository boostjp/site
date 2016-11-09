#BOOST_PP_ARRAY_POP_FRONT_Z

The `BOOST_PP_ARRAY_POP_FRONT_Z` macro pops an element from the beginning of an `array`.
It reenters `BOOST_PP_REPEAT` with maximum efficiency.

##Usage

```cpp
BOOST_PP_ARRAY_POP_FRONT_Z(z, array)
```

##Arguments

- `z` :
	The next available `BOOST_PP_REPEAT` dimension.

- `array` :
	The `array` to pop an element from.

##Remarks

This macro returns `array` after removing the first element.
If `array` has no elements, the result of applying this macro is undefined.

##See Also

- [`BOOST_PP_ARRAY_POP_FRONT`](array_pop_front.md)

##Requirements

**Header:** &lt;boost/preprocessor/array/pop_front.hpp&gt;

