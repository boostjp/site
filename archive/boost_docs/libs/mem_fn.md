# mem_fn.hpp

- 翻訳元ドキュメント： <http://www.boost.org/doc/libs/1_31_0/libs/bind/mem_fn.html>

## 目次
- [目的](#purpose)
- [FAQ](#faq)
    - [mem_fnを、標準の std::mem_fun[_ref]アダプタのかわりに使用できるか?](#Q1)
    - [既に書いてしまったコード中のstd::mem_fun[_ref]を、 全てmem_fnで置き換えるべきか?](#Q2)
    - [mem_fnは COM のメソッドに使えるか?](#Q3)
    - [何故 BOOST_MEM_FN_ENABLE_STDCALL は最初から有効になっていないのか?](#Q4)
- [インタフェース](#interface)
    - [Synopsis](#synopsis)
    - [必須事項](#requirements)
    - [get_pointer](#get_pointer)
    - [mem_fn](#mem_fn)
- [実装](#implementation)
    - [ファイル](#files)
    - [依存関係](#dependency)
    - [引数の上限個数](#number-of-arguments)
    - ["__stdcall" と "__fastcall" のサポート](#stdcall)
- [謝辞](#acknowledgements)


## <a id="purpose" href="#purpose">目的</a>
`boost::mem_fn` は、標準関数である`std::mem_fun` と `std::mem_fun_ref`の一般化である。`mem_fn`は、2つ以上の引数をとる メンバ関数へのポインタをサポートし、また`mem_fn`の戻す関数オブジェクトは第一引数に、 (訳注: そのメンバ関数の属するクラスのインスタンスを指すような) ポインタ、参照、スマートポインタをとることができる。 `mem_fn`は、メンバ変数へのポインタも、引数をとらず自身への定数参照を 戻す関数とみなすことによってサポートする。

`mem_fn`の目的は2つある。一つ目は、コンテナにスマートポインタが格納されている場合であっても、 次のような

```cpp
std::for_each(v.begin(), v.end(), boost::mem_fn(&Shape::draw));
```

見慣れた文法によって、メンバ関数の呼び出しを可能にすることである。

二つ目は、メンバ関数へのポインタを関数オブジェクトのように取り扱いたいライブラリ開発者に、 実装の道具として使用して貰うことである。例えば、あるライブラリは次のようにしてより便利な `for_each`アルゴリズムを提供することができ、

```cpp
template<class It, class R, class T> void for_each(It first, It last, R (T::*pmf) ())
{
    std::for_each(first, last, boost::mem_fn(pmf));
}
```

このアルゴリズムは次のようにして手軽に利用することができる。

```cpp
for_each(v.begin(), v.end(), &Shape::draw);
```

このアルゴリズムの機能を文書化する際には、単に次のように書けば良い：

```cpp
template<class It, class R, class T>
void for_each(It first, It last, R (T::*pmf) ());

結果: std::for_each(first, last, boost::mem_fn(pmf)); と同等。
```

ここで、 `boost::mem_fn` の部分はこのページへのリンクとするとよいだろう。 [bindのドキュメント](bind.md) にそのような例があるので参照のこと。

`mem_fn` は1つの引数(メンバ関数へのポインタ)をとり、標準あるいは独自の アルゴリズムに渡すのに適した関数オブジェクトを戻す：

```cpp
struct X
{
    void f();
};

void g(std::vector<X> & v)
{
    std::for_each(v.begin(), v.end(), boost::mem_fn(&X::f));
};

void h(std::vector<X *> const & v)
{
    std::for_each(v.begin(), v.end(), boost::mem_fn(&X::f));
};

void k(std::vector<boost::shared_ptr<X> > const & v)
{
    std::for_each(v.begin(), v.end(), boost::mem_fn(&X::f));
};
```

戻される関数オブジェクトは、引数のメンバ関数ポインタと同じ引数をとることに加え、 インスタンスを表すための「柔軟な」第一引数をとる。

関数オブジェクトが、適切なクラス(上の例では `X`)を指すポインタでも参照でも ない第一引数`x`をもって呼ばれた場合、関数オブジェクトは`get_pointer(x)` を用いて`x`からポインタを得ようとする。 スマートポインタの作者は、自分たちのスマートポインタ向けの適切な`get_pointer`関数 を定義(overload)しておくことで、それを`mem_fn`対応とすることができる。

[注意: `get_pointer` の戻り値はポインタでなくともよい。 `(x->*pmf)(...)`という形式でメンバ関数が呼び出せるなら、どんなオブジェクトでも問題ない。]

[注意: ライブラリは、`get_pointer` の非限定的 (訳注:名前空間を明示しない) 呼び出しを行なう。 そのため、引数依存検索の過程では、オーバーロードされた`boost::get_pointer`関数群に加えて、 そのスマートポインタが定義された名前空間内の`get_pointer`関数群も検索対象になる。]

`mem_fn`が戻す全ての関数オブジェクトは、`result_type`なる`typedef`を開示する。 この`typedef`は、メンバ関数の戻り型を表す。メンバ変数を渡した場合には、`result_type` はそのメンバ変数の型の定数参照として定義される。

## <a id="faq" href="#faq">FAQ</a>
### <a id="Q1" href="#Q1">mem_fnを、標準の std::mem_fun[_ref]アダプタのかわりに使用できるか?</a>
はい。単純な使い方では、`mem_fn` は標準のアダプタが提供しないいくつかの機能を提供する。 `std::bind1st`、`std::bind2nd`、[Boost.Compose](compose.md) と標準のアダプタを組み合わせるような複雑な使い方をしている場合は、 [`boost::bind`](bind.md) を使用するように書き換えることで、`mem_fn`の恩恵を自動的に受けることができる。


### <a id="Q2" href="#Q2">既に書いてしまったコード中のstd::mem_fun[_ref]を、 全てmem_fnで置き換えるべきか?</a>
いいえ。そうする強い理由がないならすべきではない。`mem_fn` は、標準のアダプタに 非常に良く似ているが、100%の互換性があるわけではない。特に、`mem_fn`は、標準の アダプタとは違って `std::[const_]mem_fun[1][_ref]_t` 型のオブジェクトを戻さないので、 標準の `argument_type` 及び `first_argument_type` という (nested) `typedef` を 用いて第一引数の型を記述することが (完全には) できない。


### <a id="Q3" href="#Q4">mem_fnは COM のメソッドに使えるか?</a>
はい。`#define BOOST_MEM_FN_ENABLE_STDCALL` とすれば可能である。


### <a id="Q4" href="#Q4">何故 BOOST_MEM_FN_ENABLE_STDCALL は最初から有効になっていないのか?</a>
特定のベンダへの依存を避けるため、可搬性のない拡張は、一般にデフォルトでオフにされるべきである。 もし `BOOST_MEM_FN_ENABLE_STDCALL` がデフォルトで有効であったなら、あなたはそうとは気づかずに その拡張を使ってしまい、結果としてあなたのコードの可搬性が損なわれるかもしれない。


## <a id="interface" href="#interface">インタフェース</a>
### <a id="synopsis" href="#synopsis">Synopsis</a>

```cpp
namespace boost
{

template<class T> T * get_pointer(T * p);

template<class R, class T> unspecified_1 mem_fn(R (T::*pmf) ());

template<class R, class T> unspecified_2 mem_fn(R (T::*pmf) () const);

template<class R, class T> unspecified_2_1 mem_fn(R T::*pm);

template<class R, class T, class A1> unspecified_3 mem_fn(R (T::*pmf) (A1));

template<class R, class T, class A1> unspecified_4 mem_fn(R (T::*pmf) (A1) const);

template<class R, class T, class A1, class A2> unspecified_5 mem_fn(R (T::*pmf) (A1, A2));

template<class R, class T, class A1, class A2> unspecified_6 mem_fn(R (T::*pmf) (A1, A2) const);

// 実際には、より多くの引数をとるような関数が、更にいくつかオーバーロードされている

}
```
* unspecified_1[italic]
* unspecified_2[italic]
* unspecified_2_1[italic]
* unspecified_3[italic]
* unspecified_4[italic]
* unspecified_5[italic]
* unspecified_6[italic]


### <a id="requirements" href="#requirements">必須事項</a>
Synopsis で述べられた全ての *unspecified-N* 型は `CopyConstructible` (コピーコンストラクト可能) かつ `Assignable` (代入可能) であること。そのためのコピーコンストラクタ及び代入演算子 は例外を送出しないこと。 *unspecified-N* `::result_type` は `mem_fn` に渡されたメンバ関数ポインタの戻り型、と定義されること (Synopsis での `R`)。 *unspecified-2-1* `::result_type` は `R const &` 、と定義されること。


### <a id="get_pointer" href="#get_pointer">get_pointer</a>
```cpp
template<class T> T * get_pointer(T * p)
```

- 戻り値： `p`
- 例外： 送出しない。


### <a id="mem_fn" href="#mem_fn">mem_fn</a>
```cpp
template<class R, class T> unspecified_1 mem_fn(R (T::*pmf) ())
```
* unspecified_1[italic]

- 戻り値： 関数オブジェクト `f` を戻す。ここで、式 `f(t)` は `(t.*pmf)()` と等価である (`t` が `T`あるいはその派生型の左辺値である場合)。 あるいは `(get_pointer(t)->*pmf)()` と等価である(それ以外の場合)。
- 例外： 送出しない。


```cpp
template<class R, class T> unspecified_2 mem_fn(R (T::*pmf) () const)
```
* unspecified_2[italic]

- 戻り値： 関数オブジェクト `f` を戻す。ここで、式 `f(t)` は `(t.*pmf)()` と等価である (`t` が `T [const]` あるいはその派生型である場合)。 あるいは `(get_pointer(t)->*pmf)()` と等価である(それ以外の場合)。
- 例外： 送出しない。


```cpp
template<class R, class T> unspecified_2_1 mem_fn(R T::*pm)
```
* unspecified_2_1[italic]

- 戻り値： 関数オブジェクト `f` を戻す。ここで、式 `f(t)` は `t.*pm` と等価である (`t` が `T [const]` あるいはその派生型である場合)。 あるいは `get_pointer(t)->*pm` と等価である（それ以外の場合）。
- 例外： 送出しない。


```cpp
template<class R, class T, class A1> unspecified_3 mem_fn(R (T::*pmf) (A1))
```
* unspecified_3[italic]

- 戻り値： 関数オブジェクト `f` を戻す。ここで、式 `f(t, a1)` は `(t.*pmf)(a1)` と等価である (`t` が `T` あるいはその派生型の左辺値である場合)。 あるいは `(get_pointer(t)->*pmf)(a1)` と等価である（それ以外の場合）。
- 例外： 送出しない。


```cpp
template<class R, class T, class A1> unspecified_4 mem_fn(R (T::*pmf) (A1) const)
```
* unspecified_4[italic]

- 戻り値： 関数オブジェクト `f` を戻す。ここで、式 `f(t, a1)` は `(t.*pmf)(a1)` と等価である (`t` が `T [const]` あるいはその派生型である場合)。 あるいは `(get_pointer(t)->*pmf)(a1)` と等価である（それ以外の場合）。
- 例外： 送出しない。


```cpp
template<class R, class T, class A1, class A2> unspecified_5 mem_fn(R (T::*pmf) (A1, A2))
```
* unspecified_5[italic]

- 戻り値： 関数オブジェクト `f` を戻す。ここで、式 `f(t, a1, a2)` は `(t.*pmf)(a1, a2)` と等価である (`t` が `T` あるいはその派生型の左辺値である場合)。 あるいは `(get_pointer(t)->*pmf)(a1, a2)` と等価である（それ以外の場合）。
- 例外： 送出しない。


```cpp
template<class R, class T, class A1, class A2> unspecified_6 mem_fn(R (T::*pmf) (A1, A2) const)
```
* unspecified_6[italic]

- 戻り値： 関数オブジェクト `f` を戻す。ここで、式 `f(t, a1, a2)` は `(t.*pmf)(a1, a2)` と等価である (`t` が `T [const]` あるいはその派生型である場合)。 あるいは `(get_pointer(t)->*pmf)(a1, a2)` と等価である（それ以外の場合）。
- 例外： 送出しない。


## <a id="implementation" href="#implementation">実装</a>
### <a id="files" href="#files">ファイル</a>
- boost/mem_fn.hpp (メインヘッダ)
- boost/bind/mem_fn_cc.hpp (mem_fn.hpp より使用される。直接インクルードしないこと。)
- boost/bind/mem_fn_vw.hpp (mem_fn.hpp より使用される。直接インクルードしないこと。)
- boost/bind/mem_fn_template.hpp (mem_fn.hpp より使用される。直接インクルードしないこと。)
- libs/bind/test/mem_fn_test.cpp (テスト)
- libs/bind/test/mem_fn_derived_test.cpp (派生オブジェクトでのテスト)
- libs/bind/test/mem_fn_fastcall_test.cpp (`__fastcall`のテスト)
- libs/bind/test/mem_fn_stdcall_test.cpp (`__stdcall`のテスト)
- libs/bind/test/mem_fn_void_test.cpp (戻りが`void`であるケースのテスト)


### <a id="dependency" href="#dependency">依存関係</a>
- Boost.Config


### <a id="number-of-arguments" href="#number-of-arguments">引数の上限個数</a>
この実装では、8つまでの引数をとるメンバ関数がサポートされている。これは、設計に固有の 制限という訳ではなく、実装の詳細である。


### <a id="stdcall" href="#stdcall">"__stdcall" と "__fastcall" のサポート</a>
いくつかのプラットフォームでは、 **呼び出し規則** (どのように関数が起動されるかの規則: 引数はどのように渡されるのか、戻り値はどのように扱われるのか、もしスタックを使用したなら、 誰がそれを奇麗にするのか) の異なるような何種類かのメンバ関数を作成できる。

例えば、Windows API の関数と、COMインタフェースのメンバ関数は、 `__stdcall` という呼び出し規則を用いるし、 Borland の VCL コンポーネントは `__fastcall` を用いる。

`mem_fn` を `__stdcall` メンバ関数に用いるには、mem_fn.hpp が (直接、あるいは間接的に) インクルードされる前に マクロ `BOOST_MEM_FN_ENABLE_STDCALL` を `#define` する。

`mem_fn` を `__fastcall` メンバ関数に用いるには、mem_fn.hpp が (直接、あるいは間接的に) インクルードされる前に マクロ `BOOST_MEM_FN_ENABLE_FASTCALL` を `#define` する。

[注意: これは可搬性のない拡張であり、インタフェースの一部ではない。]

[注意: いくつかのコンパイラは、 `__stdcall` キーワードに対して最小限のサポートしか提供していない。]


### <a id="acknowledgements" href="#acknowledgements">謝辞</a>
`get_pointer`ベースの設計は、Rene Jageによる、特性クラスを用いて `mem_fn`を ユーザ定義のスマートポインタに適合させるという提案に影響されたものである。

フォーマルレビューの期間に、Richard Crossley、 Jens Maurer、 Ed Brey、その他の方々の示唆によって、たくさんの 改良があった。レビューマネージャは Darin Adler であった。

Steve Anichini は、COMインタフェースが `__stdcall` を使用していることを指摘した。

Dave Abrahams は、不完全なコンパイラにおいても "戻り値なし" をサポートすべく、`bind` と `mem_fn` を改良した。


***
Copyright © 2001, 2002 by Peter Dimov and Multi Media Ltd. Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies. This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

***
Japanese Translation Copyright © 2003 SATO Yusuke <mailto:y-sato@y-sa.to>.

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の 複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」 に提供されており、いかなる明示的、暗黙的保証も行わない。また、 いかなる目的に対しても、その利用が適していることを関知しない。


