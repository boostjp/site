# BOOST_PP_LIST_FOR_EACH

`BOOST_PP_LIST_FOR_EACH` マクロは *リスト* 中の各要素のためにマクロを繰り返す。

## Usage

```cpp
BOOST_PP_LIST_FOR_EACH(macro, data, list)
```

## Arguments

- `macro` :
	`macro (r, data, elem )` 形式の 3項マクロ。
	このマクロは *リスト* 中の各要素を伴い `BOOST_PP_LIST_FOR_EACH` によって展開される。
	これは、次の有効な `BOOST_PP_FOR` 反復、補助の *データ* および現在の要素を伴い展開される。

- `data` :
	`macro` に渡される補助のデータ。

- `list` :
	`macro` が各要素で実行される *リスト* 。

## Remarks

このマクロは繰り返しを作成する。
もし、*リスト* が `(a, (b, (c, BOOST_PP_NIL)))` ならば、 これは

```cpp
macro(r, data, a) macro(r, data, b) macro(r, data, c)
```

に展開される。

以前、このマクロは `BOOST_PP_FOR` の中では使えなかったが、現在ではこのような制限はない。
しかし、そのような状況では `BOOST_PP_LIST_FOR_EACH_R` を使うほうがより能率的である。

## See Also

- [`BOOST_PP_LIST_FOR_EACH_R`](list_for_each_r.md)

## Requirements

Header: &lt;boost/preprocessor/list/for_each.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/cat.hpp>
#include <boost/preprocessor/list/for_each.hpp>

#define LIST (w, (x, (y, (z, BOOST_PP_NIL))))

#define MACRO(r, data, elem) BOOST_PP_CAT(elem, data)

BOOST_PP_LIST_FOR_EACH(MACRO, _, LIST) // w_ x_ y_ z_ に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_CAT[link cat.md]
* BOOST_PP_LIST_FOR_EACH[link list_for_each.md]

