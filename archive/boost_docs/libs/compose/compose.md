#Compose Function Object Adapters
標準C++ライブラリの一部であるStandard Template Library(STL) はいくつかの関数オブジェクトを提供している。 しかし残念なことにSTLはそれら関数オブジェクトを合成する手段を持ち合わせてはいない。 たとえば述語を表現した二つの単項演算AとBを基に、演算:"AかつB"を合成することができない。 関数の合成というコンセプトに基づき、ソフトウェア・コンポーネントの組み合わせによって新たなコンポーネントを構築するのは重要なことといえよう。 本ライブラリはソフトウェアからの要請と、それを満足できないライブラリとのギャップを埋めるアダプタを提供するものである。

ここに提供するアダプタは以下に示す関数の合成を実現する:

| 機能                     | Boost での名前    | SGI版 STL での名前 |
|--------------------------|-------------------|--------------------|
| `f(g(value))`            | `compose_f_gx`    | `compose1` |
| `f(g(value),h(value))`   | `compose_f_gx_hx` | `compose2` |
| `f(g(value1),h(value2))` | `compose_f_gx_hy` | |
| `f(g(value1,value2))`    | `compose_f_gxy`   | |
| `f(g())`                 | `compose_f_g`     | |

上の表にもあるとおり、二つのアダプタはSGI版STLですでに用意されている。 しかし、我々はすべてのアダプタに統一した命名規則を適用するため、その既存のアダプタの名前を変更する。

また、(既存の `unary_function` および `binary_function` を補完すべく)引数を持たない関数オブジェクト `nullary_function` を定義するとともに、 引数を持たない関数に適用できるよう `ptr_fun` をオーバロードする。

本ライブラリのコードは「あるがまま(as is)」に提供されており、いかなる明示的、暗黙的保証も行わない。

- ヘッダ [compose.hpp](./compose.hpp.md)
- `compose_f_gx` のサンプル [compose1.cpp](./compose1.cpp.md)
- `compose_f_gx_hx` のサンプル [compose2.cpp](./compose2.cpp.md)
- `compose_f_gx_hy` のサンプル [compose3.cpp](./compose3.cpp.md)
- 引数を与えない、`compose_f_g` および `ptr_fun` のサンプル [compose4.cpp](./compose4.cpp.md)


関数オブジェクトと合成関数の詳細は以下を参照されたい:

- [The C++ Standard Library - A Tutorial and Reference](http://www.josuttis.com/libbook/)
	- by Nicolai M. Josuttis 
	- Addison Wesley Longman, 1999 
	- ISBN 0-201-37926-0 
- [SGI STL documentation](http://www.sgi.com/Technology/STL/)


