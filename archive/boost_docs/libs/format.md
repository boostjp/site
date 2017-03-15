# Boost Format library

- 翻訳元ドキュメント： <http://www.boost.org/doc/libs/1_31_0/libs/format/>

format ライブラリは、書式文字列に従って引数を書式化するクラスを提供する。これは `printf` と同様に動作するが、二つの大きな違いがある： 

- format は引数を内部のストリームに送る。そのため完全に型安全であり、また自ずとあらゆるユーザ定義型をサポートする。
- 強く型付けされた format の文脈では省略記号 (`...`) を正しく使うことができない。そのため、任意の個数の引数を伴う関数呼び出しは、引数を食わせる `operator%` を繰り返し呼び出すことに置き換えられた。

詳細は以下を参照：

- [Documentation](format/format.md)
- Headers
    - format.hpp : ユーザフロントエンド。
    - format_fwd.hpp : ユーザ先行宣言。
    - format_class.hpp : クラスインターフェイス
    - format_implementation.hpp: メンバ関数の実装
    - feed_args.hpp : 引数フィーディング補助関数
    - free_funcs.hpp : 自由関数定義
    - parsing.hpp : 書式文字列パージングのコード
    - group.hpp : グループ引数およびマニピュレータのための補助的な構造体
    - exceptions.hpp : ライブラリで使用する例外
    - internals.hpp : 補助的な構造体stream_format_stateおよびformat_item
- テストプログラム example ディレクトリ

このライブラリは [Samuel Krempp](http://www.boost.org/doc/libs/1_31_0/people/samuel_krempp.htm) により提供された。

