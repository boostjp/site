# breadth_first_search

```cpp
// 名前付きパラメータバージョン
template <class VertexListGraph, class P, class T, class R>
void breadth_first_search(VertexListGraph& G, 
  typename graph_traits<VertexListGraph>::vertex_descriptor s, 
  const bgl_named_params<P, T, R>& params);

// 名前無しパラメータバージョン
template <class VertexListGraph, class Buffer, class BFSVisitor, 
	  class ColorMap>
void breadth_first_search(const VertexListGraph& g, 
   typename graph_traits<VertexListGraph>::vertex_descriptor s, 
   Buffer& Q, BFSVisitor vis, ColorMap color);
```
* VertexListGraph[link VertexListGraph.md.nolink]

`breadth_first_search()` 関数は有向グラフまたは無向グラフの幅優先巡回(breadth-first traversal) [[49]](bibliography.md#moore59) を行う。幅優先巡回は、始点から遠方に離れた頂点を訪れる前に近い頂点を訪れる。 この文脈中で「距離」とは始点からの最短経路中の辺の数として定義される。 `breadth_first_search()` 関数は始点から全ての到達可能な頂点への最短経路を計算するのに使用でき、結果として最短経路の距離が得られる。 BFS に関連した更なる定義は章 [Breadth-First Search](graph_theory_review.md#bfs-algorithm) を見よ。

BFS は巡回を実装するのに二つのデータ構造を使っている: 各頂点のカラー・マーカーとキューである。白色の頂点は未発見で、一方灰色の頂点は発見されたけれども未発見の隣接頂点を持つ。黒色の頂点は発見されており、他の黒色もしくは灰色の頂点にのみ隣接している。アルゴリズムは頂点 `u` をキューから取り除き、 各出辺 `(u,v)` を調べながら進められる。もし隣接頂点 `v` がまだ 未発見ならば、灰色に色づけしてキューに置く。すべての出辺を調べた後、頂点 `u` を黒色に色づけして手順を繰り返す。BFS アルゴリズムの疑似コードを下に示す。


```
BFS(G, s)
  for each vertex u in V[G]      頂点uの初期化
    color[u] := WHITE 
    d[u] := infinity 
    p[u] := u 
  end for
  color[s] := GRAY 
  d[s] := 0 
  ENQUEUE(Q, s)                  頂点sの発見
  while (Q != Ø) 
    u := DEQUEUE(Q)              頂点uの調査
    for each vertex v in Adj[u]  辺(u,v)の調査
      if (color[v] = WHITE)      辺(u,v)は木の辺
        color[v] := GRAY 
        d[v] := d[u] + 1  
        p[v] := u  
        ENQUEUE(Q, v)            頂点vの発見
      else                       (u,v)は木でない辺
        if (color[v] = GRAY) 
          ...                    (u,v)は灰色の終点を持つ
        else
          ...                    (u,v)は黒色の終点を持つ
    end for
    color[u] := BLACK            頂点uの終了
  end while
  return (d, p)
```

`breadth_first_search()` 関数は一定のイベント・ポイントと呼ばれる、 ユーザ定義のアクションで拡張することができる。アクションはビジタ・オブジェクトの形で提供されなければならない。すなわち、型が [BFS Visitor](BFSVisitor.md) の要求を満たしているオブジェクトである。上の擬似コード内で、イベント・ポイントは右側のラベルである。さらに各イベント・ポイントの記述を以下に示した。デフォルトでは `breadth_first_search()` 関数はどんなアクションも実行しない。距離や先行点の記録さえも。しかしながらこれらは [`distance_recorder`](distance_recorder.md) と [`predecessor_recorder`](predecessor_recorder.md.nolink) のイベント・ビジタを用いて容易に追加できる。


## 定義場所
boost/graph/breadth_first_search.hpp


## パラメータ
- IN: `VertexListGraph& g`
	- 有向グラフまたは無向グラフ。グラフの型は [Vertex List Graph](VertexListGraph.md.nolink) のモデルでなければならない。

- IN: `vertex_descriptor s`
	- 探索が開始される始点。


## 名前付きパラメータ
- IN: `visitor(BFSVisitor vis)`
	- アルゴリズムの内側で [BFS Visitor](BFSVisitor.md) コンセプトで指定されたイベント・ポイントで呼び出されるビジタ・オブジェクト。 ビジタ・オブジェクトは値渡しされる [[1]](#note_1)。
	- デフォルト: `bfs_visitor<null_visitor>`

- UTIL/OUT: `color_map(ColorMap color)`
	- これはグラフを通る進行過程を保持するためにアルゴリズムによって使われる。 アルゴリズムは開始時に全ての頂点の色を白色に初期化するため、ユーザは `breadth_first_search()` を呼ぶ前にカラー・マップを初期化する必要はない。もし複合的な幅優先探索をグラフ上で行う必要があるなら (例えばいくつかの切断された成分があるなら) `breadth_first_visit()` 関数を使って独自の初期化を行うこと。
		`ColorMap` の型は [Read/Write Property Map](../property_map/ReadWritePropertyMap.md.nolink) のモデルでなければならなく、そのキー型はグラフの頂点記述子型でなければならなく、カラー・マップの値型は [ColorValue](ColorValue.md) をモデルとしなければならない。
	- デフォルト: サイズ `num_vertices(g)` の `default_color_type` の `std::vector` から作られた `iterator_property_map`で、添え字マップには `i_map` を用いる。

- IN: `vertex_index_map(VertexIndexMap i_map)`
	- これは各頂点を `[0, num_vertices(g))` の範囲において整数にマップする。 このパラメータはデフォルトのカラー・プロパティ・マップが使われた時にのみ必要である。 `VertexIndexMap` の型は [Readable Property Map](../property_map/ReadablePropertyMap.md.nolink) のモデルでなければならない。マップの値型は汎整数型でなければならない。グラフの頂点記述子型はマップのキー型として使用できる必要がある。
	- デフォルト: `get(vertex_index, g)`

- UTIL: `buffer(Buffer& Q)`
	- 頂点が発見される順序を決定するために使用されるキュー。もしFIFOキューが使われると、 巡回は通常の BFS 順序付けに従う。他の型のキューも使用できるが、巡回順序は異なる。例えば Dijkstra のアルゴリズムは優先度付きキューを用いて実装することができる。`Buffer` の型は [Buffer](Buffer.md) のモデルでなければならない。`buffer` の `value_type` はグラフの `vertex_descriptor` 型でなければならない。 
	- デフォルト: `boost::queue`


## 計算量
時間計算量は O(E + V) である。


## ビジタ・イベント・ポイント

- `vis.initialize_vertex(v, g)` は、探索の開始前に各頂点で呼び出される。
- `vis.examine_vertex(u, g)` は、各頂点においてそれがキューから削除される時に呼び出される。
- `vis.examine_edge(e, g)` は、各頂点のあらゆる出辺において、頂点が キューから削除された後で直ちに呼び出される。
- `vis.tree_edge(e, g)` は、 `examine_edge()` に加えて 辺が木の辺の場合に呼び出される。辺 `e` の終点はこの時に発見される。
- `vis.discover_vertex(u, g)` は、アルゴリズムが初めて頂点 `u` を通った時に呼び出される。始点に近い全ての頂点が発見されており、始点から遠方に離れた頂点はまだ発見されていない。
- `vis.non_tree_edge(e, g)` は、 `examine_edge()` に加えて辺が tree edge でない場合に呼び出される。
- `vis.gray_target(e, g)` は、 `non_tree_edge()` に加えて調査時点で終点が灰色に色づけされている場合に呼び出される。灰色は頂点が現在 キュー中にある印である。
- `vis.black_target(e, g)` は、 `non_tree_edge()` に加えて調査時点で終点が黒色に色づけされている場合に呼び出される。黒色は頂点がもはやキュー中にはない印である。
- `vis.finish_vertex(u, g)` は、 `u` の全ての出辺が調べられ、全ての隣接頂点が発見された後で呼び出される。


## コード例

[examples/bfs-example.cpp](examples/bfs-example.cpp.md) 中にある例は、[Figure 6](graph_theory_review.md#bfs-algorithm) のグラフにおいて BGL 幅優先探索アルゴリズムを用いて実演している。

[examples/bfs-example2.cpp](examples/bfs-example2.cpp.md) のファイルは同じ例を含むが、使われている `adacency_list` クラスは `VertexList` を持っており、`EdgeList` が `listS` に置かれている。


## 関連項目
[`bfs_visitor`](bfs_visitor.md) と [`depth_first_search()`](depth_first_search.md)


## 注釈
- <a name="note_1" href="#note_1">[1]</a> ビジタのパラメータは値渡しされるので、もしビジタが状態を持っているなら、アルゴリズムの間のいかなる状態の変更も、送ったビジタ・オブジェクトには行われずビジタ・オブジェクトのコピーに対して行われる。それゆえポインタまたはリファレンスによってこの状態をビジタに保持させることを望むかもしれない。


***
Copyright © 2000-2001 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Takashi Itou](mailto:takashi-it@po6.nsk.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

