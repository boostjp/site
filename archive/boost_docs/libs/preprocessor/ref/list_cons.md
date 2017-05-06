# BOOST_PP_LIST_CONS

`BOOST_PP_LIST_CONS` マクロは *リスト* コンストラクタである。

## Usage

```cpp
BOOST_PP_LIST_CONS(head, tail)
```

## Arguments

- `head` :
	*リスト* の中の要素。

- `tail` :
	*リスト* 、または `BOOST_PP_LIST_NIL`、または `BOOST_PP_NIL` のどれか 1つ。

## Remarks

このマクロは新しい先頭を既存の *リスト* に追加するか、または `BOOST_PP_LIST_NIL` から *リスト* を作成する。

このマクロはもはや必要でない。
たとえば、

```cpp
BOOST_PP_LIST_CONS(a, BOOST_PP_LIST_CONS(b, BOOST_PP_LIST_NIL)))
```

は、次の明示的な書き方がある：

```cpp
(a, (b, BOOST_PP_NIL))
```

このために、このマクロは廃止された。

## See Also

- [`BOOST_PP_LIST_NIL`](list_nil.md)
- [`BOOST_PP_NIL`](nil.md)

## Requirements

Header: &lt;boost/preprocessor/list/adt.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/list/adt.hpp>

#define OLD \
	BOOST_PP_LIST_CONS( \
		a, \
		BOOST_PP_LIST_CONS( \
			b, \
			BOOST_PP_LIST_CONS( \
				c, \
				BOOST_PP_LIST_NIL \
			) \
		) \
	) \
	/**/

#define NEW (a, (b, (c, BOOST_PP_NIL)))

BOOST_PP_LIST_FIRST(OLD) == BOOST_PP_LIST_FIRST(NEW)
	// a == a に展開される

BOOST_PP_LIST_REST(OLD) == BOOST_PP_LIST_REST(NEW)
	// (b, (c, BOOST_PP_NIL)) == (b, (c, BOOST_PP_NIL)) に展開される
```
* BOOST_PP_LIST_CONS[link list_cons.md]
* BOOST_PP_LIST_NIL[link list_nil.md]
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_FIRST[link list_first.md]
* BOOST_PP_LIST_REST[link list_rest.md]

