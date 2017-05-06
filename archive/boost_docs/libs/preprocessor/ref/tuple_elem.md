# BOOST_PP_TUPLE_ELEM

`BOOST_PP_TUPLE_ELEM` マクロは *タプル* から要素を展開する。

## Usage

```cpp
BOOST_PP_TUPLE_ELEM(size, i, tuple)
```

## Arguments

- `size` :
	*タプル* の大きさ。
	有効な *タプル* の大きさの範囲は `0` から `BOOST_PP_LIMIT_TUPLE` までである。

- `i` :
	展開される *タプル* の要素へのゼロ基準のインデックス。
	有効な値の範囲は `0` から `size - 1` までである。

- `tuple` :
	要素が展開される *タプル*

## Remarks

`size` 引数は *タプル* の実際の大きさでなければならない。
`i` は *タプル* の大きさよりも小さくなければならない。

## See Also

- [`BOOST_PP_LIMIT_TUPLE`](limit_tuple.md)

## Requirements

Header: &lt;boost/preprocessor/tuple/elem.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/tuple/elem.hpp>

#define TUPLE (a, b, c, d)

BOOST_PP_TUPLE_ELEM(4, 0, TUPLE) // expands to a
BOOST_PP_TUPLE_ELEM(4, 3, TUPLE) // expands to d
```
* BOOST_PP_TUPLE_ELEM[link tuple_elem.md]

