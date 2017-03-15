# MultiPassInputIterator

- 翻訳元ドキュメント : <http://www.boost.org/doc/libs/1_31_0/libs/utility/MultiPassInputIterator.html>

このコンセプトは[Input Iterator](http://www.sgi.com/tech/stl/InputIterator.html)を精製し、範囲を複数のパスで通るようイテレータを使用してもよいという要件を追加しており、`it1 == it2`かつ`++it1 == ++it2`のとき、`it1`は間接参照可能である。このMulti-Pass Input Iteratorは、[Forward Iterator](http://www.sgi.com/tech/stl/ForwardIterator.hmtl)によく似ている。唯一の違いは、[Forward Iterator](http://www.sgi.com/tech/stl/ForwardIterator.hmtl)の`reference`型が`value_type&`であることを要求するのに対し、MultiPassInputIteratorは[Input Iterator](http://www.sgi.com/tech/stl/InputIterator.html)のように`reference`が`value_type`に変換できるということである。


## 設計ノート

Valentin Bonnardからのコメント：

```
私は、Multi-Pass Input Iteratorの導入は、正しい解決ではないと考える。これと同様に、Multi-Pass Bidirectional IteratorやMulti-Pass Random Access Iteratorを定義したいと思うだろうか？私は思わない、確実に。これは問題を混乱させるだけだ。この問題は、既存のイテレータ階層に含まれている移動性(movavility)と変更性(modifiability)と左辺値らしさを混ぜ合わせたものであり、これらは明確に独立している。

Forward、Bidirectional、Random Accessは移動性に関しての用語であり、それ以外の意味に使用すべきではない。イテレータが不変(immutable)か変更可能(mutable)かは、完全に直交する。左辺値のイテレータもまた、不変性(immutability)は直交する。これらのクリーンなコンセプトでは、Multi-Pass Input Iteratorは素直にForward Iteratorと呼べる。

他の変換は以下のようになる：

std::Forward Iterator -> ForwardIterator & Lvalue Iterator

std::Bidirectionnal Iterator -> Bidirectionnal Iterator & Lvalue Iterator

std::Random Access Iterator -> Random Access Iterator & Lvalue Iterator

私のForward Iteratorで許可しておらず、std::Forward Iteratorでは許可されている唯一の操作は「&*it」である。私は、「&*」はジェネリックコードではほとんど必要ないと考える。
```

Jeremy Siekからの返信：

Valentinの分析は正しい。もちろん、ここには後方互換性の問題がある。現在のSTLの実装は、古いForward Iteratorの定義に基いている。これに対するアクションの正しい道筋は、標準C++のForward Iteratorやその他の定義を変更することである。そうすれば、我々はMulti-Pass Input Iteratorをなくすことができる。


***
Copyright © 2000 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Univ.of Notre Dame (<mailto:jsiek@lsc.nd.edu>)

Japanese Translation Copyright © 2014 [Akira Takahashi](mailto:faithandbrave@gmail.com)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

