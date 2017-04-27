# BOOST_PP_ITERATION_FLAGS

`BOOST_PP_ITERATION_FLAGS` マクロは現在の *ファイル繰り返し* の深さに関連するフラグを検索する。

## Usage

```cpp
BOOST_PP_ITERATION_FLAGS()
```

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

	// 1st iteration:
	#define BOOST_PP_ITERATION_PARAMS_1 (4, (1, 10, "file.h", 0x0001))
	#include BOOST_PP_ITERATE()

	// 2nd iteration:
	#define BOOST_PP_ITERATION_PARAMS_1 (4, (1, 10, "file.h", 0x0002))
	#include BOOST_PP_ITERATE()

	#endif

#elif BOOST_PP_ITERATION_DEPTH() == 1 \
	&& BOOST_PP_ITERATION_FLAGS() == 0x0001 \
	/**/

	{ 1st }

#elif BOOST_PP_ITERATION_DEPTH() == 1 \
	&& BOOST_PP_ITERATION_FLAGS() == 0x0002 \
	/**/

	{ 2nd }

#endif
```
* BOOST_PP_IS_ITERATING[link is_iterating.md]
* BOOST_PP_ITERATION_PARAMS_1[link iteration_params_x.md]
* BOOST_PP_ITERATE[link iterate.md]
* BOOST_PP_ITERATION_DEPTH[link iteration_depth.md]
* BOOST_PP_ITERATION_FLAGS[link iteration_flags.md]

