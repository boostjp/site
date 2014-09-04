#コンパイル時条件によるオーバーロード
コンパイル時条件によるオーバーロードには、boost::enable_ifメタ関数、もしくはboost::mpl::bool_によるタグディスパッチを使用することができる。

以下は、std::listでもその他のコンテナでも同じように使用できるソート関数の例である。
std::listの場合はsort()メンバ関数が呼ばれ、それ以外のコンテナの場合には標準アルゴリズムのsort()フリー関数が呼ばれる。

また、この方法は、[型特性](https://sites.google.com/site/boostjp/tips/type_traits)にも適用することができる。

<h4>boost::enable_ifを使用する場合</h4>
```cpp
#include <iostream>
#include <vector>
#include <list>
#include <boost/assign/list_of.hpp>
#include <boost/range/algorithm.hpp>

#include <boost/utility/enable_if.hpp>
#include <boost/mpl/bool.hpp>

template <class Container>
struct is_list : boost::mpl::false_ {};

template <class T, class Alloc>
struct is_list<std::list<T, Alloc> > : boost::mpl::true_ {};
```

`// std::list用のオーバーロード`
`template <class Container>`
`void sort(Container& c,`
`        typename boost::enable_if<is_list<Container> >::type* = 0)`
`{`
`    c.sort();`
`}`

`// std::list以外のためのオーバーロード`
`template <class Container>`
`void sort(Container& c,`
`        typename boost::disable_if<is_list<Container> >::type* = 0)`
`{`
`    std::sort(boost::begin(c), boost::end(c));`
`}`

`void disp(int x) { std::cout << x << ' '; }`

`int main()`
`{`
`    std::vector<int> v = boost::assign::list_of(3)(1)(2);`
`    std::list<int> ls = boost::assign::list_of(3)(1)(2);`

`    sort(v);  // std::sortが呼ばれる`
`    sort(ls); // std::list::sortが呼ばれる`

`    boost::for_each(v, disp); std::cout << std::endl;`
`    boost::for_each(ls, disp);`
`}`

実行結果：
```cpp
1 2 3 
1 2 3 

enable_ifには、述語となるメタ関数(::valueを持つメタ関数)を指定する。
enable_ifの述語がtrueを返す場合にはその関数がオーバーロードされ、そうでない場合はオーバーロードの候補から外れる。
disable_ifはenable_ifの逆で、述語がfalseを返す場合にその関数がオーバーロードされる。
```

<h4>boost::mpl::bool_によるタグディスパッチを使用する場合</h4>
```cpp
#include <iostream>
#include <vector>
#include <list>
#include <boost/assign/list_of.hpp>
#include <boost/range/algorithm.hpp>

#include <boost/mpl/bool.hpp>

template <class Container>
struct is_list : boost::mpl::false_ {};

template <class T, class Alloc>
struct is_list<std::list<T, Alloc> > : boost::mpl::true_ {};
```

`// std::list用のオーバーロード`
`template <class Container>`
`void sort_impl(Container& c, boost::mpl::true_)`
`{`
`    c.sort();`
`}`

`// std::list以外のためのオーバーロード`
`template <class Container>`
`void sort_impl(Container& c, boost::mpl::false_)`
`{`
`    std::sort(boost::begin(c), boost::end(c));`
`}`

`template <class Container>`
`void sort(Container& c)`
`{`
`    // std::listかどうかを判定して結果を渡す`
`    sort_impl(c, typename is_list<Container>::type());`
`}`

`void disp(int x) { std::cout << x << ' '; }`

`int main()`
`{`
`    std::vector<int> v = boost::assign::list_of(3)(1)(2);`
`    std::list<int> ls = boost::assign::list_of(3)(1)(2);`

`    sort(v);  // std::sortが呼ばれる`
`    sort(ls); // std::list::sortが呼ばれる`

`    boost::for_each(v, disp); std::cout << std::endl;`
`    boost::for_each(ls, disp);`
`}`

実行結果：
`1 2 3 `
`1 2 3 `

is_listメタ関数は、boost::mpl::true_型もしくはboost::mpl::false_型を返すので、その型を利用してオーバーロードすることができる。

