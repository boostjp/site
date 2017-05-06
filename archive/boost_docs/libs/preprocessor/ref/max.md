# BOOST_PP_MAX

`BOOST_PP_MAX` マクロは二つの引数のうち大きい方に展開される。

## Usage

```cpp
BOOST_PP_MAX(x, y)
```

## Arguments

- `x` :
	第1のオペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

- `y` :
	第2のオペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

## Remarks

このマクロは二つの引数のうち大きい方を、または両方が等しければその値を返す。

以前、このマクロは `BOOST_PP_WHILE` の中で利用することが出来なかった。
この制約は今は存在しない。
しかし、より効率的にするには、そのような状況では `BOOST_PP_MAX_D` を使うこと。

## See Also

- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)
- [`BOOST_PP_MAX_D`](max_d.md)

## Requirements

Header: &lt;boost/preprocessor/selection/max.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/selection/max.hpp>

BOOST_PP_MAX(5, 7) // expands to 7
BOOST_PP_MAX(3, 3) // expands to 3
```
* BOOST_PP_MAX[link max.md]

