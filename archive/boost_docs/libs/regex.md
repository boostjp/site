# regex++, Index

*(Version 3.31, 16th Dec 2001)*

*Copyright (c) 1998-2001*

*Dr John Maddock*

*Permission to use, copy, modify, distribute and sell this software and its documentation for any purpose is hereby granted without fee, provided that the above copyright notice appear in all copies and that both that copyright notice and this permission notice appear in supporting documentation.
Dr John Maddock makes no representations about the suitability of this software for any purpose.
It is provided "as is" without express or implied warranty.*

---

## Contents

- [導入](regex/introduction.md#intro)
- [インストールと設定](regex/introduction.md#Installation)
- [テンプレートクラス及びアルゴリズムリファレンス](regex/template_class_ref.md#regbase)
	- Class [regbase](regex/template_class_ref.md#regbase)
	- Class [bad_expression](regex/template_class_ref.md#bad_expression)
	- Class [reg_expression](regex/template_class_ref.md#reg_expression)
	- Class [char_regex_traits](regex/template_class_ref.md#regex_char_traits)
	- Class [match_results](regex/template_class_ref.md#reg_match)
	- Algorithm [regex_match](regex/template_class_ref.md#query_match)
	- Algorithm [regex_search](regex/template_class_ref.md#reg_search)
	- Algorithm [regex_grep](regex/template_class_ref.md#reg_grep)
	- Algorithm [regex_format](regex/template_class_ref.md#reg_format)
	- Algorithm [regex_merge](regex/template_class_ref.md#reg_merge)
	- Algorithm [regex_split](regex/template_class_ref.md#regex_split)
	- Algorithm [Partial regular expression matches](regex/template_class_ref.md#partial_matches)
- クラス [RegEx](regex/hl_ref.md#RegEx) リファレンス
- [POSIX 互換関数](regex/posix_ref.md#posix)
- [正規表現構文](regex/syntax.md#syntax)
- [書式文字列構文](regex/format_string.md#format_string)
- [付録](regex/appendix.md#implementation)
	- [実装における注意](regex/appendix.md#implementation)
	- [スレッド安全性](regex/appendix.md#threads)
	- [地域化](regex/appendix.md#localisation)
	- [応用例](regex/appendix.md#demos)
		- [regex_match_example.cpp](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/snippets/regex_match_example.cpp): ftp による regex_match の例
		- [regex_search_example.cpp](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/snippets/regex_search_example.cpp): regex_search の例: C++ ファイルのクラス定義の検索
		- [regex_grep_example_1.cpp](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/snippets/regex_grep_example_1.cpp): regex_grep の例 1: C++ ファイルのクラス定義の検索
		- [regex_merge_example.cpp](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/snippets/regex_merge_example.cpp): regex_merge の例: C++ ファイルを構文をハイライトされた HTML に変換
		- [regex_grep_example_2.cpp](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/snippets/regex_grep_example_2.cpp): regex_grep の例 2: 大域コールバック関数を利用した、C++ ファイルのクラス定義の検索
		- [regex_grep_example_3.cpp](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/snippets/regex_grep_example_3.cpp): regex_grep の例 3: (オブジェクトに)束縛されたメンバ関数コールバックを利用した、 C++ ファイルのクラス定義の検索
		- [regex_grep_example_4.cpp](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/snippets/regex_grep_example_4.cpp): regex_grep の例 4: C++ Builder のクロージャをコールバックとして利用した、C++ ファイルのクラス定義の検索
		- [regex_split_example_1.cpp](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/snippets/regex_split_example_1.cpp): regex_split の例: 文字列をトークンに分割
		- [regex_split_example_2.cpp](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/snippets/regex_split_example_2.cpp): regex_split の例: リンクされた URL の抜き出し
	- [ヘッダファイル](regex/appendix.md#headers)
	- [再配布](regex/appendix.md#redist)
	- [アップグレードに関する注記](regex/appendix.md#upgrade)
- [更なる情報 (連絡と感謝)](regex/appendix.md#furtherInfo)
- [FAQ](regex/faq.md)

---

*Copyright* [*Dr John Maddock*](mailto:John_Maddock@compuserve.com) *1998-2001 all rights reserved.*

---

*Japanese Translation Copyright (C) 2003 [Kohske Takahashi](mailto:k_takahashi@cppll.jp)*

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。
このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。
また、いかなる目的に対しても、その利用が適していることを関知しない。

