# singleton

## Motivation
serializationライブラリは、いくつかの静的変数とテーブルが存在し、それが実行時のタイプに関連する情報を格納することに基づいています。 たとえば、exportされた名前とタイプを関連づけるテーブルや、基底クラスと派生クラスとを関連づけるテーブルです。 これらの変数の生成と破棄、そして利用においては、以下に示す問題の考慮が必要です。

- いくつかの静的なデータ変数と定数は、他の要素を参照します。初期化の順序は任意ではだめで、適切な順序でなければなりません。
- 多くの静的変数は、明示的に参照されることがなく、特別な予防措置を講じない限り、最適化によって取り除かれてしまいます。
- これらの変数の多くはテンプレートで作られます。そして、それらがインスタンス化されることを確実にする配慮が必要です。
- マルチスレッドシステムでは、これら静的変数に別々のスレッドから並行的にアクセスすることが可能です。これは、予測不可能な振る舞いでレースコンディションを生み出します。

この`singleton`クラスは上記問題を解決します。


## Features
この`singleton`実装は、以下の特徴を持ちます。

- あらゆるインスタンスがそれにアクセスが試みられる前に構築されます。
- あらゆるクラステンプレートのインスタンスが、インスタンス化されることを保証します。
- インスタンスが明示的に参照されるかどうかにかかわらず、リリースモードでビルドした際も最適化で消去され宇ことはありません。
- すべてのインスタンスがmain関数が呼び出される前に、プログラム内で参照される際に構築されます。マルチタスクシステムにおいて、あらゆるインスタンスの生成の間、レースコンディションが発生しないことを保証します。この保証をするためにスレッドのロックは必要ありません。
- 上記は、どんなconstインスタンスでも、プログラム全体でスレッドセーフであることを意味します。もう一度言いますが、スレッドのロックは必要ありません。
- mutableなインスタンスが作られ、`main`関数がマルチスレッドシステムで呼び出されたあとに変更されるならば、レースコンディションが発生する可能性があります。serializationライブラリでは、mutableな`singleton`が必要となるわずかな場所において、`main`関数が呼び出されたあとに、それが変更されないように注意します。より一般的な目的のため、この`singleton`上でロックを行うスレッドを簡単に実装することができましたが、serializationライブラリがそれを必要としなかったので、実装しませんでした。

## Class Interface

```cpp
namespace boost {
namespace serialization {

template
class singleton : public boost::noncopyable
{
public:
 static const T & get_const_instance();
 static T & get_mutable_instance();
};

} // namespace serialization 
} // namespace boost
```

```cpp
static const T & get_const_instance();
```

このタイプの`singleton`への`const`参照を返します。

```cpp
static T & get_mutable_instance();
```

このタイプの`singleton`へのmutable参照を返します。


## Requirements
`singleton<T>`として使えるように、型`T`はdefault constructibleでなければなりません。

それ(`T`?)は静的変数を持っているかもしれませんが、静的変数を必要としません。

> It doesn't require static variables -though it may have them.

ライブラリが、`singleton<T>`の唯一のインスタンスへのすべてのアクセスが、上記静的インターフェースを介して行われるため、`T`の一般的なメンバ関数は、機能的には、静的メンバ関数と同等となります。


## Examples
このクラステンプレートには少なくとも2つの異なる使用法があります。 これらは両方ともserializationライブラリで用いられています。 最初の利用方法を、下記のコードを含むextended_type_info.cppから抜粋します。

```cpp
typedef std::set ktmap;
...
void
extended_type_info::key_register(const char *key) {
 ...
    result = singleton::get_mutable_instance().insert(this);
 ...
}
```

プログラムのどこからでも`singleton`のインスタンスを参照することで、その型(この例ではktmap)の唯一のインスタンスがプログラムを通して存在することを保証します。 他に宣言や定義は必要ありません。

2つめの利用方法は、型の基底クラスの1つとして`singleton<T>`を用います。 extended_type_info_typeid.hppから単純化した抜粋を示します。

```cpp
template<class T>
class extended_type_info_typeid :
 public detail::extended_type_info_typeid_0,
 public singleton<extended_type_info_typeid<const T> >
{
 friend class singleton<extended_type_info_typeid<const T> >;
private:
 // private constructor to inhibit any existence other than the 
 // static one.  Note: not all compilers support this !!!
    extended_type_info_typeid() :
        detail::extended_type_info_typeid_0()
 {
        type_register(typeid(T));
 }
 ~extended_type_info_typeid(){}
 ...
};
```

この利用法は、以下のより自然なシンタックスが利用可能です。

```cpp
extended_type_info_typeid<T>::get_const_instance()
```

どこでも上記の文を1つ以上プログラムに含むならば、唯一のインスタンスが生成され、参照されることを保証します。


## Multi-Threading
この`singleton`は、次の単純なルールにしたがうことで、マルチスレッドアプリケーションから安全に使うことができます。

複数のスレッドが走っているとき、`get_mutable_instance`を呼び出さないこと!

serializationライブラリで利用されるすべての`singleton`はこのルールに従います。

ミスによるこのルール違反を発見するのを助けるために、lock/unlock機能が存在します。

```cpp
boost::serialization::global_lock::get_mutable_instance().lock();
boost::serialization::global_lock::get_mutable_instance().unlock();
```

プログラムをデバッグ用にコンパイルしている間、ライブラリが"locked"状態での`get_mutable_instance()`の呼び出しはassertionとしてトラップされます。

`main`関数が呼び出される前に、静的変数の変更を許可するためのgloal_lock状態は"unlocked"で初期化されます。

すべてのserializationテストはプログラムの開始時に`lock()`を呼び出します。

リリースモードでコンパイルされるプログラムでは、これらの関数は何の影響も与えません。

