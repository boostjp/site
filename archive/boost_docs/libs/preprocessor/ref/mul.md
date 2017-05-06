# BOOST_PP_MUL

`BOOST_PP_MUL` マクロは引数の積に展開される。

## Usage

```cpp
BOOST_PP_MUL(x, y)
```

## Arguments

- `x` :
	演算での被乗数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

- `y` :
	演算での乗数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

## Remarks

もし `x` と `y` の積が `BOOST_PP_LIMIT_MAG` より大きければ、結果は `BOOST_PP_LIMIT_MAG` になる。

以前、このマクロは `BOOST_PP_WHILE` の中で利用することが出来なかった。
この制約は今は存在しない。
しかし、より効率的にするには、そのような状況では `BOOST_PP_MUL_D` を使うこと。

このマクロは `x` が `y` より小さいか等しいときに、最も効率的である。
しかし、この効率を得るためのマクロ呼び出しの前に二つの引数を実際に比較するほどの価値はない。
言い換えれば、 `x` は2つのオペランドのうちより大きい(訳注: 小さい) *可能性が高い* 値にすればよい。

## See Also

- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)
- [`BOOST_PP_MUL_D`](mul_d.md)

## Requirements

Header: &lt;boost/preprocessor/arithmetic/mul.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/mul.hpp>

BOOST_PP_MUL(4, 4) // expands to 16
```
* BOOST_PP_MUL[link mul.md]

