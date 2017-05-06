# BOOST_PP_MIN_D

`BOOST_PP_MIN_D` マクロは第2引数と第3引数のうち小さい方に展開される。
これは、最も効率的に `BOOST_PP_WHILE` に再入する。

## Usage

```cpp
BOOST_PP_MIN_D(d, x, y)
```

## Arguments

- `d` :
	利用可能な次の `BOOST_PP_WHILE` の繰り返し。

- `x` :
	第1のオペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

- `y` :
	第2のオペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

## Remarks

このマクロは二つの引数のうち小さい方を、または両方が等しければその値を返す。

## See Also

- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)
- [`BOOST_PP_MIN`](min.md)

## Requirements

Header: &lt;boost/preprocessor/selection/min.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/list/fold_left.hpp>
#include <boost/preprocessor/selection/min.hpp>

#define LIST (1, (3, (5, (2, (4, BOOST_PP_NIL)))))

#define OP(d, state, x) BOOST_PP_MIN_D(d, state, x)

#define LIST_MAX(list) BOOST_PP_LIST_FOLD_LEFT(OP, 20, LIST)

LIST_MIN(LIST) // expands to 1
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_MIN_D[link min_d.md]
* BOOST_PP_LIST_FOLD_LEFT[link list_fold_left.md]

