#構文解析
<b><i>本稿は記述途中です。</i></b>


[Boost Spirit](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/index.html) ライブラリ、特にその中の [Qi](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/spirit/qi.html) を用いることにより構文解析器を作成することが可能である。文法、アクションを記述したファイルを元に C/C++ ソースを生成する yacc や bison といった伝統的なパーサジェネレータとは異なり、Spirit Qi では C++ 内で文法、アクションの記述を完結させることができる。また、対象とする文法も文脈自由文法のような伝統的なクラスではなく解析表現文法(PEG: Parsing Expression Grammar)である(一般に解析表現文法は自然言語の解析には適しておらずコンピュータ言語の解析に適している)。



Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>API](#TOC-API)<ol class='goog-toc'><li class='goog-toc'>[<strong>1.1 </strong>入力を全て消費したかを確認する](#TOC--)</li><li class='goog-toc'>[<strong>1.2 </strong>空白等を読み飛ばす](#TOC--1)</li><li class='goog-toc'>[<strong>1.3 </strong>解析された値を受け取る](#TOC--2)</li></ol></li><li class='goog-toc'>[<strong>2 </strong>ルール](#TOC--3)<ol class='goog-toc'><li class='goog-toc'>[<strong>2.1 </strong>プリミティブ](#TOC--4)</li><li class='goog-toc'>[<strong>2.2 </strong>ディレクティブ](#TOC--5)</li><li class='goog-toc'>[<strong>2.3 </strong>演算子](#TOC--6)</li><li class='goog-toc'>[<strong>2.4 </strong>セマンティックアクション](#TOC--7)</li><li class='goog-toc'>[<strong>2.5 </strong>非終端記号](#TOC--8)</li></ol></li><li class='goog-toc'>[<strong>3 </strong>逆引き](#TOC--9)<ol class='goog-toc'><li class='goog-toc'>[<strong>3.1 </strong>空白等を読み飛ばしたい](#TOC--10)</li><li class='goog-toc'>[<strong>3.2 </strong>特定の文字列で終了する部分まで読み出したい](#TOC--11)</li><li class='goog-toc'>[<strong>3.3 </strong>デフォルト値を与えたい](#TOC--12)</li><li class='goog-toc'>[<strong>3.4 </strong>条件によって構文解析を途中で失敗させたい](#TOC--13)</li><li class='goog-toc'>[<strong>3.5 </strong>ある範囲全体の結果を文字列として得たい](#TOC--14)</li></ol></li></ol>





###API

構文解析の実施は parse() 関数、あるいは phrase_parse() 関数を呼び出すことによって行う。parse() 関数と phrase_parse() 関数の違いは phrase_parse() が空白等の読み飛ばし(Skipper：後述)を行う一方、parse() 関数は読み飛ばしを行わない点である。phrase_parse() については[空白等をを読み飛ばす](https://sites.google.com/site/boostjp/tips/parser#TOC-2)を参照。



```cpp
#include <iostream>

#include <string>

#include <boost/spirit/include/qi.hpp>


namespace qi = boost::spirit::qi;


std::string s("123 456");

std::string::iterator first = s.begin(), last = s.end();

bool success = qi::parse( // 戻り値は解析が成功したかどうか。

                          // 入力が余っている場合でも解析が完了した場合は true を返す

    first,                // 非 const 参照で受け、かつ、値が変更されるため s.begin() 等は直接渡せない

    last,

    qi::int_              // ルール(文法部分) 後述　この場合は1つの整数

);

if (success) { std::cout << "OK" << std::endl; } // OK が出力される
```

<h4>入力を全て消費したかを確認する</h4>
parse() 関数、phrase_parse() 関数の第1引数は解析中に更新されていく。そのため構文解析中に入力が全て消費されたか確認したい場合は、第2引数に渡した値と比較すれば良い。



```cpp
#include <iostream>

#include <string>

#include <boost/spirit/include/qi.hpp>


namespace qi = boost::spirit::qi;


std::string s("123 456");

std::string::iterator first = s.begin(), last = s.end();

bool success = qi::parse( // 戻り値は解析が成功したかどうか。

                          // 入力が余っている場合でも解析が完了した場合は true を返す

    first,                // 非 const 参照で受け、かつ、値が変更されるため s.begin() 等は直接渡せない

    last,

    qi::int_              // ルール(文法部分) 後述　この場合は1つの整数

);

if (success && first == last) { std::cout << "OK" << std::endl; } // OK は出力されない


s = "123"; first = s.begin(); last = s.end();

success = qi::parse(first, last, qi::int_);

if (success && first == last) { std::cout << "OK" << std::endl; } // OK が出力される
```

<h4>空白等を読み飛ばす</h4>
前述の通り phrase_parse() 関数を用いる。関数呼び出しの際にどのような内容を読み飛ばすかを第4引数にルールの形で指定する(Skipper と呼ばれる)。非終端記号（後述）を使用している場合は、その非終端記号の型に Skipper の型を指定してやる必要があることに注意（FAQ）。



```cpp
#include <iostream>

#include <string>

#include <boost/spirit/include/qi.hpp>


namespace qi = boost::spirit::qi;


std::string s("   123");

std::string::iterator first = s.begin(), last = s.end();

bool success = qi::phrase_parse( // 戻り値は解析が成功したかどうか。

                                 // 入力が余っている場合でも解析が完了した場合は true を返す

    first,                // 非 const 参照で受け、かつ、値が変更されるため s.begin() 等は直接渡せない

    last,

    qi::int_,             // ルール(文法部分) 後述　この場合は1つの整数

    qi::space             // Skipper この場合は任意の空白

                          // 勝手に繰り返し呼び出されるので繰り返し分を明示的に指定する必要はない

);

if (success) { std::cout << "OK" << std::endl; } // OK が出力される


first = s.begin();

success = qi::parse(first, last, qi::int_);

if (success) { std::cout << "OK" << std::endl; } // 最初の空白で失敗するため OK は出力されない
```

<h4>解析された値を受け取る</h4>
parse() 関数、phrase_parse() 関数のいずれも追加で読み取った値を受け取る変数を渡すことができる。複数の値を読み取る場合は複数の変数を渡すことができる。



```cpp
#include <iostream>

#include <string>

#include <boost/spirit/include/qi.hpp>
```

`namespace qi = boost::spirit::qi;`


`std::string s("123 456");`

`std::string::iterator first = s.begin(), last = s.end();`

`int n1, n2;`

`bool success = qi::phrase_parse( // 戻り値は解析が成功したかどうか。`

`                                 // 入力が余っている場合でも解析が完了した場合は true を返す`

`    first,                // 非 const 参照で受け、かつ、値が変更されるため s.begin() 等は直接渡せない`

`    last,`

`    qi::int_ >> qi::int_, // ルール(文法部分) 後述　この場合は2つの整数`

`    qi::space             // Skipper この場合は任意の空白`

`                          // 勝手に繰り返し呼び出されるので繰り返し分を明示的に指定する必要はない`

`    n1, n2                // 読み取った値の格納先`

`);`

`if (success) { std::cout << "OK: " << n1 << ", " << n2 << std::endl; } // OK: 123, 456 が出力される`



###ルール

ルールはプリミティブ、ディレクティブ、演算子を組み合わせることによって表現される。

<h4>プリミティブ</h4>
文字を読むプリミティブのリストについては [Character Parsers](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/spirit/qi/quick_reference/qi_parsers/char.html) を参照。

数値を読むプリミティブのリストについては [Numeric Parsers](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/spirit/qi/quick_reference/qi_parsers/numeric.html) を参照。

文字列を読むプリミティブのリストについては [String Parsers](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/spirit/qi/quick_reference/qi_parsers/string.html) を参照。

バイナリ値を読むプリミティブのリストについては [Binary Parsers](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/spirit/qi/quick_reference/qi_parsers/binary.html) を参照。

補助的なプリミティブのリストについては [Auxiliary Parsers](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/spirit/qi/quick_reference/qi_parsers/auxiliary.html) を参照。

<b><i>※後で適当に丸めて翻訳して入れる</i></b>

<h4>ディレクティブ</h4>
ディレクティブのリストは [Parser Directives](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/spirit/qi/quick_reference/qi_parsers/directive.html) を参照。

<b><i>※後で翻訳して入れる</i></b>

<h4>演算子</h4>
演算子のリストは [Parser Operators](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/spirit/qi/quick_reference/qi_parsers/operator.html) を参照。

属性（読み取る値）の型については [Compound Attribute Rules](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/spirit/qi/quick_reference/compound_attribute_rules.html) を参照。 

<b><i>※後で翻訳して入れる</i></b>

<h4>セマンティックアクション</h4>

<h4>非終端記号</h4>
ルールを rule として名前をつけることができる。



```cpp
// Iterator の型以外は省略可能で、順序も自由

qi::rule<

    std::string::iterator, // 解析対象の Iterator の型 ※しばしば template 引数
```

`    int(void),             // 属性の型 ※関数型として指定し戻り値の型が読み取る値 ※省略可能`

`    qi::locals<int>,       // ローカル変数の型 ※省略可能`

`    qi::space_type         // Skipper の型 ※省略可能　<b>Skipper を使いたい時には忘れず指定すること</b>`

`                           // ※指定しなくともコンパイルできてしまうが望み通りの挙動とならない`

`> int_pair;`

`int_pair %= qi::int_[qi::_a = qi::_1] >> qi::int_(qi::_a); // 同じ数字の2回の繰り返し`


// int_pair の任意の回数の繰り返し

`qi::rule<std::string::iterator, int(void), qi::space_type> int_pairs = *int_pair;`




また複数の rule の固まりを grammar としてまとめることもできる。



```cpp
template<typename Iterator>

struct mygrammar : qi::grammar<Iterator, A1, A2, A3> // <b>start_rule の template 引数と一致すること</b>

{

    mygrammar() : mygrammar::base_type(start_rule, name)

    {

        start_rule = /* */;

        /* 他の rule の定義 */

    }

    qi::rule<Iterator, A1, A2, A3> start_rule;

    /* 他の rule の宣言 */

};
```

###逆引き

<h4>空白等を読み飛ばしたい</h4>
phrase_parse() と Skipper を使う。rule や grammar を使う場合は Skipper の型を指定する必要があることに注意すること。



```cpp
#include <iostream>

#include <string>

#include <boost/spirit/include/qi.hpp>


namespace qi = boost::spirit::qi;


std::string s("   123");

std::string::iterator first = s.begin(), last = s.end();


qi::rule<std::string::iterator, int(), <b>qi::space_type</b>> rule = qi::int_; // Skipper の型指定


bool success = qi::<b>phrase_parse</b>( // phrase_parse() を使用

    first,

    last,

    rule,

    <b>qi::space</b>            // Skipper この場合は任意の空白

                          // 勝手に繰り返し呼び出されるので繰り返し分を明示的に指定する必要はない

);

if (success) { std::cout << "OK" << std::endl; } // OK が出力される
```

<h4>特定の文字列で終了する部分まで読み出したい</h4>
文字列 "end" までの任意の文字列("end" を含まない)を読み出したい場合は以下のようなルールを用いれば良い。読み飛ばしたい場合は qi::omit を使えばよい。



```cpp
*(qi::char_ - qi::lit("end")) >> qi::lit("end")
```

<h4>デフォルト値を与えたい</h4>
例えば文字列 "value:" に続いて数値がある場合はその数値を、ない場合はデフォルト値 42 を返したい場合は以下のように qi::attr を使用すればよい。省略された場合にさらに数値が続く場合は省略されているか否かが判別できずにうまくいかない（場合が多い）ので注意。



```cpp
qi::lit("value:") >> (qi::int_ | <b>qi::attr</b>(42) )
```

<h4>条件によって構文解析を途中で失敗させたい</h4>
通常は何もせず常に成功するプリミティブ qi::eps （※特定のタイミングでセマンティックアクションを実行させたい場合等に使う）に遅延評価される引数を与えることで実現できる。



```cpp
namespace phx = boost::phoenix;

int n;

// 読み出した整数が 42 以外の時だけ成功する

qi::rule<> rule = qi::int_[phx::ref(n) = qi::_1] >> <b>qi::eps</b>(phx::ref(n) != 42);
```

<h4>ある範囲全体の結果を文字列として得たい</h4>
例えば改行で終端される空白区切りの文字列を得たい場合、



```cpp
(*qi::graph % qi::char_(' ')) >> qi::lit_('\n')
```

をルールとすると空白を除いた文字列が得られることになるが場合によっては空白を含む文字列全体を得たい場合があるかもしれない。あるいは、単純に構成すると文字列のリスト(std::vector<std::string>)が属性の型となってしまうが欲しいのはリストではなく文字列である場合もあるだろう。こうした場合、qi::raw ディレクティブを使うのが簡単である。



```cpp
#include <iostream>

#include <string>

#include <boost/spirit/include/qi.hpp>
```

`namespace qi = boost::spirit::qi;`


`std::string s("a b c\n");`

`std::string::iterator first = s.begin(), last = s.end();`

`std::string value;`


`bool success = qi::parse(`

`    first,`

`    last,`

`    <b>qi::raw</b>[(*qi::graph % qi::lit(' '))] >> qi::lit('\n'),`

`    value`

`);`

`if (success) { std::cout << value << std::endl; } // a b c が出力される`



