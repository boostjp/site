# BOOST_PP_ITERATION

`BOOST_PP_ITERATION` マクロは現在の *ファイル繰り返し*の深さの反復値に展開される。

## Usage

```cpp
BOOST_PP_ITERATION()
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

	#define BOOST_PP_ITERATION_PARAMS_1 (3, (1, 3, "file.h"))
	#include BOOST_PP_ITERATE()

	#endif

#elif BOOST_PP_ITERATION_DEPTH() == 1

	value == BOOST_PP_ITERATION()

#endif
```
* BOOST_PP_IS_ITERATING[link is_iterating.md]
* BOOST_PP_ITERATION_PARAMS_1[link iterations_params_x.md]
* BOOST_PP_ITERATE[link iterate.md]
* BOOST_PP_ITERATION_DEPTH[link iteration_depth.md]
* BOOST_PP_ITERATION[link iteration.md]

