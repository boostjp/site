# BOOST_PP_DEDUCE_D

`BOOST_PP_DEDUCE_D` マクロは `BOOST_PP_WHILE` の構築状態を手動で推論する。

## Usage

```cpp
BOOST_PP_DEDUCE_D()
```

## Remarks

このマクロは深い展開における*自動再帰*の使用を避けるためにある。
いくつかのプリプロセッサでは、そのような深さでの*自動再帰*は非効率的となり得る。
これは接尾辞 `_D` を持ったマクロの実行に直接使用されるためのものではない。例えば:

```cpp
BOOST_PP_ADD_D(BOOST_PP_DEDUCE_D(), x, y)
```

もしこのような文脈でこのマクロが使われた場合、`_D` マクロは失敗するだろう。
`_D` マクロは渡されたパラメータ `d` を直接、`BOOST_PP_DEDUCE_D()` が展開されるのを邪魔して、結合する。
さらに言えば、このマクロをさきの例のような状況で使用するのは無意味である。
効率を得るにはすでに遅すぎるからだ。

## See Also

- [`BOOST_PP_WHILE`](while.md)

## Requirements

Header: &lt;boost/preprocessor/control/deduce_d.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/add.hpp>
#include <boost/preprocessor/arithmetic/inc.hpp>
#include <boost/preprocessor/arithmetic/sub.hpp>
#include <boost/preprocessor/control/deduce_d.hpp>
#include <boost/preprocessor/punctuation/comma_if.hpp>
#include <boost/preprocessor/repetition/repeat.hpp>
#include <boost/preprocessor/tuple/elem.hpp>

#define RANGE(first, last) \
	BOOST_PP_REPEAT( \
		BOOST_PP_INC( \
			BOOST_PP_SUB(last, first) \
			, \
			RANGE_M, \
		(first, BOOST_PP_DEDUCE_D()) \
	) \
	/**/

#define RANGE_M(z, n, data) \
	RANGE_M_2( \
		n, \
		BOOST_PP_TUPLE_ELEM(2, 0, data), \
		BOOST_PP_TUPLE_ELEM(2, 1, data) \
	) \
	/**/

#define RANGE_M_2(n, first, d) \
   BOOST_PP_COMMA_IF(n) BOOST_PP_ADD_D(d, n, first) \
   /**/

RANGE(5, 10) // 5, 6, 7, 8, 9, 10 に展開される
```
* BOOST_PP_REPEAT[link repeat.md]
* BOOST_PP_INC[link inc.md]
* BOOST_PP_SUB[link sub.md]
* BOOST_PP_DEDUCE_D[link deduce_d.md]
* BOOST_PP_TUPLE_ELEM[link tuple_elem.md]
* BOOST_PP_TUPLE_ELEM[link tuple_elem.md]
* BOOST_PP_COMMA_IF[link comma_if.md]
* BOOST_PP_ADD_D[link add_d.md]

