# scoped_array class template

`scoped_array`クラステンプレートは動的に割り当てられた配列へのポインタを保持する。
(動的に割り当てられた配列とは、C++の`new[]`によって割り当てられたものである。)
`scoped_array`に指された配列は、その`scoped_array`が破棄されたとき、もしくは明示的に`reset`を呼び出したときに削除されることが保証される。

`scoped_array`テンプレートはシンプルな要求におけるシンプルな解決法である。
これは、所有権の共有や移動を伴わずに、デザインパターンの&quot;Resource Acquisition Is Initialization&quot;イディオム(訳注:RAIIパターン、「資源獲得を初期化時に行う」ことによりオブジェクトの所有権の所在を明確にする) を実現するための基礎的な仕組みを提供する。
`scoped_array`の名前と意味的な主張(noncopyableであるということ)の両方が、そのスコープでの所有権の所在が唯一であることを表す。
これはnoncopyableであり、コピーされるべきでないポインタに対して、`shared_array`よりも安全である。

`scoped_array`はとてもシンプルなので、通常の実装では全ての操作は組み込み配列ポインタと同様に速く、組み込み配列ポインタよりも大きな記憶スペースを取ることはない。

`scoped_array`はC++標準ライブラリコンテナの中で使うことはできない。
配列のスマートポインタをコンテナの中に格納する必要があるときは、[shared_array](shared_array.md)を使う。

`scoped_array`は単独のオブジェクトへのポインタを正しく扱うことはできない。
単独のオブジェクトへのポインタを扱うためには[scoped_ptr](scoped_ptr.md)を参考にせよ。

`scoped_array`に代わるものとして、`std::vector`がある。
`std::vector`は`scoped_array`に比べ若干重いが、より柔軟である。
動的なメモリ割当を使わないのであれば、`boost::array`もまた、`scoped_array`の代わりとなる。

このクラステンプレートには、指し示す配列の要素の型を表すパラメータ`T`を与える。
`T`はスマートポインタの[共通の要求事項](smart_ptr.md#Common requirements)を満たさなければならない。

## Synopsis

```cpp
namespace boost {

template<typename T> class scoped_array : noncopyable
{

public:
    typedef T element_type;

    explicit scoped_array(T * p = 0); // never throws
    ~scoped_array(); // never throws

    void reset(T * p = 0); // never throws

    T & operator[](std::ptrdiff_t i) const; // never throws
    T * get() const; // never throws

    void swap(scoped_array & b); // never throws
};

template<typename T>
void swap(scoped_array<T> & a, scoped_array<T> & b); // never throws

}
```
* element_type[link #element_type]
* scoped_array[link #ctor]
* ~scoped_array[link #~scoped_array]
* reset[link #reset]
* operator[][link #operator[]]
* get[link #get]
* swap[link #swap]
* swap[link #free-swap]

## Members

### <a name="element_type">element_type</a>

`typedef T element_type;`

保持されるポインタの型を規定する。

### <a name="ctor">constructors</a>

`explicit scoped_array(T * p = 0); // never throws`

`scoped_array`を構築し、`p`のコピーを保持する。
`p`はC++の`new[]`によって割り当てられた配列へのポインタか、0でなくてはならない。
`T`は完全型である必要はない。
スマートポインタの[共通の要求事項](smart_ptr.md#Common requirements)を参照のこと。

### <a name="~scoped_array">destructor</a>

`~scoped_array(); // never throws`

保持されているポインタが指す配列を削除する。
値が0のポインタに対する `delete[]`が安全であることに注意せよ。 
`T`は完全型である必要はない。
削除される配列の要素のデストラクタが例外を送出しないという条件が満たされている場合、このデストラクタが例外を送出しないことが保証される。
スマートポインタの[共通の要求事項](smart_ptr.md#Common requirements)を参照のこと。

### <a name="reset">reset</a>

`void reset(T * p = 0); // never throws`

`p`が保持するポインタと等価でなければ、保持するポインタが指す配列を削除し、`p`のコピーを保持する。
`p`はC++の`new[]`によって割り当てられたものか、0でなければならない。
削除される配列の要素のデストラクタが例外を送出しないという条件が満たされている場合、このデストラクタが例外を送出しないことが保証される。
スマートポインタの[共通の要求事項](smart_ptr.md#Common requirements)を参照のこと。

### <a name="operator[]">subscripting</a>

`T & operator[](std::ptrdiff_t i) const; // never throws`

保持しているポインタが指す配列の`i`番目の要素への参照を返す。
保持しているポインタが0のとき、及び`i`が0未満または配列の要素数以上の数であるとき、この演算子のふるまいは未定であり、ほぼ確実に有害である。

### <a name="get">get</a>

`T * get() const; // never throws`

保持しているポインタを返す。
`T`は完全型である必要はない。
スマートポインタの[共通の要求事項](smart_ptr.md#Common requirements)を参照のこと。

### <a name="swap">swap</a>

`void swap(scoped_array & b); // never throws`

二つのスマートポインタの中身を交換する。
`T`は完全型である必要はない。
スマートポインタの[共通の要求事項](smart_ptr.md#Common requirements)を参照のこと。

## <a name="functions">Free Functions</a>

### <a name="free-swap">swap</a>

```cpp
template<typename T>
void swap(scoped_array<T> & a, scoped_array<T> & b); // never throws
```

`a.swap`と等価。
`std::swap`のインターフェースとの一貫性を図り、ジェネリックプログラミングを補助するために用意されている。

---

Revised 1 February 2002

Copyright 1999 Greg Colvin and Beman Dawes. Copyright 2002 Darin Adler. 
Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies.
This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

Japanese Translation Copyright (C) 2003 [Ryo Kobayashi](mailto:lenoir@zeroscape.org),
オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。
このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。
また、いかなる目的に対しても、その利用が適していることを関知しない。

