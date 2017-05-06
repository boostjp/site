# BOOST_PP_LIST_FOR_EACH_PRODUCT

`BOOST_PP_LIST_FOR_EACH_PRODUCT` マクロはいくつかの *リスト* の各デカルト積のためにマクロを繰り返す。

## Usage

```cpp
BOOST_PP_LIST_FOR_EACH_PRODUCT(macro, size, tuple)
```

## Arguments

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

以前、このマクロは `BOOST_PP_FOR` の中では使えなかったが、現在ではこのような制限はない。
しかし、そのような状況では `BOOST_PP_LIST_FOR_EACH_PRODUCT_R` を使うほうがより能率的である。

## See Also

- [`BOOST_PP_LIST_FOR_EACH_PRODUCT_R`](list_for_each_product_r.md)

## Requirements

Header: &lt;boost/preprocessor/list/for_each_product.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/list/for_each_product.hpp>

#define L1 (a, (b, (c, BOOST_PP_NIL)))
#define L2 (x, (y, (z, BOOST_PP_NIL)))

#define MACRO(r, product) product

BOOST_PP_LIST_FOR_EACH_PRODUCT(MACRO, 2, (L1, L2))
	// (a, x) (a, y) (a, z) (b, x) (b, y) (b, z) (c, x) (c, y) (c, z) に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_FOR_EACH_PRODUCT[link list_for_each_product.md]

