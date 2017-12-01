# Singleton Pool の実装

## 依存性

Boostヘッダー `pool.hpp` ([pool](pool.md)を見よ)、`detail/singleton.hpp` ([singleton](singleton.md)を見よ)、`detail/mutex.hpp` ([mutex](mutex.md)を見よ)、`detail/guard.hpp` ([guard](guard.md)を見よ)をインクルードしている。

## 梗概

```cpp
template <typename Tag,
	unsigned RequestedSize,
	typename UserAllocator = default_user_allocator_new_delete,
	typename Mutex = details::pool::default_mutex,
	unsigned NextSize = 32>
class singleton_pool
{
... // 公開インタフェース

public: // 公開インタフェースの拡張
	typedef Mutex mutex;
	static const unsigned next_size = NextSize;
};
```

## 公開インタフェースの拡張

### 追加テンプレートパラメータ

#### `Mutex`

このクラスは[mutex](mutex.md)型のもので基底であるPoolへの同時アクセスを保護するために使用する。
これは開示されているので、ユーザーはシングルトンプールを通常の様(つまり同期して)に記述することもできるし、効率のために、シングルトンプールを(`details::pool::null_mutex` を指定して)同期制御無しにすることもできる。

#### `NextSize`

基底となる Pool が生成されるとき、このパラメーターの値が渡される。
より詳しい情報は [pool](pool.md) の公開インタフェースの拡張を見よ。

### 追加メンバー

typedef である `mutex` と静的定数値 `next_size` はテンプレートパラメータの値 `Mutex` と `NextSize` をそれぞれにクラス外に見せる。

## 将来の方向性

Boost multithreading library が完成すれば、`Mutex` パラメーターは同等の柔軟性を提供する、そのライブラリーの何かで置き換えられ、実装の詳細からインタフェース仕様へ移動されることになるだろう。

## [インタフェースの説明](../interfaces/singleton_pool.md)

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright](../copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

