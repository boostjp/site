# BOOST_PP_IF

`BOOST_PP_IF` マクロは論理式の状態にしたがって 2つの値からひとつを選択する。

## Usage

```cpp
BOOST_PP_IF(cond, t, f)
```

## Arguments

- `cond` :
	結果が `t` か `f` かを決定する条件。
	この値は `0` か `1` に展開されなければならない。

- `t` :
	`cond` が `1` の時に展開される結果。

- `f` :
	`cond` が `2` の時に展開される結果。

## Remarks

このマクロは第1引数に対してブール値への変換を行う。
もし変換が必要ないなら、代わりに `BOOST_PP_IF` を使うこと。

## See Also

- [`BOOST_PP_IIF`](iif.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/control/if.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/control/if.hpp>

BOOST_PP_IF(10, a, b) // expands to a
BOOST_PP_IF(0, a, b) // expands to b
```
* BOOST_PP_IF[link if.md]

