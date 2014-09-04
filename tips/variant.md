#ユーザー定義型を扱える型安全な共用体
ユーザー定義型を共用体で扱うには、[Boost Variant Library](http://www.boost.org/doc/libs/release/doc/html/variant.html)を使用する。

Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>基本的な使い方](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>どの型が格納されているかを判定する](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>格納されている値を取り出す](#TOC--2)</li><li class='goog-toc'>[<strong>4 </strong>値をクリアする](#TOC--3)</li><li class='goog-toc'>[<strong>5 </strong>variantを再帰的にする](#TOC-variant-)</li></ol>




###基本的な使い方
まず、Boost.Variantの基本的な使い方を以下に示す：

```cpp
#include <iostream>
#include <string>
#include <boost/variant.hpp>

struct var_printer : boost::static_visitor<void> {
    void operator()(int x) const
        { std::cout << x << std::endl; }

    void operator()(std::string& s) const
        { std::cout << s << std::endl; }

    void operator()(double x) const
        { std::cout << x << std::endl; }
};

int main()
{
    // int, string, doubleのオブジェクトが格納されうる型
    boost::variant<int, std::string, double> v;

    v = 3; // int型の値を代入
    boost::apply_visitor(var_printer(), v); // visitorで型ごとの処理を行う

    v = "hello"; // 文字列を代入
    boost::apply_visitor(var_printer(), v);
}
```

出力：
```cpp
3
hello
```

[`boost::variant`](http://www.boost.org/doc/libs/release/doc/html/boost/variant.html)クラステンプレートが、型安全に抽象化された共用体である。そのテンプレート引数として、格納されうる型を列挙する。
[`boost::variant`](http://www.boost.org/doc/libs/release/doc/html/boost/variant.html)クラスは、テンプレートパラメータで指定された型のオブジェクトを、コピー／ムーブコンストラクタおよび代入演算子で代入できる。
[`boost::apply_visitor()`](http://www.boost.org/doc/libs/release/doc/html/boost/apply_visitor.html)という関数に指定する関数オブジェクトは、[`boost::static_visitor`](http://www.boost.org/doc/libs/release/doc/html/boost/static_visitor.html)クラスから派生したクラスであり、[`boost::variant`](http://www.boost.org/doc/libs/release/doc/html/boost/variant.html)オブジェクトにどの型のオブジェクトが格納されているのかによって、関数呼び出し演算子を適切にオーバーロードしてくれる。


###どの型が格納されているかを判定する
[`boost::variant`](http://www.boost.org/doc/libs/release/doc/html/boost/variant.html)オブジェクトにどの型が格納されているか判定するには以下の`which()`メンバ関数、もしくは`type()`メンバ関数を使用する。

`which()`メンバ関数は、格納されている型の、0から始まるインデックスを返す。

```cpp
#include <iostream>
#include <string>
#include <boost/variant.hpp>

int main()
{
    boost::variant<int, std::string, double> v;

    // 空の状態
    std::cout << v.which() << std::endl;

    v = 1; // int型の値を格納
    std::cout << v.which() << std::endl;

    v = 3.14; // double型の値を格納
    std::cout << v.which() << std::endl;
}
```
* which[color ff0000]
* which[color ff0000]
* which[color ff0000]

出力：
```cpp
0
0
2
```

`type()`メンバ関数は、格納されている型の[`std::type_info`](/reference/typeinfo/type_info.md)オブジェクトへの`const`左辺値参照を返す。
```cpp
#include <iostream>
#include <string>
#include <boost/variant.hpp>

int main()
{
    boost::variant<int, std::string, double> v;

    v = 1; // int型の値を格納
    if (v.type() == typeid(int)) {
        std::cout << "int" << std::endl;
    }

    v = 3.14; // double型の値を格納
    if (v.type() == typeid(double)) {
        std::cout << "double" << std::endl;
    }
}
```
* type[color ff0000]
* type[color ff0000]

出力：
```cpp
int
double
```

###格納されている値を取り出す
[`boost::variant`](http://www.boost.org/doc/libs/release/doc/html/boost/variant.html)オブジェクトに格納されている値を取り出すには、[`boost::get()`](http://www.boost.org/doc/libs/1_52_0/doc/html/boost/get_id1950197.html)非メンバ関数を使用する。
この関数には参照版とポインタ版の2種類が用意されている。それぞれの特徴は以下の通り：

- 参照版 ： [`boost::get()`](http://www.boost.org/doc/libs/1_52_0/doc/html/boost/get_id1950197.html)非メンバ関数に[`boost::variant`](http://www.boost.org/doc/libs/release/doc/html/boost/variant.html)オブジェクトへの参照を渡すと、格納されている値への参照を返す。指定された型が格納されている型と同じではない場合、[`boost::bad_get`](http://www.boost.org/doc/libs/release/doc/html/boost/bad_get.html)型の例外を送出する。
- ポインタ版 ： [`boost::get()`](http://www.boost.org/doc/libs/1_52_0/doc/html/boost/get_id1950197.html)非メンバ関数に[`boost::variant`](http://www.boost.org/doc/libs/release/doc/html/boost/variant.html)オブジェクトへのポインタを渡すと、格納されている値へのポインタを返す。指定された型が格納されている型と同じではない場合、ヌルポインタを返す。```cpp
#include <iostream>
#include <string>
#include <boost/variant.hpp>

int main()
{
    boost::variant<int, std::string, double> v;
    v = 1; // int型の値を格納

    // 参照版
    try {
        int& x = boost::get<int>(v);
        std::cout << x << std::endl;
    }
    catch (boost::bad_get& e) {
        std::cout << e.what() << std::endl;
    }

    // ポインタ版
    if (int* x = boost::get<int>(&v)) {
        std::cout << *x << std::endl;
    }
    else {
        std::cout << "int値は格納されていない" << std::endl;
    }
}
```
* get[color ff0000]
* get[color ff0000]

出力：
```cpp
1
1
```

###値をクリアする
Boost.Variantには[決して空にはならない保証](http://www.boost.org/doc/libs/release/doc/html/variant/design.html#variant.design.never-empty)という考え方があるため、他の値を入れることはできてもクリアはできない。`clear()`関数は用意されておらず、`empty()`メンバ関数は常に`false`を返す。
どうしてもクリアしたい場合は、`boost::blank`という型を`variant`に格納できるように指定する。これは単なる中身が空のクラスである。
`which()`メンバ関数や`type()`メンバ関数を使用して、`boost::blank`オブジェクトが格納されているかどうかで、空かどうかを判定する。

[`boost::variant`](http://www.boost.org/doc/libs/release/doc/html/boost/variant.html)クラスは、そのデフォルトコンストラクタで第1テンプレートパラメータのオブジェクトを構築するので、`boost::blank`は第1テンプレートパラメータとして指定することを推奨する。

```cpp
#include <iostream>
#include <string>
#include <boost/variant.hpp>

int main()
{
    boost::variant<boost::blank, int, std::string> v = boost::blank();
    v = 3;

    v = boost::blank();

    if (v.type() == typeid(boost::blank)) {
        std::cout << "blank" << std::endl;
    }
    else {
        std::cout << "no blank" << std::endl;
    }
}
```
* boost::blank[color ff0000]
* boost::blank()[color ff0000]

出力：
```cpp
blank
```

###variantを再帰的にする

documentated boost version is 1.52.0
