# BOOST_PP_EMPTY

`BOOST_PP_EMPTY` は空文字に展開される無項ユーティリティマクロである。

## Usage

```cpp
BOOST_PP_EMPTY()
```

## Remarks

このマクロは、役立たずなマクロ展開の回避を支援する。
これは主に、`BOOST_PP_IF` や `BOOST_PP_IIF` の引数として有用である。

## Requirements

Header: &lt;boost/preprocessor/facilities/empty.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/control/if.hpp>
#include <boost/preprocessor/facilities/empty.hpp>

#define X() result
#define MACRO(c) BOOST_PP_IF(c, X, BOOST_PP_EMPTY)()

MACRO(0) // 空文字に展開される
MACRO(1) // result に展開される
```
* BOOST_PP_EMPTY[link empty.md]
* BOOST_PP_IF[link if.md]

