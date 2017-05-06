# BOOST_PP_LIST_ENUM

`BOOST_PP_LIST_ENUM` マクロは *リスト* をカンマ区切りリストに変換する。

## Usage

```cpp
BOOST_PP_LIST_ENUM(list)
```

## Arguments

- `list` :
	変換される *リスト* 。

## Remarks

たとえば、もし *リスト* が `(a, (b, (c, BOOST_PP_NIL)))` ならば、

```cpp
a, b, c
```

を、このマクロは作成するだろう。

以前、このマクロは `BOOST_PP_FOR` の中では使えなかったが、現在ではこのような制限はない。
しかし、そのような状況では `BOOST_PP_LIST_ENUM_R` を使うほうがより能率的である。

## See Also

- [`BOOST_PP_LIST_ENUM_R`](list_enum_r.md)

## Requirements

Header: &lt;boost/preprocessor/list/enum.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/list/enum.hpp>

#define LIST (w, (x, (y, (z, BOOST_PP_NIL))))

BOOST_PP_LIST_ENUM(LIST) // w, x, y, z に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_ENUM[link list_enum.md]

