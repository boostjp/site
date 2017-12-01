# Singleton Pool

## はじめに


`singleton_pool.hpp` はテンプレートクラス `singleton_pool` を提供している。
そのクラスはシングルトンオブジェクトとしての `pool` へのアクセスを提供している。
他のpool-ベースのインターフェースについての情報は、[他の pool インタフェース](../interfaces.md)を見よ。

## 梗概

```cpp
template <typename Tag, unsigned RequestedSize,
    typename UserAllocator = default_user_allocator_new_delete>
struct singleton_pool
{
public:
	typedef Tag tag;
	typedef UserAllocator user_allocator;
	typedef typename pool<UserAllocator>::size_type size_type;
	typedef typename pool<UserAllocator>::difference_type difference_type;

	static const unsigned requested_size = RequestedSize;

private:
	static pool<size_type> p; // exposition only!

	singleton_pool();

public:
	static bool is_from(void * ptr);

	static void * malloc();
	static void * ordered_malloc();
	static void * ordered_malloc(size_type n);

	static void free(void * ptr);
	static void ordered_free(void * ptr);
	static void free(void * ptr, std::size_t n);
	static void ordered_free(void * ptr, size_type n);

	static bool release_memory();
	static bool purge_memory();
};
```

## 注意事項

静的関数によって参照されている、基底となっている pool `p` は、実際には次のように宣言されている。

-- `main()` の開始前および `main()` の終了後はただひとつのスレッドのみが走っているなら、スレッドセーフである。
	`singleton_pool` のすべての静的関数は `p` へのアクセスを同期する。
-- 使用前に構築済みであることが保証されている。それゆえ、上の梗概での単純な静的オブジェクトは実際には不正な実装である。
	これを保証する、実際の[実装](../implementation/singleton_pool.md)はもっと込み入ったものである。

別々の、基底となっている pool `p` は [実装に特定のもの](../implementation/singleton_pool.md)を含めて、テンプレートパラメーターの組み合わせ毎に存在することに注意せよ。

## テンプレートパラメータ

### Tag

テンプレートパラメータ `Tag` を区別することによって、別々の束縛されないシングルトンプールが存在できる。
一例として [pool allocators](pool_alloc.md) は、2つの異なるアロケーター型が、同じ基底となっているシングルトンプールを共有することが決して起きないように、2つのタグを使用している。

実際には`Tag`が`singleton_pool`によって何かに使用されることはない。

### RequestedSize

割り当てられるメモリーチャンクの要求サイズ。
これはコンストラクタパラメーターとして、基底となる `pool` に渡される。
0より大きいこと。

### UserAllocator

基底となる `pool` が、システムからメモリーを割り当てるために使用するメソッドを定義する。
詳細は [User Allocators](user_allocator.md) を見よ。

## 意味

**Symbol Table**

| Symbol | Meaning |
|---|---|
| `SingletonPool` | `singleton_pool<Tag, RequestedSize, UserAllocator>` |
| `chunk` | value of type `void *` |
| `n` | value of type `size_type` |

**Typedefs/Static Const Values**

| Expression | Type/Value |
|---|---|
| `SingletonPool::tag` | `Tag` | 
| `SingletonPool::user_allocator` | `UserAllocator` |
| `SingletonPool::size_type` | `pool<UserAllocator>::size_type` |
| `SingletonPool::difference_type` | `pool<UserAllocator>::difference_type` |
| `SingletonPool::requested_size` | `RequestedSize` |

**Functions**

| 式 | 戻り型 | 意味的同値 |
|---|---|---|
| `SingletonPool::is_from(chunk)` | `bool` | `SingletonPool::p.is_from(chunk);` synchronized |
| `SingletonPool::malloc()` | `void *` | `SingletonPool::p.malloc();` synchronized |
| `SingletonPool::ordered_malloc(n)` | `void *` | `SingletonPool::p.ordered_malloc(n);` synchronized |
| `SingletonPool::free(chunk)` | `void` | `SingletonPool::p.free(chunk);` synchronized |
| `SingletonPool::ordered_free(chunk)` | `void` | `SingletonPool::p.ordered_free(chunk);` synchronized |
| `SingletonPool::free(chunk, n)` | `void` | `SingletonPool::p.free(chunk, n);` synchronized |
| `SingletonPool::ordered_free(chunk, n)` | `void` | `SingletonPool::p.ordered_free(chunk, n);` synchronized |
| `SingletonPool::release_memory()` | `bool` | `SingletonPool::p.release_memory();` synchronized |
| `SingletonPool::purge_memory()` | `bool` | `SingletonPool::p.purge_memory();` synchronized |

これらの関数についてより詳しい情報は、[pool interface](pool.md) を見よ。

## Symbols

- `boost::singleton_pool`

## [Implementation Details](../implementation/singleton_pool.md)

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright.html](../copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

