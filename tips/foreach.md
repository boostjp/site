# for each文
[Boost Foreach Library](http://www.boost.org/doc/libs/release/libs/foreach/index.html)は、C++においてシーケンスをループするためのfor each文をライブラリで提供する。

## インデックス

- [`BOOST_FOREACH`マクロ](#boost-foreach-macro)
- [要素を参照する](#reference)
- [標準コンテナに対して使用する](#apply-container)
- [`std::map`に対して使用する](#apply-map)
- [逆順にループする](#reverse-iteration)
- [配列に対して使用する](#apply-multi-array)
- [C++11 範囲`for`文との違い](#difference-cpp11-range-for)


## <a name="boost-foreach-macro" href="#boost-foreach-macro">BOOST_FOREACHマクロ</a>

for each文には、`BOOST_FOREACH`というマクロを使用する。

`BOOST_FOREACH`を使用することで、シーケンスの各要素が順番にループ変数に格納され、処理される。

このマクロを使用するには、`<boost/foreach.hpp>`をインクルードする。


```cpp
#include <iostream>
#include <boost/foreach.hpp>

int main()
{
    const int ar[] = {3, 1, 4};

    BOOST_FOREACH (int x, ar) {
        std::cout << x << std::endl;
    }
}
```

実行結果：

```
3
1
4
```


## <a name="reference" href="#reference">要素を参照する</a>

`BOOST_FOREACH`マクロは、シーケンスの各要素を参照し、書き換えることができる。

```cpp
#include <iostream>
#include <boost/foreach.hpp>

int main()
{
    int ar[] = {3, 1, 4};

    BOOST_FOREACH (int& x, ar) {
        ++x; // 要素を書き換える
    }

    BOOST_FOREACH (int x, ar) {
        std::cout << x << std::endl;
    }
}
```

実行結果：

```
4
2
5
```

## <a name="apply-container" href="#apply-container">標準コンテナに対して使用する</a>

`BOOST_FOREACH`マクロは、組み込み配列だけではなく、`std::vector`や`std::list`、`std::map`といった標準ライブラリのコンテナを処理することができる。

```cpp
#include <iostream>
#include <vector>
#include <boost/assign/list_of.hpp>
#include <boost/foreach.hpp>

int main()
{
    const std::vector<int> v = boost::assign::list_of(3)(1)(4);

    BOOST_FOREACH (int x, v) { // std::vectorをループする
        std::cout << x << std::endl;
    }
}
```

実行結果：

```
3
1
4
```


## <a name="apply-map" href="#apply-map">std::mapに対して使用する</a>

`BOOST_FOREACH`マクロで`std::map`を処理するには、少し工夫が必要になる。

`BOOST_FOREACH`マクロの第1引数には、`std::map`の要素型である`std::pair`を直接書きたいところではあるが、言語仕様の制限により、マクロの引数の中でカンマを使用することができない。

そこで、要素型は事前に`typedef`しておく必要がある。



```cpp
#include <iostream>
#include <map>
#include <string>
#include <boost/foreach.hpp>

int main()
{
    std::map<int, std::string> m;
    m[3] = "a";
    m[1] = "b";
    m[4] = "c";

    typedef std::map<int, std::string>::const_reference type;
    BOOST_FOREACH (type x, m) {
        std::cout << x.first << ',' << x.second << std::endl;
    }
}
```

実行結果：

```
1,b
3,a
4,c
```

しかし多くの場合、`std::map`をループする際には、キーか値、どちらかがとれれば十分である。

その場合は、Boost Range Libraryの`boost::adaptors::map_keys`を使用してキーのみを抽出、`boost::adaptors::map_values`を使用して値のみを抽出できる。


```cpp
#include <iostream>
#include <map>
#include <string>
#include <boost/range/adaptor/map.hpp>
#include <boost/foreach.hpp>

int main()
{
    std::map<int, std::string> m;
    m[3] = "a";
    m[1] = "b";
    m[4] = "c";

    // キーのみを抽出
    BOOST_FOREACH (int key, m | boost::adaptors::map_keys) {
        std::cout << key << ' ';
    }
    std::cout << std::endl;

    // 値のみを抽出
    BOOST_FOREACH (const std::string& value, m | boost::adaptors::map_values) {
        std::cout << value << ' ';
    }
}
```

実行結果：

```
1 3 4 
b a c 
```


## <a name="reverse-iteration" href="#reverse-iteration">逆順にループする</a>

逆順にループするには、`BOOST_REVERSE_FOREACH`マクロを使用するか、もしくはシーケンスに対してBoost Range Libraryの`boost::adaptors::reversed`を適用する。


`BOOST_REVERSE_FOREACH`マクロを使用する場合：

```cpp
#include <iostream>
#include <vector>
#include <boost/assign/list_of.hpp>
#include <boost/foreach.hpp>

int main()
{
    const std::vector<int> v = boost::assign::list_of(3)(1)(4);

    BOOST_REVERSE_FOREACH (int x, v) {
        std::cout << x << std::endl;
    }
}
```

実行結果：

```
4
1
3
```

`boost::adaptors::reversed`を使用する場合：


```cpp
#include <iostream>
#include <vector>
#include <boost/assign/list_of.hpp>
#include <boost/range/adaptor/reversed.hpp>
#include <boost/foreach.hpp>

int main()
{
    const std::vector<int> v = boost::assign::list_of(3)(1)(4);

    BOOST_FOREACH (int x, v | boost::adaptors::reversed) {
        std::cout << x << std::endl;
    }
}
```

実行結果：

```
4
1
3
```


## <a name="apply-multi-array" href="#apply-multi-array">配列の配列に対して使用する</a>

多次元配列のような「シーケンスのシーケンス」に対しては、`BOOST_FOREACH`を重ねて使用することで対処できる。

言語組込の配列を使用する場合：

```cpp
#include <iostream>
#include <boost/foreach.hpp>

int main()
{
    typedef int int_a2[2];
    const int_a2 a[2] = {
        {1, 2},
        {3, 4},
    };

    BOOST_FOREACH(const int_a2 &x, a)
    {
        BOOST_FOREACH(int y, x)
        {
            std::cout << y << ' ';
        }
        std::cout << std::endl;
    }
}
```

「配列への参照型」の記法は直感的でないため、`typedef`を用いている。


実行結果：

```
1 2
3 4
```

`std::vector`を使用する場合：

```cpp
#include <iostream>
#include <vector>
#include <boost/foreach.hpp>
#include <boost/assign/list_of.hpp>

int main()
{
    std::vector<std::vector<int> > v;
    v.push_back(boost::assign::list_of(1)(10));
    v.push_back(boost::assign::list_of(2)(20));

    BOOST_FOREACH(std::vector<int> const &x, v)
    {
        BOOST_FOREACH(int y, x)
        {
            std::cout << y << ' ';
        }
        std::cout << '\n';
    }
}
```

実行結果：

```
1 10
2 20
```


## <a name="difference-cpp11-range-for" href="#difference-cpp11-range-for">C++11 範囲for文との違い</a>

C++11から、`BOOST_FOREACH`マクロ相当の言語機能である「範囲`for`文(range-based for statement)」が導入された。この2つには、大きく以下の差異がある：

1. `BOOST_FOREACH`マクロは、イテレータの組(`std::pair<begin-iter, end-iter>`)をサポートしている。
2. 範囲`for`文は、要素の変数を、範囲`for`文で定義しなければならない。

以下に、その詳細を記載する。


**1. イテレータの組**

`BOOST_FOREACH`マクロは、イテレータの組をループ対象にできる。

C++11 範囲`for`文は、ループ対象の型が`begin()`/`end()`メンバ関数、もしくは`begin()`/end()非メンバ関数を持っている必要がある。

```cpp
#include <iostream>
#include <vector>
#include <utility>
#include <boost/foreach.hpp>

int main()
{
    const std::vector<int> v = {3, 1, 4};

    // pairのfirstを先頭イテレータ、secondを終端イテレータと見なす
    const auto range = std::make_pair(v.cbegin(), v.cend());

    BOOST_FOREACH (int x, range) {
        std::cout << x << std::endl;
    }
}
```

実行結果：

```
3
1
4
```


**2. 範囲`for`文は、要素の変数を、範囲`for`文で定義しなければならない。**

範囲`for`文の構文規則は、以下のようになっている：

```
for ( for-range-declaration : expression ) statement
```

`for-range-declaration`の部分が、要素の変数宣言を要求している。そのため、以下のようなコードは書けない：

```cpp
std::vector<int> v;

int x;
for (x : v) {} // コンパイルエラー：変数xは範囲for文で定義しなければならない

// 正しいコード：
for (int x : v) {}
```

`BOOST_FOREACH`マクロには、このような制限はないため、定義済みの変数を要素として使用できる。

