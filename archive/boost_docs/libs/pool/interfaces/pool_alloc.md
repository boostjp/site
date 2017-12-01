# pool_alloc - Boost Pool Standard Allocators

## はじめに

`pool_alloc.hpp` は速く効率的なメモリー割り当てに使用できる2つのテンプレート型を提供している。
どちらも[20.1.5]の標準アロケーターとしての要件と[20.1.5/4]の付加要件を満足しており、標準コンテナもしくはユーザーが作成したコンテナに使用することができる。
他の pool ベースのインタフェースの情報は[他のプールインターフェース](../interfaces.md)を見よ。

## 梗概

```cpp
struct pool_allocator_tag { };

template <typename T,
	typename UserAllocator = default_user_allocator_new_delete>
class pool_allocator
{
public:
	typedef UserAllocator user_allocator;
	typedef T value_type;
	typedef value_type * pointer;
	typedef const value_type * const_pointer;
	typedef value_type & reference;
	typedef const value_type & const_reference;
	typedef typename pool<UserAllocator>::size_type size_type;
	typedef typename pool<UserAllcoator>::difference_type difference_type;

	template <typename U>
	struct rebind
	{ typedef pool_allocator<U, UserAllocator> other; };

public:
	pool_allocator();
	pool_allocator(const pool_allocator &);
	// 以下はstd::allocator [20.4.1]をそっくり真似るので explicitではない。
	template <typename U>
	pool_allocator(const pool_allocator<U, UserAllocator> &);
	pool_allocator & operator=(const pool_allocator &);
	~pool_allocator();

	static pointer address(reference r);
	static const_pointer address(const_reference s);
	static size_type max_size();
	static void construct(pointer ptr, const value_type & t);
	static void destroy(pointer ptr);

	bool operator==(const pool_allocator &) const;
	bool operator!=(const pool_allocator &) const;

	static pointer allocate(size_type n);
	static pointer allocate(size_type n, pointer);
	static void deallocate(pointer ptr, size_type n);
};

struct fast_pool_allocator_tag { };

template <typename T
	typename UserAllocator = default_user_allocator_new_delete>
class fast_pool_allocator
{
public:
	typedef UserAllocator user_allocator;
	typedef T value_type;
	typedef value_type * pointer;
	typedef const value_type * const_pointer;
	typedef value_type & reference;
	typedef const value_type & const_reference;
	typedef typename pool<UserAllocator>::size_type size_type;
	typedef typename pool<UserAllocator>::difference_type difference_type;

	template <typename U>
	struct rebind
	{ typedef fast_pool_allocator<U, UserAllocator> other; };

public:
	fast_pool_allocator();
	fast_pool_allocator(const fast_pool_allocator &);
	// 以下はstd::allocator [20.4.1]をそっくり真似るので explicitではない。
	template <typename U>
	fast_pool_allocator(const fast_pool_allocator<U, UserAllocator> &);
	fast_pool_allocator & operator=(const fast_pool_allocator &);
	~fast_pool_allocator();

	static pointer address(reference r);
	static const_pointer address(const_reference s);
	static size_type max_size();
	static void construct(pointer ptr, const value_type & t);
	static void destroy(pointer ptr);

	bool operator==(const fast_pool_allocator &) const;
	bool operator!=(const fast_pool_allocator &) const;

	static pointer allocate(size_type n);
	static pointer allocate(size_type n, pointer);
	static void deallocate(pointer ptr, size_type n);

	static pointer allocate();
	static void deallocate(pointer ptr);
};
```

## テンプレート

### T

最初のテンプレートパラメーターは割り当て/開放するオブジェクトの型である。

### UserAllocator

基礎となっている Pool がシステムからメモリーを確保するとき使用するメソッドを定義する。
詳細は [User Allocators](user_allocator.md) を見よ。

## 意味

上記の2つの pool アロケーターは標準[20.1.5]で説明されている標準アロケーターとしてのすべての要件を満足している。
それらは[20.1.5/4]に見られる付加要件も満足しており、どの標準準拠のコンテナにも使用することができる。

加えて、`fast_pool_allocator` は追加の割り当てと追加の開放を行う関数も提供している。

**Symbol Table**

| Symbol | Meaning |
|---|---|
| `PoolAlloc` | `fast_pool_allocator<T, UserAllocator>` |
| `p` | value of type `T *` |

**Additional allocation/deallocation functions (`fast_pool_allocator` only)**

| Expression | Return Type | Semantic Equivalence |
|---|---|---|
| `PoolAlloc::allocate()` | `T *` | `PoolAlloc::allocate(1)` |
| `PoolAlloc::deallocate(p)` | `void` | `PoolAlloc::deallocate(p, 1)` |

typedef である `user_allocator` はテンプレートパラメータの値である `UserAllocator` をクラスの外に見せる。

## 注意事項

割り当て関数は、メモリーを使い切ったときには `std::bad_alloc` を投げる。

アロケーターが使用する、基底となっている Pool 型は [Singleton Pool Interface](singleton_pool.md) 経由でアクセスできる。
`pool_allocator` で使用される識別タグは `pool_allocator_tag` であり、`fast_pool_allocator` で使用されるタグは `fast_pool_allocator_tag` である。
([実装に特定のもの](../implementation/pool_alloc.md)も含めて)アロケータのすべてのテンプレートパラメータは、基底となっている Pool の型を決定する。
ただし、最初のパラメータ `T` については、そのサイズが使用されるので、これは除く。

`T` のサイズが基底となる Pool の型を決定するので、同じサイズの異なる型のアロケータは、同じ基底となる pool を*共有することになる*。
タグクラスは `pool_allocator` と `fast_pool_allocator` が pool を共有しないようにする。
例えば、 `sizeof(int) == sizeof(void *)` であるシステムでは、`pool_allocator<int>` と `pool_allocator<void *>` は同一の pool から 割り当て/開放を行うことになる。

`main()` 開始前と `main()` 終了後に、ただひとつのスレッドのみが走っているなら、どちらのアロケータも完全にスレッドセーフである。

## The Fast Pool Allocator

`pool_allocator` は、任意数の連続したチャンクへの割り当て要求に効率的に応えることに適した、より汎用性のある解である。
`fast_pool_allocator` も、汎用性のある解であるが、一度に一個のチャンクが要求されることに効率的に応えるように調整されている。
連続したチャンクに対しても機能するが、`pool_allocator` ほどではない。
もし、パフォーマンスを真剣に考えているなら、`std::list` のようなコンテナを扱うときは `fast_pool_allocator` を、`std::vector` のようなコンテナを扱うときは `pool_allocator` を使うとよい。

## Symbols

- `boost::pool_allocator`
- `boost::pool_allocator_tag`
- `boost::fast_pool_allocator`
- `boost::fast_pool_allocator_tag`

## [実装の詳細](../implementation/pool_alloc.md)

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright.html](../copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

