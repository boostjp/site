# scoped_ptr class template

`scoped_ptr`クラステンプレートは動的に割り当てられたオブジェクトへのポインタを保持する。
(動的に割り当てられたオブジェクトとはC++の`new`で割り当てられたものである。)
指されたオブジェクトは`scoped_ptr`のデストラクト時か、明示的な`reset`によって削除されることが保証されている。
[example](#example)を参考のこと。

`scoped_ptr`テンプレートはシンプルな要求におけるシンプルな解決法である。
これは、所有権の共有や移動を伴わずに、デザインパターンの&quot;Resource Acquisition Is Initialization&quot;イディオム(訳注:RAIIパターン、「資源獲得を初期化時に行う」ことによりオブジェクトの所有権の所在を明確にする)を実現するための基礎的な仕組みを提供する。
`scoped_ptr`の名前と意味的な主張(noncopyableであるということ)の両方が、そのスコープでの所有権の所在が唯一であることを表す。
これはnoncopyableであり、コピーされるべきでないポインタに対して、`shared_ptr`や`std::auto_ptr`よりも安全である。

`scoped_ptr`はとてもシンプルなので、通常の実装では全ての操作は組み込みポインタと同様に速く、組み込みポインタよりも大きな記憶スペースを取ることはない。

`scoped_ptr`は C++ 標準ライブラリコンテナの中で使うことはできない。
コンテナの中にスマートポインタを格納する必要があるときは、[shared_ptr](shared_ptr.md)を使う。

`scoped_ptr`は動的に割り当てられた配列を正しく扱うことはできない。
動的に割り当てられた配列を扱うためには、[scoped_array](scoped_array.md)を参考にせよ。

このクラステンプレートには、指し示すオブジェクトの型を表すパラメータ`T`を与える。
`T`はスマートポインタの[共通の要求事項](smart_ptr.md#Common requirements)を満たさなければならない。

## Synopsis

```cpp
namespace boost {

template<typename T> class scoped_ptr : noncopyable {

public:
    typedef T element_type;

    explicit scoped_ptr(T * p = 0); // never throws
    ~scoped_ptr(); // never throws

    void reset(T * p = 0); // never throws

    T & operator*() const; // never throws
    T * operator->() const; // never throws
    T * get() const; // never throws
     
    void swap(scoped_ptr & b); // never throws
};

template<typename T>
void swap(scoped_ptr<T> & a, scoped_ptr<T> & b); // never throws

}
```
* element_type[link #element_type]
* scoped_ptr[link #constructors]
* ~scoped_ptr[link #destructor]
* reset[link #reset]
* operator*[link #indirection]
* operator->[link #indirection]
* get[link #get]
* swap[link #swap]
* swap[link #free-swap]

## Members

### <a name="element_type">element_type</a>

`typedef T element_type;`

保持するポインタの型を規定する

### <a name="constructors">constructors</a>

`explicit scoped_ptr(T * p = 0); // never throws`

`scoped_ptr`を構築して、`p`のコピーを保持する。
`p`は C++ の`new`によって割り当てられたものか、0でなければならない。
`T`は完全型である必要はない。
スマートポインタの[共通の要求事項](smart_ptr.md#Common requirements)を参考にせよ。

### <a name="destructor">destructor</a>

`~scoped_ptr(); // never throws`

保持するポインタが指すオブジェクトを、まるで`delete this->get()`としたかのようにして破棄する。

例外を送出しないという保証は、削除されるオブジェクトのデストラクタが例外を送出しないという要求に依存する。
スマートポインタの[共通の要求事項](smart_ptr.md#Common requirements)を参考にせよ。

### <a name="reset">reset</a>

`void reset(T * p = 0); // never throws`

`p`が保持するポインタと等価でなければ、保持するポインタが指すオブジェクトを削除し、`p`のコピーを保持する。
`p`はC++の`new`によって割り当てられたものか、0でなければならない。
例外を送出しないという保証は、削除されるオブジェクトのデストラクタが例外を送出しないという要求に依存する。
スマートポインタの[共通の要求事項](smart_ptr.md#Common requirements)を参考にせよ。

### <a name="indirection">indirection</a>

`T & operator*() const; // never throws`

保持するポインタが指すオブジェクトの参照を返す。
保持するポインタが0なら動作は未定義である。

`T * operator->() const; // never throws`

保持するポインタを返す。
保持するポインタが0なら動作は未定義である。

### <a name="get">get</a>

`T * get() const; // never throws`

保持するポインタを返す。
`T`は完全型である必要はない。
スマートポインタの[共通の要求事項](smart_ptr.md#Common requirements)を参考にせよ。

### <a name="swap">swap</a>

`void swap(scoped_ptr & b); // never throws`

ふたつのスマートポインタの中身を交換する。
`T`は完全な型である必要はない。
スマートポインタの[共通の要求事項](smart_ptr.md#Common requirements)
を参考にせよ。

## <a name="functions">Free Functions</a>

### <a name="free-swap">swap</a>

`template<typename T> void swap(scoped_ptr<T> & a, scoped_ptr<T> & b); // never throws`

`a.swap(b)`と等価である。
`std::swap`のインターフェースとの一貫性を図り、ジェネリックプログラミングを支援する。

## <a name="example">Example</a>

`scoped_ptr`の使い方の例を示す。

```cpp
#include <boost/scoped_ptr.hpp>
#include <iostream>

struct Shoe { ~Shoe() { std::cout << "Buckle my shoe\n"; } };

class MyClass {
    boost::scoped_ptr<int> ptr;
  public:
    MyClass() : ptr(new int) { *ptr = 0; }
    int add_one() { return ++*ptr; }
};

void main()
{
    boost::scoped_ptr<Shoe> x(new Shoe);
    MyClass my_instance;
    std::cout << my_instance.add_one() << '\n';
    std::cout << my_instance.add_one() << '\n';
}
```

このプログラムは子守唄の始めの部分をつくる(※訳注:例が分かりにくい。)

```cpp
1
2
Buckle my shoe
```

## Rationale

`auto_ptr`に代わって`scoped_ptr`を使う第一の理由は、「資源獲得は初期化時に行う」RAIIパターンがカレントスコープでのみ適用されることと、所有権の移動はないことの二つのことをソースを読む人に伝えることである。

`scoped_ptr`を使う第二の理由は、後になってメンテナンスするプログラマが、`auto_ptr`を返すことで所有権を移動させる関数を加えることを防ぐ、ということだ。
なぜなら、メンテナンスプログラマは`auto_ptr`を見れば、所有権を安全に移動することが可能だと考えてしまうからである。

`bool`と`int`を考えよう。
我々は皆、蓋を開けてみれば`bool`はただの`int`に過ぎないことを知っている。
実際、そのため`bool`をC++の標準に含めることに反対した者もいる。
しかし、単に`int`と書くのではなく`bool`と書くことで、プログラマの意図をはっきりと表現することができる。
`scoped_ptr`も同じことである。
これを使えば、何をしたいかをはっきりと伝えることができる。

`scoped_ptr<T>`は`std::auto_ptr<T> const`と等価であると考えられるかもしれない。
しかしEd Breyは`reset`が`std::auto_ptr<T> const`ではうまく働かないことを指摘した。

## <a name="Handle/Body">Handle/Body</a> Idiom

`scoped_ptr`の一般的な用法の一つに、handle/body表現 (pimplとも呼ばれる) の実装がある。
handle/body表現とは、オブジェクト本体の実装を隠蔽する(ヘッダファイル中にさらけ出すことを回避する)ためのものである。

サンプルプログラム[scoped_ptr_example_test.cpp](http://www.boost.org/doc/libs/1_31_0/libs/smart_ptr/example/scoped_ptr_example_test.cpp)は、ヘッダファイル[scoped_ptr_example.hpp](http://www.boost.org/doc/libs/1_31_0/libs/smart_ptr/example/scoped_ptr_example.hpp)をインクルードしている。
このヘッダファイルでは、不完全型のポインタを取る`scoped_ptr<>`を利用して実装を隠蔽している。
完全型が必要となるメンバ関数のインスタンス化は、実装ファイル[scoped_ptr_example.cpp](http://www.boost.org/doc/libs/1_31_0/libs/smart_ptr/example/scoped_ptr_example.cpp)の中に記述されている。

## Frequently Asked Questions

**Q**.
なぜ`scoped_ptr`はメンバ関数`release()`を持たないのか?

**A**.
ソースコードを読んでいるとき、使われている型に基づいてプログラムの動作を結論付けられることは価値がある。
もし`scoped_ptr`がメンバ関数`release()`を持っていれば、保持するポインタの所有権の移動が可能になり、資源の寿命を与えられた文脈に制限するという役割が弱くなる。
所有権の移動が必要なときは`std::auto_ptr`を使えばよい。
(Dave Abrahamにより提供されている。)

---

Revised 17 September 2002

Copyright 1999 Greg Colvin and Beman Dawes.
Copyright 2002 Darin Adler. 
Copyright 2002 Peter Dimov.
Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies.
This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

Japanese Translation Copyright (C) 2003 [Kohske Takahashi](mailto:kohske@msc.biglobe.ne.jp), [Ryo Kobayashi](mailto:lenoir@zeroscape.org).

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。
このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。
また、いかなる目的に対しても、その利用が適していることを関知しない。

