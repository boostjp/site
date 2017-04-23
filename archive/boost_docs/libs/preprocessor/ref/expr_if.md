# BOOST_PP_EXPR_IF

`BOOST_PP_EXPR_IF` マクロは第1引数が 0以外ならば第2引数に、そうでなければ無に展開される。

## Usage

```cpp
BOOST_PP_EXPR_IF(cond, expr)
```

## Arguments

- `cond` :
	マクロが `expr` に展開されるか無に展開されるかを決定する条件。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

- `expr` :
	`cond` が 0以外のときの展開の結果。

## Remarks

このマクロは第1引数に基づいてブーリアン変換を行う。
もしこの変換が不必要ならば、代わりに `BOOST_PP_EXPR_IIF` を使うべきだ。

## See Also

- [`BOOST_PP_EXPR_IIF`](expr_iif.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/control/expr_if.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/control/expr_if.hpp>
#include <boost/preprocessor/tuple/elem.hpp>

#define CV(n) \
	BOOST_PP_EXPR_IF( \
		n, \
		BOOST_PP_TUPLE_ELEM( \
			4, n, \
			(..., const, volatile, const volatile) \
		) \
	) \
	/**/

CV(0) // 無に展開される
CV(1) // const に展開される
```
* BOOST_PP_EXPR_IF[link expr_if.md]
* BOOST_PP_TUPLE_ELEM[link tuple_elem.md]

