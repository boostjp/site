# BOOST_PP_REPEAT_1ST

`BOOST_PP_REPEAT_1ST` マクロは `BOOST_PP_REPEAT` の1番目の次元を表す。

## Usage

```cpp
BOOST_PP_REPEAT_1ST(count, macro, data)
```

## Arguments

- `count` :
	`macro` を呼び出す繰り返しの回数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_REPEAT` までである。

- `macro` :
	`macro(z, n, data)` という形の3つ組の演算。
	このマクロは `BOOST_PP_REPEAT_1ST` によって利用可能な次の繰り返しの深さ、現在の繰り返し回数、付属の `data` 引数に展開される。

- `data` :
	`macro` に渡される付属のデータ。

## Remarks

このマクロは次のシーケンスに展開される:

```cpp
macro(z, 0, data) macro(z, 1, data) ... macro(z, count - 1, data)
```

`macro` に渡される `z` の値は利用可能な次の繰り返しの次元を表す。
接尾辞 `_Z` をもつ他のマクロの仲間は内部で `BOOST_PP_REPEAT` を利用している -
例えば `BOOST_PP_ENUM_PARAMS` や `BOOST_PP_ENUM_PARAMS_Z` など。
これらの `_Z` バージョンの利用は厳密には必要ではない。
しかし、 (`macro` に渡される) `z` の値をこれらのマクロに渡すことで、最も効率的に `BOOST_PP_REPEAT` に再入出来る。

この `z` の値を、単純に別のマクロに渡すのではなく、直接使うためには、`BOOST_PP_REPEAT_z` を見よ。

このマクロは推奨されていない。
過去のバージョンとの互換性のためだけに存在している。
代わりに `BOOST_PP_REPEAT` を使うこと。

## See Also

- [`BOOST_PP_LIMIT_REPEAT`](limit_repeat.md)
- [`BOOST_PP_REPEAT`](repeat.md)
- [`BOOST_PP_REPEAT_z`](repeat_z.md)

## Requirements

Header: &lt;boost/preprocessor/repetition/repeat.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/repetition/repeat.hpp>

#define DECL(z, n, text) text ## n = n;

BOOST_PP_REPEAT_1ST(5, DECL, int x)
```
* BOOST_PP_REPEAT_1ST[link repeat_1st.md]

