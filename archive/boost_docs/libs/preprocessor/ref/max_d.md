# BOOST_PP_MAX_D

`BOOST_PP_MAX_D` マクロは第2引数と第3引数のうち大きい方に展開される。
これは、最も効率的に `BOOST_PP_WHILE` に再入する。

## Usage

```cpp
BOOST_PP_MAX_D(d, x, y)
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

このマクロは二つの引数のうち大きい方を、または両方が等しければその値を返す。

## See Also

- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)
- [`BOOST_PP_MAX`](max.md)

## Requirements

Header: &lt;boost/preprocessor/selection/max.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/list/fold_left.hpp>
#include <boost/preprocessor/selection/max.hpp>

#define LIST (1, (3, (5, (2, (4, BOOST_PP_NIL)))))

#define OP(d, state, x) BOOST_PP_MAX_D(d, state, x)

#define LIST_MAX(list) BOOST_PP_LIST_FOLD_LEFT(OP, 0, LIST)

LIST_MAX(LIST) // expands to 5
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_MAX_D[link max_d.md]
* BOOST_PP_LIST_FOLD_LEFT[link list_fold_left.md]

