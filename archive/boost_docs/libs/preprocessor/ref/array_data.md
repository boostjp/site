#BOOST_PP_ARRAY_DATA

BOOST_PP_ARRAY_DATA マクロは*配列*から*タプル*のデータを抽出する。

##Usage

```cpp
BOOST_PP_ARRAY_DATA(array)
```

##Arguments

- `array` :
	*タプル*に変換される*配列*。

##Remarks

このマクロは*配列*データの一部分であるタプル部分に展開される。

##Requirements

**Header:** &nbsp;&lt;boost/preprocessor/array/data.hpp&gt;

##Sample Code

```cpp
#include <boost/preprocessor/array/data.hpp>

#define ARRAY (3, (x, y, z))

BOOST_PP_ARRAY_DATA(ARRAY) // (x, y, z) に展開される
```
* BOOST_PP_ARRAY_DATA[link array_data.md]

