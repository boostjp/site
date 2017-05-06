# BOOST_PP_LIST_IS_NIL

`BOOST_PP_LIST_IS_NIL` マクロは *リスト* が空かどうかを判断する述語である。

## Usage

```cpp
BOOST_PP_LIST_IS_NIL(list)
```

## Arguments

- `list` :
	*リスト*。

## Remarks

もし *リスト* が空ならば、このマクロは `1` に展開される。
そうでなければ `0` に展開される。

## Requirements

Header: &lt;boost/preprocessor/list/adt.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/list/adt.hpp>

#define LIST (a, BOOST_PP_NIL)

BOOST_PP_LIST_IS_NIL(LIST) // 0 に展開される
BOOST_PP_LIST_IS_NIL(BOOST_PP_LIST_REST(LIST)) // 1 に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_IS_NIL[link list_is_nil.md]
* BOOST_PP_LIST_REST[link list_rest.md]

