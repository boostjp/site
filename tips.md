#Boost逆引きリファレンス
逆引きリファレンスは、やりたいことから方法を調べるためのリファレンスです。

[テンプレートページ](https://sites.google.com/site/boostjp/tips/template_page)


Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>データ構造](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>並行データ構造](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>入出力](#TOC--2)</li><li class='goog-toc'>[<strong>4 </strong>数値操作](#TOC--3)</li><li class='goog-toc'>[<strong>5 </strong>文字列操作](#TOC--4)</li><li class='goog-toc'>[<strong>6 </strong>関数](#TOC--5)</li><li class='goog-toc'>[<strong>7 </strong>クラス](#TOC--6)</li><li class='goog-toc'>[<strong>8 </strong>イディオム](#TOC--7)</li><li class='goog-toc'>[<strong>9 </strong>メモリ](#TOC--8)</li><li class='goog-toc'>[<strong>10 </strong>検証](#TOC--9)</li><li class='goog-toc'>[<strong>11 </strong>プロセス](#TOC--10)</li><li class='goog-toc'>[<strong>12 </strong>数学](#TOC--11)</li><li class='goog-toc'>[<strong>13 </strong>コンパイル時処理](#TOC--12)</li><li class='goog-toc'>[<strong>14 </strong>並行処理](#TOC--13)</li><li class='goog-toc'>[<strong>15 </strong>ネットワーク](#TOC--14)</li><li class='goog-toc'>[<strong>16 </strong>日付・時間](#TOC--15)</li><li class='goog-toc'>[<strong>17 </strong>言語バインディング](#TOC--16)</li><li class='goog-toc'>[<strong>18 </strong>コンピュータビジョン](#TOC--17)</li><li class='goog-toc'>[<strong>19 </strong>開発環境](#TOC--18)</li></ol>




##<b>データ構造</b>

- [配列](https://sites.google.com/site/boostjp/tips/array)
- [多次元配列](https://sites.google.com/site/boostjp/tips/multi_array)
- [タプル](https://sites.google.com/site/boostjp/tips/tuple)
- [ハッシュ表](https://sites.google.com/site/boostjp/tips/hashmap)
- [グラフ](https://sites.google.com/site/boostjp/tips/graph)
- [コンテナに複数の並び順を持たせる](https://sites.google.com/site/boostjp/tips/multi_index)
- [for each文](https://sites.google.com/site/boostjp/tips/foreach)
- [リスト処理の遅延評価](https://sites.google.com/site/boostjp/tips/list)
- [動的型](https://sites.google.com/site/boostjp/tips/dynamic_type)
- [サイズを動的に変更できるビット集合](https://sites.google.com/site/boostjp/tips/dynamic_bitset)
- [循環バッファ](https://sites.google.com/site/boostjp/tips/circular_buffer)
- [優先順位を付けて並べ替える](https://sites.google.com/site/boostjp/tips/priority_sort)

##<b>並行データ構造</b>

- [ロックフリーキュー](https://sites.google.com/site/boostjp/tips/lockfree-queue)
- [ロックフリースタック](https://sites.google.com/site/boostjp/tips/lockfree-stack)

##<b>入出力</b>

- [ファイル／ディレクトリ操作](https://sites.google.com/site/boostjp/tips/filesystem)
- [シリアライズ](https://sites.google.com/site/boostjp/tips/serialize)
- [XMLの読み込み／書き込み](https://sites.google.com/site/boostjp/tips/xml)
- [JSONの読み込み／書き込み](https://sites.google.com/site/boostjp/tips/json)
- [iniファイルの読み込み／書き込み](https://sites.google.com/site/boostjp/tips/ini)
- [メモリマップドファイル](https://sites.google.com/site/boostjp/tips/memory_mapped_file)
- [ストリームの状態を戻す](https://sites.google.com/site/boostjp/tips/io_state)
- [ロギング](https://sites.google.com/site/boostjp/tips/logging)

##<b>数値操作</b>
<ul/>


- [多倍長整数](https://sites.google.com/site/boostjp/tips/multiprec-int)
- [多倍長浮動小数点数](https://sites.google.com/site/boostjp/tips/multiprec-float)

##<b>文字列操作</b>

- [文字列操作](https://sites.google.com/site/boostjp/tips/string_algo)
- [文字列フォーマット](https://sites.google.com/site/boostjp/tips/format)
- [構文解析](https://sites.google.com/site/boostjp/tips/parser)
- [静的な正規表現](https://sites.google.com/site/boostjp/tips/static_regex)
- [動的な正規表現](https://sites.google.com/site/boostjp/tips/dynamic_regex)

##<b>関数</b>

- [関数ポインタと関数オブジェクトを統一的に扱う](https://sites.google.com/site/boostjp/tips/function)
- [カリー化／部分適用](https://sites.google.com/site/boostjp/tips/partial_eval)
- [無名関数](https://sites.google.com/site/boostjp/tips/lambda)
- [名前付き引数](https://sites.google.com/site/boostjp/tips/named_parameter)

##<b>クラス</b>

- [クラスをコピー不可にする](https://sites.google.com/site/boostjp/tips/noncopyable)
- [コピー不可なオブジェクトを持ちまわる](https://sites.google.com/site/boostjp/tips/noncopyable_container)
- [ムーブ可能なクラスを定義する](https://sites.google.com/site/boostjp/tips/move)
- [組み込み型を必ず初期化する](https://sites.google.com/site/boostjp/tips/initialize)
- [無効値の統一的な表現](https://sites.google.com/site/boostjp/tips/optional)
- [ユーザー定義型を扱える型安全な共用体](https://sites.google.com/site/boostjp/tips/variant)
- [オブジェクトにユニークなIDを付ける](https://sites.google.com/site/boostjp/tips/uuid)
- [演算子自動定義する](https://sites.google.com/site/boostjp/tips/operators)
- [イテレータを作る](https://sites.google.com/site/boostjp/tips/iterator)

##<b>イディオム</b>

- [有限状態マシン](https://sites.google.com/site/boostjp/tips/finite_state_machine)
- [スコープを抜ける際に実行されるブロック](https://sites.google.com/site/boostjp/tips/scope_guard)
- [シグナル／スロット](https://sites.google.com/site/boostjp/tips/signals)
- コルーチン

##<b>メモリ</b>

- [リソースを自動的に解放する](https://sites.google.com/site/boostjp/tips/smart_ptr)
- プロセス間共有メモリ
- 値の共有／Flyweightパターン
- メモリプール

##<b>検証</b>


- [単体テスト](https://sites.google.com/site/boostjp/tips/unit_test)
- [実行時アサート](https://sites.google.com/site/boostjp/tips/dynamic_assert)
- [コンパイル時アサート](https://sites.google.com/site/boostjp/tips/static_assert)

##<b>プロセス</b>


- [コマンドラインオプションの定義／取得](https://sites.google.com/site/boostjp/tips/program_options)

##<b>数学</b>

- [乱数](https://sites.google.com/site/boostjp/tips/random)
- [線形代数](https://sites.google.com/site/boostjp/tips/linear-algebra)
- [数学](https://sites.google.com/site/boostjp/tips/math)
- 単位演算
- [区間演算](https://sites.google.com/site/boostjp/tips/interval_arithmetic)
- [統計処理](https://sites.google.com/site/boostjp/tips/statistics)
- [計算幾何](https://sites.google.com/site/boostjp/tips/geometry)
- 常微分方程式

##<b>コンパイル時処理</b>

- EDSLの作成
- [型特性](https://sites.google.com/site/boostjp/tips/type_traits)
- 型リスト操作
- [コンパイル時アサート](https://sites.google.com/site/boostjp/tips/static_assert)
- [コンパイル時条件によるオーバーロード](https://sites.google.com/site/boostjp/tips/constcond_overload)

##<b>並行処理</b>


- [スレッド](https://sites.google.com/site/boostjp/tips/thread)
- [MPI並列計算](https://sites.google.com/site/boostjp/tips/mpi)

##<b>[ネットワーク](https://sites.google.com/site/boostjp/tips/network)</b>

- [TCP](https://sites.google.com/site/boostjp/tips/network/tcp)
- UDP
- SSL
- シリアルポート

##<b>日付・時間</b>


- [日付の計算](https://sites.google.com/site/boostjp/tips/date_time)
- [処理時間の計測](https://sites.google.com/site/boostjp/tips/timer)

##<b>言語バインディング</b>


- Pythonバインディング

##<b>コンピュータビジョン</b>


- 画像処理

##<b>開発環境</b>

- [Boostのバージョンを調べる](https://sites.google.com/site/boostjp/tips/version)
- [コンパイラ間の差を吸収する](https://sites.google.com/site/boostjp/tips/config)
- コンパイラが、あるC++0xの機能をサポートしているかどうかでコードを変更する
- コンパイラによって、テンプレート中の hoge<T>::type x; や fuga.f(); がコンパイルエラーになったりならなかったりする問題を回避する
- メンバ関数テンプレートの呼び出しでコンパイルエラーになる問題を回避する
- [ビルドツール](https://sites.google.com/site/boostjp/tips/build)
- ビルドしたバイナリを実行する
- ディレクトリ構造を保存した状態でインストールを行う
- [ヘッダオンリー or ビルドが必要なライブラリ](https://sites.google.com/site/boostjp/tips/build_link)
- [C++11にもBoostにも存在するライブラリ](https://sites.google.com/site/boostjp/tips/cxx11-boost-mapping)
