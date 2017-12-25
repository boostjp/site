# shared_ptr class template

- [Introduction](#Introduction)
- [Best Practices](#BestPractices)
- [Synopsis](#Synopsis)
- [Members](#Members)
- [Free Functions](#functions)
- [Example](#example)
- [Handle/Body Idiom](#Handle/Body)
- [Thread Safety](#ThreadSafety)
- [Frequently Asked Questions](#FAQ)
- [Smart Pointer Timings](smarttests.md)

## <a id="Introduction">Introduction</a>

`shared_ptr`クラステンプレートは、C++の`new`などによって動的に割り当てられたオブジェクトへのポインタを保持する。
`shared_ptr`に指されたオブジェクトは、そのオブジェクトを指す最後の`shared_ptr`が破棄もしくはリセットされるときに削除されることが保証されている。
[example](#example)を参照のこと。

`shared_ptr`はC++標準ライブラリの**CopyConstructible**(コピーコンストラクト可能)と**Assignable**(代入可能)の条件を満たすので、標準ライブラリのコンテナで使うことができる。
また、標準ライブラリの連想コンテナで使うことができるように、比較演算子が提供されている。

通常、`shared_ptr`は動的に割り当てられた配列を正しく扱うことはできない。
動的に割り当てられた配列の扱い方については、[shared_array](shared_array.md)を参照のこと。

`shared_ptr`の実装には参照カウントが用いられているため、循環参照された`shared_ptr`のインスタンスは正常に解放されない。
例えば、`main()`が`A`を指す`shared_ptr`を保持しているときに、その`A`が直接的または間接的に`A`自身を指す`shared_ptr`を持っていると、`A`に対する[参照カウント](#use_count)は2となる。
最初の`shared_ptr`が破棄される際に、`A`の[参照カウント](#use_count)は 1 となり、そのインスタンスは破棄されずに残ってしまう。
循環参照を回避するには、[weak_ptr](weak_ptr.md)を使う。

このクラステンプレートには、指し示すオブジェクトの型を表すパラメータ`T`を与える。
`shared_ptr`とそのメンバ関数の多くは、`T`に特別な条件を必要としない。
不完全型や`void`も許されている。
`T`に特別な条件を必要とするメンバ関数([constructors](#constructors), [reset](#reset))についてはこのドキュメント中で明示されている。

`T *`が暗黙の型変換により`U *`に変換可能であれば、`shared_ptr<T>`は暗黙に`shared_ptr<>`に変換できる。
特に、`shared_ptr<T>`は暗黙の型変換により、`shared_ptr<T const>`、`shared_ptr<U>`、`shared_ptr<void>`に変換できる。
(`U`はアクセス可能な`T`の基底型)

## <a id="BestPractices">Best Practices</a>

メモリリークの可能性をほとんど排除する為のシンプルな指針 : `new`の結果を常に名前のあるスマートポインタに格納すること。
コードに含まれる全ての`new`キーワードは、次の形にされるべきである :

`shared_ptr<T> p(new Y);`

もちろん、上での`shared_ptr`の代わりに他のスマートポインタを利用しても良い。
また、`T`と`Y`が同じ型であったり、`Y`のコンストラクタに引数が与えられても良い。

この指針に従えば、自然と明示的な`delete`が無くなり、*try/catch*構文も極めて少なくなるだろう。

タイプ数(コード量)を減らすために、名前のない一時的な`shared_ptr`を使ってはならない。
このことがなぜ危険かを理解するには、以下の例を考えると良い :

```cpp
void f(shared_ptr<int>, int);
int g();

void ok()
{
    shared_ptr<int> p(new int(2));
    f(p, g());
}

void bad()
{
    f(shared_ptr<int>(new int(2)), g());
}
```

`ok`関数はこの指針に的確に従っているのに対し、`bad`関数は一時的な`shared_ptr`を使用しており、メモリリークが起きる可能性がある。
関数の引数が評価される順序が不定であるため、`new int(2)`が最初に評価され、次に`g()`が評価されるかもしれない。
その結果、もし`g`が例外を送出すると、`shared_ptr`のコンストラクタは呼び出されない。
この問題についてのより詳しい情報は[Herb Sutter's treatment (英文)](http://www.gotw.ca/gotw/056.htm)を参照のこと。

## <a id="Synopsis">Synopsis</a>

```cpp
namespace boost {

class use_count_is_zero: public std::exception;

template<typename T> class weak_ptr;

template<typename T> class shared_ptr {

public:

    typedef T element_type;

    shared_ptr();
    template<typename Y> explicit shared_ptr(Y * p);
    template<typename Y, typename D> shared_ptr(Y * p, D d);
    ~shared_ptr(); // never throws

    shared_ptr(shared_ptr const & r); // never throws
    template<typename Y> shared_ptr(shared_ptr<Y> const & r); // never throws
    template<typename Y> explicit shared_ptr(weak_ptr<Y> const & r);
    template<typename Y> explicit shared_ptr(std::auto_ptr<Y> & r);

    shared_ptr & operator=(shared_ptr const & r); // never throws  
    template<typename Y> shared_ptr & operator=(shared_ptr<Y> const & r); // never throws
    template<typename Y> shared_ptr & operator=(std::auto_ptr<Y> & r);

    void reset();
    template<typename Y> void reset(Y * p);
    template<typename Y, typename D> void reset(Y * p, D d);

    T & operator*() const; // never throws
    T * operator->() const; // never throws
    T * get() const; // never throws

    bool unique() const; // never throws
    long use_count() const; // never throws

    operator unspecified-bool-type() const; // never throws

    void swap(shared_ptr & b); // never throws
};

template<typename T, typename U>
bool operator==(shared_ptr<T> const & a, shared_ptr<U> const & b); // never throws
template<typename T, typename U>
bool operator!=(shared_ptr<T> const & a, shared_ptr<U> const & b); // never throws
template<typename T>
bool operator<(shared_ptr<T> const & a, shared_ptr<T> const & b); // never throws

template<typename T>
void swap(shared_ptr<T> & a, shared_ptr<T> & b); // never throws

template<typename T>
T * get_pointer(shared_ptr<T> const & p); // never throws

template<typename T, typename U>
shared_ptr<T> shared_static_cast(shared_ptr<U> const & r); // never throws
template<typename T, typename U>
shared_ptr<T> shared_dynamic_cast(shared_ptr<U> const & r);
template<typename T, typename U>
shared_ptr<T> shared_polymorphic_cast(shared_ptr<U> const & r);
template<typename T, typename U>
shared_ptr<T> shared_polymorphic_downcast(shared_ptr<U> const & r); // never throws

}
```
* weak_ptr[link weak_ptr.md]
* element_type[link #element_type]
* shared_ptr[link #constructors]
* ~shared_ptr[link #destructor]
* operator=[link #assignment]
* reset[link #reset]
* operator*[link #indirection]
* operator->[link #indirection]
* get[link #get]
* unique[link #unique]
* use_count[link #use_count]
* unspecified-bool-type[link #conversions]
* swap[link #swap]
* operator==[link #comparison]
* operator!=[link #comparison]
* operator<[link #comparison]
* swap[link #free-swap]
* get_pointer[link #get_pointer]
* shared_static_cast[link #shared_static_cast]
* shared_dynamic_cast[link #shared_dynamic_cast]
* shared_polymorphic_cast[link #shared_polymorphic_cast]
* shared_polymorphic_downcast[link #shared_polymorphic_downcast]

*[`shared_ptr`のシグネチャに必要な条件を緩和し、補足的なデフォルトのテンプレートパラメータ(例えば、スレッドモデルを変換可能なパラメータなど)を使えるようにすることは、利便性の向上に繋がるかも知れない。*
*これは、ODR違反の可能性を発見する一助になるだろう。*
*(訳注:ODR(One-Definition Rule) C++ のプログラム中のあらゆる要素の本体は、その要素が使われる全ての翻訳単位で同じ内容で定義されなくてはならないという規則[[参考(boost::pythonのドキュメント)](../python/doc/v2/definitions.md)])*

*一方、`shared_ptr`をtemplateテンプレートパラメータとして使うには、シグネチャの正確な合致が必要となる。*
*メタプログラミングに精通している人は、template テンプレートパラメータを重要視しない。*
*柔軟性が低すぎるからである。*
*その代わり典型的に、`std::allocator::rebind-type`を"書き換える"。]*

## <a id="Members">Members</a>

### <a id="element_type">element_type</a>

`typedef T element_type;`

テンプレートパラメータ T の型を規定する

### <a id="constructors">コンストラクタ ( constructors )</a>

`shared_ptr();`

- **Effects:**
    - `shared_ptr`を構築する。
- **Postconditions:**
    - [use count](#use_count)は 1 ; 保持されるポインタは 0 。
- **Throws:**
    - `std::bad_alloc`.
- **Exception safety:**
    - 例外が発生すると、コンストラクタは何もしない。

*[`use_count() == 1`という事後条件は強すぎる。*
*`reset()`の中でデフォルトコンストラクタが使われるため、例外を送出しない保証が重要である。*
*しかし、現在の仕様では参照カウンタの割り当てが必要となっているため、例外を送出しないことが保証されなくなっている。*
*そのため、この事後条件は将来のリリースで撤廃されるだろう。*
*デフォルトコンストラクタにより構築された`shared_ptr`(とそこから作られた全てのコピー)の参照カウンタは、おそらく未定義になるだろう。*

*例外を送出しないことを保証するには、二つの実装が考えられる。*
*一つは、参照カウンタへのポインタとして0を保持する方法、もう一つは、デフォルトコンストラクタによって構築される全ての`shared_ptr`に対して、静的に割り当てられた唯一の参照カウンタを利用する方法である。*
*後者の方法は、スレッドセーフの問題と初期化の順序の問題のために、現在のヘッダのみの参照実装では実現が困難であるが仕様の為に実装方法が制限されるべきではない。*

*将来のリリースでは、組み込みポインタとの一貫性を高めるため、`shared_ptr`を数字の0から構築できるようになるかもしれない。*
*今後、`0`を`shared_ptr<T>()`の略記として使うことを可能にする、このコンストラクタが、潜在化されたままにされるかどうかは明かではない。]*

```cpp
template<typename Y>
explicit shared_ptr(Y * p);
```

- **Requirements:**
    - `p`は`T *`に変換可能でなくてはならない。
    - `Y`は完全な型でなくてはならない。
    - `delete p`の式が文法的に正しくなければならない; 未定義の振る舞いをしてはならない; 例外を送出してはならない。
- **Effects:**
    - `shared_ptr`を構築し、`p`のコピーを保持する。
- **Postconditions:**
    - [use count](#use_count)は1 。
- **Throws:**
    - `std::bad_alloc`.
- **Exception safety:**
    - 例外が発生すると、`delete p`を呼び出す。
- **Notes:**
    - `p`はC++の`new`によって割り当てられたオブジェクトへのポインタか、0でなくてはならない。
      事後条件の[use count](#use_count)が1というのは、`p`が0の時でも同様である(値が0のポインタに対する`delete`呼び出しが安全であるため )。

*[このコンストラクタは、実際に渡されたポインタの型を記憶するためにテンプレートに変更された。*
*デストラクタは同じポインタについて、本来の型で`delete`を呼び出す。*
*よって、`T`が仮想デストラクタを持っていなくても、あるいは`void`であっても、本来の型で`delete`される。*

*現在の実装では、`p`が`counted_base *`に変換可能なとき、`shared_ptr`は`counted_base`に埋め込まれた参照カウントを使う。*
*これは、`shared_ptr`を`this`のような生のポインタから構築する方法を提供する(実験的な)試みである。*
*非メンバ関数`shared_from_this(q)`は、`q`が`counted_base const *`へ変換可能なとき、その変換を行う。*

*現在の実装で用意されている随意選択可能な割り込みカウントは、`shared_ptr`を`intrusive_ptr`(割り込みカウント方式の実験的な汎用スマートポインタ)と一緒に利用できるようにしている。*

*別の実装の可能性としては、割り込みカウントではなくグローバルのポインタカウントマップを使う方法が考えられる。*
*その場合、`shared_from_this`の処理時間はO(1)ではなくなる。*
*これは一部のユーザに影響を与えるが、この処理が行われることは希なため、パフォーマンスの問題は予想していない。*
*グローバルのポインタカウントマップを管理するのは困難である; ポインタカウントマップは`shared_ptr`のインスタンスが構築される前に初期化されている必要があり、初期化はスレッドセーフに行われなければならない。*
*Windowsの動的ライブラリの形態に従えば、幾つかのカウントマップを存在させることができる。*

*どの実装が使われるべきか、または仕様でその両方を許容するかどうかは、まだ明かではない。*
*とは言え、スマートポインタを幅広く利用するプログラマにとって、`shared_ptr`を`this`から構築できることは必要不可欠である。]*

```cpp
template<typename Y, typename D>
shared_ptr(Y * p, D d);
```

- **Requirements:**
    - `p`は`T *`に変換可能でなくてはならない。
      `D`は**CopyConstructible**(コピーコンストラクト可能)でなくてはならない。
      `D`のコピーコンストラクタとデストラクタは例外を送出してはならない。
      `d(p)`の式が文法的に正しくなければならない; 未定義の振る舞いをしてはならない; 例外を送出してはならない。
- **Effects:**
    - `shared_ptr`を構築し、`p`と`d`のコピーを保持する。
      (訳注: `d`は`p`の**deallocator**(削除子)になる)
- **Postconditions:**
    - [use count](#use_count)は 1 。
- **Throws:**
    - `std::bad_alloc`
- **Exception safety:**
    - 例外が発生すると、`d(p)`を呼び出す。
- **Notes:**
    - `p`に指されているオブジェクトを削除する時になると、保持されている`p`のコピーを1引数として、保持されている`d`(のコピー)が実行される。

*[カスタム削除子は、`shared_ptr`を返すファクトリ関数を利用可能にし、メモリ割り当ての方策をユーザから切り離す。*
*削除子は型の属性ではないので、バイナリの互換性やソースを破壊せずに変更することができ、使用する側の再コンパイルを必要としない。*
*例えば、静的に割り当てられたオブジェクトを指す`shared_ptr`を返すには、"何もしない(no-op)" 削除子が有効である。*

*カスタム削除子のサポートは大きなオーバーヘッドを生じない。*
*`shared_ptr`の他の特徴も削除子が保持されることを必要としている。*

*`D`のコピーコンストラクタが例外を送出しないと言う条件は、値渡しのために設定されている。*
*もし、このコピーコンストラクタが例外を送出すると、ポインタ`p`が指すメモリがリークする。*
*この条件を取り除くためには、`d`を(コンストの)参照渡しにする必要がある。*
*参照渡しには幾つかの短所がある;*
*(1) 値渡しならば、関数(関数への参照)を関数ポインタ(幾つかのコンパイラではできないかもしれないが、手動で実行できる必要がある)に変更するのが容易である。*
*(2) 現在のところ、(標準に従えば)コンスト参照を関数に結びつけることはできない。*
*オーバーロード関数群を備えることでこれらの制限を克服できるのだが、幾つかのコンパイラに存在する14.5.5.2 問題のために実現できない。*
*14.5.5.2 問題とは、部分整列をサポートしていないコンパイラで、特殊化されたテンプレート関数がコンパイルできないというものである。*
*(訳注: &quot;部分整列&quot; : テンプレート関数の特殊化の度合いによる利用優先順位付け)*

*前述された問題が解決されれば、これらの条件も取り除かれるだろう。] *

```cpp
shared_ptr(shared_ptr const & r); // never throws
template<typename Y>
shared_ptr(shared_ptr<Y> const & r); // never throws
```

- **Effects:**
    - `shared_ptr`を構築し、`r`が保持するポインタのコピーを保持したかのように作用する。
- **Postconditions:**
    - 全てのコピーの[use count](#use_count)は 1 増加する。
- **Throws:**
    - 無し。

*[デフォルトコンストラクタにより構築された`shared_ptr`は、コピーされると事後条件が緩和される。]*

```cpp
template<typename Y>
explicit shared_ptr(weak_ptr<Y> const & r);
```

- **Effects:**
    - `shared_ptr`を構築し、r`が管理するポインタのコピーを保持したかのように作用する。
- **Postconditions:**
    - 全てのコピーの[use count](#use_count)は 1 増加する。
- **Throws:**
    - `r.use_count() == 0`の時、`use_count_is_zero`を送出する。
- **Exception safety:**
    - 例外が発生すると、コンストラクタは何もしない。

*[このコンストラクタは仕様の選択的な部分に位置する; `weak_ptr`の存在に依存する。*
*`weak_ptr`が使用されているかどうかに無頓着なユーザにとって、`weak_ptr`のサポートが`shared_ptr`にオーバーヘッドを生じさせているのは事実である。*

*一方、全ての参照カウントにとって、循環参照は深刻な問題である。*
*ライブラリ内で解決方法が提供されないのは許容できない;*
*もしユーザがウィークポインタ機構の再開発をせざるを得なくなった場合、安全な`weak_ptr`の設計は簡単なことではなく、悪い結果をもたらす確率は相当大きい。*

*機能の追加には努力を払う価値があるというのが私の意見である。*
*その証拠として、この参照の実装にて`weak_ptr`が提供されている。]*

```cpp
template<typename Y>
shared_ptr(std::auto_ptr<Y> & r);
```

- **Effects:**
    - `shared_ptr`を構築し、`r.release()`のコピーを保持したかのように作用する。
- **Postconditions:**
    - [use count](#use_count)は1。 
- **Throws:**
    - `std::bad_alloc`
- **Exception safety:**
    - 例外が発生すると、コンストラクタは何もしない。

*[このコンストラクタは`auto_ptr`を値渡しでなく参照で受け取り、一時的な`auto_ptr`を受け取らない。*
*これは、このコンストラクタが強力な保証を提供する設計にするためである。]*

### <a id="destructor">デストラクタ ( destructor )</a>

`~shared_ptr(); // never throws`

- **Effects:**
    - もし** *this **が唯一の所有者であるとき(`use_count() == 1`)、保持しているポインタが指すオブジェクトを破棄する。
- **Postconditions:**
    - 残存する全てのコピーの[use count](#use_count)が 1 減少する。
- **Throws:**
    - なし。

### <a id="assignment">代入 ( assignment )</a>

```cpp
shared_ptr & operator=(shared_ptr const & r); // never throws
template<typename Y>
shared_ptr & operator=(shared_ptr<Y> const & r); // never throws
template<typename Y>
shared_ptr & operator=(std::auto_ptr<Y> & r);
```

- **Effects:**
    - `shared_ptr(r).swap(*this)`と等価。 
- **Notes:**
    - 一時的なスマートポインタの構築と破棄による参照カウントの更新は未知の副作用を生じる可能性がある。
      この実装は、一時的なオブジェクトを構築しない方法を採ることによって、
      保証された作用を得られる。
      特に、この様な例では:

```cpp
shared_ptr<int> p(new int);
shared_ptr<void> q(p);
p = p;
q = p;
```

      いずれの代入文も、何も作用しない(no-op)だろう。

*[一部の上級者は、この&quot;as if&quot;規則(訳注: 演算子の再配置規則)をそのまま表現したような注意書きをくどいと感じるだろう。*
*しかし、作用の説明に C++ のコードを用いられるとき、しばしばそれが必要な実装であるかのように誤って解釈されてしまうことがあると、経験的に示唆されている。*
*さらに付け加えると、この部分で&quot;as if&quot;規則が適用されるかどうかは全くわからないが、可能な最適化について明示しておくことは好ましいと思われる。]*

### <a id="reset">リセット ( reset )</a>

`void reset();`

- **Effects:**
    - `shared_ptr().swap(*this)`と等価。
    - _[`reset()`は将来の実装で、例外を送出しない(nothrow)保証を提供するだろう。]_

```cpp
template<typename Y>
void reset(Y * p);
```

- **Effects:**
    - `shared_ptr(p).swap(*this)`と等価。

```cpp
template<typename Y, typename D>
void reset(Y * p, D d);
```

- **Effects:**
    - `shared_ptr(p, d).swap(*this)`と等価。

### <a id="indirection">ポインタ偽装 ( indirection )</a>

`T & operator*() const; // never throws`

- **Requirements:**
    - 保持されているポインタが 0 でないこと。
- **Returns:**
    - 保持されているポインタが指すオブジェクトの参照。
- **Throws:**
    - 無し。

`T * operator->() const; // never throws`

- **Requirements:**
    - 保持されているポインタが 0 でないこと。
- **Returns:**
    - 保持されているポインタ。
- **Throws:**
    - 無し。

### <a id="get">ポインタの取得 ( get )</a>

`T * get() const; // never throws`

- **Returns:**
    - 保持されているポインタ。
- **Throws:**
    - 無し。

### <a id="unique">一意性 ( unique )</a>

`bool unique() const; // never throws`

- **Returns:**
    - `use_count() == 1`.
- **Throws:**
    - 無し。
- **Notes:**
    - `unique()`は恐らく`use_count()`よりも速い。 
      だが、もし`unique()`を使って書き込み時コピー(copy on write)を実装しようとしているなら、保持されているポインタが0の時は`unique()`の値を当てにしてはならない。

*[将来のリリースでは、デフォルトコンストラクタで構築された`shared_ptr`に対し、`unique()`は不定の値を返すようになるだろう。]*

### <a id="use_count">参照カウント ( use_count )</a>

`long use_count() const; // never throws`

- **Returns:**
    - 保持しているポインタを共有している`shared_ptr`オブジェクトの数。
- **Throws:**
    - 無し。
- **Notes:**
    - `use_count()`は必ずしも必要なものではない。
      デバッグや試験の為にだけ使用するべきで、製品のコードに使用するべきでない。

### <a id="conversions">変換 ( conversions )</a>

`operator unspecified-bool-type () const; // never throws`

- **Returns:**
    - `shared_ptr`がブール式として使用されたときに、`get() != 0`と等価な明示的ではない値を返す。
- **Throws:**
    - 無し。
- **Notes:**
    - この変換演算子は`shared_ptr`オブジェクトを、`if (p && p->valid()) {}`のようなブール式の中で使えるようにするためのものである。
    - 実際に対象となる型はメンバ関数へのポインタなどであり、暗黙の型変換の落とし穴を回避するために用いる。

*[このブールへの変換は単にコードをスマートにする物(syntactic sugar : 構文糖)というわけではない。*
*この変換により`shared_dynamic_cast`や`make_shared`を使用するときに、`shared_ptr`を条件式として利用することができる。]*

### <a id="swap">交換 ( swap )</a>

`void swap(shared_ptr & b); // never throws`

- **Effects:**
    - 二つのスマートポインタの中身を交換する。
- **Throws:**
    - 無し。

## <a id="functions">Free Functions</a>

### <a id="comparison">比較 ( comparison )</a>

```cpp
template<typename T, typename U>
bool operator==(shared_ptr<T> const & a, shared_ptr<U> const & b); // never throws
```

- **Returns:**
    - `a.get() == b.get()`
- **Throws:**
    - 無し。

```cpp
template<typename T, typename U>
bool operator!=(shared_ptr<T> const & a, shared_ptr<U> const & b); // never throws
```

- **Returns:**
    - `a.get() != b.get()`
- **Throws:**
    - 無し。

```cpp
template<typename T>
bool operator<(shared_ptr<T> const & a, shared_ptr<T> const & b); // never throws
```

- **Returns:**
    - `operator<`は、C++ 標準の**[lib.alg.sorting]**の25.3章で説明されている、完全な弱い順序づけのための明示的ではない値を返す。
- **Throws:**
    - 無し。
- **Notes:**
    - `shared_ptr`オブジェクトを連想コンテナのキーとして使えるようにするための演算子。

*[一貫性と適合性の理由から、`std::less`の特殊化版よりも、`operator<`の方が好まれて使われている。*
*`std::less`は`operator<`の結果を返すことを必要とされ、他の幾つかの標準アルゴリズムも、属性が提供されないとき、比較のために`std::less`ではなく`operator<`を使う。*
*`std::pair`のような複合オブジェクトの`operator<`もまた、収容している子オブジェクトの`operator<`に基づいて実装されている。*

*比較演算子の安全の確保は、設計によって省略された。]*

### <a id="free-swap">交換 ( swap )</a>

```cpp
template<typename T>
void swap(shared_ptr<T> & a, shared_ptr<T> & b); // never throws
```

- **Effects:**
    - `a.swap(b)`と等価。
- **Throws:**
    - 無し。
- **Notes:**
    - `std::swap`のインターフェースとの一貫性を図り、ジェネリックプログラミングを支援する。

*[`swap`は`shared_ptr`と同じ名前空間で定義される。*
*これは現在のところ、標準ライブラリから使用可能な`swap`関数を提供するための唯一の正当な方法である。]*

### <a id="get_pointer">ポインタを取得 ( get_pointer )</a>

```cpp
template<typename T>
T * get_pointer(shared_ptr<T> const & p); // never throws
```

- **Returns:**
    - `p.get()`
- **Throws:**
    - 無し。
- **Notes:**
    - 汎用プログラミングを補助する機能を提供する。
	  [`mem_fn`](../mem_fn.md)で使用する。

### <a id="shared_static_cast">静的キャスト ( shared_static_cast )</a>

```cpp
template<typename T, typename U>
shared_ptr<T> shared_static_cast(shared_ptr<U> const & r); // never throws
```

- **Requires:**
    - `static_cast<T*>(r.get())`は正しい形でなくてはならない。
- **Returns:**
    - `static_cast<T*>(r.get())`のコピーを保持し、`r`と所有権を共有する`shared_ptr<T>`オブジェクト。
- **Throws:**
    - 無し。
- **Notes:**
    - 表面的には次の式と等価。
      `shared_ptr<T>(static_cast<T*>(r.get()))`
      これは、同じオブジェクトを2度削除しようとする事になるため、結局は未定義のふるまいとなる。

### <a id="shared_dynamic_cast">動的キャスト ( shared_dynamic_cast )</a>

```cpp
template<typename T, typename U>
shared_ptr<T> shared_dynamic_cast(shared_ptr<U> const & r);</pre>
```

- **Requires:**
    - `dynamic_cast<T*>(r.get())`の式が正しい形であり、そのふるまいが定義されていなくてはならない。
- **Returns:**
	- `dynamic_cast<T*>(r.get())`が非ゼロの値を返すとき、`r`のコピーを保持し、その所有権を共有する`shared_ptr<T>`オブジェクトを返す。
	- それ以外の時は、デフォルトコンストラクタにより構築された`shared_ptr<T>`オブジェクトを返す。
- **Throws:**
    - `std::bad_alloc`
- **Exception safety:**
    - 例外が発生すると、この関数は何もしない。
- **Notes:**
    - 表面的には次の式と等価。
      `shared_ptr<T>(dynamic_cast<T*>(r.get()))`
      これは、同じオブジェクトを2度削除しようとする事になるため、結局は未定義のふるまいとなる。

### <a id="shared_polymorphic_cast">ポリモーフィックキャスト ( shared_polymorphic_cast )</a>

```cpp
template<typename T, typename U>
shared_ptr<T> shared_polymorphic_cast(shared_ptr<U> const & r);
```

- **Requires:**
    - `polymorphic_cast<T*>(r.get())`の式が正しい形であり、そのふるまいが定義されていなくてはならない。
- **Returns:**
    - `polymorphic_cast<T*>(r.get())`のコピーを保持し、`r`と所有権を共有する`shared_ptr<T>`オブジェクト。
- **Throws:**
    - 保持しているポインタが変換できないとき、`std::bad_cast`を送出する。
- **Exception safety:**
    - 例外が発生すると、この関数は何もしない。

### <a id="shared_polymorphic_downcast">ポリモーフィックダウンキャスト ( shared_polymorphic_downcast )</a>

```cpp
template<typename T, typename U>
shared_ptr<T> shared_polymorphic_downcast(shared_ptr<U> const & r); // never throws
```

- **Requires:**
    - `polymorphic_downcast<T*>(r.get())`の式が正しい形であり、そのふるまいが定義されていなければならない。
- **Returns:**
    - `polymorphic_downcast<T*>(r.get())`のコピーを保持し、`r`と所有権を共有する`shared_ptr<T>`オブジェクト。
- **Throws:**
    - 無し。

## <a id="example">Example</a>

サンプルプログラムの本体はshared_ptr_example.cppを参照のこと。
このプログラムは、`shared_ptr`オブジェクトからなる`std::set`と`std::vector`を作成する。

これらのコンテナに`shared_ptr`オブジェクトを格納した後、幾つかの`shared_ptr`オブジェクトの参照カウントが2ではなく1になることに注意せよ。
これは、コンテナとして`std::multiset`ではなく`std::set`が使われているためである(`std::set`は重複するキーを持つ要素を受け入れない)。
更に言うと、これらのオブジェクトの参照カウントは`push_back`及び`insert`のコンテナ操作をしている間は同じ数のままであるだろう。
更に複雑になると、コンテナ操作の際に様々な要因によって例外が発生する可能性もある。
スマートポインタを利用せずにこの様なメモリ管理や例外管理を行うことは、正に悪夢である。

## <a id="Handle/Body">Handle/Body</a> Idiom

`shared_ptr`の一般的な用法の一つに、handle/body表現(pimplとも呼ばれる)の実装がある。
handle/body表現とは、オブジェクト本体の実装を隠蔽する(ヘッダファイル中にさらけ出すことを回避する)ためのものである。

サンプルプログラムshared_ptr_example2_test.cppは、ヘッダファイルshared_ptr_example2.hppをインクルードしている。
このヘッダファイルでは、不完全型のポインタを取る`shared_ptr<>`を利用して実装を隠蔽している。
完全型が必要となるメンバ関数のインスタンス化は、実装ファイルshared_ptr_example2.cpp内に記述されている。
ここでは明示的なデストラクタが必要とされていないことに注意せよ。
`~scoped_ptr`と違い、`~shared_ptr`は`T`は完全型である必要はない。

## <a id="ThreadSafety">Thread Safety</a>

`shared_ptr`オブジェクトはプリミティブ型と同等のスレッドセーフティを提供する。
`shared_ptr`のインスタンスは、複数のスレッドから(const 処理のためのアクセスに限り)同時に&quot;読む&quot;事ができる。
また、異なる`shared_ptr`を、複数のスレッドから(`operator=`や`reset`のようなスレッド動作を想定した操作のためのアクセスに限り)同時に&quot;変更する&quot;こともできる
(それらの`shared_ptr`インスタンスが、コピーされた(同じ参照カウントを共有する)ものでも問題ない )。

上記以外の同時アクセスは未定義のふるまいを引き起こす。

例 Examples:

```cpp
shared_ptr<int> p(new int(42));

//--- Example 1 ---

// thread A
shared_ptr<int> p2(p); // reads p

// thread B
shared_ptr<int> p3(p); // OK, multiple reads are safe

//--- Example 2 ---

// thread A

p.reset(new int(1912)); // writes p

// thread B
p2.reset(); // OK, writes p2

//--- Example 3 ---

// thread A
p = p3; // reads p3, writes p

// thread B
p3.reset(); // writes p3; undefined, simultaneous read/write

//--- Example 4 ---

// thread A
p3 = p2; // reads p2, writes p3

// thread B
// p2 goes out of scope: undefined, the destructor is considered a "write access"

//--- Example 5 ---

// thread A
p3.reset(new int(1));

// thread B
p3.reset(new int(2)); // undefined, multiple writes
```

`shared_ptr`は、実装がスレッドをサポートしているかどうかを検出するために[Boost.Config](/tips/config.md)を使用している。
もしあなたのプログラムがシングルスレッドだとしても、マルチスレッドをサポートしているかどうかは*Boost.Config*が自動的に検出する。
シングルスレッドのプロジェクトにおいて、スレッドセーフティの為のオーバーヘッドを取り除くためには、`#define BOOST_DISABLE_THREADS`を定義する。

## <a id="FAQ">FAQ ( Frequently Asked Questions )</a>

**Q.**
共有ポインタにはそれぞれ異なる特長を持った幾つかの実装のバリエーションがあるが、なぜこのスマートポインタライブラリは単一の実装しか提供しないのか?
手元の仕事に最も適した実装を見つけるために、それぞれの型を試してみられることは有益なのではないだろうか？

**A.**
標準的な所有権共有ポインタを提供することが、`shared_ptr`の重要な目標の一つである。
通常、異なる共有ポインタは併用できないので、安定したライブラリインターフェースを提供するためには共有ポインタ型を一つにすることが大切である。
例えば、(ライブラリAで使われている)参照カウントポインタは、(ライブラリBで使われている)連結ポインタと所有権を共有できない。

**Q.**
なぜ`shared_ptr`は、拡張のためのポリシーや特性を与えるためのテンプレートパラメータを持たないのか。

**A.**
パラメータ化することは、ユーザにとって使いにくくなることに繋がる。
この`shared_ptr`テンプレートは、拡張可能なパラメータを必要とせずに一般的なニーズを満たすように注意深く設計されている。
いつかは、高い拡張性を持ち、非常に使い易く、且つ誤用されにくいスマートポインタが開発されるかも知れない。
しかしそれまでは、`shared_ptr`が幅広い用途に使用されるだろう。
(そのような興味深いポリシー思考のスマートポインタについて知りたければ、Andrei Alexandrescuの[Modern C++ Design](http://cseng.aw.com/book/0,,0201704315,00.html)を読むべきである。)

**Q.**
私は納得できない。
複雑性を隠すためにデフォルトのパラメータを使うことができるはずだ。
もう一度尋ねるが、なぜポリシーを導入しないのか？

**A.**
テンプレートパラメータは型に影響を及ぼす。
この FAQ の最初の解答を参照せよ。

**Q.**
なぜ`shared_ptr`の実装は連結リスト方式を使っていないのか？

**A.**
連結リスト方式の実装は、余分なポインタのためのコストに見合うだけの利点が無いからである。
[timings](smarttests.md)のページを参照せよ。
補足すると、連結リスト方式の実装でスレッドセーフティを実現するには、大きな犠牲を伴う。

**Q.**
なぜ`shared_ptr`やその他のBoostスマートポインタは、`T *`への自動的な型変換を提供しないのか？

**A.**
自動的な型変換は、エラーに繋がる傾向が非常に高いと信じられている。

**Q.**
なぜ`shared_ptr`は`use_count()`を提供しているのか？

**A.**
テストケースを書くための支援や、デバッグ出力の支援をするためである。
循環依存することが分かっているような複雑なプログラムにおいて、原本となる`shared_ptr`の`use_count()`が、バグを追跡するために有効である。

**Q.**
なぜ`shared_ptr`は計算量の指定を明示しないのか？

**A.**
なぜなら、計算量の指定は、実装者に制限を付与し、`shared_ptr`の利用者に対する見かけ上の利益もなしに仕様を複雑化する。
例えば、もしエラー検証機構の実装に厳密な計算量の指定が必要とされた場合、その実装には整合性が無くなってしまうだろう。

**Q.**
なぜ`shared_ptr`は`release()`関数を提供しないのか？

**A.**
`shared_ptr`は`unique()`な時をのぞいて、所有権を譲渡できない。
なぜなら、いずれは所有権を共有している他の`shared_ptr`が、そのオブジェクトを削除するはずだからである。

考えてみよ:

```cpp
shared_ptr<int> a(new int);
shared_ptr<int> b(a); // a.use_count() == b.use_count() == 2

int * p = a.release();
// このとき、pの所有権はどこにあるのだろう？aがrelease()してもなお、bはデストラクタの中でdeleteを呼ぶだろう。
```

**Q.**
なぜ`shared_ptr`は(あなたが大好きな機能をここに当てはめよ)を提供しないのか？

**A.**
なぜなら、(あなたが愛する機能)は、参照カウント方式の実装でも、連結リスト方式の実装でも、あるいは他の特定の実装でも構わないという話だったからである。
故意に提供していないわけではない。

---
Revised $Date: 2003/03/15 06:38:54 $

Copyright 1999 Greg Colvin and Beman Dawes.
Copyright 2002 Darin Adler. 
Copyright 2002 Peter Dimov.
Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies.
This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

Japanese Translation Copyright (C) 2003
[Ryo Kobayashi](mailto:lenoir@zeroscape.org),
[Kohske Takahashi](mailto:kohske@msc.biglobe.ne.jp).

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」
に提供されており、いかなる明示的、暗黙的保証も行わない。また、
いかなる目的に対しても、その利用が適していることを関知しない。

