# BOOST_PP_COMPL

`BOOST_PP_COMPL` マクロはオペランドのビット反転（ビット*否定(NOT)*、または補数）として機能する。

## Usage

```cpp
BOOST_PP_COMPL(x)
```

## Arguments

- `x` :
	変換される値。
	この値は `0` か `1` に展開されなければならない。

## Remarks

`x` が `0` ならば、このマクロは `1` に展開される。
`x` が `1` ならば、`0` に展開される。

このマクロはビット*否定(NOT)*（※訳注：原文では OR となっているが間違いであろう）演算を行う前に、それぞれのオペランドを boolean 変換**しない**。
この変換が必要ならば、代わりに `BOOST_PP_NOT` を使用する。

## See Also

- [`BOOST_PP_NOT`](not.md)

## Requirements

Header: &lt;boost/preprocessor/logical/compl.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/logical/compl.hpp>

BOOST_PP_COMPL(1) // 0 に展開される
BOOST_PP_COMPL(0) // 1 に展開される
```
* BOOST_PP_COMPL[link compl.md]

