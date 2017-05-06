# BOOST_PP_LIST_TRANSFORM_D

`BOOST_PP_LIST_TRANSFORM_D` マクロは *リスト* 中の各要素を与えられた変形に従って変形する。
これは `BOOST_PP_WHILE` 内で呼ばれる際には最も効率よく機能する。

## Usage

```cpp
BOOST_PP_LIST_TRANSFORM_D(d, op, data, list)
```

## Arguments

- `d` :
	次の有効な `BOOST_PP_WHILE` 反復。

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

## See Also

- [`BOOST_PP_LIST_TRANSFORM`](list_transform.md)

## Requirements

Header: &lt;boost/preprocessor/list/transform.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/inc.hpp>
#include <boost/preprocessor/list/fold_right.hpp>
#include <boost/preprocessor/list/transform.hpp>

#define A (1, (2, (3, (4, BOOST_PP_NIL))))
#define B (A, (A, (A, (A, BOOST_PP_NIL))))

#define OP_T(d, data, x) BOOST_PP_INC(x)
#define OP(d, state, x) (BOOST_PP_LIST_TRANSFORM_D(d, OP_T, 2, x), state)

BOOST_PP_LIST_FOLD_RIGHT(OP, BOOST_PP_NIL, B)
/*
	((2, (3, (4, (5, BOOST_PP_NIL)))), ((2, (3, (4, (5, BOOST_PP_NIL)))),
	((2, (3, (4, (5, BOOST_PP_NIL)))), ((2, (3, (4, (5, BOOST_PP_NIL)))),
	BOOST_PP_NIL))))
	に展開される
*/
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_INC[link inc.md]
* BOOST_PP_LIST_TRANSFORM_D[link list_transform_d.md]
* BOOST_PP_LIST_FOLD_RIGHT[link list_fold_right.md]

