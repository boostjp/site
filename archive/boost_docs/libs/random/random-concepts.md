# Random Number Generator Library Concepts

## Introduction

乱数は、以下に示すような様々に異なる問題領域において要求される。

- 計算 (シミュレーション、モンテ・カルロ積分)
- ゲーム (ランダムな敵の動き)
- セキュリティ (鍵生成)
- テスト (無作為なホワイトボックステスト)

Boost Random Number Generator Library は、計算やセキュリティの領域を要求する場合においてもこの生成子が使われ得るように、よく吟味され決定された特徴を持つ乱数生成子のフレームワークを提供する。

計算領域における乱数の一般的な概論は、以下を参照のこと。

> "Numerical Recipes in C: The art of scientific computing", William
> H. Press, Saul A. Teukolsky, William A. Vetterling, Brian P. Flannery,
> 2nd ed., 1992, pp. 274-328<br/>
> [訳注: 日本語版は、丹慶 勝市 他訳
> 「ニューメリカルレシピ・イン・シー 日本語版―C言語による数値計算のレシピ」
> 東京: 技術評論社、1993年 (ISBN: 4874085601)]

問題領域の要求に応じて、乱数生成子の様々なバリエーションが利用できる。

- 非決定論的乱数生成子
- 擬似乱数生成子
- 準乱数生成子

全てのバリエーションはいくつかの共通する特徴をもっている。
これらの（STLにおける）concept は、NumberGenerator や UniformRandomNumberGenerator と呼ばれる。
各 concept の定義は次節を参照のこと。

このライブラリの最終目標は以下のとおりである。

- サードパーティ製の乱数生成子との結合を容易にする。
- 生成子の妥当性を検証するインターフェイスの定義。
- 有名なディストリビューション[?]を模範とする簡便なフロントエンドクラスの提供。
- 最大効率の提供。
- フロントエンド処理における量子化効果を操作可能にする。(まだできていない)

## <a name="number_generator">Number Generator</a>

数生成子は、引数を取らない *関数オブジェクト* (std:20.3 [lib.function.object]) であり、全て `operator()` の呼出し毎に数値を返す。

以下の表において、`X` は、`T` 型のオブジェクトを返す数生成子クラスである。
また、`u` は `X` の値である。

### NumberGenerator の必須条件

| 式 | 返値型 | 事前/事後条件 |
|----|--------|---------------|
| `X::result_type` | `T` | `std::numeric_limits<T>::is_specialized` は真であり、`T` は `LessThanComparable` である。 |
| `u.operator()()` | `T` | - |

*注意:* NumberGenerator の必須条件は、返される数値の特性にいかなる制約を課すのもではない。

## <a name="uniform-rng">Uniform Random Number Generator</a>

一定乱数生成子は、与えられた範囲で一様に生成される乱数列を提供する NumberGenerator である。
この範囲は、コンパイル時に固定されているか、もしくはオブジェクトの実行時構築の後(のみ)でも与えることができる。

いくつかの(有限)集合 S の*下限値*は、S の(唯一の)メンバ l であり、S における全ての v に関して、 l &lt;= v が成り立つ。
同様に、いくつかの(有限)集合 S の*上限値*は、S の(唯一の)メンバ u であり、S における全ての v に関して、 v &lt;= u が成り立つ。

以下の表において、`X` は、`T` 型のオブジェクトを返す数生成子クラスであり、 `v` は、`X` の定値である。

`UniformRandomNumberGenerator` の必須条件

| 式 | 返値型 | 事前/事後条件 |
|----|--------|---------------|
| `X::has_fixed_range` | `bool` | コンパイル時定数。 `true` であれば、乱数が一定に生成される範囲はコンパイル時に決定しており、 メンバ変数 `min_value` と `max_value` が存在する。 *注意:* このフラグは、コンパイラの制限により `false` になり得る。 |
| `X::min_value` | `T` | コンパイル時定数。 `min_value` は `v.min()` と同値である。 |
| `X::max_value` | `T` | コンパイル時定数。 `max_value` は `v.max()` と同値である。 |
| `v.min()` | `T` | `operator()` によって返される全ての値集合の下限を返す。 この関数の返値はオブジェクトの生存期間を通じて不変である。 |
| `v.max()` | `T` |`std::numeric_limits<T>::is_integer` が真であれば、`operator()` によって返される全ての値集合の上限、偽であれば、`operator()` によって返される全ての値集合の上限より大きな、表現可能な最小の数を返す。いかなる場合においても、この関数の返値はオブジェクトの生存期間を通じて不変である。 |

メンバ関数 `min`、`max`、および `operator()` は、償却定数時間計算量を持つ。

*注意:* 整数生成子 (i.e. 整数 `T`) においては、生成される値 `x` は、 `min() <= x <= max()` を満たす。
非整数生成子 (i.e. 非整数 `T`)においては、 生成される値 `x` は、`min() <= x < max()` を満たす。

*論拠:* `min` と `max` による範囲の記述は2つの目的に役立つ。
一つは、[0..1) といったような正統な範囲に対する値のスケーリングを可能にする。
もう一つは、さらに進んだプロセスのために妥当であるかもしれない値の意味のあるビット(significant bit) を記述する。

整数における範囲は、閉じられた間隔 [min, max] であるが、これは基礎となる型が半開の間隔 [min, max+1) を表現することができない可能性があるためである。
非整数における範囲は、これまでの版のどちらつかずの状態より実用的であるため、半開の間隔 [min, max)である。 

*注意:* UniformRandomNumberGenerator コンセプトは `operator()(long)` を必須としていないため、 RandomNumberGenerator (std:25.2.11 [lib.alg.random.shuffle]) の必須事項を満足していない。
この要求を満足するためには [`random_number_generator`](http://www.boost.org/doc/libs/1_31_0/libs/random/random-misc.html#random_number_generator) アダプタを使用すること。

*論拠:* 整数範囲を持つ生成子による出力の異なる整数範囲へのマッピングは些細なことではないので、 `operator()(long)` は供給されていない。

## <a name="nondet-rng">Non-deterministic Uniform Random Number Generator</a>

非決定論的一様乱数生成子は、確率過程に基づく UniformRandomGenerator である。
それゆえ、この生成子は一連の真に無作為な数を提供する。
このような過程には、放射性核種崩壊、ツェーナー・ダイオードのノイズ、量子粒のトンネリング、サイコロを転がす、壺から引き当てる、コインを投げる、といった例を挙げることができる。
環境に依存するならば、ネットワーク・パケットの内部到達時間や、キーボードのイベントも確率過程の近似値になりえる。

[`random_device`](http://www.boost.org/doc/libs/1_31_0/libs/random/nondet_random.html#random_device) クラスは非決定論的乱数生成子のモデルである。

*注意:* このタイプの乱数生成子は、セキュリティ・アプリケーションに有用である。
外部からの攻撃者が数を予想し、暗号や認証鍵を入手されるのを防ぐ。
そこで、このコンセプトのモデルは、環境によって可能な範囲にかけて、いかなる情報も漏れないよう注意深くなければならない。
例えば、一時的な記憶域が必要でなくなったときにすぐに明示的に消去することは賢明である。

## <a name="pseudo-rng">Pseudo-Random Number Generator</a>

擬似乱数生成子は、決定論的擬似乱数列を提供する UniformRandomNumberGenerator である。
この擬似乱数は、いくつかのアルゴリズムと内部状態に基づいている。
線形合同生成子と逆合同生成子[?]は、このような擬似乱数生成子の例である。
しばしば、これらの生成子はパラメータに非常に敏感である。
悪い実装が使われるのを避けるため、外部のテスト・スーツは生成された数列と提供された値の妥当性が実際に一致することを確かめるべきである。

Donald E. Knuth は彼の著書 "The Art of Computer Programming, Vol. 2, 3rd edition, Addison-Wesley, 1997" の中で、擬似乱数生成に関して広範囲に及ぶ概観を示している。
特定の生成子に関する記述の中には補足の参考資料が含まれている。

*注意:* 擬似乱数生成子の状態は必然的に有限であるため、生成子によって返される数列はいずれはループすることになる。

UniformRandomNumberGenerator の必須事項に加えて、擬似乱数生成子にはいくらか追加の必須事項がある。
下記の表において、`X` は `T` 型のオブジェクトを返す擬似乱数生成子クラスであり、 `x` は `T` の値、`u` は `X` の値、そして `v` は `const` な `X` の値である。

### PseudoRandomNumberGenerator 必須事項

| 式 | 返値型 | 事前/事後条件 |
|----|--------|---------------|
| `X()` | - | 実装定義の状態で生成子を作成する。 *注意:* このように作成された生成子は、従属[?]しているか全く同一の乱数列を生成する可能性がある。 |
| `explicit X(...)` | - | ユーザに提供された状態を用いて生成子を作成する。 実装はコンストラクタの仮引数を明示すること。 |
| `u.seed(...)` | `void` | 現在の状態を引数に従って設定する。 少なくともデフォルトではないコンストラクタと同様のシグネチャを持つ関数を提供すること。 |
| `v.validation(x)` | `bool` | あらかじめ計算されハードコーディングされた、生成子の乱数列における 10001 番目の要素と `x` とを比較する。 妥当性の検証が有意味であるために、生成子はデフォルトコンストラクタによって構築されていなければならず、また `seed` は呼ばれていてはならない。 |

*Note:* The `seed` member function is similar to the `assign` member function in STL containers.
However, the naming did not seem appropriate.

Classes which model a pseudo-random number generator shall also model EqualityComparable, i.e. implement `operator==`.
Two pseudo-random number generators are defined to be *equivalent* if they both return an identical sequence of numbers starting from a given state.

Classes which model a pseudo-random number generator should also model the Streamable concept, i.e. implement `operator<<` and `operator>>`.
If so, `operator<<` writes all current state of the pseudo-random number generator to the given `ostream` so that `operator>>` can restore the state at a later time.
The state shall be written in a platform-independent manner, but it is assumed that the `locale`s used for writing and reading be the same.

The pseudo-random number generator with the restored state and the original at the just-written state shall be equivalent.

Classes which model a pseudo-random number generator may also model the CopyConstructible and Assignable concepts.
However, note that the sequences of the original and the copy are strongly correlated (in fact, they are identical), which may make them unsuitable for some problem domains.
Thus, copying pseudo-random number generators is discouraged; they should always be passed by (non-`const`) reference.

The classes [`rand48`](http://www.boost.org/doc/libs/1_31_0/libs/random/random-generators.html#rand48), [`minstd_rand`](http://www.boost.org/doc/libs/1_31_0/libs/random/random-generators.html#linear_congruential), and [`mt19937`](http://www.boost.org/doc/libs/1_31_0/libs/random/random-generators.html#mersenne_twister) are models for a pseudo-random number generator.

*Note:* This type of random-number generator is useful for numerics, games and testing.
The non-zero arguments constructor(s) and the `seed()` member function(s) allow for a user-provided state to be installed in the generator.
This is useful for debugging Monte-Carlo algorithms and analyzing particular test scenarios.
The Streamable concept allows to save/restore the state of the generator, for example to re-run a test suite at a later time.

## <a name="quasi-rng">Quasi-Random Number Generators</a>

A quasi-random number generator is a Number Generator which provides a deterministic sequence of numbers, based on some algorithm and internal state.
The numbers do not have any statistical properties (such as uniform distribution or independence of successive values).

*Note:* Quasi-random number generators are useful for Monte-Carlo integrations where specially crafted sequences of random numbers will make the approximation converge faster.

*[Does anyone have a model?]*

Jens Maurer, 2000-02-23

