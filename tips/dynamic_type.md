# 動的型
[Boost.Any](http://www.boost.org/doc/libs/release/doc/html/any.html)

## インデックス

- [あらゆる型の値を代入する](#assign)
- [値を取り出す](#extract-value)
- [あらゆる型の値をコンテナに入れる](#store-to-container)


## <a name="assign" href="#assign">あらゆる型の値を代入する</a>

`boost::any`型には、あらゆる型の値を格納することができる。

格納されている型のチェックには、`boost::any::type()`メンバ関数を使用し、[`std::type_info`](https://cpprefjp.github.io/reference/typeinfo/type_info.html)型で判定することができる。

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

```
Hello
```

## <a name="extract-value" href="#extract-value">値を取り出す</a>

`boost::any`に代入した値を取り出すには、`boost::any_cast()`関数を使用する。

この関数の使用方法は、コピーして取り出す、値を参照する、値へのポインタを取得する、の3つがある。


**方法1. 値をコピーして取り出す。**

```cpp
boost::any a;
…
T x = boost::any_cast<T>(a);
```

この例のように、テンプレート引数に取り出す型`T`を指定し、引数として`boost::any`オブジェクトへの参照を渡すことで、`boost::any`型に格納されている型Tのオブジェクトを、コピーで取り出すことができる。

型`T`のオブジェクトが格納されていない場合には、`boost::bad_any_cast`例外が投げられる。


**方法2. 値を参照する。**

```cpp
boost::any a;
…
T& x = boost::any_cast<T&>(a);
```

この例のように、テンプレート引数に`T&`を指定した場合、`boost::any`型に格納されている型Tのオブジェクトを参照することができる。

型`T`のオブジェクトが格納されていない場合には、`boost::bad_any_cast`例外が投げられる。


**方法3. 値へのポインタを取得する。**

```cpp
boost::any a;
T* x = boost::any_cast<T>(&a);
```

この例のように、テンプレート引数に型`T`を指定し、引数として`boost::any`オブジェクトへのポインタを渡すことで、`boost::any`型に格納されている型Tのオブジェクトへのポインタを取得できる。

型`T`のオブジェクトが格納されていない場合には、ヌルポインタが返される。


## <a name="store-to-container" href="#store-to-container">あらゆる型の値をコンテナに入れる</a>

`std::vector<boost::any>`のようにすれば、あらゆる型の値をコンテナに入れることができる。

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
```

実行結果：

```
int : 1
string : Hello
double : 3.14
```


