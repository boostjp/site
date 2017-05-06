# BOOST_PP_NOR

`BOOST_PP_NOR` マクロはオペランドを否定論理和 *NOR* に展開する。

## Usage

```cpp
BOOST_PP_NOR(p, q)
```

## Arguments

- `p` :
	演算における左オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

- `q` :
	演算における右オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

## Remarks

`p` と `q` の両方が `0` ならば、このマクロは `1` に展開される。
そうでなければ、 `0` に展開される。

このマクロは否定論理和 `OR` の演算を行う前に、それぞれのオペランドをブール値に変換する。
もしこの変換が不要なら、代わりに `BOOST_PP_BITNOR` を使うこと。

## See Also

- [`BOOST_PP_BITNOR`](bitnor.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/logical/nor.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/logical/nor.hpp>

BOOST_PP_NOR(4, 0) // expands to 0
BOOST_PP_NOR(0, 0) // expands to 1
```
* BOOST_PP_NOR[link nor.md]

