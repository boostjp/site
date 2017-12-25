# Boost.Signals: クラステンプレート `last_value`

## ヘッダ

```cpp
#include <boost/last_value.hpp>
```
* boost/last_value.hpp[link http://www.boost.org/doc/libs/1_31_0/boost/last_value.hpp]

## 概要

```cpp
namespace boost {
	template<typename T>
	class last_value {
	public:
		typedef T result_type;

		template<typename InputIterator>
		result_type operator()(InputIterator, InputIterator) const;
	};

	template<>
	class last_value<void> {
	public:
		typedef implementation-defined result_type; // void は禁止

		template<typename InputIterator>
		result_type operator()(InputIterator, InputIterator) const;
	};
}
```
* operator()[link #call]
* operator()[link #void_call]

## メンバ

<a id="call">`template<typename InputIterator> result_type operator()(InputIterator first, InputIterator last) const;`</a>

- **事前条件**: `first != last`.
- **作用**: シーケンス `[first, last)` 中のすべてのイテレータを参照外しする。
- **戻り値**: 最後のイテレータを参照外しした結果。


<a id="void_call">`template<typename InputIterator> result_type operator()(InputIterator first, InputIterator last) const;`</a>

- **作用**: シーケンス `[first, last)` 中のすべてのイテレータを参照外しする。
- **戻り値**: 値は無意味だが `void` ではない。
- **論拠**: `void` を戻す関数は、しばしば関数オブジェクトを構成するシステムに多くの回避手段を要求する。
	そこで `void` を戻すことを避け、代わりに関数オブジェクトを容易に適合させうる、実装依存の無意味な値を戻すことに決定した。

[Doug Gregor](http://www.cs.rpi.edu/~gregod)

Last modified: Fri Oct 11 05:42:17 EDT 2002

