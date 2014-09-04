#コンテナに複数の並び順を持たせる
std::vectorやstd::mapといったコンテナを使用していると、希に「mapとして使いたいけど挿入順も覚えておきたい」といったことや、「mapに、値からキーを検索する機能がほしい」といった要求が出てくることがある。そういった要求を叶えてくれるのが、[Boost Multi-Index Library](http://www.boost.org/libs/multi_index/doc/index.html)である。


Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>boost::multi_index_containerの基本的な使い方 - 挿入順を知っているstd::set](#TOC-boost::multi_index_container---std::set)</li><li class='goog-toc'>[<strong>2 </strong>インデックスの表現を変数に持つ](#TOC--)</li><li class='goog-toc'>[<strong>3 </strong>インデックスに名前を付ける](#TOC--1)</li><li class='goog-toc'>[<strong>4 </strong>インデックスと標準コンテナの対応表](#TOC--2)</li><li class='goog-toc'>[<strong>5 </strong>複数のキーを持つmap](#TOC-map)</li><li class='goog-toc'>[<strong>6 </strong>双方向map](#TOC-map1)</li><li class='goog-toc'>[<strong>7 </strong>要素書き換え](#TOC--3)</li><li class='goog-toc'>[<strong>8 </strong>動的な並び順](#TOC--4)</li></ol>



<h4>boost::multi_index_containerの基本的な使い方 - 挿入順を知っているstd::set</h4>Boost.MultiIndexでは、boost::multi_index_containerというコンテナ型を使用する。

```cpp
namespace boost{
namespace multi_index{

template<typename Value,typename IndexSpecifierList,typename Allocator>
class multi_index_container;

} // namespace multi_index

using multi_index::multi_index_container;

} // namespace boost
```

multi_index_containerの第1テンプレートパラメータValueは要素型、第2テンプレートパラメータIndexSpecifierListがインデックス(並び順)のリスト、第3テンプレートパラメータAllocatorがアロケータの型である。
第2、第3テンプレートパラメータは省略でき、省略した場合のIndexSpecifierListはordered_unique(すなわちstd::set)となる。

boost::multi_index_container型を使用して、挿入順を知っているstd::setを表現するには、以下のようにする：

```cpp
#include <iostream>
#include <boost/multi_index_container.hpp>
#include <boost/multi_index/sequenced_index.hpp>
#include <boost/multi_index/ordered_index.hpp>
#include <boost/multi_index/identity.hpp>
#include <boost/range/algorithm/for_each.hpp>

using namespace boost::multi_index;

typedef multi_index_container< 
    int,
    indexed_by<
        ordered_unique<identity<int> >, // 辞書順(重複なし)
        sequenced<> // 挿入順
    >
> Container;

void disp(int x) { std::cout << x << ' '; }

int main()
{
    Container c;
    c.insert(1);
    c.insert(3);
    c.insert(2);
    c.insert(5);
    c.insert(4);

    
    boost::for_each(c, disp);
    std::cout << std::endl;

    // 挿入順に表示
    boost::for_each(c.get<1>(), disp);
}
```

実行結果：

```cpp
1 2 3 4 5 
1 3 2 5 4 



ここではインデックスに、重複なしの辞書順を表すordered_uniqueと、挿入順を表すsequencedの2つを指定しており、これを指定したmulti_index_containerはこの2つの並び順を同時に表現できるようになっている。0番目のインデックス(デフォルト)がordered_uniqueのため、要素の追加にはinsertを使用しているが、逆の場合にはpush_backを使用する。

コンテナを使用する際に、何も使用しなければ、そのコンテナは0番目のインデックスとして振る舞うことになる。
そのため、この例において、BOOST_FOREACHやboost::for_eachといったアルゴリズムに、インデックスを指定せずにコンテナを渡した場合には、辞書順に処理されることになる。

```cpp
// 辞書順に表示
boost::for_each(c, disp);
```


<span style='line-height:13px'>```cpp
1 2 3 4 5 
</span>


インデックスを指定する場合には、boost::multi_index_container::get<N>()を使用する。
インデックスの番号を指定して、その並び順の表現を取得する。
ここでは、c.get<1>()とすることで、sequencedのインデックスが取得でき、挿入順に処理することができる。


<span style='line-height:13px'><span style='font-family:Arial,sans-serif'>```cpp
// 挿入順に表示
boost::for_each(c.get<1>(), disp);

</span></span>

<span style='line-height:13px'>```cpp
1 3 2 5 4 
</span>

<h4>インデックスの表現を変数に持つ</h4>インデックスの表現を変数に保持したい場合は、boost::multi_index_container::nth_index<N>メタ関数でインデックスの型を取得することができるので、その型にget<N>()したコンテナを参照で格納する。


#include <iostream>
#include <boost/multi_index_container.hpp>
#include <boost/multi_index/sequenced_index.hpp>
#include <boost/multi_index/ordered_index.hpp>
#include <boost/multi_index/identity.hpp>
#include <boost/range/algorithm/for_each.hpp>

using namespace boost::multi_index;

typedef multi_index_container< 
    int,
    indexed_by<
        ordered_unique<identity<int> >, // 辞書順(重複なし)
        sequenced<> // 挿入順
    >
> Container;

void disp(int x) { std::cout << x << ' '; }

int main()
{
    Container c;
    c.insert(1);
    c.insert(3);
    c.insert(2);
    c.insert(5);
    c.insert(4);

    typedef Container::nth_index<0>::type Set;
    typedef Container::nth_index<1>::type List;

    Set& s = c.get<0>();
    List& ls = c.get<1>();

    // 辞書順に表示
    boost::for_each(s, disp);
    std::cout << std::endl;

    // 挿入順に表示
    boost::for_each(ls, disp);
}
```


実行結果：
<span style='font-family:Arial,sans-serif;line-height:19px'>
<code style='color:rgb(0,96,0)'>1 2 3 4 5 </code>
<code style='color:rgb(0,96,0)'>1 3 2 5 4 </code>


</span>



<h4 style='font-family:Trebuchet MS,arial,sans-serif;font-size:1.2em;background-color:rgb(238,238,238);border-top-style:dotted;border-right-style:dotted;border-bottom-style:dotted;border-left-style:dotted;border-top-width:1px;border-right-width:1px;border-bottom-width:1px;border-left-width:1px;border-top-color:rgb(199,199,199);border-right-color:rgb(199,199,199);border-bottom-color:rgb(199,199,199);border-left-color:rgb(199,199,199);color:rgb(26,66,146);padding-top:3px;padding-right:5px;padding-bottom:3px;padding-left:5px;line-height:19px'>インデックスに名前を付ける</h4>0番目のインデックス、1番目のインデックス、といった指定は、プログラムが小さいうちはいいかもしれないが、直値の指定は一般に管理しにくい。そこで、<b>タグ</b>と呼ばれる空の型を作り、それをインデックスを示す名前として使用することができる。

これまでインデックス番号を指定していたget<N>()にはタグ名を指定し、インデックスの型を取得するnth_indexメタ関数の代わりにboost::multi_index_container::index<Tag>メタ関数を使用する。

```cpp
#include <iostream>
#include <boost/multi_index_container.hpp>
#include <boost/multi_index/sequenced_index.hpp>
#include <boost/multi_index/ordered_index.hpp>
#include <boost/multi_index/identity.hpp>
#include <boost/range/algorithm/for_each.hpp>

using namespace boost::multi_index;

struct order {}; // 辞書順のタグ
struct seq {}; // 挿入順のタグ

typedef multi_index_container< 
    int,
    indexed_by<
        ordered_unique<tag<order>, identity<int> >, // 辞書順(重複なし)
        sequenced<tag<seq> > // 挿入順
    >
> Container;

void disp(int x) { std::cout << x << ' '; }

int main()
{
    Container c;
    c.insert(1);
    c.insert(3);
    c.insert(2);
    c.insert(5);
    c.insert(4);

    typedef Container::index<order>::type Set;
    typedef Container::index<seq>::type List;

    Set& s = c.get<order>();
    List& ls = c.get<seq>();

    // 辞書順に表示
    boost::for_each(s, disp);
    std::cout << std::endl;

    // 挿入順に表示
    boost::for_each(ls, disp);
}
```


実行結果：
<span style='font-family:Arial,sans-serif;line-height:19px'>
<code style='color:rgb(0,96,0)'>1 2 3 4 5 </code>
<code style='color:rgb(0,96,0)'>1 3 2 5 4 </code>


</span>





<h4>インデックスと標準コンテナの対応表</h4>Boost.MultiIndexのインデックスは、下記のように標準コンテナに対応している。
なお、std::mapはordered_(non_)uniqueで表現でき、std::unordered_mapはhashed_(non_)uniqueで表現できる。mapを表現するにはboost::multi_index::memberを使用する。


| | | |
|-------------------|------------------------|------------|
|インデックス |標準コンテナ | 説明 |
| ordered_unique | std::set | 辞書順(重複なし) |
| ordered_non_unique | std::multiset | 辞書順(重複あり) |
| hashed_unique | std::unordered_set | ハッシュ表(重複なし) |
| hashed_non_unique | std::unordered_multiset | ハッシュ表(重複あり) |
| sequenced | std::list | 挿入順 |
| random_access | std::vector | ランダムアクセス |

<h4>複数のキーを持つmap</h4>boost::multi_index::memberを使用すると、ordered_(non_)unique, hashed_(non_)uniqueをstd::map, std::unordered_mapのように扱うことができる。

memberの第1テンプレートパラメータはユーザー定義型の型、第2テンプレートパラメータはキーにするメンバ変数の型、第3テンプレートパラメータはキーにするメンバ変数へのポインタである。
memberを使用すると、IDをキーにして要素を検索するmap、名前をキーにして要素を検索するmapを同時に存在させることができる。

```cpp
#include <iostream>
#include <string>
#include <boost/multi_index_container.hpp>
#include <boost/multi_index/member.hpp>
#include <boost/multi_index/ordered_index.hpp>

using namespace boost::multi_index;

struct person {
    int id;
    std::string name;
    int age;

    person(int id, const std::string& name, int age)
        : id(id), name(name), age(age) {}

    void print() const
        { std::cout << id << "," << name << "," << age << std::endl; }
};

struct id {};
struct name {};
struct age {};

typedef multi_index_container<
    person,
    indexed_by<
        ordered_unique<tag<id>,   member<person, int,         &person::id> >,
        ordered_unique<tag<name>, member<person, std::string, &person::name> >,
        ordered_unique<tag<age>,  member<person, int,         &person::age> >
    >
> dictionary;

int main()
{
    dictionary dict;
    dict.insert(person(3, "Akira",  30));
    dict.insert(person(1, "Millia", 20));
    dict.insert(person(4, "Johnny", 10));

    // IDをキーにするmap
    {
        typedef dictionary::index<id>::type id_map;
        id_map& m = dict.get<id>();

        // IDをキーにして検索
        id_map::iterator it = m.find(1);
        if (it != m.end()) {
            it->print();
        }
    }

    // 名前をキーにするmap
    {
        typedef dictionary::index<name>::type name_map;
        name_map& m = dict.get<name>();

        // 名前をキーにして検索
        name_map::iterator it = m.find("Akira");
        if (it != m.end()) {
            it->print();
        }
    }

    // 年齢をキーにするmap
    {
        typedef dictionary::index<age>::type age_map;
        age_map& m = dict.get<age>();

        // 年齢をキーにして検索
        age_map::iterator it = m.find(10);
        if (it != m.end()) {
            it->print();
        }
    }
}
```

実行結果：
```cpp
1,Millia,20
3,Akira,30
4,Johnny,10
```

<h4>双方向map</h4>「[複数のキーをもつmap](https://sites.google.com/site/boostjp/tips/multi_index#TOC-map)」と同じ方法で、IDから名前を調べる、名前からIDを調べる、というような双方向mapを、Boost.MultiIndexで書くことができる。


```cpp
#include <iostream>
#include <string>
#include <boost/multi_index_container.hpp>
#include <boost/multi_index/member.hpp>
#include <boost/multi_index/ordered_index.hpp>

using namespace boost::multi_index;

struct product {
    int id;
    std::string name;

    product(int id, const std::string& name)
        : id(id), name(name) {}
};

struct id {};
struct name {};

typedef multi_index_container<
    product,
    indexed_by<
        ordered_unique<tag<id>,   member<product, int,         &product::id> >,
        ordered_unique<tag<name>, member<product, std::string, &product::name> >
    >
> dictionary;

int main()
{
    dictionary dict;
    dict.insert(product(2852, "coffee"));
    dict.insert(product(7777, "cola"));

    // IDから名前を調べる
    {
        typedef dictionary::index<id>::type id_map;
        id_map& m = dict.get<id>();

        // IDをキーにして検索
        id_map::iterator it = m.find(2852);
        if (it != m.end()) {
            std::cout << it->name << std::endl;
        }
    }

    // 名前からIDを調べる
    {
        typedef dictionary::index<name>::type name_map;
        name_map& m = dict.get<name>();

        // 名前をキーにして検索
        name_map::iterator it = m.find("cola");
        if (it != m.end()) {
            std::cout << it->id << std::endl;
        }
    }
}


実行結果：
```cpp
coffee
7777
```

<h4>要素書き換え</h4>boost::multi_index_containerの要素書き換えには、replace()メンバ関数を使用する方法と、modify()メンバ関数を使用する方法の2種類がある。これは、前者が安全優先の関数であり、後者が速度優先の関数である。

<b>replace()メンバ関数による要素書き換え</b>

replace()は、安全優先の要素書換え関数である。
指定したイテレータの位置の要素を第2引数の値で置き換え、全てのインデックスに適用される。

```cpp
#include <boost/multi_index_container.hpp>
#include <boost/multi_index/ordered_index.hpp>

#include <iostream>
#include <boost/range/algorithm/for_each.hpp>

using namespace boost::multi_index;
typedef multi_index_container<int> Container;

void disp(int x) { std::cout << x <<  ' '; }

int main()
{
    Container c;
    c.insert(3);
    c.insert(1);
    c.insert(4);

    Container::iterator it = c.find(1);
    c.replace(it, 2);

    boost::for_each(c, disp);
}
```

実行結果：
```cpp
2 3 4 


replaceは以下の方法でこの置き換えを行う。

- 変更された要素がすべてのインデックスリストに関してオリジナルのオーダーを保持する場合、計算量は定数時間で、そうでなければ対数時間
- イテレータと参照の有効性は保たれる
- 操作は強い例外安全、つまり、(システムまたはユーザーのデータ型によって引き起こされる)何らかの例外が投げられた場合、multi_index_containerは変化しない

replaceは、標準のSTLコンテナで提供されなかった強力な操作と、強い例外安全が必要であるときに特に便利だ。

replaceの便利さにはコストが伴う。
更新(と内部のreplaceを検索)のために2回全体の要素をコピーしなければならない。
要素をコピーすることが高コストな場合、これはまさしくオブジェクトの小さな部分変更のためのかなりの計算コストであるかもしれない。
```

<b>modify()関数による要素書き換え</b>

replace()が安全優先な実装なのに対し、modify()関数は速度優先の要素書き換えを行う。
replace()は、書き換える要素へのイテレータと、要素書き換えのための関数オブジェクトをとる。

```cpp
#include <boost/multi_index_container.hpp>
#include <boost/multi_index/ordered_index.hpp>

#include <iostream>
#include <boost/range/algorithm/for_each.hpp>

using namespace boost::multi_index;
typedef multi_index_container<int> Container;

class change_value {
    int value_;
public:
    explicit change_value(int value)
        : value_(value) {}

    void operator()(int& target) const
    {
        target = value_;
    }
};

void disp(int x) { std::cout << x <<  ' '; }

int main()
{
    Container c;
    c.insert(3);
    c.insert(1);
    c.insert(4);

    Container::iterator it = c.find(1);
    c.modify(it, change_value(2));

    boost::for_each(c, disp);
}
```

実行結果：
```cpp
2 3 4 
```

modify()はreplace()と速度を優先するために、衝突により書き換え失敗が起こった場合に、壊れたデータになってしまうことを防ぐために、要素を削除する。

さらに、一貫性のためにmodify()は、衝突により書き換え失敗が起こった場合にロールバックするための関数オブジェクトを任意に指定するバージョンも提供している。

```cpp
#include <boost/multi_index_container.hpp>
#include <boost/multi_index/ordered_index.hpp>

#include <iostream>
#include <boost/range/algorithm/for_each.hpp>

using namespace boost::multi_index;
typedef multi_index_container<int> Container;

class change_value {
    int value_;
public:
    explicit change_value(int value)
        : value_(value) {}

    void operator()(int& target) const
    {
        target = value_;
    }
};

class rollback_value {
    int value_;
public:
    explicit rollback_value(int value)
        : value_(value) {}

    void operator()(int& target) const
    {
        target = value_;
    }
};

void disp(int x) { std::cout << x <<  ' '; }

int main()
{
    Container c;
    c.insert(3);
    c.insert(1);
    c.insert(4);

    Container::iterator it = c.find(1);
    c.modify(it, change_value(2), rollback_value(1));

    boost::for_each(c, disp);
}
```

プログラマは、最良の更新メカニズムを決定するためにreplace()、modify()およびロールバックをもつmodify()の振る舞いの差をケースバイケースで考慮しなければなりません。

更新関数と衝突時の動作

- replace(it, x)：置換は行われない
- modify(it, mod)：要素は消去される
- modify(it, mod, back)：backは復旧するのに使用される(backが例外を投げた場合、要素は消去される)

<h4>動的な並び順</h4>Boost.MultiIndexのordered indices, random access indices, sequenced indicesなどのインデックスは不変であるため、通常の手段では並び順をあとから変えることはできない。

```cpp
typedef multi_index_container<
    int,
    indexed_by<random_access<> >
> container;

container c;
boost::random_shuffle(c); // エラー！書き換えできない

こういった動的な並び順をインデックスとして持たせるために、rearrangeというメンバ関数が用意されている。
以下がその使用例である。2つめのrandom access indicesを、動的な並び順として扱えるようにしている。

```cpp
#include <iostream>
#include <vector>
#include <boost/range/algorithm.hpp>
#include <boost/multi_index_container.hpp>
#include <boost/multi_index/random_access_index.hpp>
#include <boost/assign/list_of.hpp>
#include <boost/foreach.hpp>
#include <boost/ref.hpp>

using namespace boost::multi_index;
typedef multi_index_container<
    int,
    indexed_by<
        random_access<>,
        random_access<>
    >
> container;

int main()
{
    container c = boost::assign::list_of(1)(2)(3)(4)(5);

    std::vector<boost::reference_wrapper<const int> > v;
    BOOST_FOREACH(const int& i, c) {
        v.push_back(boost::cref(i));
    }

    boost::random_shuffle(v);
    c.get<1>().rearrange(v.begin());

    boost::for_each(c.get<0>(), [](int x) { std::cout << x; }); std::cout << std::endl;
    boost::for_each(c.get<1>(), [](int x) { std::cout << x; }); std::cout << std::endl;
}
```

実行結果：
```cpp
12345
52431
```

1つめのrandom access indicesの並び順はそのままに、2つめのrandom access indicesの方だけが、random_shuffleを適用した動的な並び順になっていることがわかる。
rearrangeを使用するには、multi_index_containerの要素を一旦、reference wrapperのコンテナに持たせてそのコンテナに対して並び順の操作を行う必要がある。

Boost.MultiIndexのドキュメントでは、トランプをシャッフルする例が紹介されている。
[http://www.boost.org/doc/libs/1_46_1/libs/multi_index/example/rearrange.cpp](http://www.boost.org/doc/libs/1_46_1/libs/multi_index/example/rearrange.cpp)



