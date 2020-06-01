# Regex++, Traits Class Reference.

*Copyright (c) 1998-2001*

*Dr John Maddock*

*Permission to use, copy, modify, distribute and sell this software and its documentation for any purpose is hereby granted without fee, provided that the above copyright notice appear in all copies and that both that copyright notice and this permission notice appear in supporting documentation.
Dr John Maddock makes no representations about the suitability of this software for any purpose.
It is provided "as is" without express or implied warranty.*

---

この章では `reg_expression` テンプレートクラスの特性クラスの仕様について述べる。
これらの仕様は多少複雑(申し訳ない)で、新しい特徴の要求にあたり変更が必要である。
しかし私はしばらく、これらをこのままにしておこうと思う。
そして理想的には、仕様は増えるよりも減らされるべきである。

`reg_expression` 特性クラスは文字型の性質と、その文字型に関連するロケールの性質の両方をカプセル化する。
関連するロケールは実行時に (`std::locale` によって) 定義されるかもしれないし、特性クラスに直接コーディングされて、コンパイル時に決定されているかもしれない。

次のクラスの例は、 クラス `reg_expression` で使うための、 "典型的な" 特性クラスに求められるインタフェースを説明している:

```cpp
class mytraits
{
   typedef implementation_defined char_type;
   typedef implementation_defined uchar_type;
   typedef implementation_defined size_type;
   typedef implementation_defined string_type;
   typedef implementation_defined locale_type;
   typedef implementation_defined uint32_t;
   struct sentry
   {
      sentry(const mytraits&);
      operator void*() { return this; }
   };

   enum char_syntax_type
   {
      syntax_char = 0,
      syntax_open_bracket = 1,                  // (
      syntax_close_bracket = 2,                 // )
      syntax_dollar = 3,                        // $
      syntax_caret = 4,                         // ^
      syntax_dot = 5,                           // .
      syntax_star = 6,                          // *
      syntax_plus = 7,                          // +
      syntax_question = 8,                      // ?
      syntax_open_set = 9,                      // [
      syntax_close_set = 10,                    // ]
      syntax_or = 11,                           // |
      syntax_slash = 12,                        //
      syntax_hash = 13,                         // #
      syntax_dash = 14,                         // -
      syntax_open_brace = 15,                   // {
      syntax_close_brace = 16,                  // }
      syntax_digit = 17,                        // 0-9
      syntax_b = 18,                            // for \b
      syntax_B = 19,                            // for \B
      syntax_left_word = 20,                    // for \&lt;
      syntax_right_word = 21,                   // for \
      syntax_w = 22,                            // for \w
      syntax_W = 23,                            // for \W
      syntax_start_buffer = 24,                 // for \`
      syntax_end_buffer = 25,                   // for \'
      syntax_newline = 26,                      // for newline alt
      syntax_comma = 27,                        // for {x,y}

      syntax_a = 28,                            // for \a
      syntax_f = 29,                            // for \f
      syntax_n = 30,                            // for \n
      syntax_r = 31,                            // for \r
      syntax_t = 32,                            // for \t
      syntax_v = 33,                            // for \v
      syntax_x = 34,                            // for \xdd
      syntax_c = 35,                            // for \cx
      syntax_colon = 36,                        // for [:...:]
      syntax_equal = 37,                        // for [=...=]

      // perl ops:
      syntax_e = 38,                            // for \e
      syntax_l = 39,                            // for \l
      syntax_L = 40,                            // for \L
      syntax_u = 41,                            // for \u
      syntax_U = 42,                            // for \U
      syntax_s = 43,                            // for \s
      syntax_S = 44,                            // for \S
      syntax_d = 45,                            // for \d
      syntax_D = 46,                            // for \D
      syntax_E = 47,                            // for \Q\E
      syntax_Q = 48,                            // for \Q\E
      syntax_X = 49,                            // for \X
      syntax_C = 50,                            // for \C
      syntax_Z = 51,                            // for \Z
      syntax_G = 52,                            // for \G
      syntax_bang = 53,                         // reserved for future use '!'
      syntax_and = 54,                          // reserve for future use '&'
   };

   enum{
      char_class_none = 0,
      char_class_alpha,
      char_class_cntrl,
      char_class_digit,
      char_class_lower,
      char_class_punct,
      char_class_space,
      char_class_upper,
      char_class_xdigit,
      char_class_blank,
      char_class_unicode,
      char_class_alnum,
      char_class_graph,
      char_class_print,
      char_class_word
   };

   static size_t length(const char_type* p);
   unsigned int syntax_type(size_type c)const;
   char_type translate(char_type c, bool icase)const;
   void transform(string_type& out, const string_type& in)const;
   void transform_primary(string_type& out, const string_type& in)const;
   bool is_separator(char_type c)const;
   bool is_combining(char_type)const;
   bool is_class(char_type c, uint32_t f)const;
   int toi(char_type c)const;
   int toi(const char_type*& first, const char_type* last, int radix)const;
   uint32_t lookup_classname(const char_type* first, const char_type* last)const;
   bool lookup_collatename(string_type& buf, const char_type* first, const char_type* last)const;
   locale_type imbue(locale_type l);
   locale_type getloc()const;
   std::string error_string(unsigned id)const;

   mytraits();
   ~mytraits();
};
```

特性クラスに求められるメンバ型は次のように定義されている:

| メンバ名      | 説明 |
|---------------|------|
| `char_type`   | この特性クラスがカプセル化する文字型。POD 型でなければならない。`uchar_type` に変換可能でなければならない。 |
| `uchar_type`  | `char_type` に対応する unsigned 型。`size_type` に変換可能でなければならない。 |
| `size_type`   | 符号なし整数型。`uchar_type` と同じ精度でなければならない。 |
| `string_type` | `std::basic_string<char_type>` と同じ能力を提供する型。これは照合要素、文字列のソートのために使われる。もし `char_type` がロケール依存の照合を持っていなければ ("文字"ではない)、これは `std::basic_string` よりも単純なものでよい。 |
| `locale_type` | 特性クラスで使われるロケールをカプセル化する型。おそらく `std::locale` だと思うが、プラットフォーム特有の型も可能である。または、もしインスタンス毎のロケールを特性クラスがサポートしないなら、ダミー型も可能である。 |
| `uint32_t`    | 少なくとも 32ビットの精度を持つ 符号なし整数型。文字分類のためのビットマスク型として使われる。 |
| `sentry`      | 特性クラスのインスタンスから構築可能で、 `void*` への変換可能なクラスもしくは構造体型。`sentry` 型のインスタンスはそれぞれの正規表現をコンパイルする前に構築される。これは、特性クラスの接頭辞/接尾辞操作を実行する機会を提供する。例えば、グローバルロケールをカプセル化した特性クラスは、(キャッシュされたデータを更新することで)グローバルロケールと同期する機会として、これを利用することが出来る。 |

次のメンバ定数は、ロケール非依存な正規表現の構文をあらわすために使われる。
メンバ関数 `syntax_type` はこれらの値のうちの一つを返し、ロケール依存の正規表現をロケール非依存なトークンのシーケンスに変換するために使われる。

| メンバ定数             | 英語での表現         |
|------------------------|----------------------|
| `syntax_char`          | 全ての特殊でない文字 |
| `syntax_open_bracket`  | (                    |
| `syntax_close_bracket` | )                    |
| `syntax_dollar`        | \$                   |
| `syntax_caret`         | \^                   |
| `syntax_dot`           | .                    |
| `syntax_star`          | \*                   |
| `syntax_plus`          | +                    |
| `syntax_question`      | ?                    |
| `syntax_open_set`      | [                    |
| `syntax_close_set`     | ]                    |
| `syntax_or`            | \|                   |
| `syntax_slash`         | \\                   |
| `syntax_hash`          | #                    |
| `syntax_dash`          | -                    |
| `syntax_open_brace`    | {                    |
| `syntax_close_brace`   | }                    |
| `syntax_digit`         | 0123456789           |
| `syntax_b`             | b                    |
| `syntax_B`             | B                    |
| `syntax_left_word`     | <                    |
| `syntax_right_word`    |                      |
| `syntax_w`             | w                    |
| `syntax_W`             | W                    |
| `syntax_start_buffer`  | \`                   |
| `syntax_end_buffer`    | '                    |
| `syntax_newline`       | \\n                  |
| `syntax_comma`         | ,                    |
| `syntax_a`             | a                    |
| `syntax_f`             | f                    |
| `syntax_n`             | n                    |
| `syntax_r`             | r                    |
| `syntax_t`             | t                    |
| `syntax_v`             | v                    |
| `syntax_x`             | x                    |
| `syntax_c`             | c                    |
| `syntax_colon`         | :                    |
| `syntax_equal`         | =                    |
| `syntax_e`             | e                    |
| `syntax_l`             | l                    |
| `syntax_L`             | L                    |
| `syntax_u`             | u                    |
| `syntax_U`             | U                    |
| `syntax_s`             | s                    |
| `syntax_S`             | S                    |
| `syntax_d`             | d                    |
| `syntax_D`             | D                    |
| `syntax_E`             | E                    |
| `syntax_Q`             | Q                    |
| `syntax_X`             | X                    |
| `syntax_C`             | C                    |
| `syntax_Z`             | Z                    |
| `syntax_G`             | G                    |
| `syntax_bang`          | !                    |
| `syntax_and`           | &                    |

次のメンバ定数は特別な文字分類を表すために使われる:

| メンバ定数           | 説明                                                                                   |
|----------------------|----------------------------------------------------------------------------------------|
| `char_class_none`    | 分類なし。ゼロでなければならない。                                                     |
| `char_class_alpha`   | 全てのアルファベット文字                                                               |
| `char_class_cntrl`   | 全てのコントロール文字                                                                 |
| `char_class_digit`   | 全ての10進数字                                                                         |
| `char_class_lower`   | 全ての小文字                                                                           |
| `char_class_punct`   | 全ての句読点                                                                           |
| `char_class_space`   | 全ての空白文字                                                                         |
| `char_class_upper`   | 全ての大文字                                                                           |
| `char_class_xdigit`  | 全ての16進数字                                                                         |
| `char_class_blank`   | 全てのブランク文字(スペースとタブ)                                                     |
| `char_class_unicode` | 全ての拡張ユニコード文字。これらは単一のナロウキャラクタとしてあらわすことができない。 |
| `char_class_alnum`   | 全ての文字と数字                                                                       |
| `char_class_graph`   | 全ての絵文字                                                                           |
| `char_class_print`   | 全ての印字可能文字                                                                     |
| `char_class_word`    | 単語を形成する文字全て(文字、数字、アンダースコア)                                     |

次のメンバ関数が全ての正規表現特性クラスに必要である。
ここで *const* として宣言されているメンバは、もしクラスがインスタンスのデータを含まなければ代わりに *static* として宣言することが出来る。

| メンバ関数 | 説明 |
|------------|------|
| `static size_t length(const char_type* p);` | null 終端文字列 p の長さを返す。|
| `unsigned int syntax_type(size_type c)const;` | 入力文字列をロケール非依存なトークン (`syntax_xxx` メンバ定数のひとつ) に変換する。正規表現をロケール非依存な解析木に構文解析するときに呼ばれる。<br/><br/>例: 英語での正規表現では、全ての単語形成文字の文字クラスをあらわすために、"[[:word:]]" とこの略記 "\\w" を使うことが出来る。結果的に、 `syntax_type('w')` は `syntax_w` を返す。フランス語での正規表現では、 "[[:word:]]" の代わりに、"[[:mot:]]" を、"\\w" の代わりに "\\m" を使うことが出来る。このため、 `syntax_w` を返すのは、 `syntax_type('m')` である。 |
| `char_type translate(char_type c, bool icase)const;` | 入力文字を、その文字が属する等価クラスをあらわす一意の識別子に変形する。もし `icase` が真なら、戻り値は大文字小文字を考慮しない。<br/><br/>[等価クラスは互いに等価であると扱われなければならない文字すべての集合である。] |
| `void transform(string_type& out, const string_type& in)const;` | 文字列 `in` をロケール依存のソートキーに変形し、`out` に結果を格納する。 |
| `void transform_primary(string_type& out, const string_type& in)const;` | 文字列 `in` をロケール依存の主ソートキーに変形し、結果を `out` に格納する。 |
| `bool is_separator(char_type c)const;` | `c` が行の区切りなら `true` を返す。 |
| `bool is_combining(char_type c)const;` | `c` がユニコード複合文字なら `true` を返す。 |
| `bool is_class(char_type c, uint32_t f)const;` | `c` がビットマップ `f` であらわされる文字クラスの要素なら `true` を返す。 |
| `int toi(char_type c)const;` | 文字 `c` を10進整数に変換する。 <br/><br/>[事前条件: `is_class(c,char_class_digit)==true` ] |
| `int toi(const char_type*& first, const char_type* last, int radix)const;` | 文字列 `[first-last)` を基数 `radix` の整数値に変換する。最初の非数字文字を発見したら停止し、 `first` がその文字をさすように設定する。<br/><br/>[事前条件: `is_class(*first,char_class_digit)==true` ] |
| `uint32_t lookup_classname(const char_type* first, const char_type* last)const;` | 文字クラス `[first-last)` をあらわすビットマップを返す。もし `[first-last)` が文字クラス名として認識されたければ、 `char_class_none` を返す。 |
| `bool lookup_collatename(string_type& buf, const char_type* first, const char_type* last)const;` | シーケンス `[first-last)` が既知の照合要素名であれば、その照合要素を `buf` に格納し、 `true` を返す。そうでなければ、 `false` を返す。 |
| `locale_type imbue(locale_type l);` | クラスをロケール `l` にする。 |
| `locale_type getloc()const;` | 特性クラスのロケールを返す。 |
| `std::string error_string(unsigned id)const;` | エラー番号 `id` に対するロケール依存のエラー文字列を返す。引数 `id` は POSIX 標準で述べられ、 `<boost/cregex.hpp>` で定義されている `REG_XXX` エラーコードのひとつである。 |
| `mytraits();` | コンストラクタ |
| `~ mytraits();` | デストラクタ |

カスタマイズされた特性クラスの例が
[Christian Engstr・](mailto:christian.engstrom@glindra.org)
によっても提供されている。
[`iso8859_1_regex_traits.cpp`](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/iso8859_1_regex_traits/iso8859_1_regex_traits.cpp) 及び [`iso8859_1_regex_traits.hpp`](https://www.boost.org/doc/libs/1_31_0/libs/regex/example/iso8859_1_regex_traits/iso8859_1_regex_traits.hpp) を見よ。
この例は `c_regex_traits` を継承し、二つのロケール特有の関数についてのそれ自身の実装を提供している。
これは (ひとつのロケールに結び付けられる限り) 全てのプラットフォームでそのクラスが安定した振る舞いを与えることを保証する。

---

*Copyright* [*Dr John Maddock*](mailto:John_Maddock@compuserve.com) *1998-2001 all rights reserved.*

---

*Japanese Translation Copyright (C) 2003 [Kohske Takahashi](mailto:k_takahashi@cppll.jp)*

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。
このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。
また、いかなる目的に対しても、その利用が適していることを関知しない。

