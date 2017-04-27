# BOOST_PP_GREATER

`BOOST_PP_GREATER` マクロは2つの値の大きさを比較する。

## Usage

```cpp
BOOST_PP_GREATER(x, y)
```

## Arguments

- `x` :
	比較における左オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

- `y` :
	比較における右オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

## Remarks

もし `x` が `y` より大きければ、このマクロは `1` に展開される。
そうでなければ、 `0` に展開される。

以前、このマクロは `BOOST_PP_WHILE` の中で使うことは出来なかった。
今はこの制限はない。
しかし、より効率的にするには、そのような状況では `BOOST_PP_GREATER_D` を使うこと。

## See Also

- [`BOOST_PP_GREATER_D`](greater_d.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/comparison/greater.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/comparison/greater.hpp>

BOOST_PP_GREATER(4, 3) // expands to 1
BOOST_PP_GREATER(5, 5) // expands to 0
```
* BOOST_PP_GREATER[link greater.md]

