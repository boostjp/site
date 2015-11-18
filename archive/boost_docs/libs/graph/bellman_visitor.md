#bellman_visitor<EventVisitorList>
このクラスは、(`std::pair` を使って作られる) [EventVisitor](EventVisitor.md) のリストを [BellmanFordVisitor](BellmanFordVisitor.md) に変換するアダプタである。


##モデル
[BellmanFordVisitor](BellmanFordVisitor.md)


##テンプレートパラメータ

| パラメータ | 説明 | デフォルト |
|------------|------|------------|
| `EventVisitorList` | `std::pair` で作られた [EventVisitor](EventVisitor.md) のリスト。 | `null_visitor` |


##定義場所
boost/graph/bellman_ford_shortest_paths.hpp


##メンバ関数
このクラスは [BellmanFordVisitor](BellmanFordVisitor.me) に要求される全てのメンバ関数を実装している。それぞれの関数で、適切なイベントが EventVisitorList の中の [EventVisitor](./EventVisitor.md) にディスパッチされる。


##非メンバ関数

| 関数 | 説明 |
|------|------|
| `template <class EventVisitorList>`<br/> `bellman_visitor<EventVisitorList>`<br/> `make_bellman_visitor(EventVisitorList ev_list);` | イベントビジタのリストを [BellmanFordVisitor](BellmanFordVisitor.md) に適合させたものを返す。 |


##関連項目
[Visitorコンセプト](visitor_concepts.md)

イベントビジタ: [`predecessor_recorder`](predecessor_recorder.md) 、 [`distance_recorder`](distance_recorder.me) 、 [`time_stamper`](./time_stamper.md) 、 [`property_writer`](property_writer.md) 。


***
Copyright © 2000-2001

- [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)
- [Lie-Quan Lee](http://www.boost.org/doc/libs/1_31_0/people/liequan_lee.htm), Indiana University (<mailto:llee@cs.indiana.edu>)
- [Andrew Lumsdaine](http://www.osl.iu.edu/~lums), Indiana University (<mailto:lums@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Hiroshi Ichikawa](mailto:gimite@mx12.freecom.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

