# BOOST_PP_BITXOR

`BOOST_PP_BITXOR` マクロはオペランドのビット*排他的和(XOR)*に展開される。

## Usage

```cpp
BOOST_PP_BITXOR(x, y)
```

## Arguments

- `x` :
	演算における左オペランド。
	この値は `0` か `1` に展開されなければならない。

- `y` :
	演算における右オペランド。
	この値は `0` か `1` に展開されなければならない。

## Remarks

`x` か `y` のどちらか片方のみが `1` であれば、このマクロは `1` に展開される。
そうでなければ、`0` に展開される。

このマクロはビット*排他的和(XOR)*（※訳注：原文では OR となっていたが間違いであろう）演算を行う前に、それぞれのオペランドを boolean 変換**しない**。
この変換が必要ならば、代わりに `BOOST_PP_XOR` を使用する。

## See Also

- [`BOOST_PP_XOR`](xor.md)

## Requirements

Header: &lt;boost/preprocessor/logical/bitxor.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/logical/bitxor.hpp>

BOOST_PP_BITXOR(0, 0) // 0 に展開される
BOOST_PP_BITXOR(0, 1) // 1 に展開される
BOOST_PP_BITXOR(1, 0) // 1 に展開される
BOOST_PP_BITXOR(1, 1) // 0 に展開される
```
* BOOST_PP_BITXOR[link bitxor.md]

