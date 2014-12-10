#Member Function Adapters

functional.hpp ヘッダは C++ 標準ライブラリ (§ 20.3.8): 由来のメンバ関 数アダプタの全ての強化バージョンを含んでいる:

- `mem_fun_t`
- `mem_fun1_t`
- `const_mem_fun_t`
- `const_mem_fun1_t`
- `mem_fun_ref_t`
- `mem_fun1_ref_t`
- `const_mem_fun_ref_t`
- `const_mem_fun1_ref_t`

同様に対応するヘルパ関数も提供する。

- `mem_fun`
- `mem_fun_ref`

標準のアダプタそれぞれから、以下の変更がなされている:

`first_argument_type` `typedef` は `const_` ファミリーのメンバ関数アダプタのために 修正されている。([以下](#firstarg) を参照せよ)。

`mem_fun1_t`やその変種に渡される引数は、メンバ関数の引数型として、`call_traits::param_type` を用いて渡される。


## <a name="firstarg" href="firstarg">first_argument_type</a>
標準は `const_mem_fun1_t` を例えば、以下のように指定する:

```cpp
template <class S, class T, class A> class const_mem_fun1_t
  : public binary_function<T*, A, S> {
public:
  explicit const_mem_fun1_t(S (T::*p)(A) const);
  S operator()(const T* p, A x) const;
};
```

`binary_function` への第一引数が実際には `const T*` であるにも関わらず、 `T*` になっている点に注意しなさい。

これはどういうことか？さて、我々が以下のように書くとき何が起こるかを考えなさい。

```cpp
struct Foo { void bar(int) const; };
const Foo *cp = new Foo;
std::bind1st(std::mem_fun(&Foo::bar), cp);
```

我々は以下のようなものを効果的に含む `const_mem_fun1_t` オブジェクトを作成した。

```cpp
typedef Foo* first_argument_type;
```

次に `bind1st` はこの `typedef` を `cp` によって初期化されるメンバ型として用いる `binder1st` オブジェクトを作成する。言い換えれば、我々は `Foo*` メンバを `const Foo*` メンバで初期化する必要がある！ 明らかに これは不可能であるので、標準ライブラリのベンダはこれを実装するために `cp` の定数性を、おそらく `bind1st` の本体の中で、キャストして取り除かなければならなかっただろう。

このハックは改良された [バインダ](./binders.md) とともに用いる場合十分ではないので、我々はメンバ関数アダプタの修正されたバージョンも同様に提供しなければならなかった。


## <a name="arguments" href="arguments">Argument Types</a>
標準は `mem_fun1_t` を例えば以下のように定義する (§20.3.8 ¶2):

```cpp
template <class S, class T, class A> class mem_fun1_t
  : public binary_function<T*, A, S> {
public:
  explicit mem_fun1_t(S (T::*p)(A));
  S operator()(T* p, A x) const;
};
```

`operator()` の第二引数はメンバ関数の引数と全く同じであることに注意しなさい。もしこれが値型であれば、引数は二度値渡しされてコピーされる。

しかしながら、もし我々が引数を代わりに `const A&` として宣言することによってこの非効率性を削除しようとするならば、もし `A` が参照型であれば、我々は参照の参照を持ってしまう。そしてそれは現在のところ非合法である。 (ただし [C++ 言語中核の問題点 106 番目](http://www.open-std.org/jtc1/sc22/wg21/docs/cwg_defects.html#106) を参照せよ)

つまり、`operator()` の引数を宣言する望ましい方法は、メンバ関数の引数が参照であるかないかに依っている。もしそれが参照であるならば、単純に `A` と宣言したいのであり、もし値であれば `const A&` と宣言したいのである。

Boost の [`call_traits`](../utility/call_traits.md) クラステンプレートは `param_type` `typedef` を含んでいて、それは部分特殊化版を用いて正確にこの判断をを行う。`operator()` を 以下のように宣言することによって。

```cpp
S operator()(T* p, typename call_traits<A>::param_type x) const
```

我々は望ましい結果を引き出した - 参照の参照を生み出すことなく、効率性を得たのだ。


## <a name="limitations" href="limitations">Limitations</a>
call traits テンプレートはこの改良を実現するために使われる関数オブジェ クト特性と `call_traits` の両方が部分特殊化版に頼っているので、この改良は部分特殊化の機能を持つコンパイラでのみ有効である。そうでないコンパイラでは、メンバ関数に渡される引数は(`mem_fun1_t` ファミリの中で) 常に参照渡しとなるので、参照の参照の可能性を生みだすことになる。


***
Copyright © 2000 Cadenza New Zealand Ltd. Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies. This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

Revised 28 June 2000


***
Japanese Translation Copyright (C) 2003 shinichiro.h <g940455@mail.ecc.u-tokyo.ac.jp>.

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の 複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」 に提供されており、いかなる明示的、暗黙的保証も行わない。また、 いかなる目的に対しても、その利用が適していることを関知しない。


