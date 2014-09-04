#コンパイル時アサート
定数式の条件によるアサートには、BOOST_STATIC_ASSERTマクロを使用することができる。
BOOST_STATIC_ASSERTマクロを使用するには、<boost/static_assert.hpp>をインクルードする。

```cpp
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

```cpp
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
