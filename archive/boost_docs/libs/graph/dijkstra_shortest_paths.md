# dijkstra_shortest_paths
```cpp
// 名前付きパラメータバージョン
template <typename VertexListGraph, typename P, typename T, typename R>
void
dijkstra_shortest_paths(VertexListGraph& g,
  typename graph_traits<VertexListGraph>::vertex_descriptor s,
  const bgl_named_params<P, T, R>& params);

// 名前なしパラメータバージョン
template <typename VertexListGraph, typename DijkstraVisitor, 
	  typename PredecessorMap, typename DistanceMap,
	  typename WeightMap, typename IndexMap, typename Compare, typename Combine, 
	  typename DistInf, typename DistZero>
void dijkstra_shortest_paths
  (const VertexListGraph& g,
   typename graph_traits<VertexListGraph>::vertex_descriptor s, 
   PredecessorMap predecessor, DistanceMap distance, WeightMap weight, 
   IndexMap index_map,
   Compare compare, Combine combine, DistInf inf, DistZero zero,
   DijkstraVisitor vis)
```
* VertexListGraph[link VertexListGraph.md.nolink]
* DijkstraVisitor[link DijkstraVisitor.md]
* Compare[link http://www.sgi.com/tech/stl/BinaryPredicate.html]
* Combine[link http://www.sgi.com/tech/stl/BinaryFunction.html]

このアルゴリズム [[10](bibliography.md#dijkstra59),[8](bibliography.md#clr90)] は、全ての辺の重みが負でない場合の、重みづけされた有向グラフまたは無向グラフの単一始点の最短経路問題を解く。いくつかの辺の重みが負である場合は Bellman-Ford のアルゴリズムを使いなさい。全ての辺の重みが 1 に等しい時は Dijkstra のアルゴリズムの代わりに幅優先探索を使いなさい。最短経路問題の定義のために、最短経路問題のいくつかの背景 についての章 [Shortest-Paths Algorithms](graph_theory_review.md#shortest-path-algorithms) を見なさい。

`dijkstra_shortest_paths()` 関数から出力を得るための主な二つの選択が存在する。`distance_map()` パラメータを通して距離プロパティ・ マップを提供するならば、グラフ中の始点から他の全ての頂点への最短距離は距離マップに記録されるだろう。さらに最短経路木を先行点マップ (predecessor map) に記録することができる。その場合 `V` 中の各頂点 `u` にとって、最短経路木中では `p[u]` が `u` の先行点になるだろう (ただし `p[u] = u` でここに `u` が始点であるかまたは始点からは到達不能な頂点である場合を除く)。 これらの二つの選択に加え、ユーザはアルゴリズムのイベント・ポイントのどれかの間アクションを取れる独自のビジタを提供することができる。

Dijkstra のアルゴリズムは最短経路を知っている頂点集合 `S` を反復的に「育てる」ことによって、始点から他の頂点への全ての最短経路を発見する。アルゴリズムの各段階で、`S` に追加される次の頂点は優先度付きキューによって決定される。キューは、距離ラベルによって優先された `V - S`[[1]](#note_1) 中に頂点を含む。そして距離ラベルとはいまの所見られる各頂点への最短経路の長さである。それから優先度付きキューの先頭にある頂点 `u` が `S` に加えられ、その各先行辺はリラックス (距離が減らされる) される。つまり、もし `u` への距離に出辺 `(u,v)` の重みを加えた結果が `v` の 距離ラベルより小さいなら、頂点 `v` の評価された距離は減らされる。 それからアルゴリズムは元に戻り、優先度付きキューの先頭の次の頂点の処理をする。優先度付きキューが空になった時にアルゴリズムは終了する。

アルゴリズムは各頂点がどの集合中にあるかの過程を保持するためにカラー・マーカー (白色、灰色、そして黒色) を使う。黒色に色づけされた頂点は `S` 中にある。 白色または灰色に色づけされた頂点は `V-S` 中にある。白色の頂点はまだ発見されていず、灰色の頂点は優先度付きキュー中にある。デフォルトでは、グラフ中の各頂点のためのカラー・マーカーを格納するための配列を割り当てる。`color_map()` パラメータによって独自の記憶域と色へのアクセスを提供することができる。

下記の擬似コードは Dijkstra の単一始点の最短経路アルゴリズムである。 `w` は辺の重み、`d` は距離ラベル、そして `p` は最短経路木を符号化するのに使われる各頂点の先行点である。`Q` は減少キー操作 (DECREASE-KEY operation) を備える優先度付きキューである。ビジタのイベント・ポイントは右側のラベルによって示されている。

```
DIJKSTRA(G, s, w)
  for each vertex u in V           頂点 u の初期化
    d[u] := infinity 
    p[u] := u 
    color[u] := WHITE
  end for
  color[s] := GRAY 
  d[s] := 0 
  INSERT(Q, s)                     頂点 s の発見
  while (Q != Ø)
    u := EXTRACT-MIN(Q)            頂点 u の調査
    S := S U { u }
    for each vertex v in Adj[u]    辺 (u,v) の調査
      if (w(u,v) + d[u] < d[v])
        d[v] := w(u,v) + d[u]      辺 (u,v) はリラックスされた (減らされた)
        p[v] := u 
        if (color[v] = WHITE) 
          color[v] := GRAY
          INSERT(Q, v)             頂点 v の発見
        else if (color[v] = GRAY)
          DECREASE-KEY(Q, v)
      else
        ...                        辺 (u,v) はリラックスされない (減らされない)
    end for
    color[u] := BLACK              頂点 u の終了
  end while
  return (d, p)
```

## 定義場所
boost/graph/dijkstra_shortest_paths.hpp


## パラメータ

- IN: `const VertexListGraph& g`
	- アルゴリズムが適用されるグラフオブジェクト。`VertexListGraph` の型は [Vertex List Graph](VertexListGraph.md.nolink) のモデルでなければならない。

- IN: `vertex_descriptor s`
	- 始点。全ての距離はこの頂点から計算される。そして最短経路木はこの頂点を根とする。


## 名前付きパラメータ

- IN: `weight_map(WeightMap w_map)`
	- グラフ中の各辺の重みまたは「長さ」。重みは全て非負でなければならず、辺の一つが負であればアルゴリズムは [`negative_edge`](exception.md#negative_edge) 例外を投げる。`WeightMap` の型は [Readable Property Map](../property_map/ReadablePropertyMap.md.nolink) のモデルでなければならない。グラフの辺記述子型は重みマップのキー型として使用できる必要がある。このマップの値型は距離マップの値型と同じでなければならない。
	- デフォルト: `get(edge_weight, g)`

- IN: `vertex_index_map(VertexIndexMap i_map)`
	- これは各頂点を `[0, num_vertices(g))` の範囲において整数にマップする。これは辺がリラックスされた (減らされた) 時、ヒープ・データ構造を効率よく更新するのに必要である。`VertexIndexMap` は [Readable Property Map](../property_map/ReadablePropertyMap.md.nolink) のモデルでなければならない。マップの値型は汎整数型でなければならない。グラフの頂点記述子型はマップのキー型として使用できる必要がある。
	- デフォルト: `get(vertex_index, g)`

- OUT: `predecessor_map(PredecessorMap p_map)`
	- 先行点マップ (predecessor map) は最小全域木中に辺を記録する。アルゴリズムの完了時に、`V` 中の全ての `u` のための辺 `(p[u],u)` は最小全域木中にある。もし `p[u] = u` なら `u` は始点かまたは始点から到達不能な頂点である。 `PredecessorMap` の型はキーと頂点の型がグラフの頂点記述子型と同じ [Read/Write Property Map](../property_map/ReadWritePropertyMap.md.nolink) でなければならない。 
	- デフォルト: `dummy_property_map`

- UTIL/OUT: `distance_map(DistanceMap d_map)`
	- グラフ `g` 中の始点 `s` から各頂点への最短経路の重みは、このプロパティ・マップ中に記録される。最短経路の重みは、最短経路に沿った辺の重みの和である。`DistanceMap` の型は [Read/Write Property Map](../property_map/ReadWritePropertyMap.md.nolink) のモデルでなければならない。グラフの頂点記述子型は距離マップのキー型として使用できる必要がある。距離マップの値型は `combine` 関数オブジェクトと単位要素のための `zero` オブジェクトから作られた [Monoid](Monoid.md.nolink) の要素型である。さらに距離の値型は `compare` 関数オブジェクトによって提供される [StrictWeakOrdering](http://www.sgi.com/tech/stl/StrictWeakOrdering.html) の順序付けを持っていなければならない。 
	- デフォルト: サイズ `num_vertices(g)` の `WeightMap` の値型の `std::vector` から作られた [`iterator_property_map`](../property_map/iterator_property_map.md.nolink) で、添え字マップには `i_map` を用いる。

- IN: `distance_compare(CompareFunction cmp)`
	- この関数はどの頂点が始点により近いか決定するために距離を比較するのに使われる。`CompareFunction` の型は [Binary Predicate](http://www.sgi.com/tech/stl/BinaryPredicate.html) のモデルでなければならず、`DistanceMap` プロパティ・ マップの値型に一致する引数型を持たなければならない。 
	- デフォルト: `std::less<D>` ここで `D=typename property_traits<DistanceMap>::value_type` とする

- IN: `distance_combine(CombineFunction cmb)`
	- この関数は道の距離を計算するために、距離を結合するのに使われる。 `CombineFunction` の型は [Binary Function](http://www.sgi.com/tech/stl/BinaryFunction.html) のモデルでなければならない。二項関数の第一引数の型は `DistanceMap` プロパティ・マップの値型に一致していなければならず、 第二引数の型は `WeightMap` プロパティ・マップの値型に一致していなければならない。結果型は距離の値型と同じでなければならない。
	- デフォルト: `std::plus<D>` ここで `D=typename property_traits<DistanceMap>::value_type` とする

- IN: `distance_inf(D inf)`
	- `inf` オブジェクトは `D` オブジェクトのどの値よりも最も大きく なければならない。すなわち、`d != inf` の場合どれでも `compare(d, inf) == true` でなければならない。 `D` の型は `DistanceMap` の値型である。
	- デフォルト: `std::numeric_limits<D>::max()`

- IN: `distance_zero(D zero)`
	- `zero` の値は距離の値と `combine` 関数オブジェクトによって 作られた [Monoid](Monoid.md.nolink) のための単一要素でなければならない。`D` の型は `DistanceMap` の値型である。 
	- デフォルト: `D()`

- UTIL/OUT: `color_map(ColorMap c_map)`
	- これは頂点に印をつけるためにアルゴリズムの実行の間使われる。頂点は白色から始めて、それがキュー中に挿入された時に灰色になる。それからそれがキューから取り除かれた時に黒色になる。アルゴリズムの終了時に、始点から到達可能な頂点は黒色に色づけされている。その他の全ての頂点は白色のままである。`ColorMap` の型は [Read/Write Property Map](../property_map/ReadWritePropertyMap.md.nolink) のモデルでなければならない。頂点記述子はマップのキー型として使用できる必要があり、マップの値型は [Color Value](ColorValue.md) のモデルでなければならない。
	- デフォルト: サイズ `num_vertices(g)` の `default_color_type` の `std::vector` から作られた [`iterator_property_map`](../property_map/iterator_property_map.md.nolink) で、添え字マップには `i_map` を用いる。

- OUT: `visitor(DijkstraVisitor v)`
	- アルゴリズム内の一定のイベント・ポイントの間に起こしたいアクションを指定するのに使いなさい。`DijkstraVisitor` は [Dijkstra Visitor](DijkstraVisitor.md) コンセプトのモデルでなければならない。ビジタ・オブジェクトは値渡しされる [[2]](#note_2)。
	- デフォルト: `dijkstra_visitor<null_visitor>`


## 計算量
時間計算量は O((V + E) log V) か、もし全ての頂点が始点から到達可能ならちょうど O(E log V) になる。


## ビジタ・イベント・ポイント

- `vis.initialize_vertex(u, g)` は、アルゴリズムの開始前に各頂点で呼び出される。
- `vis.examine_vertex(u, g)` は、頂点が優先度付きキューから取り除かれ、集合 `S` に加えられた時に呼び出される。この時点で `(p[u],u)` は最短経路木の辺であることが分かるので `d[u] = delta(s,u) = d[p[u]] + w(p[u],u)` である。さらに、調査された頂点の距離は単調増加 `d[u1] <= d[u2] <= d[un]` である。
- `vis.examine_edge(e, g)` は、頂点の各出辺において、頂点が集合 `S` に加えられた後で直ちに呼び出される。
- `vis.edge_relaxed(e, g)` は、辺 `(u,v)` において、もし `d[u] + w(u,v) < d[v]` であるなら呼び出される。頂点 `v` のための最近のリラックス (減少) にあずかった辺 `(u,v)` は最短経路木の中にある辺である。
- `vis.discover_vertex(v, g)` は、頂点 `v` において、`(u,v)` が調査されて `v` が白色である時に呼び出される。頂点が発見されていれば灰色に色づけされており、各到達可能な頂点はきっかり一度発見されるからである。これは頂点が優先度付きキューに挿入される時にも言える。
- `vis.edge_not_relaxed(e, g)` は、もし辺がリラックスされない (上を見よ) なら呼び出される。
- `vis.finish_vertex(u, g)` は、頂点の出辺が全て調査された後に呼び出される。


## コード例
[examples/dijkstra-example.cpp](examples/dijkstra-example.cpp.md) を見よ。これは Dijkstra のアルゴリズムの使用例である。


## 注釈
- <a id="note_1" href="#note_1">[1]</a> ここで使われているアルゴリズムは全ての `V - S` 頂点を一度に優先度付きキュー中に置かないことによって、わずかなスペースを節約している。その代わり、発見された `V - S` 中のこれらの頂点だけであり、それゆえ無限より少ない距離を持っている。

- <a id="note_2" href="#note_2">[2]</a> ビジタのパラメータは値渡しされるので、もしビジタが状態を持っているなら、アルゴリズムの間のいかなる状態の変更も、送ったビジタ・オブジェクトには行われずビジタ・オブジェクトのコピーに対して行われる。それゆえポインタまたはリファレンスによってこの状態をビジタに保持させることを望むかもしれない。


***
Copyright © 2000-2001 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Takashi Itou](mailto:takashi-it@po6.nsk.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

