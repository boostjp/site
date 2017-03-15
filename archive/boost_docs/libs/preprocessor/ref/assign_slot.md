# BOOST_PP_ASSIGN_SLOT

`BOOST_PP_ASSIGN_SLOT` マクロは、数値マクロかまたは数値式を完全に評価する。

## Usage

```cpp
# include BOOST_PP_ASSIGN_SLOT(i)
```

## Arguments

- `i` :
	代入されている*スロット*番号。
	この値は `1` から `BOOST_PP_LIMIT_SLOT_COUNT` までの範囲内でなければならない。

## Remarks

これを使う前に、*名前付き外部引数* `BOOST_PP_VALUE` が定義されていなければならない。
それもまた、`0` から `2^32 - 1` までの範囲内の数値に展開されなければならない。

## See Also

- [`BOOST_PP_LIMIT_SLOT_COUNT`](limit_slot_count.md)
- [`BOOST_PP_VALUE`](value.md)

## Requirements

Header: &lt;boost/preprocessor/slot/slot.hpp&gt;

## Sample Code

```cpp
# include boost/preprocessor/slot/slot.hpp>

# define X() 4

# define BOOST_PP_VALUE 1 + 2 + 3 + X()
# include BOOST_PP_ASSIGN_SLOT(1)

# undef X

BOOST_PP_SLOT(1) // 10 に展開される
```
* BOOST_PP_VALUE[link value.md]
* BOOST_PP_ASSIGN_SLOT[link assign_slot.md]
* BOOST_PP_SLOT[link slot.md]

