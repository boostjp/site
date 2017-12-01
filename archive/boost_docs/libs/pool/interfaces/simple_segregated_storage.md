# 単純分離記憶域

## はじめに

`simple_segregated_storage.hpp` はメモリーチャンクの*フリーリスト*へのアクセスを管理するテンプレートクラス `simple_segregated_storage` を提供する。
これは**極めて**単純なクラスであり、ほとんどすべての機能に事前条件があることに注意してほしい。
それは最速最小ですぐ使えるメモリアロケータとなることを狙っている。
--例えば組み込みシステムで使われるような。
このクラスは多くの難しい事前条件(すなわちアラインメント問題である)をユーザーの代わりに処理する。
さらに多くの用法については[他のプールインタフェイス](../interfaces.md)を見よ。

## 梗概

```cpp
template <typename SizeType = std::size_t>
class simple_segregated_storage
{
private:
	simple_segregated_storage(const simple_segregated_storage &);
	void operator=(const simple_segregated_storage &);

public:
	typedef SizeType size_type;

	simple_segregated_storage();
	~simple_segregated_storage();

	static void * segregate(void * block,
		size_type nsz, size_type npartition_sz,
		void * end = 0);
	void add_block(void * block,
		size_type nsz, size_type npartition_sz);
	void add_ordered_block(void * block,
		size_type nsz, size_type npartition_sz);

	bool empty() const;

	void * malloc();
	void free(void * chunk);
	void ordered_free(void * chunk);
	void * malloc_n(size_type n, size_type partition_sz);
	void free_n(void * chunks, size_type n,
		size_type partition_sz);
	void ordered_free_n(void * chunks, size_type n,
		size_type partition_sz);
};
```

## 意味

`simple_segregated_storage<SizeType>`型のオブジェクトは、それのフリーリストが空ならば*空(empty)*である。
オブジェクトが空でないとき、そのフリーリストが順序付けされているならば*順序付けされている(ordered)*。
フリーリストは `malloc()`の繰り返し呼び出しが、`std::less<void *>`で定義される、単調増加列の値に帰着するならば、順序付けされている。
メンバー関数は、フリーリストの順序付けられた傾向を維持するならば*順序付け維持(order-preserving)*である。
(すなわち順序付けられたフリーリストは、そのメンバー関数の呼出し後も順序付けられている。)

**Table:Symbol Table**

| Symbol | Meaning |
|---|---|
| `Store` | `simple_segregated_storage<SizeType>` |
| `t` | `Store` 型の値 |
| `u` | `const Store` 型の値 |
| `block, chunk, end` | `void *` 型の値 |
| `partition_sz, sz, n` | `Store::size_type` 型の値 |

**Table:テンプレートパラメータ**

| パラメータ | 既定値 | 要求 |
|---|---|---|
| `SizeType` | `std::size_t` | 符号無し整数型 |

**Table:Typedefs**

| Symbol | Type |
|---|---|
| `size_type` | `SizeType` |

**Table:Constructors, Destructors, and State**

| 式 | 戻り型 | 事後条件 | 注意事項
|---|---|---|---|
| `Store()` | not used | `empty()` | 新しい `Store` を構築する |
| `(&t)->~Store()` | not used |  |  `Store` を破棄する |
| `u.empty()` | `bool` |  | `u` が空のとき `true` を返す。順序付け維持(Order-preserving) |

**Table:Segregation**

| 式 | 戻り型 | 事前条件 | 事後条件 | 意味的同値 | 注意事項 |
|---|---|---|---|---|---|
| `Store::segregate(block, sz, partition_sz, end)` | `void *` | `partition_sz >= sizeof(void *)` <br/> `partition_sz = sizeof(void *) * i` となる整数`i`が存在する。<br/> `sz >= partition_sz` <br/> `block` はサイズが`partition_sz`であるオブジェクトの配列に適切に整列している。 <br/> `block` は`void *`の配列に適切に整列している。 |  |  | `block`によって指定された`sz`バイトのメモリーブロック全体を通してフリーリストをインターリーブする、そのさい可能な限り多くの`partition_sz`-サイズのチャンクに分割する。最後のチャンクは`end`を指すようにセットされ、最初のチャンクへのポインタが返される(これはいつも`block`に等しい)。 のインターリーブされたフリーリストは順序付けされている。O(sz)。 |
| `Store::segregate(block, sz, partition_sz)` | `void *` | Same as above |  | `Store::segregate(block, sz, partition_sz, 0)` |  |
| `t.add_block(block, sz, partition_sz)` | `void` | Same as above | `!t.empty()` |  |`block`によって指定された`sz`バイトのメモリーブロックを`partition_sz`サイズのチャンクに分割し(segregate)、そのフリーリストを自分自身のフリーリストに加える。呼び出し前に`t` が空のとき、呼出し後は順序付けられている。O(sz)。 |
| `t.add_ordered_block(block, sz, partition_sz)` | `void` | Same as above | `!t.empty()` |  | `block`によって指定された`sz`バイトのメモリーブロックを`partition_sz`サイズのチャンクに分離させ(segregate)、そのフリーリストを自分自身のフリーリストとマージする。 順序付け維持(Order-preserving)である。 O(sz)。 |

**Table:Allocation and Deallocation**

| 式 | 戻り型 | 事前条件 | 事後条件 | 意味的同値 | 注意事項 |
|---|---|---|---|---|---|
| `t.malloc()` | `void *` | `!t.empty()` |  |  | フリーリストから、存在する最初のチャンクを取り出し返す。順序付け維持(Order-preserving)である。O(1)。 |
| `t.free(chunk)` | `void` | `chunk` was previously returned from a call to `t.malloc()` | `!t.empty()` |  |`chunk`をフリーリスト中へ戻す。`chunk`は`0`であってはならない。O(1)。 |
| `t.ordered_free(chunk)` | `void` | Same as above | `!t.empty()` |  | `chunk`をフリーリスト中へ戻す。`chunk`は`0`であってはならない。フリーリストのサイズによりO(N)。 |
| `t.malloc_n(n, partition_sz)` | `void *` |  |  |  | `partition_sz`サイズの連続したチャンク`n`個を発見しようと企てる。見つかれば、それらをすべてフリーリストから取り除き、それらの先頭へのポインタを返す。見つからなければ、`0`を返す。(必須ではないが)フリーリストは順序づけられていることが強く推奨される。このアルゴリズムは、フリーリストがうまく連続していなければ失敗するからである。順序付け維持(Order-preserving)である。フリーリストのサイズにより O(N)。 |
| `t.free_n(chunk, n, partition_sz)` | `void` | `chunk` was previously returned from a call to `t.malloc_n(n, partition_sz)` | `!t.empty()` | t.add_block(chunk, n * partition_sz, partition_sz) | `chunk`は実際に `n * partition_sz`バイトにわたるチャンクのブロックを参照していることを前提に、分離しブロックに加える。`chunk`は`0`であってはならない。O(n)。 |
| `t.ordered_free_n(chunk, n, partition_sz)` | `void` | same as above | same as above | `t.add_ordered_block(chunk, n * partition_sz, partition_sz)` | 上記と同じ。ただしフリーリストにマージする。順序付け維持(Order-preserving)である。NをフリーリストのサイズとしてO(N + n)。 |

## Symbols

- `boost::simple_segregated_storage`

## [実装の詳細](../implementation/simple_segregated_storage.md)

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright](../copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

