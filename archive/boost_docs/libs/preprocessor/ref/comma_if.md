# BOOST_PP_COMMA_IF

`BOOST_PP_COMMA_IF` マクロは条件によりコンマに展開される。

## Usage

```cpp
BOOST_PP_COMMA_IF(cond)
```

## Arguments

- `cond` :
	マクロがコンマを展開するか空文字を展開するかを決定する条件。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

## Remarks

`cond` が `0` に展開されれば、このマクロは空文字に展開される。
そうでなければ、コンマに展開される。

プリプロセッサは、コンマをマクロ呼び出しでの引数の区切りとして解釈する。
よって、コンマに対しては特別な対応が必要となる。

## See Also

- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/punctuation/comma_if.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/punctuation/comma_if.hpp>
#include <boost/preprocessor/repetition/repeat.hpp>

#define MACRO(z, n, text) BOOST_PP_COMMA_IF(n) text

BOOST_PP_REPEAT(3, MACRO, class) // class, class, class に展開される
```
* BOOST_PP_COMMA_IF[link comma_if.md]
* BOOST_PP_REPEAT[link repeat.md]

