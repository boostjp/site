# Regex++, Format String Reference.

*Copyright (c) 1998-2001*

*Dr John Maddock*

*Permission to use, copy, modify, distribute and sell this software and its documentation for any purpose is hereby granted without fee, provided that the above copyright notice appear in all copies and that both that copyright notice and this permission notice appear in supporting documentation.
Dr John Maddock makes no representations about the suitability of this software for any purpose.
It is provided "as is" without express or implied warranty.*

---

### <a id="format_string">Format String Syntax</a>

書式文字列は、アルゴリズム [`regex_format`](template_class_ref.md#reg_format) と [`regex_merge`](template_class_ref.md#reg_merge) で使われている。
これは、一つの文字列を別の文字列に変形するために使われる。

3種類の書式文字列がある: sed, perl, そして拡張である。
拡張構文はデフォルトなので、最初にこれについて説明する。

**拡張文字列構文**

書式文字列では、次のものを除く全ての文字はリテラルとして扱われる: ()\$\\?: 

これらをリテラルとして使うには、エスケープ文字 \\ を前につけなければならない。

次の特別なシーケンスを扱うことが出来る。

*グループ化:*

書式文字列の中で子表現をグループ化するには、丸括弧 ( と ) を使うこと。
リテラル '(' と ')' をあらわすには、 \\( と \\) を使う。

*子表現展開:*

次の perl のような表現は、特定の一致した子表現を展開する。

|       |   |
|-------|---|
| \$\`  | 前の一致の終端から現在の一致の先頭までの全てのテキストを展開する。もし現在の一致の操作中に前の一致がなければ、入力文字列の先頭から現在の一致の先頭までの全てが展開される。 |
| \$'   | 一致の終端から入力文字列の終端までの全てのテキストを展開する。 |
| \$&   | 現在の一致を全て展開する。 |
| \$0   | 現在の一致を全て展開する。 |
| \$N   | 子表現 *N* に一致したテキストを展開する。 |

*条件付表現:*

条件付表現は二つの異なる書式文字列を、子表現が入力文字列に一致したかどうかに依存して選択することを可能にする：

?N 真表現 : 偽表現

もし子表現 *N* が一致していれば、 真表現が実行される。
そうでなければ偽表現が実行される。

例: "(while)|(for)" を検索した時、書式文字列 "?1WHILE:FOR" は一致したものを大文字にして出力する。

*エスケープシーケンス:*

次のエスケープシーケンスが可能である:

|       |   |
|-------|---|
| \\a   | ベル文字 |
| \\f   | フォームフィード(FF)文字 |
| \\n   | 改行 |
| \\r   | 復帰 |
| \\t   | タブ |
| \\v   | 垂直タブ |
| \\x   | 16進文字 - 例えば: \\x0D |
| \\x{} | 可能なユニコード16進文字 - 例えば \\x{1A0} |
| \\cx  | ASCII エスケープ文字 x 、例えば \\c@ は escape-@ と等価。 |
| \\e   | ASCII エスケープ文字 |
| \\dd  | 8進文字定数、例えば \\10 |

**Perl 書式文字列**

Perl 書式文字列は文字 ()?: が特別な意味を持たないこと以外は、
デフォルト構文と同じである。

**Sed 書式文字列**

Sed 書式文字列は、文字 \\ と & のみを特殊文字として使う。

n が数字のとき、 \\n は n 番目の子表現に展開される。

& は一致全体に展開される。
( \\0 と等価)。

他のエスケープシーケンスはデフォルト構文と同じように展開される。

---

*Copyright* [*Dr John Maddock*](mailto:John_Maddock@compuserve.com) *1998-2001 all rights reserved.*

---

*Japanese Translation Copyright (C) 2003 [Kohske Takahashi](mailto:k_takahashi@cppll.jp)*

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。
このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。
また、いかなる目的に対しても、その利用が適していることを関知しない。

