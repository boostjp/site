# pool_alloc - Boost Pool Standard Allocators Implementation

## 依存性

システムヘッダ`<new>` と `<limits>`をインクルードしている。

Boostヘッダ`"singleton_pool.hpp"` ([singleton_pool](singleton_pool.md)を見よ) および `"detail/mutex.hpp"` ([mutex](mutex.md)を見よ)をインクルードしている。

## 梗概

```cpp
template <typename T,
	typename UserAllocator = default_user_allocator_new_delete,
	typename Mutex = details::pool::default_mutex,
	unsigned NextSize = 32>
class pool_allocator
{
public:
... // 公開インタフェース

public: // extensions to public interface
	typedef Mutex mutex;
	static const unsigned next_size = NextSize;

	template <typename U>
	struct rebind
	{
		typedef pool_allocator<U, UserAllocator, Mutex, NextSize> other;
	};
};

template <typename T,
	typename UserAllocator = default_user_allocator_new_delete,
	typename Mutex = details::pool::default_mutex,
	unsigned NextSize = 32>
class fast_pool_allocator
{
public:
... // 公開インタフェース

public: // extensions to public interface
	typedef Mutex mutex;
	static const unsigned next_size = NextSize;

	template <typename U>
	struct rebind
	{
		typedef fast_pool_allocator<U, UserAllocator, Mutex, NextSize> other;
	};
};
```

## 公開インタフェースの拡張

### Additional template parameters

#### `Mutex`

このパラメーターで、ユーザーに基底となるシングルトンプールで使用される同期の型を決定することができる。
より多くの情報は [singleton pool](singleton_pool.md) の公開インタフェースの拡張を見よ。

#### `NextSize`

このパラメーターの値は基底となる Pool が生成されるときに渡される。
より詳しい情報は [pool](pool.md) の公開インタフェースの拡張を見よ。

### `rebind` の修正

構造体 `rebind` が、追加のテンプレートパラメータの値を保護するために再定義されている。

### 追加メンバー

typedef である `mutex` と静的定数値 `next_size` はテンプレートパラメータの値 `Mutex` と `NextSize` をそれぞれクラス外へ見せる。

## 注意事項

多くのよく使われる STL ライブラリがアロケータの使い方でバグを含んでいる。
具体的に言うと、それらは `deallocate` 関数にヌルポインタを渡しており、それは標準[20.1.5 Table 32]ではっきりと禁止されている。

PoolAlloc は、それを発見すれば、これらのライブラリのバグ回避する。
現状でのバグ回避:

- Borland C++ (Builder and command-line compiler) with default (RogueWave) library, ver. 5 and earlier
- STLport (with any compiler), ver. 4.0 and earlier

## 将来の方向性

Boost multithreading library が完成すれば、`Mutex` パラメーターは同様の柔軟性を提供する、そのライブラリーの何かで置き換えられ、実装の詳細からインタフェース仕様へ移されることになるだろう。

## [Interface Description](../interfaces/pool_alloc.md)

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright](../copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

