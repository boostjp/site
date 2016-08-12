#Boost.Signals: ヘッダ &lt;[boost/signals/connection.hpp](http://www.boost.org/doc/libs/1_31_0/boost/signals/connection.hpp)&gt;

##&lt;[boost/signals/connection.hpp](http://www.boost.org/doc/libs/1_31_0/boost/boost/signals/connection.hpp)&gt; ヘッダ概要

```cpp
namespace boost {
	namespace signals {
	class connection;
	class scoped_connection;

	void swap(connection&, connection&);
	void swap(scoped_connection&, scoped_connection&);
	}
}
```
* connection[link #connection_class]
* scoped_connection[link #scoped_connection_class]
* swap[link #swap_free]
* swap[link #scoped_swap_free]

##<a name="connection_class">`connection` クラス概要</a>

`connection` クラスは [Signal](signal.md) と [Slot](slot.md) の間の接続を表す。
これはシグナルとスロットが現在接続されているかを問い合わせ、またシグナルとスロットを切断する能力を有する軽量オブジェクトである。
問い合わせと `connection` の切断を行うことは、常に安全である。

```cpp
namespace boost {
	namespace signals {
		class connection : // connection クラスは LessThanComparable かつ EqualityComparableである
		private less_than_comparable1<connection>, // 開示用
		private equality_comparable1<connection> // 開示用
		{
		public:
			connection();
			connection(const connection&);
			~connection();

			void disconnect() const;
			bool connected() const;

			connection& operator=(const connection&);
			void swap(connection&);

			bool operator==(const connection& other) const;
			bool operator<(const connection& other) const;
		};
	}
}
```
* LessThanComparable[link http://www.sgi.com/tech/stl/LessThanComparable.html]
* EqualityComparable[link http://www.sgi.com/tech/stl/EqualityComparable.html]
* connection[link #default_constructor]
* connection[link #copy_constructor]
* ~connection[link #destructor]
* disconnect[link #disconnect]
* connected[link #connected]
* operator=[link #copy_assignment]
* swap[link #swap_member]
* operator==[link #equality]
* operator<[link #less_than]

##`connection` クラスメンバ

###コンストラクタ

<a name="default_constructor">`connection();`</a>

- **作用**: 現在の接続を NULL 接続に設定する。
- **事後条件**: `!this->connected()`
- **例外**: なし。

<a name="copy_constructor">`connection(const connection& other);`</a>

- **作用**: `other` によって参照されていた接続を `this` が参照する。
- **例外**: なし。

###デストラクタ

<a name="destructor">`~connection();`</a>

- **作用**: なし。

###接続管理

<a name="disconnect">`void disconnect() const;`</a>

- **作用**: `this->is_connected()` が真であれば `this` によって参照されているシグナルとスロットの接続を切断する; そうでなければ何もしない。
- **事後条件**: `!this->is_connected()`

<a name="connected">`bool connected() const;`</a>

- **戻り値**: `this` がアクティブな (接続されている) 非 NULL 接続を参照していれば `true`、そうでなければ `false`。
- **例外**: なし。

###代入と交換
<a name="copy_assignment">`connection& operator=(const connection& other);`</a>

- **作用**: `connection(other).swap(*this);`
- **戻り値**: `*this`

<a name="swap_member">`void swap(connection& other);`</a>

- **作用**: `this` と `other` が参照している接続を交換する。
- **例外**: なし。

###比較

<a name="equality">`bool operator==(const connection& other) const;`</a>

- **戻り値**: `this` と `other` が同一の接続を参照しているか、両方とも NULL 接続を参照している場合 `true`、そうでなければ `false`。
- **例外**: なし。

<a name="less_than">`bool operator<(const connection& other) const;`</a>

- **戻り値**: 実装定義の順序づけによって、`this` によって参照されている接続が `other` によって参照されている接続に先行する場合 `true`、そうでなければ `false`。
- **例外**: なし。

##<a name="scoped_connection_class">`scoped_connection` クラス概要</a>

`scoped_connection` クラスは、そのインスタンスが破棄されるときに自動的に切断される接続である。

```cpp
namespace boost {
	namespace signals {
		class scoped_connection : public connection
		{
		public:
			scoped_connection();
			scoped_connection(const scoped_connection&);
			scoped_connection(const connection&);
			~scoped_connection();

			connection& operator=(const scoped_connection&);
			connection& operator=(const connection&);
			void swap(connection&);
		};
	}
}
```
* scoped_connection[link #scoped_default_constructor]
* scoped_connection[link #scoped_copy_constructor]
* scoped_connection[link #scoped_copy_connection_constructor]
* ~scoped_connection[link #scoped_destructor]
* operator=[link #scoped_copy_assignment]
* operator=[link #scoped_copy_connection_assignment]
* swap[link #scoped_swap_member]

##`scoped_connection` クラスメンバ

###コンストラクタ

<a name="scoped_default_constructor">`scoped_connection();`</a>

- **作用**: 現在の接続を NULL 接続に設定する。
- **事後条件**: `!this->connected()`
- **例外**: なし。

<a name="scoped_copy_constructor">`scoped_connection(const scoped_connection& other);`</a>

- **作用**: `other` によって参照されていた接続を `this` が参照する。
- **例外**: なし。

<a name="scoped_copy_connection_constructor">`scoped_connection(const connection& other);`</a>

- **作用**: `other` によって参照されていた接続を `this` が参照する。
- **例外**: なし。

###デストラクタ

<a name="destructor">`~connection();`</a>

- **作用**: `this->disconnect()`

###代入と交換
<a name="scoped_copy_assignment">`scoped_connection& operator=(const scoped_connection& other);`</a>

- **作用**: `scoped_connection(other).swap(*this);`
- **戻り値**: `*this`

<a name="scoped_copy_connection_assignment">`scoped_connection& operator=(const connection& other);`</a>

- **作用**: `scoped_connection(other).swap(*this);`
- **戻り値**: `*this`

<a name="scoped_swap_member">`void swap(scoped_connection& other);`</a>

- **作用**: `this` と `other` が参照する接続を交換する。
- **例外**: なし。

##フリー関数

<a name="swap_free">`void swap(connection& c1, connection& c2);`</a>

- **作用**: `c1.swap(c2)`
- **例外**: なし。

<a name="scoped_swap_free">`void swap(scoped_connection& c1, scoped_connection& c2);`</a>

- **作用**: `c1.swap(c2)`
- **例外**: なし。

[Doug Gregor](http://www.cs.rpi.edu/~gregod)

Last modified: Fri Oct 11 05:42:05 EDT 2002

