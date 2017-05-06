# BOOST_PP_LIST_FOR_EACH_I

`BOOST_PP_LIST_FOR_EACH_I` マクロは *リスト* 中の各要素のためにマクロを繰り返す。

## Usage

```cpp
BOOST_PP_LIST_FOR_EACH_I(macro, data, list)
```

## Arguments

- `macro` :
	`macro (r, data, i, elem )` 形式のマクロ。
	このマクロは *リスト* 中の各要素を伴い `BOOST_PP_LIST_FOR_EACH` によって展開される。
	これは、次の有効な `BOOST_PP_FOR` 反復、補助の *データ* 、現在の要素のインデックスおよび現在の要素を伴い展開される。

- `data` :
	`macro` に渡される補助のデータ。

- `list` :
	`macro` が各要素で実行される *リスト* 。

## Remarks

このマクロは繰り返しを作成する。
もし、*リスト* が `(a, (b, (c, BOOST_PP_NIL)))` ならば、 これは

```cpp
macro(r, data, 0, a) macro(r, data, 1, b) macro(r, data, 2, c)
```

に展開される。

以前、このマクロは `BOOST_PP_FOR` の中では使えなかったが、現在ではこのような制限はない。
しかし、そのような状況では `BOOST_PP_LIST_FOR_EACH_I_R` を使うほうがより能率的である。

## See Also

- [`BOOST_PP_LIST_FOR_EACH_I_R`](list_for_each_i_r.md)

## Requirements

Header: &lt;boost/preprocessor/list/for_each_i.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/cat.hpp>
#include <boost/preprocessor/list/for_each_i.hpp>

#define LIST (w, (x, (y, (z, BOOST_PP_NIL))))

#define MACRO(r, data, i, elem) BOOST_PP_CAT(elem, BOOST_PP_CAT(data, i))

BOOST_PP_LIST_FOR_EACH_I(MACRO, _, LIST) // w_0 x_1 y_2 z_3 に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_CAT[link cat.md]
* BOOST_PP_LIST_FOR_EACH_I[link list_for_each_i.md]

