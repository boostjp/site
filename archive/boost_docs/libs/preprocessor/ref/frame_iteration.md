# BOOST_PP_FRAME_ITERATION

`BOOST_PP_FRAME_ITERATION` マクロは *ファイル繰り返し* の絶対的な深さの反復値に展開される。

## Usage

```cpp
BOOST_PP_FRAME_ITERATION(i)
```

## Arguments

- `i` :
	反復値が検索されるフレームの絶対的深さ。
	有効な値の範囲は `1` から `BOOST_PP_ITERATION_DEPTH()` までである。

## Remarks

このマクロは *ファイル繰り返し* が進行中の時のみ有効である。

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

	#endif

#elif BOOST_PP_ITERATION_DEPTH() == 1

	--
	#define BOOST_PP_ITERATION_PARAMS_2 \
		(3, (1, BOOST_PP_ITERATION(), "file.h"))   \
		/**/

	#include BOOST_PP_ITERATE()

#else

	outer: BOOST_PP_FRAME_ITERATION(1)
	inner: BOOST_PP_FRAME_ITERATION(2)

#endif
```
* BOOST_PP_IS_ITERATING[link is_iterating.md]
* BOOST_PP_ITERATION_PARAMS_1[link iteration_params_x.md]
* BOOST_PP_ITERATE[link iterate.md]
* BOOST_PP_ITERATION_DEPTH[link iteration_depth.md]
* BOOST_PP_ITERATION_PARAMS_2[link iteration_params_x.md]
* BOOST_PP_ITERATION[link iteration.md]
* BOOST_PP_ITERATE[link iterate.md]
* BOOST_PP_FRAME_ITERATION[link frame_iteration.md]

