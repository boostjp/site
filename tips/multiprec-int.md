#多倍長整数
多倍長整数を使用するには、[Boost Multiprecision Library](http://www.boost.org/libs/multiprecision/)を使用する。


##インデックス
- [基本的な使い方](#basic-usage)
- [多倍長整数の種類](#variation)
- [文字列からの変換](#from-string)
- [文字列への変換](#to-string)
- [異なる大きさの整数間で型変換する](#convert-integer)
- [最小値を取得する](#min)
- [最大値を取得する](#max)
- [有限かどうかを判定する](#is-bounded)
- [サポートされている数学関数一覧]


## <a name="basic-usage" href="basic-usage">基本的な使い方</a>
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
```
93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000
```

`cpp_int`は、Boost.Multiprecisionが独自実装した演算をバックエンドに持つ、任意精度の多倍長整数である。この型は、メモリが許す限り無限の桁数を扱える。Boost.Multiprecisionが提供する全ての機能は、`boost::multiprecision`名前空間以下で定義される。

Boost.Multiprecisionの多倍長整数は、組み込みの整数型と同じ演算をサポートする。

| 式 | 説明 |
|-------------------------------------------|-------------|
| `a + b;`<br/> `a += b;`   | 加算 |
| `a - b;`<br/> `a -= b;`   | 減算 |
| `a * b;`<br/> `a *= b;`   | 乗算 |
| `a / b;`<br/> `a /= b;`   | 除算 |
| `a % b;`<br/> `a %= b;`   | 剰余算 |
| `+a;`                     | 符号をプラスにする |
| `-a;`                     | 符号をマイナスにする |
| `a++;`<br/> `++a;`        | インクリメント |
| `a--;`<br/> `--a;`        | デクリメント |
| `a & b;`<br/> `a &= b;`   | ビットAND |
| <code>a &#x7C; b;</code><br/> <code>a &#x7C;= b;</code> | ビットOR |
| `a ^ b;`<br/> `a ^= b;`   | ビットXOR |
| `a << b;`<br/> `a <<= b;` | 左ビットシフト |
| `a >> b;`<br/> `a >>= b;` | 右ビットシフト |
| `a == b;`                 | 等値比較 |
| `a != b;`                 | 非等値比較 |
| `a < b;`                  | `a`が`b`より小さいかの判定 |
| `a <= b;`                 | `a`が`b`以下かの判定 |
| `a > b;`                  | `a`が`b`より大きいかの判定 |
| `a >= b;`                 | `a`が`b`以上かの判定 |
| `os << a;`                | ストリームへの出力 |
| `is >> a;`                | ストリームからの入力 |


## <a name="variation" href="variation">多倍長整数の種類</a>
以下に、Boost.Multiprecisionから提供される多倍長整数の種類を示す。

**[Boost Multiprecision独自実装の多倍長整数](http://www.boost.org/doc/libs/release/libs/multiprecision/doc/html/boost_multiprecision/tut/ints/cpp_int.html)**

```cpp
#include <boost/multiprecision/cpp_int.hpp>
```

符号付きチェックなし整数：

| 型 | 説明 |
|-------------|------------------------------------|
| `cpp_int`   | 任意精度の符号付き多倍長整数。 メモリが許す限り、無限の桁数を扱える。 |
| `int128_t`  | 128ビット精度の符号付き整数。 |
| `int256_t`  | 256ビット精度の符号付き整数。 |
| `int512_t`  | 512ビット精度の符号付き整数。 |
| `int1024_t` | 1024ビット精度の符号付き整数。 |


符号なしチェックなし整数：

| 型 | 説明 |
|--------------|------------------|
| `uint128_t`  | 128ビット精度の符号なし整数。 |
| `uint256_t`  | 256ビット精度の符号なし整数。 |
| `uint512_t`  | 512ビット精度の符号なし整数。 |
| `uint1024_t` | 1024ビット精度の符号なし整数。 |


符号付きチェック付き整数：

| 型 | 説明 |
|---------------------|------------------------------------|
| `checked_cpp_int`   | 任意精度の符号付き多倍長整数。 メモリが許す限り、無限の精度を扱える。 |
| `checked_int128_t`  | 128ビット精度の符号付き整数。 |
| `checked_int256_t`  | 256ビット精度の符号付き整数。 |
| `checked_int512_t`  | 512ビット精度の符号付き整数。 |
| `checked_int1024_t` | 1024ビット精度の符号付き整数。 |


符号なしチェック付き整数：

| 型 | 説明 |
|----------------------|------------------|
| `checked_uint128_t`  | 128ビット精度の符号なし整数。 |
| `cheked_uint256_t`   | 256ビット精度の符号なし整数。 |
| `checked_uint512_t`  | 512ビット精度の符号なし整数。 |
| `checked_uint1024_t` | 1024ビット精度の符号なし整数。 |


チェック付き整数は、値が不正になる演算を行った際に例外を送出する。

チェックなし整数が送出する例外：

| 条件       | 送出する例外 |
|------------|------------------------------------------------------------------|
| ゼロ割り時 | [`std::overflow_error`][stdexcept]例外が送出される |


チェック付き整数が送出する例外：

| 条件 | 送出する例外 |
|----------------------------------|----------------------------------------------------|
| ゼロ割り時                       | [`std::overflow_error`][stdexcept]例外が送出される |
| 符号なしなのにマイナス値になった | [`std::range_error`][stdexcept]例外が送出される    |
| オーバーフロー時                 | [`std::overflow_error`][stdexcept]例外が送出される |

[stdexcept]: https://sites.google.com/site/cpprefjp/reference/stdexcept


**[GMPバックエンドの多倍長整数](http://www.boost.org/doc/libs/release/libs/multiprecision/doc/html/boost_multiprecision/tut/ints/gmp_int.html)**

```cpp
#include <boost/multiprecision/gmp.hpp>
```

符号ありチェックなし整数：

| 型 | 説明 |
|-----------|---------------|
| `mpz_int` | 任意精度の符号付き多倍長整数 |


**[libtommathバックエンドの多倍長整数](http://www.boost.org/doc/libs/release/libs/multiprecision/doc/html/boost_multiprecision/tut/ints/tom_int.html)**

```cpp
#include <boost/multiprecision/tommath.hpp>
```

符号ありチェックなし整数：

| 型 | 説明 |
|-----------|---------------|
| `tom_int` | 任意精度の符号付き多倍長整数 |


## <a name="from-string" href="from-string">文字列からの変換</a>
文字列から多倍長整数に変換するには、`explicit`な変換コンストラクタ、もしくは`assign()`メンバ関数を使用する。

文字列は、`char`配列および[`std::string`](https://sites.google.com/site/cpprefjp/reference/string/basic_string)を受け取ることができる。


**コンストラクタで文字列から変換**

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
```
123
456
```


**`assign()`メンバ関数で文字列から変換**

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
```
123
```

変換できない文字列が渡された場合は、[`std::runtime_error`](https://sites.google.com/site/cpprefjp/reference/stdexcept)例外が送出される。


## <a name="to-string" href="to-string">文字列への変換</a>
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

出力：
```
123
173
7B
```

## <a name="convert-integer" href="convert-integer">異なる大きさの整数間で型変換する</a>
Boost.Multiprecisionの多倍長整数は、異なる精度間での変換をサポートしている。


**小さい整数型から大きい整数型への変換**

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


**大きい精度から小さい精度への変換**

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


## <a name="min" href="min">最小値を取得する</a>
多倍長整数の最小値を取得するには、[`std::numeric_limits`](https://sites.google.com/site/cpprefjp/reference/limits/numeric_limits)クラスの[`min()`](https://sites.google.com/site/cpprefjp/reference/limits/numeric_limits/min)静的メンバ関数を使用する。

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

出力：
```
0
-340282366920938463463374607431768211455
```


## <a name="max" href="max">最大値を取得する</a>
多倍長整数の最大値を取得するには、[`std::numeric_limits`](https://sites.google.com/site/cpprefjp/reference/limits/numeric_limits)クラスの[`max()`](https://sites.google.com/site/cpprefjp/reference/limits/numeric_limits/max)静的メンバ関数を使用する。

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

出力：
```
0
340282366920938463463374607431768211455
```


## <a name="is-bounded" href="is-bounded">有限かどうかを判定する</a>
多倍長整数型の表す値が有限かどうかを判定するには、[`std::numeric_limits`](https://sites.google.com/site/cpprefjp/reference/limits/numeric_limits)クラスの[`is_bounded`](https://sites.google.com/site/cpprefjp/reference/limits/numeric_limits/is_bounded)定数を取得する。

[`is_bounded`](https://sites.google.com/site/cpprefjp/reference/limits/numeric_limits/is_bounded)は`bool`型で定義され、有限であれば`true`、無限であれば`false`が設定される。

任意精度整数である`cpp_int`は無限の桁数を持つため、[`is_bounded`](https://sites.google.com/site/cpprefjp/reference/limits/numeric_limits/is_bounded)は`false`となる。

固定精度整数の`int128_t`、`int256_t`といった型の場合、[`is_bounded`](https://sites.google.com/site/cpprefjp/reference/limits/numeric_limits/is_bounded)は`true`となる。

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

出力：
```
false
true
```


## <a name="math-functions" href="math-functions">サポートされている数学関数一覧</a>

**標準関数サポート**

標準ライブラリで定義される以下の関数は、Boost.Multiprecisionの多倍長整数でも使用できる。

これらの関数は、`boost::multiprecision`名前空間で定義される。


| 関数 | 説明 |
|-------------------------------------------|-------------------------|
| `T abs(T x);`<br/> [`T fabs(T x);`][fabs] | 絶対値 |
| [`T sqrt(T x);`][sqrt]        | 平方根 |
| `T floor(T x);`               | 床関数（引数より大きくない最近傍の整数） |
| `T ceil(T x);`                | 天井関数（引数より小さくない最近傍の整数） |
| `T trunc(T x);`<br/> `T itrunc(T x);`<br/> `T ltrunc(T x);`<br/> `T lltrunc(T x);` | ゼロ方向への丸め |
| `T round(T x);`<br/> `T lround(T x);`<br/> `T llround(T x);` | 四捨五入による丸め |
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
| `T ldexp(T x, int);`          | 2 の冪乗との乗算 |
| `T frexp(T x, int*);`         | 仮数部と 2 の冪乗への分解 |
| [`T pow(T x, T y);`][pow]     | 冪乗 |
| `T fmod(T x, T y);`           | 浮動小数点剰余 |
| [`T atan2(T x, T y);`][atan2] | 対辺と隣辺からの逆正接関数（アークタンジェント） |

[fabs]: https://sites.google.com/site/cpprefjp/reference/cmath/fabs
[sqrt]: https://sites.google.com/site/cpprefjp/reference/cmath/sqrt
[exp]: https://sites.google.com/site/cpprefjp/reference/cmath/exp
[log]: https://sites.google.com/site/cpprefjp/reference/cmath/log
[log10]: https://sites.google.com/site/cpprefjp/reference/cmath/log10
[cos]: https://sites.google.com/site/cpprefjp/reference/cmath/cos
[sin]: https://sites.google.com/site/cpprefjp/reference/cmath/sin
[tan]: https://sites.google.com/site/cpprefjp/reference/cmath/tan
[acos]: https://sites.google.com/site/cpprefjp/reference/cmath/acos
[asin]: https://sites.google.com/site/cpprefjp/reference/cmath/asin
[atan]: https://sites.google.com/site/cpprefjp/reference/cmath/atan
[cosh]: https://sites.google.com/site/cpprefjp/reference/cmath/cosh
[sinh]: https://sites.google.com/site/cpprefjp/reference/cmath/sinh
[tanh]: https://sites.google.com/site/cpprefjp/reference/cmath/tanh
[pow]: https://sites.google.com/site/cpprefjp/reference/cmath/pow
[atan2]: https://sites.google.com/site/cpprefjp/reference/cmath/atan2


**整数に特化した数学関数サポート**

以下の関数は、Boost.Multiprecisionで整数演算に特化したものとして、`boost::multiprecision`名前空間で定義される。

| 関数 | 説明 |
|-------------------------------------------|-------------------------------------------|
| [`T pow(T x, unsigned int y);`][pow]    | 冪乗 |
| `T powm(T b, T p, T m);`                | 冪剰余 |
| `void divide_qr(T x, y, T& q, T& r);`   | 除算と剰余算を同時に行う |
| `template <class Integer>`<br/> `Integer integer_modulus(T x, Integer val);` | 剰余の絶対値 |
| `unsigned int lsb(T x);`                | 1に設定されている最下位ビットのインデックスを取得する |
| `bool bit_test(T val, unsigned index);` | 指定されたインデックスのビットが1に設定されているかを判定する |
| `T& bit_set(T& val, unsigned index);`   | 指定されたインデックスのビットを1に設定する |
| `T& bit_unset(T& val, unsigned index);` | 指定されたインデックスのビットを0に設定する |
| `T& bit_flip(T& val, unsigned index);`  | 指定されたインデックスのビットを反転する |
| `template <class Engine>`<br/> `bool miller_rabin_test(T n, unsigned trials, Engine& gen);`<br/> `bool miller_rabin_test(T n, unsigned trials);` | ミラー・ラビン素数判定<br/> 参照： [Boost.Multiprecision ミラー・ラビン法による素数判定 - Faith and Brave - C++で遊ぼう](http://d.hatena.ne.jp/faith_and_brave/20130222/1361516978) |

参照： [Integer functions - Boost Multiprecision Library](http://www.boost.org/doc/libs/release/libs/multiprecision/doc/html/boost_multiprecision/ref/number.html#boost_multiprecision.ref.number.integer_functions)

documented boost version is 1.53.0

