# Regex++ template class reference.

*Copyright (c) 1998-2001*

*Dr John Maddock*

*Permission to use, copy, modify, distribute and sell this software and its documentation for any purpose is hereby granted without fee, provided that the above copyright notice appear in all copies and that both that copyright notice and this permission notice appear in supporting documentation.
Dr John Maddock makes no representations about the suitability of this software for any purpose.
It is provided "as is" without express or implied warranty.*

---

## <a id="regbase">class regbase</a>

```cpp
#include boost/regex.hpp>
```

`regbase` クラスは `reg_expression` のためのテンプレート引数に依存しない基底クラスである。
唯一の公開メンバは 列挙型の値 `flag_type` であり、これは正規表現がどのように解釈されるかを決定する

```cpp
class regbase
{
public:
   enum flag_type_
   {
      escape_in_lists = 1,                          // '\\' special inside [...] 
      char_classes = escape_in_lists << 1,          // [[:CLASS:]] allowed 
      intervals = char_classes << 1,                // {x,y} allowed 
      limited_ops = intervals << 1,                 // all of + ? and | are normal characters 
      newline_alt = limited_ops << 1,               // \n is the same as | 
      bk_plus_qm = newline_alt << 1,                // uses \+ and \? 
      bk_braces = bk_plus_qm << 1,                  // uses \{ and \} 
      bk_parens = bk_braces << 1,                   // uses \( and \) 
      bk_refs = bk_parens << 1,                     // \d allowed 
      bk_vbar = bk_refs << 1,                       // uses \| 
      use_except = bk_vbar << 1,                    // exception on error 
      failbit = use_except << 1,                    // error flag 
      literal = failbit << 1,                       // all characters are literals 
      icase = literal << 1,                         // characters are matched regardless of case 
      nocollate = icase << 1,                       // don't use locale specific collation 

      basic = char_classes | intervals | limited_ops | bk_braces | bk_parens | bk_refs,
      extended = char_classes | intervals | bk_refs,
      normal = escape_in_lists | char_classes | intervals | bk_refs | nocollate,
      emacs = bk_braces | bk_parens | bk_refs | bk_vbar,
      awk = extended | escape_in_lists,
      grep = basic | newline_alt,
      egrep = extended | newline_alt,
      sed = basic,
      perl = normal
   }; 
   `typedef` `unsigned` `int` flag_type;
};
```

列挙型 `regbase::flag_type` は正規表現のコンパイルのための構文規則を決定する。
それぞれのフラグは以下のような作用を持つ: 

- `regbase::escape_in_lists`
	- 文字集合の中で "\" を使うことを認める。
		文字集合の中の文字、例えば [\]] は "]" のみを含む文字集合を表している。
		もしこのフラグが設定されていなければ、"\" は文字集合の中では通常の文字として扱われる。
- `regbase::char_classes`
	- このビットが設定されているとき、文字クラス [:クラス名:] を文字集合宣言の中 で使うことを認める。
		例えば [[:word:]] は文字クラス "word"に属する全ての文字の集合を表している。
- `regbase::intervals`
	- このビットが設定されているとき、
		繰り返し回数の範囲指定を使うことを認める。
		例えば "a{2,4}" は文字 a が2回以上4回以下繰り返されることを表している。
- `regbase::limited_ops`
	- このビットが設定されているとき、"+"、 "?" そして "|" はあらゆる状況で通常の文字として扱われる。
- `regbase::newline_alt`
	- このビットが設定されているとき、改行文字 "\n" は排他演算子 "|"と同じ作用を持つ。
- `regbase::bk_plus_qm`
	- このビットが設定されているとき、"\+" は1回以上の繰り返しを表す。
		そして "\?" は0回か1回の繰り返しを表す。
		このビットが設定されていないときは、代わりに "+" と "?" が使われる。
- `regbase::bk_braces`
	- このビットが設定されているとき、 "\{" と "\}" が繰り返しの回数指定に使われ、 "{" と "}" は通常の文字として扱われる。
		これはデフォルトとは反対の動作である。
- `regbase::bk_parens`
	- このビットが設定されているとき、 "\(" と "\)" が子表現のグループ化に使われ、 "(" と ")" は通常の文字として扱われる。
		これはデフォルトとは反対の動作である。
- `regbase::bk_refs`
	- このビットが設定されているとき、後方参照が許される。
- `regbase::bk_vbar`
	- このビットが設定されているとき、 "\|" が排他演算子を表し、 "|" は通常の文字として扱われる。
		これはデフォルトとは反対の動作である。
- `regbase::use_except`
	- このビットが設定されているとき、 [`bad_expression`](#bad_expression) 例外がエラー時に発生する。
		このフラグを使うことは賛成されない。
		なぜなら `reg_expression` はエラーの際、常に例外を発生させるだろう。
- `regbase::failbit`
	- もし `regbase::use_except` が設定されていなければ、エラー時にこのビットが設定される。
		使う前に、正規表現が妥当かどうかを見るためにこのビットをチェックすべきである。
- `regbase::literal`
	- 文字列中の全ての文字はリテラルとして扱われる。
		特殊文字や、エスケープシーケンスは存在しない。
- `regbase::icase`
	- 文字列中の全ての文字は、大文字/小文字の区別なく一致する。
- `regbase::nocollate`
	- 文字集合宣言の中で、文字範囲を扱うときに、ロケールに特殊な一致は不可能になる。
		例えば、このビットが設定されているとき、 [a-c] という表現は a, b そして c という文字にロケールにかかわらず一致する。
		このビットが設定されていなければ、 [a-c] は a から c の並びにあるどんな文字にも一致する。
- `regbase::basic`
	- POSIX の基本正規表現構文との互換性をもつ:
		つまり、`char_classes | intervals | limited_ops | bk_braces | bk_parens | bk_refs` のビットを設定する。
- `Regbase::extended`
	- POSIX の拡張正規表現構文との互換性をもつ:
		つまり、 `char_classes | intervals | bk_refs` のビットを設定する。
- `regbase::normal`
	- これはデフォルトの設定である。
		そして多くの人が、ライブラリがこのように動作することを期待している。
		POSIX 拡張構文との互換性をもつが、ロケールに特殊な一致ない。
		そして文字集合宣言の中でのエスケープ文字を使うことが出来る。
		これは `regbase::escape_in_lists | regbase::char_classes | regbase::intervals | regbase::bk_refs | regbase::nocollate` のビットを設定する。
- `regbase::emacs`
	- emacs エディタとの互換性を与える。
		`bk_braces | bk_parens | bk_refs | bk_vbar` と等価である。
- `regbase::awk`
	- Unix のユーティリティ Awk との互換性を与える。
		POSIX 拡張正規表現と同じだが、文字集合の中にエスケープを許す。
		`extended | escape_in_lists` と等価である。
- `regbase::grep`
	- Unix の grep ユーティリティとの互換性を与える。
		POSIX 基本正規表現と同じだが、改行文字と排他演算子は等価である。
		つまり、 `basic | newline_alt` と同じである。
- `regbase::egrep`
	- Unix の egrep ユーティリティとの互換性を与える。
		POSIX 拡張正規表現と同じだが、改行文字と排他演算子は等価である。
		つまり、 `extended | newline_alt` と同じである。
- `regbase::sed`
	- Unix の sed ユーティリティとの互換性を与える。
		POSIX 基本正規表現と同じである。
- `regbase::perl`
	- プログラミング言語 perl との互換性を与える。
		`regbase::normal` と同じである。

---

## <a id="bad_expression">Exception classes.</a>

```cpp
#include <boost/pat_except.hpp>
```

誤った正規表現が現れたときにいつでも、`bad_expression` のインスタンスが投げられる。

```cpp
namespace boost{

class bad_pattern : public std::runtime_error
{
public:
   explicit bad_pattern(const std::string& s) : std::runtime_error(s){};
};

class bad_expression : public bad_pattern
{
public:
   bad_expression(const std::string& s) : bad_pattern(s) {}
};


} // namespace boost
```

補足: `bad_pattern` クラスは全てのパターンマッチングでの例外の基底クラスであり、 `bad_expression` はそのひとつである。
`bad_pattern` の基底クラスとして `std::runtime_error ` を選択していることには議論の余地がある。
ライブラリがどう使われるかよるが、例外は論理的エラー(プログラマが与えた正規表現)か、実行時エラー(ユーザが与えた正規表現)のいずれかだろう。

---

## <a id="reg_expression">Class `reg_expression`</a>

```cpp
#include <boost/regex.hpp>
```

テンプレートクラス `reg_expression` は正規表現の解釈とコンパイルをカプセル化している。
このクラスは [`regbase`](#regbase) を継承していて、3つのテンプレートパラメータを持つ。
パラメータは:

- `charT`:
	- 文字型を決定する。
		つまり、 `char` か `wchar_t` のどちらかである。
- `traits`:
	- 文字型の振る舞いを決定する。
		例えば、大文字小文字を考慮して照合するか、文字クラス名を認識するか、などである。
		デフォルトの `traits` クラスが与えられている: [`regex_traits<charT>`](#regex_char_traits) 。
- `Allocator`:
	- allocator クラスは、メモリ割り当てに使われるクラスである。

簡単に使えるように、2つの標準的な `reg_expression` のインスタンスを定義した、2つの typedef がある。
カスタムのアロケータクラスを使いたいのでなければ、これら以外のものを使う必要はないだろう。

```cpp
namespace boost{
template <class charT, class traits = regex_traits<charT>, class Allocator = std::allocator<charT> >
class reg_expression;
typedef reg_expression<char> regex;
typedef reg_expression<wchar_t> wregex;
}
```

`reg_expression` の定義は次の通りである: 
この定義は `basic_string` クラスに厳密に基づいていて、`charT` のコンテナとしての要求を満たしている。

```cpp
namespace boost{
template <class charT, class traits = regex_traits<charT>, class Allocator = std::allocator<charT> >
class reg_expression : public regbase
{
public: 
   // typedefs:
   typedef charT char_type; 
   typedef traits traits_type; 
   // locale_type 
   // placeholder for actual locale type used by the 
   // traits class to localise *this. 
   typedef typename traits::locale_type locale_type; 
   // value_type 
   typedef charT value_type; 
   // reference, const_reference 
   typedef charT& reference; 
   typedef const charT& const_reference; 
   // iterator, const_iterator 
   typedef const charT* const_iterator; 
   typedef const_iterator iterator; 
   // difference_type 
   typedef typename Allocator::difference_type difference_type; 
   // size_type 
   typedef typename Allocator::size_type size_type; 
   // allocator_type 
   typedef Allocator allocator_type; 
   typedef Allocator alloc_type; 
   // flag_type 
   typedef boost::int_fast32_t flag_type; 
public: 
   // constructors 
   explicit reg_expression(const Allocator& a = Allocator()); 
   explicit reg_expression(const charT* p, flag_type f = regbase::normal, const Allocator& a = Allocator()); 
   reg_expression(const charT* p1, const charT* p2, flag_type f = regbase::normal, const Allocator& a = Allocator()); 
   reg_expression(const charT* p, size_type len, flag_type f, const Allocator& a = Allocator()); 
   reg_expression(const reg_expression&); 
   template <class ST, class SA> 
   explicit reg_expression(const std::basic_string<charT, ST, SA>& p, flag_type f = regbase::normal, const Allocator& a = Allocator()); 
   template <class I> 
   reg_expression(I first, I last, flag_type f = regbase::normal, const Allocator& a = Allocator()); 
   ~reg_expression(); 
   reg_expression& operator=(const reg_expression&); 
   reg_expression& operator=(const charT* ptr); 
   template <class ST, class SA> 
   reg_expression& operator=(const std::basic_string<charT, ST, SA>& p); 
   // 
   // assign: 
   reg_expression& assign(const reg_expression& that); 
   reg_expression& assign(const charT* ptr, flag_type f = regbase::normal); 
   reg_expression& assign(const charT* first, const charT* last, flag_type f = regbase::normal); 
   template <class string_traits, class A> 
   reg_expression& assign( 
       const std::basic_string<charT, string_traits, A>& s, 
       flag_type f = regbase::normal); 
   template <class iterator> 
   reg_expression& assign(iterator first, 
                          iterator last, 
                          flag_type f = regbase::normal); 
   // 
   // allocator access: 
   Allocator get_allocator()const; 
   // 
   // locale: 
   locale_type imbue(locale_type l); 
   locale_type getloc()const; 
   // 
   // flags: 
   flag_type getflags()const; 
   // 
   // str: 
   std::basic_string<charT> str()const; 
   // 
   // begin, end: 
   const_iterator begin()const; 
   const_iterator end()const; 
   // 
   // swap: 
   void swap(reg_expression&)throw(); 
   // 
   // size: 
   size_type size()const; 
   // 
   // max_size: 
   size_type max_size()const; 
   // 
   // empty: 
   bool empty()const; 
   unsigned mark_count()const; 
   bool operator==(const reg_expression&)const; 
   bool operator<(const reg_expression&)const; 
};
} // namespace boost 
```

`reg_expression` クラスは次のような公開メンバ関数を持っている:

- `reg_expression(Allocator a = Allocator());`
	- 何の表現ももっていない、`reg_expression` のデフォルトのインスタンスを構築する。
- `reg_expression(charT* p, unsigned f = regbase::normal, Allocator a = Allocator());`
	- 正規表現構文を決定するためのフラグ `f` を使って、ヌル終端文字列 `p` で表された表現から `reg_expression` のインスタンスを構築する。
		利用可能なフラグの値に関しては[regbase](#regbase) を見よ。
- `reg_expression(charT* p1, charT* p2, unsigned f = regbase::normal, Allocator a = Allocator());`
	- 正規表現構文を決定するためのフラグ `f` を使って、入力イテレータ `p1` と `p2` で表された表現から `reg_expression` のインスタンスを構築する。
		利用可能なフラグの値に関しては[regbase](#regbase) を見よ。
- `reg_expression(charT* p, size_type len, unsigned f, Allocator a = Allocator());`
	- 正規表現構文を決定するためのフラグ `f` を使って、長さ `len` の文字列 `p` によって表された表現から `reg_expression` のインスタンスを構築する。
		利用可能なフラグの値に関しては [`regbase`](#regbase) を見よ。
- `template <class ST, class SA> reg_expression(const std::basic_string<charT, ST, SA>& p, boost::int_fast32_t f = regbase::normal, const Allocator& a = Allocator());`
	- 正規表現構文を決定するためのフラグ f を使って、文字列 p によって表された表現から `reg_expression` のインスタンスを構築する。
		利用可能なフラグの値に関しては [`regbase`](#regbase) を見よ。
		注意 - このメンバはコンパイラによっては利用できないかもしれない。
- `template <class I> reg_expression(I first, I last, flag_type f = regbase::normal, const Allocator& a = Allocator());`
	- 正規表現構文を決定するためのフラグ `f` を使って、入力イテレータ `p1` と `p2` で表された表現から `reg_expression` のインスタンスを構築する。
		利用可能なフラグの値に関しては [`regbase`](#regbase) を見よ。
- `reg_expression(const reg_expression&);`
	- コピーコンストラクタ。
		存在する正規表現をコピーする。
- `reg_expression& operator=(const reg_expression&);`
	- 存在する正規表現をコピーする。
- `reg_expression& operator=(const charT* ptr);`
	- assign(ptr) と等価。
- `template <class ST, class SA> reg_expression& operator=(const std::basic_string<charT, ST, SA>& p);`
	- assign(p) と等価。
- `reg_expression& assign(const reg_expression& that);`
	- `that` が持っている正規表現をコピーする。
		もし `that` が有効な正規表現を持っていなければ、 [`bad_expression`](#bad_expression) が発生する。
		`this` ポインタを返す。
- `reg_expression& assign(const charT* p, flag_type f = regbase::normal);`
	- 正規表現構文を決定するためのフラグ `f` を使って、ヌル終端文字列 `p` で表された表現から正規表現をコンパイルする。
		利用可能なフラグの値に関しては [`regbase`](#regbase) を見よ。
		もし `p` が有効な正規表現を持っていなければ [`bad_expression`](#bad_expression) が発生する。
		`this` ポインタを返す。
- `reg_expression& assign(const charT* first, const charT* last, flag_type f = regbase::normal);`
	- 正規表現構文を決定するためのフラグ `f` を使って、入力イテレータ `first-last` で表された表現から正規表現をコンパイルする。
		利用可能なフラグの値に関しては [`regbase`](#regbase) を見よ。
		もし `p` が有効な正規表現を持っていなければ [`bad_expression`](#bad_expression) が発生する。
		`this` ポインタを返す。
- `template <class string_traits, class A> reg_expression& assign(const std::basic_string<charT, string_traits, A>& s, flag_type f = regbase::normal);`
	- 正規表現構文を決定するためのフラグ `f` を使って、文字列 `s` で表された表現から正規表現をコンパイルする。
		利用可能なフラグの値に関しては [`regbase`](#regbase) を見よ。
		もし `p` が有効な正規表現を持っていなければ [`bad_expression`](#bad_expression) が発生する。
		`this` ポインタを返す。
- `template <class iterator>  reg_expression& assign(iterator first, iterator last, flag_type f = regbase::normal);`
	- 正規表現構文を決定するためのフラグ `f` を使って、入力イテレータ `first-last` で表された表現から正規表現をコンパイルする。
		利用可能なフラグの値に関しては [`regbase`](#regbase) を見よ。
		もし `p` が有効な正規表現を持っていなければ [`bad_expression`](#bad_expression) が発生する。
		`this` ポインタを返す。
- `Allocator get_allocator()const;`
	- 正規表現で使われるアロケータを返す。
- `locale_type imbue(const locale_type& l);`
	- 正規表現を特定のロケールに変更し、現在の表現を無効にする。
		もし呼び出しの結果、実在しないメッセージカタログが開かれようとしたら、 `std::runtime_error` が発生するだろう。
- `locale_type getloc()const;`
	- 表現で使われているロケールを返す。
- `flag_type getflags()const;`
	- 現在の表現をコンパイルするのに使われているフラグを返す。
- `std::basic_string<charT> str()const;`
	- 現在の表現を文字列として返す。
- `const_iterator begin()const;`
	- 現在の表現の最初の文字へのポインタを返す。
- `const_iterator end()const;`
	- 現在の表現の最後の文字へのポインタを返す。
- `size_type size()const;`
	- 現在の表現の長さを返す。
- `size_type max_size()const;`
	- 正規表現文字列の最大長を返す。
- `bool empty()const;`
	- オブジェクトが有効な表現を持っていなければ `true` を返す。
- `unsigned mark_count()const;`
	- コンパイルされた正規表現の中の子表現の数を返す。
		これは全体の一致(子表現がゼロ)も含み、常に1以上を返すことに注意せよ。

---

## <a id="regex_char_traits">Class `regex_traits`</a>

```cpp
#include <boost/regex/regex_traits.hpp>
```

*これは正規表現特性クラスの予備的なバージョンであり、変更を必要とする。*

特性クラスの目的は、 `reg_expression` クラスと、それに関連するマッチングアルゴリズムの振る舞いのカスタマイズをより簡単にすることである。
カスタム特性クラスは特殊文字セットを扱うことが出来て、追加の文字クラスを定義する。
例えば、全ての(ユニコード)漢字文字として [[:kanji:]] を定義することが出来る。
このライブラリは3つの特性クラスと、使われているデフォルトのロケールモデルに依存してこの3つのうちのひとつを継承するラッパクラス `regex_traits` を提供している。
`c_regex_traits` クラスは C のグローバルロケールをカプセル化している。
`w32_regex_traits` クラスは Win32 グローバルロケールをカプセル化している(Win32 システム上だけで利用できる)。
`cpp_regex_traits` は C++ のロケールをカプセル化している( `std::locale` がサポートされているときのみ提供される):

```cpp
template <class charT> class c_regex_traits;
template<> class c_regex_traits<char> { /*details*/ };
template<> class c_regex_traits<wchar_t> { /*details*/ };

template <class charT> class w32_regex_traits;
template<> class w32_regex_traits<char> { /*details*/ };
template<> class w32_regex_traits<wchar_t> { /*details*/ };

template <class charT> class cpp_regex_traits;
template<> class cpp_regex_traits<char> { /*details*/ };
template<> class cpp_regex_traits<wchar_t> { /*details*/ };

template <class charT> class regex_traits : public base_type { /*detailts*/ };
```

`base_type` は Win32 システム上では、デフォルトで `w32_regex_traits` である。
そうでなければ、 `c_regex_traits` がデフォルトである。
デフォルトの振る舞いは `BOOST_REGEX_USE_C_LOCALE` (`c_regex_traits` をデフォルトで使うように強制する)、または `BOOST_REGEX_USE_CPP_LOCALE` (`cpp_regex_traits` をデフォルトで使うように強制する) を定義することによって変更できる。
もう一つの選択肢として、特定の特性クラスを `reg_expression` テンプレートに渡すことも出来る。

カスタムの制約クラスのための要求は [ここに記されている](traits_class_ref.md)。

また、カスタムの制約クラスの例が [Christian Engstr](mailto:christian.engstrom@glindra.org) によって提供されている。
*iso8859_1_regex_traits.cpp* 及び *iso8859_1_regex_traits.hpp* を見よ。
より詳細は *readme file* を見よ。

---

## <a id="reg_match">Class `match_results`</a>

```cpp
#include <boost/regex.hpp>
```

正規表現は、多くの単純なパターンマッチングのアルゴリズムとはことなる。
なぜなら全体での一致を発見し、子表現の一致を作ることも出来るからである: 
それぞれの子表現は、パターンの中で、丸括弧 (...) の組により区切られている。
子表現の一致をユーザに報告するための方法もある:
これは、 子表現の一致の集合の索引としての機能をもつ `match_results` クラスにより実現されている。
それぞれの子表現の一致は `sub_match` 型のオブジェクトの中に格納されている。

```cpp
// 
// class sub_match: 
// denotes one sub-expression match. 
//
template <class iterator>
struct sub_match
{
   typedef typename std::iterator_traits<iterator>::value_type       value_type;
   typedef typename std::iterator_traits<iterator>::difference_type  difference_type;
   typedef iterator                                                  iterator_type;

   iterator first;
   iterator second;
   bool matched;

   operator std::basic_string<value_type>()const;

   bool operator==(const sub_match& that)const;
   bool operator !=(const sub_match& that)const;
   difference_type length()const;
};

// 
// class match_results: 
// contains an indexed collection of matched sub-expressions. 
// 
template <class iterator, class Allocator = std::allocator<typename std::iterator_traits<iterator>::value_type > > 
class match_results 
{ 
public: 
   typedef Allocator                                                 alloc_type; 
   typedef typename Allocator::template Rebind<iterator>::size_type  size_type; 
   typedef typename std::iterator_traits<iterator>::value_type       char_type; 
   typedef sub_match<iterator>                                       value_type; 
   typedef typename std::iterator_traits<iterator>::difference_type  difference_type; 
   typedef iterator                                                  iterator_type; 
   explicit match_results(const Allocator& a = Allocator()); 
   match_results(const match_results& m); 
   match_results& operator=(const match_results& m); 
   ~match_results(); 
   size_type size()const; 
   const sub_match<iterator>& operator[](int n) const; 
   Allocator allocator()const; 
   difference_type length(int sub = 0)const; 
   difference_type position(unsigned int sub = 0)const; 
   unsigned int line()const; 
   iterator line_start()const; 
   std::basic_string<char_type> str(int sub = 0)const; 
   void swap(match_results& that); 
   bool operator==(const match_results& that)const; 
   bool operator<(const match_results& that)const; 
};
typedef match_results<const char*> cmatch;
typedef match_results<const wchar_t*> wcmatch; 
typedef match_results<std::string::const_iterator> smatch;
typedef match_results<std::wstring::const_iterator> wsmatch; 
```

`match_results` クラスは正規表現に一致したものを報告するのに使われる。
これはマッチングアルゴリズム [`regex_match`](#query_match) と [`regex_search`](#reg_search) を渡されて、 [`regex_grep`](#reg_grep) によってコールバック関数(または関数オブジェクト) にに何が一致したのかを知らせる。
一致判定の為に選ばれるデフォルトのアロケータパラメータは、 `reg_expresion` のデフォルトのアロケータパラメータであることに注意せよ。
`match_results` には次の公開メンバ関数がある: 

- `match_results(Allocator a = Allocator());`
	- アロケータのインスタンス a を使って、 `match_results` のインスタンスを構築する。
- `match_results(const match_results& m);`
	- コピーコンストラクタ
- `match_results& operator=(const match_results& m);`
	- 代入演算子。
- `const sub_match<iterator>& operator[](size_type n) const;`
	- 一致したものを返す。
		`n` が 0 なら文字列全体を、 `n` が 1 なら最初の子表現を表している。
		(訳注: 以下、その数字に対応する子表現を表している)
- `Allocator& allocator()const;`
	- このクラスで使われているアロケータを返す。
- `difference_type length(unsigned int sub = 0);`
	- 一致した子表現の長さを返す。
		デフォルトでは全体の一致の長さを返す。
		要するにこれは、`operator [](sub).second - operator[](sub).first` と等価である。
- `difference_type position(unsigned int sub = 0);`
	- 一致した子表現の位置を返す。
		デフォルトでは全体の一致の位置を返す。
		戻り値は、文字列の先頭からの相対的な一致の位置である。
- `unsigned int line()const;`
	- 一致が起こった行番号を返す。
		行番号の先頭は 0 でなく 1 である。
		`operator[](0)` より前の改行文字の数に 1 を加えたものと等価である。
- `iterator line_start()const;`
	- 一致が起こった行の先頭を示すイテレータを返す。
- `size_type size()const;`
	- 一致の中に、子表現 0 (全体の一致) も含めて、いくつの子表現が存在するかを返す。
		もし検索の操作で一致が見つからなかったとき、これは重要である。
		一致が起こったかどうか決定するのに、 [`regex_search`](#reg_search) / [`regex_match`](#query_match) からの戻り値を使わなければならない。

メンバ関数 `operator[]` は更に説明が必要である。
これは `sub_match<iterator>` 型の構造体への const の参照を返す。
`sub_match<iterator>` は次の公開メンバを持っている:

- `typedef typename std::iterator_traits<iterator>::value_type value_type;`
	- イテレータによって指されている型。
- `typedef typename std::iterator_traits<iterator>::difference_type difference_type;`
	- 二つのイテレータの違いを表す型。
- `typedef iterator iterator_type;`
	- イテレータの型。
- `iterator first`
	- 一致の先頭の位置を示すイテレータ。
- `iterator second`
	- 一致の終端の位置を示すイテレータ。
- `bool matched`
	- この子表現が一致したものの中にあるかを示す bool 値。
- `difference_type length()const;`
	- 子表現の一致の長さを返す。
- `operator std::basic_string<value_type> ()const;`
	- 子表現の一致を `std::basic_string<>` のインスタンスに変換する。
		このメンバは存在しないか、コンパイラに依存して、より限られて存在するかのどちらかだろう、ということに注意せよ。

`operator []` は情報を返す子表現を表す引数として整数値を取る。
引数は次のような特殊な値を取りうる:

- `-2`
	- 一致の終端から、入力された文字列の終端までの全てを返す。
		これは perl での `$'` と等価である。
		もしこれが null 文字列なら: `first == second ` かつ `matched == false` である。
- `-1`
	- 入力された文字列の先頭から(または、もし grep の操作であれば最後の一致の終端から)この一致の先頭までの全てを返す。
		perl での `$\`` と等価である。
		もしこれが null 文字列なら: `first == second ` かつ `matched == false.` である。
- `0`
	- 一致したもの全体を返す。
		perl での `$&` と等価である。
		パラメータ `matched` は常に `true` である。
- `0 < N < size()`
	- 子表現 N に一致したものを返す。
		もしこの子表現が何も一致していなかったら、 `matched == false ` そうでなければ `matched == true` である。
- `N < -2 or N >= size()`
	- 範囲外の存在しない子表現を表している。
		「空の」一致を返す。
		つまり、 `first == last ` かつ `matched == false.` である。

アロケータのパラメータと同様に、 `match_results<>` もまたイテレータ型をもち、これはどんなイテレータの組み合わせも、それが双方向イテレータであるなら、与えられた正規表現で検索することが出来る、ということに注意せよ。

---

## <a id="query_match">Algorithm `regex_match`</a>

```cpp
#include <boost/regex.hpp>
```

アルゴリズム `regex_match` は与えられた正規表現が、一組の双方向イテレータによって表されるシーケンスに一致するかを決定する。
このアルゴリズムは以下のように定義されている。
*入力シーケンス全体と一致したときのみ結果が `true` であることに注意せよ。*
この関数の主要な使い道は、入力データの検証である:

```cpp
template <class iterator, class Allocator, class charT, class traits, class Allocator2>
bool regex_match(iterator first, 
                 iterator last, 
                 match_results<iterator, Allocator>& m, 
                 const reg_expression<charT, traits, Allocator2>& e, 
                 unsigned flags = match_default);
```

ライブラリは次の簡易版も定義している。
これは `const charT*` 型か、或いは `const std::basic_string<>&` 型を一組のイテレータの代わりにとる。
(コンパイラによってはこれらの簡易版は利用できないかもしれないこと、或いは限られた形でしか利用できないかもしれないことに注意せよ):

```cpp
template <class charT, class Allocator, class traits, class Allocator2>
bool regex_match(const charT* str, 
                 match_results<const charT*, Allocator>& m, 
                 const reg_expression<charT, traits, Allocator2>& e, 
                 unsigned flags = match_default)

template <class ST, class SA, class Allocator, class charT, class traits, class Allocator2>
bool regex_match(const std::basic_string<charT, ST, SA>& s, 
                 match_results<typename std::basic_string<charT, ST, SA>::const_iterator, Allocator>& m, 
                 const reg_expression<charT, traits, Allocator2>& e, 
                 unsigned flags = match_default);
```

最後に、ただ true か false を返すだけで、何が一致したかに関与しない簡易版がある。

```cpp
template <class iterator, class Allocator, class charT, class traits, class Allocator2>
bool regex_match(iterator first, 
                 iterator last, 
                 const reg_expression<charT, traits, Allocator2>& e, 
                 unsigned flags = match_default);

template <class charT, class Allocator, class traits, class Allocator2>
bool regex_match(const charT* str, 
                 const reg_expression<charT, traits, Allocator2>& e, 
                 unsigned flags = match_default)

template <class ST, class SA, class Allocator, class charT, class traits, class Allocator2>
bool regex_match(const std::basic_string<charT, ST, SA>& s, 
                 const reg_expression<charT, traits, Allocator2>& e, 
                 unsigned flags = match_default);
```

主要版(訳注:簡易版ではない定義)の関数のパラメータは次の通りである。

- `iterator first`
	- 一致させる範囲の先頭を示す。
- `iterator last`
	- 一致させる範囲の終端を示す。
- `match_results<iterator, Allocator>& m`
	- 何が一致したかを報告するための `match_results` のインスタンス。
		関数を抜けるときに、もし一致が起こっていたら `m[0]` は一致した文字列の全体を表す。
		`m[0].first` は `first` と等しく、 `m[0].second` は `last` より少ないか、等しい。
		`m[1]` は最初の子表現、 `m[2]` は2番目の子表現を示し、以下それが続く。
		もし一致が起こらなければ、 `m[0].first = m[0].second = last` である。
	- `match_results` 構造体はイテレータのみを保持し、文字列を保持していないので、 `regex_match` に渡されるイテレータと文字列は、その結果が使われる限り有効でなければならないことに注意せよ。
		このため、決して一時的文字列オブジェクトを `regex_match` に渡してはならない。
- `const reg_expression<charT, traits, Allocator2>& e`
	- 一致判定につかう正規表現を持つ。
- `unsigned flags = match_default`
	- 一致に使われるセマンティクスを決定する。
		ひとつ以上の [`match_flags`](#match_type) 列挙子の組み合わせである。

`regex_match` は一致が起こらなければ `false` を、起これば `true` を返す。
一致は、 `first` で始まり、 `last` で終わるときにだけ起こる。
例えば、次の例: *example* は FTP レスポンスの処理である。

```cpp
#include <stdlib.h> 
#include <boost/regex.hpp> 
#include <string> 
#include <iostream> 

using namespace boost; 

regex expression("([0-9]+)(\\-| |$)(.*)"); 

// process_ftp: 
// on success returns the ftp response code, and fills 
// msg with the ftp response message. 
int process_ftp(const char* response, std::string* msg) 
{ 
   cmatch what; 
   if(regex_match(response, what, expression)) 
   { 
      // what[0] contains the whole string 
      // what[1] contains the response code 
      // what[2] contains the separator character 
      // what[3] contains the text message. 
      if(msg) 
         msg->assign(what[3].first, what[3].second); 
      return std::atoi(what[1].first); 
   } 
   // failure did not match 
   if(msg) 
      msg->erase(); 
   return -1; 
}
```

<a id="match_type">アルゴリズムに渡されるフラグパラメータの値は次の値のひとつ以上の組み合わせでなければならない。</a>

- `match_default`
	- デフォルトの値である。
		`first` は行の先頭、バッファの先頭、そして(可能なら)単語の先頭を表す。
		`last` は行の最後、バッファの最後、そして(可能なら)単語の最後を表す。
		子表現ドット "." は改行文字とヌル文字の両方にも一致する。
- `match_not_bol`
	- このフラグが設定されているとき、 `first` は新しい行の先頭を表さない。
- `match_not_eol`
	- このフラグが設定されているとき、 `last` は行の最後を表さない。
- `match_not_bob`
	- このフラグが設定されているとき、 `first` はバッファの始まりを表さない。
- `match_not_eob`
	- このフラグが設定されているとき、 `last` はバッファの終わりを表さない。
- `match_not_bow`
	- このフラグが設定されているとき、 `first` は単語の先頭に一致することが出来ない。
- `match_not_eow`
	- このフラグが設定されているとき、 `last` は単語の終わりに一致することが出来ない。
- `match_not_dot_newline`
	- このフラグが設定されているとき、ドット表現 "." は改行文字に一致しない
- `match_not_dot_null`
	- このフラグが設定されているとき、ドット表現 "." はヌル文字に一致しない。
- `match_prev_avail`
	- このフラグが設定されているとき、 `*--first` は有効な表現であり、これらを検証するのに前の文字の値が使われるので `match_not_bol` と `match_not_bow` は作用しない。
- `match_any`
	- このフラグが設定されているとき、可能な限り長く一致するのではなく、一致した最初の文字列が返される。
		このフラグは一致を発見するのにかかる時間を非常に削減するが、何が一致するかは未定義である。
- `match_not_null`
	- このフラグが設定されているとき、正規表現はヌル文字列には決して一致しない。
- `match_continuous`
	- このフラグが設定されているとき、grep 操作の間に、一連の一致はそれぞれ、以前の一致が終了した場所から始まる。
- `match_partial`
	- このフラグが設定されているとき、正規表現アルゴリズムは部分一致: [`partial matches`](#partial_matches) を報告する。
		これは入力文字列の最後のひとつ以上の文字が、正規表現の接頭辞(訳注:入力文字列の最後の任意の部分と、正規表現の前からいくつかが一致するということ)に一致するということである。

---

## <a id="reg_search">Algorithm `regex_search`</a>

```cpp
#include <boost/regex.hpp>
```

アルゴリズム `regex_search` は一組の双方向イテレータによって示される範囲を、与えられた正規表現で検索する。
このアルゴリズムは、一致がその位置で始まる可能性があるときのみ、一致を検証することで、検索時間を削減するために様々な探索的方法を利用する。
このアルゴリズムは次のように定義されている。

```cpp
template <class iterator, class Allocator, class charT, class traits, class Allocator2>
bool regex_search(iterator first, 
                iterator last, 
                match_results<iterator, Allocator>& m, 
                const reg_expression<charT, traits, Allocator2>& e, 
                unsigned flags = match_default);
```

ライブラリは次の簡易版も定義している。
これは 一組のイテレータの代わりに、 `const charT*` 型か、或いは `const std::basic_string<>&` 型をとる。
(コンパイラによってはこれらの簡易版は利用できないかもしれないこと、或いは限られた形でしか利用できないかもしれないことに注意せよ):

```cpp
template <class charT, class Allocator, class traits, class Allocator2>
bool regex_search(const charT* str, 
                match_results<const charT*, Allocator>& m, 
                const reg_expression<charT, traits, Allocator2>& e, 
                unsigned flags = match_default);

template <class ST, class SA, class Allocator, class charT, class traits, class Allocator2>
bool regex_search(const std::basic_string<charT, ST, SA>& s, 
                match_results<typename std::basic_string<charT, ST, SA>::const_iterator, Allocator>& m, 
                const reg_expression<charT, traits, Allocator2>& e, 
                unsigned flags = match_default);
```

主要版(訳注:簡易版ではない定義)の関数のパラメータは次の通りである。

- `iterator first`
	- 検索範囲の開始位置。
- `iterator last`
	- 検索範囲の終了位置。
- `match_results<iterator, Allocator>& m`
	- 何が一致したかを報告するための `match_results` のインスタンス。
		関数を抜けるときに、もし一致が起こっていたら `m[0]` は一致した文字列の全体を表す。
		`m[0].first` は `first` と等しく、 `m[0].second` は `last` より少ないか、等しい。
		`m[1]` は最初の子表現、 `m[2]` は2番目の子表現を示し、以下それが続く。
		もし一致が起こらなければ、 `m[0].first = m[0].second = last` である。
	- `match_results` 構造体はイテレータのみを保持し、文字列を保持していないので、 `regex_search` に渡されるイテレータと文字列は、その結果が使われる限り有効でなければならないことに注意せよ。
		このため、決して一時的文字列オブジェクトを `regex_search` に渡してはならない。
- `const reg_expression<charT, traits, Allocator2>& e`
	- 検索に使われる正規表現。
- `unsigned flags = match_default`
	- 何が一致するかを決定するフラグ。
		[`match_flags`](#match_type) 列挙子のひとつ以上の組み合わせ。

次の例: *example* は文字列の形でファイルの内容を受け取り、ファイルの中の全ての C++ クラス宣言を検索する。
コードは `std::string` がどのように実装されていようが動く。
例えば 不連続の保持(訳注: コンテナの要素がメモリ上で連続していないこと)を使っている SGI rope クラスでこれが動くように簡単に変更できる。

```cpp
#include <string> 
#include <map> 
#include <boost/regex.hpp> 

// purpose: 
// takes the contents of a file in the form of a string 
// and searches for all the C++ class definitions, storing 
// their locations in a map of strings/int's 
typedef std::map<std::string, int, std::less<std::string> > map_type; 

boost::regex expression("^(template[[:space:]]*<[^;:{]+>[[:space:]]*)?(class|struct)[[:space:]]*(\\<\\w+\\>([[:blank:]]*\\([^)]*\\))?[[:space:]]*)*(\\<\\w*\\>)[[:space:]]*(<[^;:{]+>[[:space:]]*)?(\\{|:[^;\\{()]*\\{)"); 

void IndexClasses(map_type& m, const std::string& file) 
{ 
   std::string::const_iterator start, end; 
   start = file.begin(); 
   end = file.end(); 
      boost::match_results<std::string::const_iterator> what; 
   unsigned int flags = boost::match_default; 
   while(regex_search(start, end, what, expression, flags)) 
   { 
      // what[0] contains the whole string 
      // what[5] contains the class name. 
      // what[6] contains the template specialisation if any. 
      // add class name and position to map: 
      m[std::string(what[5].first, what[5].second) + std::string(what[6].first, what[6].second)] = 
                what[5].first - file.begin(); 
      // update search position: 
      start = what[0].second; 
      // update flags: 
      flags |= boost::match_prev_avail; 
      flags |= boost::match_not_bob; 
   } 
}
```

---

## <a id="reg_grep">Algorithm `regex_grep`</a>

```cpp
#include <boost/regex.hpp>
```

`Regex_grep` は、双方向イテレータの範囲を最初から最後まで検索し、与えられた正規表現との全ての(重ならない)一致を発見する。
この関数は次のように宣言されている:

```cpp
template <class Predicate, class iterator, class charT, class traits, class Allocator>
unsigned int regex_grep(Predicate foo, 
                        iterator first, 
                        iterator last, 
                        const reg_expression<charT, traits, Allocator>& e, 
                        unsigned flags = match_default)
```

ライブラリは次の簡易版も定義している。
これは 一組のイテレータの代わりに、 `const charT*` 型か、或いは `const std::basic_string<>&` 型をとる。
(コンパイラによってはこれらの簡易版は利用できないかもしれないこと、或いは限られた形でしか利用できないかもしれないことに注意せよ):

```cpp
template <class Predicate, class charT, class Allocator, class traits>
unsigned int regex_grep(Predicate foo, 
              const charT* str, 
              const reg_expression<charT, traits, Allocator>& e, 
              unsigned flags = match_default);

template <class Predicate, class ST, class SA, class Allocator, class charT, class traits>
unsigned int regex_grep(Predicate foo, 
              const std::basic_string<charT, ST, SA>& s, 
              const reg_expression<charT, traits, Allocator>& e, 
              unsigned flags = match_default);
```

主要版(訳注:簡易版ではない定義)の関数のパラメータは次の通りである。


- `foo`
	- 述語関数オブジェクトや関数ポインタ。
		より詳しい情報は下を見よ。
- `first`
	- 検索範囲の先頭。
- `last`
	- 検索範囲の末端。
- `e`
	- 検索のための正規表現。
- `flags`
	- どのように一致が行われるかを決定するフラグ。
		[`match_flags`](#match_type) 列挙子のひとつ。

このアルゴリズムは、正規表現 e に対する、重ならない全ての一致を発見する。
それぞれの一致で、 [`match_results<iterator, Allocator>`](#reg_match) 構造体に情報が入る。
これは何が一致したかについての情報を保持し、述語関数 `foo` を呼び出し、ひとつの引数として `match_results<iterator,Allocator>` を渡す。
もし述語関数が `true` を返せば grep 操作は引き続き行われる。
そうでなければ grep 操作はそれ以降の一致を検索することなく終了する。
この関数は、発見された一致の数を返す。

述語関数の一般的な形式は以下の通りである: 

```cpp
struct grep_predicate
{
   bool operator()(const match_results<iterator_type, expression_type::alloc_type>& m);
};
```

例えば、正規表現 `a*b` は文字列 `aaaaab` の中でひとつの一致を発見し、文字列 `aaabb` の中に二つの一致を発見する。

このアルゴリズムは、grep の実装よりも多くのことに使うことが出来ることを覚えておくこと。
述語関数があるので、やりたいことはそこで何でも出来る。
grep ユーティリティは結果を画面に出力する。
別のプログラムは正規表現に基づいてファイルを索引付けし、ブックマークの集合をリストに蓄えることが出来る。
テキストファイル変換ユーティリティはファイルに出力する。
再帰的な解析のために、ひとつの `regex_grep` の結果を別の `regex_grep` に連鎖することさえ可能である。

*Example*: `regex_search` の例を、代わりに `regex_grep` を使って変換している:

```cpp
#include <string> 
#include <map> 
#include <boost/regex.hpp> 

// IndexClasses: 
// takes the contents of a file in the form of a string 
// and searches for all the C++ class definitions, storing 
// their locations in a map of strings/int's 

typedef std::map<std::string, int, std::less<std::string> > map_type; 

boost::regex expression("^(template[[:space:]]*<[^;:{]+>[[:space:]]*)?" 
                 "(class|struct)[[:space:]]*(\\<\\w+\\>([[:blank:]]*\\([^)]*\\))?[[:space:]]*)*(\\<\\w*\\>)" 
                 "[[:space:]]*(<[^;:{]+>[[:space:]]*)?(\\{|:[^;\\{()]*\\{)"); 

class IndexClassesPred 
{ 
   map_type& m; 
   std::string::const_iterator base; 
public: 
   IndexClassesPred(map_type& a, std::string::const_iterator b) : m(a), base(b) {} 
   bool operator()(const match_results<std::string::const_iterator, regex::alloc_type>& what) 
   { 
      // what[0] contains the whole string 
      // what[5] contains the class name. 
      // what[6] contains the template specialisation if any. 
      // add class name and position to map: 
      m[std::string(what[5].first, what[5].second) + std::string(what[6].first, what[6].second)] = 
                what[5].first - base; 
      return true; 
   } 
}; 

void IndexClasses(map_type& m, const std::string& file) 
{ 
   std::string::const_iterator start, end; 
   start = file.begin(); 
   end = file.end(); 
   regex_grep(IndexClassesPred(m, start), start, end, expression); 
}
```

*Example*: グローバルコールバック関数呼び出しに `regex_grep` を使っている:

```cpp
#include <string> 
#include <map> 
#include <boost/regex.hpp> 

// purpose: 
// takes the contents of a file in the form of a string 
// and searches for all the C++ class definitions, storing 
// their locations in a map of strings/int's 

typedef std::map<std::string, int, std::less<std::string> > map_type; 

boost::regex expression("^(template[[:space:]]*<[^;:{]+>[[:space:]]*)?(class|struct)[[:space:]]*(\\<\\w+\\>([[:blank:]]*\\([^)]*\\))?[[:space:]]*)*(\\<\\w*\\>)[[:space:]]*(<[^;:{]+>[[:space:]]*)?(\\{|:[^;\\{()]*\\{)"); 

map_type class_index; 
std::string::const_iterator base;

bool grep_callback(const boost::match_results<std::string::const_iterator, boost::regex::alloc_type>& what) 
{ 
   // what[0] contains the whole string 
   // what[5] contains the class name. 
   // what[6] contains the template specialisation if any. 
   // add class name and position to map: 
   class_index[std::string(what[5].first, what[5].second) + std::string(what[6].first, what[6].second)] = 
                what[5].first - base; 
   return true; 
} 

void IndexClasses(const std::string& file) 
{ 
   std::string::const_iterator start, end; 
   start = file.begin(); 
   end = file.end(); 
   base = start; 
   regex_grep(grep_callback, start, end, expression, match_default); 
}

```

*Example*: `regex_grep` を使ってクラスメンバ関数を呼び出している。
標準ライブラリアダプタ `std::mem_fun` と `std::bind1st` はメンバ関数を述語関数に変換するために使われている。

```cpp
#include <string> 
#include <map> 
#include <boost/regex.hpp> 
#include <functional> 

// purpose: 
// takes the contents of a file in the form of a string 
// and searches for all the C++ class definitions, storing 
// their locations in a map of strings/int's 

typedef std::map<std::string, int, std::less<std::string> > map_type; 

class class_index 
{ 
   boost::regex expression; 
   map_type index; 
   std::string::const_iterator base; 
   bool grep_callback(boost::match_results<std::string::const_iterator, boost::regex::alloc_type> what); 
public: 
   void IndexClasses(const std::string& file); 
   class_index() 
      : index(), 
        expression("^(template[[:space:]]*<[^;:{]+>[[:space:]]*)?" 
                   "(class|struct)[[:space:]]*(\\<\\w+\\>([[:blank:]]*\\([^)]*\\))?" 
                   "[[:space:]]*)*(\\<\\w*\\>)[[:space:]]*(<[^;:{]+>[[:space:]]*)?" 
                   "(\\{|:[^;\\{()]*\\{)" 
                   ){} 
}; 

bool class_index::grep_callback(boost::match_results<std::string::const_iterator, boost::regex::alloc_type> what) 
{ 
   // what[0] contains the whole string 
   // what[5] contains the class name. 
   // what[6] contains the template specialisation if any. 
   // add class name and position to map: 
   index[std::string(what[5].first, what[5].second) + std::string(what[6].first, what[6].second)] = 
               what[5].first - base; 
   return true; 
} 

void class_index::IndexClasses(const std::string& file) 
{ 
   std::string::const_iterator start, end; 
   start = file.begin(); 
   end = file.end(); 
   base = start; 
   regex_grep(std::bind1st(std::mem_fun(&class_index::grep_callback), this), 
              start, 
              end, 
              expression); 
} 
```

*最後に*、 C++ Builder のユーザは C++ Builder のクロージャ型をコールバック引数として使うことが出来る。

```cpp
#include <string> 
#include <map> 
#include <boost/regex.hpp> 
#include <functional> 

// purpose: 
// takes the contents of a file in the form of a string 
// and searches for all the C++ class definitions, storing 
// their locations in a map of strings/int's 

typedef std::map<std::string, int, std::less<std::string> > map_type; 
class class_index 
{ 
   boost::regex expression; 
   map_type index; 
   std::string::const_iterator base; 
   typedef boost::match_results<std::string::const_iterator, boost::regex::alloc_type> arg_type; 
   bool grep_callback(const arg_type& what); 
public: 
   typedef bool (__closure* grep_callback_type)(const arg_type&); 
   void IndexClasses(const std::string& file); 
   class_index() 
      : index(), 
        expression("^(template[[:space:]]*<[^;:{]+>[[:space:]]*)?" 
                   "(class|struct)[[:space:]]*(\\<\\w+\\>([[:blank:]]*\\([^)]*\\))?" 
                   "[[:space:]]*)*(\\<\\w*\\>)[[:space:]]*(<[^;:{]+>[[:space:]]*)?" 
                   "(\\{|:[^;\\{()]*\\{)" 
                   ){} 
}; 

bool class_index::grep_callback(const arg_type& what) 
{ 
   // what[0] contains the whole string    
// what[5] contains the class name.    
// what[6] contains the template specialisation if any.    
// add class name and position to map:    
index[std::string(what[5].first, what[5].second) + std::string(what[6].first, what[6].second)] = 
               what[5].first - base; 
   return true; 
} 

void class_index::IndexClasses(const std::string& file) 
{ 
   std::string::const_iterator start, end; 
   start = file.begin(); 
   end = file.end(); 
   base = start; 
   class_index::grep_callback_type cl = &(this->grep_callback); 
   regex_grep(cl, 
            start, 
            end, 
            expression); 
}
```

---

## <a id="reg_format">Algorithm `regex_format`</a>

```cpp
#include <boost/regex.hpp>
```

アルゴリズム `regex_format` は一致の結果を受け取り、 [書式指定子](format_string.md#format_string) に基づいて新しい文字列を作成する。
`regex_format` は検索と置換の操作の為に使うことが出来る:

```cpp
template <class OutputIterator, class iterator, class Allocator, class charT>
OutputIterator regex_format(OutputIterator out,
                            const match_results<iterator, Allocator>& m,
                            const charT* fmt,
                            unsigned flags = 0);

template <class OutputIterator, class iterator, class Allocator, class charT>
OutputIterator regex_format(OutputIterator out,
                            const match_results<iterator, Allocator>& m,
                            const std::basic_string<charT>& fmt,
                            unsigned flags = 0);</pre>
```

ライブラリは次のような `regex_format` の簡易版も用意している。
これは結果を、イテレータに出力するのではなく、文字列として直接返す。
(注意: この簡易版はコンパイラによっては使えないか、使えても機能が限られているかもしれない。)

```cpp
template <class iterator, class Allocator, class charT>
std::basic_string<charT> regex_format
                                 (const match_results<iterator, Allocator>& m, 
                                  const charT* fmt,
                                  unsigned flags = 0);

template <class iterator, class Allocator, class charT>
std::basic_string<charT> regex_format
                                 (const match_results<iterator, Allocator>& m, 
                                  const std::basic_string<charT>& fmt,
                                  unsigned flags = 0);
```

主要版の関数に渡されるパラメータは次の通りである。

- `OutputIterator out`
	- 出力イテレータ型。
		出力文字列はこのイテレータに送られる。
		通常は `std::ostream_iterator` である。
- `const match_results<iterator, Allocator>& m`
	- `match_result<>` のインスタンス。
		これは上の一致判定アルゴリズムのうちのひとつから得られ、何が一致したを表す。
- `const charT* fmt`
	- 一致がどのように新しい文字列に変換されるかを決定する書式指定子。
- `unsigned flags`
	- 書式指定子がどのように解釈されるかを示す、オプションのフラグ。

<a id="format_flags">書式のフラグは以下のように定義されている。</a>

- `format_all`
	- すべての構文のオプションを可能にする。
		(拡張正規表現構文に加え perl-like の構文も可能)。
- `format_sed`
	- sed-like の構文のみ許す。
- `format_perl`
	- perl-like の構文のみ許す。
- `format_no_copy`
	- [`regex_merge`](#reg_merge) 操作の間に、一致しなかった部分を出力文字列にコピーできなくする。
- `format_first_only`
	- このフラグが設定されているときは、最初の一致だけが置換される。
		(`regex_merge` だけに適用される。)

書式指定子の構文(そして利用可能なオプション)は [書式指定子](format_string.md#format_string) でより完全に書かれている。

---

## <a id="reg_merge">Algorithm `regex_merge`</a>

```cpp
#include <boost/regex.hpp>
```

アルゴリズム `regex_merge` は [`regex_grep`](#reg_grep) と [`regex_format`](#reg_format) を組み合わせたものである。
つまり、文字列の最初から最後まで、正規表現との全ての一致を発見し、その一致それぞれに対して、文字列を書式化するために [`regex_format`](#reg_format) を呼び出し、結果を出力イテレータに送る。
一致しなかった部分のテキストはフラグパラメータ [`format_no_copy`](#format_flags) が設定されていなければ、変更されることなく出力される。
[`format_first_only`](#format_flags) が設定されていれば、全ての一致ではなく、最初の一致だけが置換される。

```cpp
template <class OutputIterator, class iterator, class traits, class Allocator, class charT>
OutputIterator regex_merge(OutputIterator out, 
                          iterator first,
                          iterator last,
                          const reg_expression<charT, traits, Allocator>& e, 
                          const charT* fmt, 
                          unsigned int flags = match_default);

template <class OutputIterator, class iterator, class traits, class Allocator, class charT>
OutputIterator regex_merge(OutputIterator out, 
                           iterator first,
                           iterator last,
                           const reg_expression<charT, traits, Allocator>& e, 
                           std::basic_string<charT>& fmt, 
                           unsigned int flags = match_default);
```

このライブラリは次のような `regex_merge` の簡易版も定義している。
これは、イテレータに出力するのではなく、結果を文字列として直接返す。
(注意：コンパイラによってはこの簡易版は利用できないか、利用できても限られた形でしか使えない。)

```cpp
template <class traits, class Allocator, class charT>
std::basic_string<charT> regex_merge(const std::basic_string<charT>& text,
                                     const reg_expression<charT, traits, Allocator>& e, 
                                     const charT* fmt, 
                                     unsigned int flags = match_default);

template <class traits, class Allocator, class charT>
std::basic_string<charT> regex_merge(const std::basic_string<charT>& text,
                                     const reg_expression<charT, traits, Allocator>& e, 
                                     const std::basic_string<charT>& fmt, 
                                     unsigned int flags = match_default);
```

主要版の関数に渡されるパラメータは次の通りである:

- `OutputIterator out`
	- 出力イテレータ型。
		通常は `std::ostream_iterator` である。
- `iterator first`
	- 検索するテキストの範囲の最初。
		(双方向イテレータ)
- `iterator last`
	- 検索するテキストの範囲の最後。
		(双方向イテレータ)
- `const reg_expression<charT, traits, Allocator>& e`
	- 検索のための正規表現
- `const charT* fmt`
	- 一致した部分のテキストに適用される書式指定子。
- `unsigned int flags = match_default`
	- 正規表現がどのように一致するかを決定するフラグ。
		[`match_flags`](#match_type) を見よ。
		また、書式指定子がどのように解釈されるかを決定するフラグ。
        [`format_flags`](#format_flags) を見よ。

次 *例* は C/C++ のソースコードをインプットとして受け取り、構文が強調された HTML コードを出力する。

```cpp example
#include <fstream>
#include <sstream>
#include <string>
#include <iterator>
#include <boost/regex.hpp>
#include <fstream>
#include <iostream>

// purpose:
// takes the contents of a file and transform to
// syntax highlighted code in html format

boost::regex e1, e2;
extern const char* expression_text;
extern const char* format_string;
extern const char* pre_expression;
extern const char* pre_format;
extern const char* header_text;
extern const char* footer_text;

void load_file(std::string& s, std::istream& is)
{
   s.erase();
   s.reserve(is.rdbuf()->in_avail());
   char c;
   while(is.get(c))
   {
      if(s.capacity() == s.size())
         s.reserve(s.capacity() * 3);
      s.append(1, c);
   }
}

int main(int argc, const char** argv)
{
   try{
   e1.assign(expression_text);
   e2.assign(pre_expression);
   for(int i = 1; i < argc; ++i)
   {
      std::cout << "Processing file " << argv[i] << std::endl;
      std::ifstream fs(argv[i]);
      std::string in;
      load_file(in, fs);
      std::string out_name(std::string(argv[i]) + std::string(".htm"));
      std::ofstream os(out_name.c_str());
      os << header_text;
      // strip '<' and '>' first by outputting to a
      // temporary string stream
      std::ostringstream t(std::ios::out | std::ios::binary);
      std::ostream_iterator<char, char> oi(t);
      boost::regex_merge(oi, in.begin(), in.end(), e2, pre_format);
      // then output to final output stream
      // adding syntax highlighting:
      std::string s(t.str());
      std::ostream_iterator<char, char> out(os);
      boost::regex_merge(out, s.begin(), s.end(), e1, format_string);
      os << footer_text;
   }
   }
   catch(...)
   { return -1; }
   return 0;
}

extern const char* pre_expression = "(<)|(>)|\\r";
extern const char* pre_format = "(?1<)(?2>)";


const char* expression_text = // preprocessor directives: index 1
                              "(^[[:blank:]]*#(?:[^\\\\\\n]|\\\\[^\\n[:punct:][:word:]]*[\\n[:punct:][:word:]])*)|"
                              // comment: index 2
                              "(//[^\\n]*|/\\*.*?\\*/)|"
                              // literals: index 3
                              "\\<([+-]?(?:(?:0x[[:xdigit:]]+)|(?:(?:[[:digit:]]*\\.)?[[:digit:]]+(?:[eE][+-]?[[:digit:]]+)?))u?(?:(?:int(?:8|16|32|64))|L)?)\\>|"
                              // string literals: index 4
                              "('(?:[^\\\\']|\\\\.)*'|\"(?:[^\\\\\"]|\\\\.)*\")|"
                              // keywords: index 5
                              "\\<(__asm|__cdecl|__declspec|__export|__far16|__fastcall|__fortran|__import"
                              "|__pascal|__rtti|__stdcall|_asm|_cdecl|__except|_export|_far16|_fastcall"
                              "|__finally|_fortran|_import|_pascal|_stdcall|__thread|__try|asm|auto|bool"
                              "|break|case|catch|cdecl|char|class|const|const_cast|continue|default|delete"
                              "|do|double|dynamic_cast|else|enum|explicit|extern|false|float|for|friend|goto"
                              "|if|inline|int|long|mutable|namespace|new|operator|pascal|private|protected"
                              "|public|register|reinterpret_cast|return|short|signed|sizeof|static|static_cast"
                              "|struct|switch|template|this|throw|true|try|typedef|typeid|typename|union|unsigned"
                              "|using|virtual|void|volatile|wchar_t|while)\\>"
                              ;

const char* format_string = "(?1<font color=\"#008040\">$&</font>)"
                            "(?2<I><font color=\"#000080\">$&</font></I>)"
                            "(?3<font color=\"#0000A0\">$&</font>)"
                            "(?4<font color=\"#0000FF\">$&</font>)"
                            "(?5<B>$&</B>)"

const char* header_text = "<HTML>\n<HEAD>\n"
                          "<TITLE>Auto-generated html formated source</TITLE>\n"
                          "<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=windows-1252\">\n"
                          "</HEAD>\n"
                          "<BODY LINK=\"#0000ff\" VLINK=\"#800080\" BGCOLOR=\"#ffffff\">\n"
                          "<P> </P>\n<PRE>";

const char* footer_text = "</PRE>\n</BODY>\n\n";
```

---

## <a id="regex_split">Algorithm `regex_split`</a>

```cpp
#include <boost/regex.hpp>
```

アルゴリズム `regex_split` は perl の spilit 操作と似たようなことをおこなう。
そして3種類のオーバロードの形で提供されている。

```cpp
template <class OutputIterator, class charT, class Traits1, class Alloc1, class Traits2, class Alloc2>
std::size_t regex_split(OutputIterator out, 
                        std::basic_string<charT, Traits1, Alloc1>& s, 
                        const reg_expression<charT, Traits2, Alloc2>& e,
                        unsigned flags,
                        std::size_t max_split);

template <class OutputIterator, class charT, class Traits1, class Alloc1, class Traits2, class Alloc2>
std::size_t regex_split(OutputIterator out, 
                        std::basic_string<charT, Traits1, Alloc1>& s, 
                        const reg_expression<charT, Traits2, Alloc2>& e,
                        unsigned flags = match_default);

template <class OutputIterator, class charT, class Traits1, class Alloc1>
std::size_t regex_split(OutputIterator out, 
                        std::basic_string<charT, Traits1, Alloc1>& s);
```

それぞれの関数は出力のための出力イテレータ、入力文字列を受け取る。
正規表現が、印付けされた子表現を含まないとき、アルゴリズムは正規表現と一致しないテキストのそれぞれの部分をひとつの文字列として、出力イテレータに書き込む。
もし正規表現が印付けされた子表現を含んでいれば、一致が発見される度に、印付けされた子表現それぞれに対してひとつの文字列が、出力イテレータに書き込まれる。
`max_split` 以上の文字列は出力イテレータに書き込まれない。
関数を抜ける前に、処理された全ての入力は文字列 s から削除される(もし `max_split` まで到達しなければ、全ての `s` が削除される)。
出力イテレータに書き込まれた文字列の数を返す。
もしパラメータ `max_split` が特定されていなければ、デフォルトでは `UINT_MAX` が使われる。
正規表現が特定されていなければ、デフォルトでは "\s+" が使われ、空白によって分割される。
(訳注: この関数は、正規表現が子表現を持っているかどうかで、動作が大きく異なる。
正規表現が子表現を持っていないとき、この関数はまさに、 perl の split と同様に動作する。
正規表現が子表現を持っているとき、その一致した子表現が出力イテレータに書き込まれる。)

*Example*: the following function will split the input string into a series of tokens, and remove each token from the string `s`:

```cpp
unsigned tokenise(std::list<std::string>& l, std::string& s)
{
   return boost::regex_split(std::back_inserter(l), s);
}
```

*Example*: the following short program will extract all of the URL's from a html file, and print them out to `cout`:

```cpp
#include <list>
#include <fstream>
#include <iostream>
#include <boost/regex.hpp>

boost::regex e("<\\s*A\\s+[^>]*href\\s*=\\s*\"([^\"]*)\"",
               boost::regbase::normal | boost::regbase::icase);

void load_file(std::string& s, std::istream& is)
{
   s.erase();
   //
   // attempt to grow string buffer to match file size,
   // this doesn't always work...
   s.reserve(is.rdbuf()-&gtin_avail());
   char c;
   while(is.get(c))
   {
      // use logarithmic growth stategy, in case
      // in_avail (above) returned zero:
      if(s.capacity() == s.size())
         s.reserve(s.capacity() * 3);
      s.append(1, c);
   }
}


int main(int argc, char** argv)
{
   std::string s;
   std::list<std::string> l;

   for(int i = 1; i < argc; ++i)
   {
      std::cout << "Findings URL's in " << argv[i] << ":" << std::endl;
      s.erase();
      std::ifstream is(argv[i]);
      load_file(s, is);
      boost::regex_split(std::back_inserter(l), s, e);
      while(l.size())
      {
         s = *(l.begin());
         l.pop_front();
         std::cout << s << std::endl;
      }
   }
   return 0;
}
```

---

## <a id="partial_matches">Partial Matches</a>

一致フラグ `match_partial` は次のアルゴリズムに渡すことが出来る:
[`regex_match`](#reg_match), [`regex_search`](#reg_search), そして [`regex_grep`](#reg_grep) 。
これは、全体一致と同様に部分一致が発見されることを表す。
部分一致は、入力テキストの終端に1文字以上の一致があるが、それが正規表現の全体と一致しているのではない、というものである(テキストが終了したかもしれないが、まだ続くかもしれない、というような時だ)。
部分一致は通常、入力データの検証(キーボードが押される度にそれぞれの文字を検証する)、とか、メモリ(やメモリマップドファイルにさえ)に読み込むには長すぎるようなテキスト、または不確定な長さのテキスト(例えばテキストの元はソケットや、それに似たようなものかもしれない)を検索するときである。
部分一致と全体一致は次の表に示されるように、区別されている(変数 `M` は `regex_match`, `regex_search`, `regex_grep` によって結果を書き込まれた `match_results<>` のインスタンスを表している)。

| Result | `M[0].matched` | `M[0].first` | `M[0].second` |
|---|---|---|---|
| 一致無し | False | 未定義 | 未定義 | 未定義 |
| 部分一致 | True | False | 部分一致の先頭 | 部分一致の終端(テキストの終端) |
| 全体一致 | True | True | 全体一致の先頭 | 全体一致の終端 |

*次の例* はユーザがキーを押す度に、テキストが有効なクレジットカードの番号かどうか検証する。
入力された文字は積み上げられた文字列に付け加えられ、 `is_possible_card_number` に渡される。
もしこれが true を返せばテキストは有効なカード番号であり、ユーザインタフェースの OK ボタンが有効になる。
もし false を返せばこれはまだ有効なカードナンバーではないが、更に入力が可能で、ユーザインタフェースの OK ボタンは無効である。
最後にこの手続きで、入力が決して有効な番号にはならないという例外が発生すれば、入力された文字は破棄され、ユーザに適したエラーを表示する。

```cpp
#include <string>
#include <iostream>
#include <boost/regex.hpp>

boost::regex e("(\\d{3,4})[- ]?(\\d{4})[- ]?(\\d{4})[- ]?(\\d{4})");

bool is_possible_card_number(const std::string& input)
{
   //
   // return false for partial match, true for full match, or throw for
   // impossible match based on what we have so far...
   boost::match_results<std::string::const_iterator> what;
   if(0 == boost::regex_match(input, what, e, boost::match_default | boost::match_partial))
   {
      // the input so far could not possibly be valid so reject it:
      throw std::runtime_error("Invalid data entered - this could not possibly be a valid card number");
   }
   // OK so far so good, but have we finished?
   if(what[0].matched)
   {
      // excellent, we have a result:
      return true;
   }
   // what we have so far is only a partial match...
   return false;
}
```

*次の例* では、不定な長さのテキストを含むストリームから入力を受け取る。
この例は単に、ストリームの中に現れる html タグの数を数えるだけである。
テキストはバッファに読み込まれ、同時に一部を検索する。
部分一致が現れれば、その部分一致は、次のひとまとまりのテキストの先頭として次回に検索される: 

```cpp
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <boost/regex.hpp>

// match some kind of html tag:
boost::regex e("<[^>]*>");
// count how many:
unsigned int tags = 0;
// saved position of partial match:
char* next_pos = 0;

bool grep_callback(const boost::match_results<char*>& m)
{
   if(m[0].matched == false)
   {
      // save position and return:
      next_pos = m[0].first;
   }
   else
      ++tags;
   return true;
}

void search(std::istream& is)
{
   char buf[4096];
   next_pos = buf + sizeof(buf);
   bool have_more = true;
   while(have_more)
   {
      // how much do we copy forward from last try:
      unsigned leftover = (buf + sizeof(buf)) - next_pos;
      // and how much is left to fill:
      unsigned size = next_pos - buf;
      // copy forward whatever we have left:
      memcpy(buf, next_pos, leftover);
      // fill the rest from the stream:
      unsigned read = is.readsome(buf + leftover, size);
      // check to see if we've run out of text:
      have_more = read == size;
      // reset next_pos:
      next_pos = buf + sizeof(buf);
      // and then grep:
      boost::regex_grep(grep_callback,
                        buf,
                        buf + read + leftover,
                        e,
                        boost::match_default | boost::match_partial);
   }
}
```

---

*Copyright* [*Dr John Maddock*](mailto:John_Maddock@compuserve.com) *1998-2001 all rights reserved.*

---

*Japanese Translation Copyright (C) 2003 [Kohske Takahashi](mailto:k_takahashi@cppll.jp)*

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。
このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。
また、いかなる目的に対しても、その利用が適していることを関知しない。

