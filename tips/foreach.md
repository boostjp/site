#for each文
Boost Foreach Libraryは、C++においてシーケンスをループするためのfor each文をライブラリで提供する。



Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>BOOST_FOREACHマクロ](#TOC-BOOST_FOREACH-)</li><li class='goog-toc'>[<strong>2 </strong>要素を参照する](#TOC--)</li><li class='goog-toc'>[<strong>3 </strong>標準ライブラリのコンテナに対して使用する](#TOC--1)</li><li class='goog-toc'>[<strong>4 </strong>std::mapに対して使用する](#TOC-std::map-)</li><li class='goog-toc'>[<strong>5 </strong>逆順にループする](#TOC--2)</li><li class='goog-toc'>[<strong>6 </strong>配列の配列に対して使用する](#TOC--3)</li></ol>



<h4>BOOST_FOREACHマクロ</h4>

for each文には、BOOST_FOREACHというマクロを使用する。

BOOST_FOREACHを使用することで、シーケンスの各要素が順番にループ変数に格納され、処理される。



```cpp
#include <iostream>

#include <boost/foreach.hpp>
```

`int main()`

`{`

`    const int ar[] = {3, 1, 4};`


`    BOOST_FOREACH (int x, ar) {`

`        std::cout << x << std::endl;`

`    }`

`}`




実行結果：

```cpp
3

1

4
```

<h4>要素を参照する</h4>
BOOST_FOREACHマクロは、シーケンスの各要素を参照し、書き換えることができる。



```cpp
#include <iostream>

#include <boost/foreach.hpp>
```

`int main()`

`{`

`    int ar[] = {3, 1, 4};`


`    BOOST_FOREACH (int& x, ar) {`

`        ++x; // 要素を書き換える`

`    }`


`    BOOST_FOREACH (int x, ar) {`

`        std::cout << x << std::endl;`

`    }`

`}`




実行結果：

```cpp
4

2

5


```

<h4>標準ライブラリのコンテナに対して使用する</h4>
BOOST_FOREACHマクロは、組み込み配列だけではなく、std::vectorやstd::list、std::mapといった標準ライブラリのコンテナを処理することができる。



```cpp
#include <iostream>

#include <vector>

#include <boost/assign/list_of.hpp>

#include <boost/foreach.hpp>
```

`int main()`

`{`

`    const std::vector<int> v = boost::assign::list_of(3)(1)(4);`


`    BOOST_FOREACH (int x, v) { // std::vectorをループする`

`        std::cout << x << std::endl;`

`    }`

`}`




実行結果：

```cpp
3

1

4


```

<h4>std::mapに対して使用する</h4>
BOOST_FOREACHマクロでstd::mapを処理するには、少し工夫が必要になる。

BOOST_FOREACHマクロの第1引数には、std::mapの要素型であるstd::pairを直接書きたいところではあるが、言語仕様の制限により、マクロの引数の中でカンマを使用することができない。

そこで、要素型は事前にtypedefしておく必要がある。



```cpp
#include <iostream>

#include <map>

#include <string>

#include <boost/foreach.hpp>
```

`int main()`

`{`

`    std::map<int, std::string> m;`

`    m[3] = "a";`

`    m[1] = "b";`

`    m[4] = "c";`


`    typedef std::map<int, std::string>::const_reference type;`

`    BOOST_FOREACH (type x, m) {`

`        std::cout << x.first << ',' << x.second << std::endl;`

`    }`

`}`




実行結果：

```cpp
1,b

3,a

4,c
```

しかし多くの場合、std::mapをループする際には、キーか値、どちらかがとれれば十分である。

その場合は、Boost Range Libraryのboost::adaptors::map_keysを使用してキーのみを抽出、boost::adaptors::map_valuesを使用して値のみを抽出することができる。



```cpp
#include <iostream>

#include <map>

#include <string>

#include <boost/range/adaptor/map.hpp>

#include <boost/foreach.hpp>
```

`int main()`

`{`

`    std::map<int, std::string> m;`

`    m[3] = "a";`

`    m[1] = "b";`

`    m[4] = "c";`


`    // キーのみを抽出`

`    BOOST_FOREACH (int key, m | boost::adaptors::map_keys) {`

`        std::cout << key << ' ';`

`    }`

`    std::cout << std::endl;`


`    // 値のみを抽出`

`    BOOST_FOREACH (const std::string& value, m | boost::adaptors::map_values) {`

`        std::cout << value << ' ';`

`    }`

`}`




実行結果：

```cpp
1 3 4

b a c
```

<h4>逆順にループする</h4>
逆順にループするには、BOOST_REVERSE_FOREACHマクロを使用するか、もしくはシーケンスに対してBoost Range Libraryのboost::adaptors::reversedを適用する。


BOOST_REVERSE_FOREACHマクロを使用する場合：

```cpp
#include <iostream>

#include <vector>

#include <boost/assign/list_of.hpp>

#include <boost/foreach.hpp>
```

`int main()`

`{`

`    const std::vector<int> v = boost::assign::list_of(3)(1)(4);`


`    BOOST_REVERSE_FOREACH (int x, v) {`

`        std::cout << x << std::endl;`

`    }`

`}`



実行結果：


```cpp
4

1

3
```

boost::adaptors::reversedを使用する場合：


```cpp
#include <iostream>

#include <vector>

#include <boost/assign/list_of.hpp>

#include <boost/range/adaptor/reversed.hpp>

#include <boost/foreach.hpp>
```

`int main()`

`{`

`    const std::vector<int> v = boost::assign::list_of(3)(1)(4);`


`    BOOST_FOREACH (int x, v | boost::adaptors::reversed) {`

`        std::cout << x << std::endl;`

`    }`

`}`




実行結果：


```cpp
4

1

3
```

<h4>配列の配列に対して使用する</h4>
多次元配列のような「シーケンスのシーケンス」に対しては、BOOST_FOREACHを重ねて使用することで対処できる。


言語組込の配列を使用する場合：

```cpp
#include <iostream>

#include <boost/foreach.hpp>
```

`int main()`

`{`

`    typedef int int_a2[2];`

`    const int_a2 a[2] = {`

`        {1, 2},`

`        {3, 4},`

`    };`


`    BOOST_FOREACH(const int_a2 &x, a)`

`    {`

`        BOOST_FOREACH(int y, x)`

`        {`

`            std::cout << y << ' ';`

`        }`

`        std::cout << std::endl;`

`    }`

`}`


「配列への参照型」の記法は直感的でないため、typedefを用いている。



実行結果：

```cpp
1 2

3 4
```

std::vectorを使用する場合：

```cpp
#include <iostream>

#include <vector>

#include <boost/foreach.hpp>

#include <boost/assign/list_of.hpp>
```

`int main()`

`{`

`    std::vector<std::vector<int> > v;`

`    v.push_back(boost::assign::list_of(1)(10));`

`    v.push_back(boost::assign::list_of(2)(20));`


`    BOOST_FOREACH(std::vector<int> const &x, v)`

`    {`

`        BOOST_FOREACH(int y, x)`

`        {`

`            std::cout << y << ' ';`

`        }`

`        std::cout << '\n';`

`    }`

`}`




実行結果：

```cpp
1 10

2 20
```
