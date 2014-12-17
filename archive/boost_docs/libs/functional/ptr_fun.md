#Function Pointer Adapters
functional.hpp ヘッダは C++ 標準 (§ 20.3.7): 由来の関数ポインタアダプ タの両方の強化バージョンを提供する:

- `pointer_to_unary_function`
- `pointer_to_binary_function`

同様に対応するヘルパ関数も提供する。

- `ptr_fun`

しかし、[function object traits](./function_traits.md) を使用しているおかげで、このライブラリのアダプタと接続する場合、このアダプタを使う必要はない。しかしながら、あなたの実装が我々の特性クラスとともにきちんと働かない場合 (部分特殊化版が欠けていることによる) や、サードパーティの関数オブジェクトアダプタとともに使いたい場合に、使う必要があるかもしれない。


## <a name="usage" href="#usage">Usage</a>
これらのアダプタを使う必要がある場合、使い方は標準関数ポインタアダプタと同様である。例えば、

```cpp
bool bad(std::string foo) { ... }
...
std::vector<std::string> c;
...
std::vector<std::string>::iterator it
     = std::find_if(c.begin(), c.end(), std::not1(boost::ptr_fun(bad)));
```

しかしながら、このライブラリは関数オブジェクト特性をサポートする、強化された [ネゲータ](./negators.md) を含んでいることに注意しなさい。それで、以上のソースと同様に以下のように書ける。

```cpp
std::vector<std::string>::iterator it
     = std::find_if(c.begin(), c.end(), boost::not1(bad));
```


## <a name="arguments" href="#arguments">Argument Types</a>
標準は `pointer_to_unary_function` をこのように定 義する(§20.3.8 ¶2):

```cpp
template <class Arg, class Result>
class pointer_to_unary_function : public unary_function<Arg, Result> {
public:
  explicit pointer_to_unary_function(Result (* f)(Arg));
  Result operator()(Arg x) const;
};
```

`operator()` の引数はラップされる関数の引数と厳密に等しい型であることに注意しなさい。もしこれが値型であれば、引数は値渡しされ、二度コピーされる。`pointer_to_binary_function` も同様の問題を持っている。

しかしながら、引数を代わりに `const Arg&` と宣言することによって非効率を削除しようとすると、`Arg` が参照型であった場合、現 在では非合法な (ただし [C++ 言語中核の問題点 106 番目](http://www.open-std.org/jtc1/sc22/wg21/docs/cwg_defects.html#106) を参照せよ)、参照の参照ができてしまう。

つまり、`operator()` の引数を宣言する望ましい方法は、ラップされる関数の引数が参照であるかないかに依っている。もしそれが参照であるならば、単純に `Arg` と宣言したいのであり、もし値であれば `const Arg&` と宣言したいのである。

Boost の [`call_traits`](../utility/call_traits.md) クラステンプレートは `param_type` `typedef` を含んでいて、それは部分特殊化版を用いて正確にこの判断をを行う。`operator()` を以下のように宣言することによって。

```cpp
Result operator()(typename call_traits<Arg>::param_type x) const
```

我々は望ましい結果を引き出した - 参照の参照を生み出すことなく、効率性を得たのだ。


## <a name="limitations" href="#limitations">Limitations</a>
call traits テンプレートはこの改良を実現するために使われる関数オブジェクト特性と `call_traits` の両方が部分特殊化版に頼っているので、この改良は部分特殊化の機能を持つコンパイラでのみ有効である。そうでないコンパイラでは、関数に渡される引数は常に参照渡しとなるので、参照の参照の可能性を生みだすことになる。


***
Copyright © 2000 Cadenza New Zealand Ltd. Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies. This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

Revised 28 June 2000


***
Japanese Translation Copyright (C) 2003 shinichiro.h <g940455@mail.ecc.u-tokyo.ac.jp>.

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の 複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」 に提供されており、いかなる明示的、暗黙的保証も行わない。また、 いかなる目的に対しても、その利用が適していることを関知しない。
