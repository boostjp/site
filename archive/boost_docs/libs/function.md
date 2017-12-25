# Header `<boost/function.hpp>`

- 翻訳元ドキュメント： <http://www.boost.org/doc/libs/1_31_0/doc/html/function.html>

ヘッダファイル `<boost/function.hpp>` に含まれるのは、関数オブジェクトのラッパとなるクラステンプレート群である。 Boost.Function の概念はコールバックを一般化したものだ。 Boost.Function は以下の点で関数ポインタと共通の特徴をもっている。 1 つは、何らかの実装によって呼び出される「呼び出しのインタフェース」 (例: 2 つの `int` 型引数を取り、 `float` を返す関数) を定義していること。もう 1 つは、呼び出される実装をプログラム実行中に変更できる事だ。

一般に、遅延呼び出しやコールバックを実現するために関数ポインタを使うあらゆる場面で、代わりに Boost.Function を使用できる。そして、それによって呼ばれる側の実装はぐっと自由になる。呼ばれる側にはあらゆる「互換性のある」関数オブジェクト (や関数ポインタ) が指定できる。「互換性がある」とは、 Boost.Function に渡した引数が、対象となる関数オブジェクトの引数に変換できるということだ(訳注：戻り値にも互換性が必要)。


## 目次
- [Compatibility Note](#compatibility-note)
- [Tutorial](function/tutorial.md)
- [Reference manual](function/reference.md)
- [Boost.Function vs. Function Pointers](#function-vs-function-pointers)
- [Performance](#performance)
- [Portability](#portability)
- [Design rationale](#design-rationale)
- [Acknowledgements](#acknowledgements)
- [FAQ](function/faq.md)


## <a id="compatibility-note" href="#compatibility-note">Compatibility Note</a>
Boost.Function は、インタフェースを小さく、分かりやすくするために、一部が再設計された。昔の Boost.Function にあった、いくつかのめったに (または決して) 使われない機能は推奨されなくなり、近々削除される。以下に推奨されなくなった機能とその理由、それに伴うコードの修正法をリストアップする。

- `boost::function` クラステンプレートの文法が変更された。以前は`boost::function<int, float, double, std::string>`のように書いたが、 `boost::function<int (float, double, std::string)>`のような、より自然な書き方になった。戻り値と全ての引数の型が、 1 つの関数型のパラメータに収まる事になったのだ。残りのテンプレートパラメータ (`Allocator`など) が、この関数型パラメータの後に続く。
	この変更への対応は、コンパイラに依存する。あなたのコンパイラがテンプレートの部分特殊化版をサポートし、関数型をパース (これは大抵 OK) できるなら、新しい文法を使うようにソースを修正してもいいし (推奨) 、文法が変わっていない`functionN` クラスを直接使ってもいい。あなたのコンパイラがテンプレートの部分特殊化版か関数型をサポートしていなければ、`functionN`クラスを使う必要がある。`functionN`クラスを使うように修正するのは簡単で、クラス名の最後に引数の数を加えるだけだ (例: `boost::function<void, int, int>` を `boost::function2<void, int, int>` に変更) 。
	`boost::function` クラステンプレートの古い文法のサポートはしばらく続くが、いつかは削除される。削除した方がエラーメッセージが分かりやすくなり、リンク互換性が良くなるからだ。
- 呼び出しポリシーのテンプレートパラメータ (`Policy`) は推奨されておらず、将来削除される。この機能はめったに使われないので、代替となる機能は無い。
- ミックスインのテンプレートパラメータ (`Mixin`) は推奨されておらず、将来削除される。この機能はめったに使われないので、代替となる機能は無い。
- `set` メソッドは推奨されておらず、将来削除される。代わりに代入演算子を使えば良い。

新しい文法に移行し、推奨されない機能を削除するためには、 `BOOST_FUNCTION_NO_DEPRECATED` プリプロセサマクロを定義する。このマクロを定義すると、推奨されない全ての機能が使えなくなる。 `BOOST_FUNCTION_NO_DEPRECATED` を使ってコンパイルされたプログラムなら、推奨されない機能が削除されても大丈夫だ。


## <a id="function-vs-function-pointers" href="#function-vs-function-pointers">Boost.Function vs. Function Pointers</a>
Boost.Function には関数ポインタに比べていくつかの利点がある。

- Boost.Function は、任意の互換性がある関数オブジェクトを格納できる (関数ポインタは全く同じシグネチャを持つ関数しか受け付けない) 。
- Boost.Function は、引数の束縛などの関数オブジェクトを作り出すライブラリと共用できる。
- Boost.Function を使えば、空の関数オブジェクトの呼び出しを、デバッグ時に簡単に検出できる。
- Boost.Function では、それぞれの呼び出しの前後に、ある操作を実行するように指定できる。例えば、同期用の基本命令を関数型の一部にすることができる(訳注：この機能 (呼び出しポリシー) は推奨されておらず、将来削除される)。

そしてもちろん、関数ポインタにも Boost.Function に比べていくつかの利点がある。

- 関数ポインタはサイズが小さい (関数ポインタはポインタ 1 つ、 Boost.Function はポインタ 3 つ) 。
- 関数ポインタは高速だ (Boost.Function は関数ポインタを通した呼び出しを 2 回する可能性がある) 。
- 関数ポインタは C のライブラリと下位互換性がある。
- エラーメッセージが読みやすい。

以上 2 つのリストは Darin Adler のコメントを編集したものである。


## <a id="performance" href="#performance">Performance</a>

### Function object wrapper size

関数オブジェクトのラッパのサイズは 2 つの関数ポインタと、 1 つの関数ポインタまたはデータのポインタ (の大きい方) のサイズになる。一般的な 32 ビットプラットフォームでは、 1 つのラッパ当たり 12 バイトになる。さらに、対象となる関数オブジェクトがヒープに割り当てられる。


### Copying efficiency

関数オブジェクトのラッパのコピーによって、格納された関数オブジェクトのコピーのためにメモリ割り当てが発生する。デフォルトのアロケータを、もっと速いカスタムアロケータで置換することもできる。また、関数オブジェクトのラッパが、対象となる関数オブジェクトの「参照」を格納するように指定できる (`ref`を使用) 。これは関数オブジェクトのコピーが酷く高価な場合に有効だ。


### Invocation efficiency

適切なインライン化を行うコンパイラならば、関数オブジェクトの呼び出しによって、関数ポインタを通した呼び出しが 1 回行われる。非メンバ関数ポインタの呼び出しならば、その関数ポインタの呼び出しに加えて、もう 1 回の呼び出しが行われる (コンパイラがとても強力な関数をまたいだ分析を行うならば別だが) 。


## <a id="portability" href="#portability">Portability</a>
Boost.Function は、できるだけ移植性を高めるように、できるだけ多くのコンパイラ (C++ 標準準拠度が低いものも含む) をサポートするように設計されている。以下のコンパイラは `boost::function`に含まれる全てのテストケースに合格した。

- GCC 2.95.3
- GCC 3.0
- SGI MIPSpro 7.3.0
- Borland C++ 5.5.1
- Comeau C++ 4.2.45.2
- Metrowerks Codewarrior 6.1

以下のコンパイラでも `boost::function`を使えるが、いくつか問題がある。

- Microsoft Visual C++ 6.0 (service pack 5): アロケータはサポートされない。 `boost::function` クラステンプレートにいくつか問題がある ( `boost::functionN` の方は動作するようだ) 。
- Intel C++ 5.0: アロケータはサポートされない。

あなたのコンパイラが上のリストになければ、 `boost::function` ライブラリを使えるかチェックするための小さなテスト群があるので、これを使える。標準に準拠したコンパイラなら、修正無しでコードをコンパイルできるはずだが、問題が起きたらバグレポートを送ってほしい。


## <a id="design-rationale" href="#design-rationale">Design rationale</a>

### Combatting virtual function bloat

多くのコンパイラでは、仮想関数の使用によって「コードの膨張」が起きがちである。クラスが仮想関数を持つ場合、オブジェクトの型を分類する補助関数を作る必要がある。私達の経験では、多くの `boost::function` オブジェクトが使われると、この補助関数が実行可能ファイルのサイズを大きく膨張させる。

Boost.Function では、仮想関数の代わりに非メンバ関数を使った、代わりの等価なアプローチをとっている。 Boost.Function オブジェクトが関数オブジェクトを呼び出すためには、本質的に 2 つのポインタを持つ必要がある。所有する関数オブジェクトへの `void` ポインタと、関数オブジェクトの「呼び出し役」への `void` ポインタ (関数ポインタが代入される) だ。 Boost.Function が提供する、引数と戻り値の変換は、この呼び出し役が実行する。第 3 のポインタは「管理者」と呼ばれる非メンバ関数を指す。これは関数オブジェクトのコピーと破棄を扱う。この方法はタイプセーフだ。なぜなら、関数オブジェクトを実際に扱う関数である呼び出し役と管理者は、関数オブジェクトの型を知らされてインスタンス化されるので、入ってくる `void` ポインタ (関数オブジェクトへのポインタ) を、正しい型に安全にキャストできるからだ。


## <a id="acknowledgements" href="#acknowledgements">Acknowledgements</a>
たくさんの人がこのライブラリの作成に参加した。 William Kempf 、 Jesse Jones 、 Karl Nelson は、ライブラリのインタフェースと守備範囲を、他のライブラリとは独立したものにする上で大きな助けになってくれた。 John Maddock は公式なレビューをやってくれた。他にもたくさんの人がレビューをして、インタフェース、実装、ドキュメントについて優れたコメントを寄せてくれた。


***
Douglas Gregor

Japanese Translation Copyright © 2003 [Hiroshi Ichikawa](mailto:gimite@mx12.freecom.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

このドキュメントの対象: Boost Version 1.29.0

