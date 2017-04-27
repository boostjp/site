# BOOST_PP_INC

`BOOST_PP_INC` マクロはその引数より 1 大きな値に展開される。

## Usage

```cpp
BOOST_PP_INC(x)
```

## Arguments

- `x` :
	インクリメントされる値。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

## Remarks

もし `x` が `BOOST_PP_LIMIT_MAG` なら、結果は `BOOST_PP_LIMIT_MAG` である。

## See Also

- [`BOOST_PP_DEC`](dec.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/arithmetic/inc.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/inc.hpp>

BOOST_PP_INC(BOOST_PP_INC(6)) // expands to 8
BOOST_PP_INC(4) // expands to 5
```
* BOOST_PP_INC[link inc.md]

