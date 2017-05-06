# BOOST_PP_LIST_AT_D

`BOOST_PP_LIST_AT_D` マクロは *リスト* の中の要素を抽出する。
これは `BOOST_PP_WHILE` 内で呼ばれる際には最も効率よく機能する。

## Usage

```cpp
BOOST_PP_LIST_AT_D(d, list, index)
```

## Arguments

- `d` :
	次の有効な `BOOST_PP_WHILE` 反復。

- `list` :
	要素が抽出される *リスト* 。
	この *リスト* は少なくとも `index + 1` 個の要素を所持していなければならない。

- `index` :
	抽出される要素の *リスト* の中の位置（起点は 0）。

## See Also

- [`BOOST_PP_LIST_AT`](list_at.md)

## Requirements

Header: &lt;boost/preprocessor/list/at.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/control/while.hpp>
#include <boost/preprocessor/list/at.hpp>

#define LIST (7, (2, (0, (1, BOOST_PP_NIL))))

#define PRED(d, state) BOOST_PP_LIST_AT_D(d, state, 0)
#define OP(d, state) BOOST_PP_LIST_REST(state)

BOOST_PP_WHILE(PRED, OP, LIST) // (0, (1, BOOST_PP_NIL)) に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_AT_D[link list_at_d.md]
* BOOST_PP_LIST_REST[link list_rest.md]
* BOOST_PP_WHILE[link while.md]

