# BOOST_PP_LIST_REVERSE

`BOOST_PP_LIST_REVERSE` マクロは 逆順の *リスト* に展開される。

## Usage

```cpp
BOOST_PP_LIST_REVERSE(list)
```

## Arguments

- `list` :
	逆順にされる *リスト* 。

## Remarks

以前、このマクロは `BOOST_PP_WHILE` の中では使えなかったが、現在ではこのような制限はない。
しかし、そのような状況では `BOOST_PP_LIST_REVERSE_D` を使うほうがより能率的である。

## See Also

- [`BOOST_PP_LIST_REVERSE_D`](list_reverse_d.md)

## Requirements

Header: &lt;boost/preprocessor/list/reverse.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/list/reverse.hpp>

#define LIST (0, (1, (2, (3, BOOST_PP_NIL))))

BOOST_PP_LIST_REVERSE(LIST) // (3, (2, (1, (0, BOOST_PP_NIL)))) に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_REVERSE[link list_reverse.md]

