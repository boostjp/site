# BOOST_PP_MOD

`BOOST_PP_MOD` マクロは引数の余りに展開される。

## Usage

```cpp
BOOST_PP_MOD(x, y)
```

## Arguments

- `x` :
	演算の割られる方(分子)。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

- `y` :
	演算の割る方(分母)。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

## Remarks

以前、このマクロは `BOOST_PP_WHILE` の中で利用することが出来なかった。
この制約は今は存在しない。
しかし、より効率的にするには、そのような状況では `BOOST_PP_MOD_D` を使うこと。

もし `y` が `0` なら、結果は未定義である。

## See Also

- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)
- [`BOOST_PP_MOD_D`](mod_d.md)

## Requirements

Header: &lt;boost/preprocessor/arithmetic/mod.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/mod.hpp>

BOOST_PP_MOD(11, 5) // expands to 1
```
* BOOST_PP_MOD[link mod.md]

