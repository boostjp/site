# BOOST_PP_LIST_ENUM_R

`BOOST_PP_LIST_ENUM_R` マクロは *リスト* をカンマ区切りリストに変換する。
これは `BOOST_PP_FOR` 内で呼ばれる際には最も効率よく機能する。

## Usage

```cpp
BOOST_PP_LIST_ENUM_R(r, list)
```

## Arguments

- `r` :
	次の有効な `BOOST_PP_FOR` 反復。

- `list` :
	変換される *リスト* 。

## Remarks

たとえば、もし *リスト* が `(a, (b, (c, BOOST_PP_NIL)))` ならば、

```cpp
a, b, c
```

を、このマクロは作成するだろう。

## See Also

- [`BOOST_PP_LIST_ENUM`](list_enum.md)

## Requirements

Header: &lt;boost/preprocessor/list/enum.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/list/adt.hpp>
#include <boost/preprocessor/repetition/for.hpp>
#include <boost/preprocessor/list/enum.hpp>

#define LIST (x, (y, (z, BOOST_PP_NIL)))

#define PRED(r, state) BOOST_PP_LIST_IS_CONS(state)
#define OP(r, state) BOOST_PP_LIST_REST(state)
#define MACRO(r, state) [ BOOST_PP_LIST_ENUM_R(r, state) ]

BOOST_PP_FOR(LIST, PRED, OP, MACRO)
	// [x, y, z] [y, z] [z] に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_IS_CONS[link list_is_cons.md]
* BOOST_PP_LIST_REST[link list_rest.md]
* BOOST_PP_LIST_ENUM_R[link list_enum_r.md]
* BOOST_PP_FOR[link for.md]

