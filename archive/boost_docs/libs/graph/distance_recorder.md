#distance_recorder<DistanceMap, EventTag>
これは、グラフ探索中に、ある始点から各頂点までの距離を ([property map](../property_map.md) を使って) 記録する [EventVisitor](EventVisitor.md) である。辺 `e = (u,v)` に対して実行されると、 `v` への距離は `u` への距離より大きくなる。 `distance_recorder` は `on_tree_edge` や `on_relax_edge` イベントでよく使われる。頂点イベントには使用できない。

[`bfs_visitor`](bfs_visitor.md) や [`dfs_visitor`](dfs_visitor.md) などのアルゴリズム別のアダプタでラップすることで、 `distance_recorder` を グラフアルゴリズムで使えるようになる。また、`std::pair` を使って他のイベントビジタと結合して、 EventVisitorList を作れる。


##コード例
例は [`bfs_visitor`](bfs_visitor.md) を参照。


##モデル
[EventVisitor](EventVisitor.md)


##定義場所
boost/graph/visitors.hpp


##テンプレートパラメータ

| パラメータ | 説明 | デフォルト |
|------------|------|------------|
| `DistanceMap` | キーの型と値の型がグラフの頂点記述子型である [WritablePropertyMap](../property_map/WritablePropertyMap.md) [[訳注1]](#translate_note_1)。 |
| `EventTag`    | グラフアルゴリズム中、いつ `distance_recorder` が呼び出されるかを指定するタグ。 `EventTag` は辺イベントでなければならない。 |


##関連型

| 型 | 説明 |
|----|------|
| `distance_recorder::event_filter` | テンプレートパラメータ `EventTag` と同じ型。 |


##メンバ関数

| メンバ | 説明 |
|--------|------|
| `distance_recorder(DistanceMap pa);` | 距離プロパティマップ `pa` を使って `distance_recorder` オブジェクトを構築する。 |
| `template <class Edge, class Graph>`<br/> `void operator()(Edge e, const Graph& g);` | 辺 `e = (u,v)` を渡されると、 `u` への距離に 1 を足したものを `v` への距離として記録する。 |


##非メンバ関数

| 関数 | 説明 |
|------|------|
| `template <class DistanceMap, class Tag>`<br/> `distance_recorder<DistanceMap, Tag>`<br/> `record_distances(DistanceMap pa, Tag);` | `distance_recorder` を作る便利な方法。 |


##関連項目
[Visitorコンセプト](visitor_concepts.md)

イベントビジタ: [`predecessor_recorder`](predecessor_recorder.md) 、 [`time_stamper`](time_stamper.md) 、 [`property_writer`](property_writer.md) 。


##訳注
<a name="translate_note_1" href="#translate_note_1">[訳注1]</a> 値の型は整数である。


***
Copyright © 2000-2001

- [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)
- [Lie-Quan Lee](http://www.boost.org/doc/libs/1_31_0/people/liequan_lee.htm), Indiana University (<mailto:llee@cs.indiana.edu>)
- [Andrew Lumsdaine](http://www.osl.iu.edu/~lums), Indiana University (<mailto:lums@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Hiroshi Ichikawa](mailto:gimite@mx12.freecom.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

