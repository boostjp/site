# BOOST_PP_NIL

`BOOST_PP_NIL` 識別子はライブラリによって、非マクロを示すために予約されている。

## Usage

```cpp
BOOST_PP_NIL
```

## Remarks

この識別子は 定義されて *いない* この目的は *マクロではないこと* である。
*リスト* を終了するためにも使われる。

## Sample Code

```cpp
#include <boost/preprocessor/list/adt.hpp>

#define LIST (x, (y, (z, BOOST_PP_NIL)))

BOOST_PP_LIST_FIRST(x) // expands to x
BOOST_PP_LIST_REST(x) // expands to (y, (z, BOOST_PP_NIL))
```
* BOOST_PP_NIL[link nil.md]
* BOOST_PP_LIST_FIRST[link list_first.md]
* BOOST_PP_LIST_REST[link list_rest.md]

