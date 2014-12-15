#bellman_ford_shortest_paths
```cpp
// 名前付きパラメータバージョン
template <class EdgeListGraph, class Size, class P, class T, class R>
bool bellman_ford_shortest_paths(EdgeListGraph& g, Size N, 
  const bgl_named_params<P, T, R>& params = all defaults)

// 名前無しパラメータバージョン
template <class EdgeListGraph, class Size, class WeightMap,
	  class PredecessorMap, class DistanceMap,
	  class BinaryFunction, class BinaryPredicate,
	  class BellmanFordVisitor>
bool bellman_ford_shortest_paths(EdgeListGraph& g, Size N, 
  WeightMap weight, PredecessorMap pred, DistanceMap distance, 
  BinaryFunction combine, BinaryPredicate compare, BellmanFordVisitor v)
```
* EdgeListGraph[link ./EdgeListGraph.md]
* BinaryFunction[link http://www.sgi.com/tech/stl/BinaryFunction.html]
* BinaryPredicate[link http://www.sgi.com/tech/stl/BinaryPredicate.html]
* BellmanFordVisitor[link ./BellmanFordVisitor.md]

Bellman-Ford アルゴリズム [[4](./bibliography.md#bellman58),[11](./bibliography.md#ford62:_flows),[20](./bibliography.md#lawler76:_comb_opt),[8](./bibliography.md#clr90)] は、正と負の両方の辺の重みを持つグラフの単一始点の最短経路問題を解く。最短経路問題の定義のために、 章 [Shortest-Paths Algorithms](./graph_theory_review.md#shortest-paths-algorithms) を見なさい。 もし正の辺の重みを持つ最短経路問題を解く必要があるだけなら、Dijkstra の アルゴリズムがより効率的な代替手段を提供する。もし全ての辺の重みが 1 に等しいなら幅優先探索がより一層効率的な代替手段を提供する。

`bellman_ford_shortest_paths()` 関数を呼ぶ前に、ユーザは始点に 0 の 距離を割り当て、他の全ての頂点に無限大の距離を割り当てなければならない。 Bellman-Ford アルゴリズムはグラフ中の全ての辺を通してループし、各辺に リラックス操作 (減らす操作) を適用することによって進められる。下記の擬似コード中で、 `v` は `u` の隣接頂点で、`w` は辺にそれらの重みをマップし、 `d` は今の所見られる各辺への最短経路の長さを記録する距離マップである。`p` は各辺の親を記録する先行点マップで、それは結局最短経路木中で親となるであろう。


```
RELAX(u, v, w, d, p)
  if (w(u,v) + d[u] < d[v]) 
    d[v] := w(u,v) + d[u]      辺をリラックスする (減らす) (u,v)
    p[v] := u
  else
    ...                        辺 (u,v) は リラックスされていない (減らされていない)
```

アルゴリズムはグラフ中に負の閉路が存在しないならば、各辺への距離が可能な限り最小に減らされた事が保証された後にこのループを `|V|` 回 繰り返す。もし負の閉路が存在するならば、グラフ中に適当に最小化されない 辺が存在する事になるだろう。つまり、`w(u,v) + d[u] < d[v]` であるような 辺 `(u,v)` が存在することになるだろう。 アルゴリズムは全ての辺が最小化されたかどうか最後に一回調べるためにグラフ中の辺をループし、もしよければ `true` を返し、そうでなければ `false` を返す。


```
BELLMAN-FORD(G)
  for each vertex u in V        頂点 u の初期化
    d[u] := infinity
    p[u] := u
  end for
  for i := 1 to |V|-1
    for each edge (u,v) in E    辺 (u,v) の調査
      RELAX(u, v, w, d, p)
    end for
  end for
  for each edge (u,v) in E
    if (w(u,v) + d[u] < d[v])
      return (false, , )        辺 (u,v) は最小化されていない
    else
      ...                       辺 (u,v) は最小化されている
  end for
  return (true, p, d)
```

`bellman_ford_shortest_paths()` 関数から出力を得るための主な二つの選択が存在する。 ユーザが `distance_map()` パラメータを通して距離プロパティ・マップを提供するならばグラフ中の始点から他の全ての頂点への最短距離は距離マップに記録されるだろう (もし関数が `true` を返すなら)。 二番目の選択は最短経路木を `predecessor_map()` に記録することである。 `V` 中の各頂点 `u` にとって、最短経路木中では `p[u]` が `u` の先行点になるだろう (ただし `p[u] = u` でここに `u` が始点 であるか、または始点からは到達不能な頂点である場合を除く)。 これらの二つの選択に加え、ユーザはアルゴリズムのイベント・ポイントのどれかの間、アクションを取れる独自のビジタをそこに提供することができる。


##パラメータ
- IN: `EdgeListGraph& g`
	- 型が [Edge List Graph](./EdgeListGraph.md) のモデルの有向グラフまたは無向グラフでなければならない。

- IN: `Size N`
	- グラフ中の頂点の数。型 `Size` は汎整数型でなければならない。


##名前付きパラメータ
- IN: `weight_map(WeightMap w)`
	- グラフ中の各辺の重み　(そして「長さ」もしくは「コスト」として知られる)。 `WeightMap` の型は [Readable Property Map](./ReadablePropertyMap.md) のモデルでなければならない。このプロパティ・マップのキー型はグラフの辺記述子でなければならない。重みマップの値型は距離マップの値型を伴った Addable でなければならない。
	- デフォルト: `get(edge_weight, g)`

- OUT: `predecessor_map(PredecessorMap p_map)`
	- 先行点マップ (predecessor map) は最小全域木中に辺を記録する。 アルゴリズムの完了時に、`V` 中の全ての `u` のための辺 `(p[u],u)` は最小全域木中にある。もし `p[u] = u` なら `u` は始点かまたは始点から到達不能な頂点である。 `PredecessorMap` の型はキーと頂点の型がグラフの頂点記述子型と同じ [Read/Write Property Map](./ReadWritePropertyMap.md) でなければならない。
	- デフォルト: `dummy_property_map`

- IN/OUT: `distance_map(DistanceMap d)`
	- グラフ `g` 中の始点から各頂点への最短経路の重みは、このプロパティ・マップ中に記録される。`DistanceMap` の型は [Read/Write Property Map](./ReadWritePropertyMap.md) のモデルでなければならない。プロパティ・マップのキー型は グラフの頂点記述子型でなければならず、距離マップの値型は [Less Than Comparable](http://www.sgi.com/tech/stl/LessThanComparable.html) でなければならない。
	- デフォルト: `get(vertex_distance, g)`

- IN: `visitor(BellmanFordVisitor v)`
	- ビジタ・オブジェクトで、その型は [Bellman-Ford Visitor](./BellmanFordVisitor.md) のモデルでなければならない。ビジタ・オブジェクトは値渡しされる [[1]](#note_1)。
	- デフォルト: `bellman_visitor<null_visitor>`

- IN: `distance_combine(BinaryFunction combine)`
	- この関数オブジェクトはリラックス (減少) 段階中で、加算の役割を置き換える。 第一引数の型は距離マップの値型に一致していなければならず、第二引数の型は重みマップの値型に一致していなければならない。 結果型は距離マップの値型と同じでなければならない。
	- デフォルト:`std::plus<D>` ここで `D=typename property_traits<DistanceMap>::value_type` とする。

- IN: `distance_compare(BinaryPredicate compare)`
	- この関数オブジェクトはリラックス (減少) 段階中で、距離を比較する less-than (`<`) 演算子の役割を置き換える。引数の型は距離マップの値型に一致していなければならない。 
	- デフォルト: `std::less<D>` ここで `D=typename property_traits<DistanceMap>::value_type` とする。


##計算量
時間複雑性は O(V E) である。


##Visitor Event Points

- `vis.examine_edge(e, g)` は、グラフ中の各辺において `|V|` 回呼び出される。
- `vis.edge_relaxed(e, g)` は終点のための距離ラベルが減じられた時に呼び出される。頂点 `v` のための最近のリラックス (減少) にあずかった 辺 `(u,v)` は最短経路木の中にある辺である。
- `vis.edge_not_relaxed(e, g)` は、もし終点のための距離ラベルが減じられなかった時に呼び出される。
- `vis.edge_minimized(e, g)` は、アルゴリズムの第二段階の間、各辺が最小化されたかどうかの検査の間に呼び出される。もし辺が最小化されていればこの関数が呼び出される。
- `vis.edge_not_minimized(e, g)` もまた、アルゴリズムの第二段階の間、各辺が最小化されたかどうかの検査の間に呼び出される。もし辺が最小化されていなければ、この関数が呼び出される。これはグラフ中に負の閉路が存在する時に起こる。


##コード例
Bellman-Ford のアルゴリズムを用いた例が [examples/bellman-example.cpp](./examples/bellman-example.cpp.md) 中にある。


##注釈
- <a name="note_1" href="note_1">[1] ビジタのパラメータは値渡しされるので、もしビジタが状態を持っているなら、アルゴリズムの間のいかなる状態の変更も、送ったビジタ・オブジェクトには行われず ビジタ・オブジェクトのコピーに対して行われる。それゆえポインタまたは リファレンスによってこの状態をビジタに保持させる事を望むかもしれない。


***
Copyright © 2000-2001 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<jsiek@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Takashi Itou](takashi-it@po6.nsk.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

