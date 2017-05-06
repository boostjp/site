# BOOST_PP_LESS

`BOOST_PP_LESS` マクロは 2つの値の大きさを比較する。

## Usage

```cpp
BOOST_PP_LESS(x、y)
```

## Arguments

- `x` :
	比較における左オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

- `y` :
	比較における右オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

## Remarks

もし `x` が `y` より小さいならば、このマクロは `1` に展開される。
そうでなければ `0` に展開される。

以前、このマクロは `BOOST_PP_WHILE` の中では使えなかったが、現在ではこのような制限はない。
しかし、そのような状況では `BOOST_PP_LESS_D` を使うほうがより能率的である。

## See Also

- [`BOOST_PP_LESS_D`](less_d.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/comparison/less.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/comparison/less.hpp>

BOOST_PP_LESS(4, 3) // 0 に展開される
BOOST_PP_LESS(3, 4) // 1 に展開される
```
* BOOST_PP_LESS[link less.md]

