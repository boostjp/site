#EventVisitor Concept
このコンセプトは単独イベントビジタのインタフェースを定義する。 EventVisitor は適用メンバ関数 (`operator()`) を持つ。これは、 EventVisitor 内の `event_filter` typedef で指定されるイベントが起きた時に、グラフアルゴリズム内で実行される。 EventVisitor を組み合わせて [EventVistorList](./EventVistorList.md) を作成できる。

以下に、 BGL アルゴリズムによって実行されるイベントのタグのリストを示す。各タグは、アルゴリズムのビジタのメンバ関数と対応している。例えば、[`breadth_first_search()`](./breadth_first_search.md) の [BFSVisitor](./BFSVisitor.md) には `cycle_edge()` というメンバ関数がある。これに対応するタグは `on_cycle_edge` だ。 `operator()` の第1引数は、イベントタグによって決まる、辺か頂点の記述子でなければならない。

```cpp
namespace boost {
  struct on_initialize_vertex { };
  struct on_start_vertex { };
  struct on_discover_vertex { };
  struct on_examine_edge { };
  struct on_tree_edge { };
  struct on_cycle_edge { };
  struct on_finish_vertex { };
  struct on_forward_or_cross_edge { };
  struct on_back_edge { };
  struct on_edge_relaxed { };
  struct on_edge_not_relaxed { };
  struct on_edge_minimized { };
  struct on_edge_not_minimized { };
} // namespace boost
```

##Refinement of
[Copy Constructible](../utility/CopyConstructible.md) (ビジタのコピーは軽い操作である方がいい)


##表記

| 識別子 | 説明 |
|--------|------|
| `G`    | Graph のモデルの型。 |
| `g`    | `G` 型のオブジェクト。 |
| `V`    | EventVisitor のモデルの型。 |
| `vis`  | `V` 型のオブジェクト。 |
| `x`    | `boost::graph_traits<G>::vertex_descriptor` 型か `boost::graph_traits<G>::edge_descriptor` 型のオブジェクト。 |


##関連型

| 名前 | 型 | 説明 |
|------|----|------|
| Event Filter | `V::event_filter` | どのイベントによってビジタが実行されるかを指定するタグ構造体。 |


##有効な表現式

| 名前 | 式 | 戻り値 | 説明 |
|------|----|--------|------|
| Apply Visitor | `vis(x, g)` | `void` | オブジェクト `x` に対してビジタの操作を実行する。 `x` はグラフの辺か頂点の記述子である。 |


##モデル

- [`predecessor_recorder`](./predecessor_recorder.md)
- [`distance_recorder`](./distance_recorder.md)
- [`time_stamper`](./time_stamper.md)
- [`property_writer`](./property_writer.md)
- [`null_visitor`](./null_visitor.md)


##関連項目
[EventVisitorList](./EventVisitorList.md), [Visitorコンセプト](./visitor_concepts.md)


***
Copyright © 2000-2001

- [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)
- [Lie-Quan Lee](http://www.boost.org/doc/libs/1_31_0/people/liequan_lee.htm), Indiana University (<mailto:llee@cs.indiana.edu>)
- [Andrew Lumsdaine](http://www.osl.iu.edu/~lums), Indiana University (<mailto:lums@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Hiroshi Ichikawa](mailto:gimite@mx12.freecom.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

