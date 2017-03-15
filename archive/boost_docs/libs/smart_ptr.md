# Smart Pointer Library

このスマートポインタライブラリは 5 種類のスマートポインタクラステンプレートを含む。
スマートポインタはC++の`new`で動的に割り当てられるメモリの管理を容易にする。
更に`scoped_prt`は他の方法で動的に割り当てられたメモリの管理を容易にする。

- [Documentation](smart_ptr/smart_ptr.md)
- Header [scoped_ptr.hpp](http://www.boost.org/doc/libs/1_31_0/boost/scoped_ptr.hpp).
- Header [scoped_array.hpp](http://www.boost.org/doc/libs/1_31_0/boost/scoped_array.hpp).
- Header [shared_ptr.hpp](http://www.boost.org/doc/libs/1_31_0/boost/shared_ptr.hpp).
- Header [shared_array.hpp](http://www.boost.org/doc/libs/1_31_0/boost/shared_array.hpp).
- Header [weak_ptr.hpp](http://www.boost.org/doc/libs/1_31_0/boost/weak_ptr.hpp).
- Test program [smart_ptr_test.cpp](http://www.boost.org/doc/libs/1_31_0/libs/smart_ptr/test/smart_ptr_test.cpp).
- Originally submitted by [Greg Colvin](http://www.boost.org/doc/libs/1_31_0/people/greg_colvin.htm) and [Beman Dawes](http://www.boost.org/doc/libs/1_31_0/people/beman_dawes.html),
currently maintained by [Peter Dimov](http://www.boost.org/doc/libs/1_31_0/people/peter_dimov.htm) and [Darin Adler](http://www.boost.org/doc/libs/1_31_0/people/darin_adler.htm).

Revised 1 February 2002.

Japanese Translation Copyright (C) 2003 [Kohske Takahashi](mailto:kohske@msc.biglobe.ne.jp), [Ryo Kobayashi](mailto:lenoir@zeroscape.org).

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。
このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。
また、いかなる目的に対しても、その利用が適していることを関知しない。

