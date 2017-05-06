# BOOST_PP_TUPLE_EAT

`BOOST_PP_TUPLE_EAT` マクロは特定の大きさの *タプル* を食うマクロに展開される。

## Usage

```cpp
BOOST_PP_TUPLE_EAT(size)
```

## Arguments

- `size` :
	食われる *タプル* の大きさ。
	有効な *タプル* の大きさの範囲は、 `0` から `BOOST_PP_LIMIT_TUPLE` までである。

## Remarks

`size` 引数は *タプル* の実際の大きさでなければならない。

## See Also

- [`BOOST_PP_LIMIT_TUPLE`](limit_tuple.md)

## Requirements

Header: &lt;boost/preprocessor/tuple/eat.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/control/if.hpp>
#include <boost/preprocessor/tuple/eat.hpp>

#define OP(a, b) (a b)

#define MACRO(n) BOOST_PP_IF(n, OP, BOOST_PP_TUPLE_EAT(2))(1, 2)

MACRO(0) // expands to nothing
MACRO(1) // expands to (1, 2)
```
* BOOST_PP_IF[link if.md]
* BOOST_PP_TUPLE_EAT[link tuple_eat.md]

