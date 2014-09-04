#コマンドラインオプションの定義／取得
Boost.ProgramOptionsを用いるとプログラムの実行時に付けられる引数文字列について、一般的なオプションの仕組みの定義とその取得を容易に行える。
なお、Boost.ProgramOptionsを用いる場合はコンパイルの際に`g++ -lboost_program_options source.cxx`の様にしてバイナリーのライブラリーをリンクする必要がある点に注意。

Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>オプションの定義](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>オプションの取得](#TOC--1)</li></ol>



<h4>オプションの定義</h4><boost/program_options.hpp>に定義される名前空間boost::program_optionsに含まれるoptions_description型により先ずはプログラムオプションを定義する。

```cpp
#include <boost/program_options.hpp>
...
int main(const int ac, const char* const * const av)
{
  using namespace boost::program_options;
  
  // オプションの定義
  options_description description("おぷしょん");
  description.add_oiptions()
    ("hoge,h", value<int>()->default_value(-100), "ほげほげおぷしょんの説明だよ")
    ("fuga,f", value<std::vector<unsigned>>()->multitoken(), "ふがふがおぷしょんの説明だよ")
    ("help,H", "へるぷ")
    ("version,v", "ばーじょん情報")
    ;
<span style='background-color:transparent;font-size:10pt;line-height:1.5'>}</span>
```

以上の例では、`app -hoge 123 -fuga 1 2 4 8 16 32`であるとか、`app -h -10 -f 123 456 789`であるとか`app -H`などの様な利用法を想定したプログラムオプションを定義している。

また、hogeにはデフォルト値として -100 、fugaは複数要素のオプションとしてmultitoken()を定義している。

※定義しただけでは意味がありませんので、実際には「オプションの取得」と組み合わせて使います。

<h4>オプションの取得</h4>parse_command_lineでoptions_descriptionの定義に基づいてコマンドライン引数を解析し、その結果を<span style='background-color:transparent;line-height:1.5;font-size:10pt'>variables_mapオブジェクトに対して格納する事を定義し、notiryにより実際にvariables_mapオブジェクトに解析されたプログラムオプションの結果が格納される。</span>

```cpp
#include <boost/program_options.hpp>
...
int main(const int ac, const char* const * const av)
{
  using namespace boost::program_options;
  
  // オプションの定義
  options_description description("おぷしょん");
  // <span style='background-color:transparent;line-height:1.5;font-size:10pt'>（省略：「オプションの定義」を参照のこと）</span>
<span style='background-color:transparent;line-height:1.5;font-size:10pt'>  </span>
<span style='background-color:transparent;line-height:1.5;font-size:10pt'>  // オプションの取得</span>
<span style='background-color:transparent;line-height:1.5;font-size:10pt'>  variables_map vm;</span>
<span style='background-color:transparent;line-height:1.5;font-size:10pt'>  store(parse_command_line(ac, av, description), vm);</span>
<span style='background-color:transparent;line-height:1.5;font-size:10pt'>  notify(vm);</span>

  // (a.) オプション help が存在すれば description をコマンドのヘルプとして出力する。
  if( vm.count("help") )
    std::cout << description << std::endl;

  // (b.) オプション hoge の取得（ int 型）
  auto hoge = vm["hoge"].as<int>();

  // (c.) オプション fuga の取得 （ std::vector<unsigned> 型）
  auto fuga = vm["fuga"].as<std::vector<unsigned>>();
<span style='background-color:transparent;font-size:10pt;line-height:1.5'>}</span>
```

この例では、(a.)により実際に実行時に`app -H`とコマンドラインでオプションを定義すれば、 description を元にした一般的なプログラムオプションの表示が行われる。

(b.)と(c.)ではそれぞれ`app -hoge -10`や`app -fuga 123 456 789`の様に定義されたプログラムオプションをそれぞれint型、std::vector<unsigned>型取得している。
<span style='background-color:transparent;line-height:1.5;font-size:10pt'></span>
<span style='background-color:transparent;line-height:1.5;font-size:10pt'>※定義しただけでは意味がありませんので、実際には「オプションの定義」と組み合わせて使います。</span>

