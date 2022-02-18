# 無効値の統一的な表現
関数が失敗した場合に返される値が、`-1`だったり`NULL`だったり`false`だったりその他の特別な値だったり、ライブラリによって、または型によってバラバラである。[Boost Optional Library](http://www.boost.org/libs/optional/)では、無効値を統一的に表現するための`boost::optional`型を提供する。


## インデックス
- [関数の失敗値と成功値](#fail-value)
- [無効値がありえることを仕様ではなく型で示す](#type-as-nullary-value)
- [`if`文の条件式で定義した変数に格納する](#store-value-in-if-expr)


## <a id="fail-value" href="#fail-value">関数の失敗値と成功値</a>
Boost.Optionalの基本的な使い道は、関数の失敗値を表現することである。

検索の関数を考えてみよう。よくあるのは、該当要素が見つかったときに要素を指すポインタを返し、見つからなかった場合は`NULL`ポインタを返すといったものだ。

```cpp example
#include <vector>
#include <boost/assign/list_of.hpp>

int* find_value(std::vector<int>& v, int value)
{
    for (std::size_t i = 0; i < v.size(); ++i) {
        if (v[i] == value)
            return &v[i];
    }
    return NULL;
}

int main()
{
    std::vector<int> v = boost::assign::list_of(1)(2)(3);

    int* p = find_value(v, 3);
    if (p) {
        std::cout << *p << std::endl;
    }
    else {
        std::cout << "該当なし" << std::endl;
    }
}
```

実行結果：
```
3
```

これは、Boost.Optionalを使用すると以下のように書くことができる。

```cpp example
#include <vector>
#include <boost/assign/list_of.hpp>
#include <boost/optional.hpp>

boost::optional<int&> find_value(std::vector<int>& v, int value)
{
    for (std::size_t i = 0; i < v.size(); ++i) {
        if (v[i] == value)
            return v[i];
    }
    return boost::none;
}

int main()
{
    std::vector<int> v = boost::assign::list_of(1)(2)(3);

    boost::optional<int&> p = find_value(v, 3);
    if (p) {
        std::cout << p.get() << std::endl;
    }
    else {
        std::cout << "該当なし" << std::endl;
    }
}
```

実行結果：
```
3
```

このケースは単なるポインタの置き換えだが、`boost::optional`はその他あらゆるケースで無効値を表現するのに使用できる。


### <a id="type-as-nullary-value" href="#type-as-nullary-value">無効値がありえることを仕様ではなく型で示す</a>
例として、本の見た目を模倣する電子書籍ビューアを考えよう。

画面には、2ページを見開き表示するが、そのデータが偶数ページ数あるとは限らず、最終ページは見開きではなく左1ページしか表示しないかもしれない。また、ページめくりの方向によっては、右ページのみ表示する場合もある。

そのような状況で、`boost::optional<int>`を使用して、有効なページを指しているかどうかを管理できる。

```cpp
#include <vector>
#include <boost/optional.hpp>

class Viewer {
    std::vector<Page> pages_;
    boost::optional<int> left_page_; // 左に表示するページ番号
    boost::optional<int> right_page_; // 右に表示するページ番号

    void nextPage()
    {
        if (left_page_ && left_page_.get() + 1 < pages.size())
            left_page_ = left_page_.get() + 1;
        else
            left_page_ = boost::none;

        if (right_page_ && right_page_.get() + 1 < pages.size())
            right_page_ = right_page_.get() + 1;
        else
            right_page_ = boost::none;
    }
};
```

`boost::optional`により、「`-1`ページを無効値とする」のようなプログラム仕様ではなく、型によって無効値がありえることを示すことができる。


## <a id="store-value-in-if-expr" href="#store-value-in-if-expr">if文の条件式で定義した変数に格納する</a>
C++の言語仕様では、`if`文の条件式で変数を定義できる。`boost::optional`の変数を`if`文で定義すると便利だ。

```cpp
if (boost::optional<int> p = get_value()) {
    std::cout << p.get() << std::endl;
}
```

こうすることで、`boost::optional`変数の寿命が`if`文のスコープになるので、連続して`optional`値を使用する場合などに、変数名の衝突や、誤って異なる変数を使用してしまう心配がなくなる。

```cpp
if (boost::optional<int> p = get_position()) {
    ...
} // ここでpの寿命が尽きる

// 同名の変数を定義する
if (boost::optional<int> p = get_vector()) {
}
```

