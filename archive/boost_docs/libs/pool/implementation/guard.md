# guard - Auto-lock/unlock-er

## はじめに

`detail/guard.hpp` は `Mutex` のロックとアンロック操作にスコープ付きのアクセスを許すようにした `guard<Mutex>` を提供する。
それは、例外が投げられたときでも、`Mutex` を確実にアンロックする。

## 梗概

```cpp
namespace details {
namespace pool {

template <typename Mutex>
class guard
{
private:
	guard(const guard &);
	void operator=(const guard &);

public:
	explicit guard(Mutex & mtx);
	~guard();
};

} // namespace pool
} // namespace details
```

## 意味

**Symbol Table**

| Symbol | Meaning |
|---|---|
| `T` | `guard<Mutex>` |
| `m` | value of type `Mutex &` |
| `g` | value of type `guard<Mutex>` |

**Requirements on `Mutex`**

| Expression | Return Type | Assertion/Note/Pre/Post-Condition |
|---|---|---|
| `m.lock()` | not used | `m` で参照される mutex をロックする。 |
| `m.unlock()` | not used | `m` で参照される mutex をアンロックする。 |

**Requirements satisfied by `guard`**

| 式 | アサーション/注意事項/事前/事後条件 |
|---|---|
| `T(m)` | `m` で参照される mutex をロックする。`T(m)` を `m` に束縛する。 |
| `(&g)->~T()` | `g` が束縛されている mutex をアンロックする。 |

## 例

(プラットフォーム依存の) `mutex` があり、以下のようにそれをコードで包むことができる。

```cpp
extern mutex global_lock;

static void f()
{
	boost::details::pool::guard<mutex> g(global_lock);
	// g のコンストラクタは "global_lock" をロックする

... // 何をしてもよい:
	// 例外を投げるもよし
	// return するもよし
	// そのまま抜けてもよし

} // g のデストラクタが "global_lock"をアンロックする
```

## 依存性

なし。

## 将来の方向性

このヘッダーはいつかは Boost multithreading library で置き換えられるであろう。

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright]("../copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

