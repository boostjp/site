# BOOST_PP_WHILE_d

`BOOST_PP_WHILE_d` マクロは `BOOST_PP_WHILE` のループ構築への再入を表す。

## Usage

```cpp
BOOST_PP_WHILE_ ## d(pred, op, state)
```

## Arguments

- `d` :
	利用可能な次の `BOOST_PP_WHILE` の繰り返し。

- `pred` :
	`pred(d, state)` という形の二項述語。
	この述語は `BOOST_PP_WHILE` によって、利用可能な次の繰り返し `d` と現在の `state` に展開される。
	この述語は `0` から `BOOST_PP_LIMIT_MAG` までの範囲の値に展開されなければならない。
	構築は、述語が `0` を返すまでループし続ける。
	この述語が `0` を返したとき、 `BOOST_PP_WHILE` は現在の `state` を返す。

- `op` :
	`op(d, state)` という形の二項演算。
	この演算は `BOOST_PP_WHILE` によって利用可能な次の繰り返し `d` と現在の `state` に展開される。
	このマクロは `pred` が `0` を返すまで、新しい `state` を生成しながら、繰り返し `state` に展開される。

- `state` :
	初期状態。
	この引数はたいてい *タプル* である。

## Remarks

このマクロは `pred(d, state)` が非 0 の間、`op(d, state)` を繰り返す。
すなわち、次のように展開される:

```cpp
op(d, ... op(d, op(d, state)) ... ).
```

ある時は、プリプロセッサのトークンペースト演算子ではなく、`BOOST_PP_CAT` で文字列結合をする必要があるかもしれない。
この時は `d` の値はマクロ呼び出しそのものである。
これを展開するには遅延が必要である。
このような状況での構文は次のようになるだろう。

```cpp
BOOST_PP_CAT(BOOST_PP_WHILE_, d)(pred, op, state).
```

以前、 `d` を直接 `BOOST_PP_WHILE` につなげる (アンダースコアを挟まない) ことが可能だった。
これは現在ではサポートされていない。

## See Also

- [`BOOST_PP_CAT`](cat.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)
- [`BOOST_PP_WHILE`](while.md)

## Requirements

Header: &lt;boost/preprocessor/control/while.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/add.hpp>
#include <boost/preprocessor/arithmetic/dec.hpp>
#include <boost/preprocessor/array/elem.hpp>
#include <boost/preprocessor/array/size.hpp>
#include <boost/preprocessor/control/while.hpp>
#include <boost/preprocessor/tuple/elem.hpp>

#define PRED(d, data) BOOST_PP_TUPLE_ELEM(3, 1, data)

#define OP(d, data) \
	OP_D( \
		d, \
		BOOST_PP_TUPLE_ELEM(3, 0, data), \
		BOOST_PP_TUPLE_ELEM(3, 1, data), \
		BOOST_PP_TUPLE_ELEM(3, 2, data) \
	) \
	/**/

#define OP_D(d, res, i, array) \
	( \
		BOOST_PP_ADD_D( \
			d, res, \
			BOOST_PP_ARRAY_ELEM(BOOST_PP_DEC(i), array)), \
		BOOST_PP_DEC(i), \
		array \
	) \
	/**/

#define ACCUMULATE_D(d, array) \
	BOOST_PP_TUPLE_ELEM( \
		3, 0, \
		BOOST_PP_WHILE_ ## d( \
			PRED, OP, \
			(0, BOOST_PP_ARRAY_SIZE(array), array) \
		) \
	) \
	/**/

#define ARRAY (4, (1, 2, 3, 4))

ACCUMULATE_D(1, ARRAY)// expands to 10
```
* BOOST_PP_TUPLE_ELEM[link tuple_elem.md]
* BOOST_PP_ADD_D[link add_d.md]
* BOOST_PP_ARRAY_ELEM[link array_elem.md]
* BOOST_PP_DEC[link dec.md]
* BOOST_PP_WHILE_[link while_d.md]
* BOOST_PP_ARRAY_SIZE[link array_size.md]

