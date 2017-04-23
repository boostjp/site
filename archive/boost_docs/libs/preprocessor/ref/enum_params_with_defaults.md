# BOOST_PP_ENUM_PARAMS_WITH_DEFAULTS

`BOOST_PP_ENUM_PARAMS_WITH_A_DEFAULT` マクロはコンマで区切られたデフォルト引数付きのパラメータリストを生成する。

## Usage

```cpp
BOOST_PP_ENUM_PARAMS_WITH_DEFAULTS(count, param, def)
```

## Arguments

- `count` :
	生成するパラメータの個数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_REPEAT` まで。

- `param` :
	パラメータのテキスト部。
	`BOOST_PP_ENUM_PARAMS_WITH_DEFAULTS` は生成したパラメータと `0` から `count - 1` までの範囲の数字とを結合する。

- `def` :
	それぞれのパラメータにかかるデフォルト値。
	`BOOST_PP_ENUM_PARAMS_WITH_DEFAULTS` は生成したデフォルト引数と `0` から `count - 1` までの範囲の数字とを結合する。

## Remarks

このマクロはコンマ区切りのシーケンスに展開される:

```cpp
param ## 0 = def ## 0, param ## 1 = def ## 1, ... param ## count - 1 = def ## count - 1
```

以前、このマクロは `BOOST_PP_REPEAT` の中で再帰的に使うことは出来なかった。
この制限はもう存在しない。
ライブラリは自動的に利用可能な次の反復の深さを発見できるからである。

このマクロは廃止された。
これは後方互換性のためにのみ存在する。
代わりに `BOOST_PP_ENUM_BINARY_PARAMS` を用いよ。

```cpp
BOOST_PP_ENUM_BINARY_PARAMS(count, param, = def)
```

## See Also

- [`BOOST_PP_ENUM_BINARY_PARAMS`](enum_binary_params.md)
- [`BOOST_PP_LIMIT_REPEAT`](limit_repeat.md)

## Requirements

Header: &lt;boost/preprocessor/repetition/enum_params_with_defaults.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/repetition/enum_params_with_defaults.hpp>

BOOST_PP_ENUM_PARAMS_WITH_DEFAULTS(3, class T, U)
	// T0 = U0, T1 = U1, T2 = U2 に展開される

BOOST_PP_ENUM_BINARY_PARAMS(3, class T, = U)
	// T0 = U0, T1 = U1, T2 = U2 に展開される
```
* BOOST_PP_ENUM_PARAMS_WITH_DEFAULTS[link enum_params_with_defaults.md]
* BOOST_PP_ENUM_BINARY_PARAMS[link enum_binary_params.md]

