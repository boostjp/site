#EventVisitorList Concept

EventVisitorList は、[EventVisitor](./EventVisitor.md) そのものか、 `std::pair` で結合された EventVisitor のリストである。各グラフアルゴリズムには、 EventVisitorList を、アルゴリズムに必要な独自のビジタに変換するアダプタが定義されている。 以下に、イベントビジタを `std::pair` で結合してリストにする方法の例と、アルゴリズムのビジタアダプタクラスの使い方の例を示す。

仮に、[深さ優先探索](./graph_theory_review.md#dfs-algorithm)で、各頂点の発見／呼び出しの前後関係を、括弧を使った構造で出力したいとする。これを達成するには、 BGL アルゴリズム [`depth_first_search()`](./depth_first_search.md) と2つのイベントビジタを使えばよい。以下の例の完全なソースコードは [examples/dfs_parenthesis.cpp](./examples/dfs_parenthesis.cpp.md) にある。まず、 2 つのイベントビジタを定義する。使うイベントビジタとして、 DFSVisitor に詳述されたイベントのリストの中から `on_discover_vertex` と `on_finish_vertex` を選ぶ。

```cpp
struct open_paren : public base_visitor<open_paren> {
  typedef on_discover_vertex event_filter;
  template <class Vertex, class Graph>
  void operator()(Vertex v, Graph& G) {
    std::cout << "(" << v;
  }
};
struct close_paren : public base_visitor<close_paren> {
  typedef on_finish_vertex event_filter;
  template <class Vertex, class Graph>
  void operator()(Vertex v, Graph& G) {
    std::cout << v << ")";
  }
};
```

次に2つのイベントビジタオブジェクトを作り、 `std::make_pair` で作られる `std::pair` を使って、この2つから EventVisitorList を作る。

```cpp
std::make_pair(open_paren(), close_paren())
```

次にこのリストを `depth_first_search()` に渡したいところだが、 `depth_first_search()` が要求しているのは [DFSVisitor](./DFSVisitor.md) であって、 EventVisitorList ではない。そこで EventVisitor のリストを DFSVisitor に変換するアダプタ、 [`dfs_visitor`](./dfs_visitor.md) を使う。他のビジタアダプタ同様、 `dfs_visitor` には `make_dfs_visitor()` という作成関数がある。

```cpp
make_dfs_visitor(std::make_pair(open_paren(), close_paren()))
```

さあこれで、以下のように、生成されたビジタオブジェクトを `depth_first_search()` に渡すことができる。

```cpp
  // グラフオブジェクト G を作る...

  std::vector<default_color_type> color(num_vertices(G));

  depth_first_search(G, make_dfs_visitor(std::make_pair(open_paren(), close_paren())),
                     color.begin());
```

3つ以上のイベントビジタのリストを作りたければ、以下のように `std::make_pair` をネストして呼び出せばいい。

```cpp
std::make_pair(visitor1,
  std::make_pair(visitor2,
    ...
    std::make_pair(visitorN-1, visitorN)...));
```


##関連項目
[EventVisitor](./EventVisitor.md), [Visitorコンセプト](./visitor_concepts.md)


***
Copyright © 2000-2001

- [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<jsiek@osl.iu.edu>)
- [Lie-Quan Lee](http://www.boost.org/doc/libs/1_31_0/people/liequan_lee.htm), Indiana University (<llee@cs.indiana.edu>)
- [Andrew Lumsdaine](http://www.osl.iu.edu/~lums), Indiana University (<lums@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Hiroshi Ichikawa](gimite@mx12.freecom.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

