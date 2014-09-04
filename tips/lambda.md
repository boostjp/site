#無名関数
無名関数は、[Boost Lambda Library](http://www.boost.org/doc/libs/release/doc/html/lambda.html) または、 [Boost Phoenix Library](http://www.boost.org/doc/libs/release/libs/phoenix/doc/html/index.html) を使用することによって表現できる。


Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>基本的な使い方](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>メンバ変数を扱う](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>2つ以上の式を書く](#TOC-2-)</li></ol>



<h4>基本的な使い方</h4>Boost.Lambdaによって無名関数を表現するには、boost::lambda名前空間の_1, _2というプレースホルダーと呼ばれる値を使用する。以下は、コンテナから特定の条件に一致した値を見つけ出す例である。

```cpp
#include <iostream>
#include <vector>
#include <boost/range/algorithm/find_if.hpp>

bool is_target_value(int x) { return x == 3; }

int main()
{
    std::vector<int> v;
    v.push_back(1);
    v.push_back(2);
    v.push_back(3);

    std::vector<int>::iterator it = boost::find_if(v, is_target_value);
    if (it != v.end())
        std::cout << *it << std::endl;
    else
        std::cout << "Not Found" << std::endl;
}
```

実行結果：
```cpp
3
```

これを、Boost.Lambdaを使用して書くと以下のようになる：

```cpp
#include <iostream>
#include <vector>
#include <boost/lambda/lambda.hpp>
#include <boost/range/algorithm/find_if.hpp>

int main()
{
    std::vector<int> v;
    v.push_back(1);
    v.push_back(2);
    v.push_back(3);

    using boost::lambda::_1;
    std::vector<int>::iterator it = boost::find_if(v, _1 == 3);
    if (it != v.end())
        std::cout << *it << std::endl;
    else
        std::cout << "Not Found" << std::endl;
}
```

実行結果：
```cpp
3
```

_1という値は、「無名関数の第1引数」を意味し、この場合、コンテナの各要素が渡されることになる。
Boost.Lambdaでは、_1, _2のようなプレースホルダーに対して各種演算処理を適用するというスタイルで、無名関数を表現する。

<h4>メンバ変数を扱う</h4>Boost.Lambdaでメンバ変数を扱うには、operator->*()を使用する。左辺はポインタである必要があるため、&_1のように表記し、右辺にはメンバ変数ポインタを指定する。

以下は、Personクラスを要素とするコンテナから、nameメンバ変数をキーにして該当する要素を検索する処理である：

```cpp
#include <iostream>
#include <vector>
#include <boost/lambda/lambda.hpp>
#include <boost/range/algorithm/find_if.hpp>

struct Person {
    int id;
    std::string name;

    Person() : id(0) {}
    Person(int id, const std::string& name) : id(id), name(name) {}
};

int main()
{
    std::vector<Person> v;
    v.push_back(Person(1, "Alice"));
    v.push_back(Person(2, "Bob"));
    v.push_back(Person(3, "Carol"));

    using boost::lambda::_1;
    std::vector<Person>::iterator it = boost::find_if(v, &_1 ->* &Person::name == "Alice");
    if (it != v.end())
        std::cout << it->id << std::endl;
    else
        std::cout << "Not Found" << std::endl;
}

実行結果：
```cpp
1
```

<h4>2つ以上の式を書く</h4>Boost.Phoenix のカンマ演算子を使用して、複数の式を書くことが出来る。

<span style='background-color:rgb(239,239,239)'>
```cpp
#include <boost/phoenix.hpp>
#include <boost/range/irange.hpp>
#include <boost/range/algorithm/for_each.hpp>
#include <iostream>

void
disp(int n){
    std::cout << n << std::endl;
}

int
main(){
    namespace phx = boost::phoenix;
    using phx::arg_names::arg1;
    // カンマ演算子で複数の式を書く
    (
        phx::bind(&disp, arg1),        // disp(10)
        phx::bind(&disp, arg1 + arg1)<span>  // disp(10 + 10)</span>
    )(10);
    
    int sum = 0;
    // 0～9 までの合計を計算する
    boost::for_each(boost::irange(0, 10), (
        std::cout << arg1 << ",",
        phx::ref(sum) += arg1
    ));
    std::cout << "\n";
    std::cout << sum << std::endl;
    
    return 0;
}
```
* ,        [color ff0000]
* )[color ff0000]
* ([color ff0000]
* ,[color ff0000]
* )[color ff0000]

</span>

実行結果：
<span style='line-height:13px;background-color:rgb(239,239,239)'>```cpp
10
20
0,1,2,3,4,5,6,7,8,9,
45
```

</span>

 
