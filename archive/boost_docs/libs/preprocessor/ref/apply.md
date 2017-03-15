# BOOST_PP_APPLY

`BOOST_PP_APPLY` マクロは、その引数と空文字との違いを吸収する。

## Usage

```cpp
BOOST_PP_APPLY(x)
```

## Arguments

- `x` :
	取り出された引数。
	この引数は `BOOST_PP_NIL` か、または `(arg)` や `((a, b))` のような一要素の*タプル*である。

## Remarks

`x` が `BOOST_PP_NIL` ならば、このマクロは空文字に展開される。
`x` が一要素の*タプル*ならば、その*タプル*の内容に展開される。

## See Also

- [`BOOST_PP_NIL`](nil.md)

## Requirements

**Header:** &lt;boost/preprocessor/facilities/apply.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/facilities/apply.hpp>
#include <boost/preprocessor/tuple/elem.hpp>

# define CV(i) \
	BOOST_PP_APPLY( \
		BOOST_PP_TUPLE_ELEM( \
			4, i, \
			(BOOST_PP_NIL, (const), (volatile), (const volatile)) \
		) \
	) \
	/**/

CV(0) // 無くなる
CV(1) // const に展開される
```
* BOOST_PP_APPLY[link apply.md]
* BOOST_PP_TUPLE_ELEM[link tuple_elem.md]
* BOOST_PP_NIL[link nil.md]

