# BOOST_PP_ENUM_TRAILING_BINARY_PARAMS_Z

`BOOST_PP_ENUM_TRAILING_BINARY_PARAMS_Z` マクロはコンマの先行した、コンマで区切られた二項パラメータリストを生成する。
これは `BOOST_PP_REPEAT` に最も効率よく再入する。

## Usage

```cpp
BOOST_PP_ENUM_TRAILING_BINARY_PARAMS_Z(z, count, p1, p2)
```

## Arguments

- `z` :
	利用可能な次の `BOOST_PP_REPEAT` の次元。

- `count` :
	生成するパラメータの数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_REPEAT` まで。

- `p1` :
	パラメータの第一部分のテキスト部。
	`BOOST_PP_ENUM_TRAILING_BINARY_PARAMS_Z` は生成したパラメータと `0` から `count - 1` までの範囲の数字とを結合する。

- `p2` :
	パラメータの第二（※訳注：原文では first。間違いか）部分のテキスト部。
	`BOOST_PP_ENUM_TRAILING_BINARY_PARAMS_Z` は生成したパラメータと `0` から `count - 1` までの範囲の数字とを結合する。

## Remarks

このマクロはコンマ区切りのシーケンスに展開される:

```cpp
, p1 ## 0 p2 ## 0, p1 ## 1 p2 ## 1, ... p1 ## count - 1 p2 ## count - 1
```

## See Also

- [`BOOST_PP_ENUM_TRAILING_BINARY_PARAMS`](enum_trailing_binary_params.md)
- [`BOOST_PP_LIMIT_REPEAT`](limit_repeat.md)

## Requirements

Header: &lt;boost/preprocessor/repetition/enum_trailing_binary_params.hpp&gt;

