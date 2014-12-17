#ref.hpp

 1.00.0004 (2002-01-27)

- 翻訳元ドキュメント： <http://www.boost.org/doc/libs/1_31_0/doc/html/ref.html>

##目次
- [ファイル](#files)
- [目的](#purpose)
- [インタフェース](#interface)
- [謝辞](#acknowledgements)


## <a name="files" href="#files">ファイル</a>
- ref.hpp


## <a name="purpose" href="#purpose">目的</a>
boost/ref.hpp ヘッダーでは、クラス テンプレートである `boost::reference_wrapper<T>` と、`boost::reference_wrapper<T>` のインスタンスを返す二つの関数 `boost::ref` と `boost::cref`、それに二つの特性クラス `boost::is_reference_wrapper<T>` と `boost::unwrap_reference<T>` が定義されている。

`boost::reference_wrapper<T>` の目的は、`T` 型のオブジェクトへの参照を格納することにある。主に、値渡しの仮引数をとる関数のテンプレート (アルゴリズム) に参照を「食わせる (feed)」のに使われる。

この使い方をサポートするため、`boost::reference_wrapper<T>` は `T &` への暗黙の型変換を提供する。このことにより、関数テンプレートが適合していない参照に対しても大抵はうまく働くようになる。

`boost::reference_wrapper<T>` は `CopyConstructible`（コピーコンストラクト可能) でかつ `Assignable` (代入可能) である (通常の参照は `Assignable` (代入可能) ではない)。

`X` が `x` の型である場合、`boost::ref(x)` という式は `boost::reference_wrapper<X>(x)` を返す。同様に、`boost::cref(x)` は `boost::reference_wrapper<X const>(x)` を返す.

`boost::is_reference_wrapper<T>::value` という式は、もし `T` が `reference_wrapper` であるときには `true` を返し、それ以外のときには `false` を返す。

`boost::unwrap_reference<T>::type` という型式 (type-expression) は、`T` が `reference_wrapper` のときには `T::type` であり、それ以外のときには `T` である。


## <a name="interface" href="#interface">インタフェース</a>
###Synopsis
```cpp
namespace boost
{
    template<class T> class reference_wrapper;
    template<class T> reference_wrapper<T> ref(T & t);
    template<class T> reference_wrapper<T const> cref(T const & t);
    template<class T> class is_reference_wrapper<T const>;
    template<class T> class unwrap_reference<T const>;
}
```
* class reference_wrapper[link #reference_wrapper]
* ref(T& t)[link #ref]
* cref(T& const & t)[link #cref]
* is_reference_wrapper[link #is_reference_wrapper]
* unwrap_reference[link #unwrap_reference]


### <a name="reference_wrapper" href="#reference_wrapper">reference_wrapper</a>
```cpp
template<class T> class reference_wrapper
{
public:
    typedef T type;

    explicit reference_wrapper(T & t);

    operator T & () const;

    T & get() const;
    T* get_pointer() const;
};
```
* explicit reference_wrapper[#op_constructor]
* operator T &[#op_t]
* T& get[#get]
* T* get_pointer[#get_pointer]


#### <a name="op_constructor" href="#op_constructor">`explicit reference_wrapper(T & t)`</a>
- 作用: `t` への参照を格納する `reference_wrapper` のオブジェクトを構築する。
- 例外: なし。


#### <a name="op_t" href="#op_t">`operator T & () const`</a>
- 戻り値: 格納した参照。
- 例外: なし。


#### <a name="get" href="#get">`T & get() const`</a>
- 戻り値: 格納した参照。
- 例外: なし。


#### <a name="get_pointer" href="#get_pointer">`T* get_pointer() const`</a>
- 戻り値: 格納したオブジェクトへのポインタ。
- 例外: なし。


### <a name="ref" href="#ref">`ref`</a>
```cpp
template<class T> reference_wrapper<T> ref(T & t);
```

- 戻り値: `reference_wrapper<T>(t)`
- 例外: なし。


### <a name="cref" href="#cref">`cref`</a>
```cpp
template<class T> reference_wrapper<T const> cref(T const & t);
```

- 戻り値: `reference_wrapper<T const>(t)`
- 例外: なし。


### <a name="is_reference_wrapper" href="#is_reference_wrapper">`is_reference_wrapper`</a>
```cpp
template<class T> class is_reference_wrapper<T const>
{
 public:
    static bool value = unspecified;
};
```
* unspecified[italic]

もし `T` が `reference_wrapper` の特殊化版であれば値は `true`。


### <a name="unwrap_reference" href="#unwrap_reference">unwrap_reference</a>
```cpp
template<class T> class unwrap_reference<T const>
{
 public:
    typedef unspecified type;
};
```
* unspecified[italic]

もし `T` が `reference_wrapper` の特殊化版であれば `type` は `T::type` と等価。そうでなければ `type` は `T` と等価。


## <a name="acknowledgements" href="#acknowledgements">謝辞</a>
`ref` と `cref` は元々は Jaakko Järvi 氏作の Boost.Tuple というライブラリの一部であった。それが、一般的に有用であるという理由で Peter Dimov 氏の手によって「`boost::` に昇格」した。Douglas Gregor 氏と Dave Abrahams 氏が `is_reference_wrapper` と `unwrap_reference` を提供した。


***
Copyright © 2001 by Peter Dimov and Multi Media Ltd. Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies. This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

***
Japanese Translation Copyright © 2003 [Fujio Kojima](f_kojima@fukuicompu.co.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

