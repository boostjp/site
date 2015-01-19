#コンセプト・チェックの実装
理想的には、実体化位置においてコンセプト侵害が捕らえられ、提示されるに及くはない。 D&E [[2]](./bibliography.md#design-and-evolution) が言及するように、エラーは、関数テンプレートが必要とする要求事項すべてを試行することにより捕らえることができる。 コードをコンパイルするのみで――一切実行することなく ――済ませたいが故に、要求事項（とくに有効式）を行使する方法は、まさに扱いにくい問題である。 我々のアプローチは、関数ポインタに代入される個別の関数に要求事項を試行させることである。 この場合、コンパイラは関数を実体化するだろうが、実際にそれを起動することはない。 さらに、コンパイラの最適化によって「死んでいるコード」としてポインタ代入は削除されうだろう（代入によって課される実行時オーバヘッドは、どんな場合でも些細であろうが）。 まず第一に、コンパイラが制約関数のセマンティクス解析およびコンパイルをスキップすることは考えられるかもしれない。 そうなれば、関数ポインタ・テクニックは効力を失うだろう。 しかし、不必要なコードおよび関数の除去が、通常はコンパイルの後半の段階で行われるので、これはありそうもない。 関数ポインタ・テクニックは、GNU C++、Microsoft Visual C++、およびいくつかの EDG ベースのコンパイラ（KAI C++、SGI MIPSpro）で問題なく使用できた。 以下のコードは、このテクニックを` std::stable_sort()` 関数に適用する方法を示す：

```cpp
template <class RandomAccessIterator>
void stable_sort_constraints(RandomAccessIterator i)
{
  typename std::iterator_traits<RandomAccessIterator>
    ::difference_type n;
  i += n;  // exercise the requirements for RandomAccessIterator
  ...
}
template <class RandomAccessIterator>
void stable_sort(RandomAccessIterator first, RandomAccessIterator last)
{
  typedef void (*fptr_type)(RandomAccessIterator);
  fptr_type x = &stable_sort_constraints;
  ...
}
```

多くの場合、確認される必要のある要求事項の集合は多大なものとなる。 また、ライブラリ実装者にとって、すべての公開関数テンプレートのために `stable_sort_constraints()` のような制約関数を書くのは煩わしいことだろう。 代わりに、対応するコンセプトの定義に従って、有効式の集合を一まとめにする。 各コンセプトに対して、テンプレート・パラメータがあるところでその型をチェックするために、コンセプト・チェック用クラステンプレートを定義する。 このクラスは、コンセプトの有効式をすべて試行する `contraints()` メンバ関数を含んでいる。 `n` や `i` などのような制約関数の中で使用されるオブジェクトは、コンセプト・チェック用クラスのデータ・メンバとして宣言する。

```cpp
template <class Iter>
struct RandomAccessIterator_concept
{
  void constraints()
  {
    i += n;
    ...
  }
  typename std::iterator_traits<RandomAccessIterator>
    ::difference_type n;
  Iter i;
  ...
};
```

これでメンバ関数ポインタを扱わなくてはならなくなったが、制約関数の実体化を引き起こすために関数ポインタ・メカニズムを使用することは、依然として可能である。 ライブラリ実装者がコンセプト・チェックを呼出すことを簡便にするために、`function_requires()` という名前の関数の中に、メンバ関数ポインタ機構を隠蔽した。 以下のコード片は、イテレータが [`RandomAccessIterator`](http://www.sgi.com/tech/stl/RandomAccessIterator.html) であることを確かめるために `function_requires()` を使用する方法を提示する。

```cpp
template <class Iter>
void stable_sort(Iter first, Iter last)
{
  function_requires< RandomAccessIteratorConcept<Iter> >();
  ...
}
```

`function_requires()` の定義は以下のとおりである。 `Concept` は、モデルとなる型によって実体化された、コンセプト・チェック用クラスである。 我々は、関数ポインタ `x` に制約メンバ関数のアドレスを代入する。 そうすることで、制約関数の実体化およびコンセプトの有効式のチェックを行うことができる。 それから、変数が未使用であることを示すコンパイラ警告を回避するために、`x` へ `x` を代入し、名前衝突を防ぐために、全体を do-while ループで包む。

```cpp
template <class Concept>
void function_requires()
{
  void (Concept::*x)() = BOOST_FPTR Concept::constraints;
  ignore_unused_variable_warning(x);
}
```

クラス・テンプレートの型パラメータをチェックするために、クラス定義本体内で使用できる `BOOST_CLASS_REQUIRE` マクロを提供する（関数では本体内で `function_requires()` のみを使用すればよいのと対照的である）。 このマクロは入れ子クラス・テンプレートを宣言し、そのテンプレート・パラメータは関数ポインタである。 それから、`typedef` の中で、テンプレート引数として、制約関数への関数ポインタ型を渡して入れ子クラス型を使用する。 名前衝突を防ぐ支援として、入れ子クラスおよび `typedef` 名において `type_var` と`concept`の名前を使用する。

```cpp
#define BOOST_CLASS_REQUIRE(type_var, ns, concept) \
  typedef void (ns::concept <type_var>::* func##type_var##concept)(); \
  template <func##type_var##concept _Tp1> \
  struct concept_checking_##type_var##concept { }; \
  typedef concept_checking_##type_var##concept< \
    BOOST_FPTR ns::concept<type_var>::constraints> \
    concept_checking_typedef_##type_var##concept
```

さらに、２つ以上の型の相互作用を必要とするコンセプトを扱うために、より多くの引数をとる `BOOST_CLASS_REQUIRE` のバージョンがある。 コンパイラの中には、関数ポインタ型のテンプレート・パラメータを実装しないものが複数あるため、BCCL コンセプト・チェックの実装においては`BOOST_CLASS_REQUIRE` を使用していない。


- [次へ：「リファレンス」](./reference.md)
- [前へ：「コンセプトを用いたプログラミング」](./prog_with_concepts.md)

***
Copyright © 2000 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm)(<mailto:jsiek@osl.iu.edu>) Andrew Lumsdaine(<mailto:lums@osl.iu.edu>)

