#多倍長浮動小数点数
多倍長浮動小数点数を使用するには、[Boost Multiprecision Library](http://www.boost.org/libs/multiprecision/)を使用する。

Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>基本的な使い方](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>多倍長浮動小数点数の種類](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>文字列からの変換](#TOC--2)</li><li class='goog-toc'>[<strong>4 </strong>文字列への変換](#TOC--3)</li><li class='goog-toc'>[<strong>5 </strong>異なる精度間で型変換する](#TOC--4)</li><li class='goog-toc'>[<strong>6 </strong>サポートされている数学関数一覧](#TOC--5)</li></ol>




###基本的な使い方
ここでは、Boost.Multiprecisionから提供される多倍長浮動小数点数の、基本的な使い方を示す。
以下は、任意精度の符号あり多倍長整数である[`boost::multiprecision::cpp_dec_float_100`](http://www.boost.org/doc/libs/release/libs/multiprecision/doc/html/boost_multiprecision/tut/floats/cpp_dec_float.html)クラス型を使用して、2の平方根を求めるプログラムである。

```cpp
#include <iostream>
#include <boost/multiprecision/cpp_dec_float.hpp>

namespace mp = boost::multiprecision;

int main()
{
    // 100は仮数部の桁数
    mp::cpp_dec_float_100 x = 2.0f;

    // 平方根を100桁求める
    mp::cpp_dec_float_100 result = mp::sqrt(x);

    // 出力桁数を設定して出力
    std::cout << std::setprecision(std::numeric_limits<decltype(x)>::digits10 + 1)
              << result;
}
```
* cpp_dec_float_100 x = 2.0f;[color ff0000]

出力：
```cpp
1.4142135623730950488016887242096980785696718753769480731766797379907324784621070388503875343276415727
```

`cpp_dec_float_100`は、Boost.Multiprecisionが独自実装した演算をバックエンドに持つ、100桁の仮数部を表現可能な多倍長浮動小数点数である。Boost.Multiprecisionが提供する全ての機能は、`boost::multiprecision`名前空間で定義される。

Boost.Multiprecisionの多倍長浮動小数点数は、以下の演算をサポートする。ビット演算は使用できない。


| | |
|-----------------------------------------|-------------|
| `a + b;` `a += b;` | 加算 |
| `a - b;` `a -= b;` | 減算 |
| `a * b;` `a *= b;` | 乗算 |
| `a / b;` `a /= b;` | 除算 |
| `+a;` | 符号をプラスにする |
| `-a;` | 符号をマイナスにする |
| `a++;` `++a;` | インクリメント |
| `a--;` `--a;` | デクリメント |
| `a == b;` | 等値比較 |
| `a != b;` | 非等値比較 |
| `a < b;` | aがbより小さいかの判定 |
| `a <= b;` | aがb以下かの判定 |
| `a > b;` | aがbより大きいかの判定 |
| `a >= b;` | aがb以上かの判定 |
| `os << a;` | ストリームへの出力 |
| `is >> a;` | ストリームからの入力 |



###多倍長浮動小数点数の種類
以下に、Boost.Multiprecisionから提供される多倍長整数の種類を示す。

<b>[Boost Multiprecision独自実装の多倍長浮動小数点数](http://www.boost.org/doc/libs/release/libs/multiprecision/doc/html/boost_multiprecision/tut/floats/cpp_dec_float.html)</b>
`#include <boost/multiprecision/cpp_dec_float.hpp>`

| | |
|------------------|--------------------|
| cpp_dec_float_50 | 仮数部を50桁表現可能な浮動小数点数 |
| cpp_dec_float_100 | 仮数部を100桁表現可能な浮動小数点数 |

以下は、ユーザー定義の固定精度浮動小数点数型を定義する例である：
```cpp
// 仮数部を1,000桁表現可能な浮動小数点数の定義
namespace mp = boost::multiprecision;
typedef mp::number<mp:cpp_dec_float<1000> > cpp_dec_float_1000;
```

独自実装の多倍長浮動小数点数の特徴：

- デフォルト値は0である
- 基数は10。基数2ベースとは異なる振る舞いが可能
- `infinity`と`NaN`をサポートする。オーバーフローやゼロ割り時には、組み込みの浮動小数点数型と同じ振る舞いをする。
- 全ての操作は、常に切り捨てを行う

<b>[GMPバックエンドの多倍長浮動小数点数](http://www.boost.org/doc/libs/release/libs/multiprecision/doc/html/boost_multiprecision/tut/floats/gmp_float.html)</b>
`#include <boost/multiprecision/gmp.hpp>`

| | |
|----------------------------|----------------------|
| mpf_float_50 | 仮数部を50桁表現可能な浮動小数点数 |
| `mpf_float_100` | 仮数部を100桁表現可能な浮動小数点数 |
| `mpf_float_500` | 仮数部を500桁表現可能な浮動小数点数 |
| `mpf_float_1000` | 仮数部を1,000桁表現可能な浮動小数点数 |
| `mpf_float` | 仮数部を任意長表現可能な浮動小数点数 |
以下は、ユーザー定義の固定精度浮動小数点数型を定義する例である：
```cpp
// 仮数部を10,000桁表現可能な浮動小数点数の定義
namespace mp = boost::multiprecision;
typedef mp::number<mp:gmp_float<10000> > mpf_dec_float_10000;

gmp_floatのテンプレート引数として0を指定すると、任意長の仮数部が表現可能になる。

GMP多倍長浮動小数点数の特徴：

- デフォルト値は0である
- GMPのグローバル設定を変更しない
- GMPはinfinityやNaNといった概念を持たないため、可能な限りオーバーフローやゼロ割りは避けること。オーバーフロー時またはゼロ割り時にはstd::overflow_error例外が送出される。

<b>MPFRバックエンドの多倍長浮動小数点数</b>
#include <boost/multiprecision/mpfr.hpp>
動的メモリ確保を行う多倍長浮動小数点数
```
* MPFRバックエンドの多倍長浮動小数点数[link http://www.boost.org/doc/libs/release/libs/multiprecision/doc/html/boost_multiprecision/tut/floats/mpfr_float.html]

| | |
|-----------------------------|----------------------|
| mpfr_float_50 | 仮数部を50桁表現可能な浮動小数点数 |
| `mpfr_float_100` | 仮数部を100桁表現可能な浮動小数点数 |
| `mpfr_float_500` | 仮数部を500桁表現可能な浮動小数点数 |
| `mpfr_float_1000` | 仮数部を1,000桁表現可能な浮動小数点数 |
| `mpfr_float` | 仮数部を任意長表現可能な浮動小数点数 |


動的メモリ確保を行わない多倍長浮動小数点数

| | |
|----------------------|--------------------|
| static_mpfr_float_50 | 仮数部を50桁表現可能な浮動小数点数 |
| static_mpfr_float_100 | 仮数部を100桁表現可能な浮動小数点数 |


以下は、ユーザー定義の、動的メモリ確保を行う固定精度浮動小数点数型を定義する例である：
```cpp
// 仮数部を10,000桁表現可能な浮動小数点数の定義
namespace mp = boost::multiprecision;
typedef mp::number<mp:mpfr_float_backend<10000> > mpf_dec_float_10000;

mpfr_float_backendの第2テンプレート引数としてboost::multiprecision::allocate_stack列挙値を指定することで、動的メモリ確保を行わない多倍長浮動小数点数型の定義ができる。

MPFR多倍長浮動小数点数の特徴：

- デフォルト値はNaNである
- 全ての操作は、最近接値への丸めを使用する
- GMPとMPFRのグローバル設定を変更しない
- 0で割るとinfinityになる
```

###文字列からの変換
文字列から多倍長浮動小数点数に変換するには、`explicit`な変換コンストラクタ、もしくは`assign()`メンバ関数を使用する。
文字列は、`char`配列および[`std::string`](/reference/string/basic_string.md)を受け取ることができる。

<b>コンストラクタで文字列から変換</b>
```cpp
#include <iostream>
#include <string>
#include <boost/multiprecision/cpp_dec_float.hpp>

using namespace boost::multiprecision;

int main()
{
    cpp_dec_float_100 x("3.14");                // char配列から変換
    cpp_dec_float_100 y(std::string("3.14"));   // std::stringから変換

    std::cout << x << std::endl;
    std::cout << y << std::endl;
}
```

出力：
```cpp
3.14
3.14
```

<b>assign()メンバ関数で文字列から変換</b>
```cpp
#include <iostream>
#include <boost/multiprecision/cpp_dec_float.hpp>

using namespace boost::multiprecision;

int main()
{
    cpp_dec_float_100 x;
    x.assign("3.14");

    std::cout << x << std::endl;
}
```

出力：
```cpp
3.14
```

変換できない文字列が渡された場合は、[`std::runtime_error`](/reference/stdexcept.md)例外が送出される。


###文字列への変換
文字列への変換には、`str()`メンバ関数を使用する。この関数は、`std::string`型で多倍長浮動小数点数の文字列表現を返す。
デフォルトでは固定小数点表記の文字列が返されるが、以下の引数を設定することで、精度と表記、その他出力方法を選択できる。

- 第1引数： 出力する精度。0を指定した場合、できるだけ多くの桁数を出力する。
- 第2引数： 出力フラグ。
```cpp
#include <iostream>
#include <boost/multiprecision/cpp_dec_float.hpp>

using boost::multiprecision::cpp_dec_float_50;

int main()
{
    cpp_dec_float_50 x = 3.14;

    // 固定小数点表記(デフォルト)
    {
        const std::string s = x.str();
        std::cout << s << std::endl;
    }
    // 固定小数点表記(明示的に指定)
    {
        const std::string s = x.str(0, std::ios_base::fixed);
        std::cout << s << std::endl;
    }
    // 科学的表記
    {
        const std::string s = x.str(0, std::ios_base::scientific);
        std::cout << s << std::endl;
    }
}
```

出力：
```cpp
3.140000000000000124344978758017532527446746826171875
3.1400000000000001243449787580175325274467468261718750000000000000000000000
3.1400000000000001243449787580175325274467468261718750000000000000000000000e+00
```

###異なる精度間で型変換する
Boost.Multiprecisionの多倍長浮動小数点数は、異なる精度間での変換をサポートしている。

<b>小さい精度から大きい精度への変換</b>
`float`や`double`型といった組み込みの浮動小数点数型から、`cpp_dec_float_50`や`cpp_dec_float_100`といった多倍長浮動小数点数への暗黙変換が可能である。
また、`cpp_dec_float_50`から`cpp_dec_float_100`へ、といったより大きい精度への暗黙変換が可能である。

```cpp
#include <boost/multiprecision/cpp_dec_float.hpp>

using namespace boost::multiprecision;

int main()
{
    // floatからcpp_dec_float_50への暗黙変換
    float f = 3.14f;
    cpp_dec_float_50 f50 = f; // OK

    // cpp_dec_float_50からcpp_dec_float_100への暗黙変換
    cpp_dec_float_100 f100 = f50; // OK
}
```

<b>大きい精度から小さい精度への変換</b>
小さい精度への変換は、データが失われる可能性があるため、暗黙の型変換はサポートしない。
明示的な型変換を使用する場合のみ変換可能である。

```cpp
#include <boost/multiprecision/cpp_dec_float.hpp>

using namespace boost::multiprecision;

int main()
{
    cpp_dec_float_100 f100 = 3.14;

//  cpp_dec_float_50 f50 = f100; // コンパイルエラー！変換できない
    cpp_dec_float_50 f50 = static_cast<cpp_dec_float_50>(f100); // OK
}
```

###サポートされている数学関数一覧
<b>標準関数サポート</b>
標準ライブラリで定義される以下の関数は、Boost.Multiprecisionの多倍長浮動小数点数でも使用できる。
これらの関数は、`boost::multiprecision`名前空間で定義される。


| | |
|-----------------------------------------------------------------------------------------------------------------------------|-------------------------|
| `T abs(T x);` [`T fabs(T x);`](/reference/cmath/fabs.md) | 絶対値 |
| [`T sqrt(T x);`](/reference/cmath/sqrt.md) | 平方根 |
| `T floor(T x);` | 床関数（引数より大きくない最近傍の整数） |
| `T ceil(T x);` | 天井関数（引数より小さくない最近傍の整数） |
| `T trunc(T x);` `T itrunc(T x);` `T ltrunc(T x);` `T lltrunc(T x);` | ゼロ方向への丸め |
| `T round(T x);` `T lround(T x);` `T llround(T x);` | 四捨五入による丸め |
| [`T exp(T x);`](/reference/cmath/exp.md) | e (ネイピア数) を底とする指数関数 |
| [`T log(T x);`](/reference/cmath/log.md) | e (ネイピア数) を底とする自然対数 |
| [`T log10(T x);`](/reference/cmath/log10.md) | 10 を底とする常用対数 |
| [`T cos(T x);`](/reference/cmath/cos.md) | 余弦関数（コサイン） |
| [`T sin(T x);`](/reference/cmath/sin.md) | 正弦関数（サイン） |
| [`T tan(T x);`](/reference/cmath/tan.md) | 正接関数（タンジェント） |
| [`T acos(T x);`](/reference/cmath/acos.md) | 逆余弦関数（アークコサイン） |
| [`T asin(T x);`](/reference/cmath/asin.md) | 逆正弦関数（アークサイン） |
| [`T atan(T x);`](/reference/cmath/atan.md) | 逆正接関数（アークタンジェント） |
| [`T cosh(T x);`](/reference/cmath/cosh.md) | 双曲線余弦関数（ハイパボリックコサイン） |
| [`T sinh(T x);`](/reference/cmath/sinh.md) | 双曲線正弦関数（ハイパボリックサイン） |
| [`T tanh(T x);`](/reference/cmath/tanh.md) | 双曲線正接関数（ハイパボリックタンジェント） |
| `T ldexp(T x, int);` | 2 の冪乗との乗算 |
| `T frexp(T x, int*);` | 仮数部と 2 の冪乗への分解 |
| [`T pow(T x, T y);`](/reference/cmath/pow.md) | 冪乗 |
| `T fmod(T x, T y);` | 浮動小数点剰余 |
| [`T atan2(T x, T y);`](/reference/cmath/atan2.md) | 対辺と隣辺からの逆正接関数（アークタンジェント） |


documented boost version is 1.53.0
