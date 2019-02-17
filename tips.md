# Boost逆引きリファレンス
逆引きリファレンスは、やりたいことから方法を調べるためのリファレンスです。


**目次**

- [データ構造](#data_structure)
- [並行データ構造](#concurrent_data_structure)
- [入出力](#io)
- [数値演算](#numeric)
- [文字列操作](#string)
- [関数](#function)
- [クラス](#class)
- [イディオム](#idiom)
- [メモリ](#memory)
- [検証](#validation)
- [プロセス](#process)
- [数学](#math)
- [コンパイル時処理](#compile_time)
- [並行処理](#concurrency)
- [ネットワーク](#network)
- [日付・時間](#datetime)
- [言語バインディング](#lang_binding)


## <a id="data_structure" href="#data_structure">データ構造</a>

- [配列](/tips/array.md)
- [多次元配列](/tips/multi_array.md)
- [タプル](/tips/tuple.md)
- [ハッシュ表](/tips/hashmap.md)
- [グラフ](/tips/graph.md)
- [コンテナに複数の並び順を持たせる](/tips/multi_index.md)
- [for each文](/tips/foreach.md)
- [リスト処理の遅延評価](/tips/list.md)
- [動的型](/tips/dynamic_type.md)
- [サイズを動的に変更できるビット集合](/tips/dynamic_bitset.md)
- [循環バッファ](/tips/circular_buffer.md)
- [優先順位を付けて並べ替える](/tips/priority_sort.md)


## <a id="concurrent_data_structure" href="#concurrent_data_structure">並行データ構造</a>

- [ロックフリーキュー](/tips/lockfree-queue.md)
- [ロックフリースタック](/tips/lockfree-stack.md)


## <a id="io" href="#io">入出力</a>

- [ファイル／ディレクトリ操作](/tips/filesystem.md)
- [シリアライズ](/tips/serialize.md)
- [XMLの読み込み／書き込み](/tips/xml.md)
- [JSONの読み込み／書き込み](/tips/json.md)
- [iniファイルの読み込み／書き込み](/tips/ini.md)
- [メモリマップドファイル](/tips/memory_mapped_file.md)
- [ストリームの状態を戻す](/tips/io_state.md)
- [ロギング](/tips/logging.md)


## <a id="numeric" href="#numeric">数値演算</a>

- [多倍長整数](/tips/multiprec-int.md)
- [多倍長浮動小数点数](/tips/multiprec-float.md)


## <a id="string" href="#string">文字列操作</a>

- [文字列操作](/tips/string_algo.md)
- [文字列フォーマット](/tips/format.md)
- [構文解析](/tips/parser.md)
- [静的な正規表現](/tips/static_regex.md)
- [動的な正規表現](/tips/dynamic_regex.md)


## <a id="function" href="#function">関数</a>

- [関数ポインタと関数オブジェクトを統一的に扱う](/tips/function.md)
- [カリー化／部分適用](/tips/partial_eval.md)
- [無名関数](/tips/lambda.md)
- [名前付き引数](/tips/named_parameter.md)


## <a id="class" href="#class">クラス</a>

- [クラスをコピー不可にする](/tips/noncopyable.md)
- [コピー不可なオブジェクトを持ちまわる](/tips/noncopyable_container.md)
- [ムーブ可能なクラスを定義する](/tips/move.md)
- [組み込み型を必ず初期化する](/tips/initialize.md)
- [無効値の統一的な表現](/tips/optional.md)
- [ユーザー定義型を扱える型安全な共用体](/tips/variant.md)
- [オブジェクトにユニークなIDを付ける](/tips/uuid.md)
- [演算子自動定義する](/tips/operators.md)
- [イテレータを作る](/tips/iterator.md)


## <a id="idiom" href="#idiom">イディオム</a>

- [有限状態マシン](/tips/finite_state_machine.md)
- [スコープを抜ける際に実行されるブロック](/tips/scope_guard.md)
- [シグナル／スロット](/tips/signals.md)
- [コルーチン](/tips/coroutine.md)


## <a id="memory" href="#memory">メモリ</a>

- [リソースを自動的に解放する](/tips/smart_ptr.md)
- プロセス間共有メモリ
- 値の共有／Flyweightパターン
- メモリプール


## <a id="validation" href="#validation">検証</a>

- [単体テスト](/tips/unit_test.md)
- [実行時アサート](/tips/dynamic_assert.md)
- [コンパイル時アサート](/tips/static_assert.md)


## <a id="process" href="#process">プロセス</a>

- [コマンドラインオプションの定義／取得](/tips/program_options.md)


## <a id="math" href="#math">数学</a>

- [乱数](/tips/random.md)
- [線形代数](/tips/linear-algebra.md)
- [数学](/tips/math.md)
- [単位演算](/tips/units.md)
- [区間演算](/tips/interval_arithmetic.md)
- [統計処理](/tips/statistics.md)
- [計算幾何](/tips/geometry.md)
- 常微分方程式


## <a id="compile_time" href="#compile_time">コンパイル時処理</a>

- EDSLの作成
- [型特性](/tips/type_traits.md)
- 型リスト操作
- [コンパイル時アサート](/tips/static_assert.md)
- [コンパイル時条件によるオーバーロード](/tips/constcond_overload.md)


## <a id="concurrency" href="#concurrency">並行処理</a>

- [スレッド](/tips/thread.md)
- [MPI並列計算](/tips/mpi.md)


## <a id="network" href="#network">ネットワーク</a>

- [TCP](/tips/network/tcp.md)
- UDP
- SSL
- シリアルポート


## <a id="datetime" href="#datetime">日付・時間</a>

- [日付の計算](/tips/date_time.md)
- [処理時間の計測](/tips/timer.md)


## <a id="lang_binding" href="#lang_binding">言語バインディング</a>

- Pythonバインディング


## <a id="computer_vision" href="#computer_vision">コンピュータビジョン</a>

- 画像処理


## <a id="env" href="#env">開発環境</a>

- [Boostのバージョンを調べる](/tips/version.md)
- [コンパイラ間の差を吸収する](/tips/config.md)
	- コンパイラが、あるC++11の機能をサポートしているかどうかでコードを変更する
	- コンパイラによって、テンプレート中の `hoge<T>::type x;` や `fuga.f();` がコンパイルエラーになったりならなかったりする問題を回避する
	- メンバ関数テンプレートの呼び出しでコンパイルエラーになる問題を回避する
- [ビルドツール](/tips/build.md)
- ビルドしたバイナリを実行する
- ディレクトリ構造を保存した状態でインストールを行う
- [ヘッダオンリー or ビルドが必要なライブラリ](/tips/build_link.md)
- [C++11にもBoostにも存在するライブラリ](/tips/cxx11-boost-mapping.md)

