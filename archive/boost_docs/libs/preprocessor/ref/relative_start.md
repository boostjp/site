# BOOST_PP_RELATIVE_START

`BOOST_PP_RELATIVE_FINISH` マクロは *ファイル繰り返し* の現在の深さと相対的なの深さの下限に展開される。

## Usage

```cpp
BOOST_PP_RELATIVE_START(i)
```

## Arguments

- `i` :
	その下限が検索されるフレームの相対的な深さ。
	有効な値の範囲は `0` から `BOOST_PP_ITERATION_DEPTH() - 1` までである。

## Remarks

このマクロは *ファイル繰り返し* が進行中の時のみ有効である。

引数 `i` は現在のフレームより *外側の* フレームの数として解釈される。

## Requirements

Header: &lt;boost/preprocessor/iteration/iterate.hpp&gt;

