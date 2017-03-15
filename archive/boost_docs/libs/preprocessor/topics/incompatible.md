# 非互換性

以前の Boost のリリース(1.28)とはいくつか非互換な部分がある。
それらは大雑把に言って三つのカテゴリにわけられる。

- `BOOST_PP_REPEAT` に基づく水平反復
- 再入構文
- *list* の畳み込み

## 反復ターゲット

まず、最も広く使われていると思われるのは、`BOOST_PP_REPEAT` へ渡されるターゲットマクロと、`BOOST_PP_REPEAT` を使った水平反復の構成である。
これはターゲットマクロを必要とするような全ての `BOOST_PP_REPEAT_*` と全ての `BOOST_PP_ENUM_*` を含む。

非互換性は自明であるが、それはソースの変更を必要とする。

これらのターゲットマクロは *第3の* 引数を期待するようになった。
追加されたのは各ターゲットマクロの *最初の* パラメータである。
It represents the next repetition dimension and brings `BOOST_PP_REPEAT` inline with rest of the library.

したがって次のようであったものは:

```cpp
# define macro(n, data) ...
BOOST_PP_REPEAT(5, macro, data)
```

...次のようになる:

```cpp
# define macro(z, n, data) ...
BOOST_PP_REPEAT(5, macro, data)
```

このパラメータは `BOOST_PP_REPEAT` メカニズムへの非常に効率的な再入に利用できる。
しかしながら、ライブラリは自動的に次の反復次元を見つけるため、それを必ずしも使う必要はない。

## 次元の順序付け

しかしこの自動的な検知により、`BOOST_PP_REPEAT_1ST`、`BOOST_PP_REPEAT_2ND`、`BOOST_PP_3RD`を順序からはずれて使うことは安全でない。
これらのマクロは *自動再帰* メカニズムをバイパスし、また *自動再帰* メカニズムは適切な順序でマクロが使われることに依存している。
これらのバイパスマクロを使うなら、一番外側の反復は `BOOST_PP_REPEAT_1ST`、次が `BOOST_PP_REPEAT_2ND`、最後が `BOOST_PP_REPEAT_3RD` で *なければならない*。
それ以外の使いかたはライブラリによってサポートされない。
時々は動作するかもしれないが、動作しないこともあるかもしれない。

## 再入構文

*自動再帰* も同様の問題がある。
以前は `BOOST_PP_WHILE` の再帰構文(と同様に `BOOST_PP_FOR`)は次のようであった:

```cpp
BOOST_PP_WHILE ## d(pred, op, state)
```

...あるいは:

```cpp
BOOST_PP_CAT(BOOST_PP_WHILE, d)(pred, op, state)
```

*自動再帰* モデルにおいて、`BOOST_PP_CAT` バージョンは使えない。
なぜなら `BOOST_PP_CAT` は連結の前に引数の展開を許すが、`BOOST_PP_WHILE` は引数無しで展開するからである。
このライブラリでそれは3つのパラメータを取るように見えるが、しかしそれは *自動再帰* のトリックである。
それは次のようなものと同様である:

```cpp
# define A(x, y) ...
# define B A
// ...
B(2, 3)
```

この構文は `B` マクロが2つの引数をとるように見えるが、実際はそうではない。
この `B` マクロが `A` に推移することを除いては、 *自動再帰* メカニズムも同様の流儀で動作する。

いくつかのプリプロセッサは動作が遅いため、直接的な再入(*自動再帰* 無しの)がいくつかの非自明なケースでいまだに必要とされる。
その結果、ライブラリは再入のために新しい構文を使う:

```cpp
BOOST_PP_FOR_ ## r(state, pred, op, macro)
BOOST_PP_REPEAT_ ## z(count, macro, data)
BOOST_PP_WHILE_ ## d(pred, op, state)
```

## 畳み込み

以前は `BOOST_PP_LIST_FOLD_RIGHT` マクロの引数は `BOOST_PP_LIST_FOLD_LEFT` の逆順であった。
また、`BOOST_PP_LIST_FOLD_RIGHT` へ渡される集積マクロも逆の引数で呼ばれていた。
この食い違いは解消された。

例示すると、`BOOST_PP_LIST_FOLD_RIGHT` は次のようであった:

```cpp
# define macro(d, elem, state)
BOOST_PP_LIST_FOLD_RIGHT(macro, list, state)
```

これは次のように置き換わった...

```cpp
# define macro(d, state, elem)
BOOST_PP_LIST_FOLD_RIGHT(macro, state, list)
```

## 概要

このライブラリは1.28リリースには無い新しい機能をたくさん持っていて、このリストはそれら全てを列挙するものではない。
これは単に、新しいリリースに互換となるためにコードを変更したければならないもののリストである。

## See Also

- [`BOOST_PP_FOR`](../ref/for.md)
- [`BOOST_PP_LIST_FOLD_RIGHT`](../ref/list_fold_right.md)
- [`BOOST_PP_REPEAT`](../ref/repeat.md)
- [`BOOST_PP_WHILE`](../ref/while.md)

---

Paul Mensonides

