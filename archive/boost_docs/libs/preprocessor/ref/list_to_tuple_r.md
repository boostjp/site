# BOOST_PP_LIST_TO_TUPLE_R

`BOOST_PP_LIST_TO_TUPLE_R` マクロは *リスト* を *タプル* に変換する。
これは `BOOST_PP_FOR` 内で呼ばれる際には最も効率よく機能する。

## Usage

```cpp
BOOST_PP_LIST_TO_TUPLE_R(r, list)
```

## Arguments

- `r` :
	次の有効な `BOOST_PP_FOR` 反復。

- `list` :
	変換される *リスト* 。

## Remarks

たとえば、もし *リスト* が `(a, (b, (c, BOOST_PP_NIL)))` ならば、このマクロは

```cpp
(a, b, c)
```

を生成するだろう。

## See Also

- [`BOOST_PP_LIST_TO_TUPLE`](list_to_tuple.md)

## Requirements

Header: &lt;boost/preprocessor/list/to_tuple.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/list/adt.hpp>
#include <boost/preprocessor/list/to_tuple.hpp>
#include <boost/preprocessor/repetition/for.hpp>

#define LIST (x, (y, (z, BOOST_PP_NIL)))

#define PRED(r, state) BOOST_PP_LIST_IS_CONS(state)
#define OP(r, state) BOOST_PP_LIST_REST(state)
#define MACRO(r, state) BOOST_PP_LIST_TO_TUPLE_R(r, state)

BOOST_PP_FOR(LIST, PRED, OP, MACRO)
	// (x, y, z) (y, z) (z) に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_IS_CONS[link list_is_cons.md]
* BOOST_PP_LIST_REST[link list_rest.md]
* BOOST_PP_LIST_TO_TUPLE_R[link list_to_tuple_r.md]
* BOOST_PP_FOR[link for.md]

