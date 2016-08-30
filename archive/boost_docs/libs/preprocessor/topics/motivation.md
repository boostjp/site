#動機

C++ の関数やテンプレートの引数リストは特別な構文によって組み立てられるもので、C++ の式によって構成したり操作したりできない。
このことによってコードを無駄に反復してしまうことがある。

例としてBoostの `is_function<>` メタ関数の実装を見てみよう。
この実装は、型が関数へのポインタへ変換できるかどうかを調べる `is_function_tester()` 多重定義関数を使っている。
引数リストは特別な取扱いがされるため、任意個の引数を持つ関数に直接マッチさせることはできない。
そのかわりに、関数 `is_function_tester()` はサポートされる全ての引数の個数ごとに別々に定義されなければならない。
例えば次の通り:

```cpp
template<class R>
yes_type is_function_tester(R (*)());

template<class R, class A0>
yes_type is_function_tester(R (*)(A0));

template<class R, class A0, class A1>
yes_type is_function_tester(R (*)(A0, A1));

template<class R, class A0, class A1, class A2>
yes_type is_function_tester(R (*)(A0, A1, A2));

// ...
```

このような種類の繰り返しは総称的なコンポーネントやメタプログラミングのための機能の実装をする際に頻繁に起きる。

##典型的な解決法

典型的には、このような繰り返しは手動で解決される。
手動による繰り返しは生産的ではないが、訓練されていない人間の目にはそのようなコードが読みやすいことがある。

ほかの解決法としては、繰り返しを生成する外部プログラムを使うことや、高度なエディタなどを使う方法がある。
残念ながら、外部の生成プログラムを使う方法はたくさんの欠点がある:

- 生成プログラムを書くのは時間がかかる。(標準的な生成プログラムを使うと楽になるが。)
- 生成された C++ コードを直接変更できない。
- 生成プログラムを呼ぶのは難しいかもしれない。
- 特定の環境においては生成プログラムの呼び出しを自動化するのは難しいかもしれない。
	(呼び出しの自動化は頻繁に変更されるライブラリにとっては魅力的である。)
- 生成プログラムの移植や配布は難しいかもしれないし、時間を消費する。

##プリプロセッサではどうか？

C++にはプリプロセッサが付いているので、このような需要に向いていると考えるかもしれない。
実際、プリプロセッサはこのようなケースに極めて妥当である。なぜなら:

- プリプロセッサはポータブルである。
- プリプロセッサはコンパイルの一部として自動的に実行される。
- プリプロセッサのコードは直接 C++ のコードに埋め込むことができる。
- コンパイラは通常、プリプロセッサの出力を見ることができるようになっているが、これは生成されたコードをデバグしたりコピーするのに便利である。

残念ながらプリプロセッサは非常に低レベルなものであり、繰り返しや再帰的マクロをサポートしていない。
したがってライブラリによるサポートが必要である。

- 詳細なプリプロセッサの機能と制限については、C++ 標準 [[Std]](bibliography.md#std) を参照してほしい。

##ふたたび先の例

プリプロセッサライブラリを使用すると、 `is_function_tester()` は次のように実装できる:

```cpp
#define IS_FUNCTION_TESTER(Z, N, _) \
	template<class R BOOST_PP_COMMA_IF(N) BOOST_PP_ENUM_PARAMS(N, class A)> \
	yes_type is_function_tester(R (*)(BOOST_PP_ENUM_PARAMS(N, A))); \
	/**/

BOOST_PP_REPEAT(BOOST_PP_INC(MAX_IS_FUNCTION_TESTER_PARAMS), IS_FUNCTION_TESTER, _)

#undef IS_FUNCTION_TESTER
```

サポートする引数の最大個数を変更するには、単に `MAX_IS_FUNCTION_TESTER_PARAMS` を変更してコンパイルしなおせばよい。

---

(C) Copyright [Housemarque Oy](http://www.housemarque.com) 2002

Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies.
This document is provided "as is" without express or implied warranty and with no claim as to its suitability for any purpose.

