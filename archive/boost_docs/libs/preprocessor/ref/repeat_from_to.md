# BOOST_PP_REPEAT_FROM_TO

`BOOST_PP_REPEAT_FROM_TO` マクロは高速な横断的繰り返しの構築を表す。

## Usage

```cpp
BOOST_PP_REPEAT_FROM_TO(first, last, macro, data)
```

## Arguments

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

`macro` に渡される `z` の値は利用可能な次の繰り返し次元を表す。
`_Z` 接尾辞をもつ他のマクロとその仲間は内部で、 `BOOST_PP_REPEAT` を利用している -
例えば、 `BOOST_PP_ENUM_PARAMS` と `BOOST_PP_ENUM_PARAMS_Z` などである。
これらの `_Z` バージョンを使うことは厳密には必要ではないが、 (`macro` に渡される) `z` の値をこれらのマクロに渡すことで、最も効率的に `BOOST_PP_REPEAT` に再入することが出来る。

この `z` の値を、単純に別のマクロに渡すのではなく、直接使うためには、`BOOST_PP_REPEAT_FROM_TO_z` を見よ。

以前、このマクロは `BOOST_PP_REPEAT` の中で再帰的に使うことは出来なかった。
この制限はもう存在しない。
ライブラリは自動的に、利用可能な次の繰り返しの深さを検出できる。

このマクロは `BOOST_PP_WHILE` も利用している。
このため、 `BOOST_PP_WHILE` にへの理想的な再入のために、このマクロの2つの変種がある。
つまり、 `BOOST_PP_REPEAT_FROM_TO_D` と `BOOST_PP_REPEAT_FROM_TO_D_z` である。

## See Also

- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)
- [`BOOST_PP_LIMIT_REPEAT`](limit_repeat.md)
- [`BOOST_PP_REPEAT_FROM_TO_D`](repeat_from_to_d.md)
- [`BOOST_PP_REPEAT_FROM_TO_D_z`](repeat_from_to_d_z.md)
- [`BOOST_PP_REPEAT_FROM_TO_z`](repeat_from_to_z.md)

## Requirements

Header: &lt;boost/preprocessor/repetition/repeat_from_to.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/cat.hpp>
#include <boost/preprocessor/repetition/repeat_from_to.hpp>

#define DECL(z, n, text) BOOST_PP_CAT(text, n) = n;

BOOST_PP_REPEAT_FROM_TO(5, 10, DECL, int x)
	/*
		expands to:
		int x5 = 5; int x6 = 6; int x7 = 7;
		int x8 = 8; int x9 = 9;
	*/
```
* BOOST_PP_CAT[link cat.md]
* BOOST_PP_REPEAT_FROM_TO[link repeat_from_to.md]

