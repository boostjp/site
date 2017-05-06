# BOOST_PP_STRINGIZE

`BOOST_PP_STRINGIZE` マクロは、引数を展開した後に文字列化する。

## Usage

```cpp
BOOST_PP_STRINGIZE(text)
```

## Arguments

- `text` :
	リテラル文字列に変換されるテキスト。

## Remarks

プリプロセッサ文字列化演算子 (`#`) では引数を展開することは出来ない。
このマクロは文字列化の前に引数を展開することを可能にする。

## Requirements

Header: &lt;boost/preprocessor/stringize.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/cat.hpp>
#include <boost/preprocessor/stringize.hpp>

BOOST_PP_STRINGIZE(BOOST_PP_CAT(a, b)) // expands to "ab"
```
* BOOST_PP_STRINGIZE[link stringize.md]
* BOOST_PP_CAT[link cat.md]

