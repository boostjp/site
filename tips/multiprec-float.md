# 多倍長浮動小数点数
多倍長浮動小数点数を使用するには、[Boost Multiprecision Library](http://www.boost.org/libs/multiprecision/)を使用する。


## インデックス
- [基本的な使い方](#basic-usage)
- [多倍長浮動小数点数の種類](#variation)
- [文字列からの変換](#from-string)
- [文字列への変換](#to-string)
- [異なる精度間で型変換する](#convert-precision)
- [サポートされている数学関数一覧](#math-functions)


## <a id="basic-usage" href="#basic-usage">基本的な使い方</a>
ここでは、Boost.Multiprecisionから提供される多倍長浮動小数点数の、基本的な使い方を示す。

以下は、任意精度の符号あり多倍長整数である[`boost::multiprecision::cpp_dec_float_100`](http://www.boost.org/doc/libs/release/libs/multiprecision/doc/html/boost_multiprecision/tut/floats/cpp_dec_float.html)クラス型を使用して、2の平方根を求めるプログラムである。

```cpp example
#include <iostream>
#include <boost/multiprecision/cpp_dec_float.hpp>

namespace mp = boost::multiprecision;

int main()
{
    // 仮数部100ビット、指数部32ビットの浮動小数点数
    mp::cpp_dec_float_100 x = 2.0f;

    // 平方根を求める
    mp::cpp_dec_float_100 result = mp::sqrt(x);

    // 出力桁数を設定して出力
    std::cout << std::setprecision(std::numeric_limits<decltype(x)>::digits10 + 1)
              << result;
}
```
* cpp_dec_float_100 x = 2.0f;[color ff0000]

出力：
```
1.4142135623730950488016887242096980785696718753769480731766797379907324784621070388503875343276415727
```

Boost.Multiprecisionの多倍長浮動小数点数は、以下の演算をサポートする。ビット演算は使用できない。


| 式                      | 説明 |
|-------------------------|------|
| `a + b;`<br/> `a += b;` | 加算 |
| `a - b;`<br/> `a -= b;` | 減算 |
| `a * b;`<br/> `a *= b;` | 乗算 |
| `a / b;`<br/> `a /= b;` | 除算 |
| `+a;`                   | 符号をプラスにする |
| `-a;`                   | 符号をマイナスにする |
| `a++;`<br/> `++a;`      | インクリメント |
| `a--;`<br/> `--a;`      | デクリメント |
| `a == b;`               | 等値比較 |
| `a != b;`               | 非等値比較 |
| `a < b;`                | `a`が`b`より小さいかの判定 |
| `a <= b;`               | `a`が`b`以下かの判定 |
| `a > b;`                | `a`が`b`より大きいかの判定 |
| `a >= b;`               | `a`が`b`以上かの判定 |
| `os << a;`              | ストリームへの出力 |
| `is >> a;`              | ストリームからの入力 |


## <a id="variation" href="#variation">多倍長浮動小数点数の種類</a>
以下に、Boost.Multiprecisionから提供される多倍長整数の種類を示す。

**[Boost Multiprecision独自実装の多倍長浮動小数点数](http://www.boost.org/doc/libs/release/libs/multiprecision/doc/html/boost_multiprecision/tut/floats/cpp_dec_float.html)**

```cpp
#include <boost/multiprecision/cpp_dec_float.hpp>
```

| 型                  | 説明 |
|---------------------|--------------------|
| `cpp_dec_float_50`  | 仮数部が50ビットの浮動小数点数型  |
| `cpp_dec_float_100` | 仮数部が100ビットの浮動小数点数型 |

以下は、ユーザー定義の固定精度浮動小数点数型を定義する例である：

```cpp
// 仮数部1,000ビットを持つ浮動小数点数の定義
namespace mp = boost::multiprecision;
typedef mp::number<mp::cpp_dec_float<1000> > cpp_dec_float_1000;

// 仮数部1,000ビット、指数部64ビットを持つ浮動小数点数の定義
namespace mp = boost::multiprecision;
typedef mp::number<mp::cpp_dec_float<1000, std::uint64_t> > cpp_dec_float_1000_64exp;
```

独自実装の多倍長浮動小数点数の特徴：

- デフォルト値は0である
- 基数は10。基数2ベースとは異なる振る舞いが可能
- `infinity`と`NaN`をサポートする。オーバーフローやゼロ割り時には、組み込みの浮動小数点数型と同じ振る舞いをする。
- 全ての操作は、常に切り捨てを行う


**[GMPバックエンドの多倍長浮動小数点数](http://www.boost.org/doc/libs/release/libs/multiprecision/doc/html/boost_multiprecision/tut/floats/gmp_float.html)**

```cpp
#include <boost/multiprecision/gmp.hpp>
```

| 型               | 説明 |
|------------------|---------------------------------------|
| `mpf_float_50`   | 仮数部が50ビットの浮動小数点数型    |
| `mpf_float_100`  | 仮数部が100ビットの浮動小数点数型   |
| `mpf_float_500`  | 仮数部が500ビットの浮動小数点数型   |
| `mpf_float_1000` | 仮数部が1,000ビットの浮動小数点数型 |
| `mpf_float`      | 仮数部が任意ビット使用可能な浮動小数点数型  |

以下は、ユーザー定義の固定精度浮動小数点数型を定義する例である：

```cpp
// 仮数部が10,000ビットの浮動小数点数型の定義
namespace mp = boost::multiprecision;
typedef mp::number<mp::gmp_float<10000> > mpf_dec_float_10000;
```

`gmp_float`のテンプレート引数として0を指定すると、任意長の仮数部が表現可能になる。

GMP多倍長浮動小数点数の特徴：

- デフォルト値は0である
- GMPのグローバル設定を変更しない
- GMPは`infinity`や`NaN`といった概念を持たないため、可能な限りオーバーフローやゼロ割りは避けること。オーバーフロー時またはゼロ割り時には`std::overflow_error`例外が送出される。


**MPFRバックエンドの多倍長浮動小数点数**

```cpp
#include <boost/multiprecision/mpfr.hpp>
```

動的メモリ確保を行う多倍長浮動小数点数：

- [MPFRバックエンドの多倍長浮動小数点数](http://www.boost.org/doc/libs/release/libs/multiprecision/doc/html/boost_multiprecision/tut/floats/mpfr_float.html)

| 型 | 説明 |
|-------------------|---------------------------------------|
| `mpfr_float_50`   | 仮数部が50ビットの浮動小数点数型    |
| `mpfr_float_100`  | 仮数部が100ビットの浮動小数点数型   |
| `mpfr_float_500`  | 仮数部が500ビットの浮動小数点数型   |
| `mpfr_float_1000` | 仮数部が1,000ビットの浮動小数点数型 |
| `mpfr_float`      | 仮数部が任意ビット使用可能な浮動小数点数型  |


動的メモリ確保を行わない多倍長浮動小数点数

| 型 | 説明 |
|-------------------------|--------------------|
| `static_mpfr_float_50`  | 仮数部が50ビットの浮動小数点数型 |
| `static_mpfr_float_100` | 仮数部が100ビットの浮動小数点数型 |


以下は、ユーザー定義の、動的メモリ確保を行う固定精度浮動小数点数型を定義する例である：

```cpp
// 仮数部を10,000ビットの浮動小数点数型の定義
namespace mp = boost::multiprecision;
typedef mp::number<mp::mpfr_float_backend<10000> > mpf_dec_float_10000;
```

`mpfr_float_backend`の第2テンプレート引数として`boost::multiprecision::allocate_stack`列挙値を指定することで、動的メモリ確保を行わない多倍長浮動小数点数型の定義ができる。

MPFR多倍長浮動小数点数の特徴：

- デフォルト値は`NaN`である
- 全ての操作は、最近接値への丸めを使用する
- GMPとMPFRのグローバル設定を変更しない
- 0で割ると`infinity`になる


## <a id="from-string" href="#from-string">文字列からの変換</a>
文字列から多倍長浮動小数点数に変換するには、`explicit`な変換コンストラクタ、もしくは`assign()`メンバ関数を使用する。
文字列は、`char`配列および[`std::string`](https://cpprefjp.github.io/reference/string/basic_string.html)を受け取ることができる。


**コンストラクタで文字列から変換**

```cpp example
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
```
3.14
3.14
```


**`assign()`メンバ関数で文字列から変換**

```cpp example
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
```
3.14
```

変換できない文字列が渡された場合は、[`std::runtime_error`](https://cpprefjp.github.io/reference/stdexcept.html)例外が送出される。


## <a id="to-string" href="#to-string">文字列への変換</a>
文字列への変換には、`str()`メンバ関数を使用する。この関数は、`std::string`型で多倍長浮動小数点数の文字列表現を返す。

デフォルトでは固定小数点表記の文字列が返されるが、以下の引数を設定することで、精度と表記、その他出力方法を選択できる。

- 第1引数： 出力する精度。0を指定した場合、できるだけ多くの桁数を出力する。
- 第2引数： 出力フラグ。

```cpp example
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
```
3.140000000000000124344978758017532527446746826171875
3.1400000000000001243449787580175325274467468261718750000000000000000000000
3.1400000000000001243449787580175325274467468261718750000000000000000000000e+00
```


## <a id="convert-precision" href="#convert-precision">異なる精度間で型変換する</a>
Boost.Multiprecisionの多倍長浮動小数点数は、異なる精度間での変換をサポートしている。


**小さい精度から大きい精度への変換**

`float`や`double`型といった組み込みの浮動小数点数型から、`cpp_dec_float_50`や`cpp_dec_float_100`といった多倍長浮動小数点数への暗黙変換が可能である。

また、`cpp_dec_float_50`から`cpp_dec_float_100`へ、といったより大きい精度への暗黙変換が可能である。

```cpp example
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


**大きい精度から小さい精度への変換**

小さい精度への変換は、データが失われる可能性があるため、暗黙の型変換はサポートしない。

明示的な型変換を使用する場合のみ変換可能である。

```cpp example
#include <boost/multiprecision/cpp_dec_float.hpp>

using namespace boost::multiprecision;

int main()
{
    cpp_dec_float_100 f100 = 3.14;

//  cpp_dec_float_50 f50 = f100; // コンパイルエラー！変換できない
    cpp_dec_float_50 f50 = static_cast<cpp_dec_float_50>(f100); // OK
}
```


## <a id="math-functions" href="#math-functions">サポートされている数学関数一覧</a>

**標準関数サポート**

標準ライブラリで定義される以下の関数は、Boost.Multiprecisionの多倍長浮動小数点数でも使用できる。

これらの関数は、`boost::multiprecision`名前空間で定義される。


| 関数 | 説明 |
|----------------------------------------------------------|-------------------------|
| `T abs(T x);`<br/> [`T fabs(T x);`][fabs] | 絶対値 |
| [`T sqrt(T x);`][sqrt]        | 平方根 |
| [`T floor(T x);`][floor]      | 床関数（引数より大きくない最近傍の整数） |
| [`T ceil(T x);`][ceil]        | 天井関数（引数より小さくない最近傍の整数） |
| [`T trunc(T x);`][trunc]<br/> `T itrunc(T x);`<br/> `T ltrunc(T x);`<br/> `T lltrunc(T x);` | ゼロ方向への丸め |
| [`T round(T x);`][round]<br/> `T lround(T x);`<br/> `T llround(T x);`                       | 四捨五入による丸め |
| [`T exp(T x);`][exp]          | e (ネイピア数) を底とする指数関数 |
| [`T log(T x);`][log]          | e (ネイピア数) を底とする自然対数 |
| [`T log10(T x);`][log10]      | 10 を底とする常用対数 |
| [`T cos(T x);`][cos]          | 余弦関数（コサイン） |
| [`T sin(T x);`][sin]          | 正弦関数（サイン） |
| [`T tan(T x);`][tan]          | 正接関数（タンジェント） |
| [`T acos(T x);`][acos]        | 逆余弦関数（アークコサイン） |
| [`T asin(T x);`][asin]        | 逆正弦関数（アークサイン） |
| [`T atan(T x);`][atan]        | 逆正接関数（アークタンジェント） |
| [`T cosh(T x);`][cosh]        | 双曲線余弦関数（ハイパボリックコサイン） |
| [`T sinh(T x);`][sinh]        | 双曲線正弦関数（ハイパボリックサイン） |
| [`T tanh(T x);`][tanh]        | 双曲線正接関数（ハイパボリックタンジェント） |
| [`T ldexp(T x, int);`][ldexp]  | 2 の冪乗との乗算 |
| [`T frexp(T x, int*);`][frexp] | 仮数部と 2 の冪乗への分解 |
| [`T pow(T x, T y);`][pow]     | 冪乗 |
| [`T fmod(T x, T y);`][fmod]   | 浮動小数点剰余 |
| [`T atan2(T x, T y);`][atan2] | 対辺と隣辺からの逆正接関数（アークタンジェント） |

[fabs]: https://cpprefjp.github.io/reference/cmath/fabs.html
[floor]: https://cpprefjp.github.io/reference/cmath/floor.html
[ceil]: https://cpprefjp.github.io/reference/cmath/ceil.html
[trunc]: https://cpprefjp.github.io/reference/cmath/trunc.html
[round]: https://cpprefjp.github.io/reference/cmath/round.html
[sqrt]: https://cpprefjp.github.io/reference/cmath/sqrt.html
[exp]: https://cpprefjp.github.io/reference/cmath/exp.html
[log]: https://cpprefjp.github.io/reference/cmath/log.html
[log10]: https://cpprefjp.github.io/reference/cmath/log10.html
[cos]: https://cpprefjp.github.io/reference/cmath/cos.html
[sin]: https://cpprefjp.github.io/reference/cmath/sin.html
[tan]: https://cpprefjp.github.io/reference/cmath/tan.html
[acos]: https://cpprefjp.github.io/reference/cmath/acos.html
[asin]: https://cpprefjp.github.io/reference/cmath/asin.html
[atan]: https://cpprefjp.github.io/reference/cmath/atan.html
[cosh]: https://cpprefjp.github.io/reference/cmath/cosh.html
[sinh]: https://cpprefjp.github.io/reference/cmath/sinh.html
[tanh]: https://cpprefjp.github.io/reference/cmath/tanh.html
[ldexp]: https://cpprefjp.github.io/reference/cmath/ldexp.html
[frexp]: https://cpprefjp.github.io/reference/cmath/frexp.html
[pow]: https://cpprefjp.github.io/reference/cmath/pow.html
[fmod]: https://cpprefjp.github.io/reference/cmath/fmod.html
[atan2]: https://cpprefjp.github.io/reference/cmath/atan2.html

documented boost version is 1.53.0
