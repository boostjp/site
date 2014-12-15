#AdjacencyGraph
AdjacencyGraph コンセプトは、グラフ中の頂点への隣接頂点の効率的なアクセス のためのインターフェースを供給する。これは [IncidenceGraph](./IncidenceGraph.md) コンセプト (出辺の終点が隣接頂点である) と非常に良く似ている。 いくつかの状況では頂点への関心のみがあり、しかし一方、他の状況では辺も同様に重要になるため、両者のコンセプトが供給された。


##Refinement of
[Graph](./Graph.md)


##表記

| 識別子 | 説明 |
|--------|------|
| `G`    | グラフのモデルの型。 |
| `g`    | 型が `G` のオブジェクト。 |
| `v`    | 型が `boost::graph_traits<G>::vertex_descriptor` のオブジェクト。 |


##関連型

- `boost::graph_traits<G>::traversal_category`

このタグ型は `adjacency_graph_tag` に変換可能でなければならない。


- `boost::graph_traits<G>::adjacency_iterator`

頂点 `v` のための隣接イテレータは `v` に隣接した頂点へのアクセスを提供する。そのため隣接イテレータの値型はそのグラフの頂点記述子型である。 隣接イテレータは [MultiPassInputIterator](./MultiPassInputIterator.md) の要求を満たしていなければならない。


##妥当な式

| 式 | 説明 |
|----|------|
| `adjacent_vertices(v, g)` | グラフ `g` 中の頂点 `v` に隣接している頂点へのアクセスを提供 するイテレータ範囲を返す。[[1]](#note1)<br/> 返却型: `std::pair<adjacency_iterator, adjacency_iterator>` |


##計算量の保証
`adjacent_vertices()` 関数は定数時間内に終了するはずである。


##関連項目
[Graphコンセプト](./Graph.md), [`adjacency_iterator`](./adjacency_iterator.md)


##コンセプトチェックするクラス

```cpp
template <class G>
struct AdjacencyGraphConcept
{
  typedef typename boost::graph_traits<G>::adjacency_iterator
    adjacency_iterator;
  void constraints() {
    function_requires< IncidenceGraphConcept<G> >();
    function_requires< MultiPassInputIteratorConcept<adjacency_iterator> >();

    p = adjacent_vertices(v, g);
    v = *p.first;
    const_constraints(g);
  }
  void const_constraints(const G& g) {
    p = adjacent_vertices(v, g);
  }
  std::pair<adjacency_iterator,adjacency_iterator> p;
  typename boost::graph_traits<G>::vertex_descriptor v;
  G g;
};
```


##設計原理
[IncidenceGraph](./IncidenceGraph.md) が同じ (それ以上の) 機能を実際に含んでいるので、AdjacencyGraph コンセプトはいくぶん軽薄である。 `adjacent_vertices()` が `out_edges()` よりも使用すると便利な状況があるので AdjacencyGraph コンセプトは存在する。 グラフ・クラスを構築しており、隣接イテレータを作成する余分な仕事を行いたくない場合は、恐れを持たないでいただきたい。 出辺イテレータから隣接イテレータを作成するために使用できる[`adjacency_iterator`](./adjacency_iterator.md)と名付けられたアダプタ・クラスがある。


##注釈
- <a name="note1" href="note1">[1]</a> **multigraph** (多数の辺が同じ二つの頂点を接続できる) の 場合は、`adjacent_vertices()` 関数によって返されたイテレータが各隣接頂点を一度含む範囲にアクセスするかどうか、また `out_edges()` 関数 のふるまいと一致し、二度以上隣接した頂点を含むことがある範囲にアクセスすべき かどうかとしての問題が持ち出される。 この決定はグラフ・アルゴリズムの実装と共により多くの経験を考慮して再検討される必要があるかもしれないが、今のところふるまいは `out_edges()` のそれと一致すると定義される。


***
Copyright © 2000-2001 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<jsiek@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Takashi Itou](takashi-it@po6.nsk.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

