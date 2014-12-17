#BGLでグラフアルゴリズムを構築する
BGLの主な目標は、精密なグラフ・クラスを提供することにあるのではなく、また再利用可能なグラフ・アルゴリズムの広範囲にわたる集合を提供することにあるのでもない (それらは目標であるにもかかわらず)。BGLの主な目標は、他者に再利用可能なグラフのアルゴリズムを書くよう奨励することである。再利用可能とは最大限に再利用可能であることを意味する。ジェネリックプログラミングはアルゴリズムを最大限に再利用可能にする手法であり、この章でジェネリックプログラミングをいかにグラフ・アルゴリズムを構築するのに応用するかについて論ずるつもりである。

ジェネリックプログラミングの過程を説明するために、グラフの着色アルゴリズムの構築を歩み抜けてみようと思う。グラフの着色問題 (またはもっと具体的に頂点着色問題) はグラフ `G` 中の各頂点を、同じ色で彩られた隣接した二つの頂点がないように、そして最小の色数が使われるようにすることである。一般的に、グラフの着色問題はNP完全問題で、それゆえ適度な量の時間で最適解を見つけるのは不可能である。しかしながら、最小に近い着色を見つけるために発見的手法を使う多くのアルゴリズムが存在する。

ここで示す今問題にするアルゴリズムは疎なヤコビ行列とヘッセン行列の消去法 [[9](./bibliography.md#curtis74:_jacob),[7](./bibliography.md#coleman84:_estim_jacob),[6](./bibliography.md#coleman85:_algor)] 中で用いられている 線形時間の SEQ サブルーチンに基づいている。このアルゴリズムはグラフ中の全ての頂点を入力された順序によって定義される順番に従って訪れる。各頂点において、アルゴリズムは隣接頂点の色を印付け、それから現時点の頂点の色のために最小のまだ印付けられていない色を選ぶ。もし全ての色がすでに印付けられていたら、新しい色が作成される。色の印番号が現在の頂点番号に等しいなら、色は印付けられているとみなされる。これは各頂点のために印を置き直さねばならない厄介ごとから守る。このアルゴリズムの有効性は入力された頂点の順番に大きく依存する。最大先頭 (largest-first) 順序付け [[31]](./bibliography.md#welsch67)、 最小後尾 (smallest-last) 順序付け [[29]](./bibliography.md#matula72:_graph_theory_computing)、そして接続次数 (incidence degree) による順序付け [[32]](./bibliography.md#brelaz79:_new) を含むいくつかの順序付けアルゴリズムが存在し、そしてそれらはこの着色アルゴリズムの有効性を改善する。

汎用グラフ・アルゴリズムを構築する際にする最初の決定は、どのグラフ操作がアルゴリズムの実装のために必要か決定すること、そしてその操作にどのグラフ・コンセプトを結びつけるか決定することである。このアルゴリズム中で頂点の色を初期化するために全ての頂点を通して巡回する必要があるだろう。さらに隣接頂点もアクセスする必要がある。それゆえ [VertexListGraph](./VertexListGraph.md) コンセプトを選択するつもりである。というのは、これらの操作を含む最小の概念であるからである。グラフの型はこのアルゴリズムのためにテンプレート関数中で引数が決められるだろう。グラフの型を BGL [`adjacency_list`](./adjacency_list.md) のような特定のグラフ・クラスには限定しない。なぜかというとこれはアルゴリズムの再利用可能性を著しく制限するだろうからである (今まで書かれたほとんどのアルゴリズムはそうであるが)。グラフの型を [VertexListGraph](./VertexListGraph.md) をモデルとする型にぜひ限定しよう。これはアルゴリズム中のそれらのグラフ操作の使用によって、その上 `function_requires()` とともにコンセプト・チェックとして付け加えられた明示的な要求として強いられる (コンセプト・チェックについてのさらなる詳細のために章 [Concept Checking](../concept_check.md) を見なさい)。

次に、このプログラム中でどの頂点プロパティまたは辺プロパティが使われるであろうかについて考える必要がある。この場合、唯一のプロパティは頂点の色である。頂点の色へのアクセスを指定する最も融通のきく方法はプロパティ・マップのインターフェースを使うことである。これはアルゴリズムの使用者にどのようにプロパティを格納したいかを決定する能力を与える。色の読み書き両方が必要であろうから、[ReadWritePropertyMap](../property_map/ReadWritePropertyMap.md) としての要求を指定する。カラー・マップの `key_type` はグラフからの `vertex_descriptor` でなければならず、`value_type` は 整数の種類でなければならない。さらに `order` 引数のためのインターフェースをプロパティ・マップとして指定する。この場合 [ReadablePropertyMap](../property_map/ReadablePropertyMap.md) である。順序付けのために、`key_type` は整数のオフセットで、 `value_type` は `vertex_descriptor` である。再びコンセプト・チェックとともにこれらの要求を適用する。このアルゴリズムの返却値はグラフを着色するのに必要な色の数で、従って関数の返却値型はグラフの `vertices_size_type` である。次のコードはテンプレート関数としてのグラフのアルゴリズムのためのインターフェース、コンセプト・チェック、そしていくつかの `typedef` を示す。実装は容易であり、上述で論ぜられていない唯一の段階は色の初期化段階で、そしてそこで全ての頂点の色を「着色されてない」状態にする。

```cpp
namespace boost {
  template <class VertexListGraph, class Order, class Color>
  typename graph_traits<VertexListGraph>::vertices_size_type
  sequential_vertex_color_ting(const VertexListGraph& G, 
    Order order, Color color)
  {
    typedef graph_traits<VertexListGraph> GraphTraits;
    typedef typename GraphTraits::vertex_descriptor vertex_descriptor;
    typedef typename GraphTraits::vertices_size_type size_type;
    typedef typename property_traits<Color>::value_type ColorType;
    typedef typename property_traits<Order>::value_type OrderType;

    function_requires< VertexListGraphConcept<VertexListGraph> >();
    function_requires< ReadWritePropertyMapConcept<Color, vertex_descriptor> >();
    function_requires< IntegerConcept<ColorType> >();
    function_requires< size_type, ReadablePropertyMapConcept<Order> >();
    typedef typename same_type<OrderType, vertex_descriptor>::type req_same;
    
    size_type max_color = 0;
    const size_type V = num_vertices(G);
    std::vector<size_type> 
      mark(V, numeric_limits_max(max_color));
    
    typename GraphTraits::vertex_iterator v, vend;
    for (tie(v, vend) = vertices(G); v != vend; ++v)
      color[*v] = V - 1; // which means "not colored"
    
    for (size_type i = 0; i < V; i++) {
      vertex_descriptor current = order[i];

      // 隣接頂点の全ての色を印付ける
      typename GraphTraits::adjacency_iterator ai, aend;
      for (tie(ai, aend) = adjacent_vertices(current, G); ai != aend; ++ai)
        mark[color[*ai]] = i; 

      // 隣接頂点によって使われていない最小の色を見つける
      size_type smallest_color = 0;
      while (smallest_color < max_color && mark[smallest_color] == i) 
        ++smallest_color;

      // もし全ての色を使い切ったら、色の数を増やす
      if (smallest_color == max_color)
        ++max_color;

      color[current] = smallest_color;
    }
    return max_color;
  }
} // namespace boost
```


***
Copyright © 2000-2001

- [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<jsiek@osl.iu.edu>)
- [Lie-Quan Lee](http://www.boost.org/doc/libs/1_31_0/people/liequan_lee.htm), Indiana University (<llee@cs.indiana.edu>)
- [Andrew Lumsdaine](http://www.osl.iu.edu/~lums), Indiana University (<lums@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Takashi Itou](takashi-it@po6.nsk.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

