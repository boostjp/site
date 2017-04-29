# breadth_first_visit
```cpp
template <class IncidenceGraph, class P, class T, class R>
void breadth_first_visit(IncidenceGraph& G, 
  typename graph_traits<IncidenceGraph>::vertex_descriptor s, 
  const bgl_named_params<P, T, R>& params);

template <class IncidenceGraph, class Buffer, class BFSVisitor, class ColorMap>
void breadth_first_visit
  (const IncidenceGraph& g, 
   typename graph_traits<IncidenceGraph>::vertex_descriptor s, 
   Buffer& Q, BFSVisitor vis, ColorMap color)
```
* IncidenceGraph[link ./IncidenceGraph.md]
* Buffer[link ./Buffer.md]
* BFSVisitor[link ./BFSVisitor.md]

この関数はカラー・マーカーがアルゴリズム中で初期化されないことを除けば、基本的に `breadth_first_search()` と同じである。 ユーザはアルゴリズムを呼ぶ前に全ての頂点の色が白色であることを確かめる責任がある。この違いでグラフの型は [Vertex List Graph](VertexListGraph.md) である代わりに [Incidence Graph](IncidenceGraph.md) であることのみが要求される。 さらにこの違いはカラー・プロパティ・マップ中のより多くの柔軟性を考慮に入れている。例えば頂点上の部分的な関数を実装するだけのマップを使うことができる。そしてそれは探索がグラフのごく一部にしか及ばない場合、より良い空間効率であることができる。


## 定義場所
boost/graph/breadth_first_search.hpp


## パラメータ
- IN: `IncidenceGraph& g`
	- 有向グラフまたは無向グラフ。グラフの型は [Incidence Graph](IncidenceGraph.md) のモデルでなければならない。

- IN: `vertex_descriptor s`
	- 探索が開始される始点。


## 名前付きパラメータ

- IN: `visitor(BFSVisitor vis)`
	- アルゴリズムの内側で [BFS Visitor](BFSVisitor.md) コンセプトで指定されたイベント・ポイントで呼び出されるビジタ・オブジェクト。ビジタ・オブジェクトは値渡しされる [[1]](#note_1)。
	- デフォルト: `bfs_visitor<null_visitor>`

- UTIL/OUT: `color_map(ColorMap color)`
	- これはグラフを通る進行過程を保持するためにアルゴリズムによって使われる。 `ColorMap` の型は [Read/Write Property Map](../property_map/ReadWritePropertyMap.md.nolink) のモデルでなければならなく、そのキー型はグラフの頂点記述子型でなければならなく、カラー・マップの値型は [ColorValue](ColorValue.md) をモデルとしなければならない。 
	- デフォルト: `get(vertex_color, g)`

- UTIL: `buffer(Buffer& Q)`
	- 頂点が発見される順序を決定するために使用されるキュー。 もしFIFO キューが使われると、巡回は通常の BFS 順序付けに従う。 他の型のキューも使用できるが、巡回順序は異なる。 例えば Dijkstra のアルゴリズムは優先度付きキューを用いて実装することができる。 `Buffer` の型は [Buffer](Buffer.md) のモデルでなければならない。 
	- デフォルト: `boost::queue`


## 計算量
時間計算量は O(E) である。


## ビジタ・イベント・ポイント

- `vis.initialize_vertex(v, g)` は、探索の開始前に各頂点で呼び出される。
- `vis.examine_vertex(u, g)` は、各頂点においてそれがキューから削除される時に呼び出される。
- `vis.examine_edge(e, g)` は、各頂点のあらゆる出辺において、 頂点がキューから削除された後で直ちに呼び出される。
- `vis.tree_edge(e, g)` は、 `examine_edge() `に加えて辺が木の辺の場合に呼び出される。辺 `e` の終点はこの時に発見される。
- `vis.discover_vertex(u, g)` は、アルゴリズムが初めて頂点 `u` に通った時に呼び出される。始点に近い全ての頂点が発見されており、始点から遠方に離れた頂点はまだ発見されていない。
- `vis.non_tree_edge(e, g)` は、 `examine_edge()` に 加えて辺が木の辺でない場合に呼び出される。
- `vis.gray_target(e, g)` は、 `non_tree_edge()` に加えて調査時点で終点が灰色に色づけされている場合に呼び出される。 灰色は頂点が現在キュー中にある印である。
- `vis.black_target(e, g)` は、 `non_tree_edge()` に加えて調査時点で終点が黒色に色づけされている場合に呼び出される。 黒色は頂点がもはやキュー中にはない印である。
- `vis.finish_vertex(u, g)` は、 `u` の全ての出辺が調べられ、全ての隣接頂点が発見された後で呼び出される。


## 関連項目
[`breadth_first_search()`](breadth_first_search.md), [`bfs_visitor`](bfs_visitor.md), and [`depth_first_search()`](depth_first_search.md)


## 注釈
- <a name="note_1" href="#note_1">[1]</a> ビジタのパラメータは値渡しされるので、もしビジタが状態を持っているなら、アルゴリズムの間のいかなる状態の変更も、送ったビジタ・オブジェクトには行われずビジタ・オブジェクトのコピーに対して行われる。それゆえポインタまたはリファレンスによってこの状態をビジタに保持させることを望むかもしれない。


***
Copyright © 2000-2001 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Takashi Itou](mailto:takashi-it@po6.nsk.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

