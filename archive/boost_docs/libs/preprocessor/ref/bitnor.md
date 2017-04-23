# BOOST_PP_BITNOR

`BOOST_PP_BITNOR` マクロはオペランドのビット*否定和(NOR)*に展開される。

## Usage

```cpp
BOOST_PP_BITNOR(x, y)
```

## Arguments

- `x` :
	演算における左オペランド。
	この値は `0` か `1` に展開されなければならない。

- `y` :
	演算における右オペランド。
	この値は `0` か `1` に展開されなければならない。

## Remarks

`x` も `y` も `1` でなければ、このマクロは `1` に展開される。
そうでなければ、`0` に展開される。

このマクロはビット*否定和(NOR)*演算を行う前に、それぞれのオペランドを boolean 変換**しない**。
この変換が必要ならば、代わりに `BOOST_PP_NOR` を使用する。

## See Also

- [`BOOST_PP_NOR`](nor.md)

## Requirements

Header: &lt;boost/preprocessor/logical/bitnor.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/logical/bitnor.hpp>

BOOST_PP_BITNOR(0, 0) // 1 に展開される
BOOST_PP_BITNOR(0, 1) // 0 に展開される
BOOST_PP_BITNOR(1, 0) // 0 に展開される
BOOST_PP_BITNOR(1, 1) // 0 に展開される
```
* BOOST_PP_BITNOR[link bitnor.md]

