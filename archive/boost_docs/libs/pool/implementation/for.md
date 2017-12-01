# for - m4 FOR Macro

## はじめに

`detail/for.m4` は `BOOST_M4_FOR` を提供する。
この `m4` マクロは `#for` プリプロセッサインストラクションと同等のものを提供する。

## 用法

このマクロは `m4` ファイルで使用されなくてはならない。
このファイルは、すべてのビルトインシンボルに`m4_`接頭辞が強制的に付けられることように、オプション `-P`が使用されていると仮定している。

## 引数

- 現在の値を保持する変数の名前
- その変数の開始値
- その変数の終了値
- 繰り返されるテキスト。
	このテキストは変数への参照を含むことができ、そのときの変数の値で置き換えられる。
- 区切りテキスト(オプショナル)

もし引数の数が不正であれば(4未満または5より多い)、`BOOST_M4_FOR` はエラーとともに終了する。
もし開始値(`$2`)が終了値(`$3`)と同じか大きい場合、`BOOST_M4_FOR`は何もしない。
さもなくば、テキスト(`$4`)を繰り返す。
このとき変数(`$1`)をレンジ[開始値 (`$2`), 終了値 (`$3`)] に束縛し、繰り返されるテキスト(`$4`)の出現の間には区切りテキスト(`$5`)を繰り返す。

## 例

注意してほしいのは、下記のテーブルで使われる引用符(`"`)は入力と出力の一部であることである。
それはホワイトスペースを区切るために使われる。
すべての対の引用符内のコードは一行に書かれていると思ってほしい。

| Input | Output |
|---|---|
| "BOOST_M4_FOR(i, 1, 3)" | Boost m4 script: BOOST_M4_FOR: Wrong number of arguments (3) |
| "BOOST_M4_FOR(i, 1, 3, i, ` ', 13)" | Boost m4 script: BOOST_M4_FOR: Wrong number of arguments (6) |
| "BOOST_M4_FOR(i, 7, 0, i )" | (nothing) |
| "BOOST_M4_FOR(i, 0, 0, i )" | (nothing) |
| "BOOST_M4_FOR(i, 0, 7, i )" | "0 1 2 3 4 5 6 " |
| "BOOST_M4_FOR(i, -13, -10, i )" | "-13 -12 -11 " |
| "BOOST_M4_FOR(i, 0, 8, BOOST_M4_FOR(j, 0, 4, (i, j) )"<br/>")" | "(0, 0) (0, 1) (0, 2) (0, 3) "<br/>"(1, 0) (1, 1) (1, 2) (1, 3) "<br/>"(2, 0) (2, 1) (2, 2) (2, 3) "<br/>"(3, 0) (3, 1) (3, 2) (3, 3) "<br/>"(4, 0) (4, 1) (4, 2) (4, 3) "<br/>"(5, 0) (5, 1) (5, 2) (5, 3) "<br/>"(6, 0) (6, 1) (6, 2) (6, 3) "<br/>"(7, 0) (7, 1) (7, 2) (7, 3) "<br/>"" |
| "BOOST_M4_FOR(i, 7, 0, i, /)" | (nothing) |
| "BOOST_M4_FOR(i, 0, 0, i, /)" | (nothing) |
| "BOOST_M4_FOR(i, 0, 7, i, /)" | "0/1/2/3/4/5/6" |
| "BOOST_M4_FOR(i, -13, -10, i, `, ')" | "-13, -12, -11" |
| "BOOST_M4_FOR(i, 0, 8, `[BOOST_M4_FOR(j, 0, 4, (i, j), `, ')]', `,"<br/>"')" | "[(0, 0), (0, 1), (0, 2), (0, 3)],"<br/>"[(1, 0), (1, 1), (1, 2), (1, 3)],"<br/>"[(2, 0), (2, 1), (2, 2), (2, 3)],"<br/>"[(3, 0), (3, 1), (3, 2), (3, 3)],"<br/>"[(4, 0), (4, 1), (4, 2), (4, 3)],"<br/>"[(5, 0), (5, 1), (5, 2), (5, 3)],"<br/>"[(6, 0), (6, 1), (6, 2), (6, 3)],"<br/>"[(7, 0), (7, 1), (7, 2), (7, 3)]" |

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright](../copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

