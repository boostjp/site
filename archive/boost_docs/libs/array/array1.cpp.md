# array1.cpp
```cpp example
/*クラス array<> を使った簡単な例
 */
#include <iostream>
#include <boost/array.hpp>

int main()
{
    // 特殊な型を定義する
    typedef boost::array<float,6> Array;

    // array の生成と初期化
    Array a = { { 42 } };

    // 要素へのアクセス
    for (unsigned i=1; i<a.size(); ++i) {
        a[i] = a[i-1]+1;
    }

    // STL コンテナでの共通する操作をいくつかおこなう
    std::cout << "size:     " << a.size() << std::endl;
    std::cout << "empty:    " << std::boolalpha << a.empty() << std::endl;
    std::cout << "max_size: " << a.max_size() << std::endl;
    std::cout << "front:    " << a.front() << std::endl;
    std::cout << "back:     " << a.back() << std::endl;
    std::cout << "elems:    ";

    // すべての要素に対して反復操作をおこなう
    for (Array::const_iterator pos=a.begin(); pos<a.end(); ++pos) {
        std::cout << *pos << ' ';
    }
    std::cout << std::endl;

    // コピーコンストラクタと代入演算子のチェック
    Array b(a);
    Array c;
    c = a;
    if (a==b && a==c) {
        std::cout << "copy construction and copy assignment are OK"
                  << std::endl;
    }
    else {
        std::cout << "copy construction and copy assignment FAILED"
                  << std::endl;
    }

    return 0;  // Visual-C++ コンパイラのご機嫌をとる
}
```

