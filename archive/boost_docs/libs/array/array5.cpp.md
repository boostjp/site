# array5.cpp
```cpp example
/* クラス array<> の簡単な使用例
 */
#include <iostream>
#include <boost/array.hpp>

template <typename T>
void test_static_size (const T& cont)
{
    int tmp[T::static_size];
    for (unsigned i=0; i<T::static_size; ++i) {
        tmp[i] = int(cont[i]);
    }
    for (unsigned i=0; i<T::static_size; ++i) {
        std::cout << tmp[i] << ' ';
    }
    std::cout << std::endl;
}

int main()
{
    // 特殊な型を定義する
    typedef boost::array<float,6> Array;

    // array の生成と初期化
    const Array a = { { 42.42 } };

    // STL コンテナでの共通する操作をいくつかおこなう
    std::cout << "static_size: " << a.size() << std::endl;
    std::cout << "size:        " << a.size() << std::endl;
    std::cout << "empty:       " << std::boolalpha << a.empty() << std::endl;
    std::cout << "max_size:    " << a.max_size() << std::endl;
    std::cout << "front:       " << a.front() << std::endl;
    std::cout << "back:        " << a.back() << std::endl;
    std::cout << "[0]:         " << a[0] << std::endl;
    std::cout << "elems:       ";

    // すべての要素に対して反復操作をおこなう
    for (Array::const_iterator pos=a.begin(); pos<a.end(); ++pos) {
        std::cout << *pos << ' ';
    }
    std::cout << std::endl;
    test_static_size(a);

    // コピーコンストラクタと代入演算子のチェック
    Array b(a);
    Array c;
    c = a;
    if (a==b && a==c) {
        std::cout << "copy construction and copy assignment are OK"
                  << std::endl;
    }
    else {
        std::cout << "copy construction and copy assignment are BROKEN"
                  << std::endl;
    }

    typedef boost::array<double,6> DArray;
    typedef boost::array<int,6> IArray;
    IArray ia = { 1, 2, 3, 4, 5, 6 };
    DArray da;
    da = ia;
    da.assign(42);

    return 0;  // Visual-C++ コンパイラのご機嫌をとる
}
```

