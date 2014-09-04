#動的型


Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>あらゆる型の値を代入する](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>値を取り出す](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>あらゆる型の値をコンテナに入れる](#TOC--2)</li></ol>



<h4>あらゆる型の値を代入する</h4>`boost::any`型には、あらゆる型の値を格納することができる。
格納されている型のチェックには、`boost::any::type()`メンバ関数を使用し、[`std::typeinfo`](/reference/typeinfo/type_info.md)型で判定することができる。
格納されている値を元の型に変換するには、`boost::any_cast()`関数を使用する。

```cpp
#include <iostream>
#include <string>
#include <boost/any.hpp>

int main()
{
    boost::any x = 1; // int値を格納
    x = std::string("Hello"); // std::string値を格納

    // 格納されている型をチェック
    if (x.type() == typeid(std::string)) {
        // 元の型に変換
        std::cout << boost::any_cast<std::string>(x) << std::endl;
    }
    else {
        std::cout << "not string" << std::endl;
    }
}
```

実行結果：
```cpp
Hello
```

<h4>値を取り出す</h4>`boost::any`に代入した値を取り出すには、`boost::any_cast()`関数を使用する。
この関数の使用方法は、コピーして取り出す、値を参照する、値へのポインタを取得する、の3つがある。

<b>方法1. 値をコピーして取り出す。</b>
```cpp
boost::any a;
...
T x = boost::any_cast<T>(a);

のように、テンプレート引数に取り出す型Tを指定し、引数としてboost::anyオブジェクトへの参照を渡すことで、boost::any型に格納されている型Tのオブジェクトを、コピーで取り出すことができる。
型Tのオブジェクトが格納されていない場合には、boost::bad_any_cast例外が投げられる。

<b>方法2. 値を参照する。</b>
```cpp
boost::any a;
...
T& x = boost::any_cast<T&>(a);

のように、テンプレート引数にT&を指定した場合、boost::any型に格納されている型Tのオブジェクトを参照することができる。
型Tのオブジェクトが格納されていない場合には、boost::bad_any_cast例外が投げられる。

<b>方法3. 値へのポインタを取得する。</b>
```cpp
boost::any a;
T* x = boost::any_cast<T>(&a);
```

のように、テンプレート引数に型`T`を指定し、引数として`boost::any`オブジェクトへのポインタを渡すことで、`boost::any`型に格納されている型Tのオブジェクトへのポインタを取得できる。
型`T`のオブジェクトが格納されていない場合には、ヌルポインタが返される。
<h4>あらゆる型の値をコンテナに入れる</h4>`std::vector<boost::any>`のようにすれば、あらゆる型の値をコンテナに入れることができる。
このようなコンテナは、ヘテロなコンテナ(heterogeneous containers)と呼ばれる。

```cpp
#include <iostream>
#include <string>
#include <vector>
#include <boost/any.hpp>
#include <boost/foreach.hpp>

int main()
{
    std::vector<boost::any> v;
    v.push_back(1);
    v.push_back(std::string("Hello"));
    v.push_back(3.14);

    BOOST_FOREACH (const boost::any& x, v) {
        if (x.type() == typeid(int)) {
            std::cout << "int : " << boost::any_cast<int>(x) << std::endl;
        }
        else if (x.type() == typeid(std::string)) {
            std::cout << "string : " << boost::any_cast<std::string>(x) << std::endl;
        }
        else if (x.type() == typeid(double)) {
            std::cout << "double : " << boost::any_cast<double>(x) << std::endl;
        }
        else {
            std::cout << "unknown type" << std::endl;
        }
    }
}

実行結果：
```cpp
int : 1
string : Hello
double : 3.14

```
