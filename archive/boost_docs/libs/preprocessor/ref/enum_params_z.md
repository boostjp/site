# BOOST_PP_ENUM_PARAMS_Z

`BOOST_PP_ENUM_PARAMS_Z` マクロはコンマで区切られたパラメータリストを生成する。
これは `BOOST_PP_REPEAT` に最も効率よく再入する。

## Usage

```cpp
BOOST_PP_ENUM_PARAMS_Z(z, count, param)
```

## Arguments

- `z` :
	利用可能な次の `BOOST_PP_REPEAT` の次元。

- `count` :
	生成するパラメータの個数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_REPEAT` まで。

- `param` :
	パラメータのテキスト部。
	`BOOST_PP_ENUM_PARAMS_Z` は生成したパラメータと `0` から `count - 1` までの範囲の数字とを結合する。

## Remarks

このマクロはコンマ区切りのシーケンスに展開される:

```cpp
param ## 0, param ## 1, ... param ## count - 1
```

## See Also

- [`BOOST_PP_ENUM_PARAMS`](enum_params.md)
- [`BOOST_PP_LIMIT_REPEAT`](limit_repeat.md)

## Requirements

Header: &lt;boost/preprocessor/repetition/enum_params.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/inc.hpp>
#include <boost/preprocessor/repetition/enum_params.hpp>
#include <boost/preprocessor/repetition/repeat.hpp>

#define MACRO(z, n, _) \
	template< \
		BOOST_PP_ENUM_PARAMS_Z(z, BOOST_PP_INC(n), class T) \
	> class X ## n { \
		/* ... */ \
	}; \
	/**/

BOOST_PP_REPEAT(2, MACRO, nil)
/*
	template<class T0> class X0 { };
	template<class T0, class T1> class X1 { };
	に展開される
*/
```
* BOOST_PP_ENUM_PARAMS_Z[link enum_params_z.md]
* BOOST_PP_INC[link inc.md]
* BOOST_PP_REPEAT[link repeat.md]

