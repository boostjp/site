#優先順位を付けて並べ替える
ここでは、優先順位を付きのオブジェクト比較と、それによる並べ替えの方法を示す。優先順位付きの比較とは、Windowsのエクスプローラで言うところの「ファイル種別順に並べて、同じファイル種別のものはファイル名順に並べる」というようなものである。
このような比較方法は、一覧画面のようなものを作る場合に必要となる。

優先順位付きの比較には、[Boost Fusion Library](http://www.boost.org/doc/libs/release/libs/fusion/doc/html/)が提供するタプル型を使用する。タプルとは、異なる複数の型からなるシーケンスである。[`std::pair`](http://cpprefjp.github.io/reference/utility/pair.html)が2つの異なる型のオブジェクトを格納するのに対して、タプルは任意個のオブジェクトを格納できる。

[Boost.Fusion](http://www.boost.org/doc/libs/release/libs/fusion/doc/html/)が提供するタプルは比較演算子を持っており、それがちょうど前述した「ファイル種別順に並べて、同じファイル種別のものはファイル名順に並べる」という意味論での比較を行う。

クラスのメンバ変数をタプルに変換することにより、優先順位付きの比較が可能となる。

以下がその例である：
```cpp
#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

#include <boost/fusion/include/comparison.hpp>
#include <boost/fusion/include/vector_tie.hpp>

struct File {
    std::string type;
    std::string name;

    File(const std::string& type, const std::string& name)
        : type(type), name(name) {}
};

bool operator<(const File& a, const File& b)
{
    // ファイル種別、ファイル名の順番で優先順位を付けて比較
    namespace fusion = boost::fusion;
    return fusion::vector_tie(a.type, a.name) < fusion::vector_tie(b.type, b.name);
}

int main()
{
    std::vector<File> files = {
        {"text", "b.txt"},
        {"application", "b.exe"},
        {"application", "a.exe"},
        {"text", "a.txt"}
    };

    // 並べ替え
    std::sort(files.begin(), files.end());

    for (const File& file : files) {
        std::cout << file.type << ", " << file.name << std::endl;
    }
}
```
* vector_tie[color ff0000]

出力：
```
application, a.exe
application, b.exe
text, a.txt
text, b.txt
```

ファイルが、ファイル種別順に並んだ上で、種別が同じファイルは名前で並べ替えられていることがわかるだろう。

このプログラムでは、`File`クラスの`operator<()`演算子において「ファイル種別でどちらが小さいかを比較し、同じであればファイル名がどちらが小さいかを比較する」という優先順位付き比較を行なっている。

[`boost::fusion::vector_tie()`](http://www.boost.org/doc/libs/release/libs/fusion/doc/html/fusion/container/generation/functions/vector_tie.html)関数は、引数として受け取った変数への参照から、参照のタプル型を構築する。ここでは、[`boost::fusion::vector`](http://www.boost.org/doc/libs/release/libs/fusion/doc/html/fusion/container/vector.html)`<const std::string&, const std::string&>`という型のタプルオブジェクトを構築する。

Boost.Fusionが提供するタプル型に対する比較演算子は、[`<boost/fusion/include/comparison.hpp>`](http://www.boost.org/doc/libs/release/libs/fusion/doc/html/fusion/sequence/operator/comparison.html)ヘッダで定義されている。


**参照：**

- [`std::lexicographical_compare()` - cpprefjp](http://cpprefjp.github.io/reference/algorithm/lexicographical_compare.html)

