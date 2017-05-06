# BOOST_PP_LIST_FOLD_RIGHT_2ND_D

`BOOST_PP_LIST_FOLD_RIGHT_2ND_D` マクロは *リスト* の要素を右から左へ折りたたむ（または蓄積する）。
これは `BOOST_PP_WHILE` 内で呼ばれる際には最も効率よく機能する。

## Usage

```cpp
BOOST_PP_LIST_FOLD_RIGHT_2ND_D(d, op, state, list)
```

## Arguments

- `d` :
	次の有効な `BOOST_PP_WHILE` 反復。

- `op` :
	`op (d, state, elem )` 形式の 3項演算。
	このマクロは *リスト* 中の各要素のために呼び出される―毎回新しい *状態* を返す。
	この演算は、次の有効な `BOOST_PP_WHILE` 反復、現在の *状態* および現在の要素を伴い `BOOST_PP_LIST_FOLD_RIGHT` によって展開される。

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

このマクロは `BOOST_PP_LIST_FOLD_RIGHT_d` によって取って代わられており、廃止された。
これは `BOOST_PP_LIST_FOLD_RIGHT` への再突入を 1回許可するだけである。

## See Also

- [`BOOST_PP_LIST_FOLD_RIGHT`](list_fold_right.md)
- [`BOOST_PP_LIST_FOLD_RIGHT_d`](list_fold_right_d.md)

## Requirements

Header: &lt;boost/preprocessor/list/fold_right.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/cat.hpp>
#include <boost/preprocessor/list/fold_right.hpp>

#define L1 (a, (b, (c, BOOST_PP_NIL)))
#define L2 (L1, (L1, (L1, BOOST_PP_NIL)))

#define OP(d, state, x) (BOOST_PP_LIST_FOLD_RIGHT_2ND_D(d, OP_2, _, x), state)
#define OP_2(d, state, x) BOOST_PP_CAT(state, x)

BOOST_PP_LIST_FOLD_RIGHT(OP, BOOST_PP_NIL, L2)
/*
	(_cba , (_cba , (_cba , BOOST_PP_NIL)))
	に展開される
*/
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_FOLD_RIGHT_2ND_D[link list_fold_right_2nd_d.md]
* BOOST_PP_CAT[link cat.md]
* BOOST_PP_LIST_FOLD_RIGHT[link list_fold_right.md]

