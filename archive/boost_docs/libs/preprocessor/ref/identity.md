# BOOST_PP_IDENTITY

`BOOST_PP_IDENTITY` マクロは呼び出されたときにその引数に展開される。

## Usage

```cpp
BOOST_PP_IDENTITY(item)()
```

## Arguments

- `item` :
	展開の結果。

## Remarks

このマクロは `BOOST_PP_IF` や `BOOST_PP_IIF` と共に使われて、
句のひとつだけが呼び出される必要があるときの為に設計されている。

## See Also

- [`BOOST_PP_IF`](if.md)
- [`BOOST_PP_IIF`](iif.md)

## Requirements

Header: &lt;boost/preprocessor/facilities/identity.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/control/if.hpp>
#include <boost/preprocessor/facilities/empty.hpp>
#include <boost/preprocessor/facilities/identity.hpp>

#define MACRO(n) BOOST_PP_IF(n, BOOST_PP_IDENTITY(x), BOOST_PP_EMPTY)()

MACRO(0) // expands to nothing
MACRO(1) // expands to x
```
* BOOST_PP_IF[link if.md]
* BOOST_PP_IDENTITY[link identity.md]
* BOOST_PP_EMPTY[link empty.md]

