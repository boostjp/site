#関数ポインタと関数オブジェクトを統一的に扱う
[Boost Function Library](http://www.boost.org/doc/libs/release/doc/html/function.html)の`boost::function`クラスは、関数ポインタでも関数オブジェクトでもどちらでも格納、呼び出しができる型である。

##インデックス

- [基本的な使い方](#basic-usage)


## <a name="basic-usage" href="basic-usage">基本的な使い方</a>

`boost::function`型は、テンプレート引数で関数のシグニチャ、すなわち関数の形を指定する。

以下は、`int`と`char`を引数にとり、`double`を返す関数のシグニチャを持つ`boost::function`の型である：

```cpp
boost::function<double(int, char)> f;
```

`boost::function`は、同じシグニチャであれば関数ポインタでも関数オブジェクトでも、どちらでも同じ`boost::function`型の変数に持つことができる。以下に例を示す。一様に扱えていることがわかるだろう。


**関数ポインタを格納して呼び出す**

```cpp
#include <iostream>
#include <boost/function.hpp>

int add(int a, int b)
{
    return a + b;
}

int main()
{
    boost::function<int(int, int)> f = add; // 関数ポインタをboost::functionに格納

    const int result = f(2, 3); // 関数呼び出し
    std::cout << result << std::endl;
}
```

実行結果：

```
5
```


***関数オブジェクトを格納して呼び出す**

```cpp
#include <iostream>
#include <boost/function.hpp>

struct add {
    typedef int result_type;
    int operator()(int a, int b) const
    {
        return a + b;
    }
};

int main()
{
    boost::function<int(int, int)> f = add(); // 関数オブジェクトをboost::functionに格納

    const int result = f(2, 3); // 関数呼び出し
    std::cout << result << std::endl;
}
```

実行結果：

```
5
```

