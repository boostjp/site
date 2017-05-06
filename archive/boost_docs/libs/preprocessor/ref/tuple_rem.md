# BOOST_PP_TUPLE_REM

`BOOST_PP_TUPLE_REM` マクロは特定の大きさの *タプル* から丸括弧を取り除くマクロに展開される。

## Usage

```cpp
BOOST_PP_TUPLE_REM(size)
```

## Arguments

- `size` :
	丸括弧が取り除かれる *タプル* の大きさ。
	有効な *タプル* の大きさの範囲は `0` から `BOOST_PP_LIMIT_TUPLE` までである。

## Remarks

`size` 引数は *タプル* の実際の大きさでなければならない。

## See Also

- [`BOOST_PP_LIMIT_TUPLE`](limit_tuple.md)

## Requirements

Header: &lt;boost/preprocessor/tuple/rem.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/tuple/rem.hpp>

BOOST_PP_TUPLE_REM(3)(x, y, z) // expands to x, y, z
```
* BOOST_PP_TUPLE_REM[link tuple_rem.md]

