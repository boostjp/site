# BOOST_PP_ENUM_SHIFTED_PARAMS_Z

`BOOST_PP_ENUM_SHIFTED_PARAMS_Z` マクロはコンマで区切られた、ずらされたパラメータリストを生成する。
これは `BOOST_PP_REPEAT` に最も効率よく再入する。

# Usage

```cpp
BOOST_PP_ENUM_SHIFTED_PARAMS_Z(z, count, param)
```

# Arguments

- `z` :
	利用可能な次の `BOOST_PP_REPEAT` の次元。

- `count` :
	生成するパラメータの個数。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_REPEAT` まで。

- `param` :
	パラメータのテキスト部。
	`BOOST_PP_ENUM_SHIFTED_PARAMS_Z` は生成したパラメータと `1` から `count - 1` までの範囲の数字とを結合する。

# Remarks

このマクロはコンマ区切りのシーケンスに展開される:

```cpp
param ## 1, ... param ## count - 1
```

# See Also

- [`BOOST_PP_LIMIT_REPEAT`](limit_repeat.md)
- [`BOOST_PP_ENUM_SHIFTED_PARAMS`](enum_shifted_params.md)

# Requirements

Header: &lt;boost/preprocessor/repetition/enum_shifted_params.hpp&gt;

# Sample Code

```cpp
#include <boost/preprocessor/repetition/enum_params.hpp>
#include <boost/preprocessor/repetition/enum_shifted_params.hpp>
#include <boost/preprocessor/repetition/repeat.hpp>

int add(void) {
	return 0;
}

#define ADD_F(z, n, _) \
	int add_f(BOOST_PP_ENUM_PARAMS_Z(z, BOOST_PP_INC(n), int p)) { \
		return p0 + add_f(BOOST_PP_ENUM_SHIFTED_PARAMS_Z(z, BOOST_PP_INC(n), p)); \
	} \
	/**/

BOOST_PP_REPEAT(5, ADD_F, nil)
```
* BOOST_PP_ENUM_PARAMS_Z[link enum_params_z.md]
* BOOST_PP_INC[link inc.md]
* BOOST_PP_ENUM_SHIFTED_PARAMS_Z[link enum_shifted_params_z.md]
* BOOST_PP_REPEAT[link repeat.md]

