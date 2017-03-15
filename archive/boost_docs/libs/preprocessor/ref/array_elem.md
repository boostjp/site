# BOOST_PP_ARRAY_ELEM

`BOOST_PP_ARRAY_ELEM` マクロは*配列*からその要素を抽出する。

## Usage

```cpp
BOOST_PP_ARRAY_ELEM(i, array)
```

## Arguments

- `i` :
	`array` における、抽出される要素の 0 から始まるインデックス。

- `array` :
	抽出される要素のもととなる:配列:。
	この*配列*は少なくとも `i + 1` 個の要素を持っていなければならない。

## Requirements

**Header:** &lt;boost/preprocessor/array/elem.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/array/elem.hpp>

# define ARRAY (4, (a, b, c, d))

BOOST_PP_ARRAY_ELEM(0, ARRAY) // a に展開される
BOOST_PP_ARRAY_ELEM(3, ARRAY) // d に展開される
```
* BOOST_PP_ARRAY_ELEM[link array_elem.md]

