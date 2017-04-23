# BOOST_PP_EXPR_IIF

`BOOST_PP_EXPR_IIF` マクロは第1引数が `1` ならば第2引数に、`0` ならば無に展開される。

## Usage

```cpp
BOOST_PP_EXPR_IIF(bit, expr)
```

## Arguments

- `bit` :
	マクロが `expr` に展開されるか無に展開されるかを決定する条件。
	この値は `0` または `1` に展開されなければならない。

- `expr` :
	`bit` が `1` のときの展開の結果。

## Remarks

このマクロは第1引数に基づいてブーリアン変換を **行わない** 。
もしこの変換が必要ならば、代わりに `BOOST_PP_EXPR_IF` を使うべきだ。

## See Also

- [`BOOST_PP_EXPR_IF`](expr_if.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/control/expr_iif.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/comparison/and.hpp>
#include <boost/preprocessor/control/expr_iif.hpp>

#define INSERT_AND(p, q, text) \
	BOOST_PP_EXPR_IIF( \
		BOOST_PP_AND(p, q), \
		text \
	) \
	/**/

INSERT_AND(2, 3, abc) // abc に展開される
INSERT_AND(0, 7, xyz) // 無に展開される
```
* BOOST_PP_EXPR_IIF[link expr_iif.md]
* BOOST_PP_AND[link and.md]

