#Boost.Compatibilty ライブラリ

- 翻訳元ドキュメント： <http://www.boost.org/doc/libs/1_31_0/libs/compatibility/>

このライブラリは、boostライブラリが規格に準拠していないプラットフォームでも利用できるようにするための回避手段を提供するものである。我々は、よりいっそう規格に準拠した標準ライブラリが提供され、いつかこのライブラリを削除できる日がくることを望んでいる。


##C++標準ライブラリのCXXヘッダ(例 `<cstdio>`)が見当たらない場合の回避策
Pythonスクリプト generate_cpp_c_headers.py は、いくつかのプラットフォームでは見当たらない C++ の C ヘッダ(例 `<cstdio>`) を生成することができる。このスクリプトによって生成されたヘッダファイルはboost/compatibility/cpp_c_headersディレクトリの中に存在する。このヘッダを使うには、ファイル検索パスにこのディレクトリを追加すればよい。たとえば以下のようにする。

```
cxx -I/usr/local/boost/boost/compatibility/cpp_c_headers ...
```

サポートしているプラットフォーム:

- Compaq Alpha, RedHat 6.2 Linux, Compaq C++ V6.3 (cxx)
- Compaq Alpha, Tru64 Unix V5.0, Compaq C++ V6.2 (cxx)
- Silicon Graphics, IRIX 6.5, MIPSpro コンパイラ: Version 7.3.1.1m (CC)

[STLport](http://www.stlport.org/) や [ISOCXX](http://www-pat.fnal.gov/personal/wb/boost/) のように、Boost.Compatibility を用いるよりもっと強力な代替手段も存在する。しかし、これらの代替手段と比べ、generate_cpp_c_headers.py はたいへん軽量(コメント抜きで100行以下のPythonコード)で、まして大げさでもなく、きわめて簡単に維持できるため、一時的な回避手段としてはより適切である。

以上は Ralf W. Grosse-Kunstleve によって寄稿されたものである。


##C++標準ライブラリ`<limits>`ヘッダが見当たらない場合の回避手段、boost/limits.hpp
Boostライブラリのうちのいくつかは標準ライブラリ`<limits>`を必要とする。しかし、このヘッダは規格に準拠していないコンパイラやライブラリがいつでも提供しているとは限らない。boost/limits.hppは、標準ライブラリ`<limits>`が利用可能であるならそれを単純にインクルードしているが、そうでないならboost/detail/limits.hppをインクルードしている。boost/config.hppの`BOOST_NO_LIMITS`は`<limits>`ヘッダが利用可能か決定するために使われる。

テストプログラム limits_test.cpp も参照せよ。

以上は Jens Maurer によって寄稿されたものである。


***
© Copyright Ralf W. Grosse-Kunstleve 2001. Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies. This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

Updated: April 16, 2001

***

Japanese Translation Copyright © 2003 [kazu.y](mailto:samba@pal.tok2.com)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

