# BOOST_PP_LIST_TRANSFORM

`BOOST_PP_LIST_TRANSFORM` マクロは *リスト* 中の各要素を与えられた変形に従って変形する。

## Usage

```cpp
BOOST_PP_LIST_TRANSFORM(op, data, list)
```

## Arguments

- `op` :
	`op (d, data, elem )` 形式の 3項述語。
	この変形は、次の有効な `BOOST_PP_WHILE` 反復、補助の *データ* および *リスト* 中の現在の要素を伴い、*リスト* 中の各要素のために `BOOST_PP_LIST_TRANSFORM` によって展開される。

- `data` :
	`pred` に渡される補助のデータ。

- `list` :
	変形される *リスト* 。

## Remarks

このマクロは *リスト* 中の各要素のために `op` を展開する。
これは各呼び出しの結果から新しい *リスト* を作成する。
たとえば、もし *リスト* が `(a, (b, (c, BOOST_PP_NIL)))` ならば、このマクロは

```cpp
(op(d, data, a), (op(d, data, b), (op(d, data, c), BOOST_PP_NIL)))
```

に展開される。

以前、このマクロは `BOOST_PP_WHILE` の中では使えなかったが、現在ではこのような制限はない。
しかし、そのような状況では `BOOST_PP_LIST_TRANSFORM_D` を使うほうがより能率的である。

## See Also

- [`BOOST_PP_LIST_TRANSFORM_D`](list_transform_d.md)

## Requirements

Header: &lt;boost/preprocessor/list/transform.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/dec.hpp>
#include <boost/preprocessor/list/transform.hpp>

#define LIST (1, (3, (2, (5, BOOST_PP_NIL))))

#define OP(d, data, elem) BOOST_PP_DEC(elem)

BOOST_PP_LIST_TRANSFORM(OP, 3, LIST)
	// (0, (2, (1, (4, BOOST_PP_NIL)))) に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_DEC[link dec.md]
* BOOST_PP_LIST_TRANSFORM[link list_transform.md]

