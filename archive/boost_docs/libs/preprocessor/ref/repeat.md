# BOOST_PP_REPEAT

`BOOST_PP_REPEAT` マクロは高速な横断的繰り返しを表す。

## Usage

```cpp
BOOST_PP_REPEAT(count, macro, data)
```

## Arguments

- `count` :
	`macro` を呼ぶ繰り返しの回数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_REPEAT` までである。

- `macro` :
	`macro(z, n, data)` という形の 3つ組の演算。
	このマクロは `BOOST_PP_REPEAT` によって、 利用可能な次の繰り返しの深さ、現在の繰り返し回数、付属の `data` に展開される。

- `data` :
	`macro` に渡される付属のデータ。

## Remarks

このマクロは次のシーケンスに展開される:

```cpp
macro(z, 0, data) macro(z, 1, data) ... macro(z, count - 1, data)
```

`macro` に渡される `z` の値は利用可能な次の繰り返し次元を表す。
`_Z` 接尾辞をもつ他のマクロとその仲間は内部で、`BOOST_PP_REPEAT` を利用している - 
例えば、 `BOOST_PP_ENUM_PARAMS` と `BOOST_PP_ENUM_PARAMS_Z` などである。
これらの `_Z` バージョンを使うことは厳密には必要ではないが、(`macro` に渡される) `z` の値をこれらのマクロに渡すことで、最も効率的に `BOOST_PP_REPEAT` に再入することが出来る。

この `z` の値を、単純に別のマクロに渡すのではなく、直接使うためには、`BOOST_PP_REPEAT_z` を見よ。

以前、このマクロは `BOOST_PP_REPEAT` の中で再帰的に使うことは出来なかった。
この制限はもう存在しない。
ライブラリは自動的に、利用可能な次の繰り返しの深さを検出できる。

## See Also

- [`BOOST_PP_LIMIT_REPEAT`](limit_repeat.md)
- [`BOOST_PP_REPEAT_z`](repeat_z.md)

## Requirements

Header: &lt;boost/preprocessor/repetition/repeat.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/repetition/repeat.hpp>

#define DECL(z, n, text) text ## n = n;

BOOST_PP_REPEAT(5, DECL, int x)
```
* BOOST_PP_REPEAT[link repeat.md]

