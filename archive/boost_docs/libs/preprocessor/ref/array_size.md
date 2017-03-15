# BOOST_PP_ARRAY_SIZE

`BOOST_PP_ARRAY_SIZE` マクロは渡された*配列*のサイズに展開される。

## Usage

```cpp
BOOST_PP_ARRAY_SIZE(array)
```

## Arguments

- `array` :
	サイズが展開される*配列*。

## Requirements

Header: &lt;boost/preprocessor/array/size.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/array/size.hpp>

# define ARRAY (3, (x, y, z))

BOOST_PP_ARRAY_SIZE(ARRAY) // 3 に展開される
```
* BOOST_PP_ARRAY_SIZE[link array_size.md]

