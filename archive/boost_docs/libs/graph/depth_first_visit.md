# depth_first_visit
```cpp
template <class IncidenceGraph, class DFSVisitor, class ColorMap>
void depth_first_visit(IncidenceGraph& g,
  typename graph_traits<IncidenceGraph>::vertex_descriptor s, 
  DFSVisitor& vis, ColorMap color)
```
* IncidenceGraph[link IncidenceGraph.md.nolink]
* DFSVisitor[link DFSVisitor.md]

この関数は [depth-firstパターン](graph_theory_review.md#dfs-algorithm) を使って、始点 `s` と同じ連結成分中にある全ての頂点を訪れる。時々単独で有用ではあるが、この関数の主な目的は `depth_first_search()` の実装のためにある。

ユーザによって提供される `DFSVisitor` はアルゴリズムの内側の各イベント・ポイントで行われるアクションを決定する。

`ColorMap` は訪れられた頂点の過程を保持するためにアルゴリズムによって使われる。


## 定義場所
boost/graph/depth_first_search.hpp


## パラメータ

- IN `IncidenceGraph& g`
	- 有向グラフまたは無向グラフ。グラフの型は [Incidence Graph](IncidenceGraph.md.nolink) のモデルでなければならない。

- IN: `vertex_descriptor s`
	- 探索が開始される始点。

- IN: `DFSVisitor visitor`
	- アルゴリズムの内側で [DFS Visitor](DFSVisitor.md) コンセプトで指定されるイベント・ポイントで呼び出されるビジタ・オブジェクト。ビジタ・オブジェクトは値渡しされる [[1]](#note_1)。

- UTIL: `ColorMap color`
	- これはグラフを通る進行過程を保持するためにアルゴリズムによって使われる。 `ColorMap` の型は [Read/Write Property Map](../property_map/ReadWritePropertyMap.md.nolink) のモデルでなければならず、かつキー型はグラフの頂点記述子型でなければならず、またカラー・マップの値型は [Color Value](ColorValue.md) をモデルとしなければならない。


## 計算量
時間計算量は O(E) である。


## 注釈
<a id="note_1" href="#note_1">[1]</a> ビジタのパラメータは値渡しされるので、もしビジタが状態を持っているなら、アルゴリズムの間のいかなる状態の変更も、送ったビジタ・オブジェクトには行われずビジタ・オブジェクトのコピーに対して行われる。それゆえポインタまたは リファレンスによってこの状態をビジタに保持させることを望むかもしれない。


***
Copyright © 2000-2001 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Takashi Itou](mailto:takashi-it@po6.nsk.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

