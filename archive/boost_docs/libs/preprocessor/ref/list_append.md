# BOOST_PP_LIST_APPEND

`BOOST_PP_LIST_APPEND` マクロは 2つの *リスト* を追加する。

## Usage

```cpp
BOOST_PP_LIST_APPEND(a, b)
```

## Arguments

- `a` :
	1つ目の *リスト* 。

- `b` :
	2つ目の *リスト* 。

## Remarks

このマクロは 2つのリストを追加する。
たとえば、もし `a` が `(1, (2, (3, BOOST_PP_NIL)))`、`b` が `(4, (5, BOOST_PP_NIL))` ならば、このマクロは

```cpp
(1, (2, (3, (4, (5, BOOST_PP_NIL)))))
```

に展開されるだろう。

以前、このマクロは `BOOST_PP_WHILE` の中では使えなかったが、現在ではこのような制限はない。
しかし、そのような状況では `BOOST_PP_LIST_APPEND_D` を使うほうがより能率的である。

## See Also

- [`BOOST_PP_LIST_APPEND_D`](list_append_d.md)

## Requirements

Header: &lt;boost/preprocessor/list/append.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/list/append.hpp>

#define L1 (a, (b, (c, BOOST_PP_NIL)))
#define L2 (x, (y, (z, BOOST_PP_NIL)))

BOOST_PP_LIST_APPENDe(L1, L2)
	// (a, (b, (c, (x, (y, (z, BOOST_PP_NIL)))))) に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_APPEND[link list_append.md]

