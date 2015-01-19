#BFS（幅優先探査）Visitor Concept
このコンセプトは [`breadth_first_search()`](./breadth_first_search.md) 用のビジタのインタフェースを定義する。ユーザは BFS Visitor インタフェースを持つクラスを定義して、そのクラスのオブジェクトを `breadth_first_search()` に渡すことができ、それによってグラフ探索中に実行される動作を追加できる。


##Refinement of
[Copy Constructible](../utility/CopyConstructible.md) (ビジタのコピーは軽い操作である方がいい)


##表記

| 識別子  | 説明 |
|---------|------|
| `V`     | BFS Visitor のモデルの型。 |
| `vis`   | `V` 型のオブジェクト。 |
| `G`     | `Graph` のモデルの型。 |
| `g`     | `G` 型のオブジェクト。 |
| `e`     | `boost::graph_traits<G>::edge_descriptor` 型のオブジェクト。 |
| `s`,`u` | `boost::graph_traits<G>::vertex_descriptor` 型のオブジェクト。 |


##関連型
なし


##有効な表現式

| 名前 | 式 | 戻り値 | 説明 |
|------|----|--------|------|
| Initialize Vertex | `vis.initialize_vertex(s, g)` | `void` | グラフ探索の開始の前に、全ての頂点に対して実行される。 |
| Discover Vertex   | `vis.discover_vertex(u, g)`   | `void` | 各頂点に初めて遭遇した時に実行される。 |
| Examine Vertex    | `vis.examine_vertex(u, g)`    | `void` | 各頂点がキューからポップされた時に実行される。これは、頂点 `u` の各出力辺に対して `examine_edge()` が実行される直前に起こる。 |
| Examine Edge      | `vis.examine_edge(e, g)`      | `void` | 各頂点が発見された後に、その頂点の各出力辺に対して実行される。 |
| Tree Edge | `vis.tree_edge(e, g)` | `void` | 各辺が、探索木を形成する辺の要素になった時に、その辺に対して実行される。 |
| Non-Tree Edge | `vis.non_tree_edge(e, g)` | `void` | 有向グラフでは後退辺と交差辺に対して、無向グラフでは交差辺に対して実行される。 |
| Gray Target | `vis.gray_target(e, g)` | `void` | 調査時に灰色に塗られている頂点を終点とする、木でない辺の部分集合に対して実行される。灰色は、頂点が今キューにいることを示す。 |
| Black Target | `vis.black_target(e, g)` | `void` | 調査時に黒に塗られている頂点を終点とする、木でない辺の部分集合に対して実行される。黒は、頂点がキューから除去されたことを示す。 |
| Finish Vertex | `vis.finish_vertex(u, g)` | `void` | ある頂点の全ての出力辺が探索木に追加され、全ての隣接する頂点が発見された後に、その頂点に対して実行される (ただし、隣接する頂点の出力辺を調査するよりは前に) 。 |


##モデル
[`bfs_visitor`](./bfs_visitor.md)


##関連項目
[Visitorコンセプト](./visitor_concepts.md)


***
Copyright © 2000-2001

- [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)
- [Lie-Quan Lee](http://www.boost.org/doc/libs/1_31_0/people/liequan_lee.htm), Indiana University (<mailto:llee@cs.indiana.edu>)
- [Andrew Lumsdaine](http://www.osl.iu.edu/~lums), Indiana University (<mailto:lums@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Hiroshi Ichikawa](mailto:gimite@mx12.freecom.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

