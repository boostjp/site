# BOOST_PP_LIST_FIRST_N_D

`BOOST_PP_LIST_FIRST_N` マクロは *リスト* の先頭から *count* 個の要素の  *リスト* に展開される。
これは `BOOST_PP_WHILE` 内で呼ばれる際には最も効率よく機能する。

## Usage

```cpp
BOOST_PP_LIST_FIRST_N_D(d, count, list)
```

## Arguments

- `d` :
	次の有効な `BOOST_PP_WHILE` 反復。

- `count` :
	抽出する要素数。

- `list` :
	要素が抽出される *リスト* 。

## Remarks

このマクロは *リスト* の先頭から *count* 個の要素を抽出し、それらを *リスト* として返す。

## See Also

- [`BOOST_PP_LIST_FIRST_N`](list_first_n.md)

## Requirements

Header: &lt;boost/preprocessor/list/first_n.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/list/first_n.hpp>
#include <boost/preprocessor/list/fold_right.hpp>

#define L1 (a, (b, (c, (d, BOOST_PP_NIL))))
#define L2 (L1, (L1, (L1, BOOST_PP_NIL)))

#define OP(d, state, x) (BOOST_PP_LIST_FIRST_N_D(d, 2, x), state)

BOOST_PP_LIST_FOLD_RIGHT(OP, BOOST_PP_NIL, L2)
/*
	((a, (b, BOOST_PP_NIL)), ((a, (b, BOOST_PP_NIL)),
	((a, (b, BOOST_PP_NIL)) , BOOST_PP_NIL )))
	に展開される
*/
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_FIRST_N_D[link list_first_n_d.md]
* BOOST_PP_LIST_FOLD_RIGHT[link list_fold_right.md]

