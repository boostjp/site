# BOOST_PP_INTERCEPT

`BOOST_PP_INTERCEPT` マクロは数字の連結を防ぎ、何にも展開されない。

## Usage

```cpp
BOOST_PP_INTERCEPT
```

## Remarks

このマクロは他の様々なライブラリが行う連結を防ぐために使われる。
典型的にこのマクロは、他のテキストの後に使われ、連結されるのを防ぎ、何にも展開されない。
このマクロは `0` から `BOOST_PP_LIMIT_MAG` までの整数定数のみの連結を防ぐことが出来る。

## See Also

- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/facilities/intercept.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/facilities/intercept.hpp>
#include <boost/preprocessor/repetition/enum_binary_params.hpp>

BOOST_PP_ENUM_BINARY_PARAMS(3, class T, = U)
// expands to class T0 = U0, class T1 = U1, class T2 = U2

BOOST_PP_ENUM_BINARY_PARAMS(3, class T, = int BOOST_PP_INTERCEPT)
// expands to class T0 = int, class T1 = int, class T2 = int
```
* BOOST_PP_ENUM_BINARY_PARAMS[link enum_binary_params.md]
* BOOST_PP_INTERCEPT[link intercept.md]

