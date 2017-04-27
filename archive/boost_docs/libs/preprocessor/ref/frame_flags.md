# BOOST_PP_FRAME_FLAGS

`BOOST_PP_FRAME_FLAGS` マクロは *ファイル繰り返し* の絶対的な深さに関連するフラグに展開される。

## Usage

```cpp
BOOST_PP_FRAME_FLAGS(i)
```

## Arguments

- `i` :
	フラグが検索されるフレームの絶対的深さ。
	有効な値の範囲は `1` から `BOOST_PP_ITERATION_DEPTH()` までである。

## Remarks

このマクロは *ファイル繰り返し* が進行中の時のみ有効である。

## Requirements

Header: &lt;boost/preprocessor/iteration/iterate.hpp&gt;

