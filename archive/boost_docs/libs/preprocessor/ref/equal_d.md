# BOOST_PP_EQUAL_D

`BOOST_PP_EQUAL_D` マクロは 2つの値が等しいかどうか比較する。

## Usage

```cpp
BOOST_PP_EQUAL_D(d, x, y)
```

## Arguments

- `d` :
	この引数は無視される。

- `x` :
	比較における左オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

- `y` :
	比較における右オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

## Remarks

もし `x` が `y` と等しいならば、このマクロは `1` に展開される。
そうでなければ `0` に展開される。

このマクロは廃止された。
これは下位互換性のためだけに存在する。
`BOOST_PP_EQUAL` を代わりに使うべきだ。

## See Also

- [`BOOST_PP_EQUAL`](equal.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/comparison/equal.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/comparison/equal.hpp>

BOOST_PP_EQUAL_D(1, 4, 3) // 0 に展開される
BOOST_PP_EQUAL_D(1, 5, 5) // 1 に展開される
```
* BOOST_PP_EQUAL_D[link equal_d.md]

