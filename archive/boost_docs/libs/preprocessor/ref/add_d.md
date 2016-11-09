#BOOST_PP_ADD_D

`BOOST_PP_ADD_D` マクロは第二引数と第三引数の和に展開される。
これは `BOOST_PP_WHILE` 内で呼ばれる際には最も効率よく機能する。

##Usage

```cpp
BOOST_PP_ADD_D(d, x, y)
```

##Arguments

- `d` :
	次の有効な `BOOST_PP_WHILE` 反復。

- `x` :
	演算における一つ目の加数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

- `y` :
	演算における二つ目の加数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

##Remarks

もし `x` と `y` の和が `BOOST_PP_LIMIT_MAG` よりも大きければ、演算結果は `BOOST_PP_LIMIT_MAG` に丸められる。

`x` が`y` より小さいかまたは同じとき、このマクロは最も効率的である。
しかしながら、その効率利得にはマクロ発動に先立って実際に二つの引数を比較するほどの価値はない。
言い換えれば、`x` は二つのオペランドのうち大きい方である可能性が*たぶん* **高そうな(逆じゃない?)**方であるべきだ。

##See Also

- [`BOOST_PP_ADD`](add.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

##Requirements

**Header:** &lt;boost/preprocessor/arithmetic/add.hpp&gt;

##Sample Code

```cpp
#include <boost/preprocessor/arithmetic/add.hpp>
#include <boost/preprocessor/arithmetic/dec.hpp>
#include <boost/preprocessor/control/while.hpp>
#include <boost/preprocessor/tuple/elem.hpp>

#define PRED(d, data) BOOST_PP_TUPLE_ELEM(2, 0, data)

#define OP(d, data) \
	( \
		BOOST_PP_DEC( \
			BOOST_PP_TUPLE_ELEM(2, 0, data) \
		), \
		BOOST_PP_ADD_D( \
			d, \
			BOOST_PP_TUPLE_ELEM(2, 1, data), \
			2 \
		) \
	) \
	/**/

// 'x' を 2 'n' 回インクリメントする
#define STRIDE(x, n) BOOST_PP_TUPLE_ELEM(2, 1, BOOST_PP_WHILE(PRED, OP, (n, x)))

STRIDE(10, 2) // 14 に展開される
STRIDE(51, 6) // 63 に展開される
```
* BOOST_PP_TUPLE_ELEM[link tuple_elem.md]
* BOOST_PP_DEC[link dec.md]
* BOOST_PP_ADD_D[link add_d.md]
* BOOST_PP_WHILE[link while.md]

