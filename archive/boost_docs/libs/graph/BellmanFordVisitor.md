#Bellman Ford Visitor Concept
このコンセプトは [`bellman_ford_shortest_paths()`](./bellman_ford_shortest_paths.md) 用のビジタのインタフェースを定義する。ユーザは Bellman Ford Visitor インタフェースを持つクラスを定義して、そのクラスのオブジェクトを `bellman_ford_shortest_paths()` に渡すことができ、それによってグラフ探索中に実行される動作を追加できる。


##Refinement of
[Copy Constructible](../utility/CopyConstructible.md) (ビジタのコピーは軽い操作である方がいい)


##表記

| 識別子  | 説明 |
|---------|------|
| `V`     | Bellman Ford Visitor のモデルの型。 |
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
| Examine Edge | `vis.examine_edge(e, g)` | `void` | グラフ内の各辺に対して `num_vertices(g)` 回実行される。 |
| Edge Relaxed | `vis.edge_relaxed(e, g)` | `void` | 調査時に、以下の条件が満たされれば、その辺は緩和される (距離が減らされる) 。この時、このメソッドが実行される。<br/> `tie(u,v) = incident(e, g);`<br/> `D d_u = get(d, u), d_v = get(d, v);`<br/> `W w_e = get(w, e);`<br/> `assert(compare(combine(d_u, w_e), d_v));` |
| Edge Not Relaxed | `edge_not_relaxed(e, g)` | `void` | 調査時に、辺が緩和 (上を参照) されなければ、このメソッドが実行される。 |
| Edge Minimized | `vis.edge_minimized(e, g)` | `void` | グラフ内の各辺を調査する `num_vertices(g)` 回の反復が終わった後に、各辺が最小化されたかをチェックするために最後の反復が行われる。辺が最小化されていれば、この関数が実行される。 |
| Edge Not Minimized | `edge_not_minimized(e, g)` | `void` | 辺が最小化されていなければ、この関数が呼ばれる。グラフ内に負の閉路が存在する時に、これが起こる。 |


##モデル
[`bellman_visitor`](./bellman_visitor.md)


***
Copyright © 2000-2001

- [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<jsiek@osl.iu.edu>)
- [Lie-Quan Lee](http://www.boost.org/doc/libs/1_31_0/people/liequan_lee.htm), Indiana University (<llee@cs.indiana.edu>)
- [Andrew Lumsdaine](http://www.osl.iu.edu/~lums), Indiana University (<lums@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Hiroshi Ichikawa](mailto:gimite@mx12.freecom.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

