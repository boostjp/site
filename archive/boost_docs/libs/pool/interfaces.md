# Boost Pool Interfaces

## はじめに

ユーザーが Pool を使いたくなるような、素晴らしい柔軟性のあるインターフェースを紹介しよう。
Pools がどのように働くかについて基本的理解が必要なら、[concepts document概念資料](concepts.md)をよく読むと良い。

## 用語とトレードオフ

### オブジェクト用法 対 シングルトン用法

*オブジェクト用法*は、個々の Pool を生成・破棄されるオブジェクトとして扱う方法である。
Pool の破棄は、暗黙のうちに、そのプールから割り当てられたチャンクを開放する。

*シングルトン用法*は、個々のプールを static な生存期間のオブジェクトとして扱う方法である。
つまりプログラム終了時まで破棄されない。
シングルトン用法ではプールは共有されてもよい。
シングルトン用法はスレッドセーフであるということである。
シングルトン用法のプールオブジェクトによって確保されたシステムメモリーは、`release_memory` または `purge_memory`を使って開放される。

### メモリー枯渇時状態: 例外 対 Null 返し

Some Pool interfaces throw exceptions when out-of-memory; others will return 0.
In general, unless mandated by the Standard, Pool interfaces will always prefer to return 0 instead of throw an exception.

プールインタフェースには、メモリ枯渇時に例外を投げるものもある。
他のものは 0 を返す。
全般的には、標準に則っていないが、プールインタフェースは例外を投げるより 0 を返すことを好んでいる。

## インタフェース

### pool

[pool interface](interfaces/pool.md)はNullを返す、単純なオブジェクト用法のインタフェースである。

Example:

```cpp
void func()
{
	boost::pool<> p(sizeof(int));
	for (int i = 0; i < 10000; ++i)
	{
		int * const t = p.malloc();
		... // t を使って何かをする。それを free() する時間は取らなくてよい
	}
} // 関数終了時、pは破棄され、すべてのmalloc()されたintも暗黙のうちに開放される。
```

### object_pool

[object_pool interface](interfaces/object_pool.md) は Null を返すオブジェクト用法のインタフェースである。
これはチャンクが割り当てられようとしているオブジェクトの型を意識するという違いがある。
破棄時、`object_pool`が割り当てたすべてのチャンクにデストラクタが呼び出される。

Example:

```cpp
struct X { ... }; // 副作用のあるデストラクタを持つ

void func()
{
	boost::object_pool<X> p;
	for (int i = 0; i < 10000; ++i)
	{
		X * const t = p.malloc();
		... //  t を使って何かをする。それを free() する時間は取らなくてよい
	}
} // 関数終了時、pは破棄され、すべてのXオブジェクトについてデストラクタが呼び出される。
```

### singleton_pool

[singleton_pool interface](interfaces/singleton_pool.md) は Null を返す、シングルトン用法のインタフェースである。
これはシングルトン用法であること以外は pool インタフェースと同じである。

Example:

```cpp
struct MyPoolTag { };

typedef boost::singleton_pool<MyPoolTag, sizeof(int)> my_pool;
void func()
{
	for (int i = 0; i < 10000; ++i)
	{
		int * const t = my_pool::malloc();
		... //  t を使って何かをする。それを free() する時間は取らなくてよい
	}
	// 明示的にすべてのmalloc()された int を開放しなくてはならない
	my_pool::purge_memory();
}
```

### pool_alloc

[pool_alloc interface](interfaces/pool_alloc.md) は例外を使うシングルトン用法のインタフェースである。
`singleton_pool` interface 上に構築され、標準アロケータ準拠クラス(コンテナ内で使用できるなど)を提供する。

Example:

```cpp
void func()
{
	std::vector<int, boost::pool_allocator<int> > v;
	for (int i = 0; i < 10000; ++i)
		v.push_back(13);
}	// 関数の終了時にpoolアロケータによって割り当てられたシステムメモリーは解放されないので、
	// 開放させるために
	//  boost::singleton_pool<boost::pool_allocator_tag, sizeof(int)>::release_memory()
	// を呼ばなくてはならない
```

## Future Directions

別のプールインタフェースを書く予定である。
クラス個々のプールによる割り当てのための基底クラスになる。
この`pool_base` インタフェースは、例外を使うシングルトン用法で、`singleton_pool` インターフェース上に構築されることになるだろう。

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright](copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

