# BOOST_PP_OR

`BOOST_PP_OR` マクロは、そのオペランドの論理和 *OR* に展開される。

## Usage

```cpp
BOOST_PP_OR(p, q)
```

## Arguments

- `p` :
	演算における左オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

- `q` :
	演算における右オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

## Remarks

`p` か `q` が非0なら、このマクロは `1` に展開される。
そうでなければ `0` に展開される。

このマクロは論理和 *OR* の演算を行う前に、それぞれのオペランドをブール値に変換する。
もしこの変換が不要なら、代わりに `BOOST_PP_BITOR` を使うこと。

## See Also

- [`BOOST_PP_BITOR`](bitor.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/logical/or.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/logical/or.hpp>

BOOST_PP_OR(4, 3) // expands to 1
BOOST_PP_OR(5, 0) // expands to 1
```
* BOOST_PP_OR[link or.md]

