#タプル
タプルの操作には、Boost Fusion Libraryを使用する。

Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>概要](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>タプルを作成するヘルパ関数](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>N番目の要素を取得](#TOC-N-)</li><li class='goog-toc'>[<strong>4 </strong>全ての要素に関数を適用する](#TOC--2)</li><li class='goog-toc'>[<strong>5 </strong>ユーザー定義型をタプルとして扱う](#TOC--3)</li><li class='goog-toc'>[<strong>6 </strong>要素をまとめて取り出す](#TOC--4)</li></ol>



<h4>概要</h4>Boost Fusion Libraryにおけるタプル型には、boost::fusion::vector<T...>を使用する。
各要素を取り出すには、boost::fusion::at_c<N>()関数を使用する。


```cpp
#include <iostream>
#include <string>
#include <boost/fusion/include/vector.hpp>
#include <boost/fusion/include/at_c.hpp>

namespace fusion = boost::fusion;

int main()
{
    const fusion::vector<int, char, std::string> v(1, 'a', "Hello");

    std::cout << fusion::at_c<0>(v) << std::endl;
    std::cout << fusion::at_c<1>(v) << std::endl;
    std::cout << fusion::at_c<2>(v) << std::endl;
}


実行結果：

```cpp
1
a
Hello



<h4>タプルを作成するヘルパ関数</h4>boost::fusion::vector型を作成するヘルパ関数、boost::fusion::make_vector()関数を使用する。


```cpp
#include <iostream>
#include <string>
#include <boost/fusion/include/vector.hpp>
#include <boost/fusion/include/make_vector.hpp>
#include <boost/fusion/include/at_c.hpp>

namespace fusion = boost::fusion;

int main()
{
    const fusion::vector<int, char, std::string> v = fusion::make_vector(1, 'a', "Hello");

    std::cout << fusion::at_c<0>(v) << std::endl;
    std::cout << fusion::at_c<1>(v) << std::endl;
    std::cout << fusion::at_c<2>(v) << std::endl;
}


実行結果：
```cpp
1
a
Hello

<h4>N番目の要素を取得</h4>N番目の要素を取得するには、boost::fusion::at_c<N>()関数を使用する。Nはコンパイル時定数である。


```cpp
#include <iostream>
#include <string>
#include <boost/fusion/include/vector.hpp>
#include <boost/fusion/include/at_c.hpp>

namespace fusion = boost::fusion;

int main()
{
    const fusion::vector<int, char, std::string> v(1, 'a', "Hello");

    const int n         = fusion::at_c<0>(v);
    const char c        = fusion::at_c<1>(v);
    const std::string s = fusion::at_c<2>(v);

    std::cout << n << std::endl;
    std::cout << c << std::endl;
    std::cout << s << std::endl;
}


実行結果：
```cpp
1
a
Hello


<h4>全ての要素に関数を適用する</h4>タプルの要素全てに関数を適用するには、boost::fusion::for_each()アルゴリズムを使用する。
要素に適用する関数には、毎回異なる型が渡されるため、多層的である必要がある(テンプレート、もしくは型数分のオーバーロード)。


```cpp
#include <iostream>
#include <string>
#include <boost/fusion/include/vector.hpp>
#include <boost/fusion/include/for_each.hpp>

namespace fusion = boost::fusion;

struct disper {
    template <class T>
    void operator()(const T& x) const
    {
        std::cout << x << std::endl;
    }
};

int main()
{
    const fusion::vector<int, char, std::string> v(1, 'a', "Hello");

    fusion::for_each(v, disper());
}



実行結果：```cpp
1
a
Hello


fusion::for_eachには、Boost.Lambdaを使用することもできる。

```cpp
#include <iostream>
#include <string>
#include <boost/fusion/include/vector.hpp>
#include <boost/fusion/include/for_each.hpp>
#include <boost/lambda/lambda.hpp>

namespace fusion = boost::fusion;
using boost::lambda::_1;

int main()
{
    const fusion::vector<int, char, std::string> v(1, 'a', "Hello");

    fusion::for_each(v, std::cout << _1 << '\n');
}


実行結果：
```cpp
1
a
Hello


<h4>ユーザー定義型をタプルとして扱う</h4>ユーザー定義型は、BOOST_FUSION_ADAPT_STRUCTマクロを適用することで、Boost.Fusionのシーケンスとして登録することができ、その後、そのユーザー定義型はBoost.Fusionで扱えるタプルとして見なされるようになる。


```cpp
#include <iostream>
#include <string>
#include <boost/fusion/include/adapt_struct.hpp>
#include <boost/fusion/include/for_each.hpp>

namespace fusion = boost::fusion;

struct Person {
    int id;
    std::string name;
    int age;

    Person(int id, const std::string& name, int age)
        : id(id), name(name), age(age) {}
};

BOOST_FUSION_ADAPT_STRUCT(
    Person,
    (int, id)
    (std::string, name)
    (int, age)
)

struct disper {
    template <class T>
    void operator()(const T& x) const
    {
        std::cout << x << std::endl;
    }
};

int main()
{
    const Person person(3, "Alice", 18);

    fusion::for_each(person, disper());
}



<h4>要素をまとめて取り出す</h4>タプルの要素をまとめて取り出すには、boost::fusion::vector_tie()を使用する。
不要な要素には、boost::fusion::ignoreを指定する。

以下の例では、タプルvの第1要素と第3要素を取り出し、第2要素を無視している。


```cpp
#include <iostream>
#include <string>
#include <boost/fusion/include/vector.hpp>
#include <boost/fusion/include/vector_tie.hpp>
#include <boost/fusion/include/ignore.hpp>

namespace fusion = boost::fusion;

int main()
{
    const fusion::vector<int, char, std::string> v(1, 'a', "Hello");

    int n;
    std::string s;
    fusion::vector_tie(n, fusion::ignore, s) = v;

    std::cout << n << std::endl;
    std::cout << s << std::endl;
}


実行結果：
```cpp
1
Hello

```
