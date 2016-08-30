#テクニック集

プリプロセッサメタプログラミングの技を例示する。

##例 - 小さな規模の反復を避けるために局所的なマクロを使う。

```cpp
#define BOOST_PP_DEF(op) /* ..................................... */  \
	template<class T, int n>                                          \
	vec<T, n> operator op ## =(vec<T, n> lhs, const vec<T, n>& rhs) { \
		for (int i = 0; i &lt; n; ++i) {                              \
			lhs(i) op ## = rhs(i);                                    \
		}                                                             \
	}                                                                 \
	/**/

BOOST_PP_DEF(+)
BOOST_PP_DEF(-)
BOOST_PP_DEF(*)
BOOST_PP_DEF(/)

#undef BOOST_PP_DEF
```

###小技:

通常はこのような種類のコードに対して `BOOST_PP_DEF` のような標準的なマクロの名前を使って構わない。
なぜならこのマクロは使用される場所のすぐそばで定義されふたたび未定義にされているから。

###小技:

継続行が正しく使用されているか確認しやすくするには継続文字(バックスラッシュ文字)の位置を揃えるとよい。

###注意:

別の演算子を定義することによってこの例を拡張することができる。
それをする前に、*algebraic categories* (文献 [[Barton]](bibliography.md#barton) で紹介されている)や *layered architecture* (例えば文献 [[Czarnecki]](bibliography.html#czarnecki)) を使うことを考慮せよ。
しかしながら、演算子トークン `*`, `/`, `+`, `-`, 等はテンプレートによっては生成できないから、これらのトークンをどこかに書く必要が出て来るだろう。
そのトークンの反復(*categorical repetition*)はテンプレートメタプログラミングによって除去できる。

##例 - マクロ BOOST_PP_EMPTY を局所的なマクロのインスタンス化の際の未使用パラメータとして使用する。

```cpp
#define BOOST_PP_DEF(cv) /* ... */ \
	template<class base>           \
	cv() typename implement_subscript_using_begin_subscript<base>::value_type& \
	implement_subscript_using_begin_subscript<base>::operator[](index_type i) cv() { \
		return base::begin()[i];   \
	}                              \
	/**/
```

###仕組み:

`BOOST_PP_EMPTY()` は空に展開されるので未使用パラメータとして使用することができる。

###注意:

`BOOST_PP_EMPTY` の後ろに () を付けないと展開されない。

関数のようなマクロを呼ぶには () が必要である。

###警告:

`BOOST_PP_EMPTY()` を使っている場合、 連結(concatenation)は安全に使用できない。

###小技:

時折、1~2行が他の行より極端に長くなることがある。
継続行演算子の位置を全ての行について揃えることを *しない* ことによって、可読性をそれほど犠牲にせずに作業を楽にすることができる。

###小技:

プリプロセッサメタプログラミングのためのマクロ識別子をハイライト表示せよ:

- `BOOST_PP_DEF`
- `BOOST_PP_EMPTY`
- `BOOST_PP_REPEAT`
- ...

これによって可読性が向上する。

##例 - 必要なら ## のかわりに BOOST_PP_CAT を使う。

```cpp
#define STATIC_ASSERT(expr) \
	enum { BOOST_PP_CAT(static_check_, __LINE__) = (expr) ? 1 : -1 }; \
	typedef char \
		BOOST_PP_CAT(static_assert_, __LINE__)[BOOST_PP_CAT(static_check_, __LINE__)] \
	/**/

// ...

STATIC_ASSERT(sizeof(int) <= sizeof(long));
```

###理由:

マクロ展開は(層状に)再帰的に適用される。
トークンの結合はマクロ展開を阻害する。
そのためトークンの結合を遅延せねばならないことがしばしば起きる。

##例 - 必要なら # のかわりに BOOST_PP_STRINGIZE を使う。

```cpp
#define NOTE(str) \
	message(__FILE__ "(" BOOST_PP_STRINGIZE(__LINE__) ") : " str) \
	/**/

// ...

#pragma NOTE("TBD!")
```

###理由:

マクロ展開は(層状に)再帰的に適用される。
文字列化はマクロ展開を阻害するため、文字列化を遅延せねばならないことがしばしば起きる。

##例 - BOOST_PP_ENUM_PARAMS (やその変種)や BOOST_PP_REPEAT や BOOST_PP_COMMA_IF 等を使ってリスト操作の *O*(*n*) 繰り返しを除去する。

```cpp
struct make_type_list_end;

template<
	BOOST_PP_ENUM_PARAMS_WITH_A_DEFAULT(
		MAKE_TYPE_LIST_MAX_LENGTH, 
		class T, 
		make_type_list_end
	)
>
struct make_type_list {
private:
	enum { end = is_same&lt;T0, make_type_list_end&gt;::value };
public:
	typedef typename type_if<
		end, type_cons_empty,
		type_cons<
			T0,
			typename type_inner_if<
				end, type_identity<end>,
				make_type_list<
					BOOST_PP_ENUM_SHIFTED_PARAMS(
						MAKE_TYPE_LIST_MAX_LENGTH,
						T
					)
				>
			>::type
		>
	>::type type;
};
```

###仕組み:

`BOOST_PP_REPEAT` は再帰もどきを使用する (疑似コード):

```cpp
#define BOOST_PP_REPEAT(n, m, p) BOOST_PP_REPEAT ## n(m, p)

#define BOOST_PP_REPEAT0(m, p)
#define BOOST_PP_REPEAT1(m, p) m(0, p)
#define BOOST_PP_REPEAT2(m, p) m(0, p) m(1, p)
#define BOOST_PP_REPEAT3(m, p) BOOST_PP_REPEAT2(m, p) m(2, p)
#define BOOST_PP_REPEAT4(m, p) BOOST_PP_REPEAT3(m, p) m(3, p)
// ...
```

###注意:

*上のコードは決して `BOOST_PP_REPEAT` の実装などではなく、単に説明のためのものである！*

`BOOST_PP_ENUM_PARAMS` とその変種は `BOOST_PP_REPEAT` を使っている。
`BOOST_PP_COMMA_IF(I)` は I != 0 のときコンマに展開される。
`BOOST_PP_INC(I)` は本質的には "I+1" に展開され、`BOOST_PP_DEC(I)` は "I-1" に展開される。

##例 - ある上限を決めるのではなく、*条件付きのマクロ定義* を使って、必要に応じてユーザがコードの繰り返しを制御できるようにする。

```cpp
#ifndef MAKE_TYPE_LIST_MAX_LENGTH
#define MAKE_TYPE_LIST_MAX_LENGTH 8
#endif
```

このようにすれば、ライブラリのコードを変更することなくユーザが `make_type_list` を設定することができる。

##例 - BOOST_PP_REPEAT と *トークン照合関数* を使って categorical repetition を除去する。

```cpp
// 注意: 私のコンパイラは算術型に関して標準的ではない。
#define ARITHMETIC_TYPE(I) ARITHMETIC_TYPE ## I

#define ARITHMETIC_TYPE0    bool
#define ARITHMETIC_TYPE1    char
#define ARITHMETIC_TYPE2    signed char
#define ARITHMETIC_TYPE3    unsigned char
#define ARITHMETIC_TYPE4    short
#define ARITHMETIC_TYPE5    unsigned short
#define ARITHMETIC_TYPE6    int
#define ARITHMETIC_TYPE7    unsigned int
#define ARITHMETIC_TYPE8    long
#define ARITHMETIC_TYPE9    unsigned long
#define ARITHMETIC_TYPE10   float
#define ARITHMETIC_TYPE11   double
#define ARITHMETIC_TYPE12   long double

#define ARITHMETIC_TYPE_CNT 13

// ...

#define BOOST_PP_DEF(z, I, _) /* ... */ \
	catch (ARITHMETIC_TYPE(I) t) {      \
		report_typeid(t);               \
		report_value(t);                \
	}                                   \
	/**/

BOOST_PP_REPEAT(ARITHMETIC_TYPE_CNT, BOOST_PP_DEF, _)

#undef BOOST_PP_DEF
```

###注意:

上の例の繰り返しはテンプレートメタプログラミング [[Czarnecki]](bibliography.html#czarnecki) によっても除去できる。
しかしながら演算子トークンの categorical repetition はテンプレートメタプログラミングによっては完全に除去できない。

##例 - BOOST_PP_REPEAT を使って*O*(*n* * *n*)の繰り返しを除去する。

```cpp
#ifndef MAX_VEC_ARG_CNT
#define MAX_VEC_ARG_CNT 8
#endif

// ...

#define ARG_FUN(z, i, _) BOOST_PP_COMMA_IF(i) T a ## i
#define ASSIGN_FUN(z, i, ) (*this)[i] = a ## i;

#define DEF_VEC_CTOR_FUN(z, i, _) /* ... */ \
	vec(BOOST_PP_REPEAT(i, ARG_FUN, _)) {   \
		BOOST_PP_REPEAT(i, ASSIGN_FUN, _)   \
	}                                       \
	/**/

BOOST_PP_REPEAT(BOOST_PP_INC(MAX_VEC_ARG_CNT), DEF_VEC_CTOR_FUN, _)

#undef ARG_FUN
#undef ASSIGN_FUN
#undef DEF_VEC_CTOR_FUN

// ...
```

###仕組み:

`BOOST_PP_REPEAT` は *自動再帰* [訳注: ???]を起こさせるような特別な方法で実装されている。

##例 - BOOST_PP_IF を使って分岐を実現する。

```cpp
#define COMMA_IF(c) \
	BOOST_PP_IF(c, BOOST_PP_COMMA, BOOST_PP_EMPTY)() \
	/**/

BOOST_PP_IF(0, true, false) == false;
BOOST_PP_IF(1, true, false) == true;
```

`BOOST_PP_IF` を使えば `BOOST_PP_REPEAT` を使ったリストの生成を簡単にできる。

###注意:

*THEN* と *ELSE* の部分(第2、第3引数)はマクロである必要はない。
しかし、もしそれらの一方が関数的なマクロであって、それを条件付きで展開したいのであれば、もう一方も関数的マクロにしなければならない。
その目的のために `BOOST_PP_IDENTITY` を使うことができる。
下の例 (Aleksey Gurtovoy による) を見よ:

```cpp
#define NUMBERED_EXPRESSION(i, x) /* ... */ \
	BOOST_PP_IF(                            \
		i,                                  \
		BOOST_PP_IDENTITY(x ## i)           \
		BOOST_PP_EMPTY                      \
	)()                                     \
	/**/
```

###注意:

上の `COMMA_IF` の例のように、`BOOST_PP_IF` の結果が呼ばれても *THEN* や *ELSE* パラメータが呼ばれないことがある。
もしパラメータも呼ばれるなら、`BOOST_PP_IF` が適切に展開される前に `BOOST_PP_EMPTY` が空に展開されるため、そのコードは正しく展開されなくなってしまう。
[訳注: ???]

###仕組み:

`BOOST_PP_IF` は全ての繰り返し範囲について定義されている(疑似コード):

```cpp
#define BOOST_PP_IF(c, THEN, ELSE) BOOST_PP_IF ## c(THEN, ELSE)

#define BOOST_PP_IF0(THEN, ELSE) ELSE
#define BOOST_PP_IF1(THEN, ELSE) THEN
#define BOOST_PP_IF1(THEN, ELSE) THEN
// ...
```

##例: 算術、論理、比較演算を使う。

```cpp
#define SPECIAL_NUMBERED_LIST(n, i, elem, special) \
	BOOST_PP_ASSERT_MSG(                      \
		BOOST_PP_LESS(i, n),                  \
		bad params for SPECIAL_NUMBERED_LIST! \
	)                                         \
	BOOST_PP_ENUM_PARAMS(i, elem)             \
	BOOST_PP_COMMA_IF(i) special              \
	BOOST_PP_REPEAT(                          \
		BOOST_PP_SUB(BOOST_PP_DEC(n), i),     \
		SPECIAL_NUMBERED_LIST_HELPER,         \
		(elem, i)                             \
	)                                         \
	/**/

#define SPECIAL_NUMBERED_LIST_HELPER(z, i, elem_base) \
	,                                            \
	BOOST_PP_CAT(                                \
		BOOST_PP_TUPLE_ELEM(2, 0, elem_base),    \
		BOOST_PP_ADD(                            \
			i,                                   \
			BOOST_PP_TUPLE_ELEM(2, 1, elem_base) \
		)                                        \
	)                                            \
	/**/

SPECIAL_NUMBERED_LIST(3, 0, E, S)
SPECIAL_NUMBERED_LIST(3, 1, E, S)
SPECIAL_NUMBERED_LIST(3, 2, E, S)
SPECIAL_NUMBERED_LIST(3, 3, E, S)
```

---

(C) Copyright [Housemarque Oy](http://www.housemarque.com) 2002

Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies.&nbsp;
This document is provided "as is" without express or implied warranty and with no claim as to its suitability for any purpose.

