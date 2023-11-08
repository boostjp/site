# ユーザー定義型を扱える型安全な共用体
ユーザー定義型を共用体で扱うには、[Boost Variant Library](http://www.boost.org/doc/libs/release/doc/html/variant.html)を使用する。


## インデックス
- [基本的な使い方](#basic-usage)
- [どの型が格納されているかを判定する](#which-type)
- [格納されている値を取り出す](#get-value)
- [値をクリアする](#clear)
- [variantを再帰的にする](#recursive-variant)
- [C++の国際標準規格上の類似する機能](#cpp-standard)


## <a id="basic-usage" href="#basic-usage">基本的な使い方</a>
まず、Boost.Variantの基本的な使い方を以下に示す：

```cpp example
#include <iostream>
#include <string>
#include <boost/variant.hpp>

struct var_printer : boost::static_visitor<void> {
    void operator()(int x) const
        { std::cout << x << std::endl; }

    void operator()(std::string& s) const
        { std::cout << s << std::endl; }

    void operator()(double x) const
        { std::cout << x << std::endl; }
};

int main()
{
    // int, string, doubleのオブジェクトが格納されうる型
    boost::variant<int, std::string, double> v;

    v = 3; // int型の値を代入
    boost::apply_visitor(var_printer(), v); // visitorで型ごとの処理を行う

    v = "hello"; // 文字列を代入
    boost::apply_visitor(var_printer(), v);
}
```

出力：
```
3
hello
```

[`boost::variant`](http://www.boost.org/doc/libs/release/doc/html/boost/variant.html)クラステンプレートが、型安全に抽象化された共用体である。そのテンプレート引数として、格納されうる型を列挙する。

[`boost::variant`](http://www.boost.org/doc/libs/release/doc/html/boost/variant.html)クラスは、テンプレートパラメータで指定された型のオブジェクトを、コピー／ムーブコンストラクタおよび代入演算子で代入できる。

[`boost::apply_visitor()`](http://www.boost.org/doc/libs/release/doc/html/boost/apply_visitor.html)関数に指定する関数オブジェクトは、[`boost::static_visitor`](http://www.boost.org/doc/libs/release/doc/html/boost/static_visitor.html)クラスから派生したクラスであり、[`boost::variant`](http://www.boost.org/doc/libs/release/doc/html/boost/variant.html)オブジェクトにどの型のオブジェクトが格納されているのかによって、関数呼び出し演算子を適切にオーバーロードしてくれる。


## <a id="which-type" href="#which-type">どの型が格納されているかを判定する</a>
[`boost::variant`](http://www.boost.org/doc/libs/release/doc/html/boost/variant.html)オブジェクトにどの型が格納されているか判定するには`which()`メンバ関数、もしくは`type()`メンバ関数を使用する。

`which()`メンバ関数は、格納されている型の、`0`から始まるインデックスを返す。

```cpp example
#include <iostream>
#include <string>
#include <boost/variant.hpp>

int main()
{
    boost::variant<int, std::string, double> v;

    // 空の状態
    std::cout << v.which() << std::endl;

    v = 1; // int型の値を格納
    std::cout << v.which() << std::endl;

    v = 3.14; // double型の値を格納
    std::cout << v.which() << std::endl;
}
```
* which[color ff0000]

出力：
```
0
0
2
```

`type()`メンバ関数は、格納されている型の[`std::type_info`](https://cpprefjp.github.io/reference/typeinfo/type_info.html)オブジェクトへの`const`左辺値参照を返す。

```cpp example
#include <iostream>
#include <string>
#include <boost/variant.hpp>

int main()
{
    boost::variant<int, std::string, double> v;

    v = 1; // int型の値を格納
    if (v.type() == typeid(int)) {
        std::cout << "int" << std::endl;
    }

    v = 3.14; // double型の値を格納
    if (v.type() == typeid(double)) {
        std::cout << "double" << std::endl;
    }
}
```
* type[color ff0000]

出力：
```
int
double
```


## <a id="get-value" href="#get-value">格納されている値を取り出す</a>
[`boost::variant`](http://www.boost.org/doc/libs/release/doc/html/boost/variant.html)オブジェクトに格納されている値を取り出すには、[`boost::get()`](http://www.boost.org/doc/libs/1_52_0/doc/html/boost/get_id1950197.html)非メンバ関数を使用する。
この関数には参照版とポインタ版の2種類が用意されている。それぞれの特徴は以下の通り：

- 参照版 ： [`boost::get()`](http://www.boost.org/doc/libs/1_52_0/doc/html/boost/get_id1950197.html)非メンバ関数に[`boost::variant`](http://www.boost.org/doc/libs/release/doc/html/boost/variant.html)オブジェクトへの参照を渡すと、格納されている値への参照を返す。指定された型が格納されている型と同じではない場合、[`boost::bad_get`](http://www.boost.org/doc/libs/release/doc/html/boost/bad_get.html)型の例外を送出する。
- ポインタ版 ： [`boost::get()`](http://www.boost.org/doc/libs/1_52_0/doc/html/boost/get_id1950197.html)非メンバ関数に[`boost::variant`](http://www.boost.org/doc/libs/release/doc/html/boost/variant.html)オブジェクトへのポインタを渡すと、格納されている値へのポインタを返す。指定された型が格納されている型と同じではない場合、ヌルポインタを返す。

```cpp example
#include <iostream>
#include <string>
#include <boost/variant.hpp>

int main()
{
    boost::variant<int, std::string, double> v;
    v = 1; // int型の値を格納

    // 参照版
    try {
        int& x = boost::get<int>(v);
        std::cout << x << std::endl;
    }
    catch (boost::bad_get& e) {
        std::cout << e.what() << std::endl;
    }

    // ポインタ版
    if (int* x = boost::get<int>(&v)) {
        std::cout << *x << std::endl;
    }
    else {
        std::cout << "int値は格納されていない" << std::endl;
    }
}
```
* boost::get[color ff0000]

出力：
```
1
1
```


## <a id="clear" href="#clear">値をクリアする</a>
Boost.Variantには[決して空にはならない保証](http://www.boost.org/doc/libs/release/doc/html/variant/design.html#variant.design.never-empty)という考え方があるため、他の値を入れることはできてもクリアはできない。`clear()`関数は用意されておらず、`empty()`メンバ関数は常に`false`を返す。

どうしてもクリアしたい場合は、`boost::blank`という型を`variant`に格納できるように指定する。これは単なる中身が空のクラスである。

`which()`メンバ関数や`type()`メンバ関数を使用して、`boost::blank`オブジェクトが格納されているかどうかで、空かどうかを判定する。

[`boost::variant`](http://www.boost.org/doc/libs/release/doc/html/boost/variant.html)クラスは、そのデフォルトコンストラクタで第1テンプレートパラメータのオブジェクトを構築するので、`boost::blank`は第1テンプレートパラメータとして指定することを推奨する。

```cpp example
#include <iostream>
#include <string>
#include <boost/variant.hpp>

int main()
{
    boost::variant<boost::blank, int, std::string> v = boost::blank();
    v = 3;

    v = boost::blank();

    if (v.type() == typeid(boost::blank)) {
        std::cout << "blank" << std::endl;
    }
    else {
        std::cout << "no blank" << std::endl;
    }
}
```
* boost::blank[color ff0000]

出力：
```
blank
```

## <a id="recursive-variant" href="#recursive-variant">variantを再帰的にする</a>
boost::variant に含める型リストに boost::variant で定義したい型それ自身も含めたい場合には `boost::variant<...>` を `boost::make_recursive_variant<...>::type` に替えて、自身の型に相当する型引数には `boost::recursive_variant_` を渡す事で、`boost::variant` によって定義される型にそれ自身の型を再帰的に含む型を生成できる。

`boost::make_recursive` を用いた再帰的な `boost::variant` 型の定義による `float` `double` `long double` `bool` を末端の値とし、 それらの `std::vector` と `std::unordered_map` によるコンテナーも再帰的に定義した型と、 `boost::apply_visitor` による JSON 風の出力を行う例を示す。

```cpp
#include <boost/variant.hpp>
#include <unordered_map>
#include <vector>
#include <string>
#include <iostream>
#include <iomanip>
#include <limits>

using property_type = boost::make_recursive_variant
< bool
, float, double, long double
, std::vector< boost::recursive_variant_ >
, std::unordered_map< std::string, boost::recursive_variant_ >
>::type;

using array_type = std::vector< property_type >;
using map_type   = std::unordered_map< std::string, property_type >;

class printer
  : boost::static_visitor< void >
{
  std::ostream& _s;
  const std::size_t _nest_level = 0;
  
  public:
  
  explicit printer( std::ostream& s, const std::size_t nest_level = 0 )
    : _s( s )
    , _nest_level( nest_level )
  { }
  
  auto indent( const std::size_t delta_nest_level = 0 ) const
  {
    for ( std::size_t n = 0; n < _nest_level + delta_nest_level; ++ n )
      _s << "  ";
  }
  
  auto operator()( const array_type& o ) const -> void
  {
    indent();
    _s << "[\n";
    for ( auto i = o.cbegin(); i != o.cend(); ++i )
    {
      boost::apply_visitor( printer( _s, _nest_level + 1 ), *i );
      if ( i + 1 != o.cend() )
        _s << ",";
      _s << "\n";
    }
    indent();
    _s << "]";
  }
  
  auto operator()( const map_type& o ) const -> void
  {
    indent();
    _s << "{\n";
    for ( auto i = o.cbegin(); i != o.cend(); )
    {
      indent( 1 );
      _s << '"' << i->first << '"' <<  ":\n";
      boost::apply_visitor( printer( _s, _nest_level + 2 ), i->second );
      if ( ++i != o.cend() )
        _s << ",";
      _s << "\n";
    }
    indent();
    _s << "}";
  }

  auto operator()( const bool e ) const -> void { indent(); _s << std::boolalpha << e; }
  
  template < typename T >
  auto operator()( const T e ) const -> void { indent(); _s << std::fixed << std::setprecision( std::numeric_limits< T >::max_digits10 - 2 ) << e; }
};

auto main() -> int
{
  array_type p1;
  p1.emplace_back( 1.23e-4f );
  p1.emplace_back( 1.23e-4 );
  p1.emplace_back( 1.23e-4l );
  p1.emplace_back( true );
  p1.emplace_back( p1 );
  map_type p2;
  p2.emplace( "fuga", p1 );
  p2.emplace( "piyo", false );
  p1.emplace_back( p2 );
  property_type p = p1;

  boost::apply_visitor( printer( std::cout ), p );
}
```

出力例:

```
[
  0.0001230,
  0.000123000000000,
  0.0001230000000000000,
  true,
  [
    0.0001230,
    0.000123000000000,
    0.0001230000000000000,
    true
  ],
  {
    "piyo":
      false,
    "fuga":
      [
        0.0001230,
        0.000123000000000,
        0.0001230000000000000,
        true,
        [
          0.0001230,
          0.000123000000000,
          0.0001230000000000000,
          true
        ]
      ]
  }
]
```

## <a id="cpp-standard" href="#cpp-standard">C++の国際標準規格上の類似する機能</a>
- [std::variant](https://cpprefjp.github.io/reference/variant/variant.html)

documentated boost version is 1.52.0
