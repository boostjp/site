# BOOST_PP_LIST_NIL

`BOOST_PP_LIST_NIL` マクロは空 *リスト* コンストラクタである。

## Usage

```cpp
BOOST_PP_LIST_NIL
```

## Remarks

このマクロは *リスト* の終わりを表わす。

このマクロは重要でない。
これは単に `BOOST_PP_NIL` に展開される。
このために、このマクロは廃止された。

## See Also

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

BOOST_PP_LIST_REST(OLD) == BOOST_PP_LIST_RESTK(NEW)
	// (b, (c, BOOST_PP_NIL)) == (b, (c, BOOST_PP_NIL)) に展開される
```
* BOOST_PP_LIST_CONS[link list_cons.md]
* BOOST_PP_LIST_NIL[link list_nil.md]
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_FIRST[link list_first.md]
* BOOST_PP_LIST_RESTK[link list_rest.md]

