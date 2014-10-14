#カリー化／部分適用
カリー化と部分適用は、[Boost Bind Library](http://www.boost.org/doc/libs/release/libs/bind/bind.html)と[Boost Function Library](http://www.boost.org/doc/libs/release/doc/html/function.html)を組み合わせることで表現できる。


##インデックス
- [部分適用(partial application)](#partial-application)
- [カリー化(currying)+適用(applying)](#currying)
- [メンバ関数のレシーバを部分適用する](#receiver-partial-application)


## <a name="partial-application" href="partial-application">部分適用(partial application)</a>
`boost::bind()`関数で、あとから指定したい引数に、プレースホルダーと呼ばれる値を指定することで、関数の一部の引数を先に渡しておき、残りをあとから指定して呼び出す、ということができる。

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
```

実行結果：
```
9
```

`_1`の指定は、「`boost::bind()`によって返された関数オブジェクトの第1引数を使用する」ということを意味する。

この場合、`boost::bind()`によって返された関数オブジェクトの第1引数`3`を、`add()`関数の`_1`を指定した位置である第2引数として使用している。


## <a name="currying" href="currying">カリー化(currying)+適用(applying)</a>
カリー化は、`boost::bind()`を使用して、第1引数のみを部分適用し、第2引数をプレースホルダーにすることで疑似的に表現できる。

カリー化のみを行う関数は用意されていないので、自分で作る必要がある(参考: <http://ideone.com/qtXeA> )。

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
```

実行結果：
```
5
```


## <a name="receiver-partial-application" href="receiver-partial-application">メンバ関数のレシーバを部分適用する</a>
`boost::bind()`は、メンバ関数ポインタも扱うことができる。

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
```

実行結果：
```
B::print()
```

