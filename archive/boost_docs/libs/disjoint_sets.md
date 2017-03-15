# Distjoint Sets（互いに素な集合）

- 翻訳元ドキュメント： <http://www.boost.org/doc/libs/1_31_0/libs/disjoint_sets/disjoint_sets.html>

```cpp
disjoint_sets<Rank, Parent, FindCompress>
```

このクラスは、互いに素な集合（素集合）の演算に 順位による和集合 および パス圧縮 を提供する。disjoint-sets のデータ構造は、素集合の S = {S<sub>1</sub>, S<sub>2</sub>, ..., S<sub>k</sub>} というコレクションを維持する。 各集合は、集合のいくつかの要素である 代表値 によって識別される。 集合は、Parent プロパティマップの中の符号化された有向木によって表わされる。 2つの発見的手法: 「順位による和集合」 および 「パス圧縮」 は、 演算を高速化するのに使われる  [[1](disjoint_sets/bibliography.md#tarjan83), [2](disjoint_sets/bibliography.md#clr90)]。


## Where Defined
- boost/disjoint_sets.hpp


## Template Parameters

| パラメータ     | 説明 |
|----------------|------|
| `Rank`         | 値型が整数型で、キー型が集合の要素型と等しい [`ReadWritePropertyMap`](property_map/ReadWritePropertyMap.md.nolink) のモデルでなければならない。 |
| `Parent`       | [`ReadWritePropertyMap`](property_map/ReadWritePropertyMap.md.nolink) のモデルで、かつ、キー型および値型は集合の要素型と等しくなければならない。 |
| `FindCompress` | 代表値の検索およびパス圧縮関数オブジェクトのうちの 1つであるべきだ。 |


## Example
`disjoint_sets` に対する典型的な使用法の手本は [`kruskal_minimum_spanning_tree()`](graph/kruskal_minimum_spanning_tree.md.nolink) アルゴリズムで見ることができる。 この例では、`union_set()` の代わりに `link()` を呼び出す。 なぜなら、`u` および `v` が `find_set()` から得られ、したがって、既にそれら集合の代表値であるからだ。

```cpp
...
disjoint_sets<Rank, Parent, FindCompress> dsets(rank, p);

for (ui  = vertices(G).first; ui != vertices(G).second; ++ui)
  dsets.make_set(*ui);
...
while ( !Q.empty() ) {
  e = Q.front();
  Q.pop();
  u = dsets.find_set(source(e));
  v = dsets.find_set(target(e));
  if ( u != v ) {
    *out++ = e;
    dsets.link(u, v);
  }
}
```


## Members

| メンバ | 説明 |
|--------|------|
| `disjoint_sets(Rank r, Parent p)` | コンストラクタ。 |
| `disjoint_sets(const disjoint_sets& x)` | コピーコンストラクタ。 |
| `template <class Element>`<br/> `void make_set(Element x)` | `Element x` を含む単集合を作成する。 |
| `template <class Element>`<br/> `void link(Element x, Element y)` | `x` および `y` で表わされる 2つの集合を結合する。 |
| `template <class Element>`<br/> `void union_set(Element x, Element y)` | 要素 `x` および `y` を含む 2つの集合を結合する。 これは、`link(find_set(x),find_set(y))` に相当する。 |
| `template <class Element>`<br/> `Element find_set(Element x)` | 要素 `x` を含む集合のための代表値を返す。 |
| `template <class ElementIterator>`<br/> `std::size_t count_sets(ElementIterator first, ElementIterator last)` | 素集合の個数を返す。 |
| `template <class ElementIterator>`<br/> `void compress_sets(ElementIterator first, ElementIterator last)` | すべての要素の親がその代表値であるように親ツリーを平滑化する。 |


## Complexity
時間計算量は、O(m alpha(m,n)) である。alpha は逆アッカーマン関数、 m は disjoint-set の演算（`make_set()`、`find_set()`、および `link()`）の総数、n は要素数である。 alpha 関数はとても遅く、log 関数よりもはるかに遅くなる。


参照：

- [`incremental_connected_components()`](graph/incremental_connected_components.md.nolink)


***

```cpp
disjoint_sets_with_storage<ID,InverseID,FindCompress>
```

このクラスは、順位および親のプロパティのための記憶領域を内部で管理する。 記憶領域は、要素IDにより索引付けされた配列の中にある。ゆえに、ID および InverseID ファンクタを必要とする。 順位および親のプロパティは、構築中に初期化される、 したがって、各要素は自動的に集合の中にある（従って、このクラスのオブジェクトを [`initialize_incremental_components()`](graph/incremental_components.md.nolink#sec:initialize-incremental-components) 関数で初期化することは必要でない。）。 このクラスは、頂点プロパティを格納する場所を提供しない `edge_list` グラフの（動的）接続している構成要素を計算する場合に特に有用である。


## Template Parameters

| パラメータ | 説明 | デフォルト |
|------------|------|------------|
| `ID` | 0からN（集合中の要素の総数）までの整数に要素を対応付ける [`ReadablePropertyMap`](property_map/ReadablePropertyMap.md.nolink) のモデルでなければならない。 | `boost::identity_property_map` |
| `InverseID` | 要素に整数を対応付ける [`ReadablePropertyMap`](property_map/ReadablePropertyMap.md.nolink) のモデルでなければならない。 | `boost::identity_property_map` |
| `FindCompress` | 代表値の検索およびパス圧縮関数オブジェクトのうちの 1つであるべきだ。 | `representative_with_full_path_compression` |


## Members
このクラスは、以下のメンバだけでなく `disjoint_sets` のすべてのメンバも持っている。

```cpp
disjoint_sets_with_storage(size_type n = 0,
                           ID id = ID(),
                           InverseID inv = InverseID())
```

コンストラクタ。


```cpp
template <class ElementIterator>
void disjoint_sets_with_storage::
  normalize_sets(ElementIterator first, ElementIterator last)
```

各集合の代表値が最も小さな ID を備えた要素になるように代表値を再整理する。 

- 事後条件: `v >= parent[v]`
- 事前条件: 素集合の構造は圧縮されていなければならない。 


***
```cpp
representative_with_path_halving<Parent>
```

これは、要素 `x` と同じ構成要素のための代表的な頂点を検索するファンクタである。 代表値木を横断している間、ファンクタは、さらに木の高さを短くするためにパス二分技術を適用する。

```cpp
Element operator()(Parent p, Element x)
```


***
```cpp
representative_with_full_path_compression<Parent>
```

これは、要素 `x` が属する集合のための代表的な要素を検索するファンクタである。

```cpp
Element operator()(Parent p, Element x)
```

***
Copyright © 2000

- [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Univ.of Notre Dame (<mailto:jsiek@lsc.nd.edu>)
- [Lie-Quan Lee](http://www.lsc.nd.edu/~llee1), Univ.of Notre Dame (<mailto:llee1@lsc.nd.edu>)
- [Andrew Lumsdaine](http://www.lsc.nd.edu/~lums), Univ.of Notre Dame (<mailto:lums@lsc.nd.edu>)

Japanese Translation Copyright (C) 2003 IKOMA Yoshiki <mailto:ikoma@mb.i-chubu.ne.jp>

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の 複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」 に提供されており、いかなる明示的、暗黙的保証も行わない。また、 いかなる目的に対しても、その利用が適していることを関知しない。

