#ColorValue
このコンセプトは色付けを必要とする型として記述されており、グラフ中を探査する時に頂点が訪問済か色でマークするために利用される。


##Refinement of
[EqualityComparable](http://www.sgi.com/tech/stl/EqualityComparable.html) and [DefaultConstructible](http://www.sgi.com/tech/stl/DefaultConstructible.html)


##表記

| 識別子 | 説明 |
|--------|------|
| `T`    | ColorValue モデルの型 |
| `cv`   | 型 `T` のオブジェクト |


##有効な表現式

| 名前 | 式 | 戻り型 | 説明 |
|------|----|--------|------|
| Get Color White | `color_traits<T>::white()` | `T` | 白色を表すオブジェクトを返す。 |
| Get Color Gray  | `color_traits<T>::gray()`  | `T` | 灰色を表すオブジェクトを返す。 |
| Get Color Black | `color_traits<T>::black()` | `T` | 黒色を表すオブジェクトを返す。 |


##モデル
`default_color_type` (boost/graph/properties.hpp の中に記述)


***
Copyright © 2000-2001

- [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<jsiek@osl.iu.edu>)
- [Lie-Quan Lee](http://www.boost.org/doc/libs/1_31_0/people/liequan_lee.htm), Indiana University (<llee@cs.indiana.edu>)
- [Andrew Lumsdaine](http://www.osl.iu.edu/~lums), Indiana University (<lums@osl.iu.edu>)

Japanese Translation Copyright © 2003 [OKI Miyuki](oki_miyuki@cppll.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

