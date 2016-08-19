#Boost.Signals: クラステンプレート slot

##ヘッダ

```cpp
#include <boost/signals/slot.hpp>
```
* boost/signals/slot.hpp[link http://www.boost.org/doc/libs/1_31_0/boost/boost/signals/slot.hpp]

##概要

`slot` クラステンプレートはスロットを作成し、非テンプレート関数への実引数として渡すことを可能にする。
これは [`CopyConstructible`](http://www.sgi.com/tech/stl/CopyConstructible.html) であるが [`DefaultConstructible`](http://www.sgi.com/tech/stl/DefaultConstructible.html) ならびに [`Assignable`](http://www.sgi.com/tech/stl/Assignable.html) ではない。

```cpp
namespace boost {
	template<typename SlotFunction>
	class slot {
	public:
		template<typename Slot>
		slot(const Slot&);

	private:
		SlotFunction stored_slot_function; // 開示用
};
}
```
* SlotFunction[link signalN.md#slot_function_type]
* slot[link #constructor]

###コンストラクタ

<a name="constructor">`template<typename Slot> slot(const Slot& slot);`</a>

- **作用**: `this` が、渡された `slot` を保持するように初期化する。
	渡される `slot` は、それによって [`SlotFunction`](signalN.md#slot_function_type) を構築可能な任意の関数オブジェクトである。

[Doug Gregor](http://www.cs.rpi.edu/~gregod)

Last modified: Fri Oct 11 05:43:10 EDT 2002

