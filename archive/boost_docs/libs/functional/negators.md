# Negators
functional.hpp ヘッダは C++ 標準 (§20.3.5) 由来のネゲータアダプタの両方の強化バージョンを提供する:

- `unary_negate`
- `binary_negate`

同様に対応するヘルパ関数も提供する。

- `not1`
- `not2`

このライブラリのネゲータは標準バージョンを二つの方法で改良する。

適合関数オブジェクトではなく関数を否定する時、それらは `ptr_fun` の必要を回避するために、[function object traits](function_traits.md) を用いる。

それらは引数や適合された関数に渡す引数を宣言する最上の方法を決するため、Boost の [call traits](../utility/call_traits.md.nolink) を用いる。([下記](#arguments)参照)


## <a id="usage" href="#usage">Usage</a>
使い型は標準ネゲータと同様である。例えば、

```cpp
bool bad(const Foo &foo) { ... }
...
std::vector<Foo> c;
...
std::find_if(c.begin(), c.end(), boost::not1(bad));
```


## <a id="arguments" href="#arguments">Argument Types</a>
C++ 標準 (§20.3.5) は unary negate をこのように定義 している。(binary negate も似ている):

```cpp
template <class Predicate>
  class unary_negate
    : public unary_function<typename Predicate::argument_type,bool> {
public:
  explicit unary_negate(const Predicate& pred);
  bool operator()(const typename Predicate::argument_type& x) const;
};
```

`Predicate` の `argument_type` が参照であった場合、 `operator()` の引数の型は参照の参照になることに注意しなさい。これは、現在の C++ では非合法である。(ただし [C++ 言語中核の問題点 106 番目](http://www.open-std.org/jtc1/sc22/wg21/docs/cwg_defects.html#106) を参照せよ)。

しかしながら、もし代わりに `operator()` を `Predicate` の `argument_type` を変更せずにそのまま採用して定義すると、それが値型であった場合不必要に非効率になってしまう。それは引数が二度コピーされることによる。一度は `unary_negate` の `operator()` を呼ぶ時、さらに適合された関数で `operator()` を呼ぶ時にもう一度である。

つまり`operator()` を宣言する望ましい方法は、 `Predicate` の `argument_type` が参照であるか否かに依 る。もしそれが参照であれば、単純に `argument_type` として宣言したいし、それが値であれば `const argument_type&` として宣言したいのである。

Boost の [`call_traits`](../utility/call_traits.md.nolink) クラステンプレートは `param_type` `typedef` を含んでいて、それは部分特 殊化版を用いて正確にこの判断を行う。`operator()` を 以下のように宣言することによって。

```cpp
bool operator()(typename call_traits<typename Predicate::argument_type>::param_type x) const
```

我々は望ましい結果を引き出した - 参照の参照を生み出すことなく、効率性を得たのだ。実のところ、実際の宣言は関数オブジェクト特性を使うためもう少し複雑である。しかし効果は同様である。


## <a id="limitations" href="#limitations">Limitations</a>
この関数オブジェクト特性の両方と call traits はこの改良を実現するために使われる関数オブジェクト特性と `call_traits` の両方が部分特殊化版に頼っているので、この改良は部分特殊化版の機能を持つコンパイラでのみ有効である。 そうでないコンパイラでは、このライブラリのネゲータは標準内のそれらと非常に似た振る舞いをする - 関数に適合するために `ptr_fun` が必要であるし、参照の参照は避けられないだろう。


***
Copyright © 2000 Cadenza New Zealand Ltd. Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies. This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

Revised 28 June 2000


***
Japanese Translation Copyright (C) 2003 shinichiro.h <mailto:g940455@mail.ecc.u-tokyo.ac.jp>.

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の 複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」 に提供されており、いかなる明示的、暗黙的保証も行わない。また、 いかなる目的に対しても、その利用が適していることを関知しない。

