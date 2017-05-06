# BOOST_PP_REPEAT_FROM_TO_z

`BOOST_PP_REPEAT_FROM_TO_z` マクロは `BOOST_PP_REPEAT_FROM_TO` の繰り返しの構築への再入を表す。

## Usage

```cpp
BOOST_PP_REPEAT_FROM_TO_ ## z(first, last, macro, data)
```

## Arguments

- `z` :
	利用可能な次の `BOOST_PP_REPEAT` の次元。

- `first` :
	繰り返しの下限。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

- `last` :
	繰り返しの上限。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

- `macro` :
	`macro(z, n, data)` という形の 3つ組の演算。
	このマクロは `BOOST_PP_REPEAT` によって、
	利用可能な次の繰り返しの深さ、現在の繰り返し回数、付属の `data` に展開される。

- `data` :
	`macro` に渡される付属のデータ。

## Remarks

このマクロは次のシーケンスに展開される:

```cpp
macro(z, first, data) macro(z, first + 1, data) ... macro(z, last - 1, data)
```

繰り返しの回数 (つまり、 `last - first` は `BOOST_PP_LIMIT_REPEAT` を越えてはならない。

文字列結合を、プリプロセッサのトークン結合演算子ではなく、 `BOOST_PP_CAT` で行わなければいけない時もある。
これは、 `z` の値がマクロ呼び出しそのものである時に起こる。
マクロの展開を可能にするには遅延呼び出しが必要である。
そのような状況で、構文は次のようになる:

```cpp
BOOST_PP_CAT(BOOST_PP_REPEAT_FROM_TO_, z)(count, macro, data).
```

## See Also

- [`BOOST_PP_CAT`](cat.md)
- [`BOOST_PP_LIMIT_REPEAT`](limit_repeat.md)
- [`BOOST_PP_REPEAT`](repeat.md)

## Requirements

Header: &lt;boost/preprocessor/repetition/repeat_from_to.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/repetition/repeat_from_to.hpp>

#define TEXT(z, n, data) n data

#define MACRO(z, n, data) \
	( \
		BOOST_PP_REPEAT_FROM_TO_ ## z( \
			1, 4, \
			TEXT, xyz \
		) \
	) \
	/**/

BOOST_PP_REPEAT(3, MACRO, _)
	/*
		expands to:
		(1 xyz 2 xyz 3 xyz)
		(1 xyz 2 xyz 3 xyz)
		(1 xyz 2 xyz 3 xyz)
	*/
```
* BOOST_PP_REPEAT_FROM_TO_[link repeat_from_to_z.md]
* BOOST_PP_REPEAT[link repeat.md]

