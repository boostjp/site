# User Allocators

## はじめに

Pool オブジェクトはシステムにメモリーブロックを要求する必要があり、それを Pool はユーザーに割り当てるチャンクに分割する。
様々な Pool インターフェースに対し、テンプレートパラメータである `UserAllocator` を指定することで、ユーザーはそれらのシステムメモリーブロックがどのように割り当てられるかを管理することができる。

## 意味

**Symbol Table**

| Symbol | 意味 |
|---|---|
| `UserAllocator` | ユーザーアロケーター型 |
| `block` | `char *` 型の値 |
| `n` | `UserAllocator::size_type` 型の値 |

**Typedefs**

| 式 | 型 |
|---|---|
| `UserAllocator::size_type` | アロケートされる最大オブジェクトのサイズを表現しうる符号無し整数型 |
| `UserAllocator::difference_type` | 任意の2つのポインタの差を表現しうる符号付整数型 |

**Allocation and Deallocation**

| 式 | 戻り型 | 事前条件/注意事項 |
|---|---|---|
| `UserAllocator::malloc(n)` | `char *` | システムから `n` バイトを割り当てようとする。メモリー枯渇時には0を返す。 |
| `UserAllocator::free(block)` | `void` | `block` `block` は以前に `UserAllocator::malloc` への呼び出しから返されたものでなくてはならない。 |

## 提供されている実装

2つの `UserAllocator` クラスが提供されている。
両者とも `pool.hpp` の中にある([pool](pool.md) を参照)。
テンプレートパラメータ `UserAllocator` のデフォルト値は常に `default_user_allocator_new_delete` である。

### 梗概

```cpp
struct default_user_allocator_new_delete
{
	typedef std::size_t size_type;
	typedef std::ptrdiff_t difference_type;

	static char * malloc(const size_type bytes)
	{ return new (std::nothrow) char[bytes]; }
	static void free(char * const block)
	{ delete [] block; }
};

struct default_user_allocator_malloc_free
{
	typedef std::size_t size_type;
	typedef std::ptrdiff_t difference_type;

	static char * malloc(const size_type bytes)
	{ return reinterpret_cast<char *>(std::malloc(bytes)); }
	static void free(char * const block)
	{ std::free(block); }
};
```

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright](../copyright.html)

This software and its documentation is provided &quot;as is&quot; without express or implied warranty, and with no claim as to its suitability for any purpose.

