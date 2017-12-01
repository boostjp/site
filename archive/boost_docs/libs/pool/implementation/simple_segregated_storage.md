# 単純分離記憶域の実装

## 依存性

システムヘッダー `<cstddef>` と `<functional>` をインクルードしている。

## Protected インタフェース

### 梗概

```cpp
template <typename SizeType = std::size_t>
class simple_segregated_storage
{
... // 公開インタフェース

protected:
	void * first;
	static void * & nextof(void * const ptr);
	void * find_prev(void * ptr);
};
```

### `void * first;`

このデータメンバーはフリーリストである。
フリーリスト中の最初のチャンクを指し、フリーリストが空のときは 0 である。

### `static void * & nextof(void * const ptr);`

これは便宜関数である。
可読性を増し、フリーリストを扱うクリーンアップコードの手助けをする。
戻り値は単に `*ptr` を適切な型へキャストしただけである。
`ptr` は 0 であってはならない。

例として、最初のチャンクの後のフリーリストを切り詰めたくなったと仮定しよう。
つまり、`*first` を 0 にセットしたいのだ。
こうすると中身が一個だけのフリーリストになる。
そうするための通常の方法は、最初に、`first` を void へのポインタへのポインタにキャストし、それを参照外しを行って代入することである(`*static_cast<void **>(first) = 0;`)。
これをこの便宜関数を使ってより容易に行うことができる(`nextof(first) = 0;`)。

### `void * find_prev(void * ptr);`

`first` によって参照されるフリーリストを廻って(traverse訳語未定)、`ptr` が指すものが仮にフリーリスト中にいるとすればそこであろう場所の、ひとつ前のものへのポインタを返す。
`ptr` がフリーリストの最初のものであれば 0 を返す(言い換えると `first` より前である)。

`ptr` が指すものは実際にはフリーリスト中には存在しないが、**仮に**フリーリスト中にあるならそこに**あるはずの**場所のひとつ前の位置を見つけ出すことに注意せよ。
`ptr` のひとつ前のエントリーを見つけ出すのではない(`ptr` がすでにフリーリストに入っているのでない限り)。
仕様として、`find_prev(0)` は 0 を返す。
フリーリストの最後のエントリーではない。

## [インタフェースの説明](../interfaces/simple_segregated_storage.md)

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright](../copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

