# BOOST_PP_ENUM_BINARY_PARAMS_Z

`BOOST_PP_ENUM_BINARY_PARAMS_Z` マクロはコンマで区切られた二項パラメータリストを生成する。
これは `BOOST_PP_REPEAT` に最も効率よく再入する。

## Usage

```cpp
BOOST_PP_ENUM_BINARY_PARAMS_Z(z, count, p1, p2)
```

## Arguments

- `z` :
	利用可能な次の `BOOST_PP_REPEAT` の次元。

- `count` :
	生成するパラメータの数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_REPEAT` まで。

- `p1` :
	パラメータの第一部分のテキスト部。
	`BOOST_PP_ENUM_BINARY_PARAMS_Z`（※訳注：原文では `BOOST_PP_ENUM_BINARY_PARAMS`。間違いか）は生成したパラメータと `0` から `count - 1` までの範囲の数字とを結合する。

- `p2` :
	パラメータの第二（※訳注：原文では first。間違いか）部分のテキスト部。
	`BOOST_PP_ENUM_BINARY_PARAMS_Z`（※訳注：原文では `BOOST_PP_ENUM_BINARY_PARAMS`。間違いか） は生成したパラメータと `0` から `count - 1` までの範囲の数字とを結合する。

## Remarks

このマクロはコンマ区切りのシーケンスに展開される:

```cpp
p1 ## 0 p2 ## 0, p1 ## 1 p2 ## 1, ... p1 ## count - 1 p2 ## count - 1
```

このマクロは `BOOST_PP_ENUM_PARAMS_WITH_A_DEFAULT` と `BOOST_PP_ENUM_PARAMS_WITH_DEFAULTS` の代わりとなる。

## See Also

- [`BOOST_PP_ENUM_BINARY_PARAMS`](enum_binary_params.md)
- [`BOOST_PP_ENUM_PARAMS_WITH_A_DEFAULT`](enum_params_with_a_default.md)
- [`BOOST_PP_ENUM_PARAMS_WITH_DEFAULTS`](enum_params_with_defaults.md)
- [`BOOST_PP_LIMIT_REPEAT`](limit_repeat.md)

## Requirements

Header: &lt;boost/preprocessor/repetition/enum_binary_params.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/inc.hpp>
#include <boost/preprocessor/repetition/enum_binary_params.hpp>
#include <boost/preprocessor/repetition/enum_params.hpp>

#define FUNCTION(z, n, _) \
	template<BOOST_PP_ENUM_PARAMS_Z(z, BOOST_PP_INC(n), class T)> \
	void f(BOOST_PP_ENUM_BINARY_PARAMS_Z(z, BOOST_PP_INC(n), T, p)) { \
		/* ... */ \
	} \
	/**/

BOOST_PP_REPEAT(2, FUNCTION, nil)
/*
	template<class T0> void f(T0 p0) { }
	template<class T0, class T1> void f(T0 p0, T1 p1) { }
	に展開される
*/
```
* BOOST_PP_ENUM_PARAMS_Z[link enum_params_z.md]
* BOOST_PP_INC[link inc.md]
* BOOST_PP_ENUM_BINARY_PARAMS_Z[link enum_binary_params_z.md]
* BOOST_PP_INC[link inc.md]
* BOOST_PP_REPEAT[link repeat.md]

