# BOOST_PP_EXPAND

```cpp
BOOST_PP_EXPAND マクロは引数のマクロの二重展開として機能する。
```

## Usage

```cpp
BOOST_PP_EXPAND(x)
```

## Arguments

- `x` :
	二重に展開される引数。

## Remarks

このマクロはマクロ実行の正しいセマンティクスを実現するために遅延が必要なときに有用である。
例えば、マクロが別のマクロの引数リストに展開されるときである。
このようなマクロではまず最初に引数リストが展開され、それからさらにマクロを展開するために再度スキャンが行われる。

## Requirements

Header: &lt;boost/preprocessor/facilities/expand.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/control/if.hpp>
#include <boost/preprocessor/facilities/expand.hpp>

#define MACRO(a, b, c) (a)(b)(c)
#define ARGS() (1, 2, 3)

BOOST_PP_EXPAND(MACRO ARGS) // (1)(2)(3) に展開される

#define SAMPLE(n) \
	BOOST_PP_EXPAND( \
		MACRO, \
		BOOST_PP_IF( \
			n, \
			(x, y, z), \
			(a, b, c) \
		) \
	) \
	/**/

SAMPLE(0) // (a)(b)(c) に展開される
SAMPLE(1) // (x)(y)(z) に展開される
```
* BOOST_PP_EXPAND[link expand.md]
* BOOST_PP_IF[link if.md]

