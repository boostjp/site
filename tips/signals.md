#シグナル／スロット
イベント処理などで使われるシグナル／スロットには、Boost.Signals2ライブラリを使用する。


Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>複数の関数を登録する](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>スロットを切断する](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>戻り値について](#TOC--2)</li><li class='goog-toc'>[<strong>4 </strong>戻り値のカスタム](#TOC--3)</li></ol>



<h4>複数の関数を登録する</h4>Boost.Signals2のシグナルには、connect()関数によって、複数の関数を接続することができる。
シグナルの関数呼び出し演算子によって、接続した関数全てを呼び出すことができる。

```cpp
#include <iostream>
#include <boost/signals2/signal.hpp>
#include <boost/bind.hpp>

struct Point {
    int x, y;
    Point(int x, int y) : x(x), y(y) {}
};

class Button {
public:
    boost::signals2::signal<void(const Point&)> clicked;

    void click()
    {
        clicked(Point(10, 10)); // 呼び出し
    }
};

class MainView {
public:
    void on_clicked(const Point& p)
    {
        std::cout << "MainView : clicked" << std::endl;
    }
};

class SubView {
public:
    void on_clicked(const Point& p)
    {
        std::cout << "SubView : clicked" << std::endl;
    }
};

int main()
{
    MainView mainView;
    SubView subView;

    Button button;

    // クリックイベントの登録
    button.clicked.connect(boost::bind(&MainView::on_clicked, &mainView, _1));
    button.clicked.connect(boost::bind(&SubView::on_clicked, &subView, _1));

    // クリックした
    button.click();
}


実行結果：
```cpp
MainView : clicked
SubView : clicked


<h4>スロットを切断する</h4>スロットを切断するには、connect()関数の戻り値であるコネクションを保持しておき、コネクションのdisconnect()メンバ関数を呼び出すことで、切断する。

```cpp
#include <iostream>
#include <boost/signals2/signal.hpp>
#include <boost/bind.hpp>

struct Point {
    int x, y;
    Point(int x, int y) : x(x), y(y) {}
};

class Button {
public:
    boost::signals2::signal<void(const Point&)> clicked;

    void click()
    {
        clicked(Point(10, 10));
    }
};

class MainView {
public:
    void on_clicked(const Point& p)
    {
        std::cout << "MainView : clicked" << std::endl;
    }
};

class SubView {
public:
    void on_clicked(const Point& p)
    {
        std::cout << "SubView : clicked" << std::endl;
    }
};

int main()
{
    MainView mainView;
    SubView subView;

    Button button;

    // クリックイベントを登録
    button.clicked.connect(boost::bind(&MainView::on_clicked, &mainView, _1));

    boost::signals2::connection con =
        button.clicked.connect(boost::bind(&SubView::on_clicked, &subView, _1));

    // SubViewのスロットを切断
    con.disconnect();

    // クリックした
    button.click();
}


実行結果：
```cpp
MainView : clicked


<h4>戻り値について</h4>
特に指定しなければ、シグナルを呼び出した時の戻り値は接続する関数の戻り値のoptionalとなり、最後に登録した関数の戻り値が戻される。また、関数が接続されていなければ無効値を戻す。optional_last_value参照
```cpp
#include <iostream>
#include <boost/signals2/signal.hpp>

int add(int x, int y)
{
    return x + y;
}

int minus(int x, int y)
{
    return x - y;
}

int multiply(int x, int y)
{
    return x * y;
}

int divide(int x, int y)
{
    return x / y;
}

int main()
{
    boost::signals2::signal<int(int, int)> sig;
    boost::signals2::signal<int(int, int)> non_connect_sig;
    
    sig.connect(&add);
    sig.connect(&minus);
    sig.connect(&multiply);
    sig.connect(&divide);

    // boost::optional<int>が戻ってくる
    std::cout << *sig(10, 2) << std::endl;

    // 無効値
    const boost::optional<int> non_connect_result = non_connect_sig(10, 2);
    if(!non_connect_result) {
        std::cout << "invalid value" << std::endl;
    }
}

実行結果：
```cpp
5
invalid value
```
* optional_last_value[link http://www.boost.org/doc/html/boost/signals2/optional_last_value.html]

<h4>戻り値のカスタム</h4>boost::signals2::signalの2番目のテンプレート引数Combinerを変えることで戻り値のカスタムが可能である。
```cpp
#include <iostream>
#include <numeric>
#include <boost/signals2/signal.hpp>

// 接続された複数の関数の戻り値の合計を戻す
template <typename T>
struct custom_result_value
{
    typedef T result_type;

    template <typename InputIterator>
    result_type operator()(InputIterator first, InputIterator last) const
    {
        if( first == last ) {
            return result_type();
        }
        return std::accumulate(first, last, 0);
    }
};

int add(int x, int y)
{
    return x + y;
}

int minus(int x, int y)
{
    return x - y;
}

int multiply(int x, int y)
{
    return x * y;
}

int divide(int x, int y)
{
    return x / y;
}

int main()
{
    boost::signals2::signal<int(int, int), custom_result_value<int> > sig;
    
    sig.connect(&add);
    sig.connect(&minus);
    sig.connect(&multiply);
    sig.connect(&divide);

    std::cout << sig(10, 2) << std::endl;
}
```
* custom_result_value[color ff0000]
* custom_result_value[color ff0000]

実行結果：
```cpp
45
```
