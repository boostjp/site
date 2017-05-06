# BOOST_PP_LIST_CAT

`BOOST_PP_LIST_CAT` マクロは *リスト* の中のすべての要素を連結する。

## Usage

```cpp
BOOST_PP_LIST_CAT(list)
```

## Arguments

- `list` :
	要素が連結される *リスト* 。

## Remarks

要素は、インデックス `0` で始まり、左から右へ連結される。

以前、このマクロは `BOOST_PP_WHILE` の中では使えなかったが、現在ではこのような制限はない。
しかし、そのような状況では `BOOST_PP_LIST_CAT_D` を使うほうがより能率的である。

## See Also

- [`BOOST_PP_LIST_CAT_D`](list_cat_d.md)

## Requirements

Header: &lt;boost/preprocessor/list/cat.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/list/cat.hpp>

#define LIST (a, (b, (c, BOOST_PP_NIL)))

BOOST_PP_LIST_CAT(LIST) // abc に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_CAT[link list_cat.md]

