# The Boost Tuple Library

タプル(または *n* -タプル)は決まった個数の要素からなるコレクションである。
2つ組(pair)、3つ組、4つ組などがタプルである。
プログラミング言語においては、タプルは他のオブジェクトを要素として持つデータオブジェクトである。
要素となるオブジェクトは異なる型でありうる。

タプルはいろいろな状況で役に立つ。
例えば、2個以上の値を返す関数を定義するのが楽になる。

ML、PythonまたはHaskellなど、いくつかのプログラミング言語は、タプルの構造が組み込まれているが、不運にもC++はそうではない。
この"不足"を補うため、Boost Tuple Libraryは、タプル構造をテンプレートで実装する。

## 目次

- [ライブラリを使う](#using_library)
- [タプル型](#tuple_types)
- [タプルを構築する](#constructing_tuples)
- [タプル要素にアクセスする](#accessing_elements)
- [コピーコンストラクションとタプルの代入](#construction_and_assignment)
- [関係演算子](#relational_operators)
- [結束子](#tiers)
- [ストリーム化](#streaming)
- [パフォーマンス](#performance)
- [移植性](#portability)
- [謝辞](#thanks)
- [参考文献](#references)

#### もっと詳しく

[上位の機能](tuple/tuple_advanced_interface.md) (いくつかのメタ関数などを紹介する)

[一部の設計/実装上の決定に関する隠れた理論的根拠](tuple/design_decisions_rationale.md)

## <a id="using_library">ライブラリを使う</a>

ライブラリを使うには:

```cpp
#include "boost/tuple/tuple.hpp"
```

比較演算子を使うには:

```cpp
#include "boost/tuple/tuple_comparison.hpp"
```

タプルの入出力演算子を使うには、

```cpp
#include "boost/tuple/tuple_io.hpp"
```

`tuple_io.hpp` と `tuple_comparison.hpp` はどちらも `tuple.hpp` をインクルードする。
全ての定義は名前空間 `::boost::tuples` にあるが、最もよく使われるいくつかの名前は、using宣言を使って、名前空間 `::boost` に持ち上げられている: `tuple`, `make_tuple`, `tie`, `get` である。
さらに、`ref` と `cref` が `::boost` の直下に定義されている。

## <a id="tuple_types">タプル型</a>

タプル型は `tuple` テンプレートのインスタンスである。
テンプレートパラメータはタプルの要素の型を指定する。
現在のバージョンは、0-10個の要素を使うことができる。
もし必要なら、要素数の上限は、まあ数十個ぐらいまでなら増やせるだろう。
データ要素はC++の型であればなんでもいい。
`void` と通常の関数型は、その型のオブジェクトは存在できないものの、正当なC++の型であることに注意してほしい。
あるタプル型が要素としてそれらを含んでいると、タプル型は存在できるが、その型のオブジェクトはできない。
コピーできない、あるいはデフォルト コンストラクトできない要素型には、その性質よりおのずと生じる制限がある。
後の'タプルを構築する'を参照されたい。

例えば、次の定義はそれぞれ正当なタプルのインスタンス化である(`A`, `B`, `C` は何かしらのユーザ定義型と思っていただきたい):

```cpp
tuple<int>
tuple<double&, const double&, const double, double*, const double*>
tuple<A, int(*)(char, int), B(A::*)(C&), C>
tuple<std::string, std::pair<A, B> >
tuple<A*, tuple<const A*, const B&, C>, bool, void*>
```

## <a id="constructing_tuples">タプルを構築する</a>

タプルのコンストラクタはタプルの要素を引数としてとる。
ある *n* -要素タプルのコンストラクタは、`0 < k <= n` である `k` 個の引数をもって召喚することができる。
例えば:

```cpp
tuple<int, double>()
tuple<int, double>(1)
tuple<int, double>(1, 3.14)
```

要素に初期値が与えられなかったならば、それはデフォルト値で初期化される(というわけでデフォルトの初期化が可能でなければならぬ)。
例えば、

```cpp
class X {
  X();
public:
  X(std::string);
};

tuple<X,X,X>()                                              // error: no default constructor for X
tuple<X,X,X>(string("Jaba"), string("Daba"), string("Duu")) // ok
```

特に参照型はデフォルトの初期化ができない:

```cpp
tuple<double&>()                // error: reference must be
                                // initialized explicitly

double d = 5;
tuple<double&>(d)               // ok

tuple<double&>(d+3.14)          // error: cannot initialize
                                // non-const reference with a temporary

tuple<const double&>(d+3.14)    // ok, but dangerous:
                                // the element becomes a dangling reference
```

コピーできない要素に初期値を与えると、コンパイル時にエラーになる:

```cpp
class Y {
  Y(const Y&);
public:
  Y();
};

char a[10];

tuple<char[10], Y>(a, Y()); // error, neither arrays nor Y can be copied
tuple<char[10], Y>();       // ok
```

だが次の例は全くokである:

```cpp
Y y;
tuple<char(&)[10], Y&>(a, y);
```


構築できないタプル型ができてしまうこともある。
これは、初期化できない要素が、初期化を必要とする要素より前にあった場合に起こる。
例えば: `tuple<char[10], int&>`.

おおざっばに言って、タプルの構築は、文脈的に、それぞれの要素の構築の集まりにすぎない。

#### <a id="make_tuple">`make_tuple` 関数</a>

タプルはまた、`make_tuple` (cf. `std::make_pair`)ヘルパ関数によっても構築することができる。
これを使うと要素型を明示的に記述しなくてもよくなるので、構築はより簡単になる:

```cpp
tuple<int, int, double> add_multiply_divide(int a, int b) {
  return make_tuple(a+b, a*b, double(a)/double(b));
}
```

デフォルトでは、要素型は、型推論によって通常の非参照型とされる。
例えば:

```cpp
void foo(const A& a, B& b) {
  ...
  make_tuple(a, b);
```

`make_tuple` の結果は、タプル型 `tuple<A, B>` になる。

例えば、コピーできない型の要素があるなど、通常の非参照型が望ましくない場合もある。
そんな時は、型推論を抑制し、代わりにconstへの参照または非constへの参照型を用いるよう明示することができる。
それには二つのヘルパ テンプレート関数、`ref` と `cref` を使う。
望みの型を得るために、どの引数でもこれらの関数でラップしてよい。
constオブジェクトを `ref` しても、結果のタプルにはconstへの参照が入るので、このメカニズムでconstが勝手に剥ぎ取られるようなことはない(次の5行のコードを見ていただきたい)。
例えば:

```cpp
A a; B b; const A ca = a;
make_tuple(cref(a), b);      // creates tuple<const A&, B>
make_tuple(ref(a), b);       // creates tuple<A&, B>
make_tuple(ref(a), cref(b)); // creates tuple<A&, const B&>
make_tuple(cref(ca));        // creates tuple<const A&>
make_tuple(ref(ca));         // creates tuple<const A&>
```

配列が `make_tuple` 関数の引数に与えられたとき、デフォルトでは型推論によりconstへの参照とされる。
`cref` でラップする必要はない。
例えば:

```cpp
make_tuple("Donald", "Daisy");
```

このコードは `tuple<const char (&)[5], const char (&)[6]>` 型のオブジェクトを生成する(文字列リテラルは `const char` の配列であり、`const char*` ではない)。
しかし、`make_tuple` で、非const配列の要素を持つタプルを生成したいときには、`ref` を使わなければならない.

関数ポインタは型推論により通常の非参照型とされ、つまり、通常の関数ポインタになる。
タプルには関数への参照も入れることができる。
しかしこのようなタプルは `make_tuple` で構築することができない(結果的にconst修飾された関数型となり、文法違反になるためである):

```cpp
void f(int i);
  ...
make_tuple(&f); // tuple<void (*)(int)>
  ...
tuple<tuple<void (&)(int)> > a(f) // ok
make_tuple(f);                    // not ok
```

## <a id="accessing_elements">タプル要素にアクセスする</a>

タプル要素には次の式でアクセスすることができる:

```cpp
t.get<N>()
```

または

```cpp
get<N>(t)
```

`t` はタプルオブジェクトであり、`N` はアクセスされる要素のインデックスを特定する汎整数定数式である。
`t` がconstか否かによって、`get` が、`N` 番目の要素を、constへの参照として返すか、非constへの参照として返すかが決まる。

最初の要素のインデックスは0であり、したがって `N` は0から `k-1` ( `k` はタプルの要素の数)でなければならない。
さもなくばコンパイル時にエラーになる。
例えば:

```cpp
double d = 2.7; A a;
tuple<int, double&, const A&> t(1, d, a);
const tuple<int, double&, const A&> ct = t;
  ...
int i = get<0>(t); i = t.get<0>();        // ok
int j = get<0>(ct);                       // ok
get<0>(t) = 5;                            // ok
get<0>(ct) = 5;                           // error, can't assign to const
  ...
double e = get<1>(t); // ok
get<1>(t) = 3.14;     // ok
get<2>(t) = A();      // error, can't assign to const
A aa = get<3>(t);     // error: index out of bounds
  ...
++get<0>(t);  // ok, can be used as any variable
```

注意!
メンバ関数の `get` はMS Visual C++ compilerではサポートされていない。
そのうえこのコンパイラは、明示的に名前空間を指定しないと、非メンバ関数のgetを使うときにもトラブルが起こる。
そのため、MSVC++ 6.0.でコンパイルされるであろうコードを書くときは、全ての `get` 呼び出しに、このように指定をした方がよい: `tuples::get<N>(a_tuple)`

## <a id="construction_and_assignment">コピーコンストラクションとタプルの代入</a>

タプルは、要素ごとのコピーコンストラクトができるなら、他のタプルからコピーコンストラクトすることができる。
同様に、要素ごとの代入ができるなら、他のタプルに代入することができる。
例えば:

```cpp
class A {};
class B : public A {};
struct C { C(); C(const B&); };
struct D { operator C() const; };
tuple<char, B*, B, D> t;
  ...
tuple<int, A*, C, C> a(t); // ok
a = t;                     // ok
```

どちらの場合でも、変換は次のように行われる: `char -> int`, `B* -> A*` (派生クラスへのポインタから基本クラスのポインタへ),  `B -> C` (ユーザ定義の変換), `D -> C` (ユーザ定義の変換)。

`std::pair` からの代入も定義されている:

```cpp
tuple<float, int> a = std::make_pair(1, 'a');
```

## <a id="relational_operators">関係演算子</a>

タプルは `==, !=, <, >, <=, >=` 演算子を、対応する、要素ごとの演算子に還元する。
これは、いずれかの演算子が、二つのタプルの全ての要素に対して定義されていれば、その演算子が、タプルについても定義されることを意味する。

二つのタプル `a` と `b` に対する等価演算子は、このように定義される:

- `a == b` iff for each `i`: `ai == bi`
- `a != b` iff exists `i`: `ai != bi`

`<, >, <=, >=` 演算子は、辞書式順序を実装する。

要素数の異なる二つのタプルを比較しようとする試みは、コンパイル時エラーになる。
また、比較演算子は *"短絡的"* である: 要素ごとの比較は最初の要素から順に始められるが、結果が明らかになるまでしか行われない。

例:

```cpp
tuple<std::string, int, A> t1(std::string("same?"), 2, A());
tuple<std::string, long, A> t2(std::string("same?"), 2, A());
tuple<std::string, long, A> t3(std::string("different"), 3, A());

bool operator==(A, A) { std::cout << "All the same to me..."; return true; }

t1 == t2; // true
t1 == t3; // false, does not print "All the..."
```

## <a id="tiers">結束子</a>

*結束子* はタプルの一種で、全ての要素が非constへの参照型のものである。
これらは `tie` 関数テンプレート(cf. `make_tuple`)を召喚することによって構築される:

```cpp
int i; char c; double d;
  ...
tie(i, c, a);
```

上の `tie` 関数は、`tuple<int&, char&, double&>` 型のタプルを生成する。
`make_tuple(ref(i), ref(c), ref(a))` によっても同じ結果が得られる。

要素として非constへの参照を持つタプルは、別のタプルをいくつかの変数に'荷解き'するために利用することができる。
例えば:

```cpp
int i; char c; double d;
tie(i, c, d) = make_tuple(1,'a', 5.5);
std::cout << i << " " <<  c << " " << d;
```

このコードは標準出力ストリームに `1 a 5.5` とプリントする。

このようなタプル荷解き操作は、MLとPythonの例に見ることができる。
タプルを返す関数を呼ぶときに役立つ。

tieのメカニズムは `std::pair` テンプレートに対しても同様に働く:

```cpp
int i; char c;
tie(i, c) = std::make_pair(1, 'a');
```

### ignore

`ignore` は、タプルから代入された要素を無視することを可能にするオブジェクトである。
タプルを返す関数の、返却値の一部にしか興味が無いときに使う。
例えば(`ignore` は入れ子の名前空間 `tuples` にある):

```cpp
char c;
tie(tuples::ignore, c) = std::make_pair(1, 'a');
```

## <a id="streaming">ストリーム化</a>

グローバルの `operator<<` は、タプルを `std::ostream` に出力するとき、それぞれの要素について再帰的に `operator<<` を呼び出すよう、オーバーロードされている。

同様に、グローバルの `operator>>` も、タプルを `std::istream` から抽出するとき、それぞれの要素について再帰的に `operator>>` を呼び出すよう、オーバーロードされている。

デフォルトの区切り文字は空白で、タプルの前後は括弧でくくられる。
例えば:

```cpp
tuple<float, int, std::string> a(1.0f, 2, std::string("Howdy folks!");

cout << a;
```

このコードはタプルをこのように出力する: `(1.0 2 Howdy folks!)`

ライブラリは、デフォルトの挙動を変えるために、3つのマニピュレータを定義している:

- `set_open(char)` は、最初の要素の前に出力される文字を定義する。
- `set_close(char)` は、最後の要素の後に出力される文字を定義する。
- `set_delimiter(char)` は、要素間の区切り文字を定義する。

これらのマニピュレータは、入れ子の名前空間 `tuples` に定義されている。
例えば:

```cpp
cout << tuples::set_open('[') << tuples::set_close(']') << tuples::set_delimiter(',') << a;
```

このコードは同じタプルをこのように出力する: `[1.0,2,Howdy folks!]`

同じマニピュレータは `operator>>` と `istream` にも同じように働く。
`cin` ストリームに次のようなデータがあるとしよう:

```cpp
(1 2 3) [4:5]
```

次のコード:

```cpp
tuple<int, int, int> i;
tuple<int, int> j;

cin >> i;
cin >> tuples::set_open('[') >> tuples::set_close(']') >> tules::set_delimiter(':');
cin >> j;
```

はタプル `i` と `j` にデータを読み込む。

`std::string` やCスタイルの文字列を含むタプルを抽出するのは、一般的にはうまくいかない。
ストリーム化されたタプルの表現は、あいまいでない構文解析ができるとは限らないからである。

## <a id="performance">パフォーマンス</a>

タプルの全てのアクセス関数や構築関数は、小さなインライン化された一行関数である。
したがって、 標準的な処理系なら、タプルを使うことで、手書きのタプルに似たクラスよりかかる余分なコストを除去できるだろう。
具体的には、そういう処理系なら、このコードと:

```cpp
class hand_made_tuple {
  A a; B b; C c;
public:
  hand_made_tuple(const A& aa, const B& bb, const C& cc)
    : a(aa), b(bb), c(cc) {};
  A& getA() { return a; };
  B& getB() { return b; };
  C& getC() { return c; };
};

hand_made_tuple hmt(A(), B(), C());
hmt.getA(); hmt.getB(); hmt.getC();
```

このコードに:

```cpp
tuple<A, B, C> t(A(), B(), C());
t.get<0>(); t.get<1>(); t.get<2>();
```

パフォーマンスの差は無い。

広く使われている処理系でも、タプルのこの種の用途について最適化をしくじるものが存在する(例えば bcc 5.5.1)ことに注意されたい。

処理系の最適化能力に依存するが、tieのメカニズムは、関数が複数の値を返すために非const参照引数を使うのに比べて、小さなペナルティしかもたらさないだろう。
例えば、次の関数 `f1` と `f2` が、等価な機能を持っているとしよう:

```cpp
void f1(int&, double&);
tuple<int, double> f2();
```

この場合、次のコードの関数呼び出し `#1` は、`#2` よりわずかに早いだろう。

```cpp
int i; double d;
  ...
f1(i,d);         // #1
tie(i,d) = f2(); // #2
```

より突っ込んだ議論は、 [[1](#publ_1), [2](#publ_2)] を参照されたい。

#### コンパイル時間に与える影響

タプルをコンパイルする時、テンプレートのインスタンス化を大量に行う必要があるので、遅くなることがある。
処理系やタプルの要素数に依存するが、タプルの構築は、前に出てきた `hand_made_tuple` のような、明示的に書かれた等価なクラスをコンパイルするのに比べ、10倍以上遅くなるだろう。
しかし、現実的には、プログラムは、タプルの定義以外にも多量のコードを含んでいるであろうから、その差はたぶん、気になるほどではないだろう。
非常に頻繁にタプルを使用した、複数のプログラムで計測した結果、コンパイル時間は5から10パーセント増大した。
同じテストプログラムで、コンパイル時のメモリ消費量は22から27パーセント増大した。
詳しくは [[1](#publ_1), [2](#publ_2)] を参照されたい。

## <a id="portability">移植性</a>

ライブラリのコードは標準C++である(?)ので、標準規格に合致した処理系で使うことができる。
以下に、処理系の一覧と、それぞれの処理系についての既知の問題を掲げる:

| 処理系 | 問題 |
|---|---|
| gcc 2.95 | - |
| edg 2.44 | - |
| Borland 5.5 | 関数ポインタとメンバ ポインタをタプルの要素にできない |
| Metrowerks 6.2 | `ref` と `cref` ラッパが使えない |
| MS Visual C++ | 参照を要素にできない(でも `tie` は動作する)。`ref` と `cref` ラッパが使えない |

## <a id="thanks">謝辞</a>

Gary Powell has been an indispensable helping hand.
In particular, stream manipulators for tuples were his idea.
Doug Gregor came up with a working version for MSVC.
Thanks to Jeremy Siek, William Kempf and Jens Maurer for their help and suggestions.
The comments by Vesa Karvonen, John Max Skaller, Ed Brey, Beman Dawes, David Abrahams and Hartmut Kaiser helped to improve the library.
The idea for the tie mechanism came from an old usenet article by Ian McCulloch, where he proposed something similar for std::pairs.

## <a id="references">参考文献</a>

<a id="publ_1">[1]</a>
Jarvi J.: *Tuples and multiple return values in C++*, TUCS Technical Report No 249, 1999 ([http://www.tucs.fi/publications](http://www.tucs.fi/publications)).

<a id="publ_2">[2]</a>
Jarvi J.: *ML-Style Tuple Assignment in Standard C++ - Extending the Multiple Return Value Formalism*, TUCS Technical Report No 267, 1999 ([http://www.tucs.fi/publications](http://www.tucs.fi/publications)).

[3] Jarvi J.:*Tuple Types and Multiple Return Values*, C/C++ Users Journal, August 2001.

---

Last modified 2001-09-13

(c) Copyright  Jaakko Jarvi 2001.

Permission to copy, use, modify, sell and distribute this software and its documentation is granted provided this copyright notice appears in all copies.
This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

Japanese Translation Copyright (C) 2003 Yoshinori Tagawa.
オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の 複製、利用、変更、販売そして配布を認める。
このドキュメントは「あるがまま」 に提供されており、いかなる明示的、暗黙的保証も行わない。
また、 いかなる目的に対しても、その利用が適していることを関知しない。

