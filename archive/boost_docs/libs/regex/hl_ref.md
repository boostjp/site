# Class RegEx

*Copyright (c) 1998-2001*

*Dr John Maddock*

*Permission to use, copy, modify, distribute and sell this software and its documentation for any purpose is hereby granted without fee, provided that the above copyright notice appear in all copies and that both that copyright notice and this permission notice appear in supporting documentation.
Dr John Maddock makes no representations about the suitability of this software for any purpose.
It is provided "as is" without express or implied warranty.*

---

```cpp
#include <boost/cregex.hpp>
```

クラス `RegEx` は正規表現ライブラリに対する高水準の単純化されたインタフェースを提供する。
このクラスはナロウキャラクタ文字列のみを扱い、正規表現は常に "通常の" 構文に従う。
つまり、標準 POSIX 拡張構文と同じであるが、ロケールに特殊な照合は不可能であり、文字集合宣言の中でのエスケープ文字が許されている。

```cpp
typedef bool (*GrepCallback)(const RegEx& expression);
typedef bool (*GrepFileCallback)(const char* file, const RegEx& expression);
typedef bool (*FindFilesCallback)(const char* file);

class RegEx
{
public:
   RegEx();
   RegEx(const RegEx& o);
   ~RegEx();
   RegEx(const char* c, bool icase = false);
   explicit RegEx(const std::string& s, bool icase = false);
   RegEx& operator=(const RegEx& o);
   RegEx& operator=(const char* p);
   RegEx& operator=(const std::string& s);
   unsigned int SetExpression(const char* p, bool icase = false);
   unsigned int SetExpression(const std::string& s, bool icase = false);
   std::string Expression()const;
   //
   // now matching operators: 
   //
   bool Match(const char* p, unsigned int flags = match_default);
   bool Match(const std::string& s, unsigned int flags = match_default); 
   bool Search(const char* p, unsigned int flags = match_default); 
   bool Search(const std::string& s, unsigned int flags = match_default); 
   unsigned int Grep(GrepCallback cb, const char* p, unsigned int flags = match_default); 
   unsigned int Grep(GrepCallback cb, const std::string& s, unsigned int flags = match_default); 
   unsigned int Grep(std::vector<std::string>& v, const char* p, unsigned int flags = match_default); 
   unsigned int Grep(std::vector<std::string>& v, const std::string& s, unsigned int flags = match_default); 
   unsigned int Grep(std::vector<unsigned int>& v, const char* p, unsigned int flags = match_default); 
   unsigned int Grep(std::vector<unsigned int>& v, const std::string& s, unsigned int flags = match_default); 
   unsigned int GrepFiles(GrepFileCallback cb, const char* files, bool recurse = false, unsigned int flags = match_default); 
   unsigned int GrepFiles(GrepFileCallback cb, const std::string& files, bool recurse = false, unsigned int flags = match_default); 
   unsigned int FindFiles(FindFilesCallback cb, const char* files, bool recurse = false, unsigned int flags = match_default); 
   unsigned int FindFiles(FindFilesCallback cb, const std::string& files, bool recurse = false, unsigned int flags = match_default); 
   std::string Merge(const std::string& in, const std::string& fmt, bool copy = true, unsigned int flags = match_default); 
   std::string Merge(const char* in, const char* fmt, bool copy = true, unsigned int flags = match_default); 
   unsigned Split(std::vector<std::string>& v, std::string& s, unsigned flags = match_default, unsigned max_count = ~0);
   //
   // now operators for returning what matched in more detail: 
   //
   unsigned int Position(int i = 0)const; 
   unsigned int Length(int i = 0)const; 
   bool Matched(int i = 0)const;
   unsigned int Line()const; 
   unsigned int Marks() const; 
   std::string What(int i)const; 
   std::string operator[](int i)const;

   static const unsigned int npos;
};
```

クラス RegEx のメンバ関数は以下のように定義されている:

- `RegEx();`
	- デフォルトコンストラクタ:
		有効な正規表現を持たない `RegEx` のインスタンスを構築する。
- `RegEx(const RegEx& o);`
	- コピーコンストラクタ:
		引数 `o` の全てのプロパティがコピーされる。
- `RegEx(const char* c, bool icase = false);`
	- 正規表現を `c` に設定して、`RegEx` のインスタンスを構築する。
		もし `icase` が `true` なら一致は大文字小文字によらない。
		そうでなければ、大文字小文字を区別して一致が行われる。
		失敗したときは `bad_expression` が投げられる。
- `RegEx(const std::string& s, bool icase = false);`
	- 正規表現を `s` に設定して、`RegEx` のインスタンスを構築する。
		もし `icase` が `true` なら一致は大文字小文字によらない。
		そうでなければ、大文字小文字を区別して一致が行われる。
		失敗したときは `bad_expression` が投げられる。
- `RegEx& operator=(const RegEx& o);`
	- デフォルトの代入演算子
- `RegEx& operator=(const char* p);`
	- 代入演算子。
		`SetExpression(p, false)` を呼び出すのと等価である。
		失敗すれば `bad_expression` が投げられる。
- `RegEx& operator=(const std::string& s);`
	- 代入演算子。
		`SetExpression(s, false)` を呼び出すのと等価である。
		失敗すれば `bad_expression` が投げられる。
- `unsigned int SetExpression(constchar* p, bool icase = false);`
	- 現在の正規表現を `p` に設定する。
		もし `icase` が `true` なら一致は大文字小文字によらない。
		そうでなければ、大文字小文字を区別して一致が行われる。
		失敗したときは `bad_expression` が投げられる。
- `unsigned int SetExpression(const std::string& s, bool icase = false);`
	- 現在の正規表現を `s` に設定する。
		もし `icase` が `true` なら一致は大文字小文字によらない。
		そうでなければ、大文字小文字を区別して一致が行われる。
		失敗したときは `bad_expression` が投げられる。
- `std::string Expression()const;`
	- 現在の正規表現のコピーを返す。
- `bool Match(const char* p, unsigned int flags = match_default);`
	- テキスト `p` に対してマッチフラグ `flags` を使って現在の正規表現の一致判定を行う。
		[match flags](template_class_ref.md#match_type) を見よ。
		正規表現が入力文字列全体と一致すれば `true` を返す。
- `bool Match(const std::string& s, unsigned int flags = match_default) ;`
	- テキスト `s` に対してマッチフラグ `flags` を使って現在の正規表現の一致判定を行う。
		[match flags](template_class_ref.md#match_type) を見よ。
		正規表現が入力文字列全体と一致すれば `true` を返す。
- `bool Search(const char* p, unsigned int flags = match_default);`
	- マッチフラグ `flags` を使って、テキスト `p` のどこかに現在の正規表現との一致があるかを判定する。
		[match flags](template_class_ref.md#match_type) を見よ。
		もし一致が発見されたら `true` を返す。
- `bool Search(const std::string& s, unsigned int flags = match_default) ;`
	- マッチフラグ `flags` を使って、テキスト `s` のどこかに現在の正規表現との一致があるかを判定する。
		[match flags](template_class_ref.md#match_type) を見よ。
		もし一致が発見されたら `true` を返す。
- `unsigned int Grep(GrepCallback cb, const char* p, unsigned int flags = match_default);`
	- マッチフラグ `flags` を使って、テキスト `p` の中にある、現在の正規表現との一致を全て発見する。
		[match flags](template_class_ref.md#match_type)を見よ。
		それぞれの一致が発見されるたびに、コールバック関数 `cb` が `cb(*this)` という形で呼ばれる。
	- どの段階でも、コールバック関数が false を返せば、grep 操作は終了し、そうでなければ、一致がそれ以上発見されなくなるまで続けられる。
		発見された一致の数を返す。
- `unsigned int Grep(GrepCallback cb, const std::string& s, unsigned int flags = match_default);`
	- マッチフラグ `flags` を使って、テキスト `s` の中にある、現在の正規表現との一致を全て発見する。
		[match flags](template_class_ref.md#match_type)を見よ。
		それぞれの一致が発見されるたびに、コールバック関数 `cb` が `cb(*this)` という形で呼ばれる。
	- どの段階でも、コールバック関数が `false` を返せば、`grep` 操作は終了し、そうでなければ、一致がそれ以上発見されなくなるまで続けられる。
		発見された一致の数を返す。
- `unsigned int Grep(std::vector<std::string>& v, const char* p, unsigned int flags = match_default);`
	- マッチフラグ `flags` を使って、テキスト `p` の中にある、現在の正規表現との一致を全て発見する。
		[match flags](template_class_ref.md#match_type)を見よ。
		それぞれの一致のたびに、一致したもののコピーが `v` に送られる。
		発見された一致の数を返す。
- `unsigned int Grep(std::vector<std::string>& v, const std::string& s, unsigned int flags = match_default);`
	- マッチフラグ `flags` を使って、テキスト `s` の中にある、現在の正規表現との一致を全て発見する。
		[match flags](template_class_ref.md#match_type)を見よ。
		それぞれの一致のたびに、一致したもののコピーが `v` に送られる。
		発見された一致の数を返す。
- `unsigned int Grep(std::vector<unsigned int>& v, const char* p, unsigned int flags = match_default);`
	- マッチフラグ `flags` を使って、テキスト `p` の中にある、現在の正規表現との一致を全て発見する。
		[match flags](template_class_ref.md#match_type) を見よ。
		それぞれの一致のたびに、一致したものの開始インデックスが `v` に送られる。発見された一致の数を返す。
- `unsigned int Grep(std::vector<unsigned int>& v, const std::string& s, unsigned int flags = match_default);`
	- マッチフラグ `flags` を使って、テキスト `s` の中にある、現在の正規表現との一致を全て発見する。
		[match flags](template_class_ref.md#match_type) を見よ。
		それぞれの一致のたびに、一致したものの開始インデックスが `v` に送られる。
		発見された一致の数を返す。
- `unsigned int GrepFiles(GrepFileCallback cb, const char* files, bool recurse = false, unsigned int flags = match_default);`
	- マッチフラグ `flags` を使って、ファイル `files` の中にある、現在の正規表現との一致を全て発見する。
		[match flags](template_class_ref.md#match_type) を見よ。
		それぞれの一致が発見されるたびに、コールバック関数 `cb` が呼ばれる。
	- コールバック関数が `false` を返せば、アルゴリズムは現在のファイル、ほかのファイルの中のそれ以降の一致を発見しないで終了する。
	- 引数 `files` はワイルドカード文字 `*` と `?` を含むことが出来る。
		もし引数 `recurse` が `true` なら、一致するファイル名のサブディレクトリも検索する。
	- 発見された一致の総数を返す。
	- ファイル入出力が失敗すれば、 `std::runtime_error` から派生した 例外が投げられるだろう。
- `unsigned int GrepFiles(GrepFileCallback cb, const std::string& files, bool recurse = false, unsigned int flags = match_default);`
	- マッチフラグ `flags` を使って、ファイル `files` の中にある、現在の正規表現との一致を全て発見する。
		[match flags](template_class_ref.md#match_type) を見よ。
		それぞれの一致が発見されるたびに、コールバック関数 `cb` が呼ばれる。
	- コールバック関数が `false` を返せば、アルゴリズムは現在のファイル、ほかのファイルの中のそれ以降の一致を発見しないで終了する。
	- 引数 `files` はワイルドカード文字 `*` と `?` を含むことが出来る。
		もし引数 `recurse` が `true` なら、一致するファイル名のサブディレクトリも検索する。
	- 発見された一致の総数を返す。
	- ファイル入出力が失敗すれば、 `std::runtime_error` から派生した例外が投げられるだろう。
- `unsigned int FindFiles(FindFilesCallback cb, const char* files, bool recurse = false, unsigned int flags = match_default);`
	- マッチフラグ `flags` を使って、 `files` を検索し、現在の正規表現と少なくとも一つの一致を持つ全てのファイルを発見する。
		[match flags](template_class_ref.md#match_type) を見よ。
		それぞれの一致が発見されるたびに、コールバック関数 `cb` が呼ばれる。
	- コールバック関数が `false` を返せば、アルゴリズムはそれ以降のファイルを考慮せずに終了する。
	- 引数 `files` はワイルドカード文字 `*` と `?` を含むことが出来る。
		もし引数 `recurse` が `true` なら、一致するファイル名のサブディレクトリも検索する。
	- 発見されたファイルの総数を返す。
	- ファイル入出力が失敗すれば、 `std::runtime_error` から派生した例外が投げられるだろう。
- `unsigned int FindFiles(FindFilesCallback cb, const std::string& files, bool recurse = false, unsigned int flags = match_default);`
	- マッチフラグ `flags` を使って、 `files` を検索し、現在の正規表現と少なくとも一つの一致を持つ全てのファイルを発見する。
		[match flags](template_class_ref.md#match_type) を見よ。
		それぞれの一致が発見されるたびに、コールバック関数 `cb` が呼ばれる。
	- コールバック関数が `false` を返せば、アルゴリズムはそれ以降のファイルを考慮せずに終了する。
	- 引数 `files` はワイルドカード文字 `*` と `?` を含むことが出来る。
		もし引数 `recurse` が `true` なら、一致するファイル名のサブディレクトリも検索する。
	- 発見されたファイルの総数を返す。
	- ファイル入出力が失敗すれば、 `std::runtime_error` から派生した例外が投げられるだろう。
- `std::string Merge(const std::string& in, const std::string& fmt, bool copy = true, unsigned int flags = match_default);`
	- 検索と置換の操作を行う:
		文字列 `in` を最初から最後まで検索し現在の正規表現との一致を全て発見する。
		一致のたびに、書式文字列 `fmt` で置換を行う。
		何が一致するか、書式文字列がどう扱われるかを決定するために `flags` を利用する。
		もし `copy` が `true` なら入力のうち全ての一致しなかった部分が、変更されることなく出力にコピーされる。
		もしフラグ `format_first_only` が設定されていれば、発見された最初のパターンだけが置換される。
		新しい文字列を返す。
		[書式文字列構文](format_string.md#format_string), [match flags](template_class_ref.md#match_type), [format flags](template_class_ref.md#format_flags) も参考にせよ。
- `std::string Merge(const char* in, const char* fmt, bool copy = true, unsigned int flags = match_default);`
	- 検索と置換の操作を行う:
		文字列 `in` を最初から最後まで検索し現在の正規表現との一致を全て発見する。
		一致のたびに、書式文字列 `fmt` で置換を行う。
		何が一致するか、書式文字列がどう扱われるかを決定するために `flags` を利用する。
		もし `copy` が `true` なら入力のうち全ての一致しなかった部分が、変更されることなく出力にコピーされる。
		もしフラグ `format_first_only` が設定されていれば、発見された最初のパターンだけが置換される。
		新しい文字列を返す。
		[書式文字列構文](format_string.md#format_string), [match flags](template_class_ref.md#match_type), [format flags](template_class_ref.md#format_flags) も参考にせよ。
- `unsigned Split(std::vector<std::string>& v, std::string& s, unsigned flags = match_default, unsigned max_count = ~0);`
	- 入力文字列を分割し、`vector` に送る。
		もし正規表現が印付けされた子表現(訳注: 印付けされた子表現 `marked-expression` とは、正規表現中の `()` で囲まれたものであり、かつ `(?` で始まらないものである。)
		を含んでいなければ、正規表現に一致しなかった入力のそれぞれの部分につき一つの文字列が出力される。
		もし正規表現が印付けされた子表現を含んでいれば、それぞれの一致で印付けされた子表現につき一つの文字列が出力される。
		`max_count` 以上の文字列は出力されない。
		この関数から戻る前に、入力文字列 `s` から、処理された全ての入力を削除する (もし `max_count` に達しなければ、文字列全て)。
		`vector` に送られた文字列の数を返す。
- `unsigned int Position(int i = 0)const;`
	- `i` 番目の子表現が一致したものの位置を返す。
		もし `i = 0` なら、全体の一致の位置を返す。
		もし与えられたインデックスが無効なら、または指定された子表現が一致していなかったら、 `RegEx::npos` を返す。
- `unsigned int Length(int i = 0)const;`
	- `i` 番目の子表現と一致したものの長さを返す。
		もし `i = 0` なら全体の一致の長さを返す。
		もし `i = 0` なら、全体の一致の位置を返す。
		もし与えられたインデックスが無効なら、または指定された子表現が一致していなかったら、 `RegEX::npos` を返す。
- `bool Matched(int i = 0)const;`
	- `i` 番目の子表現が一致していたら `true` を、そうでなければ `false` を返す。
- `unsigned int Line()const;`
	- 一致があった行番号を返す。
		番号は `0` でなく `1` で始まる。
		一致がなければ、 `RegEx::npos` を返す。
- `unsigned int Marks() const;`
	- 正規表現に含まれる、印付けされた子表現の数を返す。
		これはマッチ全体(子表現ゼロ)も含むことに注意すること。
		つまり、戻り値は常に `>= 1` である。
- `std::string What(int i)const;`
	- `i` 番目の子表現に一致したもののコピーを返す。
		もし `i = 0` なら全体の一致のコピーを返す。
		インデックスが無効であったり、指定された子表現が一致していなかったら、 `null` 文字列を返す。
- `std::string operator[](int i)const ;`
	- `what(i);` を返す。
	- 子表現の一致への簡単なアクセスに使うことが出来て、perl-like な利用法を可能にする。

---

*Copyright* [*Dr John Maddock*](mailto:John_Maddock@compuserve.com) *1998-2001 all rights reserved.*

---

*Japanese Translation Copyright (C) 2003 [Kohske Takahashi](mailto:k_takahashi@cppll.jp)*

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。
このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。
また、いかなる目的に対しても、その利用が適していることを関知しない。

