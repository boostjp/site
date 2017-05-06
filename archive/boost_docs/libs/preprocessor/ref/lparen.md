# BOOST_PP_LPAREN

`BOOST_PP_LPAREN` マクロは開き丸括弧に展開される。

## Usage

```cpp
BOOST_PP_LPAREN()
```

## Remarks

プリプロセッサは丸括弧をマクロ呼び出しではデリミタとして解釈する。
このため、丸括弧は特別な扱いを必要とする。

## See Also

- [`BOOST_PP_RPAREN`](rparen.md)

## Requirements

Header: &lt;boost/preprocessor/punctuation/paren.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/punctuation/paren.hpp>

#define X(x) x
#define MACRO(p, x) X p x )

MACRO(BOOST_PP_LPAREN(), abc) // abc に展開される

#define Y(x)

MACRO((10) Y BOOST_PP_LPAREN(), result) // 10 に展開される
```
* BOOST_PP_LPAREN[link lparen.md]

