# BOOST_PP_BOOL

`BOOST_PP_BOOL` マクロはオペランドに対しての boolean 変換として機能する。

## Usage

```cpp
BOOST_PP_BOOL(x)
```

## Arguments

- `x` :
	変換される値。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

## Remarks

`x` が `0` ならば、このマクロは `0` に展開される。
そうでなければ、`1` に展開される。

## See Also

- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/logical/bool.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/logical/bool.hpp>

BOOST_PP_BOOL(6) // 1 に展開される
BOOST_PP_BOOL(0) // 0 に展開される
```
* BOOST_PP_BOOL[link bool.md]

