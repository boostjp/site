# BOOST_PP_RPAREN_IF

`BOOST_PP_RPAREN_IF` マクロは条件によって閉じ丸括弧に展開される。

## Usage

```cpp
BOOST_PP_RPAREN_IF(cond)
```

## Arguments

- `cond` :
	マクロが閉じ丸括弧に展開されるか、何もしないかを決定する条件。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` までである。

## Remarks

`cond` が `0` に展開されれば、このマクロは何にも展開されない。
相でなければ、閉じ丸括弧に展開される。

プリプロセッサは丸括弧をマクロ呼び出しではデリミタとして解釈する。
このため、丸括弧は特別な扱いを必要とする。

## See Also

- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)
- [`BOOST_PP_LPAREN_IF`](lparen_if.md)

## Requirements

Header: &lt;boost/preprocessor/punctuation/paren_if.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/punctuation/paren_if.hpp>

#define MACRO(c, x) BOOST_PP_LPAREN_IF(c) x BOOST_PP_RPAREN_IF(c)

MACRO(0, text) // expands to text
MACRO(1, text) // expands to (text)
```
* BOOST_PP_LPAREN_IF[link lparen_if.md]
* BOOST_PP_RPAREN_IF[link rparen_if.md]

