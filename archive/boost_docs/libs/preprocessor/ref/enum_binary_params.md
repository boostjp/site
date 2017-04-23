# BOOST_PP_ENUM_BINARY_PARAMS

`BOOST_PP_ENUM_BINARY_PARAMS` マクロはコンマで区切られた二項パラメータリストを生成する。

## Usage

```cpp
BOOST_PP_ENUM_BINARY_PARAMS(count, p1, p2)
```

## Arguments

- `count` :
	生成するパラメータの個数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_REPEAT` まで。

- `p1` :
	パラメータの第一部分のテキスト部。
	`BOOST_PP_ENUM_BINARY_PARAMS` は生成したパラメータと `0` から `count - 1` までの範囲の数字とを結合する。

- `p2` :
	パラメータの第二（※訳注：原文では first。間違いか）部分のテキスト部。
	`BOOST_PP_ENUM_BINARY_PARAMS` は生成したパラメータと `0` から `count - 1` までの範囲の数字とを結合する。

## Remarks

このマクロはコンマ区切りのシーケンスに展開される:

```cpp
p1 ## 0 p2 ## 0, p1 ## 1 p2 ## 1, ... p1 ## count - 1 p2 ## count - 1
```

`BOOST_PP_REPEAT` を使った他のマクロから渡されたパラメータ `z` の値を使うためには、`BOOST_PP_ENUM_BINARY_PARAMS_Z` を見よ。

このマクロは `BOOST_PP_ENUM_PARAMS_WITH_A_DEFAULT` と `BOOST_PP_ENUM_PARAMS_WITH_DEFAULTS` の代わりとなる。

## See Also

- [`BOOST_PP_ENUM_BINARY_PARAMS_Z`](enum_binary_params_z.md)
- [`BOOST_PP_ENUM_PARAMS_WITH_A_DEFAULT`](enum_params_with_a_default.md)
- [`BOOST_PP_ENUM_PARAMS_WITH_DEFAULTS`](enum_params_with_defaults.md)
- [`BOOST_PP_LIMIT_REPEAT`](limit_repeat.md)

## Requirements

Header: &lt;boost/preprocessor/repetition/enum_binary_params.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/repetition/enum_binary_params.hpp>

BOOST_PP_ENUM_BINARY_PARAMS(3, T, p) // T0 p0, T1 p1, T2 p2 に展開される
```
* BOOST_PP_ENUM_BINARY_PARAMS[link enum_binary_params.md]

