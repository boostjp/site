#EdgeListGraph
EdgeListGraph コンセプトは Graph コンセプトを 精製し、グラフ中の全ての辺への効率的なアクセスに必要とされるものを付け加えている。


##Refinement of
[Graph](./Graph.md)


##表記

| 識別子 | 説明 |
|--------|------|
| `G`    | EdgeListGraph のモデルの型。 |
| `g`    | `G` 型のオブジェクト。 |
| `e`    | 型が `boost::graph_traits<G>::edge_descriptor` のオブジェクト。 |


##関連型
- `boost::graph_traits<G>::traversal_category`
	- このタグ型は `edge_list_graph_tag` に変換可能でなければならない。
- `boost::graph_traits<G>::edge_iterator`
	- `edges(g)` を経由して得られる辺イテレータは、グラフ中の全ての辺へのアクセスを提供する。辺イテレータの型は [MultiPassInputIterator](../utility/MultiPassInputIterator.md) の要求を満たしていなけれはならない。辺イテレータの値型はグラフの辺記述子型と同じでなければならない。
- `boost::graph_traits<G>::edges_size_type`
	- 符号なし汎整数型はグラフ中の辺の数を表すのに使われる。


##有効な表現式

| 式 | 返却値 | 説明 |
|----|--------|------|
| `edges(g)`  | `std::pair<edge_iterator, edge_iterator>` | グラフ `g` 中の全ての辺へのアクセスを提供するイテレータ範囲を返す。 |
| `num_edges(g)` | `edges_size_type` | グラフ `g` 中の辺の数を返す。 |
| `source(e, g)` | `vertex_descriptor` | `e` によって表される辺 `(u,v)` の `u` のための頂点記述子を返す。 |
| `target(e, g)` | `vertex_descriptor` | `e` によって表される辺 `(u,v)` の `v` のための頂点記述子を返す。 |


##モデル
- [`adjacency_list`](./adjacency_list.md)
- [`edge_list`](./edge_list.md)


##計算量の保証
`edges()` 関数、`source()` 関数、そして `target()` 関数は、すべて定数時間内に終了するはずである。


##関連項目
[Graphコンセプト](./graph_concepts.md)


##コンセプトチェックするクラス

```cpp
template <class G>
struct EdgeListGraphConcept
{
  typedef typename boost::graph_traits<G>::edge_iterator 
    edge_iterator;
  void constraints() {
    function_requires< GraphConcept<G> >();
    function_requires< MultiPassInputIteratorConcept<edge_iterator> >();

    p = edges(g);
    E = num_edges(g);
    e = *p.first;
    u = source(e, g);
    v = target(e, g);
    const_constraints(g);
  }
  void const_constraints(const G& g) {
    p = edges(g);
    E = num_edges(g);
    e = *p.first;
    u = source(e, g);
    v = target(e, g);
  }
  std::pair<edge_iterator,edge_iterator> p;
  typename boost::graph_traits<G>::vertex_descriptor u, v;
  typename boost::graph_traits<G>::edge_descriptor e;
  typename boost::graph_traits<G>::edges_size_type E;
  G g;
};
```


***
Copyright © 2000-2001 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<jsiek@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Takashi Itou](takashi-it@po6.nsk.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

