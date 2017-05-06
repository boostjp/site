# BOOST_PP_SUB

`BOOST_PP_SUB` マクロは引数の差に展開される。

## Usage

```cpp
BOOST_PP_SUB(x, y)
```

## Arguments

- `x` :
	引き算の被減数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

- `y` :
	引き算の減数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

## Remarks

`x - y` が `0` より小さければ、演算結果は `0` になる。

以前、このマクロは `BOOST_PP_WHILE` の中で使うことは出来なかったが、もはやそのような制限はない。
しかし、効率のためには、そのような状況では `BOOST_PP_SUB_D` を使うこと。

## See Also

- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)
- [`BOOST_PP_SUB_D`](sub_d.md)

## Requirements

Header: &lt;boost/preprocessor/arithmetic/sub.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/sub.hpp>

BOOST_PP_SUB(4, 3) // expands to 1
```
* BOOST_PP_SUB[link sub.md]

