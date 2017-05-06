# BOOST_PP_LIST_FIRST_N

`BOOST_PP_LIST_FIRST_N` マクロは *リスト* の先頭から *count* 個の要素の  *リスト* に展開される。

## Usage

```cpp
BOOST_PP_LIST_FIRST_N(count, list)
```

## Arguments

- `count` :
	抽出する要素数。

- `list` :
	要素が抽出される *リスト* 。

## Remarks

このマクロは *リスト* の先頭から *count* 個の要素を抽出し、それらを *リスト* として返す。

以前、このマクロは `BOOST_PP_WHILE` の中では使えなかったが、現在ではこのような制限はない。
しかし、そのような状況では `BOOST_PP_LIST_FIRST_N_D` を使うほうがより能率的である。

## See Also

- [`BOOST_PP_LIST_FIRST_N_D`](list_first_n_d.md)

## Requirements

Header: &lt;boost/preprocessor/list/first_n.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/list/first_n.hpp>

#define LIST (a, (b, (c, BOOST_PP_NIL)))

BOOST_PP_LIST_FIRST_N(2, LIST) // (a, (b, BOOST_PP_NIL)) に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_FIRST_N[link list_first_n.md]

