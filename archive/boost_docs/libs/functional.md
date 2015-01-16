#Improved Function Object Adapters

- 翻訳元ドキュメント : <http://www.boost.org/doc/libs/1_31_0/libs/functional/>

functional.hpp ヘッダは C++ 標準ライブラリの関数オブジェクトアダプタ(セクション 20.3.5 から 20.3.8)を強化する。この強化は主に二つの変更を行う。

1. 我々は、[参照の参照](./functional/binders.md#refref) 問題を回避し、[引数渡し](./functional/mem_fun.md#args) の効率を良くするために、Boost の [`call_traits`](./utility/call_traits.md.nolink) テンプレートを使う。
2. 我々は、[`ptr_fun`](./functional/ptr_fun.md) の必要性を回避するために、このライブラリのアダプタとともに、ふたつの[function object traits](./functional/function_traits.md) を使う。


##Contents
このヘッダは以下の関数・クラステンプレートを含む:

| 分類 | 機能 | 説明 |
|------|------|------|
| [Function object traits](./functional/function_traits.md) | `unary_traits`<br/> `binary_traits` | 関数オブジェクトや関数の引数型を決定するために使われる。`ptr_fun`の必要性を除去する。 |
| [Negators](./functional/negators.md) | `unary_negate`<br/> `binary_negate`<br/> `not1`<br/> `not2` | 標準のセクション 20.3.5 に基づく。 |
| [Binders](./functional/binders.md) | `binder1st`<br/> `binder2nd`<br/> `bind1st`<br/> `bind2nd` | 標準のセクション 20.3.6 に基づく。 |
| [Adapters for pointers to functions](./functional/ptr_fun.md) | `pointer_to_unary_function`<br/> `pointer_to_binary_function`<br/> `ptr_fun` | 標準のセクション 20.3.7 に基づく。このライブラリとともに使用する場合はバインダやネゲータは関数に適合できるので不要である。しかし、サードパーティのアダプタに必要とされるかもしれない。 |
| [Adapters for pointers to member functions](./functional/mem_fun.md) | `mem_fun_t`<br/> `mem_fun1_t`<br/> `const_mem_fun_t`<br/> `const_mem_fun1_t`<br/> `mem_fun_ref_t`<br/> `mem_fun1_ref_t`<br/> `const_mem_fun_ref_t`<br/> `const_mem_fun1_ref_t`<br/> `mem_fun`<br/> `mem_fun_ref` | 標準のセクション 20.3.8 に基づく。 |


##Usage
これらのアダプタの使い方は標準関数オブジェクトアダプタの使い方にとてもよく似ている。唯一の違いは、`std::` の代わりに `boost::` と書く必要があることだけである。そうすればあなたの頭痛は軽減される。

例えば、あなたが `set_name` 関数を持つ`Person`クラスを持っていると考えてほしい:

```cpp
class Person
{
  public:
    void set_name(const std::string &name);
  // ...
};
```

あなたは以下のように書くことによって、コレクション `c` 中の `Person` の束を改名できる。

```cpp
std::for_each(c.begin(), c.end(), 
              boost::bind2nd(boost::mem_fun_ref(&Person::set_name), "Fred"));
```

もし代わりに標準アダプタが使われていれば、このコードは普通、コンパイルに失敗する。それは、`set_name` が参照引数を取るからである。何故こうなるかを解明したければ、[バインダのドキュメント](./functional/binders.md#refref) の中のコメントを参照するとよい。


##Compiler Compatibility
このヘッダと [テストプログラム](./functional/function_test.cpp.md) は以下のコンパイラでコンパイルされる:

| コンパイラ | コメント | 
|------------|----------|
| Borland C++Builder 4 Update 2 | 既知の問題はない。 |
| Borland C++ 5.5               | 既知の問題はない。 |
| g++ 2.95.2                    | 既知の問題はない。 |
| Microsoft Visual C++ Service Pack 3 | コンパイラが部分特殊化版を欠いているため、このライブラリは標準アダプタによって提供されるより、少しだけしか多くの機能を提供しない。<br/> ・参照の参照問題を回避するための `call_traits` メカニズムが使えない。それゆえ、このライブラリのアダプタはより少ない状況でしか使えないだろう。<br/> ・関数の引数や返り値型を特定するための `function_traits` メカニズムが使えない。それゆえ、関数を適合させるため、`ptr_fun` が引き続き必要になる。 |


##Future Directions
このライブラリの第一目的は、できる限り多くの標準ライブラリの互換性を 持つ、参照の参照問題に対する解である。これによって本や雑誌で読む技術を 今日のたくさんのコンパイラで使うことができる。

長期的には、より良い解は以下のようなものだろう:

1. 幾人かの Boost のメンバは式テンプレートのライブラリを作成し ている。これらによって、関数の結合や適合が自然な文法で行えるだろう。 これは新しい技術なので、それが熟して、有名なコンパイラに広くサポートされるまでに時間がかかるかもしれないが、大きな成功となるだろう。それまでは、この functional.hpp ライブラリがギャップを埋める。
2. 標準委員会はテンプレートの実体化に際して参照の参照問題が起きることを認識していて、標準を修正する気になっている( [C++ 言語中核の問題点 106 番目](http://www.open-std.org/jtc1/sc22/wg21/docs/cwg_defects.html#106) を参照せよ)。


##Author
[Mark Rodgers](http://www.boost.org/doc/libs/1_31_0/people/mark_rodgers.htm)


##Acknowledgements
Thanks to [John Maddock](http://www.boost.org/doc/libs/1_31_0/people/john_maddock.htm) for suggesting the mechanism that allowed the function objects traits to work correctly. [Jens Maurer](http://www.boost.org/doc/libs/1_31_0/people/jens_maurer.htm) provided invaluable feedback during the [formal review process](http://www.boost.org/doc/libs/1_31_0/more/formal_review_process.htm).

***
Copyright © 2000 Cadenza New Zealand Ltd. Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies. This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

Revised 28 June 2000


***
Japanese Translation Copyright (C) 2003 shinichiro.h <g940455@mail.ecc.u-tokyo.ac.jp>.

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の 複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」 に提供されており、いかなる明示的、暗黙的保証も行わない。また、 いかなる目的に対しても、その利用が適していることを関知しない。

