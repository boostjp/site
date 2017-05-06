# BOOST_PP_XOR

`BOOST_PP_XOR` マクロはオペランドの論理的排他和 *XOR* に展開される。

## Usage

```cpp
BOOST_PP_XOR(p, q)
```

## Arguments

- `p` :
	演算における左オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

- `q` :
	演算における右オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

## Remarks

もし `p` か `q` が排他的に非 0 ならば、このマクロは `1` に展開される。
そうでなければ `0` に展開される。

このマクロは論理的排他和 *XOR* 演算を行う前に、それぞれのオペランドをブーリアンに変換する。
もしこの変換が不要なら、代わりに `BOOST_PP_BITXOR` を使うこと。

## See Also

- [`BOOST_PP_BITXOR`](bitxor.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/logical/xor.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/logical/xor.hpp>

BOOST_PP_XOR(4, 3) // expands to 0
BOOST_PP_XOR(5, 0) // expands to 1
```
* BOOST_PP_XOR[link xor.md]

