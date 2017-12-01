# singleton - Singleton

## はじめに

`detail/singleton.hpp` はクラス型のシングルトンへのアクセスを提供する。
これは汎用のシングルトン解では**ない**。
それはデフォルトコンストラクタを持つクラス型に限定される。

## 梗概

```cpp
namespace details {
namespace pool {

template <typename T>
class singleton_default
{
private:
	singleton_default();

public:
	typedef T object_type;

	static object_type & instance();
};

} // namespace pool
} // namespace details
```

## 意味

**Symbol Table**

| Symbol | Meaning |
|---|---|
| `T` | 例外を投げないデフォルトコンストラクタと例外を投げないデストラクタを持つ任意のクラス |

**`singleton_default`が満たすべき要件**

| 式 | 戻り型 | アサーション/注意事項/事前/事後条件 |
|---|---|---|
| `singleton_default<T>::instance()` | `T &` | シングルトンインスタンスへの参照を返す |

## 保証

シングルトンインスタンスは `main()` 開始前に構築され、`main()` 終了後に破棄されることが保証される。
さらに、`singleton_default<T>::instance()` への最初の呼び出しが完了する前に(たとえそれが `main()` の呼び出し前であっても)構築されていることが保証される。
したがって `main()` の中以外では複数のスレッドが実行されておらず、シングルトンへのすべてのアクセスが mutexes によって制限されているならば、この保証によってスレッドセーフなシングルトンになる。

## 詳細

我々がどのように上記の保証を提供しているかの詳細は、ヘッダーファイルのコメントを見よ。

## 依存性

なし。

## 将来の方向性

Boost singleton library によって置き換えられるかもしれない。

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright](../copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

