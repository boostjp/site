# Regex++, Appendices.

*Copyright (c) 1998-2001*

*Dr John Maddock*

*Permission to use, copy, modify, distribute and sell this software and its documentation for any purpose is hereby granted without fee, provided that the above copyright notice appear in all copies and that both that copyright notice and this permission notice appear in supporting documentation.
Dr John Maddock makes no representations about the suitability of this software for any purpose.
It is provided "as is" without express or implied warranty.*

---

### <a name="implementation">Appendix 1: Implementation notes</a>

これは boost ライブラリへ regex++ を導入した最初のものであり、 regex++ 2.x に基づいている。
以前のバージョンからの変更の完全なリストについては changes.txt を見よ。
Win32 地域化モデル (Win32 におけるデフォルトのライブラリ構築) が使われているときのみ、POSIX スタイルの等価クラスが正しいことを保証される、という点を除けば、機能的なバグは見つかっていない。

C++ 信者はこのコードをいくつかの点で馬鹿げていると考えるであろう。
特にアルゴリズムのいくつかでは goto が使われている。
コードは、再帰的な実装に変更することで、よりきれいにすることができる。
その場合は、おそらくより遅くなるだろうが。

アルゴリズムのパフォーマンスは多くの場合、十分であるだろう。
例えば、 ftp レスポンスの表現 "^([0-9]+)(\\-| |\$)(.\*)\$" が文字列 "100- this is a line of ftp response which contains a message string" に一致するのにかかる時間は: BSD の実装で 450 マイクロ秒, GNU の実装で 271 マイクロ秒, regex++ では 127 マイクロ秒である (Pentium P90, Win32 コンソールアプリ、 MS Windows 95 環境)。

しかし、一致判定に指数オーダを必要とする、 "病的な" 正規表現があることも述べておかなければならないだろう。
これらは全て、ネストされた繰り返し演算子にまつわるものである。
例えば、正規表現 "(a\*a)\*b" を `N` 文字の a に一致させるには、 *2<sup>N</sup>* に比例した時間を必要とする。
これらの表現は 問題を避けるために、(ほとんど) いつも、別の方法で書き直すことが出来る。
例えば、 "(a\*a)\*b" は "a\*b" として書き直すことが出来る。
これは、一致を解決するのに `N` に線形的に比例した時間しかかからない。
一般的に、ネストされていない繰り返し表現は *N<sup>2</sup>* に比例する時間を必要とする。
しかし、もし句が相互排他的なら線形オーダの時間で一致させることが可能である。
これは、"a\*b" の場合である。それぞれの文字に対して、一致判定は "a" か "b" か失敗のいずれかである。
一方、"a\*a" では取るべき枝を一致判定者は伝えることが出来ないので(最初の "a" か2番目のものか解らない)、両方を試さなければならない。
*正規表現をどう書くかに十分注意した方がよい。
そして、もし可能ならネストした繰り返しを避けるべきである。
このバージョンでの新しい点として、以前でのいくつかの病的なケースは直っている。
特に、先行する繰り返しや先行するリテラル文字列を含む正規表現の検索は、以前に比べかなり速くなったと思う。
リテラル文字列に対しては今は Knuth/Morris/Pratt アルゴリズムを使って検索されている(これは BM 法より好んで使われる。
なぜなら、改行文字の追跡が可能だからである)。*

*POSIX 正規表現構文のいくつかの点は、より明確に実装された:*

- 一致するものを決定するための "最左最長" 規則は曖昧である。
	このライブラリは "明確な" 解釈を持っている: 
	最左一致を発見し、それからそれぞれの子表現の長さを最長にし、
	そしてより前の順番の子表現をより後の順番の子表現より優先する。
- マルチ文字照合要素の振る舞いは標準では曖昧である。
	特に [a[.ae.]] のような表現は、それ自身に潜在したわずかな不調和を持っている。
	この実装は次のような括弧表現に一致する: 表現がそれ自身に、或いは範囲の終端としてマルチ文字照合要素を持たない限り、全ての括弧表現が単一文字のみに一致する。
	もしそうでなければ、表現は一文字以上に一致するかもしれない。
- 繰り返しの null 表現は一度だけ繰り返される。
	それらは表現により認められる最大数の繰り返しと一致した "かのように" 扱われる。
- 後方参照の振る舞いは標準では曖昧である。
	特に "((ab\*)\\2)+" という形の表現が許されるかどうかは不明瞭である。
	この実装はそのような表現を認め、後方参照は最後の子表現の一致が何であれ、一致する。
	これは一致の終端では、後方参照はそれが参照する子表現の最終的な値とは異なる一致文字列を持っているかもしれない、ということを意味する。

---

### <a name="threads">Appendix 2: スレッド安全性</a>

クラス `reg_expression<>` とその `typedef` である `regex` と `wregex` はスレッド安全性を実現している。
コンパイルされた正規表現はスレッド間で安全に共有できる。
一致判定アルゴリズム `regex_match`, `regex_search`, `regex_grep`, `regex_format`, `regex_merge` は全て、再入可能でスレッドセーフである。
クラス `match_results` も今はスレッドセーフである。
一致の結果はあるスレッドから別のスレッドに安全にコピーできる(例えばあるスレッドが一致を発見し、 `match_results` のインスタンスをキューに挿入しながら、別のスレッドがキューの逆端からそれを取り出すというようなことである)。
そうでなければ、スレッドごとに `match_results` の実体を分けて使えばよい。

POSIX API 関数は全て再入可能でスレッドセーフである。
`regcomp` を伴ってコンパイルされた正規表現も異なるスレッド間で共有可能である。

クラス `RegEx` はそれぞれのスレッドが自分の `RegEx` のインスタンスを持っているときのみスレッドセーフである(分割スレッド)。
これは、`RegEx` が正規表現のコンパイルと一致判定の両方を扱っているからである。

最後に、グローバルロケールを変更すると、コンパイルされた全ての正規表現が無効になるので、あるスレッドが正規表現を扱っている間に別のスレッドが `set_locale` を呼び出すと、
予期できない結果を生む *だろう* ということに注意せよ。

また、 `main()` の開始より前にはただひとつのスレッドだけが存在する、ということが要求されている。

---

### <a name="localisation">Appendix 3: Localization</a>

Regex++ は実行時地域化に対して拡張されたサポートを提供している。
地域化モデルは2つの部分に分かれる: フロントエンドとバックエンドだ。

フロントエンドの地域化はユーザが見るものすべてを扱う。
つまり、エラーメッセージや、正規表現構文そのものである。
例えば、フランス語のアプリケーションは [[:word:]] を [[:mot:]] に、そして \\w を \\m に変更することが出来るだろう。
フロントエンドのロケールを変更することは、開発者による積極的なサポートを要求する。
これは、地域化された文字列を含む、読み込むべきメッセージカタログと共にライブラリが提供されるということである。
フロントエンドのロケールは `LC_MESSAGES` カテゴリのみに影響される。

バックエンドの地域化は正規表現が解析された後に起こる全てのことを扱う。
つまり、ユーザが見ない、或いは直接関わらないこと全てである。
これは、大文字小文字の変換や、照合順序、文字クラスの要素などをあつかう。
バックエンドのロケールは開発者のいかなる介入も要求しない。
つまり、ライブラリは、ライブラリが現在のロケールに対して要求する全ての情報を、オペレーティングシステムやランタイムライブラリから得られるということである。
これは、もしプログラムのユーザが正規表現を直接扱えない、例えば正規表現があなたの C++ コードに埋め込まれているような場合に、明示的な地域化が必要でないということを意味する。
なぜならライブラリが、あなたのために全てをやってくれるからである。
例えば、正規表現 [[:word:]]+ をあなたのコードに埋め込むと、常に全ての単語に一致する。
もしプログラムが、仮にギリシャ語のロケール環境で走っていたとしても、全ての単語に一致するのである。
しかし、その一致はラテン文字での一致ではなく、ギリシャ文字での一致である。
バックエンドのロケールは `LC_TYPE` と `LC_COLLATE` のカテゴリに影響を受ける。

regex++ がサポートする3つの異なる地域化機構がある:

*Win32 localization model.*

これはライブラリが Win32 環境でコンパイルされたときのデフォルトのモデルである。
そして、 [`w32_regex_traits`](template_class_ref.md#regex_char_traits) によってカプセル化されている。
このモデルが適用されているときは、ユーザのコントロールパネルに従った唯一のグローバルロケールがあり、それは GetUserDefaultLCID で返される。
regex++ で使われる全ての設定は C ランタイムライブラリを通さず、オペレーティングシステムから直接得られる。
フロントエンドの地域化は、ユーザ定義の文字列をもった文字列テーブルを含むリソースである dll を要求する。
特性クラスは次の関数を export する：

```cpp
static std::string set_message_catalogue(const std::string& s);
```

これは、コードが何らかの正規表現をコンパイルする *前に* (しかし、必ずしも `reg_expression` のインスタンスを構築する前にではない)、リソースの dll の名前を識別する文字列を伴って呼び出される必要がある:

```cpp
boost::w32_regex_traits<char>::set_message_catalogue("mydll.dll");
```

この API が `w32_regex_traits` のナロウ文字とワイド文字 *両方* の特殊化のために dll の名前を設定することに注意すること。

このモデルは現在は、(Windows NT での SetThreadLocale による) スレッドに特化したロケールをサポートしていない。
ライブラリは NT での完全なユニコードのサポートを提供する。
Windows 9x ではこの能力は多少落ちる - 0 から 255 の文字はサポートされているが、それ以外は "未知の" グラフ文字として扱われる。

*C 地域化モデル*

ライブラリが Win32 以外のオペレーティングシステムでコンパイルされたとき、これがデフォルトのモデルとなる。
これは特性クラス [`c_regex_traits`](template_class_ref.md#regex_char_traits) によってカプセル化されている。
Win32 のユーザはプリプロセッサで `BOOST_REGEX_USE_C_LOCALE` を定義することで、このモデルを有効にすることが出来る。
このモデルが有効なとき、`setlocale` により設定された唯一のグローバルロケールが存在する。
全ての設定はランタイムライブラリから得ることが出来るので、結果的にユニコードのサポートはランタイムライブラリの実装に依存する。
フロントエンドの地域化は POSIX メッセージカタログを必要とする。
特性クラスは以下の関数を export する:

```cpp
static std::string set_message_catalogue(const std::string& s);
```

これは、コードが何らかの正規表現をコンパイルする *前に* (しかし、必ずしも `reg_expression` のインスタンスを構築する前にではない)、リソースの dll の名前を識別する文字列を伴って呼び出される必要がある:

```cpp
boost::c_regex_traits<char>::set_message_catalogue("mycatalogue");
```

この API が `w32_regex_traits` のナロウ文字とワイド文字 *両方* の特殊化のために dll の名前を設定することに注意すること。
もしランタイムライブラリが POSIX メッセージカタログをサポートしていなければ、 `<nl_types.h>` の独自の実装を提供するか、メッセージカタログによるフロントエンドの地域化を無効にするために `BOOST_RE_NO_CAT` を定義することが出来る。

`setlocale` を呼び出すと、コンパイルされた全ての正規表現が無効になることに注意すること。
`setlocale(LC_ALL, "C")` を呼び出すと、ライブラリは、このライブラリのバージョン 1 を含む多くの伝統的な正規表現ライブラリと同じ振る舞いをする。

*C++ 地域化 モデル*

このモデルは、プリプロセッサシンボル `BOOST_REGEX_USE_CPP_LOCALE` を定義してライブラリをビルドした時のみ有効である。
このモデルが有効なとき、 `reg_expression<>` のそれぞれのインスタンスは、自分自身の `std::locale` のインスタンスを持つ。
クラス `reg_expression<>` はメンバ関数 `imbue` も持つ。
これは、正規表現のロケールをインスタンスごとに設定することを可能にする。
フロントエンドの地域化は POSIX メッセージカタログを必要とする。
これは正規表現のロケールの `std::message` ファセットによって読み込まれる。
特性クラスは以下のシンボルを export する:

```cpp
static std::string set_message_catalogue(const std::string& s);
```

これは、コードが何らかの正規表現をコンパイルする *前に* (しかし、必ずしも `reg_expression` のインスタンスを構築する前にではない)、メッセージカタログの名前を識別する文字列を伴って呼び出される必要がある:

```cpp
boost::cpp_regex_traits<char>::set_message_catalogue("mycatalogue");
```

`reg_expression<>::imbue` の呼び出しは、その `reg_expression<>` のインスタンスの現在コンパイルされた正規表現を無効にすることに注意すること。
このモデルは C++ 標準ライブラリの思想にもっとも近いものである。
しかし、最も遅いコードを生成するモデルでもある。
そして現在の標準ライブラリの実装によって最もサポートされていないものである。
例えば私は、メッセージカタログか、或いは "C" や "POSIX" 以外のロケールの、どちらかをサポートした `std::locale` の実装を見たことはない。

最後に、もしライブラリをデフォルト以外の地域化モデルでビルドするなら、サポートライブラリをビルドするときにも、コードに `<boost/regex.hpp>` や `<boost/cregex.hpp>` をインクルードするときにも、適切なプリプロセッサシンボル (`BOOST_REGEX_USE_C_LOCALE` や `BOOST_REGEX_USE_CPP_LOCALE`) を定義しなければならないことに注意すること。
これを確実にする最良の方法は、 `<boost/regex/detail/regex_options.hpp>` に `#define` を追加することである。

*メッセージカタログの提供:*

ライブラリのフロントエンドを地域化するためには、リソース dll の文字列テーブル (Win32 モデル) か、 POSIX メッセージカタログ (C または C++ モデル) を含んだ、ふさわしいメッセージ文字列をもったライブラリを提供する必要がある。
後者の場合、<font color="red">メッセージはカタログのメッセージ集合ゼロに現れなければならない。</font>
メッセージとその ID は以下の通り:

| メッセージ ID | 意味                                                       | 既定値       |
|-----|----------------------------------------------------------------------|--------------|
| 101 | 子表現の開始に使われる文字                                           | "("          |
| 102 | 子表現の終了に使われる文字                                           | ")"          |
| 103 | 行末の明示を表す文字                                                 | "\$"         |
| 104 | 行頭の明示を表す文字                                                 | "\^"         |
| 105 | "あらゆる文字に一致する表現" を表す文字                              | "."          |
| 106 | 0回以上の一致繰り返し演算子                                          | "\*"         |
| 107 | 1回以上の一致繰り返し演算子                                          | "+"          |
| 108 | 0または1回の一致繰り返し演算子                                       | "?"          |
| 109 | 文字集合の開始                                                       | "["          |
| 110 | 文字集合の終了                                                       | "]"          |
| 111 | 排他演算子                                                           | "\|"         |
| 112 | エスケープ文字                                                       | "\\\\"       |
| 113 | ハッシュ文字 (今は使われていない)                                    | "#&"         |
| 114 | 文字範囲演算子                                                       | "-"          |
| 115 | 繰り返し演算子の開始                                                 | "{"          |
| 116 | 繰り返し演算子の終了                                                 | "}"          |
| 117 | 数字                                                                 | "0123456789" |
| 118 | エスケープ文字に続いたとき、単語の境界の明示を表す文字               | "b"          |
| 119 | エスケープ文字に続いたとき、非単語の境界の明示を表す文字             | "B"          |
| 120 | エスケープ文字に続いたときに単語の開始を表す文字                     | "<"          |
| 121 | エスケープ文字に続いたときに単語の終了を表す文字                     | ">"          |
| 122 | エスケープ文字に続いたときに、あらゆる単語構成文字を表す文字         | "w"          |
| 123 | エスケープ文字に続いたときに、あらゆる非-単語構成文字を表す文字      | "W"          |
| 124 | エスケープ文字に続いたときに、バッファの先頭の明示を表す文字         | "\`A"        |
| 125 | エスケープ文字に続いたときに、バッファの終端の明示を表す文字         | "'z"         |
| 126 | 改行文字                                                             | "\\n"        |
| 127 | コンマセパレータ                                                     | ",&"         |
| 128 | エスケープ文字に続いたときに、ベル文字を表す文字                     | "a"          |
| 129 | エスケープ文字に続いたときに、フォームフィード文字(FF)を表す文字     | "f"          |
| 130 | エスケープ文字に続いたときに、改行文字を表す文字                     | "n"          |
| 131 | エスケープ文字に続いたときに、復帰改行 (CR) 文字を表す文字           | "r"          |
| 132 | エスケープ文字に続いたときにタブ文字を表す文字                       | "t"          |
| 133 | エスケープ文字に続いたときに、垂直タブ文字を表す文字                 | "v"          |
| 134 | エスケープ文字に続いたときに、16進定数の開始を表す文字               | "x"          |
| 135 | エスケープ文字に続いたときに、 ASCII エスケープ文字の開始を表す文字  | "c"          |
| 136 | コロン                                                               | ":"          |
| 137 | イコール                                                             | "="          |
| 138 | エスケープ文字に続いたときに、 ASCII エスケープ文字を表す文字        | "e"          |
| 139 | エスケープ文字に続いたときに、あらゆる小文字を表す文字               | "l"          |
| 140 | エスケープ文字に続いたときに、あらゆる非-小文字を表す文字            | "L"          |
| 141 | エスケープ文字に続いたときに、あらゆる大文字を表す文字               | "u"          |
| 142 | エスケープ文字に続いたときに、あらゆる非-大文字を表す文字            | "U"          |
| 143 | エスケープ文字に続いたときに、あらゆる空白文字を表す文字             | "s"          |
| 144 | エスケープ文字に続いたときに、あらゆる非-空白文字を表す文字          | "S"          |
| 145 | エスケープ文字に続いたときに、あらゆる数字を表す文字。               | "d"          |
| 146 | エスケープ文字に続いたときに、あらゆる非-数字を表す文字              | "D"          |
| 147 | エスケープ文字に続いたときに、終了引用符を表す文字                   | "E"          |
| 148 | エスケープ文字に続いたときに、開始引用符を表す文字                   | "Q"          |
| 149 | エスケープ文字に続いたときに、ユニコード複合文字シーケンスを表す文字 | "X"          |
| 150 | エスケープ文字に続いたときに、あらゆる単一文字を表す文字             | "C"          |
| 151 | エスケープ文字に続いたときに、バッファ終了演算子を表す文字           | "Z"          |
| 152 | エスケープ文字に続いたときに、連続の明示を表す文字                   | "G"          |
| 153 |  (? に続いたときにゼロ幅の否定前方一致の明示を表す文字               | !            |

カスタムのエラーメッセージは以下のように読み込まれる:

| メッセージ ID | エラーメッセージ ID | 既定文字列               |
|-----|-----------------|----------------------------------------|
| 201 | `REG_NOMATCH`   | "No match"                             |
| 202 | `REG_BADPAT`    | "Invalid regular expression"           |
| 203 | `REG_ECOLLATE`  | "Invalid collation character"          |
| 204 | `REG_ECTYPE`    | "Invalid character class name"         |
| 205 | `REG_EESCAPE`   | "Trailing backslash"                   |
| 206 | `REG_ESUBREG`   | "Invalid back reference"               |
| 207 | `REG_EBRACK`    | "Unmatched [ or [\^"                   |
| 208 | `REG_EPAREN`    | "Unmatched ( or \\\\("                 |
| 209 | `REG_EBRACE`    | "Unmatched \\\\{"                      |
| 210 | `REG_BADBR`     | "Invalid content of \\\\{\\\\}"        |
| 211 | `REG_ERANGE`    | "Invalid range end"                    |
| 212 | `REG_ESPACE`    | "Memory exhausted"                     |
| 213 | `REG_BADRPT`    | "Invalid preceding regular expression" |
| 214 | `REG_EEND`      | "Premature end of regular expression"  |
| 215 | `REG_ESIZE`     | "Regular expression too big"           |
| 216 | `REG_ERPAREN`   | "Unmatched ) or \\\\)"                 |
| 217 | `REG_EMPTY`     | "Empty expression"                     |
| 218 | `REG_E_UNKNOWN` | "Unknown error"                        |

カスタムの文字クラス名は次のように読み込まれる:

| メッセージ ID | 解説            | 等価な既定のクラス名 |
|-----|--------------------------------------|-----------|
| 300 | 英数字の文字クラス名                 | "alnum"   |
| 301 | アルファベット文字の文字クラス名     | "alpha"   |
| 302 | コントロール文字の文字クラス名       | "cntrl"   |
| 303 | 数字の文字クラス名                   | "digit"   |
| 304 | 空白以外の印字可能文字の文字クラス名 | "graph"   |
| 305 | 小文字の文字クラス名                 | "lower"   |
| 306 | 印字可能文字の文字クラス名           | "print"   |
| 307 | 句読点の文字クラス名                 | "punct"   |
| 308 | 空白文字の文字クラス名               | "space"   |
| 309 | 大文字の文字クラス名                 | "upper"   |
| 310 | 16進文字の文字クラス名               | "xdigit"  |
| 311 | ブランク文字の文字クラス名           | "blank"   |
| 312 | 単語構成文字の文字クラス名           | "word"    |
| 313 | ユニコード文字の文字クラス名         | "unicode" |

最後に、カスタムの照合要素名がメッセージ ID 400 から始まって読み込まれ、最初の読み込みがその後失敗したときに終了する。
それぞれのメッセージは次のようだろう: "tagname string" `tagname` は [[.tagname.]] の内側で使われる名前であり、 *string* は照合要素の実際のテキストである。
照合要素の値 [[.zero.]] は文字列から数字への変換のために使われていることに注意せよ。
もしこれを他の値で書き換えたら、それが文字列解析に使われることになる。
例えば、ラテン数字の代わりに、ユニコードのアラビア-インド数字を正規表現の中で使いたければ、 [[.zero.]] にユニコード文字 0x0660 を使えばよい。

POSIX が定義した文字クラス名と照合要素は常に利用可能であることに注意せよ。
たとえカスタムの名前が定義されても、逆にカスタムのエラーメッセージとカスタムの構文メッセージはデフォルトのもので置き換えられる。

---

### <a name="demos">Appendix 4: 応用例 </a>

このライブラリに関する3つのデモアプリケーションがある。
Borland, Microsoft, gcc コンパイラのメイクファイルは付属しているが、それ以外は自分でメイクファイルを作成しなければならない

**regress.exe:**

一致判定、検索アルゴリズムを完全に試すための、退行テストアプリケーションである。
このプログラムが動けば、少なくともこれらの試されたものが関わる限りは、ライブラリが要求通りに動くであろうことを保証する。
もし誰かが、何か試されていないものを見つけたら、それについて聞けると私はうれしい。

Files: [`parse.cpp`](https://www.boost.org/doc/libs/1_31_0/libs/regex/test/regress/parse.cpp), [`regress.cpp`](https://www.boost.org/doc/libs/1_31_0/libs/regex/test/regress/regress.cpp), [`tests.cpp`](https://www.boost.org/doc/libs/1_31_0/libs/regex/test/regress/tests.cpp).

**jgrep.exe**

単純な grep の実装。利用法を調べるためには、コマンドラインオプションをつけずに走らせてみること。
regex++ や他の STL アルゴリズムで使うことが出来る "賢い" 双方向イテレータの例を見るには、
[`fileiter.cpp`](https://www.boost.org/doc/libs/1_31_0/libs/regex/src/fileiter.cpp)/fileiter.hpp およびそのマップファイルクラスを参考にせよ。

Files: [`jgrep.cpp`](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/jgrep/jgrep.cpp), [`main.cpp`](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/jgrep/main.cpp).

**timer.exe**

単純な対話式一致判定アプリケーション。
全ての一致の結果が時間測定されるので、プログラマはパフォーマンスが重要なときに、正規表現を最適化することが出来る。

Files: [`regex_timer.cpp`](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/timer/regex_timer.cpp).

断片的な例はこのドキュメントで使われたコードの例を含んでいる。

[`regex_match_example.cpp`](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/snippets/regex_match_example.cpp): ftp に基づく `regex_match` の例

[`regex_search_example.cpp`](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/snippets/regex_search_example.cpp): `regex_search` の例: cpp ファイルのクラス定義を検索する。

[`regex_grep_example_1.cpp`](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/snippets/regex_grep_example_1.cpp): `regex_grep` の例: cpp ファイルのクラス定義を検索する。

[`regex_merge_example.cpp`](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/snippets/regex_merge_example.cpp): `regex_merge` の例: C++ ファイルを、構文がハイライトされた HTML に変換する。

[`regex_grep_example_2.cpp`](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/snippets/regex_grep_example_2.cpp): `regex_grep` の例 2: グローバルコールバック関数を使って、cpp ファイルのクラス定義を検索する。

[`regex_grep_example_3.cpp`](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/snippets/regex_grep_example_3.cpp): `regex_grep` の例 3: 束縛されたメンバ関数コールバックを使って、cpp ファイルのクラス定義を検索する。

[`regex_grep_example_4.cpp`](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/snippets/regex_grep_example_4.cpp): `regex_grep` の例 4: C++ Builder のクロージャをコールバックとして使って、cpp ファイルのクラス定義を検索する。

[`regex_split_example_1.cpp`](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/snippets/regex_split_example_1.cpp): `regex_split` の例: 文字列をトークンに分割する。

[`regex_split_example_2.cpp`](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/snippets/regex_split_example_2.cpp): `regex_split` の例: リンクされた URL を吐き出す。

---

### <a name="headers">Appendix 5: ヘッダファイル</a>

このライブラリが使う2つの主要なヘッダファイルがある:
`<boost/regex.hpp>` は完全なライブラリへの完全なアクセスを提供する。
`<boost/cregex.hpp>` は高水準クラス `RegEx` と POSIX API 関数へのアクセスのみを提供する。

---

### <a name="redist">Appendix 6: 再配布</a>

もし Microsoft か Borland C++ を使っていて、 dll 版のランタイムライブラリにリンクしているなら、 regex++ の dll のひとつのバージョンにもリンクしているだろう。
これらの dll は再配布可能だが、 "標準の" バージョンというものが存在しないので、ユーザの PC にインストールするとき、これらを、PC のディレクトリパスにではなく、アプリケーションのプライベートディレクトリに置くべきである。
もしスタティックバージョンのランタイムライブラリとリンクしているなら、 regex++ ともリンクしていて、 dll が配布される必要はないだろう。
可能な regex++ dll とライブラリの名前は次の公式に従って導き出される:

`"boost_regex_"`<br/>
\+ `BOOST_LIB_TOOLSET`<br/>
\+ `"_"`<br/>
\+ `BOOST_LIB_THREAD_OPT`<br/>
\+ `BOOST_LIB_RT_OPT`<br/>
\+ `BOOST_LIB_LINK_OPT`<br/>
\+ `BOOST_LIB_DEBUG_OPT`<br/>

これらは次のように定義されている:

`BOOST_LIB_TOOLSET`: コンパイラのツールセットの名前 (vc6, vc7, bcb5 など)

`BOOST_LIB_THREAD_OPT`: "s" はシングルスレッドビルドを表す。
"m" はマルチスレッドビルドを表す。

`BOOST_LIB_RT_OPT`: "s" はスタティックランタイムをあらわす。
"d" はダイナミックランタイムを表す。

`BOOST_LIB_LINK_OPT`: "s" はスタティックリンクを表す。
"i" はダイナミックリンクを表す。

`BOOST_LIB_DEBUG_OPT`: 未定義ならリリースビルドを表す。
"d" はデバッグビルドを表す。
"dd" は診断デバッグビルドを表す。
(`_STLP_DEBUG`)

注意: シンボル `BOOST_REGEX_NO_LIB` をコンパイル時に定義することで、ライブラリの自動選択を不可能にすることが出来る。
これは、ランタイムライブラリの dll バージョンを使っていても、スタティックリンクをしたいようなときや、 regex++ をデバッグする必要があるときに役に立つ。

---

### <a name="upgrade">アップグレードに関する注記</a>

このバージョンの regex++ は [boost](http://www.boost.org/) プロジェクトに移植された最初のものであり、結果的に、boost コーディングガイドラインに従うために、多くの変更が為された。

ヘッダファイルは `<header>` や `<header.h>` から `<boost/header.hpp>` に変更された。

ライブラリの名前空間は "jm" から "boost" に変更された。

`reg_xxx` アルゴリズムは (名前付けの一貫性を改善するために) `regex_xxx` に改名された。

アルゴリズム `query_match` は `regex_match` に改名された。
また、正規表現が入力文字列の全体に一致するときのみ `true` を返すようになった
(入力データの検証を考えている)。

*既存のコードのコンパイル:*

ディレクトリ `libs/regex/old_include` には、このバージョンの regex++ が以前のライブラリとの互換性を持つためのヘッダファイル群が含まれている。
このディレクトリをインクルードパスに追加するか、これらのヘッダファイルを boost をインストールしたルートディレクトリにコピーすればよい。
これらのヘッダファイルの内容は推奨されていないし、ドキュメントも提供されていない。
これらは本当に、ただ既存のコードのためだけに存在している。
新しいプロジェクトには、新しいヘッダ形式を使うこと。

---

### <a name="furtherInfo">より多くの情報 (連絡と謝辞)</a>

作者への連絡は [John_Maddock@compuserve.com](mailto:John_Maddock@compuserve.com) で可能である。
このライブラリのためのホームページは [http://ourworld.compuserve.com/homepages/John_Maddock/regexpp.htm](http://ourworld.compuserve.com/homepages/John_Maddock/regexpp.htm) にある。
公式の boost のバージョンは [www.boost.org/libs/](https://www.boost.org/libs/) から入手できる。

私は Robert Sedgewick 著 "Algorithms in C++" に大変感謝している。
これは私にアルゴリズムとパフォーマンスについて考えさせてくれた。
また boost の人々は私に *考え*させてくれた、以上。
以下の人々は皆、有益なコメントや修正をしてくれた:
Dave Abrahams, Mike Allison, Edan Ayal, Jayashree
Balasubramanian, Jan BNBvlsche, Beman Dawes, Paul Baxter, David
Bergman, David Dennerline, Edward Diener, Peter Dimov, Robert
Dunn, Fabio Forno, Tobias Gabrielsson, Rob Gillen, Marc Gregoire,
Chris Hecker, Nick Hodapp, Jesse Jones, Martin Jost, Boris
Krasnovskiy, Jan Hermelink, Max Leung, Wei-hao Lin, Jens Maurer,
Richard Peters, Heiko Schmidt, Jason Shirk, Gerald Slacik, Scobie
Smith, Mike Smyth, Alexander Sokolovsky, HervNBi Poirier, Michael
Raykh, Marc Recht, Scott VanCamp, Bruno Voigt, Alexey Voinov,
Jerry Waldorf, Rob Ward, Lealon Watts, Thomas Witt and Yuval
Yosef. 
私はまた、Henry Spencer の Perl and GNU regular expression libraries
に関するマニュアルにも感謝している。
可能であれば常に、これらのライブラリ、そして POSIX 標準との互換性を保とうとした。
しかしコードは完全に私自身のものであり、バグを含んでいる!
私は、私が知らないどんなバグも直すことが出来ないだろうと、自信を持って保証できる。
だからもし、あなたが何かコメントをもっていたり、バグを発見したりしたら、ぜひ教えて欲しい。

役立つ情報は更に、次の場所で得ることが出来る:

正規表現に関する簡単なチュートリアルは [ここで見ることが出来る。](http://www.devshed.com/Server_Side/Administration/RegExp/)

[Open Unix Specification](http://www.opengroup.org/onlinepubs/7908799/toc.htm) は、正規表現構文やその仕様 [`<regex.h>`](http://www.opengroup.org/onlinepubs/7908799/xsh/regex.h.html) [`<nl_types.h>`](http://www.opengroup.org/onlinepubs/7908799/xsh/nl_types.h.html) などを含む、役立つ資料を多く含んでいる。

[Pattern Matching Pointers](http://www.cs.ucr.edu/~stelo/pattern.html) サイトは "must visit" パターンマッチに興味を持つものなら誰もが訪ねなければならない情報資源である。

[Glimpse and Agrep](http://glimpse.cs.arizona.edu/) はより高速な探索時間を実現するために、単純化された正規表現構文を使っている

[Udi Manber](http://glimpse.cs.arizona.edu/udi.html) と [Ricardo Baeza-Yates](http://www.dcc.uchile.cl/~rbaeza/) は両方とも、関連するウェブサイトから利用可能な、役立つパターンマッチの文書を集めたものである。

---

*Copyright* [*Dr John Maddock*](mailto:John_Maddock@compuserve.com) *1998-2001 all rights reserved.*

---

*Japanese Translation Copyright (C) 2003 [Kohske Takahashi](mailto:k_takahashi@cppll.jp)*

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。
このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。
また、いかなる目的に対しても、その利用が適していることを関知しない。

