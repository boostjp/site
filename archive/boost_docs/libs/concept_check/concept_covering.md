#Concept Covering and Archetypes
これまで、コンポーネントへの入力に対して、最小限の要求事項(コンセプト)を選択することの重要性を議論してきた。 しかし、選択したコンセプトが対象のアルゴリズムを「充当 "cover"」していることを確認するのも、同様に重要である。 すなわち、発生する可能性のあるユーザ・エラーは全てコンセプト・チェックによって漏れなく捕らえられるべきである。 コンセプト充当性は、「原型クラス "archetype class"」を使用することで確認可能だ。 原型クラスとは、特定のコンセプトに関連するインタフェースの正確な実装である。 原型クラスの実行時の振舞いに重要性はなく、そのメンバ関数本体は空文のままでかまわない。 そうすれば、コンポーネントへの入力として原型クラスを与えてコンパイルするだけで、簡単なテスト・プログラムが作成できる。 そのプログラムがコンパイル可能であれば、対応するコンセプトがそのコンポーネントを充当していることが確認できたことになる。

以下のコードは、[`TrivialIterator`](http://www.sgi.com/tech/stl/trivial.html) コンセプトに対する原型クラスである。 原型が対応するコンセプトと正確に一致していることを保証するために、いくつかの点で注意しなければならないことがある。 例えば、コンセプトは `operator*()` の戻り値型が値型に変換可能でなければならない。 だからといって、これはその戻り値型として、より厳格に `T&` あるいは `const T&` を要求している訳ではない。 それは、原型クラスの戻り値型として `T&` あるいは `const T&` を使用することが、誤りとなることを意味する。 正しいアプローチは、`T` 型に変換可能なユーザー定義の戻り値型を作成することで、この例では `input_proxy` として処理している。 原型クラスを用いたテストの妥当性は、完全にコンセプトとの正確な一致に依存しており、それを確認するためには慎重な（人手による）検査を必要とする。

```cpp
template <class T>
struct input_proxy {
  operator const T&() {
    return static_object<T>::get(); // Get a reference without constructing
  }
};
template <class T>
class trivial_iterator_archetype
{
  typedef trivial_iterator_archetype self;
public:
  trivial_iterator_archetype() { }
  trivial_iterator_archetype(const self&) { }
  self& operator=(const self&) { return *this;  }
  friend bool operator==(const self&, const self&) { return true; }
  friend bool operator!=(const self&, const self&) { return true; }
  input_proxy<T> operator*() { return input_proxy<T>(); }
};

namespace std {
  template <class T>
  struct iterator_traits< trivial_iterator_archetype<T> >
  {
    typedef T value_type;
  };
}
```

ジェネリック・アルゴリズムのテストとして、一般的な複数の入力型に対してインスタンスの生成を行う場合が往々にしてある。 一例として、`std::stable_sort()` に対して、イテレータとして組み込みのポインタ型を適用することが考えられる。 これは、アルゴリズムの実行時の振る舞いをテストするには適切であるが、コンセプト充当性の保証には有用ではない。 なぜなら、C++ の組み込み型は特定のコンセプトとー致を見ることは決してなく、たいていの場合、それが提供する機能は何らかのコンセプトが単独で必要とする最小のそれを上回っている。 すなわち、たとえ与えられた型で関数テンプレートがコンパイルできたとしても、そのコンセプトの要求事項は、その関数を充当する実際の要求事項に及ばないことがありうる。 それ故に、一般的な入力型でテストすることに加えて、原型クラスでコンパイルすることは重要である。

以下は、記載されている [`std::stable_sort()`](https://sites.google.com/site/cpprefjp/reference/algorithm/stable_sort) の要求事項をチェックするために原型を使用する方法を示す、[stl_concept_covering.cpp](./stl_concept_covering.cpp.md) からの抜粋である。 この場合、[`CopyConstructible`（コピー・コンストラクト可能）](http://www.boost.org/doc/libs/1_31_0/libs/utility/CopyConstructible.html) と [`Assignable`](http://www.boost.org/doc/libs/1_31_0/libs/utility/Assignable.html)（割り当て可能） 要求事項が、SGI STL 文書から無視されているように見える (試しに、その原型を削除してみるとよい) 。 Boost の原型クラスは、階層構造が取れるように設計されている。 この例において、イテレータの値型は３つの原型から構成される。 下記で参照されている原型クラスでは、`Base` という名前のテンプレート・パラメータが、階層化された原型を使用可能であることを示している。

```cpp
{
  typedef less_than_comparable_archetype< 
      sgi_assignable_archetype<> > ValueType;
  random_access_iterator_archetype<ValueType> ri;
  std::stable_sort(ri, ri);
}
```

- [次へ： Programming with Concepts](./prog_with_concepts.md)
- [前へ： Creating Concept Checking Classes](./creating_concepts.md)


***
Copyright © 2000 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm)(<jsiek@osl.iu.edu>) Andrew Lumsdaine(<lums@osl.iu.edu>)

