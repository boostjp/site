#The Boost Concept Check Library (BCCL)

- 翻訳元ドキュメント： <http://www.boost.org/doc/libs/1_31_0/libs/concept_check/concept_check.htm>
- ヘッダーファイル： boost/concept_check.hpp と boost/concept_archetype.hpp

C++ におけるジェネリック・プログラミングは、抽象データ型(あるいは「コンセプト」)を表現するためにテンプレート・パラメータを使用することを特徴としている。 しかし、C++ 言語には、クラス・テンプレートや関数テンプレートに対して、与えられたテンプレート引数がモデル化（もしくは順応）すべきコンセプトを明確に規定するためのメカニズムがない。 よく利用されているのは、必要とされるコンセプトのヒントとなるようにテンプレート・パラメータを命名し、付属文書においてコンセプトの要求事項を記述する方式である。 残念ながら、こういった要求事項の記述は、往々にして曖昧であったり不正確であったり、まったく存在しないこともある。 あるテンプレートが想定している引数の性質を、そのテンプレートのユーザーが正確に理解できなければ、それは由々しき問題となる。 さらに、以下の問題が起こりうる：

- 不正なテンプレート引数に起因するコンパイラ・エラー・メッセージは、難解になることが多い。 大抵の場合、エラーの示す位置はテンプレートが使用された所ではなく、ユーザーが目にする必要のないテンプレートの実装内である。
- 記述された要求事項が、テンプレートのコンセプトを完全に表現し切れていない場合、使用されたテンプレート引数が記述された要求事項を満足していたとしても、コンパイラ・エラーを受ける可能性がある。
- 記述された要求事項が、テンプレートが実際に必要とするよりも厳格である場合がある。
- 要求事項は、コードの中で明示的に記述されることは無い。 そのために、コードの理解がより困難になる。 さらに、コードと記述された要求事項が同期していない事態も生じる可能性がある。

Boost コンセプト・チェック・ライブラリは、次のような手段を提供する：

- テンプレート・パラメータのコンパイル時チェックを導入するためのメカニズム。
- コンセプト・チェック用クラスによって、要求事項を明確化するためのフレームワーク。
- コンセプトの要求事項が、該当テンプレートをカバーしていることを確認するためのメカニズム。
- C++ 標準ライブラリのコンセプト要求事項に対応する、コンセプト・チェック用クラスおよび原型クラス一式。

このメカニズムは C++ 標準の機能のみを使用し、実行時オーバーヘッドを課さない。 メカニズムを導入するコストは、コンパイル時間の増大のみである。

クラス・テンプレートや関数テンプレートを記述するプログラマは、全員が通常のコード作成作業の一環としてコンセプト・チェックを含めるべきである。 コンセプト・チェックは、コンポーネントへのインターフェイスとして公開されている、すべてのテンプレート・パラメータに対して導入すべきである。 利用したいコンセプトが標準ライブラリーで用いられているものであれば、BCCL の該当するコンセプト・チェック用クラスを、そのまま使用すればよい。 そうでなければ、新たにコンセプト・チェック用クラスを記述することになるが、普通は数行程度に収まるはずだ。 新しいコンセプトを用いるならば、対応する原型クラスも作成すべきである。原型クラスとはコンセプトを表す最小限のスケルトン実装である。

この文書を、以下の通り構成する。

1. [Introduction](#introduction)
2. [Motivating Example](#motivating-example)
3. [History](#history)
4. [Publications](#publications)
5. [Acknowledgements](#acknowledgements)
6. Using Concept Checks
7. Creating Concept Checking Classes
8. Concept Covering and Archetypes
9. Programming With Concepts
10. Implementation
11. Reference

[Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm) はこのライブラリを寄稿した。 [Beman Dawes](http://www.boost.org/doc/libs/1_31_0/people/beman_dawes.html) が公式レビューを管理した。


## <a name="introduction" href="introduction">Introduction</a>
コンセプト "concept" とは、ジェネリック・アルゴリズムに対する引数として与えられる型が、アルゴリズム内部で正しく使用されるために満足しなければならない要求事項(有効な式、関連型、セマンティクス不変、計算量保証など)の組み合わせである。 C++ では、コンセプトは関数テンプレート(ジェネリック・アルゴリズム)のテンプレート・パラメータとして表現される。 しかしながら、C++ にはコンセプトを表現するための明示的なメカニズムがない。テンプレート・パラメータはただのプレースホルダでしかないのだ。 慣例として、こういったパラメータには、必要とされるコンセプトに対応する名前を与える。しかし、テンプレート・パラメータを実際の型で確定するときに、C++ コンパイラはコンセプトへの遵守を強要しない。

当然ながら、ジェネリック・アルゴリズムを、そのコンセプトの内、構文に関わる要求事項を満足していない型で呼び出した場合、コンパイル・エラーが生じる。 しかし、このエラーは、該当する型がコンセプトの要求事項すべてに適合していない事実を本質的に 反映したものではない。 それどころか、エラーはインスタンス化階層の深部で発生し、該当する型に対して式が有効でないか、想定された関連型が利用可能でないといったことが原因として挙げられることになるだろう。 こうして生じたエラーメッセージは、大抵において情報に乏しく、基本的に不可解である。

必要とされるものは、インスタンス化位置(かその近傍)で「コンセプトセーフ」を強要するためのメカニズムである。 Boost コンセプト・チェック・ライブラリーは、早い段階でコンセプトの遵守を強要し、遵守していない場合のエラー・メッセージをより有用にするために C++ 標準の機能を使用する。

注意すべき点は、この技術がコンセプトの要求事項のうち構文に関わる部分(有効な式および関連型)のみを扱うことである。 我々は、コンセプトの要求事項の一部であるセマンティクス不変あるいは計算量保証を扱わない。


## <a name="motivating-example" href="motivating-example">Motivating Example</a>
テンプレート・ライブラリの不正な使用法と、その結果生じるエラーメッセージを例証するために単純なサンプルを示す。 下記のコードでは、標準テンプレート・ライブラリー (STL) のジェネリックな `std::stable_sort()` アルゴリズム [[3](./bibiography.md#generic-programming-and-the-stl)、[4](./bibliography.md#stl-tutorial-and-reference-guide)、[5](./bibliography.md#the-standard-template-library)] をリンクリストに適用している。

bad_error_eg.cpp:
```
#include <list>
#include <algorithm>
   
int main(int, char*[]) {
    std::list<int> v;
    std::stable_sort(v.begin(), v.end());
    return 0;
}
```

この場合、`std::stable_sort()` アルゴリズムは以下のようなプロトタイプを有する：

```cpp
template <class RandomAccessIterator>
void stable_sort(RandomAccessIterator first, RandomAccessIterator last);
```

Gnu C++ でこのコードをコンパイルすると、以下のコンパイラ・エラーを生成する。他のコンパイラ出力は Appendix にリストしてある(訳注 : このバージョンのドキュメントには記載されていない)。

```
stl_algo.h: In function `void __merge_sort_loop<_List_iterator
  <int,int &,int *>, int *, int>(_List_iterator<int,int &,int *>,
  _List_iterator<int,int &,int *>, int *, int)':
stl_algo.h:1448:   instantiated from `__merge_sort_with_buffer
  <_List_iterator<int,int &,int *>, int *, int>(
   _List_iterator<int,int &,int *>, _List_iterator<int,int &,int *>,
   int *, int *)'
stl_algo.h:1485:   instantiated from `__stable_sort_adaptive<
  _List_iterator<int,int &,int *>, int *, int>(_List_iterator
  <int,int &,int *>, _List_iterator<int,int &,int *>, int *, int)'
stl_algo.h:1524:   instantiated from here
stl_algo.h:1377: no match for `_List_iterator<int,int &,int *> & -
  _List_iterator<int,int &,int *> &'
```

この場合、根本的なエラーの原因は、`std:list::iterator` が [`RandomAccessIterator`](http://www.sgi.com/tech/stl/RandomAccessIterator.html) コンセプトをモデル化していないことにある。 リストのイテレータは双方向でしかなく、(ベクタのイテレータのように) 完全なランダム・アクセスが可能なわけではない。 残念ながら、このエラーメッセージには、ユーザーにこの事実を示すものは何もない。

C++ プログラマがテンプレート・ライブラリに十分な経験を持っていれば、この手のエラーに惑うことは無いかもしれない。 しかし未熟な者にとっては、次のような理由で、このメッセージが理解し難いものとなっている。

1. エラーが生じる位置、bad_error_eg.cpp の６行目は、Gnu C++ がインスタンス化スタックを４レベルも深くまで探索して表示するという事実にもかかわらず、エラーメッセージで示されていない。
2. エラーメッセージと、`std::stable_sort()` および [`RandomAccessIterator`](http://www.sgi.com/tech/stl/RandomAccessIterator.html) に関する文書化された要求事項との間に、文面上の相関がない。
3. エラーメッセージが過度に長く、ユーザーの知らない(かつ知るべきでない！) STL 内部実装用の関数がリストされている。
4. エラーメッセージに、ライブラリ内部の実装用関数が数多くリストアップされているため、プログラマが、エラーの原因は自分のコードではなくライブラリ側にあるとの結論に、誤って飛びついてしまう可能性がある。

次の例示は、より有用なメッセージとして斯くあるべきと我々が考えるものだ (また実際に Boost コンセプト・チェック・ライブラリが生成するものでもある)。

```
boost/concept_check.hpp: In method `void LessThanComparableConcept
  <_List_iterator<int,int &,int *> >::constraints()':
boost/concept_check.hpp:334:   instantiated from `RandomAccessIteratorConcept
  <_List_iterator<int,int &,int *> >::constraints()'
bad_error_eg.cpp:6:   instantiated from `stable_sort<_List_iterator
  <int,int &,int *> >(_List_iterator<int,int &,int *>, 
  _List_iterator<int,int &,int *>)'
boost/concept_check.hpp:209: no match for `_List_iterator<int,int &,int *> &
  < _List_iterator<int,int &,int *> &'
```

このメッセージは、標準的なエラー・メッセージがもつ欠点をいくつかの点で改善する。

- エラーの生じた位置 (bad_error_eg.cpp:6）がエラーメッセージに明示されている。
- メッセージは、STL 文書に記述されているコンセプト ([RandomAccessIterator](http://www.sgi.com/tech/stl/RandomAccessIterator.html)) を明示的に言及している。
- エラーメッセージははるかに短くなり、STL の内部実装用関数を露呈しない。
- エラーメッセージの中に concept_check.hpp および `constraints()` が示されることで、ライブラリ実装の中にではなくユーザーのコードにエラーがあるという事実をユーザーに警告している。


## <a name="history" href="history">History</a>
このコンセプト・チェック・システムの初期バージョンは、著者が SGI において、C++ コンパイラおよびライブラリ・グループの一員として勤務している間に開発された。 初期バージョンは今も SGI STL ディストリビューションの一部である。 Boost コンセプト・チェック・ライブラリは、エラーメッセージにおけるそれほど有用でない表現能力を犠牲にして、コンセプト・チェック用クラス定義を非常に単純化しており、その点で SGI STLのコンセプト・チェックとは異なっている。


## <a name="publications" href="publications">Publications</a>

- [C++ テンプレート・ワークショップ2000](http://www.oonumerics.org/tmpw00/)、コンセプト・チェック。


## <a name="acknowledgements" href="acknowledgements">Acknowledgements</a>
インスタンス化を引き起こすために関数ポインタを使用するアイディアは、Alexander Stepanov に拠る。 テンプレートの事前チェックに式を使用するアイディアに関して、その起源を確認できなかった。しかし、それは D&E[[2](./bibliography.md#design-and-evolution)] に記載されている。 STL コンセプトに関する優れた文書化と構造化を行った Matt Austern に感謝をささげる。このコンセプト・チェックは彼の仕事を基礎にしている。 有益なコメントとレビューを賜った Boost のメンバにも感謝を。


次へ： [Using Concept Checks](./using_concept_check.md)

***
Copyright © 2000 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm)(<jsiek@osl.iu.edu>) Andrew Lumsdaine(<lums@osl.iu.edu>)

