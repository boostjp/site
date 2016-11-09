#BOOST_PP_AND

`BOOST_PP_AND` マクロはオペランドの論理*積(AND)*に展開される。

##Usage

```cpp
BOOST_PP_AND(p, q)
```

##Arguments

- `p` :
	演算における左オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

- `q` :
	演算における右オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

##Remarks

`p` と `q` が共に `0` でないならば、このマクロは `1` に展開される。
そうでなければ `0` に展開される。

このマクロは論理*積(AND)*演算を行う前に、それぞれのオペランドを boolean 変換する。
この変換が不必要ならば、代わりに `BOOST_PP_BITAND` を使用する。

##See Also

- [`BOOST_PP_BITAND`](bitand.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

##Requirements

**Header:** &nbsp;&lt;boost/preprocessor/logical/and.hpp&gt;

##Sample Code

```cpp
#include <boost/preprocessor/logical/and.hpp>

BOOST_PP_AND(4, 3) // 1 に展開される
BOOST_PP_AND(5, 0) // 0 に展開される
```
* BOOST_PP_AND[link and.md]

