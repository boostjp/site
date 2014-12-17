#ジェネリックプログラミング手法
これは boost ライブラリで使われている、 ジェネリックプログラミング技術の不完全な概観である。

- 翻訳元：<http://www.boost.org/community/generic_programming.html>


##目次

- [はじめに(Introduction)](#introduction)
- [コンセプトの分析(The Anatomy of a Concept)](#the-anatomy-of-a-concept)
- [特性クラス(Traits)](#traits)
- [タグ分岐(Tag Dispatching)](#tag-dispatching)
- [アダプタ(Adaptors)](#adaptors)
- [型生成器(Type Generators)](#type-generators)
- [オブジェクト生成器(Object Generators)](#object-generators)
- [ポリシークラス(Policy Classes)](#policy-classes)


## <a name="introduction" href="#introduction">はじめに(Introduction)</a>
ジェネリックプログラミングはソフトウェアコンポーネントに汎用化に関するものであり、 これによりコンポーネントを多様な状況で容易に再利用することが出来る。 C++ ではクラステンプレートと関数テンプレートがジェネリックプログラミング技術に対して特に効果的である。 なぜなら、これらは効率を犠牲にすることなく汎用化を可能にするからである。

ジェネリックプログラミングの簡単な例として、C 標準ライブラリの `memcpy()` 関数をどのように汎用化するか見てみよう。 `memcpy()` の実装は次のようになっている。

```cpp
void* memcpy(void* region1, const void* region2, size_t n)
{
  const char* first = (const char*)region2;
  const char* last = ((const char*)region2) + n;
  char* result = (char*)region1;
  while (first != last)
    *result++ = *first++;
  return result;
}
```

`memcpy()` 関数は既に、 `void*` を使うことである程度汎用化されているので、 この関数は異なる種類のデータ配列のコピーに使うことが出来る。 しかし、コピーしたいデータが配列の中になかったらどうだろう。 これは、リンクリストかもしれない。コピーの概念を、 どんな要素のシーケンスにでも汎用化できるだろうか。 `memcpy()` の中身を見ると、この関数の **最小限の要求** は、ある種のポインタを使うことで、シーケンスを *横断* し、 指された要素に *アクセス* し、要素を目的地に *書き込み* 、 いつ停止するかを知るためにポインタを *比較する* 必要がある。 C++ 標準ライブラリはこのような要求を **コンセプト** の中にグループ化する。 この場合は、 [Input Iterator](http://www.sgi.com/tech/stl/InputIterator.html) コンセプト(region2) と [Output Iterator](http://www.sgi.com/tech/stl/OutputIterator.html) コンセプト (region1) である。

もし `memcpy()` を関数テンプレートとして書き直し、テンプレート引数の要求を述べるために、 [Input Iterator](http://www.sgi.com/tech/stl/InputIterator.html) と [Output Iterator](http://www.sgi.com/tech/stl/OutputIterator.html) を利用するなら、次のようにして、高度に再利用可能な `copy()` 関数を実装することが出来る。

```cpp
template <typename InputIterator, typename OutputIterator>
OutputIterator
copy(InputIterator first, InputIterator last, OutputIterator result)
{
  while (first != last)
    *result++ = *first++;
  return result;
}
```

汎用の `copy()` 関数を使うことで、どんな種類のシーケンスからでも要素をコピーできるようになるのである。 これには、`std::list` のような、イテレータを外部に置いているリンクリストも含まれる。

```cpp
#include <list>
#include <vector>
#include <iostream>

int main()
{
  const int N = 3;
  std::vector<int> region1(N);
  std::list<int> region2;

  region2.push_back(1);
  region2.push_back(0);
  region2.push_back(3);
  
  std::copy(region2.begin(), region2.end(), region1.begin());

  for (int i = 0; i < N; ++i)
    std::cout << region1[i] << " ";
  std::cout << std::endl;
}
```

## <a name="the-anatomy-of-a-concept" href="#the-anatomy-of-a-concept">コンセプトの分析(The Anatomy of a Concept)</a>
**コンセプト** は要求の集合であり、要求は有効な式、関連型、不変量、 そして計算量の保証から出来ている。要求の集合を満たす型は、コンセプトの モデル と言われる。 コンセプトは他のコンセプトの要求を拡張することが可能であり、これは **発展型(refinement)** と呼ばれる。

- **有効な式** とは、 コンセプトの *モデル* とみなされる式に関わるオブジェクトに対して、 コンパイルが成功しなければならない C++ の式である。
- **関連型** とは、 モデル型と関係する型であり、関連型はそのモデル型の中のひとつ以上の有効な式に加わっている。 典型的には関連型は、モデル型のためのクラス定義の中でネストされた `typedef` によって、 または [特性クラス](#traits) によってアクセスされる。
- **不変量** とは、常に真となる、オブジェクトの実行時特性である。 つまり、そのオブジェクトを含む関数はこれらの特性を維持しなければならない。 不変量は事前条件と事後条件の形を取ることが多い。
- **計算量保証** は有効な式の実行にかかる時間、 またはその計算が使う様々な資源の上限である。

C++ 標準ライブラリで使われているコンセプトは [SGI STL site](http://www.sgi.com/tech/stl/table_of_contents.html) で文書化されている。


## <a name="traits" href="#traits">特性クラス(Traits)</a>
特性クラスは、コンパイル時の実体(型、汎整数定数、アドレス)に情報を関連付ける手段を提供する。例えば、クラステンプレート`std::iterator_traits<T>` は次のようになっている:

```cpp
template <class Iterator>
struct iterator_traits {
  typedef ... iterator_category;
  typedef ... value_type;
  typedef ... difference_type;
  typedef ... pointer;
  typedef ... reference;
};
```

この特性クラスの `value_type` は、イテレータが "指し示す先の" 型に対して、 汎用的なコードを与える。 `iterator_category` はイテレータの能力に依存して、 より効率的なアルゴリズムを選択するために利用することが出来る。

特性テンプレートの核となる特徴は、これらが *でしゃばりではない* ということである: これらは、組み込みの型、サードパーティのライブラリで定義された型を含め、 任意の型に情報を関連付けることを可能にする。通常、特性は特性テンプレートを(部分)特殊化することで、 特定の型に特化されている。

`std::iterator_traits` についての詳細な記述は、 SGI が提供している [このページ](http://www.sgi.com/tech/stl/iterator_traits.html) を見よ。 標準ライブラリでの、大きく異なる別の特性の式は `std::numeric_limits<T>` である。これは、 数値型の範囲と能力を記述する定数を提供している。


## <a name="tag-dispatching" href="#tag-dispatching">タグ分岐(Tag Dispatching)</a>
特性クラスと同時に使われることが多い技術に、タグ分岐がある。 これは、型の性質に基づいて分岐するために、関数オーバーロードを使う方法である。 これについてのよい例は、C++ 標準ライブラリの [`std::advance()`](http://www.sgi.com/tech/stl/advance.html) 関数である。 これは、イテレータを `n` 回インクリメントする。 イテレータの種類によって、実装の中では適用される、異なる最適化がある。 もしイテレータが [random access](http://www.sgi.com/tech/stl/RandomAccessIterator.html) (前方、後方に任意の距離、ジャンプすることが可能である) なら、 `advance()` 関数は単に `i += n` で実装され、これは非常に効率的、つまり定数時間である。 他のイテレータでは、 ステップ数が **上昇** し、演算は `n` に対する線形時間になる。 もしイテレータが、 [双方向](http://www.sgi.com/tech/stl/BidirectionalIterator.html) なら、 `n` が負であっても良いので、 イテレータをインクリメントするかデクリメントするか選ばなければならない。

タグ分岐と特性クラスの関係は、分岐に使われる性質(この場合では `iterator_category`) が特性クラスによってアクセスされることが多い、ということである。 主たる `advance()` 関数は `iterator_category` を得るために [`iterator_traits`](http://www.sgi.com/tech/stl/iterator_traits.html) クラスを使う。 それから、オーバーロードされた `advance_dispatch()` 関数を呼び出すのである。 `iterator_category` をどんな型に解決するかに基づいて、 コンパイラにより、 [`input_iterator_tag`](http://www.sgi.com/tech/stl/input_iterator_tag.html) か [`bidirectional_iterator_tag`](http://www.sgi.com/tech/stl/bidirectional_iterator_tag.html) か [`random_access_iterator_tag`](http://www.sgi.com/tech/stl/random_access_iterator_tag.html) の中から適した `advance_dispatch()` が選ばれるのである。 **タグ** はタグ分岐や、似たような技術で使うための性質を伝える、 という目的だけを持つ単純なクラスである。 イテレータタグのより詳細な記述については、[このページ](http://www.sgi.com/tech/stl/iterator_tags.html) を参照すること。

```cpp
namespace std {
  struct input_iterator_tag { };
  struct bidirectional_iterator_tag { };
  struct random_access_iterator_tag { };

  namespace detail {
    template <class InputIterator, class Distance>
    void advance_dispatch(InputIterator& i, Distance n, input_iterator_tag) {
      while (n--) ++i;
    }

    template <class BidirectionalIterator, class Distance>
    void advance_dispatch(BidirectionalIterator& i, Distance n, 
       bidirectional_iterator_tag) {
      if (n >= 0)
        while (n--) ++i;
      else
        while (n++) --i;
    }

    template <class RandomAccessIterator, class Distance>
    void advance_dispatch(RandomAccessIterator& i, Distance n, 
       random_access_iterator_tag) {
      i += n;
    }
  }

  template <class InputIterator, class Distance>
  void advance(InputIterator& i, Distance n) {
    typename iterator_traits<InputIterator>::iterator_category category;
    detail::advance_dispatch(i, n, category);
  }
}
```


## <a name="adaptors" href="#adaptors">アダプタ(Adaptors)</a>
*アダプタ* は別の型や、新しいインタフェース、振る舞いの変種を提供する型を構築する、 クラステンプレートである。 標準のアダプタの例は、 [`std::reverse_iterator`](http://www.sgi.com/tech/stl/ReverseIterator.html) にある。これは、インクリメント、デクリメントに対しその動きを逆転させる、イテレータ型に対するアダプタである。 [`std::stack`](http://www.sgi.com/tech/stl/stack.html) は単純なスタックインタフェースを提供するコンテナに対するアダプタである。

標準でのアダプタについての、より解りやすいレビューは [ここ](http://www.cs.rpi.edu/~wiseb/xrds/ovp2-3b.html#SECTION00015000000000000000) にある。


## <a name="type-generators" href="#type-generators">型生成器(Type Generators)</a>
*型生成器* はテンプレート引数 [^1] に基づいて新しい型を合成することだけが目的のテンプレートである。 生成された型は通常、ネストされた `typedef` として表現され、いかにもふさわしく `type` と命名される。 型生成は通常、複雑な型表現をひとつの型に統合するために使われる。例えば、 `boost::filter_iterator_generator` では、次のようになっている:

```cpp
template <class Predicate, class Iterator, 
    class Value = complicated default,
    class Reference = complicated default,
    class Pointer = complicated default,
    class Category = complicated default,
    class Distance = complicated default
         >
struct filter_iterator_generator {
    typedef iterator_adaptor<
        Iterator,filter_iterator_policies<Predicate,Iterator>,
        Value,Reference,Pointer,Category,Distance> type;
};
```

いまこれは複雑だが、適応するフィルタイテレータを作るのは簡単である。 あなたは普通、ただこう書くだけでよい:

```cpp
boost::filter_iterator_generator<my_predicate,my_base_iterator>::type
```


## <a name="object-generators" href="#object-generators">オブジェクト生成器(Object Generators)</a>
*オブジェクト生成器* は関数テンプレートであり、唯一の目的は、 引数から新しいオブジェクトを構築することである。 汎用コンストラクタの一種として考えることが出来るだろう。 オブジェクト生成器は、生成される実際の型を表現するのが難しかったり、出来なかったりするときに、 単なるコンストラクタよりも役立つだろう。 そして生成器の結果は変数に格納するのではなく、直接関数に渡すことも出来る。 多くの Boost オブジェクト生成器は接頭辞 "`make_`" がつけられている。 これは、`std::make_pair(const T&, constU&)` に倣ってのことである。

たとえば、次のようなものを考えてみる:

```cpp
struct widget {
  void tweak(int);
};
std::vector<widget *> widget_ptrs;
```

2つの標準のオブジェクト生成器、 `std::bind2nd()` と `std::mem_fun()` を連鎖することで、全ての装置を簡単につまむことが出来る:

```cpp
void tweak_all_widgets1(int arg)
{
   for_each(widget_ptrs.begin(), widget_ptrs.end(),
      bind2nd(std::mem_fun(&widget::tweak), arg));
}
```

オブジェクト生成器を使わなければ、上の例は次のようになる:

```cpp
void tweak_all_widgets2(int arg)
{
   for_each(struct_ptrs.begin(), struct_ptrs.end(),
      std::binder2nd<std::mem_fun1_t<void, widget, int> >(
          std::mem_fun1_t<void, widget, int>(&widget::tweak), arg));
}
```

表現がより複雑になるにつれて、型指定の冗長性を減らす必要性はどうしても大きくなるのである。


## <a name="policy-classes" href="#policy-classes">ポリシークラス(Policy Classes)</a>
ポリシークラスは振る舞いを伝達するために使われるテンプレート引数である。 標準ライブラリからの例は `std::allocator` である。これは、メモリ管理の振る舞いを標準の containers に伝える。

ポリシークラスは Andrei Alexandrescu によって、 [この文書](http://www.cs.ualberta.ca/~hoover/cmput401/XP-Notes/xp-conf/Papers/7_3_Alexandrescu.pdf) の中で詳しく探求されている。彼は次のように書いている:

```
ポリシークラスは几帳面なデザイン選択の実装である。 これらは他のクラスから派生しているか、他のクラスに含まれていて、 構文的に同じインタフェースの下で、異なる戦略を提供する。 ポリシーを使うクラスは、それが使うそれぞれのポリシーに対してひとつのテンプレート引数を持って、 テンプレート化されている。 このためユーザは必要なポリシーを選択することが出来るのである。

ポリシークラスの力は、その能力を自由に組み合わせることから来る。 テンプレートクラスの中のいくつかのポリシークラスを複数の引数と組み合わせることで、 コードの量をそれほど増やすことなく、組み合わせた振る舞いを実現する。
```

Andrei のポリシークラスについての記述は、その力を、 粒状性と直交性から引き出されるものとして述べている。 Boost はおそらく、Iterator Adaptors ライブラリの中でこの特徴を弱めている。 このライブラリでは、適用されたイテレータの振る舞い全てをひとつのポリシークラスに伝えている。 しかし、これには前例がある: `std::char_traits` はその名前にもかかわらず、`std::basic_string` の振る舞いを決定するポリシークラスとして働いているのである。



##脚注
- [^1]: 型生成器は、 C++ に 「テンプレートの `typedef`」 が存在しないことに対する代替手段である。


***

Revised 14 Mar 2001

© Copyright David Abrahams 2001. Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies. This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

***

Japanese Translation Copyright (C) 2003 [Kohske Takahashi](k_takahashi@cppll.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の 複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」 に提供されており、いかなる明示的、暗黙的保証も行わない。また、 いかなる目的に対しても、その利用が適していることを関知しない。

