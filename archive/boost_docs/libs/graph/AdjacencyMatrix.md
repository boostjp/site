#AdjacencyMatrix
AdjacencyMatrix コンセプトは [Graph](./Graph.md) コンセプトを精製し、始点と終点によって与えられるグラフ中の任意の辺への効率的なアクセスのために必要なものを付け加えている。今のところどの Boost の グラフ・ライブラリ・アルゴリズムもこのコンセプトを使っていない。しかしながらこのコンセプトを必要とするであろう Floyd-Warshall のようなまだ実装されていないアルゴリズムが存在する。


##Refinement of
[Graph](./Graph)


##関連型
- `boost::graph_traits<G>::traversal_category`

このタグ型は `adjacency_matrix_tag` に変換可能でなければならない。


##有効な表現式

| 名前 | 式 | 返却値型 | 説明 |
|------|----|----------|------|
| 直接の辺アクセス | `edge(u,v,g)` | `std::pair<edge_descriptor, bool>` | グラフ `g` 中の `u` と `v` の間に辺が存在するかどうかを述べるフラグと、辺が見つかった場合に辺記述子から成るペアを返す。 |


##モデル
[`adjacency_matrix`](./adjacency_matrix.md)


##コンセプトチェックするクラス

```cpp
template <class G>
struct AdjacencyMatrix
{
  typedef typename boost::graph_traits<G>::edge_descriptor edge_descriptor;
  void constraints() {
    p = edge(u, v, g);
  }
  typename boost::graph_traits<G>::vertex_descriptor u, v;
  std::pair<bool, edge_descriptor> p;
  G g;
};
```


***
Copyright © 2000-2001 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Takashi Itou](mailto:takashi-it@po6.nsk.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

