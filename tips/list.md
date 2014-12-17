#リスト処理の遅延評価
[Boost Range Library](http://www.boost.org/doc/libs/release/libs/range/doc/html/index.html)のRangeアダプタは、リスト処理を遅延評価する仕組みを提供する。

##インデックス
- [条件抽出 - `filtered`](#filter)
- [値の変換 - `transformed`](#transform-value)
- [型変換 - `transformed`](#transform-type)
- [逆順に走査する - `reversed`](#reverse)
- [mapのキーのみを抽出する - `map_keys`](#map-key)
- [mapの値のみを抽出する - `map_values`](#map-value)
- [2つのリストを連結する - `join`](#join)
- [値の範囲を生成する - `irange`](#counting-range)
- [リストに対する複数の遅延処理を合成する](#pipe)


## <a name="filter" href="#filter">条件抽出 - filtered</a>
リストから値の条件抽出をするには、`boost::adapotrs::filtered`を使用する。

以下は、`{1, 2, 3, 4, 5}`というリストから、偶数値のみを抽出している。

```cpp
#include <iostream>
#include <vector>
#include <boost/assign/list_of.hpp>
#include <boost/range/adaptor/filtered.hpp>
#include <boost/range/algorithm/for_each.hpp>

using namespace boost::adaptors;

bool is_even(int x) { return x % 2 == 0; }
void disp(int x) { std::cout << x << std::endl; }

int main()
{
    const std::vector<int> v = boost::assign::list_of(1)(2)(3)(4)(5);

    boost::for_each(v | filtered(is_even), disp);
}
```

実行結果：
```
2
4
```

## <a name="transform-value" href="#transform-value">値の変換 - transformed</a>
リストの全ての要素に関数を適用するには、`boost::adaptors::transformed`を使用する。

これは、関数型言語一般での`map`関数に相当する。

以下は、リストの全ての要素に`1`を加算する処理である。

```cpp
#include <iostream>
#include <vector>
#include <boost/assign/list_of.hpp>
#include <boost/range/adaptor/transformed.hpp>
#include <boost/range/algorithm/for_each.hpp>

using namespace boost::adaptors;

int add(int x) { return x + 1; }
void disp(int x) { std::cout << x << std::endl; }

int main()
{
    const std::vector<int> v = boost::assign::list_of(1)(2)(3)(4)(5);

    boost::for_each(v | transformed(add), disp);
}
```

実行結果：
```
2
3
4
5
6
```


## <a name="transform-type" href="#transform-type">型変換 - transformed</a>
リストの全ての要素に関数を適用する`boost::adaptors::transformed`は、型変換にも使用することができる。

以下は、リストの全ての要素を`int`から`std::string`に変換する処理である。

```cpp
#include <iostream>
#include <vector>
#include <boost/assign/list_of.hpp>
#include <boost/range/adaptor/transformed.hpp>
#include <boost/range/algorithm/for_each.hpp>
#include <boost/lexical_cast.hpp>

using namespace boost::adaptors;

std::string int_to_string(int x) { return boost::lexical_cast<std::string>(x); }

void disp(const std::string& s) { std::cout << s << std::endl; }

int main()
{
    const std::vector<int> v = boost::assign::list_of(1)(2)(3)(4)(5);

    boost::for_each(v | transformed(int_to_string), disp);
}
```

実行結果：
```
1
2
3
4
5
```

## <a name="reverse" href="#reverse">逆順に走査する - reversed</a>
リストを逆順に走査するには、`boost::adaptors::reversed`を使用する。

```cpp
#include <iostream>
#include <vector>
#include <boost/assign/list_of.hpp>
#include <boost/range/adaptor/reversed.hpp>
#include <boost/range/algorithm/for_each.hpp>

using namespace boost::adaptors;

void disp(int x) { std::cout << x << std::endl; }

int main()
{
    const std::vector<int> v = boost::assign::list_of(1)(2)(3)(4)(5);

    boost::for_each(v | reversed, disp);
}
```

実行結果：
```
5
4
3
2
1
```

## <a name="map-key" href="#map-key">mapのキーのみを抽出する - map_keys</a>
`std::map`、`boost::unordered_map`、`std::vector<std::pair<Key, Value> >`のようなコンテナからキーのみを抽出するには、`boost::adaptors::map_keys`を使用する。

```cpp
#include <iostream>
#include <map>
#include <boost/assign/list_of.hpp>
#include <boost/range/adaptor/map.hpp>
#include <boost/range/algorithm/for_each.hpp>

using namespace boost::adaptors;

void disp(int x) { std::cout << x << std::endl; }

int main()
{
    const std::map<int, std::string> m = boost::assign::map_list_of
        (3, "Alice")
        (1, "Bob")
        (4, "Carol")
        ;

    boost::for_each(m | map_keys, disp);
}
```

実行結果：
```
1
3
4
```

## <a name="map-value" href="#map-value">mapの値のみを抽出する - map_values</a>
`std::map`、`boost::unordered_map`、`std::vector<std::pair<Key, Value> >`のようなコンテナから値のみを抽出するには、`boost::adaptors::map_values`を使用する。

```cpp
#include <iostream>
#include <map>
#include <boost/assign/list_of.hpp>
#include <boost/range/adaptor/map.hpp>
#include <boost/range/algorithm/for_each.hpp>

using namespace boost::adaptors;

void disp(const std::string& s) { std::cout << s << std::endl; }

int main()
{
    const std::map<int, std::string> m = boost::assign::map_list_of
        (3, "Alice")
        (1, "Bob")
        (4, "Carol")
        ;

    boost::for_each(m | map_values, disp);
}
```

実行結果：
```
Bob
Alice
Carol
```

## <a name="join" href="#join">2つのリストを連結する - join</a>
リストを連結するには、`boost::join()`関数を使用する。

この関数は、2つのリストを連結した新たなリストを返すのではなく、1つのリストの走査が終わったら2つめのリストを走査するRangeを返す。

```cpp
#include <iostream>
#include <vector>
#include <list>
#include <boost/assign/list_of.hpp>
#include <boost/range/join.hpp>
#include <boost/range/algorithm/for_each.hpp>

void disp(int x) { std::cout << x << std::endl; }

int main()
{
    const std::vector<int> v = boost::assign::list_of(1)(2)(3);
    const std::list<int> ls = boost::assign::list_of(4)(5);

    boost::for_each(boost::join(v, ls), disp);
}
```

実行結果：
```
1
2
3
4
5
```

## <a name="counting-range" href="#counting-range">値の範囲を生成する - irange</a>
`{1..5}`のような連続した値の範囲を生成する場合には、`boost::irange()`関数を使用する。

この関数に値の範囲を引数として渡すことで、その値の範囲を走査可能なRandom Access Rangeを返す。

```cpp
#include <iostream>
#include <boost/range/irange.hpp>
#include <boost/range/algorithm/for_each.hpp>

void disp(int x) { std::cout << x << std::endl; }

int main()
{
    // [1, 5)の範囲を生成する
    boost::for_each(boost::irange(1, 5), disp);
}
```

実行結果：
```
1
2
3
4
```

また、`irange`には、第3引数として、値を進めるステップ値も指定することができる。

これを指定することで、「値を2ずつ進める」といったことが可能になる。

```cpp
#include <iostream>
#include <boost/range/irange.hpp>
#include <boost/range/algorithm/for_each.hpp>

void disp(int x) { std::cout << x << std::endl; }

int main()
{
    // [1, 10)の範囲を、2ずつ進める
    boost::for_each(boost::irange(1, 10, 2), disp);
}
```

実行結果：
```
1
3
5
7
```

## <a name="pipe" href="#pipe">リストに対する複数の遅延処理を合成する</a>
Boost Range LibraryのRangeアダプタは、個々の処理を遅延評価するだけでなく、`operator|()`でさらに繋ぎ、それらの処理を合成できる。

以下は、条件抽出(`filtered`)と関数適用(`transformed`)を合成する処理である。リストが実際に走査されそれらの処理が必要になるまで評価が遅延される。

```cpp
#include <iostream>
#include <vector>
#include <boost/assign/list_of.hpp>
#include <boost/range/adaptor/filtered.hpp>
#include <boost/range/adaptor/transformed.hpp>
#include <boost/range/algorithm/for_each.hpp>

using namespace boost::adaptors;

bool is_even(int x) { return x % 2 == 0; }
int add(int x) { return x + 1; }

void disp(int x) { std::cout << x << std::endl; }

int main()
{
    const std::vector<int> v = boost::assign::list_of(1)(2)(3)(4)(5);

    boost::for_each(v | filtered(is_even) | transformed(add), disp);
}
```

実行結果：
```
3
5
```

