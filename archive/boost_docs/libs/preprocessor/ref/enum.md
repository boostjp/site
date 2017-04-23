# BOOST_PP_ENUM

`BOOST_PP_ENUM` マクロはコンマで区切られたリストを生成する。

## Usage

```cpp
BOOST_PP_ENUM(count, macro, data)
```

## Arguments

- `count` :
	`macro` を繰り返し呼び出す回数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_REPEAT` まで。

- `macro` :
	`macro(z, n, data)` の形の三項演算。
	このマクロは、利用可能な次の反復の深さ、現在の繰り返し番号、付属の `data` の三引数でもって `BOOST_PP_ENUM` により展開される。

- `data` :
	`macro` に渡される付属データ。

## Remarks

このマクロはコンマ区切りのシーケンスに展開される:

```cpp
macro(z, 0, data), macro(z, 1, data), ... macro(z, count - 1, data)
```

`macro` に渡される `z` の値は、利用可能な次の反復の次元を表す。 
接尾辞 `_Z` を持つ他のマクロの仲間、例えば `BOOST_PP_ENUM_PARAMS` に対しての `BOOST_PP_ENUM_PARAMS_Z`、は内部で `BOOST_PP_REPEAT` を使っている。
これらの `_Z` バージョンを使う必要は厳密にはないが、`z` の値（これは `macro` に渡される）をこれらのマクロに渡すことで、最も効率よく `BOOST_PP_REPEAT` に再入できる。

この `z` の値を単純に他のマクロに渡すのではなく、直接使うためには、`BOOST_PP_ENUM_z` を見よ。

以前、このマクロは `BOOST_PP_REPEAT` の中で再帰的に使うことは出来なかった。
この制限はもう存在しない。
ライブラリは自動的に実行可能な次の反復の深さを発見できるからだ。

## See Also

- [`BOOST_PP_ENUM_`](enum_z.md)
- [`BOOST_PP_LIMIT_REPEAT`](limit_repeat.md)

## Requirements

Header: &lt;boost/preprocessor/repetition/enum.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/repetition/enum.hpp>

#define TEXT(z, n, text) text

BOOST_PP_ENUM(4, TEXT, class) // class, class, class, class に展開される
```
* BOOST_PP_ENUM[link enum.md]

