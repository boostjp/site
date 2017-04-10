# Coding Guidelines for Integral Constant Expressions

汎整数定数式は C++ の多くの場面で用いられる。配列のサイズや、bit-field (※訳語データベースへ？) 、列挙値の初期化や、型でないテンプレートパラメータ (※訳語データベースへ？) の引数として。しかしながら多くのコンパイラは汎整数定数式の扱いに問題を抱えている。つまりこの結果として、特に型でないテンプレートパラメータを使ったプログラミングは、困難に満ちたものになりうる。そしてしばしば、特定のコンパイラでは型でないテンプレートパラメータはサポートされていない、という間違った推論に陥いらせる。この短い記事は、これに従えば、汎整数定数式を Boost に正しくサポートされている全てのコンパイラでポータブルな作法で用いることができるようになるガイドラインと回避方法を提供するようにデザインされている。この記事は主に Boost ライブラリの作者に向けられたものであるが、何故 Boost のコードがそのような方法で書かれているのかを理解することや、自身でポータブルなコードを書くことを欲するユーザにとっても役に立つものであろう。

## 汎整数定数式とは何か？

汎整数定数式は標準のセクション 5.19 で述べられている。そしてしばしば「コンパイル時定数」と呼ばれる。汎整数定数式は下記のいずれかになりうる:

1. 汎整数定数、例えば `0u` や `3L`。
2. 列挙の値。
3. グローバルな汎整数定数、例えば:
```cpp
const int my_INTEGRAL_CONSTANT = 3;
```
4. 静的メンバの定数、例えば:
```cpp
struct myclass
{ static const int value = 0; };
```
5. メンバの列挙の値、例えば:
```cpp
struct myclass
{ enum{ value = 0 }; };
```
6. 整数型や列挙型の型でないテンプレートパラメータ。
7. `sizeof` 式の結果、例えば:
```cpp
sizeof(foo(a, b, c))
```
8. 対象の型が整数型か列挙型で、かつ引数がその他の汎整数定数式のいずれかであるか浮動小数定数である場合の `static_cast` の結果。
9. 二つの汎整数定数式に二項演算子を適用した結果:

    `INTEGRAL_CONSTANT1 op INTEGRAL_CONSTANT2`

    演算子が除算演算子やコンマ演算子で無い場合に提供される。

10. 汎整数定数式に単項演算子を適用した結果:

    `op INTEGRAL_CONSTANT1`

    演算子がインクリメントやデクリメント演算子で無い場合に提供される。

## コーディングガイドライン

以下のガイドラインは特別な順番で並んでいるわけではない (言い換えれば、申し訳無いが、あなたはこれら全てに従う必要があるということだ)。そして不完全でもあるかもしれない、コンパイラの変更やさらなる問題との遭遇のために、さらにガイドラインが加わるかもしれない。

### クラスメンバの定数を宣言するときは必ず `BOOST_STATIC_CONSTANT` マクロを使う。

```cpp
template <class T>
struct myclass
{
   BOOST_STATIC_CONSTANT(int, value = sizeof(T));
};
```

Rationale: メンバ定数のインライン初期化をサポートしていないコンパイラもある。メンバの列挙をうまく扱えないコンパイラもある (それらは必ずしも汎整数定数式として扱わない)。`BOOST_STATIC_CONSTANT` マクロは問題のコンパイラで最も適切な方法を使用する。

### `int` より大きな型の汎整数定数式を宣言しない。

Rationale: 理論上は全ての汎整数型を汎整数定数式の中で使用できるが、実際問題として、大くのコンパイラは汎整数定数式を `int` より大きくない型に制限する。

### 論理演算子を汎整数定数式に対して使わない。代わりにテンプレートメタプログラミングを使う。

&lt;boost/type_traits/ice.hpp&gt; ヘッダはたくさんの回避方法のテンプレートを含んでいる。それは論理演算子の役割りを成し遂げる。例えば以下のように書く代わりに:

```cpp
INTEGRAL_CONSTANT1 || INTEGRAL_CONSTANT2
```

以下を使いなさい:

```cpp
::boost::type_traits::ice_or<INTEGRAL_CONSTANT1,INTEGRAL_CONSTANT2>::value
```

Rationale: 多くのコンパイラ(特に Borland と Microsoft のコンパイラ)は論理演算子を含む汎整数定数式を真の汎整数定数式として認識しない傾向がある。この問題は通常、汎整数定数式がテンプレートのコードの内部の奥深くにあって、複写して診断することが難しい場合にのみ現れる。

### 型でないテンプレート引数として使われる汎整数定数式の中でいかなる演算子も使うな。

以下よりも:

```cpp
typedef myclass<INTEGRAL_CONSTANT1 == INTEGRAL_CONSTANT2> mytypedef;
```

以下を使いなさい:

```cpp
typedef myclass< some_symbol> mytypedef;
```

ただし、`some_symbol` はその値が `(INTEGRAL_CONSTANT1 == INTEGRAL_CONSTANT2)` となる汎整数定数式に与えられた名前である。

Rationale: 古い EDG ベースのコンパイラ (それがそのプラットフォームで最新のバージョンである場合もある。) は、演算子を含む式を型でないテンプレートパラメータであると認識しない。たとえそのような式が汎整数定数式としてどこか他の場所で使うことができるとしても。

### 汎整数定数式を参照するために、常に完全に修飾された名前を使いなさい。

例えば:

```cpp
typedef myclass< ::boost::is_integral<some_type>::value> mytypedef;
```

Rationale: 少なくとも一つのコンパイラ (Borland のもの) は名前が完全に修飾されていなければ (完全に修飾されているとは、`::` で始まっていることを指す)、汎整数定数式の名前を認識しない。

### '`<`' と '`::`' の間には常に空白を入れなさい。

例えば:

```cpp
typedef myclass< ::boost::is_integral<some_type>::value> mytypedef;
                ^
                ここにスペースがあることを確認しなさい!
```

Rationale: `<:` はそれ自身で合法的な二重字であって、それゆえ`<::` は `[:` と同様に解釈される。

### 汎整数定数式としてローカルな名前を使うな。

Example:

```cpp
template <class T>
struct foobar
{
   BOOST_STATIC_CONSTANT(int, temp = computed_value);
   typedef myclass<temp> mytypedef;  // error
};
```

Rationale: 少なくとも一つのコンパイラ (Borland のもの) はこれを受け入れない。

しかしながら、以下を使うことによってこれを修正することができる:

```cpp
template <class T>
struct foobar
{
   BOOST_STATIC_CONSTANT(int, temp = computed_value);
   typedef foobar self_type;
   typedef myclass<(self_type::temp)> mytypedef;  // OK
};
```

これは少なくとも一つのコンパイラ (VC6) で通らない。汎整数定数式を別の特性クラスに移す方がより良い。

```cpp
template <class T>
struct foobar_helper
{
   BOOST_STATIC_CONSTANT(int, temp = computed_value);
};

template <class T>
struct foobar
{
   typedef myclass< ::foobar_helper<T>::value> mytypedef;  // OK
};
```

### 型で無いテンプレートパラメータのために他に依存する値を使うな。

例えば:

```cpp
template <class T, int I = ::boost::is_integral<T>::value>  // Error can't deduce value of I in some cases.
struct foobar;
```

Rationale: この種の使い方は Borland C++ で失敗する。これはデフォルト値が前のテンプレートパラメータに依存している場合のみの問題であることに注意しなさい。例えば、以下は問題無い:

```cpp
template <class T, int I = 3>  // OK, default value is not dependent
struct foobar;
```

## 未解決の問題

以下の問題は解決していないか、コンパイラ毎の解決があるか、一つ以上のコーディングガイドラインを破るかのどれかである。

### numeric_limits に気をつけなさい

ここには三つの問題がある:

1. &lt;limits&gt; ヘッダが無いかもしれない。&lt;limits&gt; を決して 直接インクルードせず、代わりに &lt;boost/pending/limits.hpp&gt; を使うことが推奨される。このヘッダはもしそれがあるなら、『本当の』 &lt;limits&gt; ヘッダをインクルードする。もし無ければ自身の std::numeric_limits の定義を提供する。Boost は &lt;limits&gt; ヘッダが無ければ、BOOST_NO_LIMITS マクロも定義する。
2. std::numeric_limits の実装はその静的定数メンバが汎整数定数式として使うことができない方法で定義されるかもしれない。これは非標準であるが、少なくとも二つの標準ライブラリベンダに影響するバグであるようだ。Boost はこの場合、&lt;boost/config.hpp&gt; の中で BOOST_NO_LIMITS_COMPILE_TIME_CONSTANTS を定義する。
3. VC6 には std::numeric_limits のメンバがテンプレートのコードの中 で『早まって評価』されうるという奇妙なバグがある。例えば:

```cpp
template <class T>
struct limits_test
{
   BOOST_STATIC_ASSERT(::std::numeric_limits<T>::is_specialized);
};
```

このコードはたとえテンプレートがインスタンス化されなくても VC6 でコンパイルに失敗する。いくつかの奇怪な理由のために `::std::numeric_limits<T>::is_specialized` はテンプレートパラメータ T が何であろうと常に偽と評価される。この問題は `std::numeric_limits` に依存する式に限定されるようである: 例えば、もし `::std::numeric_limits<T>::is_specialized` を `::boost::is_arithmetic<T>::value` に置換すれば、全てうまくいく。以下の回避方法もうまく働くが、コーディングガイドラインに抵触する:

```cpp
template <class T>
struct limits_test
{
   BOOST_STATIC_CONSTANT(bool, check = ::std::numeric_limits<T>::is_specialized);
   BOOST_STATIC_ASSERT(check);
};
```

だから、以下のようなものが多分最上の手段である:

```cpp
template <class T>
struct limits_test
{
#ifdef BOOST_MSVC
   BOOST_STATIC_CONSTANT(bool, check = ::std::numeric_limits<T>::is_specialized);
   BOOST_STATIC_ASSERT(check);
#else
   BOOST_STATIC_ASSERT(::std::numeric_limits<T>::is_specialized);
#endif
};
```

### `sizeof` 演算子の使い方に気をつけなさい。

私の知る限り、全てのコンパイラはその引数が型の名前 (やテンプレートの識別子) である場合 `sizeof` 式を正しく扱うようだ。しかしながら以下のような場合問題が起こりうる:

1. 引数がメンバ変数やローカル変数の名前である場合 (コードは VC6 ではコンパイルされないだろう)。
2. 引数が一時変数の生成を含む式である場合 (コードは Borland C++ でコンパイルされないだろう)。
3. 引数がオーバーロードされた関数呼出しを含む場合 (コードは Metroworks C++ ではコンパイルされるが、結果は間違った値になる)。

### 必要無ければ `boost::is_convertible` を使うな

`is_convertible` は `sizeof` 演算子を用いて実装されているので、Metroworks のコンパイラと使う場合は常に間違った値を返し、Borland のコンパイラではコンパイルされないかもしれない。(テンプレート引数が使われるかどうかに依る)。

---

Copyright Dr John Maddock 2001, all rights reserved.

---
Japanese Translation Copyright (C) 2003 shinichiro.h &lt;g940455@mail.ecc.u-tokyo.ac.jp&gt;.

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。
