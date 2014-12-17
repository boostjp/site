#コマンドラインオプションの定義／取得
[Boost Program Options Library](http://www.boost.org/doc/libs/release/doc/html/program_options.html)を用いるとプログラムの実行時に付けられる引数文字列について、一般的なオプションの仕組みの定義とその取得を容易に行える。

なお、Boost.ProgramOptionsを用いる場合はコンパイルの際に`g++ -lboost_program_options source.cxx`の様にしてバイナリーのライブラリーをリンクする必要がある点に注意。


##インデックス
- [オプションを定義する](#define-option)
- [オプションを取得する](#get-option)


## <a name="define-option" href="#define-option">オプションを定義する</a>
`<boost/program_options.hpp>`に定義される`boost::program_options`名前空間に含まれる`options_description`型により、プログラムオプションを定義する。

```cpp
#include <boost/program_options.hpp>

int main(const int ac, const char* const * const av)
{
  using namespace boost::program_options;
  
  // オプションの定義
  options_description description("おぷしょん");
  description.add_options()
    ("hoge,h", value<int>()->default_value(-100), "ほげほげおぷしょんの説明だよ")
    ("fuga,f", value<std::vector<unsigned>>()->multitoken(), "ふがふがおぷしょんの説明だよ")
    ("help,H", "へるぷ")
    ("version,v", "ばーじょん情報")
    ;
}
```

以上の例では、`app -hoge 123 -fuga 1 2 4 8 16 32`であるとか、`app -h -10 -f 123 456 789`であるとか`app -H`などの様な利用法を想定したプログラムオプションを定義している。

また、`hoge`にはデフォルト値として `-100` 、`fuga`は複数要素のオプションとして`multitoken()`を定義している。

※定義しただけでは意味がありませんので、実際には「[オプションの取得](#get-option)」と組み合わせて使います。


## <a name="get-option" href="#get-option">オプションを取得する</a>
`parse_command_line()`関数を使用して、`options_description`の定義に基づいてコマンドライン引数を解析し、その結果を`variables_map`オブジェクトに対して格納する事を定義する。`notiry()`関数を使用することで、実際に`variables_map`オブジェクトに解析されたプログラムオプションの結果が格納される。

```cpp
#include <boost/program_options.hpp>

int main(const int ac, const char* const * const av)
{
  using namespace boost::program_options;
  
  // オプションの定義
  options_description description("おぷしょん");
  // （省略：「オプションの定義」を参照のこと）
  
  // オプションの取得
  variables_map vm;
  store(parse_command_line(ac, av, description), vm);
  notify(vm);

  // (a.) オプション help が存在すれば description をコマンドのヘルプとして出力する。
  if( vm.count("help") )
    std::cout << description << std::endl;

  // (b.) オプション hoge の取得（ int 型）
  auto hoge = vm["hoge"].as<int>();

  // (c.) オプション fuga の取得 （ std::vector<unsigned> 型）
  auto fuga = vm["fuga"].as<std::vector<unsigned>>();
}
```
* variable_map[color ff0000]
* parse_command_line[color ff0000]
* notify[color ff0000]

この例では、(a.)により実際に実行時に`app -H`とコマンドラインでオプションを定義すれば、 `description` を元にした一般的なプログラムオプションの表示が行われる。

(b.)と(c.)ではそれぞれ`app -hoge -10`や`app -fuga 123 456 789`の様に定義されたプログラムオプションをそれぞれ`int`型、`std::vector<unsigned>`型取得している。


