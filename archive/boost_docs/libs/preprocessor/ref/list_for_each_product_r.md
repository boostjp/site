# BOOST_PP_LIST_FOR_EACH_PRODUCT_R

`BOOST_PP_LIST_FOR_EACH_PRODUCT_R` マクロはいくつかの *リスト* の各デカルト積のためにマクロを繰り返す。
これは `BOOST_PP_FOR` 内で呼ばれる際には最も効率よく機能する。

## Usage

```cpp
BOOST_PP_LIST_FOR_EACH_PRODUCT_R(r, macro, size, tuple)
```

## Arguments

- `r` :
	次の有効な `BOOST_PP_FOR` 反復。

- `macro` :
	`macro (r, product )` 形式の 2項マクロ。
	このマクロは *タプル* 中のデカルト積を伴い `BOOST_PP_FOR_EACH_PRODUCT` によって展開される。
	これは、次の有効な `BOOST_PP_FOR` 反復および *タプル* が含んでいるデカルト積を伴い展開される。
	この *タプル* は `size` 個の要素を持つだろう。

- `size` :
	*タプル* のサイズ。

- `tuple` :
	デカルト積が得られる *リスト* の *タプル* 。

## Remarks

このマクロは繰り返しを作成する。
もし、2つの *リスト* が `(a, (b, (c, BOOST_PP_NIL)))` と `(x, (y, (z, BOOST_PP_NIL)))` ならば、このマクロは次のシーケンスを生成するだろう。

```cpp
macro(r, (a, x)) macro(r, (a, y)) macro(r, (a, z))
macro(r, (b, x)) macro(r, (b, y)) macro(r, (b, z))
macro(r, (c, x)) macro(r, (c, y)) macro(r, (c, z))
```

## See Also

- [`BOOST_PP_LIST_FOR_EACH_PRODUCT`](list_for_each_product.md)

## Requirements

Header: &lt;boost/preprocessor/list/for_each_product.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/dec.hpp>
#include <boost/preprocessor/list/for_each_product.hpp>
#include <boost/preprocessor/repetition/for.hpp>
#include <boost/preprocessor/tuple/elem.hpp>

#define L1 (a, (b, BOOST_PP_NIL))
#define L2 (x, (y, BOOST_PP_NIL))

#define PRED(r, state) BOOST_PP_TUPLE_ELEM(2, 0, state)

#define OP(r, state) \
	( \
		BOOST_PP_DEC( \
			BOOST_PP_TUPLE_ELEM(2, 0, state) \
		), \
		BOOST_PP_TUPLE_ELEM(2, 1, state) \
	) \
	/**/

#define MACRO(r, state) \
	MACRO_I( \
		r, \
		BOOST_PP_TUPLE_ELEM(2, 0, state), \
		BOOST_PP_TUPLE_ELEM(2, 1, state) \
	) \
	/**/

#define MACRO_I(r, c, t) \
	BOOST_PP_LIST_FOR_EACH_PRODUCT_R( \
		r, MACRO_P, 2, \
		( \
			BOOST_PP_TUPLE_ELEM(2, BOOST_PP_DEC(c), t), \
			BOOST_PP_TUPLE_ELEM(2, BOOST_PP_DEC(c), t) \
		) \
	) \
	/**/

#define MACRO_P(r, product) product

BOOST_PP_FOR((2, (L1, L2)), PRED, OP, MACRO)
	// (x, x) (x, y) (y, x) (y, y) (a, a) (a, b) (b, a) (b, b) に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_TUPLE_ELEM[link tuple_elem.md]
* BOOST_PP_DEC[link dec.md]
* BOOST_PP_LIST_FOR_EACH_PRODUCT_R[link list_for_each_product_r.md]
* BOOST_PP_FOR[link for.md]

