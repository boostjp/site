# Pool の実装

## 依存性

システムヘッダー `<functional>`、`<new>`、`<cstddef>`、`<cstdlib>`、`<exception>` をインクルードしている。

Boost ヘッダー `"detail/ct_gcd_lcm.hpp"` ([ct_gcd_lcm](ct_gcd_lcm.md) を見よ)、`"detail/gcd_lcm.hpp"` ([gcd_lcm](gcd_lcm.md)を見よ)、`"simple_segregated_storage.hpp"` をインクルードしている。
( [simple_segregated_storage](simple_segregated_storage.md)を見よ)。

## 梗概

```cpp
namespace details {

template <typename SizeType>
class PODptr
{
public:
	typedef SizeType size_type;

	PODptr(char * ptr, size_type size);
	PODptr();

	// コピーコンストラクタ、代入演算子、デストラクターを許可

	bool valid() const;
	void invalidate();
	char * & begin();
	char * begin() const;
	char * end() const;
	size_type total_size() const;
	size_type element_size() const;

	size_type & next_size() const;
	char * & next_ptr() const;

	PODptr next() const;
	void next(const PODptr & arg) const;
};

} // namespace details

template <typename UserAllocator = default_user_allocator_new_delete>
class pool: protected simple_segregated_storage<typename UserAllocator::size_type>
{
... // 公開インターフェース

protected:
	details::PODptr<size_type> list;

	simple_segregated_storage<size_type> & store();
	const simple_segregated_storage<size_type> & store() const;

	const size_type requested_size;
	size_type next_size;

	details::PODptr<size_type> find_POD(void * chunk) const;
	static bool is_from(void * chunk, char * i, size_type sizeof_i);
	size_type alloc_size() const;

public: // 公開インターフェースの拡張
	pool(size_type requested_size, size_type next_size);
	size_type get_next_size() const;
	void set_next_size(size_type);
};
```

## 公開インターフェースの拡張

`pool` がシステムからメモリーを必要とするときはいつでも、テンプレートパラメータである `UserAllocator` からシステムへ要求が出される。
システムにリクエストする量はダブリングアルゴリズムによって決定される。
言い換えると、追加でシステムメモリーを確保するときは、要求する量を2倍にするということである。
ユーザーは以下に述べる拡張によってダブリングアルゴリズムを管理することができる。

### 追加のコンストラクターのパラメータ

ユーザーは `pool` のコンストラクターに追加のパラメータを渡すことができる。
このパラメーターは `size_type` 型で、そのオブジェクトがシステムメモリーを初めて必要とするときに要求するチャンクの数である。
既定値は 32 である。
このパラメーターは 0 であってはならない。

### `next_size` アクセサ関数

関数 `size_type get_next_size() const;` と `void set_next_size(size_type);` のペアはユーザーに明示的な `next_size` への読み書きを許す。
この値はオブジェクトが次にシステムメモリーからの割り当てが必要になったときに要求するチャンクの数である。
この値を 0 に設定してはならない。

## Class `PODptr`

`PODptr` は現実には存在しない異なるクラス型へのポインタであるかのように振舞うクラスである。
それは、それが指す "object" の "data" にアクセスするメンバー関数を提供する。
これらの "class" 型はサイズが異なり、メモリーの最後に何か情報を持っているため、`PODptr` は、この "class" のサイズを知っている必要がある。
まるで "class" へのポインタと同様に。

`PODptr` はシステムから割り当てられたメモリーブロックの場所とサイズを保持している。
個々のメモリーブロックは論理的に3つのセクションに分かれている。

- チャンクエリア。
	このセクションは異なるサイズである。
	`PODptr` はチャンクのサイズには注意しないが、チャンク領域のトータルサイズには注意を払い、追跡している。
- 次へのポインタ。
	このセクションは与えられた `SizeType` により常に同じサイズである。
	それはメモリーブロックリスト中の次のメモリーブロックの場所を保持する。
	次のブロックがなければ 0 を保持する。
- 次のサイズ。
	このセクションは与えられた `SizeType` により常に同じサイズである。
	それはメモリーブロックリスト中の次のメモリーブロックのサイズを保持する。

`PODptr` クラスは生のメモリーブロックを扱うよりはクリーンな方法を提供するのみである。

### 有効・無効性

`PODptr` は **valid** もしくは **invalid** のいずれかである。
invalid な `PODptr` は null ポインタのアナロジーである。

`PODptr` のデフォルトコンストラクタは無効な(invalid)なオブジェクトを作る。
メンバー関数 `invalidate` の呼び出しは、そのオブジェクトを無効にする。
メンバー関数 `valid` は、有効・無効性のテストに使用することができる。

### `PODptr` オブジェクトを得る

`PODptr` は、コンストラクタにメモリーブロックのアドレスとサイズを渡すことでメモリーブロックを指すように作られることもある。
この方法で生成された `PODptr` は有効(valid)である。

`PODptr` はメンバー関数 `next` の呼び出しによって生成されることもある。
このメンバー関数は、メモリーブロックリストの中の次のメモリーブロックを指す `PODptr` を返す。
もしくは、次のブロックが存在しないならば無効な `PODptr` を返す。

## "pointer" データにアクセスする

個々の `PODptr` は、そのメモリーブロックのアドレスとサイズを保持している。
このアドレスはメンバー関数 `begin` で、読み書きされる。
メモリーブロックのサイズはメンバー関数 `total_size` による読みのみが許されている。

### メモリーブロックの各領域へのアクセス

チャンク領域は `element_size` と連携して、メンバー関数`begin` と `end` によってアクセスすることができる。
`end` によって返される値は、つねに `begin` によって返される値に `element_size` を加えた値である。
`begin` のみが書き込み可能である。
`end` は past-the-end 値(末尾の要素の次)である。
`begin` に始まり`end` の前で終わるポインタの使用はメモリーブロックのチャンクを通しで反復することができる。

メンバー関数 `next_ptr` によって次ポインタ領域にアクセスすることができる。
メンバー関数 `next_size` によって次サイズ領域にアクセスすることができる。
両者とも書き込み可能である。
両者とも、メンバー関数 `next` を使って、同時に読むまたは変更ができる。

## Protected インタフェース

### Protected 導出

Pool は protected 導出を使って単純分離記憶域から導出されている。
これは [単純分離記憶域の実装の詳細](simple_segregated_storage.md)のすべてを、Poolから導出されるすべてのクラスにも同じように開示している。

### `details::PODptr<size_type> list;`

これは、このPoolオブジェクトによって割り当てられたメモリーブロックのリストである。
(`first` として単純分離記憶域によって開示された)未使用のメモリーチャンクのリストと同じものでは**ない**。

### `store` functions

基底クラスである単純分離記憶域オブジェクトを返すのに使われる、便宜関数がある。

### `const size_type requested_size;`

最初の引数はコンストラクタへ渡される。
ユーザーによって要求されたチャンクのバイト数を表現している。
チャンクの実際のサイズは異なっているかもしれない。
下記の `alloc_size` を見よ。

### `size_type next_size`

我々が次にシステムメモリーを割り当てるとき `UserAllocator` が要求するチャンクの数。
上記の拡張の説明を見よ。

### `details::PODptr<size_type> find_POD(void * chunk) const;`

メモリーブロックリストを通しで調べて、その `chunk` がそこから割り当てられている、または将来割り当てられことがあり得るブロックを探す。
もし見つかれば、そのブロックを返す。`chunk` が他の Pool から割り当てられている、もしくは将来他の Pool から割り当てられことがあり得る場合は無効な値を返す。
それ以外の `chunk` の値は、不正な結果を招く。

### `static bool is_from(void * chunk, char * i, size_type sizeof_i);`

`chunk` が 要素サイズが `sizeof_i` のメモリーチャンク `i` から割り当てられていると見える(思われる)かどうかをテストする。
`sizeof_i` はそのブロックのチャンク領域のサイズであり、ブロックのトータルサイズではないことに注意せよ。

`chunk` がそのメモリーブロックから割り当てられているか、将来そのメモリーブロックから割り当てられることがあり得る場合に `true` を返す。
`chunk` が他のブロックから割り当てられているか、将来他のブロックから割り当てられることがあり得る場合には `false` を返す。
それ以外の `chunk` の値は不正な結果を招く。

### `size_type alloc_size() const;`

この Pool によって割り当てられるメモリーチャンクの計算されたサイズを返す。
[アラインメントの都合で](alignment.md)、`lcm(requested_size, sizeof(void *), sizeof(size_type))` と定義されている。

## [インタフェースの説明](../interfaces/pool.md)

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright](../copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

