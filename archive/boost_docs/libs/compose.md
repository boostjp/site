#非推奨： Compose library

- 翻訳元ドキュメント： <http://www.boost.org/doc/libs/1_31_0/libs/compatibility/>


<span style="color:red;">このライブラリは、BindやLambdaといったライブラリからの支持によって廃止され、将来のBoostのリリースからは削除されるだろう。</span>

compose.hpp ヘッダは合成関数オブジェクト・アダプタを拡張するものであり、標準C++ライブラリの一部であるStandard Template Library(STL)と共に利用できる。あなたがSTLを使っていないなら本ライブラリが提供する合成関数アダプタに興味を示さないだろうが、STLを使いこなしているのならこれらアダプタの有効性が理解できるだろう。

- [ドキュメント](compose/compose.md)
- ヘッダ [compose.hpp](compose/compose.hpp.md)
- サンプルへのリンクは [ドキュメント](compose/compose.md) を参照のこと
- サンプルで利用されているヘッダ [print.hpp](compose/print.hpp.md)
- 本ライブラリは [Nicolai Josuttis](http://www.boost.org/doc/libs/1_31_0/people/people.htm) により提出された


##Comment on names
本ライブラリの作成にあたり、Nicoは関数群に良い名前を与えることをboostメーリングリンストに提案した。それに対してJerry Schwarz による compose_f_... という命名規則案が、これまでの命名規則に合致していることから承認されることとなった。 また、引数のないことを示す名前としてnullary が選ばれた。

Revise 14 March, 2001


