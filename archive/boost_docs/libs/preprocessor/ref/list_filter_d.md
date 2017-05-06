# BOOST_PP_LIST_FILTER_D

`BOOST_PP_LIST_FILTER_D` マクロは *リスト* を与えられた基準に従ってフィルターする。
これは `BOOST_PP_WHILE` 内で呼ばれる際には最も効率よく機能する。

## Usage

```cpp
BOOST_PP_LIST_FILTER_D(d, pred, data, list)
```

## Arguments

- `d` :
	次の有効な `BOOST_PP_WHILE` 反復。

- `pred` :
	`pred (d, data, elem )` 形式の 3項述語。
	この述語は、次の有効な `BOOST_PP_WHILE` 反復、補助の *データ* および *リスト* 中の現在の要素を伴い、*リスト* 中の各要素のために `BOOST_PP_LIST_FILTER` によって展開される。
	このマクロは `0` から `BOOST_PP_LIMIT_MAG` までの範囲の整数値を返さなければならない。
	もしこの述語が特定の要素で 0以外に展開されるならば、その要素は結果の *リスト* に含まれるだろう。

- `data` :
	`pred` に渡される補助のデータ。

- `list` :
	フィルターされる *リスト* 。

## Remarks

このマクロは *リスト* 中の各要素のために `pred` を展開する。
これは、`pred` が 0以外を返す各要素から新しい *リスト* を作成する。

## See Also

- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)
- [`BOOST_PP_LIST_FILTER`](list_filter.md)

## Requirements

Header: &lt;boost/preprocessor/list/filter.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/comparison/less_equal.hpp>
#include <boost/preprocessor/list/filter.hpp>
#include <boost/preprocessor/list/fold_right.hpp>

#define A (1, (2, (3, (4, BOOST_PP_NIL))))
#define B (A, (A, (A, (A, BOOST_PP_NIL))))

#define PRED(d, data, x) BOOST_PP_LESS_EQUAL(x, data)
#define OP(d, state, x) (BOOST_PP_LIST_FILTER_D(d, PRED, 2, x), state)

BOOST_PP_LIST_FOLD_RIGHT(OP, BOOST_PP_NIL, B)
/*
	((1, (2, BOOST_PP_NIL)),
	((1, (2, BOOST_PP_NIL)),
	((1, (2, BOOST_PP_NIL)),
	((1, (2, BOOST_PP_NIL)),
		BOOST_PP_NIL))))
	に展開される
*/
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LESS_EQUAL[link less_equal.md]
* BOOST_PP_LIST_FILTER_D[link list_filter_d.md]
* BOOST_PP_LIST_FOLD_RIGHT[link list_fold_right.md]

