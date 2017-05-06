# BOOST_PP_TUPLE_TO_LIST

`BOOST_PP_TUPLE_TO_LIST` マクロは *タプル* を *リスト* に変換する。

## Usage

```cpp
BOOST_PP_TUPLE_TO_LIST(size, tuple)
```

## Arguments

- `size` :
	変換される *タプル* の大きさ。
	有効な *タプル* の大きさの範囲は `0` から `BOOST_PP_LIMIT_TUPLE` までである。

- `tuple` :
	変換される *タプル* 。

## Remarks

`size` 引数は *タプル* の実際の大きさでなければならない。

## See Also

- [`BOOST_PP_LIMIT_TUPLE`](limit_tuple.md)

## Requirements

Header: &lt;boost/preprocessor/tuple/to_list.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/tuple/to_list.hpp>

BOOST_PP_TUPLE_TO_LIST(3, (x, y, z))
	// expands to (x, (y, (z, BOOST_PP_NIL)))
```
* BOOST_PP_TUPLE_TO_LIST[link tuple_to_list.md]
* BOOST_PP_NIL[link nil.md]

