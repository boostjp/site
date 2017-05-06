# BOOST_PP_LIST_AT

`BOOST_PP_LIST_AT` マクロは *リスト* の中の要素を抽出する。

## Usage

```cpp
BOOST_PP_LIST_AT(list, index)
```

## Arguments

- `list` :
	要素が抽出される *リスト* 。
	この *リスト* は少なくとも `index + 1` 個の要素を所持していなければならない。

- `index` :
	抽出される要素の *リスト* の中の位置（起点は 0）。

## Remarks

以前、このマクロは `BOOST_PP_WHILE` の中では使えなかったが、現在ではこのような制限はない。
しかし、そのような状況では `BOOST_PP_LIST_AT_D` を使うほうがより能率的である。

## See Also

- [`BOOST_PP_LIST_AT_D`](list_at_d.md)

## Requirements

Header: &lt;boost/preprocessor/list/at.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/list/at.hpp>

#define LIST (a, (b, (c, BOOST_PP_NIL)))

BOOST_PP_LIST_AT(LIST, 0) // a に展開される
BOOST_PP_LIST_AT(LIST, 2) // c に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_AT[link list_at.md]

