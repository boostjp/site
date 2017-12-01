# Object Pool Constructors Generator

## 説明

テンプレートクラス `object_pool` ([object_pool](object_pool.md) を見よ)は、いくつもの関数 `construct(..)` を含んでいる。
これらはオブジェクトの割り当てと構築の両方をひとつの操作で行う。

この関数への引数の数と型はまったく気まぐれであるので、テンプレート関数 `construct` を自動的に生成する簡単なシステムが用意されている。
このシステムは `m4` マクロプリプロセッサをベースとしている。
`m4` は UNIX システムでは標準であり、Win32 システムにもある。

`m4` を走らせると、`detail/pool_construct.m4` は `detail/pool_construct.inc` を作る。
ここには適切な個数の引数を持つ `construct` の定義のみがある。
引数の数は m4 マクロ `NumberOfArguments` としてファイルに渡されることがある。
もし提供されていなければ既定値は `3` である。

異なった引数の個数毎に(`1` から `NumberOfArguments`まで)、テンプレート関数が生成される。
引数の数と同じ数のテンプレートパラメータが存在し、それぞれの引数の型はそのテンプレートの引数(cv-修飾の場合もある)の反映である。
cv-修飾の可能な順列の数だけ生成される。

可能な引数の数のすべての順列が生成されるため、インクルードされるファイルのサイズは
コンストラクター引数の数の式で線形ではなく、指数的に増加する。
無理のないコンパイル時間のために、必要なだけの数の引数のみを使うべきである。

`detail/pool_construct.bat` と `detail/pool_construct.sh` はどちらも、`NumberOfArguments` をコマンドラインとして定義するように、`m4` を呼び出すために提供されている。
より詳細はこれらのファイルを見よ。

## 依存性

`for.m4` に依存([for](for.md) を見よ)。

## 将来の方向性

このシステムは Python (または他の言語)スクリプトによって補完または置換される予定。

## [Interface Description](../interfaces/object_pool.md)

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright](../copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

