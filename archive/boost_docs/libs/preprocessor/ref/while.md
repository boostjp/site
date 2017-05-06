# BOOST_PP_WHILE

`BOOST_PP_WHILE` マクロはループの構築を表す。

## Usage

```cpp
BOOST_PP_WHILE(pred, op, state)
```

## Arguments

- `pred` :
	`pred(d, state)` という形の二項述語。
	この述語は `BOOST_PP_WHILE` によって利用可能な次の繰り返し `d` と現在の `state` に展開される。
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

`pred` と `op` の両方に渡される `d` の値は、利用可能な次の繰り返しを表す。
接尾辞 `_D` を持つ他のマクロの仲間は内部で `BOOST_PP_WHILE` を使っている。
例えば、 `BOOST_PP_ADD` や `BOOST_PP_ADD_D`である。
これらの `_D` バージョンを使う必要は厳密にはないが、`d` の値 (これは `pred` や `op` に渡される) をこれらのマクロに渡すことで、最大限効果的に `BOOST_PP_WHILE` に再入できる。

この `d` の値を単純に他のマクロに渡すのではなく、直接使うためには、`BOOST_PP_WHILE_d` を見よ。

以前、このマクロは `BOOST_PP_WHILE` の中で再帰的に使うことは出来なかった。
この制限はもう存在しない。
ライブラリは自動的に次の繰り返しを発見できるからである。

## See Also

- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)
- [`BOOST_PP_WHILE_d`](while_d.md)

## Requirements

Header: &lt;boost/preprocessor/control/while.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/add.hpp>
#include <boost/preprocessor/control/while.hpp>
#include <boost/preprocessor/tuple/elem.hpp>

#define PRED(n, state) BOOST_PP_TUPLE_ELEM(2, 1, state)

#define OP(d, state) \
	OP_D( \
		d, \
		BOOST_PP_TUPLE_ELEM(2, 0, state), \
		BOOST_PP_TUPLE_ELEM(2, 1, state) \
	) \
	/**/

#define OP_D(d, res, c) \
	( \
		BOOST_PP_ADD_D( \
			d, \
			res, \
			BOOST_PP_DEC(c) \
		), \
		BOOST_PP_DEC(c) \
	) \
	/**/

#define SUMMATION(n) \
	BOOST_PP_TUPLE_ELEM( \
		2, 0, \
		BOOST_PP_WHILE(PRED, OP, (n, n)) \
	) \
	/**/

SUMMATION(3) // expands to 6
SUMMATION(4) // expands to 10
```
* BOOST_PP_TUPLE_ELEM[link tuple_elem.md]
* BOOST_PP_ADD_D[link add_d.md]
* BOOST_PP_DEC[link dec.md]
* BOOST_PP_WHILE[link while.md]

