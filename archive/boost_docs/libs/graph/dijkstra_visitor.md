# dijkstra_visitor&lt;EventVisitorList&gt;
このクラスは、(`std::pair` を使って作られる) [EventVisitor](EventVisitor.md) のリストを [DijkstraVisitor](DijkstraVisitor.md) に変換するアダプタである。


## コード例

以下は [examples/dave.cpp](examples/dave.cpp.md) からの抜粋である。ここでは Dijkstra のアルゴリズムで計算された最短経路木のコピーを作るために、 `copy_graph` という単独イベントビジタを使っている。

```cpp
boost::dijkstra_shortest_paths
  (G, vertex(a, G), 
   distance_map(make_iterator_property_map(distance.begin(), vertex_id, distance[0])).
   predecessor_map(make_iterator_property_map(parent.begin(), vertex_id, parent[0])).
   visitor(make_dijkstra_visitor(copy_graph(G_copy, on_examine_edge()))));
```

## モデル
[Dijkstra Visitor](DijkstraVisitor.md)


## テンプレートパラメータ

| パラメータ | 説明 | デフォルト |
|------------|------|------------|
| `EventVisitorList` | `std::pair` で作られた EventVisitor のリスト。 | `null_visitor` |


## 定義場所
boost/graph/dijkstra_shortest_paths.hpp


## メンバ関数
このクラスは [DijkstraVisitor](DijkstraVisitor.md) に要求される全てのメンバ関数を実装している。それぞれの関数で、適切なイベントが `EventVisitorList` の中の [EventVisitor](EventVisitor.md) にディスパッチされる。


## 非メンバ関数

| 関数 | 説明 |
|------|------|
| `template <class EventVisitorList>`<br/> `dijkstra_visitor<EventVisitorList>`<br/> `make_dijkstra_visitor(EventVisitorList ev_list);` | イベントビジタのリストを Dijkstra ビジタに適合させたものを返す。 |


## 関連項目
[Visitorコンセプト](visitor_concepts.md.nolink)

イベントビジタ: [`predecessor_recorder`](predecessor_recorder.md.nolink) 、 [`distance_recorder`](distance_recorder.md) 、 [`time_stamper`](time_stamper.md.nolink) 、 [`property_writer`](property_writer.md.nolink) 。 


***
Copyright © 2000-2001

- [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)
- [Lie-Quan Lee](http://www.boost.org/doc/libs/1_31_0/people/liequan_lee.htm), Indiana University (<mailto:llee@cs.indiana.edu>)
- [Andrew Lumsdaine](http://www.osl.iu.edu/~lums), Indiana University (<mailto:lums@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Hiroshi Ichikawa](mailto:gimite@mx12.freecom.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

