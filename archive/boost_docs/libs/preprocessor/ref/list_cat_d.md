# BOOST_PP_LIST_CAT_D

The `BOOST_PP_LIST_CAT_D` マクロは *リスト* の中のすべての要素を連結する。
これは `BOOST_PP_WHILE` 内で呼ばれる際には最も効率よく機能する。

## Usage

```cpp
BOOST_PP_LIST_CAT_D(d, list)
```

## Arguments

- `d` :
	次の有効な `BOOST_PP_WHILE` 反復。

- `list` :
	要素が連結される *リスト* 。

## Remarks

要素は、インデックス `0` で始まり、左から右へ連結される。

## See Also

- [`BOOST_PP_LIST_CAT`](list_cat.md)

## Requirements

Header: &lt;boost/preprocessor/list/cat.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/cat.hpp>
#include <boost/preprocessor/list/cat.hpp>
#include <boost/preprocessor/list/fold_left.hpp>

#define LISTS \
	((a, (b, BOOST_PP_NIL)), \
		((d, (e, BOOST_PP_NIL)), \
			((e, (f, BOOST_PP_NIL)), \
				BOOST_PP_NIL))) \
	/**/

#define OP(d, state, x) BOOST_PP_CAT(state, BOOST_PP_LIST_CAT_D(d, x))

BOOST_PP_LIST_FOLD_LEFT(OP, _, LISTS) // _abcdef に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_CAT[link cat.md]
* BOOST_PP_LIST_CAT_D[link list_cat_d.md]
* BOOST_PP_LIST_FOLD_LEFT[link list_fold_left.md]

