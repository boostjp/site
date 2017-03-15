# cuthill_mckee_ordering

| 構成要素 | 値 |
|----------|----|
| グラフ     | 無向 |
| プロパティ | 色、次数 |
| 計算量     | `time: O(log(m)|E|) where m = max { degree(v) | v in V }` |

```cpp
(1)
template <class IncidenceGraph, class OutputIterator,
          class ColorMap, class DegreeMap>
void 
cuthill_mckee_ordering(IncidenceGraph& g,
                       typename graph_traits<Graph>::vertex_descriptor s,
                       OutputIterator inverse_permutation, 
                       ColorMap color, DegreeMap degree)

(2)
template <class VertexListGraph, class OutputIterator, 
          class ColorMap, class DegreeMap>
void 
cuthill_mckee_ordering(VertexListGraph& G, OutputIterator inverse_permutation, 
                       ColorMap color, DegreeMap degree)
```

Cuthill-Mckee(と逆Cuthill-Mckee)順序アルゴリズム[[14](bibliography.md#george81:__sparse_pos_def), [43](bibliography.md#cuthill69:reducing_bandwith), [44](bibliography.md#liu75:anal_cm_rcm), [45](bibliography.md#george71:fem)]の目的は、各頂点に割り当てられている添え字を再順序付けすることによって、グラフの[帯域幅](bandwidth.md)を減らすことである。Cuthill-Mckee の順序付けアルゴリズムは、 i 番目の帯域幅の局所最小化によって動作する。頂点は基本的に幅優先探索順に割り当てられる。ただし各段階において、隣接頂点がキュー中に次数の昇順で並べられることを除く。

このアルゴリズムのバージョン (1) がユーザに「始点」を選ばせるのに対し、 バージョン (2) は疑似周辺ペアの発見的手法を用いて良好な始点を見つける。「始点」の選択は順序付けの品質上、重要な影響を持つ傾向がある。

このアルゴリズムの出力は、新しい順序付けになっている頂点である。使用した出力イテレータの種類に依存して、Cuthill-Mckee の順序付け、または逆 Cuthill-Mckee の順序付けのどちらか一方を得られる。例えば、出力を `vector` のリバース・イテレータを用いて `vector` に格納すれば、逆 Cuthill-Mckee 順序付けを得る。

```cpp
std::vector<vertex_descriptor> inv_perm(num_vertices(G));
cuthill_mckee_ordering(G, inv_perm.rbegin());
```

どちらの方法でも、出力を `vector` に格納することは、新しい順序付けから古い順序付けへの順列を与える。

```cpp
inv_perm[new_index[u]] == u
```

多くの場合、ほしい順列は逆の順列、つまり古い添え字から新しい添え字への順列である。これは次の方法で簡単に計算され得る。

```cpp
for (size_type i = 0; i != inv_perm.size(); ++i)
  perm[old_index[inv_perm[i]]] = i;
```


## パラメータ
**バージョン (1) 用:**

- `IncidenceGraph& g`  (IN) 
	- 無向グラフ。グラフの型は [IncidenceGraph](IncidenceGraph.md) のモデルでなければならない。

- `vertex_descriptor s`  (IN) 
	- 始点。

- `OutputIterator inverse_permutation`  (OUT) 
	- 新しい頂点の順序付け。頂点は新しい順序で [output iterator](http://www.sgi.com/tech/stl/OutputIterator.html) に書かれる。

- `ColorMap color_map`  (WORK) 
	- 内部的にアルゴリズムの進行過程を保持するために使われる (同じ頂点を二回訪れるのを回避するために)。

- `DegreeMap degree_map`  (IN) 
	- これは頂点を次数にマップしなければならない。


**バージョン (2) 用**:

- `VertexListGraph& g`  (IN) 
	- 無向グラフ。グラフの型は [VertexListGraph](VertexListGraph.md) のモデルでなければならない。

- `OutputIterator inverse_permutation`  (OUT) 
	- 新しい頂点の順序付け。頂点は新しい順序で出力イテレータに書かれる。

- `ColorMap color_map`  (WORK) 
	- 内部的にアルゴリズムの進行過程を保持するために使われる (同じ頂点を二回訪れるのを回避するために)。

- `DegreeMap degree_map`  (IN) 
	- これは頂点を次数にマップしなければならない。


## コード例
[examples/cuthill_mckee_ordering.cpp](examples/cuthill_mckee_ordering.cpp.md) を参照。


## 関連項目
[`bandwidth`](bandwidth.md)、それと boost/graph/properties.hpp 中の `degree_property_map`。


***
Copyright © 2000-2001 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Takashi Itou](mailto:takashi-it@po6.nsk.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

