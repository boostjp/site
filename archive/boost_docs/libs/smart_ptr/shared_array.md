# shared_array class template

`shared_array`クラステンプレートは動的に割り当てられた配列へのポインタを保持する。
(動的に割り当てられた配列とは、C++の`new[]`によって割り当てられたものである。)
`shared_array`に指されたオブジェクトは、そのオブジェクトを指す最後の`shared_array`が破棄もしくはリセットされるときに削除されることが保証される。

全ての`shared_array`はC++標準ライブラリの**CopyConstructible**(コピーコンストラクト可能)と**Assignable**(代入可能)の条件を満たすので、標準ライブラリのコンテナで使うことができる。
また、標準ライブラリの連想コンテナで使うことができるように、比較演算子が提供されている。

通常、`shared_array`は`new`により割り当てられたオブジェクトへのポインタを正しく扱うことはできない。
`new`によって割り当てられたオブジェクトの扱い方については、[shared_ptr](shared_ptr.md)を参照のこと。

`shared_array`の実装には参照カウントが用いられているため、循環参照された`shared_array`のインスタンスは正常に解放されない。
例えば、`main()`が`A`を指す`shared_array`を保持しているときに、その`A`が直接的または間接的に`A`自身を指す`shared_array`を持っていると、`A`に対する参照カウントは2となる。
最初の`shared_array`が破棄される際に、`A`の参照カウントは1となり、そのインスタンスは破棄されずに残ってしまう。

`shared_array`に代わるものとして、`std::vector`を指す`shared_ptr`がある。
これは`shared_array`に比べ若干重いが、より柔軟である。

このクラステンプレートには、指し示す配列の要素の型を表すパラメータ`T`を与える。
`T`はスマートポインタの[共通の要求事項](smart_ptr.md#Common requirements)を満たさなければならない。

## Synopsis

```cpp
namespace boost {

template<typename T> class shared_array {

public:
    typedef T element_type;

    explicit shared_array(T * p = 0);
    template<typename D>
    shared_array(T * p, D d);
    ~shared_array(); // never throws

    shared_array(shared_array const & r); // never throws

    shared_array & operator=(shared_array const & r); // never throws

    void reset(T * p = 0);
    template<typename D>
    void reset(T * p, D d);

    T & operator[](std::ptrdiff_t i) const() const; // never throws
    T * get() const; // never throws

    bool unique() const; // never throws
    long use_count() const; // never throws

    void swap(shared_array<T> & b); // never throws
};

template<typename T>
bool operator==(shared_array<T> const & a, shared_array<T> const & b); // never throws
template<typename T>
bool operator!=(shared_array<T> const & a, shared_array<T> const & b); // never throws
template<typename T>
bool operator<(shared_array<T> const & a, shared_array<T> const & b); // never throws

template<typename T>
void swap(shared_array<T> & a, shared_array<T> & b); // never throws

}
```
* element_type[link #element_type]
* shared_array[link #constructors]
* ~shared_array[link #destructor]
* operator=[link #assignment]
* reset[link #reset]
* operator[][link #indexing]
* get[link #get]
* unique[link #unique]
* use_count[link #use_count]
* swap[link #swap]
* operator==[link #comparison]
* operator!=[link #comparison]
* operator<[link #comparison]
* swap[link #free-swap]

## Members

### <a name="element_type">element_type</a>

`typedef T element_type;`

テンプレートパラメータ T の型を規定する。

### <a name="constructors">constructors</a>

`explicit shared_array(T * p = 0);`

`shared_array`を構築し、`p`のコピーを保持する。
`p`はC++の`new[]`によって割り当てられた配列へのポインタか、0でなくてはならない。
その後、[use count](#use_count)は1になる。
(`p == 0`の場合でも同様である。
[~shared_array](#destructor)を参照のこと)
このコンストラクタが送出する可能性のある例外は`std::bad_alloc`だけである。
もし例外が発生すると、`delete[] p`が呼び出される。

```cpp
template<typename D>
shared_array(T * p, D d);
```

`shared_array`を構築し、`p`のコピーと`d`のコピーを保持する。 
その後、[use count](#use_count)は 1 になる。
`D`のコピーコンストラクタとデストラクタは例外を送出してはならない。
`p`に指されている配列が削除される時になると、
`d`オブジェクトが`d(p)`の形で実行される。
`p`を引数に取る`d`の実行において、例外を送出してはならない。
このコンストラクタが送出する可能性のある例外は`std::bad_alloc`だけである。
もし例外が発生すると、`d(p)`が呼び出される。

`shared_array(shared_array const & r); // never throws`

`shared_array`を構築し、`r`が保持するポインタのコピーを保持したかのように作用する。
その後、全てのコピーの[use count](#use_count)は1増加する。

### <a name="destructor">destructor</a>

`~shared_array(); // never throws`

[use count](#use_count)を1減少させる。
そしてもしuse countが0だった時、保持しているポインタが指す配列を削除する。
値が0のポインタに対する`delete[]`が安全であることに注意。 
`T`は完全型である必要はない。
削除される配列の要素のデストラクタが例外を送出しないという条件が満たされている場合、このデストラクタが例外を送出しないことが保証される。
スマートポインタの[共通の要求事項](smart_ptr.md#Common requirements)を参照のこと。

### <a name="operator=">assignment</a>

`shared_array & operator=(shared_array const & r); // never throws`

[上](#constructors)で説明されているように新しい`shared_array`が構築され、現在の`shared_array`と新しい`shared_array`が交換される。
交換された元のオブジェクトは破棄される。

### <a name="reset">reset</a>

`void reset(T * p = 0);`

[上](#constructors)で説明されているように新しい`shared_array`が構築され、現在の`shared_array`と新しい`shared_array`が交換される。
交換された元のオブジェクトは破棄される。
送出する可能性のある例外は`std::bad_alloc`だけである。
もし例外が発生すると、`delete[] p`が呼び出される。

```cpp
template<typename D>
void reset(T * p, D d);
```

[上](#constructors)で説明されているように新しい`shared_array`が構築され、現在の`shared_array`と新しい`shared_array`が交換される。
交換された元のオブジェクトは破棄される。
`D`のコピーは例外を送出してはならない。
送出する可能性のある例外は`std::bad_alloc`だけである。
もし例外が発生すると、`d(p)`が呼び出される。

### <a name="indirection">indexing</a>

`T & operator[](std::ptrdiff_t i) const; // never throws`

保持しているポインタが指す配列の`i`番目の要素への参照を返す。
保持しているポインタが0のとき、及び`i`が0未満または配列の要素数以上の数であるとき、この演算子のふるまいは未定であり、ほぼ確実に有害である。

### <a name="get">get</a>

`T * get() const; // never throws`

保持しているポインタを返す。
`T`は完全型である必要はない。
スマートポインタの[共通の要求事項](smart_ptr.md#Common requirements)を参照のこと。

### <a name="unique">unique</a>

`bool unique() const; // never throws`

保持しているポインタが他の`shared_array`に共有されていないとき`true`を返す。
そうでなければ`false`を返す。
`T`は完全型である必要はない。
スマートポインタの[共通の要求事項](smart_ptr.md#Common requirements)を参照のこと。

### <a name="use_count">use_count</a>

`long use_count() const; // never throws`

保持しているポインタを共有する`shared_array`オブジェクトの数を返す。
`T`は完全型である必要はない。
スマートポインタの[共通の要求事項](smart_ptr.md#Common requirements)を参照のこと。

`use_count`は、明示的に参照カウントを使わないようにするための`shared_array`の実装に必要とされて用意されているものではないため、将来のバージョンでは削除される可能性がある。
従って、`use_count`はデバッグや試験の為にだけ使用するべきで、製品のコードに使用するべきでない。 

### <a name="swap">swap</a>

`void swap(shared_ptr & b); // never throws`

二つのスマートポインタの中身を交換する。
`T`は完全型である必要はない。
スマートポインタの[共通の要求事項](smart_ptr.md#Common requirements)を参照のこと。

## <a name="functions">Free Functions</a>

### <a name="comparison">comparison</a>

```cpp
template<ypename T>
bool operator==(shared_array<T> const & a, shared_array<T> const & b); // never throws
template<ypename T>
bool operator!=(shared_array<T> const & a, shared_array<T> const & b); // never throws
template<ypename T>
bool operator<(shared_array<T> const & a, shared_array<T> const & b); // never throws
```

二つのスマートポインタが保持するポインタを比較する。
`T`は完全型である必要はない。
スマートポインタの[共通の要求事項](smart_ptr.md#Common requirements)を参照のこと。

`operator<`オーバーロードは、`shared_ptr`オブジェクトの順序付けを定義し、`std::map`などの連想コンテナで使えるようにするために提供される。
`std::map`の実装では、比較を行うために`std::less<T*>`を用いる。
これにより、比較が正しく扱われることを確実にする。
C++標準によると、ポインタに対する関係演算の結果は不定であるが(5.9 [expr.rel] paragraph 2)、ポインタに対する`std::less<>`の結果は明確に定義されている。
(20.3.3 [lib.comparisons] paragraph 8).

### <a name="free-swap">swap</a>

```cpp
template<typename T>
void swap(shared_array<T> & a, shared_array<T> & b) // never throws
```

`a.swap(b)`と等価。
`std::swap`のインターフェースとの一貫性を図り、ジェネリックプログラミングを補助するために用意されている。

---

Revised 8 February 2002

Copyright 1999 Greg Colvin and Beman Dawes. Copyright 2002 Darin Adler. 
Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies.
This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

Japanese Translation Copyright (C) 2003
[Ryo Kobayashi](mailto:lenoir@zeroscape.org),
オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。
このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。
また、いかなる目的に対しても、その利用が適していることを関知しない。

