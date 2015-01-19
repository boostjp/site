#edmunds_karp_max_flow
```cpp
// 名前付きパラメータバージョン
template <class VertexListGraph, class P, class T, class R>
typename detail::edge_capacity_value<VertexListGraph, P, T, R>::value_type
edmunds_karp_max_flow(VertexListGraph& g, 
   typename graph_traits<VertexListGraph>::vertex_descriptor src,
   typename graph_traits<VertexListGraph>::vertex_descriptor sink,
   const bgl_named_params<P, T, R>& params = all defaults)

// 名前無しパラメータバージョン
template <class VertexListGraph, 
	  class CapacityEdgeMap, class ResidualCapacityEdgeMap,
	  class ReverseEdgeMap, class ColorMap, class PredEdgeMap>
typename property_traits<CapacityEdgeMap>::value_type
edmunds_karp_max_flow(VertexListGraph& g, 
   typename graph_traits<Graph>::vertex_descriptor src,
   typename graph_traits<Graph>::vertex_descriptor sink,
   CapacityEdgeMap cap, ResidualCapacityEdgeMap res, ReverseEdgeMap rev, 
   ColorMap color, PredEdgeMap pred)
```
* VertexListGraph[link ./VertexListGraph.md]

`edmunds_karp_max_flow()` 関数はネットワークの最大流を計算する。最大流の記述のために章 [Network Flow Algorithms](./graph_theory_review.md#network-flow-algorithms) を見なさい。計算された最大流が関数の返却値になるだろう。関数はさらに `E` 中の全ての `(u,v)` のために流量 `f(u,v)` を計算する。そしてそれは、残差容量 `r(u,v) = c(u,v) - f(u,v)` の形で返される。

このアルゴリズムのために、入力グラフとプロパティ・マップのパラメータにいくつかの特別な必要条件がある。最初に、ネットワークを表す有向グラフ `G=(V,E)` は、 `E` 中の各辺のための逆辺 (reverse edge) を含むために増やされなければならない。換言すれば、入力グラフは <code>G<sub>in</sub> = (V,{E U ET})</code> であるべきである。`ReverseEdgeMap` 引数 `rev` は元のグラフ中の各辺をその逆辺にマップしなければならない。すなわち `E` 中の全ての `(u,v)` に対して `(u,v) -> (v,u)` である。`CapacityEdgeMap` 引数 `cap` は `E` 中の各辺を正の数にマップしなければならず、<code>E<sup>T</sup></code> 中の各辺は `0` にされなければならない。

このアルゴリズムは [Edmonds and Karp](./bibliography.md#edmonds72:_improvements_netflow) に負っている。もっとも [Network Flows](./bibliography.md#ahuja93:_network_flows) に述べられている「ラベリング・アルゴリズム」と呼ばれる亜種を使っているが。

このアルゴリズムは、最大流問題を実装するための大変単純で容易な解答である。しかしながら、このアルゴリズムが [`push_relabel_max_flow()`](./push_relabel_max_flow.md) アルゴリズムほどには良くないいくつかの理由がある。

- 非整数の容量の場合、時間計算量は最疎グラフを除く全てのグラフにとって push-relabel アルゴリズムの O(V<sup>2</sup>E<sup>1/2</sup>) より悪い O(V E<sup>2</sup>) である。
- 整数の容量の場合、もし容量の範囲 `U` が大変大きいならば、アルゴリズムに長い時間がかかるだろう。


##定義場所
boost/graph/edmunds_karp_max_flow.hpp


##パラメータ
- IN: `VertexListGraph& g`
	- 有向グラフ。グラフの型は [VertexListGraph](./VertexListGraph.md) のモデルでなければならない。グラフ中の各辺 `(u,v)` のために、逆辺 `(v,u)` もまたグラフ中になければならない。

- IN: `vertex_descriptor src`
	- 流れのネットワーク・グラフのためのソース頂点。

- IN: `vertex_descriptor sink`
	- 流れのネットワーク・グラフのためのシンク頂点。


##名前付きパラメータ
- IN: `capacity_map(CapacityEdgeMap cap)`
	- 辺容量プロパティ・マップ。型は定数 [Lvalue Property Map](../property_map/LvaluePropertyMap.md) のモデルでなければならない。マップのキー型はグラフの辺記述子型でなければならない。
	- デフォルト: `get(edge_capacity, g)`

- OUT: `residual_capacity_map(ResidualCapacityEdgeMap res)`
	- これは辺をその残差容量にマップする。型は変更可能の [Lvalue Property Map](../property_map/LvaluePropertyMap.md) のモデルでなければならない。マップのキー型はグラフの辺記述子型でなければならない。 
	- デフォルト: `get(edge_residual_capacity, g)`

- IN: `reverse_edge_map(ReverseEdgeMap rev)`
	- グラフ中の全ての辺 `(u,v)` を逆辺 `(v,u)` にマップする辺プロパティ・ マップ。マップは定数 [Lvalue Property Map](../property_map/LvaluePropertyMap.md) のモデルでなければならない。マップのキー型はグラフの辺記述子型でなければならない。
	- デフォルト: `get(edge_reverse, g)`

- UTIL: `color_map(ColorMap color)`
	- 幅優先探索の段階の間、進行過程を保持するためにアルゴリズムによって使われる。アルゴリズムの終了時に、白色の頂点は最小カット集合を定義する。マップは [Lvalue Property Map](../property_map/LvaluePropertyMap.md) のモデルでなければならない。マップのキー型はグラフの頂点記述子型であるべきで、値型は [ColorValue](./ColorValue.md) のモデルでなければならない。
	- デフォルト: サイズ `num_vertices(g)` の `default_color_type` の `std::vector` から作られた [`iterator_property_map`](../property_map/iterator_property_map.md)で、添え字マップには `i_map` を用いる。

- UTIL: `predecessor_map(PredEdgeMap pred)`
	- 増大した道を格納するためにアルゴリズムによって使われる。マップは変更可能の [Lvalue Property Map](../property_map/LvaluePropertyMap.md) でなければならない。キー型はグラフの頂点記述子型であるべきで、値型は グラフの辺記述子型でなければならない。
	- デフォルト: サイズ `num_vertices(g)` の 辺記述子の `std::vector` から作られた [`iterator_property_map`](../property_map/iterator_property_map.md)で、添え字マップには `i_map` を用いる。

- IN: `vertex_index_map(VertexIndexMap i_map)`
	- グラフの各頂点を `[0, num_vertices(g))` の範囲において唯一の整数にマップしなさい。このプロパティ・マップはカラー・マップまたは先行点マップのためにデフォルトが使われた時にのみ必要である。頂点添え字マップは [Readable Property Map](../property_map/ReadablePropertyMap.md) のモデルでなければならない。マップのキー型はグラフの頂点記述子型でなければならない。
	- デフォルト: `get(vertex_index, g)`


##計算量
時間計算量は、通常の場合には O(V E<sup>2</sup>) で、もしくは容量値が 定数 `U` で範囲づけられた整数であるならば O(V E U) である。


##コード例
[examples/edmunds-karp-eg.cpp](./examples/edmunds-karp-eg.cpp.md) 中のプログラムは最大流問題の例 (辺容量を伴うグラフ) を DIMACS 形式で書かれた ファイルから読み、最大流を計算する。


##関連項目
[`push_relabel_max_flow()`](./push_relabel_max_flow.md)


***
Copyright © 2000-2001 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<jsiek@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Takashi Itou](mailto:takashi-it@po6.nsk.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

