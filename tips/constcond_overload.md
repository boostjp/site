#コンパイル時条件によるオーバーロード

コンパイル時条件によるオーバーロードには、`boost::enable_if`メタ関数、もしくは`boost::mpl::bool_`によるタグディスパッチを使用することができる。

以下は、`std::list`でもその他のコンテナでも同じように使用できるソート関数の例である。`std::list`の場合は`sort()`メンバ関数が呼ばれ、それ以外のコンテナの場合には標準アルゴリズムの`std::sort()`関数が呼ばれる。

また、この方法は、[型特性](type_traits.md)ページにて紹介している型特性メタ関数と組み合わせることもできる。

## `boost::enable_if`を使用する場合

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


// std::list用のオーバーロード
template <class Container>
void sort(Container& c,
        typename boost::enable_if<is_list<Container> >::type* = 0)
{
    c.sort();
}

// std::list以外のためのオーバーロード
template <class Container>
void sort(Container& c,
        typename boost::disable_if<is_list<Container> >::type* = 0)
{
    std::sort(boost::begin(c), boost::end(c));
}

void disp(int x) { std::cout << x << ' '; }

int main()
{
    std::vector<int> v = boost::assign::list_of(3)(1)(2);
    std::list<int> ls = boost::assign::list_of(3)(1)(2);

    sort(v);  // std::sortが呼ばれる
    sort(ls); // std::list::sortが呼ばれる

    boost::for_each(v, disp); std::cout << std::endl;
    boost::for_each(ls, disp);
}
```
* typename boost::enable_if<is_list<Container> >::type* = 0[color ff0000]
* typename boost::disable_if<is_list<Container> >::type* = 0[color ff0000]

実行結果：

```
1 2 3 
1 2 3 
```

`enable_if`には、述語となるメタ関数(`::value`を持つメタ関数)を指定する。`enable_if`の述語が`true`を返す場合にはその関数がオーバーロードされ、そうでない場合はオーバーロードの候補から外れる。

`disable_if`は`enable_if`の逆で、述語メタ関数が`false`を返す場合にその関数がオーバーロードされる。


## `boost::mpl::bool_`によるタグディスパッチを使用する場合

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


// std::list用のオーバーロード
template <class Container>
void sort_impl(Container& c, boost::mpl::true_)
{
    c.sort();
}

// std::list以外のためのオーバーロード
template <class Container>
void sort_impl(Container& c, boost::mpl::false_)
{
    std::sort(boost::begin(c), boost::end(c));
}

template <class Container>
void sort(Container& c)
{
    // std::listかどうかを判定して結果を渡す
    sort_impl(c, typename is_list<Container>::type());
}

void disp(int x) { std::cout << x << ' '; }

int main()
{
    std::vector<int> v = boost::assign::list_of(3)(1)(2);
    std::list<int> ls = boost::assign::list_of(3)(1)(2);

    sort(v);  // std::sortが呼ばれる
    sort(ls); // std::list::sortが呼ばれる

    boost::for_each(v, disp); std::cout << std::endl;
    boost::for_each(ls, disp);
}
```
* boost::mpl::true_[color ff0000]
* boost::mpl::false_[color ff0000]
* typename is_list<Container>::type()[color ff0000]

実行結果：
```
1 2 3 
1 2 3 
```

`is_list`メタ関数は、`boost::mpl::true_`型もしくは`boost::mpl::false_`型を返すので、その型を利用してオーバーロードできる。


