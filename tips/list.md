#リスト処理の遅延評価
Boost Range LibraryのRangeアダプタは、リスト処理を遅延評価する仕組みを提供する。


Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>条件抽出 - filtered](#TOC---filtered)</li><li class='goog-toc'>[<strong>2 </strong>値の変換 - transformed](#TOC---transformed)</li><li class='goog-toc'>[<strong>3 </strong>型変換 - transformed](#TOC---transformed1)</li><li class='goog-toc'>[<strong>4 </strong>逆順に走査する - reversed](#TOC---reversed)</li><li class='goog-toc'>[<strong>5 </strong>mapのキーのみを抽出する - map_keys](#TOC-map---map_keys)</li><li class='goog-toc'>[<strong>6 </strong>mapの値のみを抽出する - map_values](#TOC-map---map_values)</li><li class='goog-toc'>[<strong>7 </strong>2つのリストを連結する - join](#TOC-2---join)</li><li class='goog-toc'>[<strong>8 </strong>値の範囲を生成する - irange](#TOC---irange)</li><li class='goog-toc'>[<strong>9 </strong>リストに対する複数の遅延処理を合成する](#TOC--)</li></ol>



<h4>条件抽出 - filtered</h4>リストから値の条件抽出をするには、boost::adapotrs::filteredを使用する。
以下は、{1, 2, 3, 4, 5}というリストから、偶数値のみを抽出している。

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


実行結果：
```cpp
2
4


<h4>値の変換 - transformed</h4>リストの全ての要素に関数を適用するには、boost::adaptors::transformedを使用する。
これは、関数型言語一般でのmap関数に相当する。

以下は、リストの全ての要素を+1する処理である。

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

実行結果：
```cpp
2
3
4
5
6


<h4>型変換 - transformed</h4>リストの全ての要素に関数を適用するboost::adaptors::transformedは、型変換にも使用することができる。
以下は、リストの全ての要素をintからstd::stringに変換する処理である。

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

実行結果：
```cpp
1
2
3
4
5


<h4>逆順に走査する - reversed</h4>リストを逆順に走査するには、boost::adaptors::reversedを使用する。

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

実行結果：
```cpp
5
4
3
2
1


<h4>mapのキーのみを抽出する - map_keys</h4>std::map、boost::unordered_map、std::vector<std::pair<Key, Value> >のようなコンテナからキーのみを抽出するには、boost::adaptors::map_keysを使用する。

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

実行結果：
```cpp
1
3
4


<h4>mapの値のみを抽出する - map_values</h4>std::map、boost::unordered_map、std::vector<std::pair<Key, Value> >のようなコンテナから値のみを抽出するには、boost::adaptors::map_valuesを使用する。

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

実行結果：
```cpp
Bob
Alice
Carol


<h4>2つのリストを連結する - join</h4>リストを連結するには、boost::join()関数を使用する。
この関数は、2つのリストを連結した新たな関数を返すのではなく、1つのリストの走査が終わったら2つめのリストを走査するRangeを返す。

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

実行結果：
```cpp
1
2
3
4
5


<h4>値の範囲を生成する - irange</h4>{1..5}のような値の範囲を生成する場合には、boost::irange()関数を使用する。
この関数に値の範囲を引数として渡すことで、その値の範囲を走査可能なRandom Access Rangeを返す。

```cpp
#include <iostream>
#include <boost/range/irange.hpp>
#include <boost/range/algorithm/for_each.hpp>

void disp(int x) { std::cout << x << std::endl; }

int main()
{
    boost::for_each(boost::irange(1, 5), disp);
}

実行結果：
```cpp
1
2
3
4


また、irangeには、値を進めるステップ値も指定することができる。
これを指定することで、「値を2ずつ進める」といったことが可能になる。

```cpp
#include <iostream>
#include <boost/range/irange.hpp>
#include <boost/range/algorithm/for_each.hpp>

void disp(int x) { std::cout << x << std::endl; }

int main()
{
    boost::for_each(boost::irange(1, 10, 2), disp);
}

実行結果：
```cpp
1
3
5
7


<h4>リストに対する複数の遅延処理を合成する</h4>Boost Range LibraryのRangeアダプタは、個々の処理を遅延評価するだけでなく、operator|()でさらに繋ぎ、それらの処理を合成することができる。
以下は、条件抽出(filtered)と関数適用(transformed)を合成する処理である。リストが実際に走査されそれらの処理が必要になるまで評価が遅延される。

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

実行結果：
```cpp
3
5

```
