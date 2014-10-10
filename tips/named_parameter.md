#名前付き引数
C++において名前付き引数を表現するには、[Boost Parameter Library](http://www.boost.org/doc/libs/release/libs/parameter/doc/html/index.html)を使用する。


##インデックス
- [基本的な使い方](#basic-usage)
- [ラベルを名前空間で定義する](#define-label-in-namespace)


## <a name="basic-usage" href="basic-usage">基本的な使い方</a>
以下が、Boost.Parameterを使用した名前付き引数の例である。

```cpp
#include <iostream>
#include <string>
#include <boost/parameter/name.hpp>

struct Point {
    int x, y;
    Point(int x, int y) : x(x), y(y) {}
};

struct Color {
    int r, g, b;
    Color(int r, int g, int b) : r(r), g(g), b(b) {}
};

BOOST_PARAMETER_NAME(pos)
BOOST_PARAMETER_NAME(color)
BOOST_PARAMETER_NAME(text)

void draw_impl(const Point& p, const Color& c, const std::string& text)
{
    // 描画処理...
    std::cout << "position: " << p.x << ',' << p.y << std::endl;
    std::cout << "color: " << c.r << ',' << c.g << ',' << c.b << std::endl;
    std::cout << "text: " << text << std::endl;
}

template <class ArgPack>
void draw(const ArgPack& args)
{
    draw_impl(args[_pos], args[_color], args[_text]);
}

int main()
{
    draw((_text = "Hello", _color = Color(255, 0, 0), _pos = Point(10, 20)));
}
```

実行結果：
```
position: 10,20
color: 255,0,0
text: Hello
```

名前付き引数を利用するには、まずラベルを定義する必要がある。

```cpp
BOOST_PARAMETER_NAME(label)
```

このようにすると、`_label`という名前のラベルが作成され、名前付き引数の「名前」として使用可能になる。


名前付き引数の指定は、以下のように「ラベル = 値」の形式で記述する。複数の名前付き引数が必要な場合は、全体をカッコで囲む必要がある。

```cpp
f((_label = x, label2 = y));
```


名前付き引数を指定された関数は、まずパラメータをテンプレートで「パラメータパック」という一つの変数として受け取る。
```cpp
template <class ArgPack>
void f(const ArgPack& args);

各ラベルの値を取り出すには、パラメータパックに`operator[]()`でラベルを指定する。

```cpp
const X& x = args[_label];
```


## <a name="define-label-in-namespace" href="define-label-in-namespace">ラベルを名前空間で定義する</a>
Boost.Parameterでは、ラベルをユーザーの名前空間に定義することができる。

以下は、前項で定義したラベルを`ui`名前空間に移した例である：

```cpp
#include <iostream>
#include <string>
#include <boost/parameter/name.hpp>

struct Point {
    int x, y;
    Point(int x, int y) : x(x), y(y) {}
};

struct Color {
    int r, g, b;
    Color(int r, int g, int b) : r(r), g(g), b(b) {}
};

namespace ui {

BOOST_PARAMETER_NAME(pos)
BOOST_PARAMETER_NAME(color)
BOOST_PARAMETER_NAME(text)

} // namespace ui

void draw_impl(const Point& p, const Color& c, const std::string& text)
{
    // 描画処理...
    std::cout << "position: " << p.x << ',' << p.y << std::endl;
    std::cout << "color: " << c.r << ',' << c.g << ',' << c.b << std::endl;
    std::cout << "text: " << text << std::endl;
}

template <class ArgPack>
void draw(const ArgPack& args)
{
    draw_impl(args[ui::_pos], args[ui::_color], args[ui::_text]);
}

int main()
{
    draw((ui::_text = "Hello", ui::_color = Color(255, 0, 0), ui::_pos = Point(10, 20)));
}
```
* namespace ui[color ff0000]

実行結果：
```
position: 10,20
color: 255,0,0
text: Hello
```

