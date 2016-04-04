#Smart Pointers

スマートポインタは動的に割り当てられた(ヒープ上の)オブジェクトへのポインタを保持するオブジェクトである。
これは C++ 組み込みポインタのように振舞うが、指されたオブジェクトを適当なタイミングで自動的に削除する。
スマートポインタは、動的に割り当てられたオブジェクトを、例外が発生しても確実に破棄したいようなときに特に役立つ。
また複数の所有者に共有されている、動的に割り当てられたオブジェクトを管理するのにも使える。

概念的にはスマートポインタは指されたオブジェクトを所有しているように見える。
そしてオブジェクトがもはや必要なくなった時、責任を持って削除する。

スマートポインタライブラリは5種類のスマートポインタクラステンプレートを提供する:

| スマートポインタ | ヘッダ | 概要 |
|---|---|---|
| [`scoped_ptr`](scoped_ptr.md) | [&lt;boost/scoped_ptr.hpp&gt;](http://www.boost.org/doc/libs/1_31_0/boost/scoped_ptr.hpp) | オブジェクトの所有権を独占する単純なスマートポインタ。コピー不可。 |
| [`scoped_array`](scoped_array.md) | [&lt;boost/scoped_array.hpp&gt;](http://www.boost.org/doc/libs/1_31_0/boost/scoped_array.hpp) | 配列を独占的に所有する単純なスマートポインタ。コピー不可。 |
| [`shared_ptr`](shared_ptr.md) | [&lt;boost/shared_ptr.hpp&gt;](http://www.boost.org/doc/libs/1_31_0/boost/shared_ptr.hpp) | 複数のポインタでオブジェクトの所有権を共有するスマートポインタ。 |
| [`shared_array`](shared_array.md) | [&lt;boost/shared_array.hpp&gt;](http://www.boost.org/doc/libs/1_31_0/boost/shared_array.hpp) | 複数のポインタで配列の所有権を共有するスマートポインタ。 |
| [`weak_ptr`](weak_ptr.md) | [&lt;boost/weak_ptr.hpp&gt;](http://www.boost.org/doc/libs/1_31_0/boost/weak_ptr.hpp) | `shared_ptr`が所有するオブジェクトを、所有しないで利用するスマートポインタ。 |

これらのテンプレートは`std::auto_ptr`テンプレートを補完するように設計されている。

これらは&quot;Resource Acquisition Is Initialization&quot;イディオム(訳注:RAIIイディオム、「資源獲得を初期化時に行う」ことによりオブジェクトの所有権の所在を明確にする)の典型例である。
このイディオムはBjarne Stroustrupの"The C++ Programming Language"第3版14.4章、資源管理の項で述べられている。

テストプログラム[smart_ptr_test.cpp](http://www.boost.org/doc/libs/1_31_0/libs/smart_ptr/test/smart_ptr_test.cpp)が正しい操作を確認するために提供されている。

Boost Smart Pointerライブラリの古いバージョンについてのページ[compatibility](compatibility.md)は、以前のバージョンのスマートポインタの実装からの変更について述べている。

[smart pointer timings](http://www.boost.org/doc/libs/1_31_0/libs/smart_ptr/smarttests.htm)はパフォーマンスの問題についての興味である。

##<a name="Common requirements">Common Requirements</a>

これらのスマートポインタクラステンプレートはテンプレートパラメータ`T`をもつ。
これはスマートポインタが指すオブジェクトの方を特定する。
スマートポインタテンプレートの振る舞いは、`T`型のオブジェクトのデストラクタか**delete演算子**が例外を投げるなら、未定義である。

`T`はスマートポインタの宣言という点で、不完全な型かもしれない。
通常、`T`はスマートポインタの実体化という点で完全な型である必要がある。
不完全な型の削除を含めて、この要求を脅かすこと全てを診断する(エラーとして扱う)ような実装が必要である。
[`checked_delete`](../utility/utility.md#checked_delete)関数テンプレートの記述を参考にせよ。

`shared_ptr`はこの制限を持たず、メンバ関数の多くは`T`が完全な型であることを要求しないことに注意せよ。

###Rationale

`T`への要求は、安全性を最大化しつつ、扱いやすいように、という格言の下で注意深く作られている。
この格言の中ではスマートポインタは、`T`が不完全な型である翻訳単位の中で現れる。
これは実装とインタフェースを分離し、インタフェースが利用される翻訳単位から実装を隠す。
それぞれのスマートポインタについてのこのドキュメントでの例は、このようなスマートポインタの利用を説明している。

`scoped_ptr`は`T`がデストラクト時に完全な型であることを要求するが、`shared_ptr`はそうでないことに注意せよ。

##Exception Safety

これらのスマートポインタクラスの多くの関数は、もし例外が投げられれば「効果なし」あるいは「これこれ以外は効果なし」として明示されている。
これはこれらのクラスの一つのオブジェクトが例外を投げた時、プログラムの状態全てが、結果的に例外を発生した関数が呼び出される前の状態と同じであることを意味している。
つまり発見しうる副作用がないことを保証している。
そうでない関数は決して例外を投げない。
関数が投げる唯一の例外は`std::bad_alloc`である(`T`が[common requirements](#Common requirements)を満たしていることを仮定する)。
`std::bad_alloc`を投げる可能性があると、明示的にドキュメントに書かれている関数だけが、この例外を投げる。

##Exception-specifications

Exception-specificationsは利用されない。
[exception-specification rationale](../../more/lib_guide.md#Exception-specification)を参考にせよ。

全てのスマートポインタテンプレートは決して例外を投げないメンバ関数を持っている。
決して例外を投げないというのは、自分自身に例外を投げることも、例外を投げる他の関数を呼び出すこともないということである。
これらのメンバはコメント: `//never throws`と明示されている。

指されたオブジェクト型を破壊(destroy)する関数は[common requirements](#Common requirements)によって例外を投げることを禁止されている。

##History and Acknowledgements

2002 年 1 月。
Peter Dimov により 4 つのクラスの全てが作り直された。
機能の追加とバグの修正が行われ、それぞれのクラスが 4 つのヘッダファイルに分割された。
`weak_ptr`が追加された。
変更箇所については[互換性](compatibility.md)のページを参照せよ。

2001 年 5 月。
Vladimir Prusにより、デストラクト時における完全型の必要性が提案された。
Dave Abrahams、Greg Colvin、Beman Dawes、Rainer Deyke、Peter Dimov、John Maddock、Vladimir Prus、Shankar Sai等を含めて行われた
評議により、改善策が導き出された。

1999 年 11 月。
Darin Adlerにより、共有スマートポインタ型の為の`operator ==`、`operator !=`、及び`std::swap`、`std::less`の特殊化版が提供された。

1999 年 9 月。
Luis Coelho により、`shared_ptr::swap`と`shared_array::swap`が提供された。

1999 年 4 月。
1999 年の 4 月、5 月に、Valetin BonnardとDavid Abrahamsにより非常に多くの改善に起因する提案が為される。

1998 年 10 月。
1994 年にGreg Colvinにより、C++ 標準化委員会にクラス`auto_ptr`とクラス`counted_ptr`が提案された。
`counted_ptr`は、現在の`scoped_ptr`や`shared_ptr`とほぼ同様のものである。
標準ドキュメントの94-168/N0555、例外安全スマートポインタ(Exception Safe Smart Pointers) の項に当たる。
委員会によりライブラリワーキンググループの勧告が否決された数少ない事例の一つとして`counted_ptr`は棄却され、所有権の譲渡のセマンティクスは驚くべき事に`auto_ptr`に追加された。

1998 年の 10 月に行われた、Per Andersson、Matt Austern、Greg Colvin、Sean Corfield、Pete Becker、Nico Josuttis、Dietmar K?l、Nathan Myers、Chichiang Wan、Judy Ward等による会議に於いて、Beman Dawesにより当初のセマンティクスを`safe_ptr`と`counted_ptr`という名前で復活させることが提案された。
議論の中で、4 つのクラスの名前が決定され、`std::auto_ptr`のインターフェースに厳密に準拠する必要はないという結論に達した。
そして、それぞれの関数のシグネチャとセマンティクスが決定された。

その後の3ヶ月以上、`shared_ptr`のために幾つかの実装が熟考され、[boost.org](http://www.boost.org)のメーリングリストで議論された。
実装に関する議論では、参照カウントの実装方法について繰り返し論じられた。
参照カウントをスマートポインタに指されるオブジェクトに結びつけて管理する方法と、指されるオブジェクトとは別に管理する方法のいずれに於いても、参照カウントの値が保持されなければならない。
そのためには、それぞれの方法に対し大きく分けて二つの実装が考えられた。

- 直接的な分離カウンタ : `shared_ptr`オブジェクトは、保持するオブジェクトへのポインタとカウンタへのポインタを持つ。
- 間接的な分離カウンタ : `shared_ptr`オブジェクトは、ヘルパオブジェクトへのポインタを持ち、そのヘルパオブジェクトが保持するオブジェクトへのポインタと
カウンタへのポインタを持つ。
- 埋め込み結合カウンタ : カウンタを保持するオブジェクトのメンバにする。
- プレースメント結合カウンタ : `new`演算子の操作でカウンタを結びつける。

Each implementation technique has advantages and disadvantages. 
We went so far as to run various timings of the direct and indirect approaches, and found that at least on Intel Pentium chips there was very little measurable difference. 
Kevlin Henney provided a paper he wrote on "Counted Body Techniques." Dietmar K?l suggested an elegant partial template specialization technique to allow users to choose which implementation they preferred, and that was also experimented with.

But Greg Colvin and Jerry Schwarz argued that "parameterization will discourage users", and in the end we choose to supply only the direct implementation.

---

Revised 4 February 2002

Copyright 1999 Greg Colvin and Beman Dawes. Copyright 2002 Darin Adler. 
Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies.
This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

Japanese Translation Copyright (C) 2003 [Kohske Takahashi](mailto:kohske@msc.biglobe.ne.jp), [Ryo Kobayashi](mailto:lenoir@zeroscape.org).

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。
このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。
また、いかなる目的に対しても、その利用が適していることを関知しない。

