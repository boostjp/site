# BOOST_PP_BITOR

`BOOST_PP_BITOR` マクロはオペランドのビット*和(OR)*に展開される。

## Usage

```cpp
BOOST_PP_BITOR(x, y)
```

## Arguments

- `x` :
	演算における左オペランド。
	この値は `0` か `1` に展開されなければならない。

- `y` :
	演算における右オペランド。
	この値は `0` か `1` に展開されなければならない。

## Remarks

`x` か `y` のどちらか片方でも `1` であれば、このマクロは `1` に展開される。
そうでなければ、`0` に展開される。

このマクロはビット*和(OR)*演算を行う前に、それぞれのオペランドを boolean 変換**しない**。
この変換が必要ならば、代わりに `BOOST_PP_OR` を使用する。

## See Also

- [`BOOST_PP_OR`](or.md)

## Requirements

Header: &lt;boost/preprocessor/logical/bitor.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/logical/bitor.hpp>

BOOST_PP_BITOR(0, 0) // 0 に展開される
BOOST_PP_BITOR(0, 1) // 1 に展開される
BOOST_PP_BITOR(1, 0) // 1 に展開される
BOOST_PP_BITOR(1, 1) // 1 に展開される
```
* BOOST_PP_BITOR[link bitor.md]

