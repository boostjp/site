#タプル
タプルの操作には、[Boost Fusion Library](http://www.boost.org/doc/libs/release/libs/fusion/doc/html/)を使用する。


##インデックス
- [基本的な使い方](#basic-usage)
- [タプルを作成するヘルパ関数](#helper-function)
- [N番目の要素を取得する](#nth-element)
- [全ての要素に関数を適用する](#for-each)
- [ユーザー定義型をタプルとして扱う](#user-defined-type-as-tuple)
- [要素をまとめて取り出す](#tie)


## <a name="basic-usage" href="basic-usage">基本的な使い方</a>
Boost.Fusionにおけるタプル型には、`boost::fusion::vector<T...>`を使用する。

各要素を取り出すには、`boost::fusion::at_c<N>()`非メンバ関数を使用する。

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
```

実行結果：
```
1
a
Hello
```


## <a name="helper-function" href="helper-function">タプルを作成するヘルパ関数</a>
`boost::fusion::vector`型を作成するヘルパ関数として、`boost::fusion::make_vector()`関数が定義されている。

この関数を使用するには、`<boost/fusion/include/make_vector.hpp>`をインクルードする。

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
```

実行結果：
```
1
a
Hello
```


## <a name="nth-element" href="nth-element">N番目の要素を取得する</a>
N番目の要素を取得するには、`boost::fusion::at_c<N>()`非メンバ関数を使用する。`N`はコンパイル時に決定する定数である。

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
```

実行結果：
```
1
a
Hello
```


<a name="for-each" href="for-each">全ての要素に関数を適用する</a>
タプルの要素全てに関数を適用するには、`boost::fusion::for_each()`アルゴリズムを使用する。

要素に適用する関数には、毎回異なる型が渡されるため、多相的である必要がある(テンプレート、もしくはタプルに含まれる全ての型に対するオーバーロード)。

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
```

実行結果：
```
1
a
Hello
```

`fusion::for_each()`には、Boost.Lambdaを使用することもできる。

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
```

実行結果：
```
1
a
Hello
```

## <a name="user-defined-type-as-tuple" href="user-defined-type-as-tuple">ユーザー定義型をタプルとして扱う</a>
ユーザー定義型は、`BOOST_FUSION_ADAPT_STRUCT`マクロを適用することで、Boost.Fusionのシーケンスとして登録することができ、その後、そのユーザー定義型はBoost.Fusionで扱えるタプルとして見なされるようになる。

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

    // メンバ変数を列挙する
    fusion::for_each(person, disper());
}
```

実行結果：
```
3
Alice
18
```


## <a name="tie" href="tie">要素をまとめて取り出す</a>
タプルの要素をまとめて取り出すには、`boost::fusion::vector_tie()`関数を使用する。

不要な要素には、`boost::fusion::ignore`変数を指定する。

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

    // 0番目と2番目の要素のみ取り出す
    int n;
    std::string s;
    fusion::vector_tie(n, fusion::ignore, s) = v;

    std::cout << n << std::endl;
    std::cout << s << std::endl;
}
```

実行結果：
```
1
Hello
```

