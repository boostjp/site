# BOOST_PP_LIST_SIZE

`BOOST_PP_LIST_SIZE` マクロは *リスト* のサイズに展開される。

## Usage

```cpp
BOOST_PP_LIST_SIZE(list)
```

## Arguments

- `list` :
	サイズが計算される *リスト* 。

## Remarks

以前、このマクロは `BOOST_PP_WHILE` の中では使えなかったが、現在ではこのような制限はない。
しかし、そのような状況では `BOOST_PP_LIST_SIZE_D` を使うほうがより能率的である。

## See Also

- [`BOOST_PP_LIST_SIZE_D`](list_size_d.md)

## Requirements

Header: &lt;boost/preprocessor/list/size.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/list/size.hpp>

#define LIST (0, (1, (2, (3, BOOST_PP_NIL))))

BOOST_PP_LIST_SIZE(LIST) // 4 に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_SIZE[link list_size.md]

