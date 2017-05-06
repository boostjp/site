# BOOST_PP_LIST_FOR_EACH_I_R

`BOOST_PP_LIST_FOR_EACH_I_R` マクロは *リスト* 中の各要素のためにマクロを繰り返す。
これは `BOOST_PP_FOR` 内で呼ばれる際には最も効率よく機能する。

## Usage

```cpp
BOOST_PP_LIST_FOR_EACH_I_R(r, macro, data, list)
```

## Arguments

- `r` :
	次の有効な `BOOST_PP_FOR` 反復。

- `macro` :
	`macro (r, data, i, elem )` 形式のマクロ。
	このマクロは *リスト* 中の各要素を伴い `BOOST_PP_LIST_FOR_EACH` によって展開される。
	これは、次の有効な `BOOST_PP_FOR` 反復、補助の *データ* 、現在の要素のインデックスおよび現在の要素を伴い展開される。

- `data` :
	`macro` に渡される補助のデータ。 

- `list` :
	`macro` が各要素で実行される *リスト* 。

## Remarks

このマクロは繰り返しを作成する。
もし、*リスト* が `(a, (b, (c, BOOST_PP_NIL)))` ならば、 これは

```cpp
macro(r, data, 0, a) macro(r, data, 1, b) macro(r, data, 2, c)
```

に展開される。

## See Also

- [`BOOST_PP_LIST_FOR_EACH_I`](list_for_each_i.md)

## Requirements

Header: &lt;boost/preprocessor/list/for_each_i.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/cat.hpp>
#include <boost/preprocessor/list/adt.hpp>
#include <boost/preprocessor/list/for_each_i.hpp>
#include <boost/preprocessor/repetition/for.hpp>

#define LIST (x, (y, (z, BOOST_PP_NIL)))

#define MACRO_2(r, data, i, elem) BOOST_PP_CAT(elem, i)

#define PRED(r, state) BOOST_PP_LIST_IS_CONS(state)
#define OP(r, state) BOOST_PP_LIST_REST(state)
#define MACRO(r, state) [ BOOST_PP_LIST_FOR_EACH_I_R(r, MACRO_2, _, state) ]

BOOST_PP_FOR(LIST, PRED, OP, MACRO)
	// [x0 y1 z2] [y0 z1] [z0] に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_CAT[link cat.md]
* BOOST_PP_LIST_IS_CONS[link list_is_cons.md]
* BOOST_PP_LIST_REST[link list_rest.md]
* BOOST_PP_LIST_FOR_EACH_I_R[link list_for_each_i_r.md]
* BOOST_PP_FOR[link for.md]

