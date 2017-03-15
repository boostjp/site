# Binders
functional.hpp ヘッダは C++ 標準 (§20.3.6): 由来のバインダ関数オブジェクトアダプタの両方の強化バージョンを提供する:

- `binder1st`
- `binder2nd`

同様に対応するヘルパ関数も提供する。

- `bind1st`
- `bind2nd`

標準ライブラリにあるそれらの代わりに、これらのアダプタを使う主な便益は、それらが [参照の参照](#refref) 問題を回避することにある。


## <a name="usage" href="#usage">Usage</a>
使い方は標準バインダと同様である。例えば、

```cpp
class Foo {
public:
  void bar(std::ostream &);
  // ...
};
// ...
std::vector<Foo> c;
// ...
std::for_each(c.begin(), c.end(), 
              boost::bind2nd(boost::mem_fun_ref(&Foo::bar), std::cout));
```


## <a name="refref" href="#refref">References to References</a>
以下の使用例を考えなさい。

```cpp
class Foo {
public:
  void bar(std::ostream &);
  // ...
};
// ...
std::for_each(c.begin(), c.end(), 
              boost::bind2nd(boost::mem_fun_ref(&Foo::bar), std::cout));
```

これがもし `std::bind2nd` と `std::mem_fun_ref` を使って書かれているならば、コンパイルできないだろう。

この問題は `bar` が参照引数を取ることが原因で起こる。標準は `std::mem_fun_ref` を `second_argument_type` が `std::ostream&` である関数オブジェクトを作るように定義する。

`bind2nd` 呼び出しは `binder2nd` を作り、それは標準が以下のように定義している:

```cpp
template <class Operation>
class binder2nd
    : public unary_function<typename Operation::first_argument_type,
                            typename Operation::result_type> {
...
public:
  binder2nd(const Operation& x,
            const typename Operation::second_argument_type& y);
  ...
```

我々の `Operation` の `second_argument_type` は `std::ostream&` であるから、コンストラクタの中の `y` の型は `std::ostream&&` となるだろう。参照の参照を作ることはできないから、参照の参照は C++ では非合法であるとしてこの時点でコンパイルエラーになる。(ただし [C++ 言語中核の問題点 106 番目](http://www.open-std.org/jtc1/sc22/wg21/docs/cwg_defects.html#106) を参照せよ)。

このライブラリのバインダは Boost [`call_traits`](../utility/call_traits.md.nolink) テンプレートを使うことによってこの問題を回避している。

コンストラクタは以下のように宣言される。

```cpp
binder2nd(const Operation& x,
          typename call_traits<
             typename binary_traits<Operation>::second_argument_type
          >::param_type y)
```

結果、`y` は `std::ostream&` 型を持つ。そして、我々の例はコンパイルされる。


***
Copyright © 2000 Cadenza New Zealand Ltd. Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies. This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

Revised 28 June 2000


***
Japanese Translation Copyright (C) 2003 shinichiro.h <mailto:g940455@mail.ecc.u-tokyo.ac.jp>.

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の 複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」 に提供されており、いかなる明示的、暗黙的保証も行わない。また、 いかなる目的に対しても、その利用が適していることを関知しない。

