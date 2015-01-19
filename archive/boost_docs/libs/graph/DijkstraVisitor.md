#Dijkstra Visitor Concept
このコンセプトは [`dijkstra_shortest_paths()`](./dijkstra_shortest_paths.md) 用のビジタのインタフェースと、関連するアルゴリズムを定義する。ユーザはこのインタフェースに一致するクラスを作って、そのクラスのオブジェクトを `dijkstra_shortest_paths()` に渡すことで、探索中に実行される操作を追加できる。


##Refinement of
[Copy Constructible](../utility/CopyConstructible.md) (ビジタのコピーは軽い操作である方がいい)


##表記

| 識別子 | 説明 |
|--------|------|
| `V`           | Dijkstra Visitor のモデルの型。 |
| `vis`         | `V` 型のオブジェクト。 |
| `G`           | Graph のモデルの型。 |
| `g`           | `G` 型のオブジェクト。 |
| `e`           | `boost::graph_traits<G>::edge_descriptor` 型のオブジェクト。 |
| `s`,`u`,`v`   | `boost::graph_traits<G>::vertex_descriptor` 型のオブジェクト。 |
| `DistanceMap` | [Read/Write Property Map](../property_map/ReadWritePropertyMap.md) のモデルの型。 |
| `d`           | `DistanceMap` 型のオブジェクト。 |
| `WeightMap`   | [Readable Property Map](../property_map/ReadablePropertyMap.md) のモデルの型。 |
| `w`           | `DistanceMap` 型のオブジェクト。 |


##関連型
なし


##有効な表現式

| 名前 | 式 | 戻り値 | 説明 |
|------|----|--------|------|
| Initialize Vertex | `vis.initialize_vertex(u, g)` | `void` | 初期化される時に、グラフの各頂点に対して実行される。 |
| Examine Vertex    | `vis.examine_vertex(u, g)`    | `void` | 各頂点がキューからポップされる時に、その頂点に対して実行される。これは頂点 `u` の各出力辺に対して `examine_edge()` が実行される直前に起こる。 |
| Examine Edge      | `vis.examine_edge(e, g)`      | `void` | 各頂点が発見された後に、その頂点の各出力辺に対して実行される。 |
| Discover Vertex   | `vis.discover_vertex(u, g)`   | `void` | 各頂点に初めて遭遇した時に実行される。 |
| Edge Relaxed      | `vis.edge_relaxed(e, g)`      | `void` | 調査時に、以下の条件が満たされれば、その辺は緩和される (距離が減らされる) 。この時、このメソッドが実行される。<br/> `tie(u,v) = incident(e, g);`<br/> `D d_u = get(d, u), d_v = get(d, v);`<br/> `W w_e = get(w, e);`<br/> `assert(compare(combine(d_u, w_e), d_v));` |
| Edge Not Relaxed  | `vis.edge_not_relaxed(e, g)`  | `void` | 調査時に、辺が緩和 (上を参照) されなければ、このメソッドが実行される。 |
| Finish Vertex     | `vis.finish_vertex(u, g)`     | `void` | ある頂点の全ての出力辺が探索木に追加され、全ての隣接する頂点が発見された後に、その頂点に対して実行される (ただし、隣接する頂点の出力辺を調査するよりは前に) 。 |


##モデル
[`dijkstra_visitor`](./dijkstra_visitor.md)


***
Copyright © 2000-2001

- [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)
- [Lie-Quan Lee](http://www.boost.org/doc/libs/1_31_0/people/liequan_lee.htm), Indiana University (<mailto:llee@cs.indiana.edu>)
- [Andrew Lumsdaine](http://www.osl.iu.edu/~lums), Indiana University (<mailto:lums@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Hiroshi Ichikawa](mailto:gimite@mx12.freecom.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

