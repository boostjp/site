# BOOST_PP_MUL_D

`BOOST_PP_MUL_D` マクロは第2引数と第3引数の積に展開される。
これは、最も効率的に `BOOST_PP_WHILE` に再入する。

## Usage

```cpp
BOOST_PP_MUL_D(d, x, y)
```

## Arguments

- `d` :
	利用可能な次の `BOOST_PP_WHILE` の繰り返し。

- `x` :
	演算での被乗数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

- `y` :
	演算での乗数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

## Remarks

もし `x` と `y` の積が `BOOST_PP_LIMIT_MAG` より大きければ、`BOOST_PP_LIMIT_MAG` になる。

このマクロは `x` が `y` より小さいか等しいときに、最も効率的である。
しかし、この効率を得るためのマクロ呼び出しの前に二つの引数を実際に比較するほどの価値はない。
言い換えれば、 `x` は2つのオペランドのうちより大きい(訳注: 小さい) *可能性が高い* 値にすればよい。

## See Also

- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)
- [`BOOST_PP_MUL`](mul.md)

## Requirements

Header: &lt;boost/preprocessor/arithmetic/mul.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/dec.hpp>
#include <boost/preprocessor/arithmetic/mul.hpp>
#include <boost/preprocessor/control/while.hpp>
#include <boost/preprocessor/tuple/elem.hpp>

#define PRED(d, data) BOOST_PP_TUPLE_ELEM(3, 0, data)

#define OP(d, data) \
	( \
		BOOST_PP_DEC( \
			BOOST_PP_TUPLE_ELEM(3, 0, data) \
		), \
		BOOST_PP_TUPLE_ELEM(3, 1, data), \
		BOOST_PP_MUL_D( \
			d, \
			BOOST_PP_TUPLE_ELEM(3, 2, data), \
			BOOST_PP_TUPLE_ELEM(3, 1, data) \
		) \
	) \
	/**/

// raise 'x' to the 'n'-th power
#define EXP(x, n) BOOST_PP_TUPLE_ELEM(3, 2, BOOST_PP_WHILE(PRED, OP, (n, x, 1)))

EXP(4, 2) // expands to 16
EXP(2, 3) // expands to 8
```
* BOOST_PP_TUPLE_ELEM[link tuple_elem.md]
* BOOST_PP_DEC[link dec.md]
* BOOST_PP_MUL_D[link mul_d.md]

