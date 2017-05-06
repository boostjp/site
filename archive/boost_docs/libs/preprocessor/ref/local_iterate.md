# BOOST_PP_LOCAL_ITERATE

`BOOST_PP_LOCAL_ITERATE` マクロは *ローカル反復* を開始する。

## Usage

```cpp
#include BOOST_PP_LOCAL_ITERATE()
```

## Remarks

ユーザ定義マクロ `BOOST_PP_LOCAL_MACRO` は、`BOOST_PP_LOCAL_LIMITS` で指定された範囲の値を伴いこのマクロによって縦に展開される。

## See Also

- [`BOOST_PP_LOCAL_LIMITS`](local_limits.md)
- [`BOOST_PP_LOCAL_MACRO`](local_macro.md)

## Requirements

Header: &lt;boost/preprocessor/iteration/local.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/iteration/local.hpp>

template<int> struct sample;

#define BOOST_PP_LOCAL_MACRO(n) \
	template<> struct sample<n> { \
		enum { value = n }; \
	}; \
	/**/

#define BOOST_PP_LOCAL_LIMITS (1, 5)

#include BOOST_PP_LOCAL_ITERATE()
/* 
template<> struct sample<1> { enum { value = 1 }; };
template<> struct sample<2> { enum { value = 2 }; };
template<> struct sample<3> { enum { value = 3 }; };
template<> struct sample<4> { enum { value = 4 }; };
template<> struct sample<5> { enum { value = 5 }; };
に展開される
*/
```
* BOOST_PP_LOCAL_MACRO[link local_macro.md]
* BOOST_PP_LOCAL_LIMITS[link local_limits.md]
* BOOST_PP_LOCAL_ITERATE[link local_iterate.md]

