# BOOST_PP_LIST_REST_N

`BOOST_PP_LIST_REST_N` マクロは *リスト* の先頭の `count` 個の要素以外の *リスト* に展開される。

## Usage

```cpp
BOOST_PP_LIST_REST_N(count, list)
```

## Arguments

- `count` :
	*リスト* の先頭から削除する要素数。

- `list` :
	要素が抽出される *リスト* 。

## Remarks

このマクロは `count` 個の要素を *リスト* の先頭から削除し、残りの要素を *リスト* として返す。

以前、このマクロは `BOOST_PP_WHILE` の中では使えなかったが、現在ではこのような制限はない。
しかし、そのような状況では `BOOST_PP_LIST_REST_N_D` を使うほうがより能率的である。

## See Also

- [`BOOST_PP_LIST_REST_N_D`](list_rest_n_d.md)

## Requirements

Header: &lt;boost/preprocessor/list/rest_n.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/list/rest_n.hpp>

#define LIST (a, (b, (c, (d, BOOST_PP_NIL))))

BOOST_PP_LIST_REST_N(2, LIST) // (c, (d, BOOST_PP_NIL)) に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_REST_N[link list_rest_n.md]

