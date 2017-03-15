# array4.cpp
```cpp
/* クラス array<> の使用例
 */
#include <algorithm>
#include <functional>
#include <string>
#include <iostream>
#include <boost/array.hpp>

int main()
{
    // 四季の array の array
    boost::array<boost::array<std::string,4>,2> seasons_i18n = {
        { { { "spring", "summer", "autumn", "winter", } },
          { { "Fruehling", "Sommer", "Herbst", "Winter" } }
        }
    };

    // すべての array の四季をプリントする
    for (unsigned i=0; i<seasons_i18n.size(); ++i) {
        boost::array<std::string,4> seasons = seasons_i18n[i];
        for (unsigned j=0; j<seasons.size(); ++j) {
            std::cout << seasons[j] << " ";
        }
        std::cout << std::endl;
    }

    // 最初の array の最初の要素をプリントする
    std::cout << "first element of first array: "
              << seasons_i18n[0][0] << std::endl;

    // 最後の array の最後の要素をプリントする
    std::cout << "last element of last array: "
              << seasons_i18n[seasons_i18n.size()-1][seasons_i18n[0].size()-1]
              << std::endl;

    return 0;  // Visual-C++ コンパイラのご機嫌をとる
}
```

