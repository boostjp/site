# Boost.Signals 設計

このドキュメントは Boost.Signals に関する高レベルの設計を解説する。
追加のドキュメントが [設計の論拠](design_rationale.md) を解説する。

## 目次

- [型抹消](#type_erasure)
- [`connection` クラス](#connection)
- [スロット呼び出しイテレータ](#slot_call_iterator)
- [`visit_each` function template](#visit_each)

## <a name="type_erasure">型抹消</a>

型抹消は、テンプレート実体化で生成されるコードの量を減らすため、Boost.Signals ライブラリ中で広範に使われている。
各シグナルは、スロット名から関連する接続を写像する `std::map` とともに、スロットとそれに関係する接続のリストを管理しなければならない。
しかしながら、この map をすべてのトークン型、また場合によっては各翻訳単位 (普及しているテンプレート実体化戦略である) に対して実体化することは、コンパイル時間と空間負荷を増大させる。

このいわゆる "テンプレート膨張" に対抗するため、我々は未知の型と操作を格納する [Boost.Function](../function.md) と [Boost.Any](http://www.boost.org/doc/libs/1_31_0/libs/any/index.html) を用いている。
スロットのリストと名付けられたスロットから接続への写像を扱うコードはすべて、`any` と `Function` オブジェクトのみを扱う [`signal_base`](http://www.boost.org/doc/libs/1_31_0/boost/signals/detail/signal_base.hpp) クラスに含められ、実際の実装はよく知られた pimpl イディオムを用いて隠蔽されている。
実際の [`signalN`](reference/signalN.md) クラスは、引数の数によって変化する、もしくは connection のように本質的にテンプレート依存であるコードのみを扱う。

## <a name="connection">`connection` クラス</a>

`connection` クラスは Boost.Signals の働きにおいて中枢をなす。
これは Boost.Signals システムにおいて、与えられた接続に関連づけられた全オブジェクトを把握している唯一の存在である。
具体的には `connection` クラスそれ自身は、`basic_connection` オブジェクトを [`shared_ptr`](../smart_ptr.md) で薄くラップしたものに過ぎない。

`connection` オブジェクトは Signals システムの全関係者によって保持される:
各 [`trackable`](reference/trackable.md) オブジェクトは、すべての接続を記述する `connection` オブジェクトのリストを含む;
同様にシグナルはすべて、スロットを定義する対の集合を含む。
この対はスロットの関数オブジェクト (一般に [Boost.Function](../function.md) オブジェクト) と `connection` オブジェクトからなる。
この `connection` オブジェクトはシグナル破棄時に切断される。
最後にスロットグループからスロットへの対応は `std::multimap` のキー値に基づいている(`std::multimap` が保持するデータはスロットの対である)。

## <a name="slot_call_iterator">スロット呼び出しイテレータ</a>

スロット呼び出しイテレータは、スロットのリストを通じてその下にあるイテレータの振る舞いを変更するイテレータアダプタのスタックである。
下の表は、型と各イテレータアダプタに要求される振る舞いを記述している。
ただし、これは概念上のモデルであることに注意:
実装ではすべての層を単一のイテレータアダプタにまとめている。
なぜなら概念上のモデルを実装すると、いくつかの広く使われているコンパイラがコンパイルに失敗するからだ。

| イテレータアダプタ | 目的 |
|--------------------|------|
| Slot List Iterator | シグナルに接続されたスロットを貫くイテレータ。このイテレータの `value_type` は `std::pair<any, connection>` であり、 `any` はスロット関数型のインスタンスを保持する。 |
| Filter Iterator Adaptor | 切断されたスロットを除去する。したがって後のステージでは切断されたスロットは見えない。 |
| Projection Iterator Adaptor | 接続されたスロットを構成する pair の第一メンバへの参照(たとえばスロット関数を保持する `boost::any` オブジェクト) を戻す。 |
| Transform Iterator Adaptor | `any_cast` を行い、適切な関数型を伴ったスロット関数への参照を引き出す。 |
| Transform Iterator Adaptor | 下層のイテレータを参照外しして得られる関数オブジェクトに、シグナル自身に与えられた一連の引数を渡して呼び出しを行い、そのスロット呼び出しの結果を戻す。 |
| Input Caching Iterator Adaptor | 下層のイテレータを参照外しした結果をキャッシュする。したがってこのイテレータを複数回参照外ししても、下層のイテレータは一度だけ参照外しされる; つまりスロットは一度だけ呼ばれるが、結果は何度でも利用できる。 |
| Slot Call Iterator | Slot Call Iterator |

## 関数テンプレート <a name="visit_each">`visit_each`</a>

[`visit_each`](reference/visit_each.md) 関数テンプレートは、他のオブジェクトに格納されているオブジェクトを発見するための仕組みである。
関数テンプレート `visit_each` は 3 つの引数をとる:
走査対象のオブジェクト、各部分オブジェクトに対して呼び出される visitor 関数、そして `int` 0 である。

第三パラメタは、関数テンプレートに対する部分整列の欠落が広まっていることに対する一時的な解決策に過ぎない。
非特殊化版 `visit_each` 関数テンプレートではこの第三パラメタの型を `long` と定義しているが、ユーザによる特殊化では第三パラメタの型を `int` にしなければならない。
これにより、たとえばパラメタ `T` と `A<T>` 間の順序づけを行えない壊れたコンパイラであっても、汎整数 0 から `int` への変換の方が `long` への変更よりも適していると決定できる。
したがってこの変換によって決定される順序づけは、限られた範囲ではあるが正しく関数テンプレートの部分整列を達成する。
以下の例はこのテクニックの使用法を示している:

```cpp
template<typename>
class A {};

template<typename T>
void foo(T, long);

template<typename T>
void foo(A<T>, int);

A<T> at;
foo(at, 0);
```

この例では、コンパイラが `A<T>` が `T` よりも適している判断できないことを仮定している。
したがって関数テンプレートは、そのパラメタに基づいて順序づけることができないと仮定される。
ここで 0 から `int` への変換は 0 から `long` への変換よりも適しているため、二番目の関数テンプレートが選択される。

[Doug Gregor](http://www.cs.rpi.edu/~gregod)

Last modified: Fri Oct 11 05:40:53 EDT 2002

