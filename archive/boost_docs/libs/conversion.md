# Boost Conversion Library

- 翻訳元ドキュメント： <http://www.boost.org/doc/libs/1_31_0/libs/conversion/>

Conversion Libraryは、他の扱いにくい変換機能を用いたプログラムを安全で扱いやすいものにする。 このライブラリにはC++の組み込み変換演算子を補完する形の関数テンプレート群が含まれている。

特に、標準ライブラリ`iostream`への依存をできる限りなくすために、 Boost Conversion Libraryは以下のいくつかのヘッダに分かれている。

- [boost/cast](conversion/cast.md)ヘッダはポリモフィックな型の間の安全な変換を行う `polymorphic_cast<>`、`polymorphic_downcast<>`と、数値型の間の安全な変換を行う `numeric_cast<>`を提供する。
- [boost/lexical_cast](conversion/lexical_cast.md)ヘッダは`int`を`string` で表現したり、その逆変換を行うときのような、文字列で表現出来る型同士の変換を行う`lexical_cast<>` を提供する。


***
Revised 06 January, 2001

