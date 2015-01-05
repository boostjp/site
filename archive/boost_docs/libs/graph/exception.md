#boost/graph/exception.hpp

BGL は、 BGL アルゴリズムからエラーを報告するためにいくつかの例外クラスを定義している。 多くの BGL アルゴリズムは入力されるグラフについてある種の要求事項を設定している。 もしこれらの要求事項に則さないならば、 そのアルゴリズムは成功裏に完了することができず、その代わりに適切な例外を投げる。


##Synopsis

```cpp
struct bad_graph : public invalid_argument {
  bad_graph(const string& what_arg);
};
struct not_a_dag : public bad_graph {
  not_a_dag();
};
struct negative_edge : public bad_graph {
  negative_edge();
};
struct negative_cycle : public bad_graph {
  negative_cycle();
};
struct not_connected : public bad_graph {
  not_connected();
};
```

