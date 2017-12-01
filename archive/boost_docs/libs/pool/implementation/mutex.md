# mutex - Mutex

## はじめに

`detail/mutex.hpp` は OS 提供の mutex 型に対する首尾一貫したインターフェースを提供するいくつかの mutex 型を提供する。
それらはすべて thread-level mutex であり、プロセス間 mutex はサポートされていない。

## Configuration

このヘッダファイルは、それがどのような種類のシステムに存在しているかを考えようとする。
Win32 もしくは POSIX + pthread システムについては自身を自動コンフィグする。
すべての mutex code をもみ消すため、自動コンフィグレーションをバイパスし、このヘッダをインクルードするより前に `#define BOOST_NO_MT` しなくてはならない。
単一定義規則(ODR)違反を防ぐため、これはライブラリファイルも含めてあなたのプロジェクトの **すべての** 翻訳単位で定義されていなくてはならない。

## 梗概

```cpp
namespace details {
namespace pool {

// Win32 システムでのみ存在する
class Win32_mutex
{
private:
	Win32_mutex(const Win32_mutex &);
	void operator=(const Win32_mutex &);

public:
	Win32_mutex();
	~Win32_mutex();

	void lock();
	void unlock();
};

// POSIX+pthread システムでのみ存在する
class pthread_mutex
{
private:
	pthread_mutex(const pthread_mutex &);
	void operator=(const pthread_mutex &);

public:
	pthread_mutex();
	~pthread_mutex();

	void lock();
	void unlock();
};

// すべてのシステムに存在する
class null_mutex
{
private:
	null_mutex(const null_mutex &);
	void operator=(const null_mutex &);

public:
	null_mutex();
	~null_mutex();

	static void lock();
	static void unlock();
};

// 上記の型のひとつ
typedef ... default_mutex;

} // namespace pool
} // namespace details
```

## 意味

**Symbol Table**

| Symbol | Meaning |
|---|---|
| `Mutex` | このヘッダで定義されている任意の型 |
| `t` | value of type `Mutex` |

**`mutex` が満たすべき要求**

| Expression | Return Type | Assertion/Note/Pre/Post-Condition |
|---|---|---|
| `m.lock()` | not used | mutexをロックする |
| `m.unlock()` | not used | mutexをアンロックする |

すべての mutex は owned または unowned のいずれかである。
owned の場合、特定のスレッドに所有されている。
mutex を"ロック"するとは、その mutex が unowned になるまで待ち、カレントスレッドによって owned された状態にすることを意味する。
mutex を"アンロック"するとは、カレントスレッドによる所有を放棄すること意味する(カレントスレッドは所有を放棄する mutex を所有していなくては**ならない**ことに注意)。
特別な場合として `null_mutex` は待たれることがない。

## 依存性

システムヘッダー `<windows.h>`、`<unistd.h>`、および/または `<pthread.h>` をインクルードすることがある。

## 将来の方向性

このヘッダーはいつかは Boost multithreading library で置き換えられるであろう。

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright](../copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

