#BOOST_PP_ASSERT

`BOOST_PP_ASSERT` マクロは条件によりプリプロセッシングエラーを起こす。

##Usage

```cpp
BOOST_PP_ASSERT(cond)
```

##Arguments

- `cond` :
	アサーションを起こすかどうかを決定する条件。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

##Remarks

`cond` が `0` に展開される場合、このマクロはプリプロセッシングエラーを起こす。
そうでなければ、空文字に展開される。

##See Also

- [`BOOST_PP_ASSERT_MSG`](assert_msg.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

##Requirements

Header: &lt;boost/preprocessor/debug/assert.hpp&gt;

##Sample Code

```cpp
#include <boost/preprocessor/cat.hpp>
#include <boost/preprocessor/debug/assert.hpp>
#include <boost/preprocessor/logical/bitnor.hpp>
#include <boost/preprocessor/logical/compl.hpp>

// BOOST_PP_IS_NULLARY マクロはこのライブラリの公開された
// インターフェースには含まれていないが、それはこれが
// Borland 社のプリプロセッサでは動かないからである。
// それはアサーションを例示するためにここだけで使われる。
// 実際には、それは引数が空の丸カッコであるかそれとも
// 何らかのテキストであるかを見極める。

#include <boost/preprocessor/detail/is_nullary.hpp>

#define IS_EDISON_DESIGN_GROUP() \
	BOOST_PP_COMPL( \
		BOOST_PP_IS_NULLARY( \
			BOOST_PP_CAT(IS_EDG_CHECK, __EDG_VERSION) \
		) \
	) \
	/**/
#define IS_EDG_CHECK__EDG_VERSION ()

#define IS_METROWERKS() \
	BOOST_PP_COMPL( \
		BOOST_PP_IS_NULLARY( \
			BOOST_PP_CAT(IS_MWERKS_CHECK, __MWERKS__) \
		) \
	) \
	/**/
#define IS_MWERKS_CHECK__MWERKS__ ()

#define IS_MICROSOFT() \
	BOOST_PP_BITNOR( \
		IS_MICROSOFT_ROOT(), \
		IS_EDISON_DESIGN_GROUP() \
	) \
	/**/
#define IS_MICROSOFT_ROOT() \
	BOOST_PP_IS_NULLARY( \
		BOOST_PP_CAT(IS_MSVC_CHECK, _MSC_VER) \
	) \
	/**/
#define IS_MSVC_CHECK_MS_VER ()

// このマクロは EDG 上では動かない...
// (これはただの例である)

#define MACRO(n) \
	BOOST_PP_CAT( \
		MACRO_, \
		IS_EDISON_DESIGN_GROUP() \
	)(n) \
	/**/

#define MACRO_1(n) \
	BOOST_PP_ASSERT(0) \
	"Edison Design Group is not supported" \
	/**/

#define MACRO_0(n) normal mode: n

MACRO(10)
```
* BOOST_PP_COMPL[link compl.md]
* BOOST_PP_CAT[link cat.md]
* BOOST_PP_COMPL[link compl.md]
* BOOST_PP_CAT[link cat.md]
* BOOST_PP_BITNOR[link bitnor.md]
* BOOST_PP_CAT[link cat.md]
* BOOST_PP_CAT[link cat.md]
* BOOST_PP_ASSERT[link assert.md]

