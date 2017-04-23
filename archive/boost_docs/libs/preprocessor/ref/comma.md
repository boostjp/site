# BOOST_PP_COMMA

`BOOST_PP_COMMA` マクロはコンマに展開される。

## Usage

```cpp
BOOST_PP_COMMA()
```

## Remarks

プリプロセッサは、コンマをマクロ呼び出しでの引数の区切りとして解釈する。
よって、コンマに対しては特別な対応が必要となる。

## Requirements

Header: &lt;boost/preprocessor/punctuation/comma.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/control/if.hpp>
#include <boost/preprocessor/facilities/empty.hpp>
#include <boost/preprocessor/punctuation/comma.hpp>

BOOST_PP_IF(1, BOOST_PP_COMMA, BOOST_PP_EMPTY)() // , に展開される
```
* BOOST_PP_IF[link if.md]
* BOOST_PP_COMMA[link comma.md]
* BOOST_PP_EMPTY[link empty.md]

