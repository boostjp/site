# BOOST_PP_EQUAL

`BOOST_PP_EQUAL` マクロは 2つの値が等しいかどうか比較する。

## Usage

```cpp
BOOST_PP_EQUAL(x, y)
```

## Arguments

- `x` :
	比較における左オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

- `y` :
	比較における右オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

## Remarks

もし `x` が `y` と等しいならば、このマクロは `1` に展開される。
そうでなければ `0` に展開される。

以前、このマクロは `BOOST_PP_WHILE` の中では使えなかったが、このマクロはもはや `BOOST_PP_WHILE` を使わないので、このような制限はない。

## See Also

- [`BOOST_PP_EQUAL_D`](equal_d.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

`Header:` &lt;boost/preprocessor/comparison/equal.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/comparison/equal.hpp>

BOOST_PP_EQUAL(4, 3) // 0 に展開される
BOOST_PP_EQUAL(5, 5) // 1 に展開される
```
* BOOST_PP_EQUAL[link equal.md]

