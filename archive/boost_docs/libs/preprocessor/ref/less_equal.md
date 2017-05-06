# BOOST_PP_LESS_EQUAL

`BOOST_PP_LESS_EQUAL` マクロは 2つの値の同等または大きさを比較する。

## Usage

```cpp
BOOST_PP_LESS_EQUAL(x, y)
```

## Arguments

- `x` :
	比較における左オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

- `y` :
	比較における右オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

## Remarks

もし `x` が `y` より小さいか等しいならば、このマクロは `1` に展開される。
そうでなければ `0` に展開される。

以前、このマクロは `BOOST_PPWHILE` の中では使えなかったが、現在ではこのような制限はない。
しかし、そのような状況では `BOOST_PP_LESS_D` を使うほうがより能率的である。

## See Also

- [`BOOST_PP_LESS_EQUAL_D`](less_equal_d.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/comparison/less_equal.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/comparison/less_equal.hpp>

BOOST_PP_LESS_EQUAL(4, 3) // 0 に展開される
BOOST_PP_LESS_EQUAL(5, 5) // 1 に展開される
```
* BOOST_PP_LESS_EQUAL[link less_equal.md]

