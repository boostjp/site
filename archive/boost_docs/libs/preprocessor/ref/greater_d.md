# BOOST_PP_GREATER_D

`BOOST_PP_GREATER_D` マクロは2つの値の大きさを比較する。
これは最も効率的に `BOOST_PP_WHILE` に再入する。

## Usage

```cpp
BOOST_PP_GREATER_D(d, x, y)
```

## Arguments

- `d` :
	利用可能な次の `BOOST_PP_WHILE` の繰り返し。

- `x` :
	比較における左オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

- `y` :
	比較における右オペランド。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

## Remarks

もし `x` が `y` より大きければ、このマクロは `1` に展開される。
そうでなければ、 `0` に展開される。

## See Also

- [`BOOST_PP_GREATER`](greater.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/comparison/greater.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/comparison/greater.hpp>
#include <boost/preprocessor/list/filter.hpp>

#define LIST (1, (2, (3, (4, (5, BOOST_PP_NIL)))))

#define PRED(d, _, num) BOOST_PP_GREATER_D(d, num, 2)

BOOST_PP_LIST_FILTER(PRED, nil, LIST) // expands to (3, (4, (5, BOOST_PP_NIL)))
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_GREATER_D[link greater_d.md]
* BOOST_PP_LIST_FILTER[link list_filter.md]

