# Object Pool Implementation

## 依存性

Boost ヘッダー `"pool.hpp"`([pool](pool.md) を見よ)をインクルードしている。

## 公開インタフェースの拡張

`ObjectPool` 型のオブジェクトがシステムからメモリーを必要とするときはいつでも、それのテンプレートパラメーター `UserAllocator` がシステムへ要求を出す。
リクエストされる量はダブリングアルゴリズムによって決定される。
言い換えると、より多くのシステムメモリーが割り当てられるとき、要求される量は2倍になるということである。
ユーザーは以下に述べる拡張によってダブリングアルゴリズムを管理することができる。

### 追加のコンストラクタパラメータ

ユーザーは `ObjectPool` のコンストラクタに追加のパラメータを渡すことができる。
このパラメータは `size_type` 型で、そのオブジェクトがシステムメモリーを初めて必要とするときに要求するチャンクの数である。
デフォルト値は 32 である。
このパラメーターは 0 であってはならない。

### `next_size`アクセサ関数

関数 `size_type get_next_size() const;` と `void set_next_size(size_type);` のペアはユーザーに明示的な `next_size` の読み書きを許す。
この値はオブジェクトが次にシステムメモリーから割り当てを必要とするときに要求するチャンクの数である。
この値を 0 に設定してはならない。

## Protected インタフェース

### 梗概

```cpp
template <typename ElementType, typename UserAllocator = default_user_allocator_new_delete>
class object_pool: protected pool<UserAllocator>
{
... // public interface
};
```

### Protected Derivation

ObjectPool は protected 導出を使って単純分離記憶域から導出されている。
これは [Pool 実装の詳細](pool.md) のすべてを、ObjectPool から導出されるすべてのクラスにも同じように開示している。

## [インタフェースの説明](../interfaces/object_pool.md)

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright](../copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

