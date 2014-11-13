#コンセプト・チェック用クラスの作成
コンセプト・チェック用クラスを作成する方法の例証として、[`RandomAccessIterator`](http://www.sgi.com/tech/stl/RandomAccessIterator.html) コンセプトに対応するチェック用クラスを作成する方法を考察する。 最初に、命名規約として、コンセプト・チェック用クラスの名前を、対象コンセプトの名称に接尾辞として "Concept" を加えて生成する。 次に、コンセプトにおける有効式を試行する `constraints()` という名のメンバ関数を定義しなければならない。 `function_requires()` 関数は、この関数のシグネチャが正確に次に示すとおりであることを前提にしている：非 `const` メンバ、パラメータ無し、戻り値型 `void` 。

`constraints()` 関数の最初の部分は、[`RandomAccessIterator`](http://www.sgi.com/tech/stl/RandomAccessIterator.html) と、それが基礎を置くコンセプト、[`BidirectionalIterator`](http://www.sgi.com/tech/stl/BidirectionalIterator.html) 及び [`LessThanComparable`](http://www.sgi.com/tech/stl/LessThanComparable.html) との間にある発展形 "refinement" の関係を表現する要求事項を含んでいる。 そうする代わりに、`BOOST_CLASS_REQUIRE` マクロを使用して、クラス本体に要求事項を置くこともできる。しかし、`BOOST_CLASS_REQUIRE` マクロは、C++ 言語機能としてはやや移植性に欠けるものを使用しているので、ここでは避けた。

次に、イテレータの `iterator_category` が `std::random_access_iterator_tag` あるいはその派生クラスのいずれかであることをチェックする。 その後に、[`RandomAccessIterator`](http://www.sgi.com/tech/stl/RandomAccessIterator.html) コンセプトにおいて有効な式に当たるコードを書き加える。 `typedef` も、関連型のコンセプトを強要するために付加することができる。

```cpp
template <class Iter>
  struct RandomAccessIterator_concept          //（訳注１）
  {
    void constraints() {
      function_requires< BidirectionalIteratorConcept<Iter> >();
      function_requires< LessThanComparableConcept<Iter> >();
      function_requires< ConvertibleConcept<
        typename std::iterator_traits<Iter>::iterator_category,
        std::random_access_iterator_tag> >();

      i += n;
      i = i + n; i = n + i;
      i -= n;
      i = i - n;
      n = i - j;
      i[n];
    }
    Iter a, b;
    Iter i, j;
    typename std::iterator_traits<Iter>::difference_type n;
  };
}
```

(訳注１：いきなり命名規約に反してますが、ライブラリ内の正式版と被らないためだと思われます。よって、原文のまま。)

コンセプト・チェック用クラスの設計中に陥りやすい潜在的な落し穴は、`constraint()` 関数の中で必要よりも多くの式を使用することである。 例えば、式で必要なオブジェクトを作成するために、意図せずデフォルト・コンストラクタを使用してしまうのは良くあることだ（それに、すべてのコンセプトがデフォルト・コンストラクタを必要とするとは限らない)。 クラスのメンバ関数として我々が制約関数を記述するのは、この理由のためである。 式に関与するオブジェクトは、クラスのデータ・メンバとして宣言する。 制約クラス・テンプレートのオブジェクトはインスタンスとして生成されることは無いので、そのデフォルト・コンストラクタがインスタンス化されることはない。 従って、データ・メンバのデフォルト・コンストラクタもインスタンス化されない (C++ 標準 14.7.1 9)。


- [次へ：「コンセプトの充当化と原型」](./concept_covering.md)
- [前へ：「コンセプト・チェックの利用」](./using_concept_check.md)

***
Copyright © 2000 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm)(<jsiek@osl.iu.edu>) Andrew Lumsdaine(<lums@osl.iu.edu>)

