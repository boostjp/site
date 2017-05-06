# BOOST_PP_LIST_TO_TUPLE

`BOOST_PP_LIST_TO_TUPLE` マクロは *リスト* を *タプル* に変換する。

## Usage

```cpp
BOOST_PP_LIST_TO_TUPLE(list)
```

## Arguments

- `list` :
	変換される *リスト* 。

## Remarks

たとえば、もし *リスト* が `(a, (b, (c, BOOST_PP_NIL)))` ならば、このマクロは

```cpp
(a, b, c)
```

を生成するだろう。

以前、このマクロは `BOOST_PP_FOR` の中では使えなかったが、現在ではこのような制限はない。
しかし、そのような状況では `BOOST_PP_LIST_TO_TUPLE_R` を使うほうがより能率的である。

## See Also

- [`BOOST_PP_LIST_TO_TUPLE_R`](list_to_tuple_r.md)

## Requirements

Header:&lt;boost/preprocessor/list/to_tuple.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/list/to_tuple.hpp>

#define LIST (w, (x, (y, (z, BOOST_PP_NIL))))

BOOST_PP_LIST_TO_TUPLE(LIST) // (w, x, y, z) に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_TO_TUPLE[link list_to_tuple.md]

