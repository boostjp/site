# BOOST_PP_MOD_D

`BOOST_PP_MOD_D` マクロは第2引数と第3引数の余りに展開される。
これは、最も効率的に `BOOST_PP_WHILE` に再入する。

## Usage

```cpp
BOOST_PP_MOD_D(d, x, y)
```

## Arguments

- `d` :
	利用可能な次の `BOOST_PP_WHILE` の繰り返し。

- `x` :
	演算の割られる方(分子)。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

- `y` :
	演算の割る方(分母)。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

## Remarks

もし `y` が `0` なら、結果は未定義である。

## See Also

- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)
- [`BOOST_PP_MOD`](mod.md)

## Requirements

Header: &lt;boost/preprocessor/arithmetic/div.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/arithmetic/mod.hpp>
#include <boost/preprocessor/list/filter.hpp>
#include <boost/preprocessor/logical/not.hpp>

#define LIST (1, (2, (3, (4, (5, BOOST_PP_NIL)))))

#define EVEN_P(d, _, num) BOOST_PP_NOT(BOOST_PP_MOD_D(d, num, 2))
#define EVEN(list) BOOST_PP_LIST_FILTER(EVEN_P, nil, list)

EVEN(LIST) // expands to (2, (4, BOOST_PP_NIL))

#define ODD_P(d, _, num) BOOST_PP_MOD_D(d, num, 2)
#define ODD(list) BOOST_PP_LIST_FILTER(ODD_P, nil, list)

ODD(LIST) // expands to (1, (3, (5, BOOST_PP_NIL)))
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_NOT[link not.md]
* BOOST_PP_MOD_D[link mod_d.md]
* BOOST_PP_LIST_FILTER[link list_filter.md]

