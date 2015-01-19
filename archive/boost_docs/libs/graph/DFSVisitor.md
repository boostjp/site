#DFS Visitor Concept
このコンセプトは [`depth_first_search()`](./depth_first_search.md) 用のビジタのインタフェースを定義する。ユーザは DFS Visitor インタフェースを持つクラスを定義して、そのクラスのオブジェクトを `depth_first_search()` に渡すことができ、それによってグラフ探索中に実行される動作を追加できる。


##Refinement of
[Copy Constructible](../utility/CopyConstructible.md) (ビジタのコピーは軽い操作である方がいい)


##表記

| 識別子  | 説明 |
|---------|------|
| `V`     | DFS Visitor のモデルの型。 |
| `vis`   | `V` 型のオブジェクト。 |
| `G`     | Graph のモデルの型。 |
| `g`     | `G` 型のオブジェクト。 |
| `e`     | `boost::graph_traits<G>::edge_descriptor` 型のオブジェクト。 |
| `s`,`u` | `boost::graph_traits<G>::vertex_descriptor` 型のオブジェクト。 |


##関連型
なし


##有効な表現式

| 名前 | 式 | 戻り値 | 説明 |
|------|----|--------|------|
| Initialize Vertex | `vis.initialize_vertex(s, g)` | `void` | グラフ探索の開始の前に、グラフの全ての頂点に対して実行される。 |
| Start Vertex    | `vis.start_vertex(s, g)`    | `void` | 探索の前に 1 度、始点に対して実行される。 |
| Discover Vertex | `vis.discover_vertex(u, g)` | `void` | 各頂点に初めて遭遇した時に実行される。 |
| Examine Edge    | `vis.examine_edge(e, g)`    | `void` | 各頂点が発見された後に、その頂点の各出力辺に対して実行される。 |
| Tree Edge       | `vis.tree_edge(e, g)`       | `void` | 各辺が、探索木を形成する辺の要素になった時に、その辺に対して実行される。 |
| Back Edge       | `vis.back_edge(e, g)`       | `void` | グラフの後退辺に対して実行される。無向グラフでは、辺 `(u,v)` と辺 `(v,u)` が同じ辺なので、木の辺か後退辺か曖昧な場合がある。この時は `tree_edge()` 関数と `back_edge()` 関数が両方とも実行される。この曖昧さを解決する 1 つの方法は、木の辺を記録し、既に木の辺として記録された後退辺を無視することだ。木の辺を記録するためには、 `tree_edge` イベントで先行点を記録するのが簡単だ。 |
| Forward or Cross Edge | `vis.forward_or_cross_edge(e, g)` | `void` | グラフの先行辺と交差辺に対して実行される。無向グラフでは、このメソッドは決して呼ばれない。 |
| Finish Vertex   | `vis.finish_vertex(u, g)`    | `void` | 頂点 `u` を根とする DFS 木の全ての頂点に対して `finish_vertex` が呼ばれた後に、頂点 `u` に対して実行される。頂点 `u` が DFS 木の葉であれば、 `u` の全ての出力辺が調査された後に、 `u` に対して `finish_vertex` が呼ばれる。 |


##モデル
[`dfs_visitor`](./dfs_visitor.md)


***
Copyright © 2000-2001

- [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)
- [Lie-Quan Lee](http://www.boost.org/doc/libs/1_31_0/people/liequan_lee.htm), Indiana University (<mailto:llee@cs.indiana.edu>)
- [Andrew Lumsdaine](http://www.osl.iu.edu/~lums), Indiana University (<mailto:lums@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Hiroshi Ichikawa](mailto:gimite@mx12.freecom.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

