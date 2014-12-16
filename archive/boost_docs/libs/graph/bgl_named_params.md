#bgl_named_params<Param, Type, Rest>
多くの Boost.Graph アルゴリズムは長いパラメータ列を持ち、その多くはデフォルト値を持つ。これがいくつかの問題を起こす。 1つは、 C++ がテンプレート関数のデフォルト値を扱う仕組みを持っていないことだ。しかし、異なる数のパラメータを持つ複数のバージョンのアルゴリズムを作り、各バージョンが一部のパラメータにデフォルト値を与えることで、この問題は克服される。これは Boost.Graph の以前のバージョンで使われていたアプローチだ。しかし、この解決法はまだ、いくつかの理由で不十分だ。

- パラメータのデフォルト値は特定の順序でしか使えない。デフォルト値の順序がユーザの状況に合わなければ、ユーザは全てのパラメータを与えるという手段をとらなければならない。
- パラメータ列が長いので、順序を忘れやすい。

より良い解決法を与えるのが `bgl_named_params` だ。このクラスを使えば、パラメータを任意の順序で与えることができ、パラメータ名によって引数をパラメータに適合できる。

以下のコードで、名前付きパラメータのテクニックを使って `bellman_ford_shortest_paths()` を呼び出す例を示す。各引数は、引数がどのパラメータに与えられるのかを示す名前を持つ関数に渡される。それぞれの名前付きパラメータは、カンマではなくピリオドで区切られる。

```cpp
bool r = boost::bellman_ford_shortest_paths(g, int(N), 
     boost::weight_map(weight).
     distance_map(&distance[0]).
     predecessor_map(&parent[0]));
```

引数が正しいパラメータ関数に適合される限り、引数が与えられる順序はどうでも良い。これは、上のコードと等価な `bellman_ford_shortest_paths()` の呼び出しである。

```cpp
bool r = boost::bellman_ford_shortest_paths(g, int(N), 
   boost::predecessor_map(&parent[0]).
   distance_map(&distance[0]).
   weight_map(weight));
```

一般に、ユーザは `bgl_named_params` クラスを直接使う必要はない。 `boost::weight_map` のような `bgl_named_params` のインスタンスを作る関数があるからだ。


***
Copyright © 2000-2001

- [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<jsiek@osl.iu.edu>)
- [Lie-Quan Lee](http://www.boost.org/doc/libs/1_31_0/people/liequan_lee.htm), Indiana University (<llee@cs.indiana.edu>)
- [Andrew Lumsdaine](http://www.osl.iu.edu/~lums), Indiana University (<lums@osl.iu.edu>)

Japanese Translation Copyright © 2003 [Hiroshi Ichikawa](gimite@mx12.freecom.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

