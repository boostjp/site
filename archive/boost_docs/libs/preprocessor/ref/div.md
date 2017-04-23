# BOOST_PP_DIV

`BOOST_PP_DIV` マクロは引数の商に展開される。

## Usage

```cpp
BOOST_PP_DIV(x, y)
```

## Arguments

- `x` :
	演算における被除数（分子）。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

- `y` :
	演算における除数（分母）。
	有効な値の範囲は `1` から `BOOST_PP_LIMIT_MAG` まで。

## Remarks

以前、このマクロは `BOOST_PP_WHILE` の中では使えなかったが、現在ではこのような制限はない。
しかし、そのような状況では `BOOST_PP_DIV_D` を用いたほうが効率がよい。

`y` が `0` であった場合、結果は未定義である。

## See Also

- [`BOOST_PP_DIV_D`](div_d.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/arithmetic/div.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/div.hpp>

BOOST_PP_DIV(11, 5) // 2 に展開される
```
* BOOST_PP_DIV[link div.md]

