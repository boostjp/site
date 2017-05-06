# BOOST_PP_SLOT

`BOOST_PP_SLOT` マクロは `BOOST_PP_ASSIGN_SLOT` によって前もって評価された値を取り出す。

## Usage

```cpp
#include BOOST_PP_SLOT(i)
```

## Arguments

- `i` :
	取り出される *スロット* のインデックス。
	この値は `1` から `BOOST_PP_LIMIT_SLOT_COUNT` の範囲でなければならない。

## Remarks

使う前に、インデックス `i` の *スロット* は `BOOST_PP_ASSIGN_SLOT` で割り当てられていなければならない。

## See Also

- [`BOOST_PP_ASSIGN_SLOT`](assign_slot.md)
- [`BOOST_PP_LIMIT_SLOT_COUNT`](limit_slot_count.md)

## Requirements

Header: &lt;boost/preprocessor/slot/slot.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/slot/slot.hpp>

#define X() 4

#define BOOST_PP_VALUE 1 + 2 + 3 + X()
#include BOOST_PP_ASSIGN_SLOT(1)

#undef X

BOOST_PP_SLOT(1) // expands to 10
```
* BOOST_PP_VALUE[link value.md]
* BOOST_PP_ASSIGN_SLOT[link assign_slot.md]
* BOOST_PP_SLOT[link slot.md]

