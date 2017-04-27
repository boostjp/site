# BOOST_PP_ITERATE

`BOOST_PP_ITERATE` マクロは *ファイル繰り返し* を開始する。

## Usage

```cpp
#include BOOST_PP_ITERATE()
```

## Remarks

このマクロへの引数は *外部で名前付けされた引数* として渡される。
これには二つの方法がある。
ひとつは `BOOST_PP_FILENAME_x` によるもので、
ひとつは `BOOST_PP_ITERATION_PARAMS_x` に寄るものである。

*ファイル繰り返し* を行うには3つの情報が必要である。
まず、繰り返されるファイルの名前であり、これは `BOOST_PP_FILENAME_x` *又は* `BOOST_PP_ITERATION_PARAMS_x` の一部として渡される。
*ファイル繰り返し* 機構は、下限から上限まで (これが、2番目と3番目の *必要とされる* パラメータである) の範囲の反復値で、 このファイルを繰り返しインクルードする。
これらの上限と下限は、 `BOOST_PP_ITERATION_LIMITS` *又は* `BOOST_PP_ITERATION_PARAMS_x` の一部として渡される。

省略可能な4番目のパラメータを渡すことが出来る。
これは繰り返しに関するフラグである。
これらのフラグは基本的には、ある繰り返しを、同じファイルの別の繰り返しから区別するのに役立つ。
このパラメータは `BOOST_PP_ITERATION_PARAMS_x` によってのみ渡すことが出来る。

*ファイル繰り返し* の進行中は、 `BOOST_PP_IS_ITERATING` が `1` に定義される。

## See Also

- [`BOOST_PP_FILENAME_x`](filename_x.md)
- [`BOOST_PP_IS_ITERATING`](is_iterating.md)
- [`BOOST_PP_ITERATION_LIMITS`](iteration_limits.md)
- [`BOOST_PP_ITERATION_PARAMS_x`](iteration_params_x.md)

## Requirements

Header: &lt;boost/preprocessor/iteration/iterate.hpp&gt;

## Sample Code

```cpp
// file.h
#if !BOOST_PP_IS_ITERATING

	#ifndef FILE_H_
	#define FILE_H_

	#include <boost/preprocessor/iteration/iterate.hpp>

	#define BOOST_PP_ITERATION_PARAMS_1 (3, (1, 10, "file.h"))
	#include BOOST_PP_ITERATE()

	#define BOOST_PP_FILENAME_1 "file.h"
	#define BOOST_PP_ITERATION_LIMITS (11, 20)
	#include BOOST_PP_ITERATE()

	#endif

#else

	current iteration value is BOOST_PP_ITERATION()

#endif
```
* BOOST_PP_IS_ITERATING[link is_iterating.md]
* BOOST_PP_ITERATION_PARAMS_1[link iteration_params_x.md]
* BOOST_PP_ITERATE[link iterate.md]
* BOOST_PP_FILENAME_1[link filename_x.md]
* BOOST_PP_ITERATION_LIMITS[link iteration_limits.md]
* BOOST_PP_ITERATION[link iteration.md]

