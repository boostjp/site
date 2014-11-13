#コンセプト・チェックの利用
各コンセプトに対して、与えられた型 (あるいは型の集合) がコンセプトをモデル化していることを確かめるために使用することができる、何らかのコンセプト・チェック用クラスが存在する。 Boost コンセプト・チェック・ライブラリ (BCCL) は、C++ 標準ライブラリの中で使用される全てのコンセプト＋αを対象とした、コンセプト・チェック用クラスを含んでいる。 [リファレンス](./reference.md) セクションに、このコンセプト・チェック用クラスをリストしてある。 さらに、他の Boost ライブラリも、ライブラリ独自の特別なコンセプトに対応するコンセプト・チェック用クラスを付随している。 例えば、[graph concept](../graph/graph_concepts.md) および [property map concept](../property_map/property_map.md) がある。 さらに、クラス・テンプレートや関数テンプレートを記述する者は、既存のコンセプトでカバーされていない要求事項を表現する必要のある場合は常に、新しいコンセプト・チェック用クラスを作成すべきである。 その方法は [コンセプト・チェック用クラスの作成](./creating_concepts.md) セクションで説明する。

BCCL のコンセプト・チェック用クラスの例として、`EqualityComparableConcept` クラスを挙げる。 このクラスは、C++ 標準 20.1.1 に記述されている `EqualityComparable` (等値比較可能) 要求事項および、SGI STL で文書化されている [`EqualityComparable`](http://www.sgi.com/tech/stl/EqualityComparable.html) (等値比較可能) コンセプトに相当する。

```cpp
template <class T>
struct EqualityComparableConcept;
```

テンプレート引数 `T` はチェック対象の型と意図されている。 すなわち、`EqualityComparableConcept` の目的は、`T` に対して与えられたテンプレート引数が 等値比較可能コンセプトをモデル化しているかどうか確認することである。

個々のコンセプト・チェック用クラスには、該当するコンセプトにおいて有効な式を内包する `constraints()` という名前のメンバー関数がある。 ある型が `EqualityComparable` (等値比較可能) であるかどうかチェックするためには、その型でコンセプト・チェック用クラスのインスタンスを生成し、次に、コンパイラに、実際に `constraints()` 関数を実行することなくコンパイルさせる方法を見つける必要がある。 Boost コンセプト・チェック・ライブラリは、これを容易にする2つのユーティリティ： `function_requires()` と `BOOST_CLASS_REQUIRE` を定義している。


##`function_requires()`
`function_requires()` 関数は関数本体の中で使用できる。また、`BOOST_CLASS_REQUIRE` マクロはクラス定義本体で使用できる。 `function_requires()` 関数は引数をとらないが、コンセプト・チェック用クラスを受けるためのテンプレート・パラメータを有する。 これは、以下に示すように、インスタンス化されたコンセプト・チェック用クラスを明示的にテンプレート引数として与えられなければならないことを意味する。

```cpp
// In my library:
template <class T>
void generic_library_function(T x)
{
  function_requires< EqualityComparableConcept<T> >();
  // ...
};

// In the user's code:  
class foo {
  //... 
};

int main() {
  foo f;
  generic_library_function(f);
  return 0;
}
```


##`BOOST_CLASS_REQUIRE`
`BOOST_CLASS_REQUIRE` マクロは、ある型がコンセプトをモデル化しているかどうかチェックするために、クラス定義の内部で使用することができる。

```cpp
// In my library:
template <class T>
struct generic_library_class
{
  BOOST_CLASS_REQUIRE(T, boost, EqualityComparableConcept);
  // ...
};

// In the user's code:  
class foo {
  //... 
};

int main() {
  generic_library_class<foo> glc;
  // ...
  return 0;
}
```

##例
以前の [動機の例](./concept_check.md#motivating_example) に対してコンセプト・チェックを応用する場合、良いやり方として、テンプレート・パラメータ型が [`RandomAccessIterator`](http://www.sgi.com/tech/stl/RandomAccessIterator.html) をモデル化していることを確認するために `std::stable_sort()` の一番上に `function_requires()` を挿入することが一つ挙げられる。 さらに、`std::stable_sort()` は、イレテータの `value_type` が[`LessThanComparable` (未満比較可能)](http://www.sgi.com/tech/stl/LessThanComparable.html) を満足することが必要であるから、これをチェックするために、重ねて `function_requires()` を使用する。

```cpp
template <class RandomAccessIter>
void stable_sort(RandomAccessIter first, RandomAccessIter last)
{
  function_requires< RandomAccessIteratorConcept<RandomAccessIter> >();
  typedef typename std::iterator_traits<RandomAccessIter>::value_type value_type;
  function_requires< LessThanComparableConcept<value_type> >();
  ...
}
```

コンセプトによっては複数の型を処理するものがある。 この場合、対応するコンセプト・チェック用クラスは複数のテンプレート・パラメータを持つことになる。 以下の例は、`function_requires()` を、２つの型パラメータ（プロパティ・マップ型とそのキーとなる型）をとる [`ReadWritePropertyMap`](../property_map/ReadWritePropertyMap.md) コンセプトに対して使用する方法を示す。

```cpp
template <class IncidenceGraph, class Buffer, class BFSVisitor, 
          class ColorMap>
void breadth_first_search(IncidenceGraph& g, 
  typename graph_traits<IncidenceGraph>::vertex_descriptor s, 
  Buffer& Q, BFSVisitor vis, ColorMap color)
{
  typedef typename graph_traits<IncidenceGraph>::vertex_descriptor Vertex;
  function_requires< ReadWritePropertyMap<ColorMap, Vertex> >();
  ...
}
```

`BOOST_CLASS_REQUIRE` の使用例として、`std::vector` が有すべきコンセプト・チェックを考察する。 要素型に対して当てはめる要求事項の一つは、それが [`Assignable` (割当可能)](http://www.sgi.com/tech/stl/Assignable.html)でなければならない、ということである。 これは、`std::vector` の定義の一番上に`BOOST_CLASS_REQUIRE(T, boost, AssignableConcept)`を挿入することにより、チェックすることができる。

コンセプト・チェックは、ジェネリック・ライブラリの実装者が使用するために設計されているが、エンドユーザーにおいても有用である。 往々にして、ある型が特定のコンセプトをモデル化しているかどうか、不明確な場合がある。 こういうケースでは、問題の型とコンセプトを対象として `function_requires()` を使用する、小さなプログラムを作成することで容易にチェックできる。 ファイル [stl_concept_checks.cpp](./stl_concept_check.cpp.md) は、STL コンテナにコンセプト・チェックを適応する実例となっている。


- [次へ：「コンセプト・チェック用クラスの作成」](./creating_concepts.md)
- [前へ：「はじめに」](./concept_check.md)

***
Copyright © 2000 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm)(<jsiek@osl.iu.edu>) Andrew Lumsdaine(<lums@osl.iu.edu>)

