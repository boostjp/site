# BOOST_PP_NOT_EQUAL

`BOOST_PP_NOT_EQUAL` マクロは二つの値の非等価性を比較する。

## Usage

```cpp
BOOST_PP_NOT_EQUAL(x, y)
```

## Arguments

- `x` :
	比較における左オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

- `q` :
	比較における右オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

## Remarks

もし `x` と `y` が等しければ、このマクロは `0` に展開される。
そうでなければ、`1` に展開される。

以前、このマクロは `BOOST_PP_WHILE` の中で利用することは出来なかった。
この制限はもう存在しない。
なぜならこのマクロはもう、 `BOOST_PP_WHILE` を使っていないからである。

## See Also

- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)
- [`BOOST_PP_NOT_EQUAL_D`](not_equal_d.md)

## Requirements

Header: &lt;boost/preprocessor/comparison/not_equal.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/comparison/not_equal.hpp>

BOOST_PP_NOT_EQUAL(4, 3) // expands to 1
BOOST_PP_NOT_EQUAL(5, 5) // expands to 0
```
* BOOST_PP_NOT_EQUAL[link not_equal.md]

