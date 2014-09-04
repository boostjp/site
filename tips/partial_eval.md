#カリー化／部分適用
カリー化と部分適用は、Boost Bind LibraryとBoost Function Libraryを組み合わせることで表現できる。

Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>部分適用(partial application)](#TOC-partial-application-)</li><li class='goog-toc'>[<strong>2 </strong>カリー化(currying)+適用(applying)](#TOC-currying-applying-)</li><li class='goog-toc'>[<strong>3 </strong>メンバ関数のレシーバを部分適用する](#TOC--)</li></ol>



<h4>部分適用(partial application)</h4>boost::bind()関数で、あとから指定したい引数に、プレースホルダーと呼ばれる値を指定することで、関数の一部の引数を先に渡しておき、残りをあとから指定して呼び出す、ということができる。

```cpp
#include <iostream>
#include <boost/function.hpp>
#include <boost/bind.hpp>

int add(int a, int b, int c)
{
    return a + b + c;
}

int main()
{
    // 第1引数のみを先に渡す
    boost::function<int(int, int)> f = boost::bind(add, 2, _1, _2);

    // 残りの引数を渡して関数を呼び出す
    const int result = f(3, 4);

    std::cout << result << std::endl;
}


実行結果：
```cpp
9

_1の指定は、「boost::bind()によって返された関数オブジェクトの第1引数を使用する」ということを意味する。
この場合、boost::bind()によって返された関数オブジェクトの第1引数3を、add()関数の_1を指定した位置である第2引数として使用している。
```

<h4>カリー化(currying)+適用(applying)</h4>カリー化は、boost::bind()を使用して、第1引数のみを部分適用し、第2引数をプレースホルダーにすることで疑似的に表現できる。
カリー化のみを行う関数は用意されていないので、自分で作る必要がある(参考: http://ideone.com/qtXeA )。

```cpp
#include <iostream>
#include <boost/function.hpp>
#include <boost/bind.hpp>

int add(int a, int b)
{
    return a + b;
}

int main()
{
    // add関数の第1引数に2が渡される関数オブジェクトを返し、
    // その関数オブジェクトにさらに引数を渡して最終結果を得る。
    const int result = boost::bind(add, 2, _1)(3);

    std::cout << result << std::endl;
}


実行結果：
```cpp
5


<h4>メンバ関数のレシーバを部分適用する</h4>boost::bind()は、メンバ関数ポインタも扱うことができる。
その場合、第1引数にメンバ関数ポインタ、第2引数にメンバ関数のレシーバ(そのメンバ関数を持つオブジェクト)、残りの引数としてメンバ関数の引数を指定する。

レシーバを部分適用することで、その返される関数オブジェクトを保持するクラスに、レシーバーのクラスへの依存関係を持たせることのない設計が可能となる。

```cpp
#include <iostream>
#include <boost/function.hpp>
#include <boost/bind.hpp>

class A {
    boost::function<void()> f_; // Bクラスには依存しない
public:
    void set_func(boost::function<void()> f)
    {
        f_ = f;
    }

    void invoke()
    {
        f_(); // B::print()を呼び出し
    }
};

class B {
public:
    void print() const
    {
        std::cout << "B::print()" << std::endl;
    }
};

int main()
{
    A a;
    B b;

    // B::print()関数のレシーバを部分評価して他のクラスに渡す
    a.set_func(boost::bind(&B::print, &b));

    // 呼び出し
    a.invoke();
}


実行結果：
```cpp
B::print()

```
