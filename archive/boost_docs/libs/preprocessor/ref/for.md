# BOOST_PP_FOR

`BOOST_PP_FOR` マクロは汎用の横断的繰り返しの構築を表す。

## Usage

```cpp
BOOST_PP_FOR(state, pred, op, macro)
```

## Arguments

- `state` :
	初期状態。

- `pred` :
	`pred(r, state)` という形の2項述語。
	このマクロは `0` から `BOOST_PP_LIMIT_MAG` までの範囲の整数値に展開されなければならない。
	`BOOST_PP_FOR` はこの述語が非0を返す間、 `macro` を繰り返し展開する。
	このマクロは利用可能な次の `BOOST_PP_FOR` の繰り返しと、現在の `state` と共に呼び出される。

- `op` :
	`op(r, state)` という形の2項演算。
	この演算は `BOOST_PP_FOR` によって、利用可能な次の `BOOST_PP_FOR` の繰り返しと、現在の `state` と共に展開される。
	このマクロは `pred` が `0` を返すまで、新しい `state` を作りながら、 `state` に繰り返し適用される。

- `macro` :
	`macro(r, state)` という形の2項演算。
	このマクロは `BOOST_PP_FOR` によって、利用可能な次の `BOOST_PP_FOR` の繰り返しと、現在の `state` と共に展開される。
	このマクロは `BOOST_PP_FOR` によって、`pred` が `0` を返すまで繰り返される

## Remarks

このマクロは次のシーケンスに展開される:

```cpp
macro(r, state) macro(r, op(r, state)) ... macro(r, op(r, ... op(r, state) ... ))
```

`pred`, `op`, `macro` に渡される `r` の値は、利用可能な次の `BOOST_PP_FOR` の繰り返しを表す。
`_R` 接尾辞を持つ他のマクロの仲間は内部で `BOOST_PP_FOR` を使っている。
例えば、 `BOOST_PP_LIST_FOR_EACH` や `BOOST_PP_LIST_FOR_EACH_R` である。
これらの `_R` バージョンを使うことは厳密には必要ではないが、(`pred`, `op`, `macro` に渡される) `r` の値をこれらのマクロに渡すことで、最も効率的に `BOOST_PP_FOR` に再入することが出来る。

`r` の値を単純に他のマクロに渡すのではなく直接使うには、 `BOOST_PP_FOR_r` を見よ。

以前、このマクロは `BOOST_PP_FOR` の中で再帰的に使うことが出来なかった。
この制限は今は存在しない。
ライブラリは自動的に、利用可能な次の `BOOST_PP_FOR` の繰り返しを発見することが出来る。

## See Also

- [`BOOST_PP_FOR_`](for_r.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/repetition/for.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/inc.hpp>
#include <boost/preprocessor/comparison/not_equal.hpp>
#include <boost/preprocessor/repetition/for.hpp>
#include <boost/preprocessor/tuple/elem.hpp>

#define PRED(r, state) \
	BOOST_PP_NOT_EQUAL( \
		BOOST_PP_TUPLE_ELEM(2, 0, state), \
		BOOST_PP_INC(BOOST_PP_TUPLE_ELEM(2, 1, state)) \
	) \
	/**/

#define OP(r, state) \
	( \
		BOOST_PP_INC(BOOST_PP_TUPLE_ELEM(2, 0, state)), \
		BOOST_PP_TUPLE_ELEM(2, 1, state) \
	) \
	/**/

#define MACRO(r, state) BOOST_PP_TUPLE_ELEM(2, 0, state)

BOOST_PP_FOR((5, 10), PRED, OP, MACRO) // expands to 5 6 7 8 9 10
```
* BOOST_PP_NOT_EQUAL[link not_equal.md]
* BOOST_PP_TUPLE_ELEM[link tuple_elem.md]
* BOOST_PP_INC[link inc.md]

