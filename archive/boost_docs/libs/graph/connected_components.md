# connected_components
```cpp
// 名前付きパラメータバージョン
template <class VertexListGraph, class ComponentMap, class P, class T, class R>
typename property_traits<ComponentMap>::value_type
connected_components(VertexListGraph& G, ComponentMap comp,
    const bgl_named_params<P, T, R>& params = all defaults);

// この関数の名前なしパラメータバージョンは存在しない
```

`connected_components()` 関数は、無向グラフの連結成分を DFS に基づく方法を用いて計算する。無向グラフの連結成分はすべての互いに到達可能な頂点の集合である。もしグラフが増大する間、連結成分を保持する必要があるなら、 [`incremental_components()`](incremental_components.md) 関数の素集合に基づく方法の方が速い。「静的な」グラフには この DFS に基づく方法の方が速い [[8]](bibliography.md#clr90)。

このアルゴリズムの出力は成分プロパティ・マップ `comp` に記録され、そしてそれは各頂点に割り当てられた成分番号を与える数を含んでいる。 全成分数が関数の返却値である。


## 定義場所
boost/graph/connected_components.hpp


## パラメータ

- IN: `const Graph& g`
	- 無向グラフ。グラフの型は [Vertex List Graph](VertexListGraph.md) かつ [Incidence Graph](IncidenceGraph.md) のモデルでなければならない。

- OUT: `ComponentMap c`
	- このアルゴリズムはグラフ中にある連結成分数を計算し、各成分に整数のラベルを割り当てる。このアルゴリズムはそれから成分プロパティ・マップ中の成分番号を記録することによってグラフ中の各頂点がどの成分に属しているかを登録する。`ComponentMap` 型は [Writable Property Map](../property_map/WritablePropertyMap.md.nolink) のモデルでなければならない。値型は汎整数型であるべきで、できればグラフの `vertices_size_type` に等しい方が望ましい。キー型はグラフの頂点記述子型でなければならない。


## 名前付き引数

- UTIL: `color_map(ColorMap color)`
	- これはグラフの進行過程を保持するためにアルゴリズムによって使われる。 `ColorMap` 型は [Read/Write Property Map](../property_map/ReadWritePropertyMap.md.nolink) のモデルでなければならず、かつキー型はグラフの頂点記述子型でなければならず、またカラー・マップの値型は [ColorValue](ColorValue.md) のモデルでなければならない。
	- デフォルト: サイズ `num_vertices(g)` の `default_color_type` の `std::vector` から作られた [`iterator_property_map`](iterator_property_map.md) で、添え字マップには `i_map` を用いる。


- IN: `vertex_index_map(VertexIndexMap i_map)`
	- これは各頂点を `[0, num_vertices(g))` の範囲において整数にマップする。 このパラメータはデフォルトのカラー・プロパティ・マップが使われた時にのみ必要である。 `VertexIndexMap` の型は [Readable Property Map](../property_map/ReadablePropertyMap.md.nolink) のモデルでなければならない。マップの値型は汎整数型でなければならない。 グラフの頂点記述子型はマップのキー型として使用できる必要がある。
	- デフォルト: `get(vertex_index, g)`


## 計算量
連結成分のアルゴリズムの時間計算量もまた O(V + E) である。


## 関連項目
[`strong_components()`](strong_components.md) and [`incremental_components()`](incremental_components.md)


## コード例
ファイル [examples/connected_components.cpp](examples/connected_components.cpp.md) は無向グラフの連結成分を計算する例を含む。


***
Copyright © 2000-2001 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Takashi Itou](mailto:takashi-it@po6.nsk.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

