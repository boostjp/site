# BOOST_PP_SUB_D

`BOOST_PP_SUB_D` マクロは第2引数と第3引数の差に展開される。
これは最も効率よく、`BOOST_PP_WHILE` に再入する。

## Usage

```cpp
BOOST_PP_SUB_D(d, x, y)
```

## Arguments

- `d` :
	利用可能な次の `BOOST_PP_WHILE` の繰り返し。

- `x` :
	引き算の被減数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

- `y` :
	引き算の減数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

## Remarks

`x - y` が `0` より小さければ、演算結果は `0` になる。

## See Also

- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)
- [`BOOST_PP_SUB`](sub.md)

## Requirements

Header: &lt;boost/preprocessor/arithmetic/sub.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/dec.hpp>
#include <boost/preprocessor/arithmetic/sub.hpp>
#include <boost/preprocessor/control/while.hpp>
#include <boost/preprocessor/tuple/elem.hpp>

#define PRED(d, data) BOOST_PP_TUPLE_ELEM(2, 0, data)

#define OP(d, data) \
	( \
		BOOST_PP_DEC( \
			BOOST_PP_TUPLE_ELEM(2, 0, data) \
		), \
		BOOST_PP_SUB_D( \
			d, \
			BOOST_PP_TUPLE_ELEM(2, 1, data), \
			2 \
		) \
	) \
	/**/

// decrement 'x' by 2 'n' times
#define STRIDE(x, n) BOOST_PP_TUPLE_ELEM(2, 1, BOOST_PP_WHILE(PRED, OP, (n, x)))

STRIDE(10, 2) // expands to 6
STRIDE(14, 6) // expands to 2
```
* BOOST_PP_TUPLE_ELEM[link tuple_elem.md]
* BOOST_PP_DEC[link dec.md]
* BOOST_PP_SUB_D[link sub_d.md]

