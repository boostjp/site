# BOOST_PP_TUPLE_REVERSE

`BOOST_PP_TUPLE_REVERSE` マクロは特定の大きさの *タプル* を逆に並び替える。

## Usage

```cpp
BOOST_PP_TUPLE_REVERSE(size, tuple)
```

## Arguments

- `size` :
	並び替えられる *タプル* の大きさ。
	有効な *タプル* の大きさの範囲は `0` から `BOOST_PP_LIMIT_TUPLE` までである。

- `tuple` :
	並び替えられる *タプル* 。

## Remarks

`size` 引数は *タプル* の実際の大きさでなければならない。

## See Also

- [`BOOST_PP_LIMIT_TUPLE`](limit_tuple.md)

## Requirements

Header: &lt;boost/preprocessor/tuple/reverse.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/tuple/reverse.hpp>

BOOST_PP_TUPLE_REVERSE(3, (x, y, z)) // expands to (z, y, x)
```
* BOOST_PP_TUPLE_REVERSE[link tuple_reverse.md]

