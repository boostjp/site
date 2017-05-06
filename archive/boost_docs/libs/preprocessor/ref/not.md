# BOOST_PP_NOT

`BOOST_PP_NOT` マクロはオペランドの論理否定 *NOT* を行う。

## Usage

```cpp
BOOST_PP_NOT(x)
```

## Arguments

- `x` :
	変換される値。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

## Remarks

`x` が非0なら、このマクロは `1` に展開される。

そうでなければ、`0` に展開される。

このマクロは論理否定 `OR` の演算を行う前に、それぞれのオペランドをブール値に変換する。
もしこの変換が不要なら、代わりに `BOOST_PP_COMPL` を使うこと。

## See Also

- [`BOOST_PP_COMPL`](compl.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/logical/not.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/logical/not.hpp>

BOOST_PP_NOT(55) // expands to 0
BOOST_PP_NOT(0) // expands to 1
```
* BOOST_PP_NOT[link not.md]

