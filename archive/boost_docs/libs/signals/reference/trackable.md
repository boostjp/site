# Boost.Signals: クラス `trackable`

## ヘッダ

```cpp
#include <boost/signals/trackable.hpp>
```
* boost/signals/trackable.hpp[link http://www.boost.org/doc/libs/1_31_0/boost/signals/trackable.hpp]

## 概要

`trackable` クラスは、スロットの一部として結合されたオブジェクトが破棄されたときに、シグナルとスロットを自動的に切断するよう管理する責任を負う。
`trackable` クラスは他のクラスの基底クラスとしてのみ用いることが可能である; そのとき、派生クラスはスロットの一部として用いられる関数オブジェクトに結合される。
`trackable` オブジェクトがシグナル・スロット接続を追跡する方法は、実装定義である。

```cpp
namespace boost {
	namespace signals {
		class trackable {
		protected:
			trackable();
			trackable(const trackable&);
			~trackable();

			trackable& operator=(const trackable&);
		};
	}
}
```
* trackable()[link #default_constructor]
* trackable[link #copy_constructor]
* ~trackable()[link #destructor]
* operator=[link #copy_assignment]

## メンバ

### コンストラクタ

<a id="default_constructor">`trackable();`</a>

- **作用**: 接続済みスロットのリストを空にする。
- **例外**: なし。

<a id="copy_constructor">`trackable(const trackable&);`</a>

- **作用**: 接続済みスロットのリストを空にする。
- **例外**: なし。
- **論拠**: シグナル・スロット接続は明示的な connect メソッド呼び出しを介してのみ作成される。
	したがって `trackable` オブジェクトがコピーされるここでは、作成できない。

### デストラクタ

<a id="destructor">`~trackable();`</a>

- **作用**: すべての接続済みスロットを切断する。

### 代入

<a id="copy_assignment">`trackable& operator=(const trackable& other);`</a>

- **作用**: すべての接続済みスロットを切断する。
- **戻り値**: `*this`
- **論拠**: シグナル・スロット接続は明示的な `connect` メソッド呼び出しを介してのみ作成される。
	したがって `trackable` オブジェクトがコピーされるここでは、作成できない。

[Doug Gregor](http://www.cs.rpi.edu/~gregod)

Last modified: Fri Oct 11 05:43:22 EDT 2002

