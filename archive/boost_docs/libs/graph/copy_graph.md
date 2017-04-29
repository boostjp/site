# copy_graph
```cpp
template <class VertexListGraph, class MutableGraph> 
void copy_graph(const VertexListGraph& G, MutableGraph& G_copy,
    const bgl_named_params<P, T, R>& params = all defaults)
```
* VertexListGraph[link ./VertexListGraph.md]
* MutableGraph[link ./MutableGraph.md]

この関数はグラフ `G` から `G_copy` へとすべての頂点と辺をコピーする。また、頂点と辺のプロパティも、 `vertex_all` と `edge_all` プロパティマップを用いるか、あるいはユーザが与えたコピー関数を用いてコピーする。


## 定義場所
boost/graph/copy.hpp


## パラメータ

- IN: `const VertexListGraph& G`
	- 有向または無向グラフ。グラフの型は [Vertex List Graph](VertexListGraph.md) モデルでなければならない。

- OUT: `MutableGraph& G_copy`
	- グラフのコピー結果。 グラフの型は [Mutable Graph](MutableGraph.md) モデルでなければならない。


## 名前付きパラメータ

- IN: `vertex_copy(VertexCopier vc)`
	- これは オリジナルのグラフの頂点のプロパティをコピーの対応する頂点にコピーする [Binary Function](http://www.sgi.com/tech/stl/BinaryFunction.html) である。
	- デフォルト: `vertex_copier<VertexListGraph, MutableGraph>` これはグラフからプロパティマップにアクセスするためにプロパティタグ `vertex_all` を用いる。

- IN: `edge_copy(EdgeCopier ec)`
	- これは オリジナルのグラフの辺のプロパティをコピーの対応する辺にコピーする [Binary Function](http://www.sgi.com/tech/stl/BinaryFunction.html) である。
	- デフォルト: `edge_copier<VertexListGraph, MutableGraph>` これはグラフからプロパティマップにアクセスするためにプロパティタグ `edge_all` を用いる。

- IN: `vertex_index_map(VertexIndexMap i_map)`
	- 頂点添え字マップの型は [Readable Property Map](../property_map/ReadablePropertyMap.md.nolink) モデルでなければならず、また `G` の頂点デスクリプタを `0` から `num_vertices(G)` までの整数にマップしなければならない。
	- デフォルト: `get(vertex_index, G)`

- UTIL/OUT: `orig_to_copy(Orig2CopyMap c)`
	- これはオリジナルのグラフの頂点をコピーの頂点にマップする。
	- デフォルト: 出力グラフの頂点デスクリプタ型のサイズ `num_vertices(g)` の `std::vector` から 作られる [`iterator_property_map`](../property_map/iterator_property_map.md.nolink) で、 添え字マップのために `i_map` を用いる。


## 計算量
時間計算量は O(V + E) 。


***
Copyright © 2000-2001 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Kent.N](mailto:kn@mm.neweb.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

