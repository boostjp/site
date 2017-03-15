# adjacency_list_traits
```cpp
adjacency_list_traits<EdgeList, VertexList, Directed>
```

このクラスは `adjacency_list` クラスに結びついた型のいくつかをアクセスする代替方法を提供する。このクラスの主な理由は値が頂点記述子または辺記述子であるグラフ・プロパティを時々作成したいと思うからである。もしこのために `graph_traits` を使おうと試みるならば、相互に再帰的な型の問題にぶつかるだろう。この問題を避けるために `adjacency_list_traits` クラスが提供され、それはユーザにグラフのためのプロパティ型を提供する 要求をすることなしにユーザが頂点記述子型または辺記述型にアクセスできるようにする。

```cpp
template <class EdgeList, class VertexList, class Directed>
struct adjacency_list_traits {
  typedef ... vertex_descriptor;
  typedef ... edge_descriptor;
  typedef ... directed_category;
  typedef ... edge_parallel_category;
};
```


## Where Defined
`boost/graph/adjacency_list.hpp`


## Template Parameters

| パラメータ   | 説明 | デフォルト |
|--------------|------|------------|
| `EdgeList`   | 辺コンテナの実装のための選択子型。   | `vecS` |
| `VertexList` | 頂点コンテナの実装のための選択子型。 | `vecS` |
| `Directed`   | グラフが有向であるか無向であるかの選択子型。 | `directedS` |


## Model of
[DefaultConstructible](http://www.sgi.com/tech/stl/DefaultConstructible.html) and [Assignable](http://www.sgi.com/tech/stl/Assignable.html)


## Type Requirements
工事中


## Members

| メンバ | 説明 |
|--------|------|
| `vertex_descriptor` | グラフ中の頂点を識別するのに使われるオブジェクトのための型。 |
| `edge_descriptor`   | グラフ中の辺を識別するのに使われるオブジェクトのための型。
| `directed_category` | これはグラフが無向 (`undirected_tag`) であるか有向 (`directed_tag`) であるかを述べる。 |
| `edge_parallel_category` | これはグラフが多重辺の挿入を許可する (`allow_parallel_edge_tag`) か、または自動的に多重辺を取り除く (`disallow_parallel_edge_tag`) かを述べる。 |


## See Also
[`adjacency_list`](adjacency_list.md)


***
Copyright © 2000-2001

- [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)
- [Lie-Quan Lee](http://www.boost.org/doc/libs/1_31_0/people/liequan_lee.htm), Indiana University (<mailto:llee@cs.indiana.edu>)
- [Andrew Lumsdaine](http://www.osl.iu.edu/~lums), Indiana University (<mailto:lums@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Kent.N](mailto:kn@mm.neweb.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

