# BOOST_PP_ENUM_PARAMS

`BOOST_PP_ENUM_PARAMS` マクロはコンマで区切られたパラメータリストを生成する。

## Usage

```cpp
BOOST_PP_ENUM_PARAMS(count, param)
```

## Arguments

- `count` :
	生成するパラメータの個数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_REPEAT` まで。

- `param` :
	パラメータのテキスト部。
	`BOOST_PP_ENUM_PARAMS` は生成したパラメータと `0` から `count - 1` までの範囲の数字とを結合する。

## Remarks

このマクロはコンマ区切りのシーケンスに展開される:

```cpp
param ## 0, param ## 1, ... param ## count - 1
```

`BOOST_PP_REPEAT` を使った他のマクロから渡されたパラメータ `z` の値を使うためには、`BOOST_PP_ENUM_PARAMS_Z` を見よ。

以前、このマクロは `BOOST_PP_REPEAT` の中で再帰的に使うことは出来なかった。
この制限はもう存在しない。
ライブラリは自動的に利用可能な次の反復の深さを発見できるからである。

## See Also

- [`BOOST_PP_ENUM_PARAMS_Z`](enum_params_z.md)
- [`BOOST_PP_LIMIT_REPEAT`](limit_repeat.md)

## Requirements

Header: &lt;boost/preprocessor/repetition/enum_params.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/repetition/enum_params.hpp>

BOOST_PP_ENUM_PARAMS(3, class T) // class T0, class T1, class T2 に展開される
```
* BOOST_PP_ENUM_PARAMS[link enum_params.md]

