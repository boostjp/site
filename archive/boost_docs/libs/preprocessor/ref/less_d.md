# BOOST_PP_LESS_D

`BOOST_PP_LESS_D` マクロは 2つの値の大きさを比較する。
これは `BOOST_PP_WHILE` 内で呼ばれる際には最も効率よく機能する。

## Usage

```cpp
BOOST_PP_LESS_D(d, x, y)
```

## Arguments

- `d` :
	次の有効な `BOOST_PP_WHILE` 反復。

- `x` :
	比較における左オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

- `y` :
	比較における右オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

## Remarks

もし `x` が `y` より小さいならば、このマクロは `1` に展開される。
そうでなければ `0` に展開される。

## See Also

- [`BOOST_PP_LESS`](less.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/comparison/less.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/comparison/less.hpp>
#include <boost/preprocessor/list/filter.hpp>

#define LIST (1, (2, (3, (4, (5, BOOST_PP_NIL)))))

#define PRED(d, _, num) BOOST_PP_LESS_D(d, num, 3)

BOOST_PP_LIST_FILTER(PRED, nil, LIST)
	// (1, (2, BOOST_PP_NIL)) に展開される
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LESS_D[link less_d.md]
* BOOST_PP_LIST_FILTER[link list_filter.md]

