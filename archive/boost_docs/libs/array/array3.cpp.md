# array3.cpp
```cpp example
/* クラス array<> の使用例
 */
#include <string>
#include <iostream>
#include <boost/array.hpp>

template <class T>
void print_elements (const T& x);

int main()
{
    // 四季の array を作る
    boost::array<std::string,4> seasons = {
        { "spring", "summer", "autumn", "winter" }
    };

    // コピーして、並び順を変える
    boost::array<std::string,4> seasons_orig = seasons;
    for (unsigned i=seasons.size()-1; i>0; --i) {
        swap(seasons.at(i),seasons.at((i+1)%seasons.size()));
    }

    std::cout << "one way:   ";
    print_elements(seasons);

    // swap() を試す
    std::cout << "other way: ";
    swap(seasons,seasons_orig);
    print_elements(seasons);

    // 逆イテレータを使ってみる
    std::cout << "reverse:   ";
    for (boost::array<std::string,4>::reverse_iterator pos
           =seasons.rbegin(); pos<seasons.rend(); ++pos) {
        std::cout << " " << *pos;
    }
    std::cout << std::endl;

    return 0;  // Visual-C++ コンパイラのご機嫌をとる
}

template <class T>
void print_elements (const T& x)
{
    for (unsigned i=0; i<x.size(); ++i) {
        std::cout << " " << x[i];
    }
    std::cout << std::endl;
}
```

