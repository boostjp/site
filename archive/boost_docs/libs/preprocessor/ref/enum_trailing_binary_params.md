# BOOST_PP_ENUM_TRAILING_BINARY_PARAMS

`BOOST_PP_ENUM_TRAILING_BINARY_PARAMS` マクロはコンマの先行した、コンマで区切られた二項パラメータリストを生成する。

## Usage

```cpp
BOOST_PP_ENUM_TRAILING_BINARY_PARAMS(count, p1, p2)
```

## Arguments

- `count` :
	生成するパラメータの個数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_REPEAT` まで。

- `p1` :
	パラメータの第一部分のテキスト部。
	`BOOST_PP_ENUM_TRAILING_BINARY_PARAMS` は生成したパラメータと `0` から `count - 1` までの範囲の数字とを結合する。

- `p2` :
	パラメータの第二（※訳注：原文では first。間違いか）部分のテキスト部。
	`BOOST_PP_ENUM_TRAILING_BINARY_PARAMS` は生成したパラメータと `0` から `count - 1` までの範囲の数字とを結合する。

## Remarks

このマクロはコンマ区切りのシーケンスに展開される:

```cpp
, p1 ## 0 p2 ## 0, p1 ## 1 p2 ## 1, ... p1 ## count - 1 p2 ## count - 1
```

To use the `z` parameter passed from other macros that use `BOOST_PP_REPEAT`, see `BOOST_PP_ENUM_TRAILING_BINARY_PARAMS_Z`.

## See Also

- [`BOOST_PP_ENUM_TRAILING_BINARY_PARAMS_Z`](enum_trailing_binary_params_z.md)
- [`BOOST_PP_LIMIT_REPEAT`](limit_repeat.md)

## Requirements

Header: &lt;boost/preprocessor/repetition/enum_trailing_binary_params.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/facilities/intercept.hpp>
#include <boost/preprocessor/repetition/enum_trailing_binary_params.hpp>

template<class X BOOST_PP_ENUM_TRAILING_BINARY_PARAMS(4, class A, = X BOOST_PP_INTERCEPT)>
struct sample {
	// ...
};

/*
	template<class X, class A0 = X, class A1 = X, class A2 = X, class A3 = X>
	sample {
		// ...
	}
	に展開される
*/
```
* BOOST_PP_ENUM_TRAILING_BINARY_PARAMS[link enum_trailing_binary_params.md]
* BOOST_PP_INTERCEPT[link intercept.md]

