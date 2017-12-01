# Pool

## はじめに

`pool`は高速なメモリーアロケータであり、すべての割り当てたチャンクの適正なアラインメントを保証する。

pool.hpp は2つの [UserAllocator](user_allocator.md) クラスと `pool` テンプレートクラスを提供する。
これは [simple segregated storage](simple_segregated_storage.md) 解が提供するフレームワークを拡張し一般化する。
他のプールベースのインタフェースについての情報は[他のプールインタフェース](../interfaces.md)を見よ。

## 意味

```cpp
struct default_user_allocator_new_delete; // User Allocatorsを見よ
struct default_user_allocator_malloc_free; // User Allocatorsを見よ

template <typename UserAllocator = default_user_allocator_new_delete>
class pool
{
private:
	pool(const pool &);
	void operator=(const pool &);

public:
	typedef UserAllocator user_allocator;
	typedef typename UserAllocator::size_type size_type;
	typedef typename UserAllocator::difference_type difference_type;

	explicit pool(size_type requested_size);
	~pool();

	bool release_memory();
	bool purge_memory();

	bool is_from(void * chunk) const;
	size_type get_requested_size() const;

	void * malloc();
	void * ordered_malloc();
	void * ordered_malloc(size_type n);

	void free(void * chunk);
	void ordered_free(void * chunk);
	void free(void * chunks, size_type n);
	void ordered_free(void * chunks, size_type n);
};
```
* User Allocators[link user_allocator.md]

## テンプレートパラメータ

### UserAllocator

Poolがシステムからメモリーを割り当てるときに使用するメソッドを定義する。
詳細は [User Allocators](user_allocator.md) を見よ。

## 意味

**Table:Symbol Table**

| Symbol | Meaning |
|---|---|
| `Pool` | `pool<UserAllocator>` |
| `t` | value of type `Pool` |
| `u` | value of type `const Pool` |
| `chunk` | value of type `void *` |
| `n` | value of type `size_type` |
| `RequestedSize` | value of type `Pool::size_type`; must be greater than 0 |

**Table:Typedefs**

| Expression | Type |
|---|---|
| `Pool::user_allocator` | `UserAllocator` |
| `Pool::size_type` | `UserAllocator::size_type` |
| `Pool::difference_type` | `UserAllocator::difference_type` |

**Table:Constructors, Destructors, and Testing**

| Expression | Return Type | Notes |
|---|---|---|
| `Pool(RequestedSize)` | not used | `RequestedSize` サイズのチャンクを割り当てるために使用される、新しい空の `Pool` を構築する。 |
| `(&t)->~Pool()` | not used | `Pool`を破棄し、メモリーブロックのリストを解放する。 |
| `u.is_from(chunk)` | `bool` | `chunk`が`u`から割り当てられたものである、もしくは`u`から先々割り当てられることがあり得るものの場合に`true`を返す。`chunk`が`u`以外のpoolから割り当てられたものである、もしくは他のpoolから先々割り当てられることがあり得るものの場合に`false`を返す。さもなくば、戻り値は無意味である。 |
| `u.get_requested_size()` | `size_type` | この関数はどのようなポインタ値を与えても信頼できるテストを行っているわけでは**ない**ことに注意せよ。コンストラクタに渡された値を返す。`Pool` オブジェクトの生存期間中、変わらない。 |

**Table:Allocation and Deallocation**

| Expression | Return Type | Pre-Condition | Notes |
|---|---|---|---|
| `t.malloc()` | `void *` | | メモリーのチャンクを割り当てる。未使用のチャンクを持つブロックを、メモリーブロックリストから探し、見つかればその未使用チャンクを返す。さもなくば、新しいメモリーブロックを生成し、それのフリーリストを `t` のフリーリストに追加し、そのブロックから未使用チャンクを返す。新しいメモリーブロックを確保することができなければ、`0` を返す。償却 O(1)。 |
| `t.ordered_malloc()` | `void *` | | 上記と同じ、但し、順序を維持してフリーリストをマージすることだけが異なる。償却 O(1)。 |
| `t.ordered_malloc(n)` | `void *` | | 上記と同じ、但し、少なくとも `n * requested_size` バイト以上の大きさはある連続したチャンクを割り当てる。償却 O(1)。 |
| `t.free(chunk)` | `void` | `chunk` は `t.malloc()` もしくは `t.ordered_malloc()` によって返されたものでなくてはならない。 | メモリーのチャンクを解放する。`chunk` は `0` であってはならないことに注意せよ。O(1)。 |
| `t.ordered_free(chunk)` | `void` | 上記と同じ。 | 上記と同じ、但し、順序を維持する。`chunk` は `0` であってはならないことに注意せよ。フリーリストのサイズによって O(N)。 |
| `t.free(chunk, n)` | `void` | `chunk` は `t.ordered_malloc(n)` によって返されたものでなくてはならない。 | `chunk` は実際に `n * partition_sz` バイトに広がったチャンクのブロックを参照していることを前提とし、ブロックの個々のチャンクを開放する。`chunk` は `0` であってはならないことに注意せよ。O(n)。 |
| `t.ordered_free(chunk, n)` | `void` | `chunk` は `t.ordered_malloc(n)` によって返されたものでなくてはならない。 | `chunk` は実際に `n * partition_sz` バイトに広がったチャンクのブロックを参照していることを前提とし、ブロックの個々のチャンクを開放する。`chunk` は `0` であってはならないことに注意せよ。順序を維持する。O(N + n)、N はフリーリストのサイズ。 |
| `t.release_memory()` | `bool` | `t` 順序付けされていること。 | 割り当て中のチャンクを持たないメモリーブロックを解放する。少なくともひとつのメモリーブロックを解放した場合、`true` を返す。 |
| `t.purge_memory()` | `bool` | | すべてのメモリーブロックを解放する。この関数は `t` の割り当て関数から返されたポインタを無効にする。少なくともひとつのメモリーブロックを解放した場合、`true` を返す。 |

## Symbols

- boost::default_user_allocator_new_delete
- boost::default_user_allocator_malloc_new
- boost::pool

## [実装の詳細](../implementation/pool.md)

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright](../copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

