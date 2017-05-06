# BOOST_PP_LOCAL_LIMITS

`BOOST_PP_LOCAL_LIMITS` マクロは `BOOST_PP_LOCAL_ITERATE` によって使用されるユーザ定義 *名前付き外部引数* である。

## Usage

```cpp
#define BOOST_PP_LOCAL_LIMITS (start, finish)
```

## Arguments

- `start` :
	*ローカル反復* の（包括的な）下限。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_ITERATION` まで。

- `finish` :
	*ローカル反復* の（包括的な）上限。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_ITERATION` まで。

## Remarks

余白文字がマクロ識別子の後にあることに注意せよ。

このマクロは `2` 要素 *タプル* に展開されなければならない。
この *タプル* の要素は *ローカル反復* の下限と上限を表わす。
`start` も `finish` も両方とも *評価済みパラメータ* である。
これは単純な（`1 + 3` のような）算術式などを含むことができることを意味する。

This macro is automatically undefined for reuse by a call to `BOOST_PP_LOCAL_ITERATE`.

## See Also

- [`BOOST_PP_LIMIT_ITERATION`](limit_iteration.md)
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

