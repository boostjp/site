# BOOST_PP_DEC

`BOOST_PP_DEC` マクロは引数より 1 小さい数に展開される。

## Usage

```cpp
BOOST_PP_DEC(x)
```

## Arguments

- `x` :
	デクリメントされる値。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

## Remarks

`x` が `0` ならば、結果は**{be saturated to/丸められて/飽和減算として}** `0` となる。

## See Also

- [`BOOST_PP_INC`](inc.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/arithmetic/dec.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/dec.hpp>

BOOST_PP_DEC(BOOST_PP_DEC(6)) // 4 に展開される
BOOST_PP_DEC(0) // 0 に展開される
```
* BOOST_PP_DEC[link dec.md]

