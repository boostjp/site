#オブジェクトにユニークなIDを付ける
COMや分散環境において、オブジェクトにユニークなIDが必要になることがある。Boost Uuid Libraryは、UUID(Universally unique identifier)の型とジェネレータを提供するライブラリである。


Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>ランダムなUUIDを生成する](#TOC-UUID-)</li><li class='goog-toc'>[<strong>2 </strong>UUIDを文字列に変換する](#TOC-UUID-1)</li></ol>



<h4>ランダムなUUIDを生成する</h4>boost::uuids::random_generatorは、ランダムなUUIDを生成する関数オブジェクトである。
random_generatorを使用するには、<boost/uuid/uuid_generators.hpp>をインクルードする。

```cpp
#include <iostream>
#include <boost/uuid/uuid.hpp>
#include <boost/uuid/uuid_io.hpp>
#include <boost/uuid/uuid_generators.hpp> // random_generator

using namespace boost::uuids;

int main()
{
    // ランダムにユニークIDを生成
    const uuid id1 = random_generator()();
    const uuid id2 = random_generator()();

    std::cout << id1 << std::endl;
    std::cout << id2 << std::endl;
}
```

実行結果の例：

```cpp
d3e0fe51-8078-4a9b-a353-2485a47e0ffe
c5bcb847-5750-4388-ae8d-092e239ef2e6



<h4>UUIDを文字列に変換する</h4>boost::uuids::uuid型は、operator<<()出力ストリーム演算子を持っているので、boost::lexical_cast()を使用して文字列に変換することができる。


```cpp
#include <iostream>
#include <string>
#include <boost/uuid/uuid.hpp>
#include <boost/uuid/uuid_io.hpp>
#include <boost/uuid/uuid_generators.hpp>
#include <boost/lexical_cast.hpp>

using namespace boost::uuids;

int main()
{
    // ランダムにユニークIDを生成
    const uuid id = random_generator()();

    // 文字列に変換
    const std::string result = boost::lexical_cast<std::string>(id);

    std::cout << result << std::endl;
}


実行結果の例：
```cpp
7dad652f-fa94-4f9c-a17b-357551438095

```
