# object_pool - Boost Object Pool Allocator

## はじめに

`object_pool.hpp` は速く効率的なメモリー割り当てに使用できるテンプレート型を提供する。
開放されていないオブジェクトの自動破棄も提供する。
他のpoolベースのインタフェースについての情報は[他のプールインタフェース](../interfaces.md)を見よ。

## 梗概

```cpp
template <typename ElementType, typename UserAllocator = default_user_allocator_new_delete>
class object_pool
{
private:
	object_pool(const object_pool &);
	void operator=(const object_pool &);

public:
	typedef ElementType element_type;
	typedef UserAllocator user_allocator;
	typedef typename pool<UserAllocator>::size_type size_type;
	typedef typename pool<UserAllocator>::difference_type difference_type;

	object_pool();
	~object_pool();

	element_type * malloc();
	void free(element_type * p);
	bool is_from(element_type * p) const;

	element_type * construct();
	// other construct() functions
	void destroy(element_type * p);
};
```

## テンプレートパラメータ

### ElementType

テンプレートパラメータは割り当て/開放するオブジェクトの型である。
そのオブジェクトは例外を投げないデストラクを持たなくてはならない。

### UserAllocator

基底となっているPoolがシステムからメモリーを割り当てるとき使用するメソッドを定義する。
詳細は [User Allocators](user_allocator.md) を見よ。 

## 意味

**Symbol Table**

| Symbol | Meaning |
|---|---|
| `ObjectPool` | `object_pool<ElementType, UserAllocator>` |
| `t` | `ObjectPool` 型の値 |
| `u` | `const ObjectPool` 型の値 |
| `p` | `ElementType *` 型の値 |

**Typedefs**

| 式 | 型 |
|---|---|
| `ObjectPool::element_type` | ElementType |
| `ObjectPool::user_allocator` | UserAllocator |
| `ObjectPool::size_type` | `pool<UserAllocator>::size_type` |
| `ObjectPool::difference_type` | `pool<UserAllocator>::difference_type` |

**Constructors, Destructors, and Testing**

| 式 | 戻り型 | 注意事項 |
|---|---|---|
| `ObjectPool()` | not used | 新しい空の `ObjectPool` を構築する。 |
| `(&t)->~ObjectPool()` | not used | `ObjectPool` を破棄する。開放されていない割り当て中の ElementType に `~ElementType()` が呼び出される。O(N)。 |
| `u.is_from(p)` | `bool` | `p` が `u` から割り当てられているもの、もしくは `u` から先々、割り当てられることがありえるものの場合に `true` を返す。`p` が `u` 以外の pool から割り当てられているもの、もしくは他の pool から先々割り当てられることがありえるものの場合に `false` を返す。さもなくば、戻り値の値は無意味である。この関数はどのようなポインタ値についても信頼できるテストを行うわけでは**ない**ことに注意せよ。 |

**Allocation and Deallocation**

| Expression | Return Type | Pre-Condition | Semantic Equivalence | Notes |
|---|---|---|---|---|
| `t.malloc()` | `ElementType *` | | | `ElementType` を保持できるメモリーを割り当てる。メモリー枯渇時は `0` を返す。償却O(1)。 |
| `free(p)` | not used | `p` は `t` から返されたものでなくてはならない。 | | メモリーのチャンクを解放する。`p` は `0` であってはならないことに注意せよ。`p` のデストラクタは呼ばれないことに注意せよ。O(N)。 |
| `t.construct(???)` | `ElementType *` | `ElementType` は `???` 部分がマッチするコンストラクターを持っていなくてはならない。そこで与えられるパラメータ数は [`pool_construct`](../implementation/pool_construct.md) 中でサポートされている数を超えてはならない。 | | `ElementType` 型のオブジェクトを割り当て初期化する。メモリー枯渇時は、`0` を返す。償却 O(1)。 |
| `t.destroy(p)` | not used | `p` は `t` から返されたものでなくてはならない。 | `p->~ElementType(); t.free(p);` | |

## Symbols

- `boost::object_pool`

## [Implementation Details](../implementation/object_pool.md)

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright.html](../copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

