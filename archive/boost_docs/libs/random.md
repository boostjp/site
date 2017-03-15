# Boost Random Number Library

乱数は、様々な種類のアプリケーションで役立つ。
Boost Random Number Library (略してBoost.Random)は、例えば一様分布といったような、有用な特徴をもつ乱数を生成するための膨大で多様な生成子と分布を供給する。

導入と基本的な概念の定義の理解のため、 [concepts documentation[概要]](random/random-concepts.md) を読むべきである。
早く始めたいのなら、[random_demo.cpp](http://www.boost.org/doc/libs/1_31_0/libs/random/random_demo.cpp) を一読すれば十分であろう。

## Library Organization

ライブラリは全て `boost/random/` ディレクトリ中に、複数のヘッダー・ファイルに分かれて存在している。
さらに、`boost/random/` 中に存在する他の全てのヘッダー・ファイルをインクルードしている便利なヘッダー・ファイルが、 [`boost/random.hpp`](http://www.boost.org/doc/libs/1_31_0/boost/random.hpp) として利用可能である。

各乱数生成子は、以下のヘッダー・ファイルで利用可能である。
生成子については [documentation](http://www.boost.org/doc/libs/1_31_0/libs/random/random-variate.html) を読まれたい。

- [`boost/random/linear_congruential.hpp`](http://www.boost.org/doc/libs/1_31_0/boost/random/linear_congruential.hpp)
- [`boost/random/additive_combine.hpp`](http://www.boost.org/doc/libs/1_31_0/boost/random/additive_combine.hpp)
- [`boost/random/inversive_congruential.hpp`](http://www.boost.org/doc/libs/1_31_0/boost/random/inversive_congruential.hpp)
- [`boost/random/shuffle_output.hpp`](http://www.boost.org/doc/libs/1_31_0/boost/random/shuffle_output.hpp)
- [`boost/random/mersenne_twister.hpp`](http://www.boost.org/doc/libs/1_31_0/boost/random/mersenne_twister.hpp)
- [`boost/random/lagged_fibonacci.hpp`](http://www.boost.org/doc/libs/1_31_0/boost/random/lagged_fibonacci.hpp)

同様に、各乱数分布は、以下のヘッダー・ファイルで利用可能である。
分布については [documentation](http://www.boost.org/doc/libs/1_31_0/libs/random/random-distributions.html) を読まれたい。

- [`boost/random/uniform_smallint.hpp`](http://www.boost.org/doc/libs/1_31_0/boost/random/uniform_smallint.hpp)
- [`boost/random/uniform_int.hpp`](http://www.boost.org/doc/libs/1_31_0/boost/random/uniform_int.hpp)
- [`boost/random/uniform_01.hpp`](http://www.boost.org/doc/libs/1_31_0/boost/random/uniform_01.hpp)
- [`boost/random/uniform_real.hpp`](http://www.boost.org/doc/libs/1_31_0/boost/random/uniform_real.hpp)
- [`boost/random/triangle_distribution.hpp`](http://www.boost.org/doc/libs/1_31_0/boost/random/triangle_distribution.hpp)
- [`boost/random/bernoulli_distribution.hpp`](http://www.boost.org/doc/libs/1_31_0/boost/random/bernoulli_distribution.hpp)
- [`boost/random/cauchy_distribution.hpp`](http://www.boost.org/doc/libs/1_31_0/boost/random/cauchy_distribution.hpp)
- [`boost/random/exponential_distribution.hpp`](http://www.boost.org/doc/libs/1_31_0/boost/random/exponential_distribution.hpp)
- [`boost/random/geometric_distribution.hpp`](http://www.boost.org/doc/libs/1_31_0/boost/random/geometric_distribution.hpp)
- [`boost/random/normal_distribution.hpp`](http://www.boost.org/doc/libs/1_31_0/boost/random/normal_distribution.hpp)
- [`boost/random/lognormal_distribution.hpp`](http://www.boost.org/doc/libs/1_31_0/boost/random/lognormal_distribution.hpp)
- [`boost/random/uniform_on_sphere.hpp`](http://www.boost.org/doc/libs/1_31_0/boost/random/uniform_on_sphere.hpp)

加えて、非決定論的乱数生成子が [`<boost/nondet_random.hpp>`](http://www.boost.org/doc/libs/1_31_0/boost/nondet_random.hpp) ヘッダで利用可能である。
([`Documentation`](http://www.boost.org/doc/libs/1_31_0/libs/random/nondet_random.html) も同様)

生成子と分布関数のインターフェースを他のコンセプトに配置するために、[`decorators[装飾子?]`](http://www.boost.org/doc/libs/1_31_0/libs/random/random-misc.html) が利用可能である。

## Tests

広範囲にわたる擬似乱数生成子と分布のためのテストスーツが [random_test.cpp](http://www.boost.org/doc/libs/1_31_0/libs/random/random_test.cpp) で利用可能である。

[random_speed.cpp](http://www.boost.org/doc/libs/1_31_0/libs/random/random_speed.cpp) を使用して得られた [performance results[実行結果]](http://www.boost.org/doc/libs/1_31_0/libs/random/random-performance.html) も見ることができる。

## Rationale

決定論的乱数と非決定論的乱数の生成及び算出手法は根本的に異なるものである。
おまけに、現代のコンピュータで本来的に使用されている決定論的[乱数生成]デザインのために、非決定論的乱数の生成手段を実装することは困難である。
そこで、この乱数ライブラリは、2つの異なる適用領域を反映して、複数のヘッダー・ファイルに分割されている。

## History and Acknowledgements

1999年11月、Jeet Sakumaran は仮想関数に基づくフレームワークを提案、後にテンプレートに基づく方法の大筋を記した。
Ed Brey が、Microsoft Visual C++ がクラス内のメンバ初期化をサポートしていないことを指摘し、`enum` による回避手段を提案。
Dave Abrahams が量子化の問題を強調した。

この乱数ライブラリの最初の公のリリースは、2000年3月、boost メーリングリストでの広範囲にわたる議論の末に実現した。
Beman Dawes のオリジナルの `min_rand` クラス、移植性の修正、文書の提案、そして全般的な指導に多大なる感謝を送る。
Harry Erwin は要求に対するさらなる識見をもたらすヘッダー・ファイルを送ってくれた。
Ed Brey と Beman Dawes はイテレータのようなインターフェースを欲していた。

Beman Dawes は、Matthias Trayer と Csaba Szepesvari、そして Thomas Holenstein が詳細なコメントを記述している間に、正式な再検討を成し遂げた。
この再検討された版は、2000年6月17日に公式に boost の一部となった。

Gary Powell は、コードのきれいさについての提案を貢献した。
Dave Abraham と Howard Hinnant は基本的な生成子テンプレートを `boost::detail` 名前空間から `boost::random` に移すよう提案した。

Ed Brey は過度の警告を取り除くよう頼み、`uint64_t` の取り扱い方について手助けをした。
Andreas Scherer は MSVC でのテストを行った。
Matthias Troyer は遅れのあるフィボナッチ(lagged_fibonacci)生成子を提供した。
Michael Stevens は normal_distribution のコピーセマンティックに潜んでいたバグを発見し、文書の改良を提案した。

[Jens Maurer](http://www.boost.org/doc/libs/1_31_0/people/jens_maurer.htm), 2001-08-31

Japanese Translation Copyright (C) 2003 KATOU Akira &lt;turugina@blue.sakura.ne.jp&gt;.

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の
複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」
に提供されており、いかなる明示的、暗黙的保証も行わない。また、
いかなる目的に対しても、その利用が適していることを関知しない。

