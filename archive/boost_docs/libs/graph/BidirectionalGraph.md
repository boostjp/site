#BidirectionalGraph

BidirectionalGraph コンセプトは、[IncidenceGraph](./IncidenceGraph.md) を精製し、各頂点の入辺への効率的なアクセスのために必要とされるものを付け加えている。 有向グラフにとって、入辺への効率的なアクセスは一般的により多くの記憶スペースを必要とし、多くのアルゴリズムは入辺へのアクセスを必要としないため、 このコンセプトは [IncidenceGraph](./IncidenceGraph.md) から分離されている。 無向グラフにとってはこれは問題とならない。というのは `in_edges()` 関数 と `out_edges()` 関数は同じであり、両方の関数は頂点に隣接した辺を返すからである。


##Refinement of
[IncidenceGraph](./IncidenceGraph.md)


##表記

| 識別子 | 説明 |
|--------|------|
| `G`    | Graph のモデルの型。 |
| `g`    | 型 `G` のオブジェクト。 |
| `v`    | 型 `boost::graph_traits<G>::vertex_descriptor` のオブジェクト。 |


##関連型

- `boost::graph_traits<G>::traversal_category`
	- このタグ型は `bidirectional_graph_tag` に変換可能でなければならない。

- `boost::graph_traits<G>::in_edge_iterator`
	- 頂点 `v` のための入辺イテレータは `v` の入辺へのアクセスを提供する。そのため入辺イテレータの値型はそのグラフの辺記述子型である。 入辺イテレータは [MultiPassInputIterator](./MultiPassInputIterator.md) の要求を満たしていなければならない。


##有効な表現式

| 式 | 説明 |
|----|------|
| `in_edges(v, g)` | グラフ `g` 中の頂点 `v` の入辺 (有向グラフ) または接続辺 (無向グラフ) へのアクセスを提供するイテレータ範囲を返す。 有向グラフと無向グラフの両方にとって、出辺の終点は頂点 `v` で あることと、始点が `v` に隣接している頂点であることが要求される。<br/> 返却値型: `std::pair<in_edge_iterator, in_edge_iterator>` |
| `in_degree(v, g)` | グラフ `g` 中の頂点 `v` の入辺の数 (有向グラフ) または 接続辺の数 (無向グラフ) を返す。<br/> 返却値型: `degree_size_type` |
| `degree(v, g)`    | グラフ `g` 中の頂点 `v` の入辺と出辺を足した数 (有向グラフ) または接続辺の数 (無向グラフ) を返す。<br/> 返却値型: `degree_size_type` |


##モデル
- [`adjacency_list`](./adjacency_list.md) で `Directed=bidirectionalS`
- [`adjacency_list`](./adjacency_list.md) で `Directed=undirectedS`


##計算量の保証
`in_edges()` は定数時間であることを必要とする。 `in_degree()` 関数と `degree()` 関数は入辺の数 (有向グラフ) または接続辺の数 (無向グラフ) による線形時間であるはずである。


##関連項目
[Graphコンセプト](./graph_concepts.md)


##コンセプトチェックするクラス

```cpp
template <class G>
struct BidirectionalGraph_concept
{
  typedef typename boost::graph_traits<G>::in_edge_iterator
    in_edge_iterator;
  void constraints() {
    function_requires< IncidenceGraphConcept<G> >();
    function_requires< MultiPassInputIteratorConcept<in_edge_iterator> >();

    p = in_edges(v, g);
    e = *p.first;
    const_constraints(g);
  }
  void const_constraints(const G& g) {
    p = in_edges(v, g);
    e = *p.first;
  }
  std::pair<in_edge_iterator, in_edge_iterator> p;
  typename boost::graph_traits<G>::vertex_descriptor v;
  typename boost::graph_traits<G>::edge_descriptor e;
  G g;
};
```


***
Copyright © 2000-2001 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<jsiek@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Takashi Itou](takashi-it@po6.nsk.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

