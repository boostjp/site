# Regex++, POSIX API Reference

*Copyright (c) 1998-2001*

*Dr John Maddock*

*Permission to use, copy, modify, distribute and sell this software and its documentation for any purpose is hereby granted without fee, provided that the above copyright notice appear in all copies and that both that copyright notice and this permission notice appear in supporting documentation.
Dr John Maddock makes no representations about the suitability of this software for any purpose.
It is provided "as is" without express or implied warranty.*

---

### <a name="posix">POSIX compatibility library</a>

```cpp
#include <boost/cregex.hpp>
```

*or*:

```cpp
#include <boost/regex.h>
```

次の関数は POSIX 互換 C ライブラリが必要なユーザにとって役立つ。
これらは Unicode版 とナロウ文字版両方で利用可能である。
POSIX 標準 API の名前は、 UNICODE が定義されているかによりどちらかの版を拡張したマクロである。

**重要**: ここで定義されるシンボルは、`<boost/regex.h>` がインクルードされない限り、C++ プログラムで使われるときは全て、名前空間 *boost* の中にあることに注意せよ。
`<boost/regex.h>` がインクルードされていても、シンボルは名前空間 `boost` の中で定義されているが、グローバル名前空間と同じように利用することが出来る。

関数は次のように定義されている。

```cpp
extern "C" {
int regcompA(regex_tA*, const char*, int);
unsigned int regerrorA(int, const regex_tA*, char*, unsigned int);
int regexecA(const regex_tA*, const char*, unsigned int, regmatch_t*, int);
void regfreeA(regex_tA*);

int regcompW(regex_tW*, const wchar_t*, int);
unsigned int regerrorW(int, const regex_tW*, wchar_t*, unsigned int);
int regexecW(const regex_tW*, const wchar_t*, unsigned int, regmatch_t*, int);
void regfreeW(regex_tW*);

#ifdef UNICODE
#define regcomp regcompW
#define regerror regerrorW
#define regexec regexecW
#define regfree regfreeW
#define regex_t regex_tW
#else
#define regcomp regcompA
#define regerror regerrorA
#define regexec regexecA
#define regfree regfreeA
#define regex_t regex_tA
#endif
}
```

全ての関数は構造体 `regex_t` に対して作用する。
構造体 `regex_t` は二つの公開メンバを持っている。

`unsigned int re_nsub` これは `regcomp` によって書き込まれ、正規表現に含まれる子表現の数を表している。

`const TCHAR* re_endp` はフラグ `REG_PEND` が設定されているとき、コンパイルする正規表現の末端を指す。

*脚注: `regex_t` は実際はマクロ定義である。
これは `UNICODE` が定義されているかどうかに依存して、 `regex_tA` か `regex_tW` を定義している。
`TCHAR` は マクロ `UNICODE` に依存した、`char` か `wchar_t` の再定義である。*

`regcomp` は `regex_t` へのポインタを受け取る。
このポインタはコンパイルする正規表現と、組み合わせることの出来るフラグパラメータを指す。

- `REG_EXTENDED`
	- モダンな正規表現をコンパイルする。
		`regbase::char_classes | regbase::intervals | regbase::bk_refs` と等価である。
- `REG_BASIC`
	- 基本的な(時代遅れの)正規表現構文をコンパイルする。
		`regbase::char_classes | regbase::intervals | regbase::limited_ops | regbase::bk_braces | regbase::bk_parens | regbase::bk_refs` と等価である。
- `REG_NOSPEC`
	- 全ての文字は通常の文字であり、正規表現はリテラル文字列である。
- `REG_ICASE`
	- 大文字小文字の区別なく一致するためのコンパイル
- `REG_NOSUB`
	- このライブラリでは何の作用もない。
- `REG_NEWLINE`
	- このフラグが設定されているとき、ドット文字は改行文字に一致しない。
- `REG_PEND`
	- このフラグが設定されているとき、 `regex_t` 構造体の `re_endp` パラメータは翻訳する正規表現の終端を指していなければならない。
- `REG_NOCOLLATE`
	- このフラグが設定されているとき、ロケールに依存した文字範囲の照合は行われない。
- `REG_ESCAPE_IN_LISTS`
	`, , , `
	- このフラグが設定されているとき、大括弧表現(文字集合)のなかでエスケープシーケンスが許される。
- `REG_NEWLINE_ALT`
	- このフラグが設定されているとき、改行文字は排他演算子 `|` と等価である。
- `REG_PERL`
	- perl のような振る舞いの略記:
		`REG_EXTENDED | REG_NOCOLLATE | REG_ESCAPE_IN_LISTS`
- `REG_AWK`
	- awk のような振る舞いの略記: `REG_EXTENDED | REG_ESCAPE_IN_LISTS`
- `REG_GREP`
	- grep のような振る舞いの略記: `REG_BASIC | REG_NEWLINE_ALT`
- `REG_EGREP`
	- egrep のような振る舞いの略記: `REG_EXTENDED | REG_NEWLINE_ALT`


`regerror` は次のパラメータを受け取る。
これはエラーコードを人間に可読な文字列に変換する。

| int code                | エラーコード                       |
|-------------------------|------------------------------------|
| `const regex_t* e`      | 正規表現( null でもよい)           |
| `char* buf`             | エラーメッセージを書き込むバッファ |
| `unsigned int buf_size` | バッファサイズ                     |

もし、エラーコードが `REG_ITOA` を含む(訳注: `code & REG_ITOA` が真)なら、その結果のメッセージは、メッセージというよりは、例えば `REG_BADPAT` のような印字可能なコード名である。
コードが `REG_ATIO` なら `e` は `null` であってはならない。
そして `e->re_pend` は印字可能なエラーコードを指していなければならない。
その時の戻り値は、エラーコードの値である。
`code` がそれ以外ならどんな値の時にも、戻り値はエラーメッセージの文字数である。
戻り値が `buf_size` と同じか、それより大きければ、 `regerror` はより大きなバッファでもう一度呼ばれなければならない。

`regexec` は文字列 `buf` の中の最初の正規表現 `e` を発見する。
もし `len` が非0なら、 `*m` には何が正規表現に一致したかを書き込まれる。
`m[0]` は文字列全体と一致したものを持ち、 `m[1]` は最初の子表現であり、以下同様である。
より詳細は、ヘッダファイルでの `regmatch_t` の宣言を見よ。
`eflags` パラメータは次の値の組み合わせである:

- `REG_NOTBOL`
	- パラメータ `buf` は行のはじめを表さない。
- `REG_NOTEOL`
	- パラメータ `buf` は行の終端で終わらない。
- `REG_STARTEND`
	- 検索される文字列は、 `buf + pmatch[0].rm_so` で始まり、 `buf + pmatch[0].rm_eo` で終わる。

最後に `regfree` は `regcomp` によって割り当てられた全てのメモリを解放する。

*脚注: これは POSIX API 関数の簡略したリファレンスであり、(もし C++ 以外の言語からアクセスする必要がなければ)新しいコードでこれらの API を使うためというよりは他のライブラリとの互換性を提供する。
これらの関数のこのバージョンは、幸いなことに他のバージョンと共存できる。
使われる名前は、実際の関数名を拡張したマクロだからだ。*


---

*Copyright* [*Dr John Maddock*](mailto:John_Maddock@compuserve.com) *1998-2001 all rights reserved.*

---

*Japanese Translation Copyright (C) 2003 [Kohske Takahashi](mailto:k_takahashi@cppll.jp)*

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。
このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。
また、いかなる目的に対しても、その利用が適していることを関知しない。

