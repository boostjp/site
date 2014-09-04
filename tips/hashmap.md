#ハッシュ表
ハッシュ表には、Boost Unordered Libraryを使用する。
std::mapのハッシュ表バージョンがboost::unordered_map。
std::setのハッシュ表バージョンがboost::unordered_set。


Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>基本的な使い方](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>ユーザー定義型をキーにする(オーバーロード)](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>ユーザー定義型をキーにする(ポリシー)](#TOC--2)</li></ol>



<h4>基本的な使い方</h4>基本操作は、std::setやstd::mapと同様である。
ポリシーを設定しない場合、要求されるテンプレートパラメータは、キーと値の型である。
以下の場合、std::stringをキー、intを値とするハッシュ表を作成している。

```cpp
#include <iostream>
#include <string>
#include <boost/unordered_map.hpp>

int main()
{
    typedef boost::unordered_map<std::string, int> map_type;

    // 要素追加
    map_type m;
    m["a"] = 3;
    m["b"] = 1;
    m["c"] = 4;

    // 検索
    map_type::const_iterator it = m.find("b");
    if (it != m.end()) {
        std::cout << it->second << std::endl;
    }
    else {
        std::cout << "not found" << std::endl;
    }
}
```

実行結果：
```cpp
1


<h4>ユーザー定義型をキーにする(オーバーロード)</h4>ユーザー定義型をキーにするには、その型の等値比較を行う関数と、ハッシュを計算する関数を定義する必要がある。
以下がその簡単な例である。

```cpp
#include <iostream>
#include <string>
#include <boost/unordered_map.hpp>

struct point {
    int x, y;

    point() : x(0), y(0) {}
    point(int x, int y) : x(x), y(y) {}
};

// 等値比較
bool operator==(const point& a, const point& b)
{
    return a.x == b.x && a.y == b.y;
}

// ハッシュの計算
std::size_t hash_value(const point& p)
{
    std::size_t seed = 0;
    boost::hash_combine(seed, p.x);
    boost::hash_combine(seed, p.y);
    return seed;
}

int main()
{
    typedef boost::unordered_map<point, int> map_type;

    map_type m;
    m[point(1, 2)] = 3;
    m[point(4, 5)] = 6;
    m[point(7, 8)] = 9;

    map_type::const_iterator it = m.find(point(4, 5));
    if (it != m.end()) {
        std::cout << it->second << std::endl;
    }
    else {
        std::cout << "not found" << std::endl;
    }
}
```

実行結果：
```cpp
6

```

<h4>ユーザー定義型をキーにする(ポリシー)</h4>ユーザー定義型をキーにする方法として、等値比較の演算子やハッシュを計算する関数がすでに定義されている場合がある。
そういった場合に、別名の等値比較関数、ハッシュ計算関数をテンプレートパラメータで指定することができる。

```cpp
#include <iostream>
#include <string>
#include <boost/unordered_map.hpp>

struct point {
    int x, y;

    point() : x(0), y(0) {}
    point(int x, int y) : x(x), y(y) {}
};

// 等値比較
struct point_equal {
    bool operator()(const point& a, const point& b) const
    {
        return a.x == b.x && a.y == b.y;
    }
};

// ハッシュの計算
struct point_hash {
    typedef std::size_t result_type;

    std::size_t operator()(const point& p) const
    {
        std::size_t seed = 0;
        boost::hash_combine(seed, p.x);
        boost::hash_combine(seed, p.y);
        return seed;
    }
};

int main()
{
    typedef boost::unordered_map<point, int, point_hash, point_equal> map_type;

    map_type m;
    m[point(1, 2)] = 3;
    m[point(4, 5)] = 6;
    m[point(7, 8)] = 9;

    map_type::const_iterator it = m.find(point(4, 5));
    if (it != m.end()) {
        std::cout << it->second << std::endl;
    }
    else {
        std::cout << "not found" << std::endl;
    }
}


実行結果：
```cpp
6

```
