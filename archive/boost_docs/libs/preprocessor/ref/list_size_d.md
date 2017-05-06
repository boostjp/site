# BOOST_PP_LIST_SIZE_D

`BOOST_PP_LIST_SIZE_D` マクロは *リスト* のサイズに展開される。
これは `BOOST_PP_WHILE` 内で呼ばれる際には最も効率よく機能する。

## Usage

```cpp
BOOST_PP_LIST_SIZE_D(d, list)
```

## Arguments

- `d` :
	次の有効な `BOOST_PP_WHILE` 反復。

- `list` :
	サイズが計算される *リスト* 。

## See Also

- [`BOOST_PP_LIST_SIZE`](list_size.md)

## Requirements

Header: &lt;boost/preprocessor/list/size.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/add.hpp>
#include <boost/preprocessor/list/fold_left.hpp>
#include <boost/preprocessor/list/size.hpp>

#define L1 (a, (b, (c, BOOST_PP_NIL)))
#define L2 (x, (y, BOOST_PP_NIL))
#define L3 (p, (q, BOOST_PP_NIL))

#define LIST (L1, (L2, (L3, BOOST_PP_NIL)))

#define OP(d, state, x) \
	BOOST_PP_ADD_D( \
		d, state, \
		BOOST_PP_LIST_SIZE_D(d, x) \
	) \
	/**/

BOOST_PP_LIST_FOLD_LEFT(OP, 0, LIST) // 7 に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_ADD_D[link add_d.md]
* BOOST_PP_LIST_SIZE_D[link list_size_d.md]
* BOOST_PP_LIST_FOLD_LEFT[link list_fold_left.md]

