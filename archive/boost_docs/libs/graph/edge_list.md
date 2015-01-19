#edge_list<EdgeIterator, ValueType, DiffType>
`edge_list` クラスは辺イテレータのペアを [EdgeListGraph](./EdgeListGraph.md) をモデルとするクラスに変えるアダプタである。辺イテレータの `value_type` は `std::pair` (もしくは少なくとも `first` メンバと `second` メンバを持っている) でなければならない。ペアの `first_type` と `second_type` は同じでなければならず、それらはグラフの `vertex_descriptor` のために使われるだろう。 `ValueType` と `DiffType` のテンプレート・パラメータは、コンパイラが部分特殊化版をサポートしていない時にのみ必要である。そうでなければデフォルトは正しい型になる。


##コード例
Bellman-Ford の最短経路アルゴリズムを `edge_list` に適用する。

```cpp
enum { u, v, x, y, z, N };
char name[] = { 'u', 'v', 'x', 'y', 'z' };

typedef std::pair<int,int> E;
E edges[] = { E(u,y), E(u,x), E(u,v),
              E(v,u),
              E(x,y), E(x,v),
              E(y,v), E(y,z),
              E(z,u), E(z,x) };

int weight[] = { -4, 8, 5,
                 -2,
                 9, -3,
                 7, 2,
                 6, 7 };

typedef boost::edge_list<E*> Graph;
Graph g(edges, edges + sizeof(edges) / sizeof(E));
  
std::vector<int> distance(N, std::numeric_limits<short>::max());
std::vector<int> parent(N,-1);

distance[z] = 0;
parent[z] = z;
bool r = boost::bellman_ford_shortest_paths(g, int(N), weight,
                                            distance.begin(),
                                            parent.begin());
if (r)  
  for (int i = 0; i < N; ++i)
    std::cout << name[i] << ": " << distance[i]
              << " " << name[parent[i]] << std::endl;
else
  std::cout << "negative cycle" << std::endl;
```

出力は最短経路木中の根と各頂点の親からの距離になる。

```
u: 2 v
v: 4 x
x: 7 z
y: -2 u
z: 0 z
```


##定義場所
boost/graph/edge_list.hpp


##テンプレートパラメータ

| パラメータ | 説明 |
|------------|------|
| `EdgeIterator` | `value_type` が頂点記述子のペアである [InputIterator](http://www.sgi.com/tech/stl/InputIterator.html) のモデルでなければならない。 |
| `ValueType`    | `EdgeIterator` の `value_type`。<br/> デフォルト: `std::iterator_traits<EdgeIterator>::value_type` |
| `DiffType`     | `EdgeIterator` の `difference_type`。<br/> デフォルト: `std::iterator_traits<EdgeIterator>::difference_type` |


##モデル
[EdgeListGraph](./EdgeListGraph)


##関連型

```cpp
boost::graph_traits<edge_list>::vertex_descriptor 
```

`edge_list` に結びつけられた頂点記述子のための型。これは `std::iterator_traits<EdgeIterator>::value_type::first_type` と同じ型であるだろう。


***
```cpp
boost::graph_traits<edge_list>::edge_descriptor
```

`edge_list` に結びつけられた辺記述子のための型。


***
```cpp
boost::graph_traits<edge_list>::edge_iterator
```

`edges()` によって返されるイテレータのための型。`edge_iterator` のイテレータの種類は `EdgeIterator` のそれと同じであるだろう。


##メンバ関数
```cpp
edge_list(EdgeIterator first, EdgeIterator last) 
```

範囲 `[first,last)` で与えられる辺リストで指定された `n` 個の頂点と辺からなるグラフ・オブジェクトを作成する。


##非メンバ関数
```cpp
std::pair<edge_iterator, edge_iterator>
edges(const edge_list& g)
```

グラフ `g` の辺集合へのアクセスを提供するイテレータ範囲を返す。


***
```cpp
vertex_descriptor
source(edge_descriptor e, const edge_list& g)
```

辺 `e` の始点を返す。


***
```cpp
vertex_descriptor
target(edge_descriptor e, const edge_list& g)
```

辺 `e` の終点を返す。


***
Copyright © 2000-2001

- [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)
- [Lie-Quan Lee](http://www.boost.org/doc/libs/1_31_0/people/liequan_lee.htm), Indiana University (<mailto:llee@cs.indiana.edu>)
- [Andrew Lumsdaine](http://www.osl.iu.edu/~lums), Indiana University (<mailto:lums@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Takashi Itou](mailto:takashi-it@po6.nsk.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

