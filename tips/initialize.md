# 組み込み型を必ず初期化する
`boost::initialized<T>`クラステンプレートは、組み込み型を必ず初期化するための型である。値を参照するには、`data()`メンバ関数を使用する。

このクラスを使用するには、`<boost/utility/value_init.hpp>`をインクルードする。

```cpp
#include <iostream>
#include <boost/utility/value_init.hpp>

struct X {
    boost::initialized<int> n;
    boost::initialized<bool> b;
};

int main()
{
    X x;

    std::cout << x.n.data() << std::endl;
    std::cout << x.b.data() << std::endl;

    x.n.data() = 1;
    x.b.data() = true;

    std::cout << x.n.data() << std::endl;
    std::cout << x.b.data() << std::endl;
}
```

実行結果：

```
0
0
1
1
```

