# BOOST_PP_MIN

`BOOST_PP_MIN` マクロは二つの引数のうち小さい方に展開される。

## Usage

```cpp
BOOST_PP_MIN(x, y)
```

## Arguments

- `x` :
	第1のオペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

- `y` :
	第2のオペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

## Remarks

このマクロは二つの引数のうち小さい方を、または両方が等しければその値を返す。

以前、このマクロは `BOOST_PP_WHILE` の中で利用することが出来なかった。
この制約は今は存在しない。
しかし、より効率的にするには、そのような状況では `BOOST_PP_MIN_D` を使うこと。

## See Also

- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)
- [`BOOST_PP_MIN_D`](min_d.md)

## Requirements

Header: &lt;boost/preprocessor/selection/min.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/selection/min.hpp>

BOOST_PP_MIN(5, 7) // expands to 5
BOOST_PP_MIN(3, 3) // expands to 3
```
* BOOST_PP_MIN[link min.md]

