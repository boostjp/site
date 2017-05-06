# BOOST_PP_REPEAT_z

`BOOST_PP_REPEAT_z` マクロは `BOOST_PP_REPEAT` の繰り返しの構築への再入を表す。

## Usage

```cpp
BOOST_PP_REPEAT_ ## z(count, macro, data)
```

## Arguments

- `z` :
	利用可能な次の `BOOST_PP_REPEAT` の次元。

- `count` :
	`macro` を呼び出す繰り返しの回数。
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
macro(z, 0, data) macro(z, 1, data) ... macro(z, count - 1, data)
```

文字列結合を、プリプロセッサのトークン結合演算子ではなく、 `BOOST_PP_CAT` で行わなければいけない時もある。
これは、 `z` の値がマクロ呼び出しそのものである時に起こる。
マクロの展開を可能にするには遅延呼び出しが必要である。
そのような状況で、構文は次のようになる:

```cpp
BOOST_PP_CAT(BOOST_PP_REPEAT_, z)(count, macro, data)
```

## See Also

- [`BOOST_PP_CAT`](cat.md)
- [`BOOST_PP_LIMIT_REPEAT`](limit_repeat.md)
- [`BOOST_PP_REPEAT`](repeat.md)

## Requirements

Header: &lt;boost/preprocessor/repetition/repeat.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/inc.hpp>
#include <boost/preprocessor/punctuation/comma_if.hpp>
#include <boost/preprocessor/repetition/repeat.hpp>

#define TEXT(z, n, text) BOOST_PP_COMMA_IF(n) text

#define TEMPLATE(z, n, _) \
	BOOST_PP_COMMA_IF(n) \
	template< \
		BOOST_PP_REPEAT_ ## z( \
			BOOST_PP_INC(n), \
			TEXT, class \
		) \
	> class T ## n \
	/**/

BOOST_PP_REPEAT(3, TEMPLATE, nil)
	/*
	expands to:
		template<class> class T0,
		template<class, class> class T1,
		template<class, class, class> class T2
	*/
```
* BOOST_PP_COMMA_IF[link comma_if.md]
* BOOST_PP_REPEAT_[link repeat_z.md]
* BOOST_PP_INC[link inc.md]
* BOOST_PP_REPEAT[link repeat.md]

