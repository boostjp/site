# Boostのバージョンを調べる

## インデックス
- [基本的な使い方](#basic-usage)


## <a name="basic-usage" href="#basic-usage">基本的な使い方</a>

```cpp example
#include <boost/version.hpp>
#include <iostream>

int main() {
    std::cout << BOOST_VERSION << "\n" // 104601
              << BOOST_LIB_VERSION "\n"; // 1_46_1
}
```

Boostのバージョンが `x.yy.zz` であれば、`BOOST_VERSION` マクロは `x0yyzz` という整数に展開される。また `BOOST_LIB_VERSION` マクロは文字列 `"x_yy_zz"` となるが、`zz` が `00` の場合、`_zz` の部分は省略される。

