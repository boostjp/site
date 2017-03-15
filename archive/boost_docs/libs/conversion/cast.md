# Header boost/cast.hpp

ヘッダboost/cast.hppは、C++の組み込みキャストを補完するべく作成された、 [`polymorphic_cast`](#polymorphic_cast), [`polymorphic_downcast`](#polymorphic_cast), [`numeric_cast`](#numeric_cast)を提供する。

プログラムcast_test.cppは、これらの関数が期待通り動作するか確認するためのものである。

## <a name="polymorphic_cast" href="#polymorphic_cast">多態キャスト</a>
多態オブジェクト(少なくとも一個の仮想関数を定義しているクラスのオブジェクト)へのポインタは、時にダウンキャストやクロスキャストされることがある。ダウンキャストとは基本クラスから派生クラスへのキャストである。クロスキャストは継承階層を横切るようなキャストである。例えば、多重継承した基本クラスの一つから、他の基本クラスへのキャストなど。

このようなキャストは古いキャスト演算子でも可能であるが、もうこのアプローチは推奨されない。古いキャスト演算子は型安全性に著しく欠け、可読性を激しく損ない、おまけに検索するのが大変なので。

C++に組み込まれた`static_cast`は、多態オブジェクトへのポインタを効率よくダウンキャストするが、ポインタが実際に指しているのと異なる派生クラスへのキャストをしようとしたとき、エラーを検出しない。 `polymorphic_downcast`テンプレートは、非デバッグコンパイル時には、`static_cast`の効率を維持するが、デバッグコンパイル時には、`dynamic_cast`の成功を`assert()`によって保証し、安全性を高める。

C++に組み込まれた`dynamic_cast`は、多態オブジェクトへのポインタをダウンキャストまたはクロスキャストするために使うことができるが、エラーを知るには不便にも、返却値が`0`でないかチェックしなければならず、さらに悪いことに、チェックしないでも済ますことができる。 `polymorphic_cast`テンプレートは`dynamic_cast`を行い、返却値が`0`だったときには例外を送出する。

`polymorphic_downcast`は、デバッグモードでのテストで、キャストされうるオブジェクト型を100%カバーでき、同時に非デバッグモードでは効率が重要な場合に役立つであろう。 この二つの条件が満たされないなら、`polymorphic_cast`が適している。また、クロスキャストにはこちらを使わなければならない。 `polymorphic_downcast`は、`assert( dynamic_cast<Derived>(x) == x )` (`x`は基本クラスへのポインタ)を行う。`0`が返されなかったばかりでなく、多重継承したオブジェクトへのポインタも正しく変換されたことを保証するためである。 注意:: `polymorphic_downcast`は`assert()`を使っているので、`NDEBUG`の定義が翻訳単位間で異なっていると、単一定義規則(ODR)に違反する。[See ISO Std 3.2]

C++に組み込まれた`dynamic_cast`は、ポインタではなく参照のキャストに使われるべきである。さもなくば、あるインタフェースがサポートされているかどうか調べるために使うことができる。この場合、返却値が`0`になることはエラーではない。


### `polymorphic_cast`と`polymorphic_downcast`の概要
```cpp
namespace boost {

template <class Derived, class Base>
inline Derived polymorphic_cast(Base* x);

// Throws: dynamic_cast<Derived>(x) == 0のときstd::bad_castを送出する
// Returns: dynamic_cast<Derived>(x)

template <class Derived, class Base>
inline Derived polymorphic_downcast(Base* x);
// Effects: assert( dynamic_cast<Derived>(x) == x );
// Returns: static_cast<Derived>(x)

}
```


### `polymorphic_downcast`の例
```cpp
#include <boost/cast.hpp>
...
class Fruit { public: virtual ~Fruit(){}; ... };
class Banana : public Fruit { ... };
...
void f( Fruit * fruit ) {
// ... logic which leads us to believe it is a Banana
  Banana * banana = boost::polymorphic_downcast<Banana*>(fruit);
  ...
```


## <a name="numeric_cast" href="#numeric_cast">`numeric_cast`</a>
`static_cast`や暗黙の変換は、数値をキャストしたときに、表現できる範囲を越えてしまっても感知しない。`numeric_cast`関数テンプレートは`static_cast`(や暗黙の変換にも、まあ、そこそこ)に似ているが、値の範囲を越えた場合、検出できる点が異なる。実行時に、値が正しく保存されるかチェックして、失敗した場合、例外が送出される。

引数型と返却値型の必須事項は次の通り:
- 引数型と返却値型は、いずれも`CopyConstructible` [ISO Std 20.1.3]でなければならない。
- 引数型と返却値型は、いずれも(`std::numeric_limits<>::is_specialized`が真であることで定義される)`Numeric`でなければならない。
- 引数型は、返却値型に`static_cast`を用いて変換できなければならない。


### `numeric_cast`の概要
```cpp
namespace boost {

class bad_numeric_cast : public std::bad_cast {...};

template<typename Target, typename Source>
  inline Target numeric_cast(Source arg);

    // Throws:  SourceからTagertへの変換によって、std::numeric_limitsの定めに
    //          従い、負数の符号が無くなったり、アンダーフローやオーバーフロー
    //          する場合、bad_numeric_castを送出する。
    // Returns: static_cast<Target>(arg)

}
```

### `numeric_cast`の例
```cpp
#include <boost/cast.hpp>
using namespace boost::cast;

void ariane(double vx)
{
    ...
    unsigned short dx = numeric_cast<unsigned short>(vx);
    ...
}
```


### `numeric_cast`の理論的根拠
例外送出の条件は、`!=` 演算の必要を無くすように構成されている。


## 歴史的経緯
`polymorphic_cast`は"The C++ Programming Language"においてBjarne Stroustrupより提案された。

`polymorphic_downcast`は[Dave Abrahams](http://www.boost.org/doc/libs/1_31_0/people/dave_abrahams.htm)より寄贈された。

`numeric_cast`は[Kevlin Henney](http://www.boost.org/doc/libs/1_31_0/people/kevlin_henney.htm)より寄贈された。


***
Revised 06 January, 2001

© Copyright boost.org 1999. Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies. This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

***
Japanese Translation Copyright (C) 2003 Yoshinori Tagawa.

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の 複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」 に提供されており、いかなる明示的、暗黙的保証も行わない。また、 いかなる目的に対しても、その利用が適していることを関知しない。


