# BOOST_PP_LIST_IS_CONS

`BOOST_PP_LIST_IS_CONS` マクロは *リスト* が空でないかどうかを判断する述語である。

## Usage

```cpp
BOOST_PP_LIST_IS_CONS(list)
```

## Arguments

- `list` :
	*リスト* 。

## Remarks

もし *リスト* が非空ならば、このマクロは `1` に展開される。
そうでなければ `0` に展開される。

## Requirements

Header: &lt;boost/preprocessor/list/adt.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/list/adt.hpp>

#define LIST (a, BOOST_PP_NIL)

BOOST_PP_LIST_IS_CONS(LIST) // 1 に展開される
BOOST_PP_LIST_IS_CONS(BOOST_PP_LIST_REST(LIST)) // 0 に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_IS_CONS[link list_is_cons.md]
* BOOST_PP_LIST_REST[link list_rest.md]

