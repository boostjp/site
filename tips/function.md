#関数ポインタと関数オブジェクトを統一的に扱う
Boost Function Libraryのboost::functionクラスは、関数ポインタでも関数オブジェクトでもどちらでも格納、呼び出しができる型である。

Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>基本的な使い方](#TOC--)</li></ol>



<h4>基本的な使い方</h4>boost::function型は、テンプレート引数で関数のシグニチャ、すなわち関数の形を指定する。
以下は、intとcharを引数にとり、doubleを返す関数のシグニチャを持つboost::functionの型である：

```cpp
boost::function<double(int, char)> f;
```

boost::functionは、同じシグニチャであれば関数ポインタでも関数オブジェクトでも、どちらでも同じboost::function型の変数に持つことができる。以下に例を示す。一様に扱えていることがわかるだろう。

<b>関数ポインタを格納して呼び出す</b>

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
```cpp
5


<b>関数オブジェクトを格納して呼び出す</b>

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


実行結果：
```cpp
5

```
