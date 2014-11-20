#Date-Time Build-Compiler Information

- [全体のインデックスへ](../date_time.md)
- [Gregorianのインデックスへ](./gregorian.md)
- [Posix Timeのインデックスへ](./posix_time.md)

**Build-Compiler Information**

- [Overview](#overview)
- [Compilation Options](#compilation-options)
- [Compiler/Portability Notes](compiler-portability-notes)
- [Directory Structure](#directory-structure)
- [Required Boost Libraries](#required-boost-libraries)


## <a name="overview" href="overview">Overview</a>
ライブラリ関数のいくつかはライブラリファイルを作成する必要がある。 これらの関数を含むライブラリ( **libboost_date_time** )を作成するには、buildディレクトリにあるJamfileを使う。

変数`DATE_TIME_INLINE`は、ある特定のコア関数のインライン化を制御する。 デフォルトでこの変数はライブラリのコンパイル時に定義されている。 ライブラリを使っている全てのコンパイル単位でこの定義を含んでいなければ、リンクエラーになるだろう。


## <a name="compilation-options" href="compilation-options">Compilation Options</a>
デフォルトでは `posix_time` はナノ秒レベルの精度を提供するために内部で 64bit整数と32bit整数を使う。 選択肢として、一つの 64bit整数でマイクロ秒レベルの精度を提供することもできる。 この代替実装は、ナノ秒精度を必要としない多くのアプリケーションでパフォーマンスの向上と省メモリが期待できる。

変数`BOOST_DATE_TIME_POSIX_TIME_STD_CONFIG`はbuild/Jamfileで定義されており、これらのオプションを選択する。 64bit整数版を使う場合、単にJamfileからこの定義を削除する。


## <a name="compiler-portability-notes" href="compiler-portability-notes">Compiler/Portability Notes</a>
Boost Date-Time libraryは、多くのコンパイラでビルドされテストされた。 しかしながら、いくつかのコンパイラと標準ライブラリで問題がある。 これらの問題のいくつかは回避可能であるが、回避できない問題も残っている。 以下のコンパイラはライブラリの機能を完全にサポートしている。

- GCC 3.0.3 on Linux
- GCC 3.1 (cygwin)
- MSVC 7

特に、標準ロケールに対するサポートが完全でないと `iosteam` ベースの入出力サポートが制約される事がある。そういったコンパイラのために、より限定された文字列ベースの入出力を提供している。

以下のコンパイラ及び標準ライブラリはこの制約を含む

- GCC 2.9x on Linux
- Borland 5.1.1 and 5.6
- MSVC 6 SP5

ComeauやMetroworksといった他のコンパイラでは、ライブラリの初期バージョンでテストに成功している。


## <a name="directory-structure" href="directory-structure">Directory Structure</a>
`date_time`のディレクトリ構成はBoostに合わせて変更された。

ディレクトリ構成は次のようになっている

| ディレクトリ | 説明 |
|-------------------------------------|------|
| /boost/date_time                    | 共通ヘッダ及びテンプレート |
| /boost/date_time/gregoran           | グレゴリオ暦システムのヘッダファイル |
| /boost/date_time/posix_time         | Posix Time系のヘッダファイル |
| /libs/date_time/build               | ビルドファイルと出力ディレクトリ |
| /libs/date_time/test                | ジェネリックコードに関するテスト一式 |
| /libs/date_time/test/gregorian      | グレゴリオ暦に関するテスト一式 |
| /libs/date_time/examples/gregorian  | グレゴリオ暦に関する良いコード例 |
| /libs/date_time/src/gregorian       | libboost_date_time用のcppファイル
| /libs/date_time/test/posix_time     | Posix Time系に関するテスト一式 |
| /libs/date_time/examples/posix_time | 時間に関する良いコード例 |
| /libs/date_time/src/posix_time      | 空 (ファイルが一つあるが、ソースコードではない) |


## <a name="required-boost-libraries" href="required-boost-libraries">Required Boost Libraries</a>
このライブラリは以下のライブラリに依存している。

- boost.tokenizer
- boost.integer(cstdint)
- boost.operators
- boost::lexical_cast

よって、最低限これらのライブラリがインストールされている必要がある。


***
Last modified: Wed Aug 28 17:52:03 MST 2002 by [Jeff Garland](jeff@crystalclearsoftware.com) © 2000-2002 

Japanese Translation Copyright (C) 2003 [Shoji Shinohara](sshino@cppll.jp).


