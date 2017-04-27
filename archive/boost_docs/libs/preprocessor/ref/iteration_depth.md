# BOOST_PP_ITERATION_DEPTH

`BOOST_PP_ITERATION_DEPTH` マクロは現在の *ファイル繰り返し* の深さに展開される。

## Usage

```cpp
BOOST_PP_ITERATION_DEPTH()
```

## Remarks

もし *ファイル繰り返し* が進行中でなければ、このマクロは `0` に展開される。
相でなければ *ファイル繰り返し* の現在の深さに展開される。

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

	+ depth BOOST_PP_ITERATION_DEPTH()
	// ...

	#define BOOST_PP_ITERATION_PARAMS_2 \
		(3, (1, BOOST_PP_ITERATION(), "file.h")) \
		/**/

	#include BOOST_PP_ITERATE()

#elif BOOST_PP_ITERATION_DEPTH() == 2

	- depth BOOST_PP_ITERATION_DEPTH()
	// ...

#endif
```
* BOOST_PP_IS_ITERATING[link is_iterating.md]
* BOOST_PP_ITERATION_PARAMS_1[link iteration_params_x.md]
* BOOST_PP_ITERATE[link iterate.md]
* BOOST_PP_ITERATION_DEPTH[link iteration_depth.md]
* BOOST_PP_ITERATION[link iteration.md]

