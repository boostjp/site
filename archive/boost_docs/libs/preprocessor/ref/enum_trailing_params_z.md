# BOOST_PP_ENUM_TRAILING_PARAMS_Z

`BOOST_PP_ENUM_TRAILING_PARAMS_Z` マクロはコンマの先行した、コンマで区切られたパラメータリストを生成する。
これは `BOOST_PP_REPEAT` に最も効率よく再入する。

## Usage

```cpp
BOOST_PP_ENUM_TRAILING_PARAMS_Z(z, count, param)
```

## Arguments

- `z` :
	利用可能な次の `BOOST_PP_REPEAT` の次元。

- `count` :
	生成するパラメータの個数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_REPEAT` まで。

- `param` :
	パラメータのテキスト部。
	`BOOST_PP_ENUM_TRAILING_PARAMS_Z` は生成したパラメータと `0` から `count - 1` までの範囲の数字とを結合する。

## Remarks

このマクロはコンマ区切りのシーケンスに展開される:

```cpp
, param ## 0, param ## 1, ... param ## count - 1
```

## See Also

- [`BOOST_PP_ENUM_TRAILING_PARAMS`](enum_trailing_params.md)
- [`BOOST_PP_LIMIT_REPEAT`](limit_repeat.md)

## Requirements

Header: &lt;boost/preprocessor/repetition/enum_trailing_params.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/repetition/enum_trailing_params.hpp>
#include <boost/preprocessor/repetition/repeat.hpp>

#define MACRO(z, n, _) \
	template< \
		class BOOST_PP_ENUM_TRAILING_PARAMS_Z(z, n, class T) \
	> class X ## n { \
		/* ... */ \
	}; \
	/**/

BOOST_PP_REPEAT(2, MACRO, nil)
/*
	template<class> class X0 { };
	<class, class T0> class X1 { };
	に展開される
*/
```
* BOOST_PP_ENUM_TRAILING_PARAMS_Z[link enum_trailing_params_z.md]
* BOOST_PP_REPEAT[link repeat.md]

