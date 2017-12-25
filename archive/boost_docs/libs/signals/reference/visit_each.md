# 関数テンプレート `visit_each`

## ヘッダ

```cpp
#include <boost/visit_each.hpp>
```
* boost/visit_each.hpp[link http://www.boost.org/doc/libs/1_31_0/boost/visit_each.hpp]

## 概要

`visit_each` の機構は、`visitor` を与えられたオブジェクトの全部分オブジェクトに対して適用することを可能にする。
これは Signals ライブラリによって関数オブジェクト中の `trackable` オブジェクトを見つけ出すために使われているが、広く使われれば他の用途も出てくるだろう (例: 保守的ガベージコレクション)。
`visit_each` フレームワークに適合させるため、各オブジェクト型に対して `visit_each` のオーバーロードを提供する必要がある。

```cpp
namespace boost {
	template<typename Visitor, typename T>
	void visit_each(Visitor&, const T&, int);
}
```
* visit_each[link #visit_each]

## 関数

<a id="visit_each">`template<typename Visitor, typename T> void visit_each(Visitor& v, const T& t, int);`</a>

- **作用**: `v(t)`。
	また `t` のすべての部分オブジェクト `x` に対して
	- `x` が参照であれば `v(boost::ref(x))` を実行。
	- `x` が参照でなければ `v(x)` を実行。

- **戻り値**: なし。
- **注記**: `<boost/visit_each.hpp>` 中で定義されている `visit_each` の非特殊化版の第三パラメタは `long` であり、この第三パラメタに与える実引数は常に 0 でなければならない。
	第三パラメタは、正しい関数テンプレートの部分整列の欠落が広まっているために設けられた人為的なものであり、将来削除されるだろう。
	ライブラリ作者は、クラスの `T` 実引数を特殊化する追加のオーバーロードを加え、部分オブジェクトを訪ねられるようにすることが期待されている。

[Doug Gregor](http://www.cs.rpi.edu/~gregod)

Last modified: Fri Oct 11 05:43:33 EDT 2002

