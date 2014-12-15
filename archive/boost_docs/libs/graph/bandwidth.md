#bandwidth
```cpp
(1)
template <typename Graph>
typename graph_traits<Graph>::vertices_size_type
bandwidth(const Graph& g)

(2)
template <typename Graph, typename VertexIndexMap>
typename graph_traits<Graph>::vertices_size_type
bandwidth(const Graph& g, VertexIndexMap index_map)
```

無向グラフの 帯域幅 (bandwidth) は二つの隣接頂点の間の最大距離 で、頂点が構成単位間隔に置かれた線上で測定された距離である。別の言い方を すると、 もし無向グラフの頂点 `G=(V,E)` に各々 `0` から `|V| - 1` までの `index[v]` によって与えられる添え字が割り当てられているなら、`G` の帯域幅は以下である：


B(G) = max { |index[u] - index[v]|  | (u,v) in E }


##Defined in
boost/graph/bandwidth.hpp


***
##ith_bandwidth

```cpp
 (1)
template <typename Graph>
typename graph_traits<Graph>::vertices_size_type
ith_bandwidth(typename graph_traits<Graph>::vertex_descriptor i,
      const Graph& g)

(2)
template <typename Graph, typename VertexIndexMap>
typename graph_traits<Graph>::vertices_size_type
ith_bandwidth(typename graph_traits<Graph>::vertex_descriptor i,
      const Graph& g,
      VertexIndexMap index)
```

グラフの `i` 番目の帯域幅 (i-th bandwidth) は、 `i` 番目の頂点とその隣接のいずれかとの間の最大距離である。

B<sub>i</sub>(G) = max { |index[i] - index[j]|  | (i,j) in E }


それで帯域幅 B(G) は `i` 番目の帯域幅 B<sub>i</sub>(G) の最大値として表すことができる。

B(G) = max { B<sub>i</sub>(G)   | i=0...|V|-1 }


##Defined in
boost/graph/bandwidth.hpp 


***
Copyright © 2000-2001 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<jsiek@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Takashi Itou](takashi-it@po6.nsk.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

