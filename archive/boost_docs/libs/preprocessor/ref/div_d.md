# BOOST_PP_DIV_D

`BOOST_PP_DIV_D` マクロは第二引数と第三引数の商に展開される。
これは最も効率よく `BOOST_PP_WHILE` に再入する。

## Usage

```cpp
BOOST_PP_DIV_D(d, x, y)
```

## Arguments

- `d` :
	次の利用可能な `BOOST_PP_WHILE` の反復。

- `x` :
	演算における被除数（分子）。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

- `y` :
	演算における除数（分母）。
	有効な値の範囲は `1` から `BOOST_PP_LIMIT_MAG` まで。

## Remarks

`y` が `0` であった場合、結果は未定義である。

## See Also

- [`BOOST_PP_DIV`](div.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/arithmetic/div.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/dec.hpp>
#include <boost/preprocessor/arithmetic/div.hpp>
#include <boost/preprocessor/control/while.hpp>
#include <boost/preprocessor/tuple/elem.hpp>

#define PRED(d, data) BOOST_PP_TUPLE_ELEM(2, 0, data)

#define OP(d, data) \
	( \
		BOOST_PP_DEC( \
			BOOST_PP_TUPLE_ELEM(2, 0, data) \
		), \
		BOOST_PP_DIV_D( \
			d, \
			BOOST_PP_TUPLE_ELEM(2, 1, data), \
			2 \
		) \
	) \
	/**/

// halve 'x' 'n' times
#define HALVE(x, n) BOOST_PP_TUPLE_ELEM(2, 1, BOOST_PP_WHILE(PRED, OP, (n, x)))

HALVE(8, 2) // 2 に展開される
HALVE(16, 1) // 8 に展開される
```
* BOOST_PP_TUPLE_ELEM[link tuple_elem.md]
* BOOST_PP_DEC[link dec.md]
* BOOST_PP_DIV_D[link div_d.md]
* BOOST_PP_WHILE[link while.md]

