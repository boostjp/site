#Function Object Traits

functional.hpp ヘッダは関数と関数オブジェクトのための、二つの特性クラステンプレートを提供します:

| Type | Contents | Description |
| `template <typename T>`<br/> `struct unary_traits` | `function_type` | 関数や関数オブジェクト自身の型 (例えば `T`)。 |
| | `param_type`    | 関数や関数オブジェクトをパラメータとして渡すために使われるべき型。 |
| | `result_type`   | 関数や関数オブジェクトの返り値の型。 |
| | `argument_type` | 関数や関数オブジェクトの引数の型。 |
| `template <typename T>`<br/> `struct binary_traits` | `function_type` | 関数や関数オブジェクト自身の型 (例えば `T`)。 |
| | `param_type`  | 関数や関数オブジェクトをパラメータとして渡すために使われるべき型。 |
| | `result_type` | 関数や関数オブジェクトの返り値の型。 |
| | `first_argument_type`  | 関数や関数オブジェクトの第一引数の型。 |
| | `second_argument_type` | 関数や関数オブジェクトの第二引数の型。 |


##Usage
`unary_traits` は一引数を取る関数と適合一引数関数オブジェクト (例えば `std::unary_function` を継承したクラス) や、同様の `typedef` がなされたクラス)のどちらかとともに実体化されなければならない。(C++ 標準の §20.3.1 を参照せよ)

`binary_traits` は二引数を取る関数と適合二引数関数オブジェクト (例えば `std::binary_function` を継承したクラス) や、同様の `typedef` がなされたクラス)のどちらかとともに実体化されなければならない。(C++ 標準の §20.3.1 を参照せよ)

これらのテンプレートのもっとも一般的な使い方は、関数オブジェクトアダプタ内で、関数オブジェクトと同様に普通の関数を適合させることである。普段例えば、

```cpp
typename Operation::argument_type
```

と書く所ならどこでも、代わりに

```cpp
typename boost::unary_traits<Operation>::argument_type
```

と書くだけで良い。


##Additional Types Defined
標準の返り値と引数の `typedef` に加えて、これらの特性テンプレートは二つの型を定義する。


###`function_type`
これは関数や関数オブジェクトの型である。そして、宣言の中で以下のように使われる。

```cpp
template <class Predicate>
class unary_negate : // ...
{
  // ...
  private:
    typename unary_traits<Predicate>::function_type pred;
};
```

もしこの `typedef` がなければ、`unary_negate`を関数型とともに実体化させることができる方法で、`pred`を宣言することはできないだろう。(C++ 標準の §14.3.1 ¶3 を参照せよ)


###`param_type`
これは関数や関数オブジェクトを他の関数に引数として渡すのに最適な型である。

```cpp
template <class Predicate>
class unary_negate : // ...
{
  public:
    explicit unary_negate(typename unary_traits<Predicate>::param_type x)
        :
        pred(x)
    {}
    // ...
};
```

関数オブジェクトは定数参照で渡され、関数ポインタは値渡しされる。


##Limitations
このライブラリは全てのアダプタ関数オブジェクトでこれらの特性を利用していて、理論的には、`ptr_fun`を廃止されるようにする。しかし、サードパーティのアダプタは多分このメカニズムを利用しないだろうし、`ptr_fun`は未だ必要である。このライブラリは標準関数ポインタアダプタの改善バージョンを提供する。

これらの特性テンプレートも、テンプレートの部分特殊化版を提供できないコンパイラでは動かないだろう。これらのコンパイラでは、特性テンプレートは適合関数オブジェクトでのみ実体化され、このライブラリの関数オブジェクトとももに用いる場合でさえ、`ptr_fun`を使う必要があるだろう。


***
Copyright © 2000 Cadenza New Zealand Ltd. Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies. This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

Revised 28 June 2000

***
Japanese Translation Copyright (C) 2003 shinichiro.h <g940455@mail.ecc.u-tokyo.ac.jp>.

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の 複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」 に提供されており、いかなる明示的、暗黙的保証も行わない。また、 いかなる目的に対しても、その利用が適していることを関知しない。

