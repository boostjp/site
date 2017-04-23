# BOOST_PP_CAT

`BOOST_PP_CAT` マクロは、引数を展開した後結合する。

## Usage

```cpp
BOOST_PP_CAT(a, b)
```

## Arguments

- `a` :
	結合における左オペランド。

- `b` :
	結合における右オペランド。

## Remarks

プリプロセッサのトークン貼り付け演算子(`##`)はそれぞれの引数の展開を妨害する。
このマクロは結合前に引数が展開されることを可能にする。

`BOOST_PP_CAT` を使っているマクロの実行中に結合（※訳注：`BOOST_PP_CAT` のこと）が生成されてはならない。
もしそうなると、二回目の `BOOST_PP_CAT` は展開されないだろう。

## Requirements

Header: &lt;boost/preprocessor/cat.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/cat.hpp>

BOOST_PP_CAT(x, BOOST_PP_CAT(y, z)) // xyz に展開される
```
* BOOST_PP_CAT[link cat.md]

