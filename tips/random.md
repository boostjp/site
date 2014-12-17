#乱数
[Boost Random Library](http://www.boost.org/doc/libs/release/doc/html/boost_random.html)は、多数の擬似乱数生成器と分布のクラスを提供するライブラリである。Boost.Randomは、メルセンヌツイスターや線形合同法といった擬似乱数を生成するアルゴリズムと、整数一様分布やベルヌーイ分布といった値の分布のアルゴリズムを組み合わせて使用するという特徴を持つ。


##インデックス
- [基本的な使い方](#basic-usage)
- [シードを再設定する](#set-seed)


## <a name="basic-usage" href="#basic-usage">基本的な使い方</a>
以下は、メルセンヌツイスター法による乱数生成と、1から6までの値を一様分布する例である。

`mt19937`がメルセンヌツイスター法による擬似乱数生成アルゴリズムのエンジンクラス、`uniform_int_distribution`が一様分布(等確率)による分布アルゴリズムのクラスである。

`uniform_int_distribution`はコンストラクタで値の範囲を受け取り、その関数呼び出し演算子の引数としてエンジンを受け取ることにより、そのエンジンで指定された値の範囲の擬似乱数を生成する。

```cpp
#include <iostream>
#include <boost/random.hpp>

int main()
{
    boost::random::mt19937 gen;
    boost::random::uniform_int_distribution<> dist(1, 6);

    for (int i = 0; i < 10; ++i) {
        int result = dist(gen);
        std::cout << result << std::endl;
    }
}
```

実行結果：
```
5
1
6
6
1
6
6
2
4
2
```

## <a name="set-seed" href="#set-seed">シードを再設定する</a>
Boost.Randomのジェネレータでシードの再設定をするには、ジェネレータの`seed()`メンバ関数を使用する。

この関数は、ジェネレータのコンセプトとして規定されているので、Boost.Randomの全てのジェネレータで同じように使用できる。

以下は、メルセンヌ・ツイスターの例：

```cpp
#include <iostream>
#include <boost/random.hpp>

int main()
{
    std::size_t seed = 0; // てきとうなシード

    boost::random::mt19937 gen(seed);

    for (int i = 0; i < 3; ++i) {
        std::cout << gen() << std::endl;
    }

    std::cout << "--" << std::endl;

    gen.seed(seed); // シードを再設定
    for (int i = 0; i < 3; ++i) {
        std::cout << gen() << std::endl;
    }
}
```

出力：
```
2357136044
2546248239
3071714933
--
2357136044
2546248239
3071714933
```

シード再設定後に、同じ値が生成されているのがわかるだろう。

分布クラスを通しても同じ値が生成される：

```cpp
#include <iostream>
#include <boost/random.hpp>

int main()
{
    std::size_t seed = 0;

    boost::random::mt19937 gen(seed);
    boost::random::uniform_int_distribution<> dist(0, 10);

    for (int i = 0; i < 3; ++i) {
        std::cout << dist(gen) << std::endl;
    }

    std::cout << "--" << std::endl;

    gen.seed(seed); // シードを再設定
    for (int i = 0; i < 3; ++i) {
        std::cout << dist(gen) << std::endl;
    }
}
```

出力：
```
6
6
7
--
6
6
7
```

なお、シードを取得する機能はないので、シードの管理自体はユーザーが行う必要がある。

