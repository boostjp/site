#BOOST_PP_ASSERT_MSG

`BOOST_PP_ASSERT_MSG` マクロは条件によりデバッグ文字列を挿入する。

##Usage

```cpp
BOOST_PP_ASSERT_MSG(cond, msg</i>)
```

##Arguments

- `cond` :
	アサーションを起こすかどうかを決定する条件。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_MAG` まで。

- `msg` :
	`cond` が `0` と評価されたときに表示するメッセージ。

##Remarks

`cond` が `0` に展開される場合、このマクロは `msg` に展開される。
そうでなければ、空文字に展開される。

##See Also

- [`BOOST_PP_ASSERT_MSG`](assert_msg.md)
- [`BOOST_PP_LIMIT_MAG`](limit_mag.md)

##Requirements

Header: &lt;boost/preprocessor/debug/assert.hpp&gt;

##Sample Code

```cpp
#include <boost/preprocessor/comparison/equal.hpp>
#include <boost/preprocessor/debug/assert.hpp>

// 行番号は翻訳の第一段階でカウントされるはずだ

#line 9
BOOST_PP_ASSERT_MSG( \
	BOOST_PP_EQUAL(__LINE__, 9), \
	"incorrect line numbering detected" \
)
```
* BOOST_PP_ASSERT_MSG[link assert_msg.md]

