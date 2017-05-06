# BOOST_PP_RPAREN

`BOOST_PP_RPAREN` マクロは閉じ丸括弧に展開される。

## Usage

```cpp
BOOST_PP_RPAREN()
```

## Remarks

プリプロセッサは丸括弧をマクロ呼び出しではデリミタとして解釈する。
このため、丸括弧は特別な扱いを必要とする。

## See Also

- [`BOOST_PP_LPAREN`](lparen.md)

## Requirements

Header: &lt;boost/preprocessor/punctuation/paren.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/facilities/empty.hpp>
#include <boost/preprocessor/punctuation/paren.hpp>

#define X(x) x
#define MACRO(x, p) X ( x p

MACRO(abc, BOOST_PP_RPAREN()) // expands to abc

#define Y(x)

MACRO(BOOST_PP_EMPTY BOOST_PP_RPAREN()(), 10) // expands to 10
```
* BOOST_PP_RPAREN[link rparen.md]
* BOOST_PP_EMPTY[link empty.md]

