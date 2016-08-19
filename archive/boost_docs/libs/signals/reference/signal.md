#Boost.Signals: ヘッダ &lt;boost/signal.hpp&gt;

##ヘッダ

```cpp
#include <boost/signal.hpp>
```
* boost/signal.hpp[link http://www.boost.org/doc/libs/1_31_0/boost/signal.hpp]

##概要

`signal` クラステンプレートの仕様では、二つの正整数 `BOOST_SIGNALS_MAX_ARGS` と `N` が使われている。
前者はスロットに受け渡すことが出来る関数のパラメタ最大数を、後者は所与の実体化されたシグナルに対する関数のパラメタ数を記述する。
`BOOST_SIGNALS_MAX_ARGS` は、実装によってサポートされる実引数の最大値を定義するプリプロセッサのマクロとして、ヘッダ中に存在している。

```cpp
namespace boost {
	template<typename Signature, // Function type R (T1, T2, ..., TN)
		typename Combiner = last_value<typename function_traits<Signature>::result_type>,
		typename Group = int,
		typename GroupCompare = std::less<int>,
		typename SlotFunction = function<Signature>
	>
	class signal : public signalN<R, T1, T2, ..., TN, Combiner, Group, GroupCompare, SlotFunction>
	{
		explicit signal(const Combiner& = Combiner(), const GroupCompare& = GroupCompare());
	};
}
```
* last_value[link last_value.md]
* function[link ../../function.md]
* signal[link signalN.md]
* signal[link #constructor]

###コンストラクタ

<a name="#constructor">`explicit signal(const Combiner& combiner = Combiner(), const GroupCompare& group_compare = GroupCompare());`</a>

- **作用**: `combiner` と `group_compare` で基底クラスを初期化する。

[Doug Gregor](http://www.cs.rpi.edu/~gregod)

Last modified: Fri Oct 11 05:42:29 EDT 2002

