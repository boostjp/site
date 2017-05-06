# BOOST_PP_LIST_FOR_EACH_R

`BOOST_PP_LIST_FOR_EACH_R` マクロは *リスト* 中の各要素のためにマクロを繰り返す。
これは `BOOST_PP_FOR` 内で呼ばれる際には最も効率よく機能する。

## Usage

```cpp
BOOST_PP_LIST_FOR_EACH_R(r, macro, data, list)
```

## Arguments

- `r` :
	次の有効な `BOOST_PP_FOR` 反復。

- `macro` :
	`macro (r, data, elem )` 形式の 3項マクロ。
	このマクロは *リスト* 中の各要素を伴い `BOOST_PP_LIST_FOR_EACH` によって展開される。
	これは、次の有効な `BOOST_PP_FOR` 反復、補助の *データ* および現在の要素を伴い展開される。

- `data` :
	`macro` に渡される補助のデータ。

- `list` :
	`macro` が各要素で実行される *リスト* 。

## Remarks

このマクロは繰り返しを作成する。
もし、*リスト* が `(a, (b, (c, BOOST_PP_NIL)))` ならば、 これは

```cpp
macro(r, data, a) macro(r, data, b) macro(r, data, c)
```

に展開される。

## See Also

- [`BOOST_PP_LIST_FOR_EACH`](list_for_each.md)

## Requirements

Header: &lt;boost/preprocessor/list/for_each.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/list/adt.hpp>
#include <boost/preprocessor/list/for_each.hpp>
#include <boost/preprocessor/repetition/for.hpp>

#define LIST (x, (y, (z, BOOST_PP_NIL)))

#define MACRO_2(r, data, elem) elem

#define PRED(r, state) BOOST_PP_LIST_IS_CONS(state)
#define OP(r, state) BOOST_PP_LIST_REST(state)
#define MACRO(r, state) [ BOOST_PP_LIST_FOR_EACH_R(r, MACRO_2, _, state) ]

BOOST_PP_FOR(LIST, PRED, OP, MACRO)
	// [x y z] [y z] [z] に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_IS_CONS[link list_is_cons.md]
* BOOST_PP_LIST_REST[link list_rest.md]
* BOOST_PP_LIST_FOR_EACH_R[link list_for_each_r.md]
* BOOST_PP_FOR[link for.md]

