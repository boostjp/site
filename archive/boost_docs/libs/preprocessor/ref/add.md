# BOOST_PP_ADD

`BOOST_PP_ADD` マクロは引数の和に展開される。

## Usage

```cpp
BOOST_PP_ADD(x, y)
```

## Arguments

- `x` :
	演算における一つ目の加数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

- `y` :
	演算における二つ目の加数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

## Remarks

もし `x` と `y` の和が `BOOST_PP_LIMIT_MAG` よりも大きければ、演算結果は `BOOST_PP_LIMIT_MAG` に丸められる。

以前、このマクロは `BOOST_PP_WHILE` の中では使えなかったが、現在ではこのような制限はない。
しかし、そのような状況では `BOOST_PP_ADD_D` を用いたほうが効率がよい。

`x` が `y` より小さいかまたは同じとき、このマクロは最も効率的である。
しかしながら、その効率利得にはマクロ発動に先立って実際に二つの引数を比較するほどの価値はない。
言い換えれば、`x` は二つのオペランドのうち大きい方である可能性が*たぶん* **高そうな(逆じゃない?)**方であるべきだ。

## See Also

- [`BOOST_PP_ADD_D`](add_d.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

**Header:** &lt;boost/preprocessor/arithmetic/add.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/add.hpp>

BOOST_PP_ADD(4, 3) // 7 に展開される
```
* BOOST_PP_ADD[link add.md]

