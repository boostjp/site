# weak_ptr class template

`weak_ptr`クラステンプレートは`shared_ptr`がすでに管理しているオブジェクトへの「弱参照」を所有する。
オブジェクトにアクセスするに`weak_ptr`は、[shared_ptr constructor](shared_ptr.md#constructors)か[make_shared](#make_shared)関数によって、`shared_ptr`に変換することができる。
最後の`shared_ptr`が廃棄され、オブジェクトが削除されたら、削除されたオブジェクトを参照する`weak_ptr`の実体から`shared_ptr`を得ようとすると失敗するだろう。
コンストラクタは`boost::use_const_is_zero`型の例外を投げ、`make_shared`関数はデフォルトのコンストラクタで構築された(nullの)`shared_ptr`を返す。

全ての`weak_ptr`はC++標準ライブラリの**CopyConstructible**と**Assignable**の要求を満たしているので標準ライブラリコンテナで使うことができる。
比較演算子が提供されているので`weak_ptr`は標準関数の連想コンテナで使うことができる。

クラステンプレートはテンプレートパラメータ`T`をもつ。
これは指されるオブジェクトの型である。
`T`はスマートポインタの[common requirements](smart_ptr.md#Common requirements)を満たしていなければならない。

`shared_ptr`に比べて、`weak_ptr`は限られたサブセットの操作しか提供しない。
これは、マルチスレッドプログラムで、所有するポインタにアクセスすることはたいてい危険であり、また時々、シングルスレッドプログラムの中でも安全ではないからである。
(つまり未定義の動作を引き起こしてしまうのだ。)
例えば、次のような不完全なプログラムの一部を考えてみよう:

```cpp
shared_ptr<int> p(new int(5));
weak_ptr<int> q(p);

// some time later

if(int * r = q.get())
{
// use *r
}
```

`if`のあと、`r`が使われる直前に別のスレッドが`p.reset()`ステートメントを実行することを考えてみよう。
今、`r`はダングリングポインタである。
(※訳注:ダングリングポインタ(dangling pointer)とは何をさしているか分からないポインタのこと)

この問題を解決する方法は、`q`から一時的な`shared_ptr`を作ることである。

```cpp
shared_ptr<int> p(new int(5));
weak_ptr<int> q(p);

// some time later

if(shared_ptr<int> r = make_shared(q))
{
// use *r
}
```
* [make_shared](#make_shared)

ここでは`r`は`q`が指すポインタへの参照を持っている。
もし`p.reset()`が別のスレッドで実行されても、オブジェクトは`r`がスコープの外に出てしまう(或いはresetされてしまう)まで生きたままである。

## <a id="Synopsis">Synopsis</a>

```cpp
namespace boost {

template<typename T> class weak_ptr {

public:
    typedef T <a href="#element_type">element_type</a>;

    weak_ptr();
    template<typename Y>
    weak_ptr(shared_ptr<Y> const & r); // never throws
    ~weak_ptr(); // never throws

    weak_ptr(weak_ptr const & r); // never throws
    template<typename Y>
    weak_ptr(weak_ptr<Y> const & r); // never throws

    weak_ptr & operator=(weak_ptr const & r); // never throws  
    template<typename Y>
    weak_ptr & operator=(weak_ptr<Y> const & r); // never throws
    template<typename Y>
    weak_ptr & operator=(shared_ptr<Y> const & r); // never throws

    void reset();
    T * get() const; // never throws; deprecated, will disappear

    long use_count() const; // never throws
    bool expired() const; // never throws

    void swap(weak_ptr<T> & b); // never throws
};

template<typename T, typename U>
bool operator==(weak_ptr<T> const & a, weak_ptr<U> const & b); // never throws
template<typename T, typename U>
bool operator!=(weak_ptr<T> const & a, weak_ptr<U> const & b); // never throws
template<typename T>
bool operator<(weak_ptr<T> const & a, weak_ptr<T> const & b); // never throws

template<typename T>
void swap(weak_ptr<T> & a, weak_ptr<T> & b); // never throws

template<typename T>
shared_ptr<T> make_shared(weak_ptr<T> const & r); // never throws

}
```
* element_type[link #element_type]
* weak_ptr[link #constructors]
* ~weak_ptr[link #destructor]
* operator=[link #assignment]
* reset[link #reset]
* get[link #get]
* use_count[link #use_count]
* expired[link #expired]
* swap[link #swap]
* operator==[link #comparison]
* operator!=[link #comparison]
* operator<[link #comparison]
* swap[link #free-swap]
* make_shared[link #make_shared]

## <a id="Members">Members</a>

### <a id="element_type">element_type</a>

`typedef T element_type;`

テンプレートパラメータの型Tを与える

### <a id="constructors">constructors</a>

`weak_ptr();`

- **Effects:**
    - `weak_ptr`をコンストラクトする。
- **Postconditions:**
    - [use count](#use_count)は0。
	  所有するポインタは0。
- **Throws:**
    - `std::bad_alloc`.
- **Exception safety:**
    - 例外が投げられると、コンストラクタは何もしない。
- **Notes:**
    - `T`は完全な型である必要はない。
	  スマートポインタの[common requirements](smart_ptr.md#Common requirements)を参考にせよ。

```cpp
template<typename Y>
weak_ptr(shared_ptr<Y> const & r); // never throws
```

- **Effects:**
    - `weak_ptr`をコンストラクトし、`r`が所有するポインタのコピーを持つ。
- **Throws:**
    - なし。
- **Notes:**
    - 全てのコピーに対して[use count](#use_count)は変更されない。
	  最後の`shared_ptr`が破棄されるとき、use countと所有するポインタは0になる。

```cpp
weak_ptr(weak_ptr const & r); // never throws
template<typename Y>
weak_ptr(weak_ptr<Y> const & r); // never throws
```

- **Effects:**
    - `weak_ptr`をコンストラクトし、`r`が所有するポインタのコピーを持つ。
- **Throws:**
    - なし.
- **Notes:**
    - 全てのコピーに対して[use count](#use_count)は変更されない。

### <a id="destructor">destructor</a>

`~weak_ptr(); // never throws`

- **Effects:**
    - この`weak_ptr`を破棄するが、所有するポインタが指すオブジェクトには何も影響しない。
- **Throws:**
    - なし.
- **Notes:**
    - `T`は完全な型である必要はない。
	  スマートポインタの[common requirements](smart_ptr.md#Common requirements)を参考にせよ。

### <a id="assignment">assignment</a>

```cpp
weak_ptr & operator=(weak_ptr const & r); // never throws
template<typename Y>
weak_ptr & operator=(weak_ptr<Y> const & r); // never throws
template<typename Y>
weak_ptr & operator=(shared_ptr<Y> const & r); // never throws
```

- **Effects:**
    - `weak_ptr(r).swap(*this)`と等価.
- **Throws:**
    - なし.
- **Notes:**
    - 効果(と保証)を満たす限り実装は自由である。
	  一時的オブジェクトが作られることはない。

### <a id="reset">reset</a>

`void reset();`

- **Effects:**
    - `weak_ptr().swap(*this)`と等価.

### <a id="get">get</a>

`T * get() const; // never throws`

- **Returns:**
    - 所有するポインタ(そのポインタのための全ての`shared_ptr`オブジェクトが破棄されていれば0)
- **Throws:**
    - なし.
- **Notes:**
    - マルチスレッドのコードで`get`を使うのは危険である。
      関数から戻った後、指しているオブジェクトを別のスレッドが破棄してしまうかもしれない。
      `weak_ptr`はその`use_count`を変更しないからである。

*[`get`は非常にエラーを起こしやすい。*
*シングルスレッドのコードでも、例えば指されたオブジェクトのメンバ関数によって間接的に、`get`が返すポインタが無効にされているかもしれない。*

*`get`は非難されているし、将来のリリースでは無くなるだろう。*
*決してこれを使わないこと。]*

### <a id="use_count">use_count</a>

`long use_count() const; // never throws`

- **Returns:**
    - 所有するポインタを共有する`shared_ptr`オブジェクトの数
- **Throws:**
    - なし.
- **Notes:**
    - `use_count()`は必ずしも効率的ではない。
      デバッグとテストの目的でのみ使い、製品コードでは使わないこと。
      `T`は完全な型である必要はない。
	  スマートポインタの[common requirements](smart_ptr.md#Common requirements)を参考にせよ。

### <a id="expired">expired</a>

`bool expired() const; // never throws`

- **Returns:**
    - `use_count() == 0`.
- **Throws:**
    - なし.
- **Notes:**
    - `expired()`は`use_count()`より速いかもしれない。
      `T`は完全な型である必要はない。
	  スマートポインタの[common requirements](smart_ptr.md#Common requirements)を参考にせよ。

### <a id="swap">swap</a>

`void swap(weak_ptr & b); // never throws`

- **Effects:**
    - ふたつのポインタの内容を入れ替える。
- **Throws:**
    - なし.
- **Notes:**
    - `T`は完全な型である必要はない。
	  スマートポインタの[common requirements](smart_ptr.md#Common requirements)を参考にせよ。

## <a id="functions">Free Functions</a>

### <a id="comparison">comparison</a>

```cpp
template<typename T, typename U>
bool operator==(weak_ptr<T> const & a, weak_ptr<U> const & b); // never throws
template<typename T, typename U>
bool operator!=(weak_ptr<T> const & a, weak_ptr<U> const & b); // never throws
```

- **Returns:**
    - `a.get() == b.get()`.
- **Throws:**
    - なし.
- **Notes:**
    - `T`は完全な型である必要はない。
	  スマートポインタの[common requirements](smart_ptr.md#Common requirements)を参考にせよ。

```cpp
template<typename T>
bool operator<(weak_ptr<T> const & a, weak_ptr<T> const & b); // never throws
```

- **Returns:**
    - an implementation-defined value such that `operator<` is a strict weak ordering as described in section 25.3 **[lib.alg.sorting]** of the C++ standard.
- **Throws:**
    - なし.
- **Notes:**
    - `weak_ptr`オブジェクトが連想コンテナのキーとして使われることを許す。
	  `T`は完全な型である必要はない。
	  スマートポインタの[common requirements](smart_ptr.md#Common requirements)を参考にせよ。

### <a id="free-swap">swap</a>

```cpp
template<typename T>
void swap(weak_ptr<T> & a, weak_ptr<T> & b) // never throws
```

- **Effects:**
    - `a.swap(b)`と等価.
- **Throws:**
    - なし.
- **Notes:**
    - `std::swap`インタフェースと同じ。
      ジェネリックプログラミングを助けるだろう。

### <a id="make_shared">make_shared</a>

```cpp
template<typename T>
shared_ptr<T> make_shared(weak_ptr<T> & const r) // never throws
```

- **Returns:**
    - `r.expired()? shared_ptr<T>(): shared_ptr<T>(r)`.
- **Throws:**
    - なし.

*[`make_shared`の現在の実装は`shared_ptr`のデフォルトコンストラクタでの例外を転送することができるので、明示された要求を満たしていない。*
*将来のリリースではこのデフォルトコンストラクタは例外を投げないだろう。]*

---

Revised 29 August 2002

Copyright 1999 Greg Colvin and Beman Dawes.
Copyright 2002 Darin Adler. 
Copyright 2002 Peter Dimov.
Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies.
This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

