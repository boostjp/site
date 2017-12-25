# イテレータを作る
[Boost Iterator Library](http://www.boost.org/doc/libs/release/libs/iterator/doc/index.html)を用いると、イテレータをより楽に作成できる。

## インデックス
- [イテレータを作成する（`iterator_facade`）](#iterator_facade)
- [イテレータの種類と要求されるメンバ関数](#variation)
- [より楽にイテレータを作成する（`iterator_adaptor`）](#iterator_adaptor)


## <a id="iterator_facade" href="#iterator_facade">イテレータの作成（iterator_facade）</a>
`boost::iterator_facade`はイテレータを作成するためのクラステンプレートである。

このクラスを継承して必要な関数を書くと`typedef`や演算子が自動的に定義される。`boost::iterator_facede`のテンプレート引数には順に以下のようにとる。`=boost::use_default`の引数はデフォルトで`boost::use_default`が指定されていることを示す。

```cpp
namespace boost {

  template <
      class Derived
    , class Value
    , class CategoryOrTraversal
    , class Reference  = Value&
    , class Difference = ptrdiff_t
  >
  class iterator_facade;

}
```

| 引数番号 | パラメータ名          | 説明 |
|----------|-----------------------|------|
| 1        | `Derived`             | `iterator_facede`を継承するクラスの名前 |
| 2        | `Value`               | イテレータの`value_type`となる型 |
| 3        | `CategoryOrTraversal` | イテレータの種類を示すタグ |
| 4        | `Reference`           | イテレートするための変数の参照型（省略可。デフォルトは`Value&`） |
| 5        | `Difference`          | イテレータ間の距離を示すための型（省略可。デフォルトは`ptrdiff_t`） |

また、`iterator_facade`クラスを継承して定義するクラスには、`boost::iterator_core_access`を`friend`クラスにして、指定したイテレータの種類によって要求されている関数を定義する必要がある。

例：
```cpp example
#include <iostream>
#include <algorithm>
#include <boost/iterator/iterator_facade.hpp>
#include <boost/shared_ptr.hpp>

// よくある単方向リストがあったとする
struct my_list_node
{
    int data;
    boost::shared_ptr<my_list_node> next;
};

typedef boost::shared_ptr<my_list_node> my_list;

// 0から100までの値が入った単方向リストを作る
my_list create_list()
{
    my_list root( new my_list_node );
    root->data = 0;

    my_list p = root;
    for( int i = 1; i <= 100; ++i ) {
        p->next = my_list( new my_list_node );
        p->next->data = i;
        p = p->next;
    }

    return root;
}

// my_list用のイテレータを作る
class my_list_iterator :
    public boost::iterator_facade<
        my_list_iterator, 
        int,
        boost::forward_traversal_tag>
{
    boost::shared_ptr<my_list_node> p_;

public:
    my_list_iterator()
    { }

    explicit my_list_iterator(boost::shared_ptr<my_list_node> p) :
        p_( p )
    { }

private:
    friend class boost::iterator_core_access;

    void increment() { p_ = p_->next; }
    int& dereference() const { return p_->data; }
    bool equal(const my_list_iterator& other) const { return p_ == other.p_; }
};

my_list_iterator begin(my_list& p)
{
    return my_list_iterator( p );
}

my_list_iterator end(my_list&)
{
    return my_list_iterator();
}


void print(int value)
{
    std::cout << value << " ";
}

int main()
{
    my_list root = create_list();
    
    // よくあるイテレータを使ったループ
    for( my_list_iterator itr = begin( root ); itr != end( root ); ++itr ) {
        std::cout << *itr << " ";
    }
    std::cout << std::endl;

    // もちろんアルゴリズムにも適用可能
    std::for_each( begin( root ), end( root ), &print );
    std::cout << std::endl;
}
```
* #include <boost/iterator/iterator_facade.hpp>[color ff0000]
* // my_list用のイテレータを作る[color ff0000]
* boost::iterator_facade[color ff0000]
* boost::forward_traversal_tag[color ff0000]
* friend class boost::iterator_core_access[color ff0000]
* increment[color ff0000]
* dereference[color ff0000]
* equal[color ff0000]
* // よくあるイテレータを使ったループ[color ff0000]
* // もちろんアルゴリズムにも適用可能[color ff0000]


## <a id="variation" href="#variation">イテレータの種類と要求されるメンバ関数</a>
**イテレータの種類とそのイテレータで要求されるメンバ関数の一覧**

| タグ／関数                    | `dereference` | `equal` | `increment` | `decrement` | `advance` | `distance_to` |
|-------------------------------|:-------------:|:-------:|:-----------:|:-----------:|:---------:|:-------------:|
| `incrementable_traversal_tag` | ○            |         | ○          |             |           |               |
| `single_pass_traversal_tag`   | ○            | ○      | ○          |             |           |               |
| `forward_traversal_tag`       | ○            | ○      | ○          |             |           |               |
| `bidirectional_traversal_tag` | ○            | ○      | ○          | ○          |           |               |
| `random_access_traversal_tag` | ○            | ○      | ○          | ○          | ○        | ○            |

Forward Traversal Iterators（`forward_traversal_tag`で表されるイテレータ）はSingle Pass Iterators（`single_pass_traversal_tag`で表されるイテレータ）の要求に加えて、イテレータについてデフォルトコンストラクタが要求される。


## <a id="iterator_adaptor" href="#iterator_adaptor">より楽にイテレータを作成する（iterator_adaptor）</a>
`boost::iterator_facade`では、要求される関数を自分で定義しなければならない。`boost::iterator_facade`は柔軟ではあるが、決まったパターンを書くのは面倒である。例えば、既存のイテレータやポインタを用いてイテレータを作成する場合はイテレータやポインタを変数と要求される関数をいちいち書かなければならないことがそれに当たるだろう。そこで、`boost::iterator_adaptor`を使えば、あらかじめ既存のイテレータやポインタを変数に持っており要求される関数が定義されているイテレータのクラスを作ることができる。

端的に言えば、`boost::iterator_adaptor`は`boost::iterator_facade`を継承しており、イテレートするための変数と要求する関数が定義されているクラスである。

`boost::iterator_adaptor`のテンプレート引数は以下のようにとる。

| 引数番号 | パラメータ名 | 説明 |
|----------|--------------|-------|
| 1        | `Derived`    | `iterator_adaptor`を継承するクラスの名前   |
| 2        | `Base`       | イテレートするための変数の型               |
| 3        | `Value`      | イテレータの`value_type`となる型<br/>（省略可。デフォルトは`iterator_traits<Base>::value_type`） |
| 4        | `CategoryOrTraversal` | イテレータの種類を示すタグ<br/>（省略可。デフォルトは`iterator_traversal<Base>::type`) |
| 5        | `Reference`           | イテレートするための変数の参照型<br/>（省略可。`Value`も省略した場合のデフォルトは`iterator_traits<Base>::reference`。`Value`が指定されている場合のデフォルトは`Value&`)
| 6        | `Difference`          | イテレータ間の距離を示すための型<br/>（省略可。デフォルトは`iterator_traits<Base>::difference`） |


イテレートするための変数を間接参照した型がイテレータの`value_type`となる型と一致する場合は、`Value`にデフォルトが使うことできる。例えば、イテレートするための変数の型が`int*`で、間接参照した型が`int`の場合がそれにあたる。また、イテレートするための変数が既存のイテレータやポインタの場合、イテレータの種類を示すタグをデフォルトにできる。

`boost::iterator_adaptor`では、`increment()`メンバ関数や`decrement()`メンバ関数などの要求されるメンバ関数があらかじめ定義されているが、`boost::iterator_core_access`を`friend`クラスにして`increment()`メンバ関数などの要求されるメンバ関数を書くことによって動作をカスタマイズできる。また、このとき`boost::iterator_adaptor`の`protected`メンバである`base()`関数や`base_reference()`関数を使うことで指定した既存のイテレータやポインタなどのオブジェクトにアクセスして操作できる。


例：
```cpp example
#include <iostream>
#include <algorithm>
#include <boost/iterator_adaptors.hpp>

class container
{
    int values_[100];

public:
    struct iterator :
        public boost::iterator_adaptor<iterator, int *>
    {
        iterator(int *p) :
            iterator::iterator_adaptor_( p )
        { }
    };

    container()
    {
        for( int i = 0; i < 100; ++i ) {
            values_[i] = i;
        }
    }

    iterator begin()
    { return iterator( values_ ); }

    iterator end()
    { return iterator( values_ + 100 ); }
};

int main()
{
    container c;
    for( container::iterator itr = c.begin(); itr != c.end(); ++itr ) {
        std::cout << *itr << " ";
    }
    std::cout << std::endl;
}
```
* #include <boost/iterator_adaptors.hpp>[color ff0000]
* boost::iterator_adaptor<iterator, int *>[color ff0000]
* iterator_adaptor_[color ff0000]

