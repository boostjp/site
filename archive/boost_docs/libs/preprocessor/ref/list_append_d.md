# BOOST_PP_LIST_APPEND_D

`BOOST_PP_LIST_APPEND_D` マクロは 2つの *リスト* を追加する。
これは `BOOST_PP_WHILE` 内で呼ばれる際には最も効率よく機能する。

## Usage

```cpp
BOOST_PP_LIST_APPEND_D(d, a, b)
```

## Arguments

- `d` :
	次の有効な `BOOST_PP_WHILE` 反復。

- `a` :
	1つ目の *リスト* 。

- `b` :
	2つ目の *リスト* 。

## Remarks

このマクロは 2つのリストを追加する。
たとえば、もし `a` が `(1, (2, (3, BOOST_PP_NIL)))`、 `b` が `(4, (5, BOOST_PP_NIL))` ならば、このマクロは

```cpp
(1, (2, (3, (4, (5, BOOST_PP_NIL)))))
```

に展開されるだろう。

## See Also

- [`BOOST_PP_LIST_APPEND`](list_append.md)

## Requirements

Header: &lt;boost/preprocessor/list/append.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/dec.hpp>
#include <boost/preprocessor/control/while.hpp>
#include <boost/preprocessor/list/append.hpp>
#include <boost/preprocessor/tuple/elem.hpp>

#define LIST (1, (2, (3, BOOST_PP_NIL)))

#define PRED(d, state) BOOST_PP_TUPLE_ELEM(3, 1, state)

#define OP(d, state) \
	( \
		BOOST_PP_LIST_APPEND_D( \
			d, BOOST_PP_TUPLE_ELEM(3, 0, state), \
			BOOST_PP_TUPLE_ELEM(3, 2, state) \
		), \
		BOOST_PP_DEC( \
			BOOST_PP_TUPLE_ELEM(3, 1, state) \
		), \
		BOOST_PP_TUPLE_ELEM(3, 2, state) \
	) \
	/**/

#define LIST_MULTIPLY(c, list) \
	BOOST_PP_TUPLE_ELEM( \
		3, 0, \
		BOOST_PP_WHILE( \
			PRED, OP, \
			(BOOST_PP_NIL, c, list) \
		) \
	) \
	/**/

LIST_MULTIPLY(3, LIST)
	// (1, (2, (3, (1, (2, (3, (1, (2, (3, BOOST_PP_NIL))))))))) に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_TUPLE_ELEM[link tuple_elem.md]
* BOOST_PP_LIST_APPEND_D[link list_append_d.md]
* BOOST_PP_DEC[link dec.md]
* BOOST_PP_WHILE[link while.md]

