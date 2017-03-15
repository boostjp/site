# 構文解析
**本稿は記述途中です。**

[Boost Spirit](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/index.html) ライブラリ、特にその中の [Qi](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/spirit/qi.html) を用いることにより構文解析器を作成することが可能である。

文法、アクションを記述したファイルを元に C/C++ ソースを生成する yacc や bison といった伝統的なパーサジェネレータとは異なり、Spirit Qi では C++ 内で文法、アクションの記述を完結させることができる。また、対象とする文法も文脈自由文法のような伝統的なクラスではなく解析表現文法(PEG: Parsing Expression Grammar)である(一般に解析表現文法は自然言語の解析には適しておらずコンピュータ言語の解析に適している)。


## インデックス
- [1 API](#api)
	- [1.1 入力を全て消費したかを確認する](#check-all-consume)
	- [1.2 空白等を読み飛ばす](#skip)
	- [1.3 解析された値を受け取る](#get-parsed-result)
- 2 ルール
	- [2.1 プリミティブ](#primitive)
	- [2.2 ディレクティブ](#directive)
	- [2.3 演算子](#operator)
	- [2.4 セマンティックアクション](#semantic-action)
	- [2.5 非終端記号](#nonterminal)
- [3 逆引き](#reverse-reference)
	- [3.1 空白等を読み飛ばしたい](#reverse-skip)
	- [3.2 特定の文字列で終了する部分まで読み出したい](#reverse-find)
	- [3.3 デフォルト値を与えたい](#reverse-default-value)
	- [3.4 条件によって構文解析を途中で失敗させたい](#reverse-check-condition)
	- [3.5 ある範囲全体の結果を文字列として得たい](#reverse-as-string)


## <a name="api" href="#api">API</a>

構文解析の実施は `parse()` 関数、あるいは `phrase_parse()` 関数を呼び出すことによって行う。`parse()` 関数と `phrase_parse()` 関数の違いは、`phrase_parse()` が空白等の読み飛ばし(後述する`Skipper`)を行う一方、`parse()` 関数は読み飛ばしを行わない点である。`phrase_parse()` については[空白等を読み飛ばす](#skip)を参照。

```cpp
namespace boost { namespace spirit { namespace qi {
template <typename Iterator, typename Expr>
bool parse(
        Iterator& first
      , Iterator last
      , const Expr& expr);

template <typename Iterator, typename Expr
      , typename Attr1, typename Attr2, ..., typename AttrN>
bool parse(
        Iterator& first
      , Iterator last
      , const Expr& expr
      , Attr1& attr1, Attr2& attr2, ..., AttrN& attrN);
}}}
```

`parse()`関数の引数・戻り値は、以下を意味する：

| 引数・戻り値 | 説明 |
|--------------|------|
| 戻り値       | 解析が成功したかどうか。<br/>入力が余っている場合でも解析が完了した場合は `true` を返す。 |
| `first`      | 非 `const` 参照で受け、かつ、値が変更されるため `s.begin()` 等は直接渡せない |
| `last`       | 終端のイテレータ。参照ではなく値であるため、`s.end()`の戻り値を直接渡せる |
| `expr`       | ルール(文法部分) 後述　この場合は1つの整数 |
| `attrN`      | 読み取った値の格納先 |

```cpp
#include <iostream>
#include <string>
#include <boost/spirit/include/qi.hpp>

namespace qi = boost::spirit::qi;

std::string s("123 456");
std::string::iterator first = s.begin(), last = s.end();
bool success = qi::parse(
    first,
    last,
    qi::int_
);
if (success) { std::cout << "OK" << std::endl; } // OK が出力される
```

### <a name="check-all-consume" href="#check-all-consume">1.1 入力を全て消費したかを確認する</a>
`parse()` 関数、`phrase_parse()` 関数の第1引数であるイテレータへの参照は、解析中に更新されていく。そのため構文解析中に入力が全て消費されたか確認したい場合は、第2引数に渡した値と比較すれば良い。

```cpp
#include <iostream>
#include <string>
#include <boost/spirit/include/qi.hpp>

namespace qi = boost::spirit::qi;

std::string s("123 456");
std::string::iterator first = s.begin(), last = s.end();
bool success = qi::parse(
    first,
    last,
    qi::int_
);
if (success && first == last) { std::cout << "OK" << std::endl; } // OK は出力されない

s = "123"; first = s.begin(); last = s.end();
success = qi::parse(first, last, qi::int_);
if (success && first == last) { std::cout << "OK" << std::endl; } // OK が出力される
```


### <a name="skip" href="#skip">1.2 空白等を読み飛ばす</a>
前述の通り `phrase_parse()` 関数を用いる。関数呼び出しの際にどのような内容を読み飛ばすかを第4引数にルールの形で指定する(`Skipper` と呼ばれる)。非終端記号（後述）を使用している場合は、その非終端記号の型に `Skipper` の型を指定してやる必要があることに注意（FAQ）。

```cpp
namespace boost { namespace spirit { namespace qi {

template <typename Iterator, typename Expr, typename Skipper>
bool phrase_parse(
        Iterator& first
      , Iterator last
      , Expr const& expr
      , Skipper const& skipper
      , BOOST_SCOPED_ENUM(skip_flag) post_skip = skip_flag::postskip);

template <typename Iterator, typename Expr, typename Skipper
      , typename Attr1, typename Attr2, ..., typename AttrN>
bool phrase_parse(
        Iterator& first
      , Iterator last
      , Expr const& expr
      , Skipper const& skipper
      , Attr1& attr1, Attr2& attr2, ..., AttrN& attrN);

}}}
```

| 引数・戻り値 | 説明 |
|--------------|------|
| 戻り値       | 解析が成功したかどうか。<br/>入力が余っている場合でも解析が完了した場合は `true` を返す。 |
| `first`      | 非 `const` 参照で受け、かつ、値が変更されるため `s.begin()` 等は直接渡せない |
| `last`       | 終端のイテレータ。参照ではなく値であるため、`s.end()`の戻り値を直接渡せる |
| `expr`       | ルール(文法部分) 後述　この場合は1つの整数 |
| `skipper`    | 読み飛ばす条件 |
| `attrN`      | 読み取った値の格納先 |

```cpp
#include <iostream>
#include <string>
#include <boost/spirit/include/qi.hpp>

namespace qi = boost::spirit::qi;

std::string s("   123");
std::string::iterator first = s.begin(), last = s.end();
bool success = qi::phrase_parse(
    first,
    last,
    qi::int_,
    qi::space // Skipper この場合は任意の空白
              // 勝手に繰り返し呼び出されるので繰り返し分を明示的に指定する必要はない
);
if (success) { std::cout << "OK" << std::endl; } // OK が出力される

first = s.begin();
success = qi::parse(first, last, qi::int_);
if (success) { std::cout << "OK" << std::endl; } // 最初の空白で失敗するため OK は出力されない
```


### <a name="get-parsed-result" href="#get-parsed-result">1.3 解析された値を受け取る</a>
`parse()` 関数、`phrase_parse()` 関数のいずれも追加で読み取った値を受け取る変数を渡すことができる。複数の値を読み取る場合は複数の変数を渡すことができる。

```cpp
#include <iostream>
#include <string>
#include <boost/spirit/include/qi.hpp>

namespace qi = boost::spirit::qi;

std::string s("123 456");
std::string::iterator first = s.begin(), last = s.end();
int n1, n2;
bool success = qi::phrase_parse(
    first,
    last,
    qi::int_ >> qi::int_, // 2つの整数
    qi::space,
	n1, n2                // 読み取った値の格納先
);
if (success) { // OK: 123, 456 が出力される
    std::cout << "OK: " << n1 << ", " << n2 << std::endl;
}
```


## <a name="rule" href="#rule">2 ルール</a>
ルールはプリミティブ、ディレクティブ、演算子を組み合わせることによって表現される。


### <a name="primitive" href="#primitive">2.1 プリミティブ</a>
- 文字を読むプリミティブのリストについては [Character Parsers](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/spirit/qi/quick_reference/qi_parsers/char.html) を参照。
- 数値を読むプリミティブのリストについては [Numeric Parsers](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/spirit/qi/quick_reference/qi_parsers/numeric.html) を参照。
- 文字列を読むプリミティブのリストについては [String Parsers](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/spirit/qi/quick_reference/qi_parsers/string.html) を参照。
- バイナリ値を読むプリミティブのリストについては [Binary Parsers](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/spirit/qi/quick_reference/qi_parsers/binary.html) を参照。
- 補助的なプリミティブのリストについては [Auxiliary Parsers](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/spirit/qi/quick_reference/qi_parsers/auxiliary.html) を参照。

**※後で適当に丸めて翻訳して入れる**


### <a name="directive" href="#directive">2.2 ディレクティブ</a>
- ディレクティブのリストは [Parser Directives](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/spirit/qi/quick_reference/qi_parsers/directive.html) を参照。

**※後で翻訳して入れる**


### <a name="operator" href="#operator">2.3 演算子</a>
- 演算子のリストは [Parser Operators](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/spirit/qi/quick_reference/qi_parsers/operator.html) を参照。
- 属性（読み取る値）の型については [Compound Attribute Rules](http://www.boost.org/doc/libs/release/libs/spirit/doc/html/spirit/qi/quick_reference/compound_attribute_rules.html) を参照。 

**※後で翻訳して入れる**


### <a name="semantic-action" href="#semantic-action">セマンティックアクション</a>


### <a name="nonterminal" href="#nonterminal">非終端記号</a>
`rule`型を用いることで、ルールに名前をつけることができる。

```cpp
// Iterator の型以外は省略可能で、順序も自由
qi::rule<
    std::string::iterator, // 解析対象の Iterator の型 ※しばしば template 引数
    int(void),             // 属性の型 ※関数型として指定し戻り値の型が読み取る値 ※省略可能
    qi::locals<int>,       // ローカル変数の型 ※省略可能
    qi::space_type         // Skipper の型 ※省略可能　Skipper を使いたい時には忘れず指定すること
                           // ※指定しなくともコンパイルできてしまうが望み通りの挙動とならない
> int_pair;
int_pair %= qi::int_[qi::_a = qi::_1] >> qi::int_(qi::_a); // 同じ数字の2回の繰り返し

// int_pair の任意の回数の繰り返し
qi::rule<std::string::iterator, int(void), qi::space_type> int_pairs = *int_pair;
```

また複数の `rule` の固まりを `grammar` としてまとめることもできる。


```cpp
template <typename Iterator>
struct mygrammar : qi::grammar<Iterator, A1, A2, A3> // start_rule の template 引数と一致すること
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


## <a name="reverse-reference" href="#reverse-reference">3 逆引き</a>

### <a name="reverse-skip" href="#reverse-skip">3.1 空白等を読み飛ばしたい</a>
`phrase_parse()` と `Skipper` を使う。`rule`型 や `grammar`型 を使う場合は `Skipper` の型を指定する必要があることに注意すること。

```cpp
#include <iostream>
#include <string>
#include <boost/spirit/include/qi.hpp>

namespace qi = boost::spirit::qi;

std::string s("   123");
std::string::iterator first = s.begin(), last = s.end();

qi::rule<std::string::iterator, int(), qi::space_type> rule = qi::int_; // Skipper の型指定

bool success = qi::phrase_parse( // phrase_parse() を使用
    first,
    last,
    rule,
    qi::space // Skipper この場合は任意の空白
              // 勝手に繰り返し呼び出されるので繰り返し分を明示的に指定する必要はない
);
if (success) { std::cout << "OK" << std::endl; } // OK が出力される
```
* qi::space_type[color ff0000]
* qi::phrase_parse[color ff0000]
* qi::space[color ff0000]


### <a name="reverse-find" href="#reverse-find">3.2 特定の文字列で終了する部分まで読み出したい</a>
文字列 `"end"` までの任意の文字列(`"end"` を含まない)を読み出したい場合は以下のようなルールを用いれば良い。読み飛ばしたい場合は `qi::omit` ディレクティブを使えばよい。

```cpp
*(qi::char_ - qi::lit("end")) >> qi::lit("end")
```


### <a name="reverse-default-value" href="#reverse-default-value">3.3 デフォルト値を与えたい</a>
例えば文字列 `"value:"` に続いて数値がある場合はその数値を、ない場合はデフォルト値 `42` を返したい場合は以下のように `qi::attr` を使用すればよい。省略された場合にさらに数値が続く場合は省略されているか否かが判別できずにうまくいかない（場合が多い）ので注意。

```cpp
qi::lit("value:") >> (qi::int_ | qi::attr(42) )
```
* attr[color ff0000]


### <a name="reverse-check-condition" href="#reverse-check-condition">3.4 条件によって構文解析を途中で失敗させたい</a>
通常は何もせず常に成功するプリミティブ `qi::eps` （※特定のタイミングでセマンティックアクションを実行させたい場合等に使う）に遅延評価される引数を与えることで実現できる。

```cpp
namespace phx = boost::phoenix;
int n;
// 読み出した整数が 42 以外の時だけ成功する
qi::rule<> rule = qi::int_[phx::ref(n) = qi::_1] >> qi::eps(phx::ref(n) != 42);
```
* eps[color ff0000]


### <a name="reverse-as-string" href="#reverse-as-string">3.5 ある範囲全体の結果を文字列として得たい</a>
例えば改行で終端される空白区切りの文字列を得たい場合、

```cpp
(*qi::graph % qi::char_(' ')) >> qi::lit_('\n')
```

をルールとすると空白を除いた文字列が得られることになるが場合によっては空白を含む文字列全体を得たい場合があるかもしれない。あるいは、単純に構成すると文字列のリスト(`std::vector<std::string>`)が属性の型となってしまうが欲しいのはリストではなく文字列である場合もあるだろう。こうした場合、`qi::raw` ディレクティブを使うのが簡単である。

```cpp
#include <iostream>
#include <string>
#include <boost/spirit/include/qi.hpp>

namespace qi = boost::spirit::qi;

std::string s("a b c\n");
std::string::iterator first = s.begin(), last = s.end();
std::string value;

bool success = qi::parse(
    first,
    last,
    qi::raw[(*qi::graph % qi::lit(' '))] >> qi::lit('\n'),
    value
);
if (success) { std::cout << value << std::endl; } // a b c が出力される
```
* qi::raw[color ff0000]


