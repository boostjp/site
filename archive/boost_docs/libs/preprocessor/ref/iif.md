# BOOST_PP_IIF

`BOOST_PP_IIF` マクロはビット状態に基づいて、 2つの値からひとつを選択する。

## Usage

```cpp
BOOST_PP_IIF(bit, t, f)
```

## Arguments

- `bit` :
	結果が `t` か `f` かを決定する条件。
	この値は `0` か `1` に展開されなければならない。

- `t` :
	`bit` が `1` の時に展開される結果。

- `f` :
	`bit` が `2` の時に展開される結果。

## Remarks

このマクロは第1引数に対してブール値への変換を *行わない。*
もし変換が必要なら、代わりに `BOOST_PP_IF` を使うこと。

## See Also

- [`BOOST_PP_IF`](if.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

## Requirements

Header: &lt;boost/preprocessor/control/iif.hpp&gt;

## Sample Code

```cpp
#include <boost/preprocessor/control/iif.hpp>

#define OR_IF(p, q, t, f) BOOST_PP_IIF(BOOST_PP_OR(p, q), t, f)

OR_IF(1, 0, abc, xyz) // expands to abc
OF_IF(0, 0, abc, xyz) // expands to xyz
```
* BOOST_PP_IIF[link iif.md]
* BOOST_PP_OR[link or.md]

