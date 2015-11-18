#adjacency_matrix
```cpp
adjacency_matrix<Directed, VertexProperty, 
                 EdgeProperty, GraphProperty,
                 Allocator>
```

`adjacency_matrix` クラスは 従来からの隣接行列を用いて BGL グラフインタフェースを提供する。 頂点数 V のグラフに対して、 V x V 行列を用いる。 その行列では、各要素 a<sub>ij</sub> は 頂点 *i* から 頂点 *j* への辺が存在するか否かを示すブール値のフラグである。 図 1 ではグラフの隣接行列表現が示されている。


![](http://www.boost.org/doc/libs/1_57_0/libs/graph/doc/figs/adj-matrix-graph3.gif) ![](http://www.boost.org/doc/libs/1_57_0/libs/graph/doc/figs/adj-matrix.gif)

図 1: 有向グラフの隣接行列表現。

この隣接行列形式の隣接リストに対する利点は辺の挿入と削除が定数時間で終了するという点である。 いくつか不便な点もある。 まず1つ目は、使用するメモリの量が O(V + E) (ここで、E は辺の数) ではなく、 O(V2) である という点である。 2つ目は、全ての辺を辿る処理(例えば、幅優先探索)は、 O(V2) 時間内で実行されるが、 隣接リストでは O(V + E) 時間である。 つまり、密度の高い(E が V2に近い)グラフに対しては、 `adjacency_matrix` の方がよく、 密度の低い(E が V2 よりもずっと小さい)グラフに対しては、 `adjacency_list` の方がよい ということである。 `adjacency_matrix` クラスはプロパティテンプレートパラメータを介して頂点と辺にオブジェクトを付与することを可能とすることで、 既存のデータ構造を拡張したものである。 第 XXX 章には内部プロパティの使用方法について説明がある。 無向グラフの場合には、 `adjacency_matrix` クラスは V x V 行列を全て使用せず、 代わりに下の三角部分(対角成分とその下)を用いる。 それは、無向グラフの隣接行列は対称行列となるからである。 これによって使用するメモリは (V2)/2 へと軽減される。 図 2 で無向グラフの隣接行列表現を示している。

![](http://www.boost.org/doc/libs/1_31_0/libs/graph/doc/figs/undir-adj-matrix-graph3.gif) ![](http://www.boost.org/doc/libs/1_31_0/libs/graph/doc/figs/undir-adj-matrix2.gif)

図 2: 無向グラフの隣接行列表現。


##Example

図1のグラフを生成する。

```cpp
enum { A, B, C, D, E, F, N };
const char* name = "ABCDEF";

typedef boost::adjacency_matrix<boost::directedS> Graph;
Graph g(N);
add_edge(B, C, g);
add_edge(B, F, g);
add_edge(C, A, g);
add_edge(C, C, g);
add_edge(D, E, g);
add_edge(E, D, g);
add_edge(F, A, g);

std::cout << "vertex set: ";
boost::print_vertices(g, name);
std::cout << std::endl;

std::cout << "edge set: ";
boost::print_edges(g, name);
std::cout << std::endl;

std::cout << "out-edges: " << std::endl;
boost::print_graph(g, name);
std::cout << std::endl;
```

出力：

```
vertex set: A B C D E F 

edge set: (B,C) (B,F) (C,A) (C,C) (D,E) (E,D) (F,A) 

out-edges: 
A --> 
B --> C F 
C --> A C 
D --> E 
E --> D 
F --> A 
```


図2のグラフを生成する。

```cpp
enum { A, B, C, D, E, F, N };
const char* name = "ABCDEF";

typedef boost::adjacency_matrix<boost::undirectedS> UGraph;
UGraph ug(N);
add_edge(B, C, ug);
add_edge(B, F, ug);
add_edge(C, A, ug);
add_edge(D, E, ug);
add_edge(F, A, ug);

std::cout << "vertex set: ";
boost::print_vertices(ug, name);
std::cout << std::endl;

std::cout << "edge set: ";
boost::print_edges(ug, name);
std::cout << std::endl;

std::cout << "incident edges: " << std::endl;
boost::print_graph(ug, name);
std::cout << std::endl;
```

出力:

```
vertex set: A B C D E F 

edge set: (C,A) (C,B) (E,D) (F,A) (F,B) 

incident edges: 
A <--> C F 
B <--> C F 
C <--> A B 
D <--> E 
E <--> D 
F <--> A B 
```


##Where Defined
boost/graph/adjacency_matrix.hpp


##Template Parameters

| パラメータ | 説明 | デフォルト |
|------------|------|------------|
| `Directed`       | グラフが有効か無向かを選ぶ選択子。オプションは `directedS` と `undirectedS`。 | `directedS` |
| `VertexProperty` | 内部プロパティ記憶域を指定する。 | `no_property` |
| `EdgeProperty`   | 内部プロパティ記憶域を指定する。 | `no_property` |
| `GraphProperty`  | グラフのオブジェクトの内部プロパティ記憶域を指定する。 | `no_property` |


##Model Of
[VertexAndEdgeListGraph](VertexAndEdgeListGraph.md), [AdjacencyMatrix](AdjacencyMatrix.md), [MutablePropertyGraph](MutablePropertyGraph.md), [CopyConstructible](../utility/CopyConstructible.md), and [Assignable](Assignable.md).


##Associates Types
```cpp
graph_traits<adjacency_matrix>::vertex_descriptor
```

`adjacency_matrix` と対応付けられた頂点記述子の型。

([Graph](Graph.md) からの要求。)


***
```cpp
graph_traits<adjacency_matrix>::edge_descriptor
```

`adjacency_matrix` と対応付けられた辺記述子の型。

([Graph](Graph.md) からの要求。)


***
```cpp
graph_traits<adjacency_matrix>::vertex_iterator
```

`vertices()` によって返されるイテレータの型。 この頂点イテレータは[RandomAccessIterator](http://www.sgi.com/tech/stl/RandomAccessIterator.html)のモデルである。

([VertexListGraph](VertexListGraph.md) からの要求。)


***
```cpp
graph_traits<adjacency_matrix>::edge_iterator
```

`edges()` によって返されるイテレータの型。 この辺イテレータは[MultiPassInputIterator](../utility/MultiPassInputIterator.md)のモデルである。

([EdgeListGraph](EdgeListGraph.md) からの要求。)


***
```cpp
graph_traits<adjacency_matrix>::out_edge_iterator
```

`out_edges()` によって返されるイテレータの型。 このイテレータは[MultiPassInputIterator](../utility/MultiPassInputIterator.md)のモデルである。

([IncidenceGraph](IncidenceGraph.md) からの要求。)


***
```cpp
graph_traits<adjacency_matrix>::adjacency_iterator
```

`adjacent_vertices()` によって返されるイテレータの型。 このイテレータは出辺イテレータと同じコンセプトのモデルである。

([AdjacencyGraph](AdjacencyGraph.md) からの要求。)


***
```cpp
graph_traits<adjacency_matrix>::directed_category
```

グラフが 有向(`directed_tag`)であるか無向(`undirected_tag`)であるかに関する情報を提供する。

([Graph](Graph.md) からの要求。)


***
```cpp
graph_traits<adjacency_matrix>::edge_parallel_category
```

隣接行列は多重辺の挿入を許可しないので、 この型は常に `disallow_parallel_edge_tag` である。

([Graph](Graph.md) からの要求。)


***
```cpp
graph_traits<adjacency_matrix>::vertices_size_type
```

グラフの頂点数を扱うための型。

([VertexListGraph](VertexListGraph.md) からの要求。)


***
```cpp
graph_traits<adjacency_matrix>::edges_size_type
```

グラフの辺数を扱うための型。

([EdgeListGraph](EdgeListGraph.md) からの要求。)


***
```cpp
graph_traits<adjacency_matrix>::degree_size_type
```

頂点からの出辺数を扱うための型。

([IncidenceGraph](IncidenceGraph.md) からの要求。)


***
```cpp
property_map<adjacency_matrix, PropertyTag>::type
property_map<adjacency_matrix, PropertyTag>::const_type
```

グラフの頂点もしくは辺のプロパティに対するマップの型。 具体的なプロパティはテンプレート引数 `PropertyTag` によって指定され、 グラフの `VertexProperty` もしくは `EdgeProperty` で 指定されているプロパティの内の1つに適合していなければならない。

([PropertyGraph](PropertyGraph.md) からの要求。)


##Member Functions
```cpp
adjacency_matrix(vertices_size_type n,
                 const GraphProperty& p = GraphProperty())
```

頂点数 `n`、辺数 0 であるグラフのオブジェクトを生成する。

([MutableGraph](MutableGraph.md) からの要求。)


***
```cpp
template <typename EdgeIterator>
adjacency_matrix(EdgeIterator first,
                 EdgeIterator last,
                 vertices_size_type n,
                 const GraphProperty& p = GraphProperty())
```

頂点数 `n` で、辺が `[first, last)` の範囲で 与えられたリストで指定された辺をもつグラフのオブジェクトを生成する。 EdgeIterator の値の型は `std::pair` でなければならず、それは整数型の組である。 それら整数は頂点に対応し、`[0, n)` の範囲になければならない。
([IteratorConstructibleGraph](IteratorConstructibleGraph.md) からの要求。)


***
```cpp
template <typename EdgeIterator, typename EdgePropertyIterator>
adjacency_matrix(EdgeIterator first, EdgeIterator last,
                 EdgePropertyIterator ep_iter,
                 vertices_size_type n,
                 const GraphProperty& p = GraphProperty())
```

頂点数 `n` で、辺が `[first, last)` の範囲で与えられたリストで指定された辺をもつグラフのオブジェクトを生成する。 `EdgeIterator` の値の型は `std::pair` でなければならず、それは整数型の組である。 それら整数は頂点に対応し、`[0, n)` の範囲になければならない。 `ep_iter` の `value_type` は `EdgeProperty` であるべきである。


##Non-Member Functions
```cpp
std::pair<vertex_iterator, vertex_iterator>
vertices(const adjacency_matrix& g)
```

グラフ `g` の頂点集合へのアクセスを提供するイテレータの範囲を返す。 ([VertexListGraph](VertexListGraph.md) からの要求。)


***
```cpp
std::pair<edge_iterator, edge_iterator>
edges(const adjacency_matrix& g)
```

グラフ `g` の辺集合へのアクセスを提供するイテレータの範囲を返す。 ([EdgeListGraph](EdgeListGraph.md) からの要求。)


***
```cpp
std::pair<adjacency_iterator, adjacency_iterator>
adjacent_vertices(vertex_descriptor v, const adjacency_matrix& g)
```

グラフ `g` で頂点 `v` に隣接する頂点へのアクセスを提供するイテレータの範囲を返す。 ([AdjacencyGraph](AdjacencyGraph.md) からの要求。)


***
```cpp
std::pair<out_edge_iterator, out_edge_iterator>
out_edges(vertex_descriptor v, const adjacency_matrix& g)
```

グラフ `g` で頂点 `v` の出辺へのアクセスを提供するイテレータの範囲を返す。 グラフが無向であれば、このイテレータの範囲は、頂点 `v` に接続する全ての辺へのアクセスを提供する。

([IncidenceGraph](IncidenceGraph.md) からの要求。)


***
```cpp
vertex_descriptor
source(edge_descriptor e, const adjacency_matrix& g)
```

辺 `e` の始点を返す。

([IncidenceGraph](IncidenceGraph.md) からの要求。)


***
```cpp
vertex_descriptor
target(edge_descriptor e, const adjacency_matrix& g)
```

辺 `e` の終点を返す。

([IncidenceGraph](IncidenceGraph.md) からの要求。)


***
```cpp
degree_size_type
out_degree(vertex_descriptor u, const adjacency_matrix& g)
```

頂点 `u` を出る辺の数を返す。

([IncidenceGraph](IncidenceGraph.md) からの要求。)


***
```cpp
vertices_size_type num_vertices(const adjacency_matrix& g)
```

グラフ `g` の頂点数を返す。

([VertexListGraph](VertexListGraph.md) からの要求。)


***
```cpp
edges_size_type num_edges(const adjacency_matrix& g)
```

グラフ `g` の辺数を返す。

([EdgeListGraph](EdgeListGraph.md) からの要求。)


***
```cpp
vertex_descriptor vertex(vertices_size_type n, const adjacency_matrix& g)
```

グラフの頂点リスト内の `n` 番目の頂点を返す。


***
```cpp
std::pair<edge_descriptor, bool>
edge(vertex_descriptor u, vertex_descriptor v,
     const adjacency_matrix& g)
```

グラフ `g` で、頂点 `u` を頂点 `v` へ接続する頂点を返す。

([AdjacencyMatrix](AdjacencyMatrix.md) からの要求。)


***
```cpp
std::pair<edge_descriptor, bool>
add_edge(vertex_descriptor u, vertex_descriptor v,
         adjacency_matrix& g)
```

辺 `(u,v)` をグラフへ追加し、その新しい辺への辺記述子を返す。 すでに辺があれば二重には追加されず、`bool` のフラグは`false`となる。 この処理はグラフのいかなるイテレータ及び記述子を無効化することはない。

([MutableGraph](MutableGraph.md) からの要求。)


***
```cpp
std::pair<edge_descriptor, bool>
add_edge(vertex_descriptor u, vertex_descriptor v,
         const EdgeProperty& p,
         adjacency_matrix& g)
```

辺 `(u,v)` をグラフへ追加し、その新しい辺にその辺の内部プロパティ記憶域の値として、 `p` を付与する。 さらなる詳細は前にある非メンバ関数 `add_edge()` を見よ。


***
```cpp
void remove_edge(vertex_descriptor u, vertex_descriptor v,
                 adjacency_matrix& g)
```

グラフから辺 `(u,v)` を削除する。

([MutableGraph](MutableGraph.md) からの要求。)


***
```cpp
void remove_edge(edge_descriptor e, adjacency_matrix& g)
```

グラフから辺 `e` を削除する。 この操作は `remove_edge(source(e, g), target(e, g), g)` を呼び出すのと等価である。

([MutableGraph](MutableGraph.md) からの要求。)


***
```cpp
void clear_vertex(vertex_descriptor u, adjacency_matrix& g)
```

グラフから頂点 `u` に接続する全ての辺を削除する。 その頂点はグラフの頂点集合からは削除されない。

([MutableGraph](MutableGraph.md) からの要求。)


***
```cpp
template <typename Property>
property_map<adjacency_matrix, Property>::type
get(Property, adjacency_matrix& g)

template <typename Property>
property_map<adjacency_matrix, Property>::const_type
get(Property, const adjacency_matrix& g)
```

`Property` で指定される頂点プロパティへのプロパティマップのオブジェクトを返す。 `Property` はグラフのテンプレート引数 `VertexProperty` で指定されるプロパティの1つと適合していなければならない。

([PropertyGraph](PropertyGraph.md) からの要求。)


***
```cpp
template <typename Property, typename X>
typename property_traits<
  typenamae property_map<adjacency_matrix, Property>::const_type
>::value_type
get(Property, const adjacency_matrix& g, X x)
```

頂点もしくは辺の記述子 `x` に対するプロパティ値を返す。

([PropertyGraph](PropertyGraph.md) からの要求。)


***
```cpp
template <typename Property, typename X, typename Value>
void
put(Property, const adjacency_matrix& g, X x, const Value& value)
```

値`x` をプロパティ値として `value` にセットする。 `x` は 頂点もしくは辺の記述子である。 `Value` は `typename property_traits<property_map<adjacency_matrix, Property>::type>::value_type` に変換可能でなければならない。

([PropertyGraph](PropertyGraph.md) からの要求。)


***
```cpp
template <typename GraphProperty, typename GraphProperty>
typename property_value<GraphProperty, GraphProperty>::type&
get_property(adjacency_matrix& g, GraphProperty)
```

グラフのオブジェクト `g` に付与された `GraphProperty` で指定されたプロパティを返す。 特性クラス `property_value` は boost/pending/property.hpp で定義される。


***
```cpp
template <typename GraphProperty, typename GraphProperty>
const typename property_value<GraphProperty, GraphProperty>::type&
get_property(const adjacency_matrix& g, GraphProperty)
```

グラフのオブジェクト `g` に付与された `GraphProperty` で指定されたプロパティを返す。 特性クラス `property_value` は boost/pending/property.hpp で定義される。


***
Japanese Translation Copyright (C) 2003 KANAHORI Toshihiro <mailto:kanahori@k.tsukuba-tech.ac.jp>

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

