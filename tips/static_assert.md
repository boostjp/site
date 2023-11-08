# コンパイル時アサート
[Boost.StaticAssert](http://www.boost.org/doc/libs/release/doc/html/boost_staticassert.html)

定数式の条件によるアサートには、`BOOST_STATIC_ASSERT`マクロを使用することができる。

`BOOST_STATIC_ASSERT`マクロを使用するには、`<boost/static_assert.hpp>`をインクルードする。

## インデックス
- [関数にコンパイル時アサートを付ける](#function)
- [クラスにコンパイル時アサートを付ける](#class)
- [C++の国際標準規格上の類似する機能](#cpp-standard)


## <a id="function" href="#function">関数にコンパイル時アサートを付ける</a>

```cpp example
#include <iostream>
#include <boost/static_assert.hpp>
#include <boost/type_traits/is_integral.hpp>

template <class T>
void f(const T& x)
{
    // 整数型以外が渡されたらエラーにする
    BOOST_STATIC_ASSERT(boost::is_integral<T>::value);

    std::cout << x << std::endl;
}

int main()
{
    f(1);    // OK
    f('a');  // OK
    f(3.14); // エラー！
}
```


## <a id="class" href="#class">クラスにコンパイル時アサートを付ける</a>

```cpp example
#include <boost/static_assert.hpp>
#include <boost/type_traits/is_integral.hpp>

template <class T>
struct X {
    // 整数型以外が指定されたらエラー
    BOOST_STATIC_ASSERT(boost::is_integral<T>::value);
};

int main()
{
    X<int> a;    // OK
    X<char> b;   // OK
    X<double> c; // エラー！
}
```

## <a id="cpp-standard" href="#cpp-standard">C++の国際標準規格上の類似する機能</a>
- [コンパイル時アサート](https://cpprefjp.github.io/lang/cpp11/static_assert.html)
