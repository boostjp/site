# BOOST_PP_FOR_r

`BOOST_PP_FOR_r` マクロは `BOOST_PP_FOR` の繰り返しの構築への再入を表す。

## Usage

```cpp
BOOST_PP_FOR_ ## r(state, pred, op, macro)
```

## Arguments

- `r` :
	利用可能な次の `BOOST_PP_FOR` の繰り返し。

- `state` :
	初期状態。

- `pred` :
	`pred(r, state)` という形の2項述語。
	このマクロは `0` から `BOOST_PP_LIMIT_MAG` までの範囲の整数値に展開されなければならない。
	`BOOST_PP_FOR` はこの述語が非0を返す間、 `macro` を繰り返し展開する。
	このマクロは利用可能な次の `BOOST_PP_FOR` の繰り返しと、現在の `state` と共に呼び出される。

- `op` :
	`op(r, state)` という形の2項演算。
	この演算は `BOOST_PP_FOR` によって、利用可能な次の `BOOST_PP_FOR` の繰り返しと、現在の `state` と共に展開される。
	このマクロは `pred` が `0` を返すまで、新しい `state` を作りながら、 `state` に繰り返し適用される。

- `macro` :
	`macro(r, state)` という形の2項演算。
	このマクロは `BOOST_PP_FOR` によって、利用可能な次の `BOOST_PP_FOR` の繰り返しと、現在の `state` と共に展開される。
	このマクロは `BOOST_PP_FOR` によって、`pred` が `0` を返すまで繰り返される

## Remarks

このマクロは次のシーケンスに展開される:

```cpp
macro(r, state) macro(r, op(r, state)) ... macro(r, op(r, ... op(r, state) ... ))
```

プリプロセッサのトークン解析演算ではなく `BOOST_PP_CAT` での文字列連結を使う必要があるときが、あるだろう。
これは、 `r` の値がマクロ呼び出しそのものであるようなときに起こる。
これは、展開の遅延を必要とする。
そのような状況での構文は、次のようになる:

```cpp
BOOST_PP_CAT(BOOST_PP_FOR_, r)(state, pred, op, macro)
```

## See Also

- [`BOOST_PP_CAT`](cat.md)
- [`BOOST_PP_FOR`](for.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/repetition/for.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/dec.hpp>
#include <boost/preprocessor/arithmetic/inc.hpp>
#include <boost/preprocessor/comparison/not_equal.hpp>
#include <boost/preprocessor/punctuation/comma_if.hpp>
#include <boost/preprocessor/repetition/for.hpp>
#include <boost/preprocessor/tuple/elem.hpp>

#define PRED(r, state) \
	BOOST_PP_NOT_EQUAL( \
		BOOST_PP_TUPLE_ELEM(4, 0, state), \
		BOOST_PP_INC( \
			BOOST_PP_TUPLE_ELEM(4, 1, state) \
		) \
	) \
	/**/

#define OP(r, state) \
	( \
		BOOST_PP_INC( \
			BOOST_PP_TUPLE_ELEM(4, 0, state) \
		), \
		BOOST_PP_TUPLE_ELEM(4, 1, state), \
		BOOST_PP_TUPLE_ELEM(4, 2, state), \
		BOOST_PP_INC( \
			BOOST_PP_TUPLE_ELEM(4, 3, state) \
		) \
	) \
	/**/

#define MACRO(r, state) \
	BOOST_PP_COMMA_IF( \
		BOOST_PP_TUPLE_ELEM(4, 3, state) \
	) template< \
	BOOST_PP_FOR_ ## r( \
		(0, BOOST_PP_TUPLE_ELEM(4, 0, state), _, 0), \
		PRED_2, OP, MACRO_2 \
	) \
	> class BOOST_PP_CAT( \
		BOOST_PP_TUPLE_ELEM(4, 2, state), \
		BOOST_PP_TUPLE_ELEM(4, 0, state) \
	) \
	/**/

#define PRED_2(r, state) \
	BOOST_PP_NOT_EQUAL( \
		BOOST_PP_TUPLE_ELEM(4, 0, state), \
		BOOST_PP_TUPLE_ELEM(4, 1, state) \
	) \
	/**/

#define MACRO_2(r, state) \
	BOOST_PP_COMMA_IF( \
		BOOST_PP_TUPLE_ELEM(4, 0, state) \
	) class \
	/**/

#define TEMPLATE_TEMPLATE(low, high, name) \
	BOOST_PP_FOR( \
		(low, high, name, 0), \
		PRED, OP, MACRO \
	) \
	/**/

TEMPLATE_TEMPLATE(2, 4, T)
/*
	expands to...
	template<class, class> class T2,
	template<class, class, class> class T3,
	template<class, class, class, class> class T4
*/
```
* BOOST_PP_NOT_EQUAL[link not_equal.md]
* BOOST_PP_TUPLE_ELEM[link tuple_elem.md]
* BOOST_PP_INC[link inc.md]
* BOOST_PP_COMMA_IF[link comma_if.md]
* BOOST_PP_FOR_r[link for_r.md]
* BOOST_PP_CAT[link cat.md]
* BOOST_PP_FOR[link for.md]

