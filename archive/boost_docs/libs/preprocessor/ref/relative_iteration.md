# BOOST_PP_RELATIVE_ITERATION

`BOOST_PP_RELATIVE_FLAGS` マクロは *ファイル繰り返し* の現在の深さと相対的な深さの反復値に展開される。

## Usage

```cpp
BOOST_PP_RELATIVE_ITERATION(i)
```

## Arguments

- `i` :
	その反復値が検索されるフレームの相対的な深さ。
	有効な値の範囲は `0` から `BOOST_PP_ITERATION_DEPTH() - 1` までである。

## Remarks

このマクロは *ファイル繰り返し* が進行中の時のみ有効である。

引数 `i` は現在のフレームより *外側の* フレームの数として解釈される。
それゆえ、 `BOOST_PP_RELATIVE_ITERATION(0)` は `BOOST_PP_ITERATION()` と等価である。

## Requirements

Header: &lt;boost/preprocessor/iteration/iterate.hpp&gt;

## Sample Code

```cpp
// file.h
#if !BOOST_PP_IS_ITERATING

	#ifndef FILE_H_
	#define FILE_H_

	#include <boost/preprocessor/iteration/iterate.hpp>

1st iteration:
	#define BOOST_PP_ITERATION_PARAMS_1 (4, (0, 3, "file.h", 0x0001))
	#include BOOST_PP_ITERATE()

2nd iteration:
	#define BOOST_PP_ITERATION_PARAMS_1 (4, (1, 10, "file.h", 0x0002))
	#include BOOST_PP_ITERATE()

	#endif

#elif BOOST_PP_ITERATION_DEPTH() == 1 \
	&& BOOST_PP_ITERATION_FLAGS() == 0x0001 \
	/**/

	--
	#define BOOST_PP_ITERATION_PARAMS_2 (3, (1, 10, "file.h"))
	#include BOOST_PP_ITERATE()

#elif BOOST_PP_ITERATION_DEPTH() == 1 \
	&& BOOST_PP_ITERATION_FLAGS() == 0x0002 \
	/**/

	--
	#define BOOST_PP_ITERATION_PARAMS_2 \
		(3, (1, BOOST_PP_ITERATION(), "file.h")) \
		/**/
	#include BOOST_PP_ITERATE()

#elif BOOST_PP_ITERATION_DEPTH() == 2 \
	&& BOOST_PP_FRAME_FLAGS(1) == 0x0001 \
	/**/

	--
	#define BOOST_PP_ITERATION_PARAMS_3 \
		(3, (1, BOOST_PP_ITERATION(), "file.h")) \
		/**/
	#include BOOST_PP_ITERATE()

#else // used by both

	previous: BOOST_PP_RELATIVE_ITERATION(1)
	current: BOOST_PP_ITERATION()

#endif
```
* BOOST_PP_IS_ITERATING[link is_iterating.md]
* BOOST_PP_ITERATION_PARAMS_1[link iteration_params_x.md]
* BOOST_PP_ITERATE[link iterate.md]
* BOOST_PP_ITERATION_DEPTH[link iteration_depth.md]
* BOOST_PP_ITERATION_FLAGS[link iteration_flags.md]
* BOOST_PP_ITERATION[link iteration.md]
* BOOST_PP_FRAME_FLAGS[link frame_flags.md]
* BOOST_PP_RELATIVE_ITERATION[link relative_iteration.md]

