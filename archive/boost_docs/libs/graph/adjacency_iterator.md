# Adjacency Iterator Adaptor

Defined in header `boost/graph/adjacency_iterator.hpp`

隣接イテレータ・アダプタは `out_edge_iterator` を隣接イテレータに変形する。すなわち、辺の方々を巡回するイテレータを取り、それらの **終点** の方々を巡回するイテレータを作成する。このアダプタと共に [Incidence Graph](IncidenchGraph.md) をモデルとするグラフ型を取り、[Adjacency Graph](AdjacencyGraph.md) によって要求される能力を付け加えるのは些細なことである。


## Synopsis

```cpp
namespace boost {
  template <class Graph, class VertexDescriptor, class OutEdgeIter>
  class adjacency_iterator_generator {
  public:
    typedef iterator_adaptor<...> type;
  };
}
```


## Example
下記は `adjacency_iterator_generator` クラスの使い方の例である。

```cpp
#include <boost/graph/adjacency_iterator.hpp>

class my_graph {
  // ...
  typedef ... out_edge_iterator;
  typedef ... vertex_descriptor;
  typedef boost::adjacency_iterator_generator<my_graph, vertex_descriptor, out_edge_iterator>::type adjacency_iterator;
  // ...
};
```


## Template Parameters

| パラメータ | 説明 |
|------------|------|
| `Graph`    | グラフ型で、それは Incidence Graph をモデルとしなければならない。 |
| `VertexDescriptor` | これは `graph_traits<Graph>::vertex_descriptor` と同じ型で なければならない。これがテンプレート・パラメータである理由は、 `adjacency_iterator_generator` の主な使用はグラフ・クラスの定義の **内側** であり、その文脈中でまだ完全に定義されていないグラフ・ クラスの上で `graph_traits` を使えないからである。<br/> デフォルト: `graph_traits<Graph>::vertex_descriptor` |
| `OutEdgeIter` | これは `graph_traits<Graph>::out_edge_iterator` と同じ型でなければならない。<br/> デフォルト: `graph_traits<Graph>::out_edge_iterator` |


## Model of
隣接イテレータ・アダプタ (型 `adjacency_iterator_generator<...>::type`) は [Multi-Pass Input Iterator](../utility/MultiPassInputIterator.md) のモデルである。


## Members
隣接イテレータ型は `reference` の型が `value_type` と同じで、それから `operator*()` が値返しであることを除けば、[Random Access Iterator](http://www.sgi.com/tech/stl/RandomAccessIterator.html) コンセプトによって要求されるメンバ関数と演算子を実装している。 さらに次のコンストラクタを持つ:

```cpp
adjacency_iterator_generator::type(const OutEdgeIter& it)
```


***
Revised 19 Aug 2001

©Copyright Jeremy Siek 2000. Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies. This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

Japanese Translation Copyright © 2003 [Takashi Itou](mailto:takashi-it@po6.nsk.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。


