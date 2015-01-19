#dag_shortest_paths
```cpp
// 名前付きパラメータバージョン
template <class VertexListGraph, class Param, class Tag, class Rest>
void dag_shortest_paths(const VertexListGraph& g,
   typename graph_traits<VertexListGraph>::vertex_descriptor s,
   const bgl_named_params<Param,Tag,Rest>& params)

// 名前無しパラメータバージョン
template <class VertexListGraph, class DijkstraVisitor, 
	  class DistanceMap, class WeightMap, class ColorMap, 
	  class PredecessorMap,
	  class Compare, class Combine, 
	  class DistInf, class DistZero>
void dag_shortest_paths(const VertexListGraph& g,
   typename graph_traits<VertexListGraph>::vertex_descriptor s, 
   DistanceMap distance, WeightMap weight, ColorMap color,
   PredecessorMap pred, DijkstraVisitor vis, 
   Compare compare, Combine combine, DistInf inf, DistZero zero)
```

このアルゴリズム [[8]](./bibliography.md#clr90) は 重み付きの非循環有向グラフ (DAG) の単一始点の最短経路問題を解く。 このアルゴリズムは DAG にとって、Dijkstra や Bellman-Ford アルゴリズムより 一層効率的である。全ての辺の重みが 1 に等しい時はこのアルゴリズムの代わりに幅優先探索を使いなさい。最短経路問題の定義のために、最短経路問題のいくつかの背景についての章 [Shortest-Paths Algorithms](./graph_theory_review.md#shortest-path-algorithms) を見なさい。

`dag_shortest_paths()` 関数から出力を得るための主な二つの選択が存在する。`distance_map()` パラメータを通して距離プロパティ・マップを提供するならばグラフ中の始点から他の全ての頂点への最短距離は距離マップに記録されるだろう。さらに最短経路木を先行点マップ (predecessor map) に記録する事ができる。その場合 `V` 中の各頂点 `u` にとって、最短経路木中では `p[u]` が `u` の先行点になるだろう (ただし `p[u] = u` でここに `u` が始点であるかまたは始点からは到達不能な頂点である場合を除く)。これらの二つの選択に加え、ユーザはアルゴリズムのイベント・ポイントのどれかの間アクションをとれる独自のビジタを提供することができる。


##定義場所
boost/graph/dag_shortest_paths.hpp


##パラメータ

- IN: `const VertexListGraph& g`
	- アルゴリズムが適用されるグラフオブジェクト。`VertexListGraph` の型は [Vertex List Graph](./VertexListGraph.md) のモデルでなければならない。

- IN: `vertex_descriptor s`
	- 始点。全ての距離はこの頂点から計算され、最短経路木はこの頂点を根とする。


##名前付きパラメータ

- IN: `weight_map(WeightMap w_map)`
	- グラフ中の各辺の重みまたは「長さ」。`WeightMap` の型は [Readable Property Map](../property_map/ReadablePropertyMap.md) のモデルでなければならない。グラフの辺記述子型は重みマップのキー型として使用できる必要がある。マップの値型は距離マップの値型を伴った Addable でなければならない。 
	- デフォルト: `get(edge_weight, g)`

- IN: `vertex_index_map(VertexIndexMap i_map)`
	- これは各頂点を `[0, num_vertices(g))` の範囲において整数にマップする。これは辺がリラックスされた (減らされた) 時、ヒープ・データ構造を効率よく更新するのに必要である。`VertexIndexMap` は [Readable Property Map](../property_map/ReadablePropertyMap.md) のモデルでなければならない。マップの値型は汎整数型でなければならない。グラフの頂点記述子型はマップのキー型として使用できる必要がある。
	- デフォルト: `get(vertex_index, g)`

- OUT: `predecessor_map(PredecessorMap p_map)`
	- 先行点マップ (predecessor map) は最小全域木中に辺を記録する。アルゴリズムの完了時に、`V` 中の全ての `u` のための辺 `(p[u],u)` は最小全域木中にある。もし `p[u] = u` なら `u` は始点かまたは始点から到達不能な頂点である。 `PredecessorMap` の型はキーと頂点の型がグラフの頂点記述子型と同じ [Read/Write Property Map](../property_map/ReadWritePropertyMap.md) でなければならない。
	- デフォルト: `dummy_property_map`

- UTIL/OUT: `distance_map(DistanceMap d_map)`
	- グラフ `g` 中の始点 `s` から各頂点への最短経路の重みは、このプロパティ・マップ中に記録される。最短経路の重みは、最短経路に沿った辺の重みの和である。`DistanceMap` の型は [Read/Write Property Map](../property_map/ReadWritePropertyMap.md) のモデルでなければならない。グラフの頂点記述子型は距離マップのキー型として使用できる必要がある。距離マップの値型は `combine` 関数 オブジェクトと単位要素のための `zero` オブジェクトから作られた [Monoid](./Monoid.md) の要素型である。さらに距離の値型は `compare` 関数オブジェクトによって供給される [StrictWeakOrdering](http://www.sgi.com/tech/stl/StrictWeakOrdering.html) の順序付けを持っていなければならない。
	- デフォルト: サイズ `num_vertices(g)` の `WeightMap` の値型の `std::vector` から作られた [`iterator_property_map`](../property_map/iterator_property_map.md) で、添え字マップには `i_map` を用いる。

- IN: `distance_compare(CompareFunction cmp)`
	- この関数はどの頂点が始点により近いか決定するために距離を比較するのに使われる。 `CompareFunction` の型は [Binary Predicate](http://www.sgi.com/tech/stl/BinaryPredicate.html) のモデルでなければならず、`DistanceMap` プロパティ・マップの値型に一致する引数型を持たなければならない。
	- デフォルト: `std::less<D>` ここで `D=typename property_traits<DistanceMap>::value_type` とする。

- IN: `distance_combine(CombineFunction cmb)`
	- この関数は道の距離を計算するために、距離を結合するのに使われる。 `CombineFunction` の型は [Binary Function](http://www.sgi.com/tech/stl/BinaryPredicate.html) のモデルでなければならない。二項関数の第一引数の型は `DistanceMap` プロパティ・マップの値型に一致していなければならず、第二引数の型は `WeightMap` プロパティ・マップの値型に一致していなければならない。結果型は距離の値型と同じでなければならない。
	- デフォルト: `std::plus<D>` ここで `D=typename property_traits<DistanceMap>::value_type` とする。

- IN: `distance_inf(D inf)`
	- `inf` オブジェクトは `D` オブジェクトのどの値よりも最も大きくなければならない。すなわち、`d != inf` の場合どれでも `compare(d, inf) == true` でなければならない。 `D` の型は `DistanceMap` の値型である。 
	- デフォルト: `std::numeric_limits<D>::max()`

- IN: `distance_zero(D zero)`
	- `zero` の値は距離の値と `combine` 関数オブジェクトによって作られた [Monoid](./Monoid.md) のための単一要素でなければならない。 `D` の型は `DistanceMap` の値型である。
	- デフォルト: `D()`

- UTIL/OUT: `color_map(ColorMap c_map)`
	- これは頂点に印をつけるためにアルゴリズムの実行の間使われる。頂点は白色から始めて、それがキュー中に挿入された時に灰色になる。それからそれがキューから取り除かれた時に黒色になる。アルゴリズムの終了時に、始点から到達可能な頂点は黒色に色づけされている。その他の全ての頂点は白色のままである。`ColorMap` の型は [Read/Write Property Map](../property_map/ReadWritePropertyMap.md) のモデルでなければならない。頂点記述子はマップのキー型として使用できる必要があり、マップの値型は [Color Value](./ColorValue.md) のモデルでなければならない。 
	- デフォルト: サイズ `num_vertices(g)` の `default_color_type` の `std::vector` から作られた [`iterator_property_map`](../property_map/iterator_property_map.md) で、添え字マップには `i_map` を用いる。

- OUT: `visitor(DijkstraVisitor v)`
	- アルゴリズム内の一定のイベント・ポイントの間に起こしたいアクションを指定するのに使いなさい。`DijkstraVisitor` は [Dijkstra Visitor](./DijkstraVisitor.md) コンセプトのモデルでなければならない。ビジタ・オブジェクトは値渡しされる [[1]](#note_1)。
	- デフォルト: `dijkstra_visitor<null_visitor>`


##計算量
時間計算量は O(V + E) である。


##ビジタ・イベント・ポイント

- `vis.initialize_vertex(u, g)` は、アルゴリズムの開始前に各頂点で呼び出される。
- `vis.examine_vertex(u, g)` は、頂点が集合 `S` に加えられた時に呼び出される。この時点で `(p[u],u)` は最短経路木の辺であることがわかるので、 `d[u] = delta(s,u) = d[p[u]] + w(p[u],u)` である。さらに調査された頂点の距離は単調増加 `d[u1] <= d[u2] <= d[un]` である。
- `vis.examine_edge(e, g)` は、頂点の各出辺において、頂点が集合 `S` に加えられた後で直ちに呼び出される。
- `vis.edge_relaxed(e, g)` は、辺 `(u,v)` において、 もし `d[u] + w(u,v) < d[v]` であるなら呼び出される。頂点 `v` のための最近のリラックス (減少) にあずかった辺 `(u,v)` は最短経路木の中にある辺である。
- `vis.discover_vertex(v, g)` は、頂点 `v` において、 `(u,v)` が調査されて `v` が白色である時に呼び出される。頂点が発見されていれば灰色に色づけされており、各到達可能な頂点はきっかり一度発見されるからである。
- `vis.edge_not_relaxed(e, g)` は、もし辺がリラックスされない (上を見よ) なら呼び出される。
- `vis.finish_vertex(u, g)` は、頂点の出辺が全て調査された後に呼び出される。


##コード例
[examples/dag_shortest_paths.cpp](./examples/dag_shortest_paths.cpp.md) を見よ。これはこのアルゴリズムの使用例である。


##注釈
<a name="note_1" href="#note_1">[1]</a> ビジタのパラメータは値渡しされるので、もしビジタが状態を持っているなら、アルゴリズムの間のいかなる状態の変更も、送ったビジタ・オブジェクトには行われず ビジタ・オブジェクトのコピーに対して行われる。それゆえポインタまたはリファレンスによってこの状態をビジタに保持させることを望むかもしれない。


***
Copyright © 2000-2001 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Takashi Itou](mailto:takashi-it@po6.nsk.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

