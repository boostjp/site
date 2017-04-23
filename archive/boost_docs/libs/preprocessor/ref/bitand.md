# BOOST_PP_BITAND

`BOOST_PP_BITAND` マクロはオペランドのビット*積(AND)*に展開される。

## Usage

```cpp
BOOST_PP_BITAND(x, y)
```

## Arguments

- `x` :
	演算における左オペランド。
	この値は `0` か `1` に展開されなければならない。

- `y` :
	演算における右オペランド。
	この値は `0` か `1` に展開されなければならない。

## Remarks

`x` と `y` が共に `1` ならば、このマクロは `1` に展開される。
そうでなければ、`0` に展開される。

このマクロはビット*積(AND)*演算を行う前に、それぞれのオペランドを boolean 変換**しない**。
この変換が必要ならば、代わりに `BOOST_PP_AND` を使用する。

## See Also

- [`BOOST_PP_AND`](and.md)

## Requirements

Header: &lt;boost/preprocessor/logical/bitand.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/logical/bitand.hpp>

BOOST_PP_BITAND(0, 0) // 0 に展開される
BOOST_PP_BITAND(0, 1) // 0 に展開される
BOOST_PP_BITAND(1, 0) // 0 に展開される
BOOST_PP_BITAND(1, 1) // 1 に展開される
```
* BOOST_PP_BITAND[link bitand.md]

