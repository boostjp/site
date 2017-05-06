# BOOST_PP_LIST_FOLD_LEFT

`BOOST_PP_LIST_FOLD_LEFT` マクロは *リスト* の要素を左から右へ折りたたむ（または蓄積する）。

## Usage

```cpp
BOOST_PP_LIST_FOLD_LEFT(op, state, list)
```

## Arguments

- `op` :
	`op (d, state, elem )` 形式の 3項演算。
	このマクロは *リスト* 中の各要素のために呼び出される―毎回新しい *状態* を返す。
	この演算は、次の有効な `BOOST_PP_WHILE` 反復、現在の *状態* および現在の要素を伴い `BOOST_PP_LIST_FOLD_LEFT` によって展開される。

- `state` :
	折りたたみの初期状態。

- `list` :
	折りたたまれる *リスト* 。

## Remarks

*リスト* `(0, (1, (2, BOOST_PP_NIL)))` のために、このマクロは

```cpp
op(d, op(d, op(d, state, 0), 1), 2)
```

に展開される。

以前、このマクロは `BOOST_PP_WHILE` の中では使えなかったが、現在ではこのような制限はない。
しかし、そのような状況では `BOOST_PP_LIST_FOLD_LEFT_d` を使うほうがより能率的である。

## See Also

- [`BOOST_PP_LIST_FOLD_LEFT_d`](list_fold_left_d.md)

## Requirements

Header: &lt;boost/preprocessor/list/fold_left.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/cat.hpp>
#include <boost/preprocessor/list/fold_left.hpp>

#define LIST (a, (b, (c, BOOST_PP_NIL)))

#define OP(d, state, x) BOOST_PP_CAT(state, x)

BOOST_PP_LIST_FOLD_LEFT(OP, _, LIST) // _abc に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_CAT[link cat.md]
* BOOST_PP_LIST_FOLD_LEFT[link list_fold_left.md]

