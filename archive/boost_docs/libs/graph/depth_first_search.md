# depth_first_search
```cpp
// 名前付きパラメータバージョン
template <class Graph, class class P, class T, class R>
void depth_first_search(Graph& G,
  const bgl_named_params<P, T, R>& params);

// 名前無しパラメータバージョン
template <class Graph, class DFSVisitor, class ColorMap>
void depth_first_search(const Graph& g, DFSVisitor vis, ColorMap color)

template <class Graph, class DFSVisitor, class ColorMap>
void depth_first_search(const Graph& g, DFSVisitor vis, ColorMap color, 
                        typename graph_traits<Graph>::vertex_descriptor start)
```
* DFSVisitor[link ./DFSVisitor.md]

`depth_first_search()` 関数は、有向グラフ中の頂点の深さ優先巡回(depth-first traversal)を行う。可能な時は、深さ優先巡回は次に訪れるために現在の頂点の隣接頂点を選ぶ。もし全ての隣接頂点がすでに発見されているならば、もしくは隣接頂点が存在しないならば、アルゴリズムは未発見の隣接を持つ前の頂点へとバックトラックする。一旦全ての到達可能な頂点が訪問されたら、アルゴリズムは残っている未発見の頂点のどれかを選び出し、巡回を続ける。このアルゴリズムは全ての頂点が訪問された時に終了する。深さ優先探索はグラフ中の辺を分類するのと、頂点を順序づけるのに役立つ。章 [Depth-First Search](graph_theory_review.md#dfs-algorithm) は DFS の様々な特性を記述し、適当に例をあげている。

BFS に似て、頂点が発見された過程を保持するためにカラー・マーカーが使われる。白色はまだ発見されていない頂点を印づけ、灰色は発見されたけれどもまだ未発見の隣接している頂点を持つ頂点を印づける。黒い頂点はどの白い頂点にも隣接していない発見された頂点である。

`depth_first_search()` 関数は、アルゴリズムの内部で一定のイベント・ポイントにおいて、ユーザ定義のアクションを呼び出す。これは一般的な DFS アルゴリズムが使用できる多くの状況に適用させるための機構を提供する。下の疑似コード中で、 DFS のためのイベント・ポイントは三角形と右側のラベルで示されている。ユーザ定義のアクションはビジタ・オブジェクトの形で提供されなければならない。すなわち、型が [DFS Visitor](DFSVisitor.md) の要求を満たしているオブジェクトである。擬似コード中では、先行点を計算するアルゴリズムを `p`、発見時間を `d`、そして終了時間を `t` と表す。デフォルトでは、`depth_first_search()` 関数はこれらのプロパティを計算しない。しかしながら、これを実行するのに使える [`predecessor_recorder`](predecessor_recorder.md) と [`time_stamper`](time_stamper.md) のような、あらかじめ定義されたビジタが存在する。


```
DFS(G)
  for each vertex u in V 
    color[u] := WHITE              頂点 u の初期化
    p[u] = u 
  end for
  time := 0
  if there is a starting vertex s
    call DFS-VISIT(G, s)           頂点 s の開始
  for each vertex u in V 
    if color[u] = WHITE
      call DFS-VISIT(G, u)         頂点 u の開始
  end for
  return (p,d_time,f_time) 

DFS-VISIT(G, u) 
  color[u] := GRAY                 頂点 u の発見
  d_time[u] := time := time + 1 
  for each v in Adj[u]             辺 (u,v) の調査
    if (color[v] = WHITE)
      p[v] = u                     (u,v) は木の辺
      call DFS-VISIT(G, v)
    else if (color[v] = GRAY) 
      ...                          (u,v) は後退辺
    else if (color[v] = BLACK) 
      ...                          (u,v) は交差辺または前方辺
  end for
  color[u] := BLACK                頂点 u の終了
  f_time[u] := time := time + 1
```


## 定義場所
boost/graph/depth_first_search.hpp


## パラメータ

- IN: `Graph& g`
	- 有向グラフ。グラフの型は [Incidence Graph](IncidenceGraph.md) と [Vertex List Graph](VertexListGraph.md) のモデルでなければならない。


## 名前付きパラメータ

- IN: `visitor(DFSVisitor vis)`
	- アルゴリズムの内側で [DFS Visitor](DFSVisitor.md) コンセプトで指定されるイベント・ポイントで呼び出されるビジタ・オブジェクト。ビジタ・オブジェクトは値渡しされる [[1]](#note_1)。
	- デフォルト: `dfs_visitor<null_visitor>`

- UTIL/OUT: `color_map(ColorMap color)`
	- これはグラフを通る進行過程を保持するためにアルゴリズムによって使われる。 `ColorMap` の型は [Read/Write Property Map](../property_map/ReadWritePropertyMap.md) のモデルでなければならず、かつキー型はグラフの頂点記述子型でなければならず、またカラー・マップの値型は [ColorValue](ColorValue.md) をモデルとしなければならない。
	- デフォルト: サイズ `num_vertices(g)` の `default_color_type` の `std::vector` から作られた [`iterator_property_map`](../property_map/iterator_property_map.md) で、添え字マップには `i_map` を用いる。

- IN: `root_vertex(typename graph_traits<VertexListGraph>::vertex_descriptor start)`
	- これは深さ優先探索が開始されるべき頂点を指定する。型は与えられたグラフの頂点記述子型である。
	- デフォルト: `*vertices(g).first`

- IN: `vertex_index_map(VertexIndexMap i_map)`
	- これは各頂点を `[0, num_vertices(g))` の範囲において整数にマップする。このパラメータはデフォルトのカラー・プロパティ・マップが使われた時にのみ必要である。`VertexIndexMap` の型は [Readable Property Map](../property_map/ReadablePropertyMap.md) のモデルでなければならない。マップの値型は汎整数型でなければならない。グラフの頂点記述子型はマップのキー型として使用できる必要がある。
	- デフォルト: `get(vertex_index, g)`


## 計算量
時間計算量は O(E + V) である。


## ビジタ・イベント・ポイント

- `vis.initialize_vertex(s, g)` は、グラフの探索の開始前にグラフの各頂点で呼び出される。
- `vis.start_vertex(s, g)` は、探索の開始前に始点において一度呼び出される。
- `vis.discover_vertex(u, g)` は、初めて頂点に通った時に呼び出される。
- `vis.examine_edge(e, g)` は、各頂点のあらゆる出辺において、それが発見された後に呼び出される。
- `vis.tree_edge(e, g)` は、各辺において、それが探索木を構成する辺のメンバになった時に呼び出される。もし先行点の記録を望むなら、このイベント・ポイントで行いなさい。
- `vis.back_edge(e, g)` は、グラフ中の後退辺において呼び出される。
- `vis.forward_or_cross_edge(e, g)` は、グラフ中の前方辺または交差辺において呼び出される。無向グラフ中ではこのメソッドは決して呼ばれない。
- `vis.finish_vertex(u, g)` は、出辺の全てが探索木に追加され、全ての隣接頂点が発見された (ただし、それらの出辺が調査される前に) 後の頂点において呼び出される。


## コード例
[examples/dfs-example.cpp](examples/dfs-example.cpp.md) 中の例は、 [Figure 1](graph_theory_review.md#dfs-algorithm) にあるグラフへ適用された DFS を示す。


## 関連項目
[`depth_first_visit`](depth_first_visit.md)、[`undirected_dfs`](undirected_dfs.md)


## 注釈
<a name="note_1" href="#note_1">[1]</a> ビジタのパラメータは値渡しされるので、もしビジタが状態を持っているなら、アルゴリズムの間のいかなる状態の変更も、送ったビジタ・オブジェクトには行われずビジタ・オブジェクトのコピーに対して行われる。それゆえポインタまたはリファレンスによってこの状態をビジタに保持させることを望むかもしれない。


***
Copyright © 2000-2001 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Takashi Itou](mailto:takashi-it@po6.nsk.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

