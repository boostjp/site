# 無名関数
無名関数は、[Boost Lambda Library](http://www.boost.org/doc/libs/release/doc/html/lambda.html) または、 [Boost Phoenix Library](http://www.boost.org/doc/libs/release/libs/phoenix/doc/html/index.html) を使用することによって表現できる。


## インデックス
- [基本的な使い方](#basic-usage)
- [メンバ変数を扱う](#member-variable)
- [2つ以上の式を書く](#multiple-expressions)


## <a id="basic-usage" href="#basic-usage">基本的な使い方</a>
Boost.Lambdaによって無名関数を表現するには、`boost::lambda`名前空間の`_1`, `_2`というプレースホルダーと呼ばれる値を使用する。以下は、コンテナから特定の条件に一致した値を見つけ出す例である。

```cpp example
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
```
3
```

これを、Boost.Lambdaを使用して書くと以下のようになる：

```cpp example
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
* boost::find_if(v, _1 == 3);[color ff0000]

実行結果：
```
3
```

`_1`という値は、「無名関数の第1引数」を意味し、この場合、コンテナの各要素が渡されることになる。

Boost.Lambdaでは、`_1`, `_2`のようなプレースホルダーに対して各種演算処理を適用するというスタイルで、無名関数を表現する。


## <a id="member-variable" href="#member-variable">メンバ変数を扱う</a>
Boost.Lambdaでメンバ変数を扱うには、`operator->*()`を使用する。左辺はポインタである必要があるため、`&_1`のように表記し、右辺にはメンバ変数ポインタを指定する。

以下は、`Person`クラスを要素とするコンテナから、`name`メンバ変数をキーにして該当する要素を検索する処理である：

```cpp example
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
```

実行結果：
```
1
```


## <a id="multiple-expressions" href="#multiple-expressions">2つ以上の式を書く</a>
Boost.Phoenix のカンマ演算子を使用して、複数の式を書くことができる。

```cpp example
#include <boost/phoenix.hpp>
#include <boost/range/irange.hpp>
#include <boost/range/algorithm/for_each.hpp>
#include <iostream>

void disp(int n){
    std::cout << n << std::endl;
}

int main(){
    namespace phx = boost::phoenix;
    using phx::arg_names::arg1;
    // カンマ演算子で複数の式を書く
    (
        phx::bind(&disp, arg1),        // disp(10)
        phx::bind(&disp, arg1 + arg1)  // disp(10 + 10)
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

実行結果：
```
10
20
0,1,2,3,4,5,6,7,8,9,
45
```

 
