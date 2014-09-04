#多倍長整数
多倍長整数を使用するには、[Boost Multiprecision Library](http://www.boost.org/libs/multiprecision/)を使用する。

Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>基本的な使い方](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>多倍長整数の種類](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>文字列からの変換](#TOC--2)</li><li class='goog-toc'>[<strong>4 </strong>文字列への変換](#TOC--3)</li><li class='goog-toc'>[<strong>5 </strong>異なる精度間で型変換する](#TOC--4)</li><li class='goog-toc'>[<strong>6 </strong>最小値を取得する](#TOC--5)</li><li class='goog-toc'>[<strong>7 </strong>最大値を取得する](#TOC--6)</li><li class='goog-toc'>[<strong>8 </strong>有限かどうかを判定する](#TOC--7)</li><li class='goog-toc'>[<strong>9 </strong>サポートされている数学関数一覧](#TOC--8)</li></ol>



###基本的な使い方
ここでは、Boost.Multiprecisionから提供される多倍長整数の、基本的な使い方を示す。
以下は、任意精度の符号あり多倍長整数である[`boost::multiprecision::cpp_int`](http://www.boost.org/doc/libs/release/libs/multiprecision/doc/html/boost_multiprecision/tut/ints/cpp_int.html)クラスを使用して、100の階乗を求めるプログラムである。

```cpp
#include <iostream>
#include <boost/multiprecision/cpp_int.hpp>

namespace mp = boost::multiprecision;

int main()
{
    mp::cpp_int x = 1;
    
    for (unsigned int i = 1; i <= 100; ++i)
       x *= i;

    std::cout << x << std::endl;
}
```
* cpp_int[color ff0000]

出力：
```cpp
93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000
```

`cpp_int`は、Boost.Multiprecisionが独自実装した演算をバックエンドに持つ、任意精度の多倍長整数である。この型は、メモリが許す限り無限の桁数を扱える。Boost.Multiprecisionが提供する全ての機能は、`boost::multiprecision`名前空間で定義される。

Boost.Multiprecisionの多倍長整数は、組み込みの整数型と同じ演算をサポートする。


| | |
|-------------------------------------------|-------------|
| `a + b;` `a += b;` | 加算 |
| `a - b;` `a -= b;` | 減算 |
| `a * b;` `a *= b;` | 乗算 |
| `a / b;` `a /= b;` | 除算 |
| `a % b;` `a %= b;` | 剰余算 |
| `+a;` | 符号をプラスにする |
| `-a;` | 符号をマイナスにする |
| `a++;` `++a;` | インクリメント |
| `a--;` `--a;` | デクリメント |
| `a & b;` `a &= b;` | ビットAND |
| <code>a &#x7C; b;</code> <code>a &#x7C;= b;</code> | ビットOR |
| `a ^ b;` `a ^= b;` | ビットXOR |
| `a << b;` `a <<= b;` | 左ビットシフト |
| `a >> b;` `a >>= b;` | 右ビットシフト |
| `a == b;` | 等値比較 |
| `a != b;` | 非等値比較 |
| `a < b;` | aがbより小さいかの判定 |
| `a <= b;` | aがb以下かの判定 |
| `a > b;` | aがbより大きいかの判定 |
| `a >= b;` | aがb以上かの判定 |
| `os << a;` | ストリームへの出力 |
| `is >> a;` | ストリームからの入力 |


###多倍長整数の種類
以下に、Boost.Multiprecisionから提供される多倍長整数の種類を示す。

<b>[Boost Multiprecision独自実装の多倍長整数](http://www.boost.org/doc/libs/release/libs/multiprecision/doc/html/boost_multiprecision/tut/ints/cpp_int.html)</b>
`#include <boost/multiprecision/cpp_int.hpp>`
符号付きチェックなし整数

| | |
|-----------------------------------------------------|------------------------------------|
| `cpp_int` | 任意精度の符号付き多倍長整数。 メモリが許す限り、無限の桁数を扱える。 |
| `int128_t` | 128ビット精度の符号付き整数。 |
| `int256_t` | 256ビット精度の符号付き整数。 |
| int512_t | 512ビット精度の符号付き整数。 |
| int1024_t | 1024ビット精度の符号付き整数。 |

符号なしチェックなし整数

| | |
|------------------------------------------------------|------------------|
| uint128_t | 128ビット精度の符号なし整数。 |
| uint256_t | 256ビット精度の符号なし整数。 |
| uint512_t | 512ビット精度の符号なし整数。 |
| uint1024_t | 1024ビット精度の符号なし整数。 |

符号付きチェック付き整数

| | |
|------------------|------------------------------------|
| checked_cpp_int | 任意精度の符号付き多倍長整数。 メモリが許す限り、無限の精度を扱える。 |
| checked_int128_t | 128ビット精度の符号付き整数。 |
| checked_int256_t | 256ビット精度の符号付き整数。 |
| checked_int512_t | 512ビット精度の符号付き整数。 |
| checked_int1024_t | 1024ビット精度の符号付き整数。 |

符号なしチェック付き整数

| | |
|--------------------------------------------------------------|------------------|
| checked_uint128_t | 128ビット精度の符号なし整数。 |
| cheked_uint256_t | 256ビット精度の符号なし整数。 |
| checked_uint512_t | 512ビット精度の符号なし整数。 |
| checked_uint1024_t | 1024ビット精度の符号なし整数。 |

チェック付き整数は、値が不正になる演算を行った際に例外を送出する。

チェックなし整数が送出する例外

| | |
|------|------------------------------------------------------------------------------------------------------------------|
| ゼロ割り時 | [`std::overflow_error`](/reference/stdexcept.md)例外が送出される |

チェック付き整数が送出する例外

| | |
|-----------------|------------------------------------------------------------------------------------------------------------------|
| ゼロ割り時 | [`std::overflow_error`](/reference/stdexcept.md)例外が送出される |
| 符号なしなのにマイナス値になった | [`std::range_error`](/reference/stdexcept.md)例外が送出される |
| オーバーフロー時 | [`std::overflow_error`](/reference/stdexcept.md)例外が送出される |
<b>[GMPバックエンドの多倍長整数](http://www.boost.org/doc/libs/release/libs/multiprecision/doc/html/boost_multiprecision/tut/ints/gmp_int.html)</b>
`#include <boost/multiprecision/gmp.hpp>`
符号ありチェックなし整数

| | |
|---------------------|---------------|
| `mpz_int` | 任意精度の符号付き多倍長整数 |
<b>[libtommathバックエンドの多倍長整数](http://www.boost.org/doc/libs/release/libs/multiprecision/doc/html/boost_multiprecision/tut/ints/tom_int.html)</b>
`#include <boost/multiprecision/tommath.hpp>`
符号ありチェックなし整数

| | |
|--------|---------------|
| tom_int | 任意精度の符号付き多倍長整数 |


###文字列からの変換
文字列から多倍長整数に変換するには、`explicit`な変換コンストラクタ、もしくは`assign()`メンバ関数を使用する。
文字列は、`char`配列および[`std::string`](/reference/string/basic_string.md)を受け取ることができる。

<b>コンストラクタで文字列から変換</b>
```cpp
#include <iostream>
#include <string>
#include <boost/multiprecision/cpp_int.hpp>

using namespace boost::multiprecision;

int main()
{
    cpp_int x("123");              // char配列から変換
    cpp_int y(std::string("456")); // std::stringから変換

    std::cout << x << std::endl;
    std::cout << y << std::endl;
}
```

出力：
```cpp
123
456
```

<b>assign()メンバ関数で文字列から変換</b>
```cpp
#include <iostream>
#include <boost/multiprecision/cpp_int.hpp>

using namespace boost::multiprecision;

int main()
{
    cpp_int x;
    x.assign("123");

    std::cout << x << std::endl;
}
```

出力：
```cpp
123
```

変換できない文字列が渡された場合は、[`std::runtime_error`](/reference/stdexcept.md)例外が送出される。


###文字列への変換
文字列への変換には、`str()`メンバ関数を使用する。この関数は、`std::string`型で多倍長整数の文字列表現を返す。
デフォルトでは10進数表現の文字列が返されるが、以下の引数を設定することで、精度と基数、その他出力方法を選択できる。

- 第1引数： 出力する精度。整数では単に無視されるので、0を指定すればよい。
- 第2引数： 出力フラグ。基数の選択。
```cpp
#include <iostream>
#include <boost/multiprecision/cpp_int.hpp>

using boost::multiprecision::cpp_int;

int main()
{
    cpp_int x = 123;

    // 10進数
    {
        const std::string s = x.str();
        std::cout << s << std::endl;
    }
    // 8進数
    {
        const std::string s = x.str(0, std::ios_base::oct);
        std::cout << s << std::endl;
    }
    // 16進数
    {
        const std::string s = x.str(0, std::ios_base::hex);
        std::cout << s << std::endl;
    }
}
```
* str[color ff0000]
* str[color ff0000]
* str[color ff0000]

出力：
```cpp
123
173
7B
```

###異なる精度間で型変換する
Boost.Multiprecisionの多倍長整数は、異なる精度間での変換をサポートしている。

<b>小さい精度から大きい精度への変換</b>
`int`や`long`型といった組み込みの整数型から、`int128_t`や`cpp_int`といった多倍長整数への暗黙変換が可能である。
また、`int128_t`から`int256`へ、といったより大きい精度への暗黙変換が可能である。

```cpp
#include <boost/multiprecision/cpp_int.hpp>

using namespace boost::multiprecision;

int main()
{
    // intからint128_tへの暗黙変換
    int i = 3;
    int128_t i128 = i; // OK

    // int128_tからint256_tへの暗黙変換
    int256_t i256 = i128; // OK
}
```

<b>大きい精度から小さい精度への変換</b>
小さい精度への変換は、データが失われる可能性があるため、暗黙の型変換はサポートしない。
明示的な型変換を使用する場合のみ変換可能である。

```cpp
#include <boost/multiprecision/cpp_int.hpp>

using namespace boost::multiprecision;

int main()
{
    int256_t i256 = 3;

//  int128_t i128 = i256; // コンパイルエラー！変換できない
    int128_t i128 = static_cast<int128_t>(i256); // OK
}
```

###最小値を取得する
多倍長整数の最小値を取得するには、[`std::numeric_limits`](/reference/limits/numeric_limits.md)クラスの[`min()`](/reference/limits/numeric_limits/min.md)静的メンバ関数を使用する。
任意精度整数である`cpp_int`は無限の桁数を持つため、最小値は取得できなかったものとして、0を返す。

```cpp
#include <iostream>
#include <boost/multiprecision/cpp_int.hpp>

namespace mp = boost::multiprecision;

int main()
{
    mp::cpp_int  x = std::numeric_limits<mp::cpp_int>::min();  // 任意精度
    mp::int128_t y = std::numeric_limits<mp::int128_t>::min(); // 固定精度

    std::cout << x << std::endl;
    std::cout << y << std::endl;
}
```
* min[color ff0000]
* min[color ff0000]

出力：
```cpp
0
-340282366920938463463374607431768211455
```

###最大値を取得する
多倍長整数の最大値を取得するには、[`std::numeric_limits`](/reference/limits/numeric_limits.md)クラスの[`max()`](/reference/limits/numeric_limits/max.md)静的メンバ関数を使用する。
任意精度整数である`cpp_int`は無限の桁数を持つため、最大値は取得できなかったものとして、0を返す。

```cpp
#include <iostream>
#include <boost/multiprecision/cpp_int.hpp>

namespace mp = boost::multiprecision;

int main()
{
    mp::cpp_int  x = std::numeric_limits<mp::cpp_int>::max();  // 任意精度
    mp::int128_t y = std::numeric_limits<mp::int128_t>::max(); // 固定精度

    std::cout << x << std::endl;
    std::cout << y << std::endl;
}
```
* max[color ff0000]
* max[color ff0000]

出力：
```cpp
0
340282366920938463463374607431768211455
```

###有限かどうかを判定する
多倍長整数型の表す値が有限かどうかを判定するには、[`std::numeric_limits`](/reference/limits/numeric_limits.md)クラスの[`is_bounded`](/reference/limits/numeric_limits/is_bounded.md)定数を取得する。
[`is_bounded`](/reference/limits/numeric_limits/is_bounded.md)は`bool`型で定義され、有限であれば`true`、無限であれば`false`が設定される。

任意精度整数である`cpp_int`は無限の桁数を持つため、[`is_bounded`](/reference/limits/numeric_limits/is_bounded.md)は`false`となる。
固定精度整数の`int128_t`、`int256_t`といった型の場合、[`is_bounded`](/reference/limits/numeric_limits/is_bounded.md)は`true`となる。

```cpp
#include <iostream>
#include <boost/multiprecision/cpp_int.hpp>

namespace mp = boost::multiprecision;

int main()
{
    constexpr bool x = std::numeric_limits<mp::cpp_int>::is_bounded;  // 任意精度
    constexpr bool y = std::numeric_limits<mp::int128_t>::is_bounded; // 固定精度

    std::cout << std::boolalpha;
    std::cout << x << std::endl;
    std::cout << y << std::endl;
}
```
* is_bounded[color ff0000]
* is_bounded[color ff0000]

出力：
```cpp
false
true
```

###サポートされている数学関数一覧
<b>標準関数サポート</b>
標準ライブラリで定義される以下の関数は、Boost.Multiprecisionの多倍長整数でも使用できる。
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

<b>整数に特化した数学関数サポート</b>
以下の関数は、Boost.Multiprecisionで整数演算に特化したものとして、`boost::multiprecision`名前空間で定義される。

| | |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [`T pow(T x, unsigned int y);`](/reference/cmath/pow.md) | 冪乗 |
| `T powm(T b, T p, T m);` | 冪剰余 |
| `void divide_qr(T x, y, T& q, T& r);` | 除算と剰余算を同時に行う |
| `template <class Integer>` `Integer integer_modulus(T x, Integer val);` | 剰余の絶対値 |
| `unsigned int lsb(T x);` | 1に設定されている最下位ビットのインデックスを取得する |
| `bool bit_test(T val, unsigned index);` | 指定されたインデックスのビットが1に設定されているかを判定する |
| `T& bit_set(T& val, unsigned index);` | 指定されたインデックスのビットを1に設定する |
| `T& bit_unset(T& val, unsigned index);` | 指定されたインデックスのビットを0に設定する |
| `T& bit_flip(T& val, unsigned index);` | 指定されたインデックスのビットを反転する |
| `template <class Engine>` `bool miller_rabin_test(T n, unsigned trials, Engine& gen);` `bool miller_rabin_test(T n, unsigned trials);` | ミラー・ラビン素数判定 参照： [Boost.Multiprecision ミラー・ラビン法による素数判定 - Faith and Brave - C++で遊ぼう](http://d.hatena.ne.jp/faith_and_brave/20130222/1361516978) |

参照： [Integer functions - Boost Multiprecision Library](http://www.boost.org/doc/libs/release/libs/multiprecision/doc/html/boost_multiprecision/ref/number.html#boost_multiprecision.ref.number.integer_functions)

documented boost version is 1.53.0

