# <a id="intro">Introduction</a>

*Copyright (c) 1998-2001*

*Dr John Maddock*

*Permission to use, copy, modify, distribute and sell this software and its documentation for any purpose is hereby granted without fee, provided that the above copyright notice appear in all copies and that both that copyright notice and this permission notice appear in supporting documentation.
Dr John Maddock makes no representations about the suitability of this software for any purpose.
It is provided "as is" without express or implied warranty.*

---

## Introduction

正規表現はテキスト処理によく使われるパターンマッチングのひとつである。
多くのユーザは *grep*,*sed*,*awk* などのUnixのユーティリティや、プログラミング言語である *perl* をよく知っているだろう。
それらは正規表現の拡張である。
伝統的に、C++ユーザは正規表現を操作するのに、POSIX C APIのものに限られてきた。
regex++はこれらのAPIを提供するが、これらの API を使うのは regex++ ライブラリの最良の利用法ではない｡
例えば、regex++はワイドストリングを扱うことが可能であり、伝統的なCライブラリが出来なかった、(sedやperlと似たようなやり方での)検索や置換の操作が可能である。

[`boost::reg_expression`](template_class_ref.md#reg_expression) クラスはこのライブラリの中心となるクラスである。
このクラスは「機械によって可読な」正規表現を表し、 `std::basic_string` の上で、厳密につくられている。
それが文字列であり、さらに正規表現アルゴリズムが要求する実際のstate-machineでもあるからだ。
`std::basic_string` と同様に、このクラスには2つのtypedefがあり、それらは、このクラスを示すために非常によく使われる。

```cpp
namespace boost{

template <class charT,
          class traits = regex_traits<charT>, 
          class Allocator = std::allocator<charT> >
class reg_expression;

typedef reg_expression<char> regex;
typedef reg_expression<wchar_t> wregex;

}
```

このライブラリの使い方を見るために、クレジットカード処理を行うアプリケーションを開発していることにしよう。
クレジットカードの番号は一般的に16桁の数字であり、4桁ずつのグループに分かれていて、スペースかハイフンで区切られている。
クレジットカードの番号をデータベースに保存する前に(あなたの顧客が必ずしも理解している必要はないが)、その番号が正しい形式なのか確かめたいだろう。
数字に一致させるには、`[0-9]` という正規表現を使うことが出来るが、このような文字範囲は実際は環境依存である。
代わりにPOSIX標準形式 `[[:digit:]]` か、regex++とperlの略記 `\d` を使うべきである(多くの古いライブラリはCの環境に厳密にコードされていて、結果的にこれが古いライブラリでは使えないことに、注意が必要である。)
これにより、クレジットカードの番号の形式を確かめるには次の正規表現を使うことが出来る。

```cpp
(\d{4}[- ]){3}\d{4}
```

ここでは丸括弧 `()` は子表現(sub-expressoins)のグループとして働く(そして、前方参照の印となる)。
`{4}` は「4回繰り返す」ことを意味する。
これは、perl,awk,egrepで使われる拡張正規表現構文の一例である。
regex++も、sedやgrepで使われる古くて「基本的な」構文をサポートしているが、再利用する必要のある基本的な正規表現が既にあるのでない限り、一般的にあまり使えない。

では、その表現を使って、クレジットカードの番号の形式を確かめるC++のコードをつくってみよう

```cpp
bool validate_card_format(const std::string s)
{
   static const boost::regex e("(\\d{4}[- ]){3}\\d{4}");
   return regex_match(s, e);
}
```
* boost::regex[link template_class_ref.md#reg_expression]
* regex_match[link template_class_ref.md#query_match]

表現に余計なエスケープを加えていることに注意すること。
エスケープは、正規表現エンジンに通される前に、一度C++コンパイラを通されるので、正規表現でのエスケープはC/C++コードの中では2倍にされなければならないことを覚えておくこと。
また、ここでの全ての例は、コンパイラがKoenig lookupをサポートしていることを仮定している。
もし(例えばVC6のように)そうでなければ、例の中の関数呼び出しの幾つかには、`boost::` という接頭辞をつける必要がある。

(※訳注) Koenig lookupとは引数に依存して関数を検索すること

クレジットカードの処理をよく知っている者なら、上で使われた形式が、人間にとってカードの番号を読むのには適切であるが、オンラインのクレジットカードシステムが要求する形式を満たしていないことが解るだろう。
システムはその番号が、16(或いは15かもしれない)桁で、余計なスペースがないことを要求する。
我々に必要なのは、二つの形式を簡単に変換する手段である。
そしてここで検索と置換が登場する。
*sed* や *perl* といったユーティリティをよく知っている者なら、ここは読みとばしていいだろう。
我々には2つの文字列が必要である。
ひとつは正規表現、もう一つは "[書式文字列(format string)](format_string.md)" である。
これは一致したものを置換するためのテキストの定義を与える。
regex++ではこの検索と置換の操作は `regex_merge` というアルゴリズムで行われている。
クレジットカードの例ではこれと同様の、フォーマット変換を提供する2つのアルゴリズムを書くことが出来る。

```cpp
// match any format with the regular expression:
const boost::regex e("\\A(\\d{3,4})[- ]?(\\d{4})[- ]?(\\d{4})[- ]?(\\d{4})\\z");
const std::string machine_format("\\1\\2\\3\\4");
const std::string human_format("\\1-\\2-\\3-\\4");

std::string machine_readable_card_number(const std::string s)
{
   return regex_merge(s, e, machine_format, boost::match_default | boost::format_sed);
}

std::string human_readable_card_number(const std::string s)
{
   return regex_merge(s, e, human_format, boost::match_default | boost::format_sed);
}
```
* regex_merge[link template_class_ref.md#reg_merge]

ここでは正規表現の中で、カード番号の4つの部分を異なるフィールドとして分けるために、印付き子表現(sub-expressions)が使われている。
置換文字列はsedの様な構文を使い、一致したテキストを新しい形式で置換している。

上の例では正規表現の一致の結果を直接操作することは出来ない。
しかし一般的に一致の結果は、全体の一致に加え、多くの子表現の一致を含む。
ライブラリが正規表現の一致の結果を必要な時は、 [`match_results`](template_class_ref.md#reg_match) クラスのインスタンスを利用することで得ることが出来る。
前述のクラスと同様、多くの場合に使えるtypedefがある:

```cpp
namespace boost{
typedef match_results<const char*> cmatch;
typedef match_results<const wchar_t*> wcmatch;
typedef match_results<std::string::const_iterator> smatch;
typedef match_results<std::wstring::const_iterator> wsmatch; 
}
```

[`regex_search`](template_class_ref.md#reg_search) と [`regex_grep`](template_class_ref.md#reg_grep) アルゴリズム(これは文字列中の全ての一致を発見する)は `match_results` を利用して、何が一致したのかを報告する。

これらのアルゴリズムは正規のC-文字列の検索に制限されず、双方向イテレータであればどんなものでも検索が可能であり、ほとんどあらゆる種類のデータに対しても検索を可能にしていることに注意すること。

検索と置換操作では、すでに見てきた [`regex_merge`](template_class_ref.md#reg_merge)アルゴリズムに加え、[`regex_format`](template_class_ref.md#reg_format) アルゴリズムは、一致の結果を得て、文字列をフォーマットし、二つを合わせることで新しい文字列を作り出す。

テンプレートを嫌う人のために、ハイレベルのラッパクラス `RegEx` があり、ローレベルのテンプレートコードをカプセル化している。
これは、ライブラリの全ての能力を必要としない人のために、シンプルなインタフェースを提供する。
そして、narrow charactersと「拡張された」正規表現構文だけをサポートする。

[POSIX API](posix_ref.md#posix) 関数: regcomp, regexec, regfree, regerrorはnarrow characterとUnicode両方で利用可能で、これらのAPIとの互換性が必要な人のために提供されている。

最後に、ライブラリがランタイム [localization](appendix.md#localisation) をサポートしていること、そして、完全なPOSIX正規表現構文をサポートしていること(これはマルチキャラクタ照合要素、等価クラスのような先進的な特徴を含む)、同様に、GNUとBSD4正規表現パッケージ、そして限られてはいるがperl5、を含む他の正規表現ライブラリとの互換性を提供していることに注意すること。

## <a id="Installation">Installation and Configuration Options</a>

*[* **重要**: *もしこのライブラリのversion2.xからアップグレードするなら、ドキュメント化されたヘッダの名前とライブラリのインタフェースに多くの変更がある。しかし既存のコードは変更なしにコンパイルするべきである。
[Note for Upgraders](appendix.md#upgrade) を参考のこと。]*

ライブラリをzipファイルから解凍したら、内部のディレクトリ構造を維持する必要がある(例えば-dオプションを使って解凍する)。
そうしていなければ、これを読むのをやめて解凍したファイルを削除して、再び解凍作業を行うべきである。

このライブラリは利用する前に設定することは必要ない。
多くの一般的なコンパイラ、標準ライブラリ、プラットフォームはすでに「そのまま(as is)」でサポートされている。
もし設定の問題を経験したなら、或いはあなたのコンパイラでの設定を試したいなら、その手続きはboostの全てのライブラリと同じである。
*configuration library documentation* を参考のこと。

ライブラリは `namespace boost` の中に全てのコードを入れている。

他のいくつかのテンプレートライブラリとは異なり、このライブラリはテンプレートコード(ヘッダの中にある)と、スタティックなコードとデータ(cppファイルの中にある)の両方で構成されている。
つまり使う前に、ライブラリのコードをライブラリファイルやアーカイブファイルにビルドすることが必要である。
プラットフォーム特有の指示は以下の通りである:

**Borland C++ Builder:**

- コンソールを開き、カレントディレクトリを `<boost>\libs\regex\build` に変更する。 
- 適切なmakefileを選択する。
	(bcb4.mak for C++ Builder 4, bcb5.mak for C++ Builder 5, and bcb6.mak for C++ Builder 6)
- makefileを呼び出す(もし二つ以上のヴァージョンがインストールされているなら、makeのフルパスを渡すこと。
	makefileはmakeのパスによって、C++ Builderがインストールされたディレクトリとツールを得る。)
	例えば

```
make -fbcb5.mak
```

ビルドプロセスは多くの.libと.dllファイルをビルドする(正確な数は利用したBorlandのツールのヴァージョンによる)。
.libと.dllファイルはmakefileが使ったものに従いbcb4またはbcb5というサブディレクトリの中にある。
ライブラリを開発システムにインストールするためには:

```
make -fbcb5.mak install
```

ライブラリファイルは `<BCROOT>/lib` にコピーされ、 .dllファイルは `<BCROOT>/bin` にコピーされる。
`<BCROOT>` の場所はBorland C++のツールがインストールされている場所に対応する。

次のようにすれば、ビルドプロセスの間に作られた一時的なファイル(.libと.dllファイルを除く)を削除することが出来る:

```
make -fbcb5.mak clean
```

最後に、regex++を使うときに唯一必要なことは `<boost>` ルートディレクトリをプロジェクトのインクルードディレクトリのリストに加えることである。
.libファイルをプロジェクトに手動で加えることは必要ではない。
ヘッダは自動的に、ビルドモードに適切な.libファイルを選択し、リンカにそれをインクルードするように伝える。
しかしひとつ警告することがある: ライブラリは、コマンドラインからGUIアプリケーションをビルドする時に、ビルドを可能にするためのVCLと非VCLの違いを見分けられない。
もし5.5コマンドラインツールでコマンドラインからビルドするなら、正しいリンクライブラリが選択されるように、プリプロセッサで `_NO_VCL` を定義しなければならない: C++ Builder IDEは通常これを自動的に設定する。
5.5コマンドラインツールのユーザはこのオプションを恒久的にするために、`-D_NO_VCL` をbcc32.cfgに加えればいいだろう。

もしdllランタイムを使うときでも、regexライブラリとスタティックリンクをしたいなら、`BOOST_REGEX_STATIC_LINK` を定義すればよい。
もし一緒に、自動的なリンクを抑制したいなら(そして好きな.libを使いたいなら) `BOOST_REGEX_NO_LIB` を定義すればよい。

もしC++ Builder 6でビルドするなら、`<boost/regex.hpp>` はプリコンパイルドヘッダの中で利用できない(実際の問題は `<locale>` の中にある。
これは `<boost/regex.hpp>` の中でインクルードされている)。
もしこれが問題なら、ビルドするときに `BOOST_NO_STD_LOCALE` を定義してみること。
これはboostのいくらかのものを利用できなくするが、コンパイル時間を短縮する。

**Microsoft Visual C++ 6 and 7**

このライブラリをビルドするにはMSVCのバージョン6が必要である。
VC5を使っているなら、この [ライブラリ](http://ourworld.compuserve.com/homepages/john_maddock/regexpp.htm) の以前のリリースのひとつを見た方がよい。

コマンドプロンプトを開く。
必要なMSVCの環境変数が定義されていなければならない(例えば、Visual Studioのインストールによって同時にインストールされたVcvars32.batファイルを利用できる。)
そして `<boost>\libs\regex\build` ディレクトリに移動する。

正しいmakefileを選択する。
vc6.makは「オーソドックスな」Visual C++ 6 のためのものであり、STLPortを利用しているなら、vc6-stlport.makを選択すること。

以下のようにmakefileを呼び出す。

```
nmake -fvc6.mak
```

「vc6」というサブディレクトリの中に、多くの.libと.dllファイルが出来ている。
これらを開発環境にインストールするために:

```
nmake -fvc6.mak install
```

.libファイルは `<VC6>\lib` ディレクトリにコピーされ、.dllファイルは `<VC6>\bin` にコピーされる。
`<VC6>` の場所は Visual C++ 6 のインストールのルートである。

次のようにすれば、ビルドプロセスの間に作られた一時的なファイル(.libと.dllファイルを除く)を削除することが出来る:

```
nmake -fvc6.mak clean 
```

最後に、regex++を使うときに唯一必要なことは `<boost>` ルートディレクトリをプロジェクトのインクルードディレクトリのリストに加えることである。
.libファイルをプロジェクトに手動で加えることは必要ではない。
ヘッダは自動的に、ビルドモードに適切な.libファイルを選択し、リンカにそれをインクルードするように伝える。

もしダイナミックC++ランタイムを使うときにregexライブラリにスタティックリンクしたいなら、プロジェクトをビルドするときに `BOOST_REGEX_STATIC_LINK` を定義すること(これはリリースビルドでのみ効果を持つ)。
もしプロジェクトにソースコードを直接加えたいなら、`BOOST_REGEX_NO_LIB` を定義すれば、ライブラリの自動選択を抑止できる。

**重要**: コンパイラ最適化のバグがこのライブラリに影響するという報告がいくつかある(とくにVC6のSP5以前で)。
次善策は、/O2オプションでなく/Oityb1オプションを使ってライブラリをビルドすることである。
これは/Oa以外の全ての最適化を行う。
この問題はいくつかの標準ライブラリにも影響するという報告がある(実際、この問題がregexのコードとのものなのか、regexの中の標準ライブラリとのものなのか不明である)ので、この次善策をどんな場合にも行ってみることはおそらく価値がある。

注記: もしVC6付属のC++標準ライブラリではないものを使っているなら、regex++ライブラリをビルドするときに `"INCLUDE"` と `"LIB"` の環境変数は、新しいライブラリのインクルードパスとライブラリパスを反映するように設定されなければならない。
詳細はvcvars32.bat (Visual Studioについてくる)を参考のこと。
あるいはSTLPortがc:/stlportにあるなら次のようにすればよい:

```
nmake INCLUDES="-Ic:/stlport/stlport" XLFLAGS="/LIBPATH:c:/stlport/lib"
-fvc6-stlport.mak
```

もし、完全なSTLPortバージョン4.xでビルドするなら、vc6-stlport.makファイルを使えばSTLportをインストールした場所を示す環境変数 `STLPORT_PATH` が設定される(完全なSTLPortライブラリはシングルスレッド・スタティックビルドをサポートしていないことに注意すること)。

**GCC(2.95)**

g++コンパイラのための確実なmakefileがある。
コマンドプロンプトから `<boost>/libs/regex/build` ディレクトリに移動し次のようにタイプせよ:

```
make -fgcc.mak 
```

ビルドプロセスの最後に、ライブラリのリリースバージョンとデバッグバージョンが入ったgccというサブディレクトリができる(`libboost_regex.a` と `libboost_regex_debug.a`)。
regex++を使ったプロジェクトをビルドする時は、boostをインストールしたディレクトリをインクルードパスのリストに加え、`<boost>/libs/regex/build/gcc/libboost_regex.a` をライブラリファイルのリストに加える必要がある。

共有ライブラリとしてライブラリをビルドするためのmakefileもある。

```
make -fgcc-shared.mak
```

これは `libboost_regex.so` と `libboost_regex_debug.so` を作る。

これらのmakefileは両方とも以下の環境変数をサポートしている。

- CXXFLAGS: 追加のコンパイルオプション - これらはデバッグビルドとリリースビルド両方で適用される。
- INCLUDES: 追加のインクルードディレクトリ
- LDFLAGS: 追加のリンカオプション
- LIBS: 追加のライブラリファイル

もっと冒険したければ、`<boost>/libs/config` にコンフィギュアスクリプトがある。
*config library documentation* を参考にすること。

**Sun Workshop 6.1**

sun (6.1) コンパイラ (C++ version 3.12)用のmakefileがある。
コマンドプロンプトから `<boost>/libs/regex/build` ディレクトリに移動して、次のようにすること:

```
dmake -f sunpro.mak
```

ビルドプロセスの最後にこのライブラリのシングルそしてマルチスレッドバージョンが入ったsunproサブディレクトリが出来ている(`libboost_regex.a`, `libboost_regex.so`, `libboost_regex_mt.a` そして `libboost_regex_mt.so`)。
regex++を使うプロジェクトをビルドするときには、boostインストールディレクトリをインクルードパスのリストに、`<boost>/libs/regex/build/sunpro/` をライブラリ検索パスに加える必要がある。

makefileは以下の環境変数をサポートしている。

- CXXFLAGS: 追加のコンパイルオプション - これらはデバッグビルドとリリースビルド両方で適用される。
- INCLUDES: 追加のインクルードディレクトリ
- LDFLAGS: 追加のリンカオプション
- LIBS: 追加のライブラリファイル
- LIBSUFFIX: ライブラリのネームマングリングのための接尾辞(デフォルトでは何もつけない)

このmakefileは-xarch=v9のような構造(architecture)特有のオプションを設定しないので、適切なマクロを定義してこれらを設定する必要がある。
例えば:

```
dmake CXXFLAGS="-xarch=v9" LDFLAGS="-xarch=v9"
LIBSUFFIX="_v9" -f sunpro.mak
```

これは `libboost_regex_v9.a` 等と名付けられたregexライブラリのv9用のものをビルドする。

**Other compilers:**

汎用のmakefile([generic.mak](build/generic.mak))が `<boost-root>/libs/regex/build` にある。
使う前に設定が必要な環境変数の詳細は、このmakefileを見よ。
もしくは *Jam based build system* を使うことが出来る。
もしプラットフォームのためにライブラリの構成が必要なら *config library documentation* を参考にすること。

---

*Copyright* [*Dr John Maddock*](mailto:John_Maddock@compuserve.com) *1998-2001 all rights reserved.*

---

*Japanese Translation Copyright (C) 2003 [Kohske Takahashi](mailto:k_takahashi@cppll.jp)*

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。
このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。
また、いかなる目的に対しても、その利用が適していることを関知しない。

