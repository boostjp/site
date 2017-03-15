# array2.cpp
```cpp
/* クラス array<> の使用例
 */
#include <algorithm>
#include <functional>
#include <boost/array.hpp>
#include "print.hpp"
using namespace std;
using namespace boost;

int main()
{
    // array の生成と初期化
    array<int,10> a = { { 1, 2, 3, 4, 5 } };

    print_elements(a);

    // 要素を直接変更する
    for (unsigned i=0; i<a.size(); ++i) {
        ++a[i];
    }
    print_elements(a);

    // STL アルゴリズムを使って並び順を変える
    reverse(a.begin(),a.end());
    print_elements(a);

    // STL フレームワークを使って要素の否定をとる
    transform(a.begin(),a.end(),    // source
              a.begin(),            // destination
              negate<int>());       // operation
    print_elements(a);

    return 0;  // Visual-C++ コンパイラのご機嫌をとる
}

```

