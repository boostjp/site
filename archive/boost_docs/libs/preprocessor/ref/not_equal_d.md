# BOOST_PP_NOT_EQUAL_D

`BOOST_PP_NOT_EQUAL` マクロは二つの値の非等価性を比較する。

## Usage

```cpp
BOOST_PP_NOT_EQUAL_D(d, x, y)
```

## Arguments

- `d` :
	この引数は無視される。

- `x` :
	比較における左オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

- `q` :
	比較における右オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

## Remarks

もし `x` と `y` が等しければ、このマクロは `0` に展開される。
そうでなければ、`1` に展開される。

このマクロは推奨されていない。
過去のバージョンとの互換性のためだけに存在する。
代わりに `BOOST_PP_NOT_EQUAL` を使うこと。

## See Also

- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)
- [`BOOST_PP_NOT_EQUAL`](not_equal.md)

## Requirements

Header: &lt;boost/preprocessor/comparison/not_equal.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/comparison/equal.hpp>

BOOST_PP_NOT_EQUAL_D(1, 4, 3) // expands to 1
BOOST_PP_NOT_EQUAL_D(1, 5, 5) // expands to 0
```
* BOOST_PP_NOT_EQUAL_D[link not_equal_d.md]

