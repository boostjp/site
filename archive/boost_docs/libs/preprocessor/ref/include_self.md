# BOOST_PP_INCLUDE_SELF

`BOOST_PP_INCLUDE_SELF` マクロはファイルを間接的にインクルードする。

## Usage

```cpp
#include BOOST_PP_INCLUDE_SELF()
```

## Arguments

- `filename` :
	`BOOST_PP_INCLUDE_SELF` でインクルードされる、
	引用符、またはカギ括弧で囲まれたファイル名。

## Remarks

`BOOST_PP_INDIRECT_SELF` がこのマクロを使う前に定義されていなければならない。

多くのプリプロセッサはファイルがそのファイル自身を直接インクルードすることを許さない。
例えファイルが、そのような状況を、自分自身で防いでいてもである。
このマクロを `BOOST_PP_INDIRECT_SELF` と組み合わせることで、ファイルがそのファイル自身を間接的にインクルードすることを可能にする。

`BOOST_PP_INDIRECT_SELF` がインクルードされている間、`BOOST_PP_INCLUDE_SELF` はマクロ `BOOST_PP_IS_SELFISH` を `1` に定義する。
インクルード操作から復帰したとき、 `BOOST_PP_IS_SELFISH` は未定義にされる。

## See Also

- [`BOOST_PP_INDIRECT_SELF`](indirect_self.md)
- [`BOOST_PP_IS_SELFISH`](is_selfish.md)

## Requirements

Header: &lt;boost/preprocessor/iteration/self.hpp&gt;

## Sample Code

```cpp
// file.h
#if !BOOST_PP_IS_SELFISH

	#ifndef FILE_H_
	#define FILE_H_

	#include <boost/preprocessor/iteration/self.hpp>

	#define NAME X
	struct NAME {
		// ...
		#define BOOST_PP_INDIRECT_SELF "file.h"
		#include BOOST_PP_INCLUDE_SELF()
	};

	#define NAME Y
	struct NAME {
		// ...
		#define BOOST_PP_INDIRECT_SELF "file.h"
		#include BOOST_PP_INCLUDE_SELF()
	};

	#define NAME Z
	struct NAME {
		// ...
		#define BOOST_PP_INDIRECT_SELF "file.h"
		#include BOOST_PP_INCLUDE_SELF()
	};

	#endif

#else

	inline bool validate(NAME* p) {
		return true;
	}

	template<class T> bool validate(T* p) {
		return dynamic_cast<NAME*>(p);
	}

	#undef NAME

#endif
```
* BOOST_PP_IS_SELFISH[link is_selfish.md]
* BOOST_PP_INDIRECT_SELF[link indirect_self.md]
* BOOST_PP_INCLUDE_SELF[link include_self.md]

