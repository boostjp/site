# BOOST_PP_LOCAL_MACRO

`BOOST_PP_LOCAL_MACRO` マクロは `BOOST_PP_LOCAL_ITERATE` によって使用されるユーザ定義 *名前付き外部引数* である。

## Usage

```cpp
#define BOOST_PP_LOCAL_MACRO(n) ...
```

## Arguments

- `n` :
	*ローカル反復* メカニズムから受け取った現在の反復値。

## Remarks

このマクロは自動的に再利用のために `BOOST_PP_LOCAL_ITERATE` 呼び出しによって未定義にされる。

## See Also

- [`BOOST_PP_LOCAL_ITERATE`](local_iterate.md)

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

