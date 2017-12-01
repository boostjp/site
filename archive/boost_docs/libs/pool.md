# Boost Pool Library

## はじめに

### Poolとは何か?

Poolアロケーションは使い方の制限があるものの非常に高速なメモリー割り当て方法である。
Poolアロケーション(「単純分割記憶域(simple segregated storage)」とも言う)のより詳細な情報は[概念資料](pool/concepts.md)を見よ。

### なぜPoolを使うのか?

Poolsを使用すると、プログラム中でどのようにメモリーが使用されるかを、よりうまく管理することができる。
例えば、一度に小さなオブジェクトを大量に割り当てたいときがあり、そしてそれらの一切が要らなくなるというときがやってくる、という状況になり得るだろう。
プールインターフェイス使えば、それらのデストラクターを実行するか、忘却の彼方へ送り去るかを選ぶことができる。
プールインタフェースはメモリーリークが起きないことを保証してくれる。

### いつPoolを使うべきか?

通常、プールは小さいオブジェクトを大量に割り当て、解放するときに使用される。
もう一つのよくある使い方が、上記の状況である。
すなわち沢山のオブジェクトがメモリーから消えるときである。

一般に、Poolは普段はやらないような効率的なメモリー管理が必要なときに使うべきだ。

### Poolの使い方は?

[pool interfaces document](pool/interfaces.md)を見なさい。
そこには、このライブラリーで提供される様々なインターフェイスについて記述がある。

## ライブラリの構造と依存性

このライブラリーの開示されたシンボルの前方宣言は、ヘッダーファイル `<boost/pool/poolfwd.hpp>` に含まれている。

ライブラリーは `BOOST_POOL_` で始まるマクロを使っている。
例外はインクルードファイルガード、(`xxx.hpp` については)`BOOST_xxx_HPP`である。

ライブラリーで定義されているすべての開示されたシンボルは名前空間`boost`内にある。
ライブラリーの実装だけが使用するシンボルは名前空間`boost::details::pool`内にある。

ライブラリーの実装だけが使用するヘッダーはサブディレクトリー`detail/`にある。

ライブラリーに含まれるヘッダーは、ライブラリーのヘッダーやシステムが提供するヘッダーをそれぞれの裁量で使っていることがある。

## Installation

The Boost Pool ライブラリーはヘッダファイルによるライブラリーである。
なので .lib も .dll も .so も作る必要はなく、コンパイラーのインクルードファイルパスに Boost ディレクトリを追加するだけで使える。

## Building the Test Programs

"build" サブディレクトリにいくつかのプラットフォーム用のサブディレクトリがある。
これらのサブディレクトリには、それぞれのプラットフォームに合わせた回避手段コードに加えてメイクファイルまたは IDE プロジェクトファイルがある。

適切なサブディレクトリの "readme.txt" を読みなさい。もしあれば。

標準的なメイクファイルのターゲットは "all"、"clean" (全ての中間ファイルを削除)、"veryclean" (全ての中間ファイルと実行ファイルを削除)、である。
すべての中間ファイルと実行ファイルはメイクファイル/プロジェクトファイルと同じディレクトリに作られる。
メイクファイルではなくプロジェクトファイルが提供されている場合、"clean" and "veryclean" シェルスクリプト/バッチファイルが用意されている。

ここにないプラットフォーム用のプロジェクトファイルやメイクファイルを作ったら [shammah@voyager.net](mailto:shammah@voyager.net) へ送ってくれて構わない。

## 文書マップ

- Poolingの概観
	- [Poolの概念](pool/concepts.md) - プール(pooling)の基本的考え方
	- [implementation/alignment](pool/implementation/alignment.md) - 如何にアラインメントの移植性を保証するか
	- [interfaces](pool/interfaces.md) - 提供されるインターフェースと、いつどれを使うか
- Poolの外部インターフェース
	 - [interfaces/simple_segregated_storage](pool/interfaces/simple_segregated_storage.md) - Not for the faint of heart; embedded programmers only.
	 - [interfaces/pool](pool/interfaces/pool.md) - 基本的プールインターフェース
	 - [interfaces/singleton_pool](pool/interfaces/singleton_pool.md) - スレッドセーフシングルトンとしての基本的プールインターフェース
	 - [interfaces/object_pool](pool/interfaces/object_pool.md) - (サイズ指向でなく)型指向のプールインターフェース
	 - [interfaces/pool_alloc](pool/interfaces/pool_alloc.md) - singleton_poolに基づく標準アロケータプールインターフェース
	 - [interfaces/user_allocator](pool/interfaces/user_allocator.md) - プールインターフェースではないと言うのは、ごもっとも。だがプールがシステムメモリーをどのように管理するかをユーザーがどうのように管理するかを記述してある。
- Pool実装の詳細と拡張
	- インターフェースの実装と拡張
		- [implementation/simple_segregated_storage](pool/implementation/simple_segregated_storage.md)
		- [implementation/pool](pool/implementation/pool.md)
		- [implementation/singleton_pool](pool/implementation/singleton_pool.md)
		- [implementation/object_pool](pool/implementation/object_pool.md)
		- [implementation/pool_alloc](pool/implementation/pool_alloc.md)
	- 実装にのみ使用されるコンポーネント
		- [implementation/ct_gcd_lcm](pool/implementation/ct_gcd_lcm.md) - コンパイル時GCDとLDM
		- [implementation/for](pool/implementation/for.md) - コンポーネントの記述
		- [implementation/gcd_lcm](pool/implementation/gcd_lcm.md) - 実行時GCDとLCM
		- [implementation/guard](pool/implementation/guard.md) - mutexの自動ロックとアンロック
		- [implementation/mutex](pool/implementation/mutex.md) - プラットフォーム依存のmutex型
		- [implementation/pool_construct](pool/implementation/pool_construct.md) - object_poolのコンストラクタの引数をより多くサポートするためのシステム
		- [implementation/singleton](pool/implementation/singleton.md) - 静的初期化問題を回避するシングルトン

## 将来の方向性

別のプールインターフェースを作るつもり。クラス毎の割り当ての既定クラス

## Acknowledgements

Many, many thanks to the Boost peers, notably Jeff Garland, Beman Dawes, Ed Brey, Gary Powell, Peter Dimov, and Jens Maurer for providing helpful suggestions!

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright](pool/copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

