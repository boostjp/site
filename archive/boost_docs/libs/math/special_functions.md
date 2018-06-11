# Special Functions Documentation

- [Acknowledgements](#Acknowledgements)
- [Header Files](#Header_File)
- [Test Program](#Test_Program)
- [Synopsis](#Synopsis)
- [Functions](#Functions)
- [History](#History)

現在このライブラリは5つの"特殊な"数学関数を、boost名前空間で、テンプレートとして提供している。
この内、シンク関数とハイパボリックシンク関数(`sinc_pi`, `sinhc_pi`)は四元数と八元数を実装するのに必要である。

逆双曲関数( `acosh`, `asinh`, `atanh` )は全体的に古典的であり、シンク関数( `sinc_pi` )は信号処理の作業でよく使われるようだ。
また、双曲シンク関数( `sinhc_pi` )は、シンク関数( `sinc_pi` )と双曲関数( sinh, cosh, tanh )から名付けられており、*アドホックな* 関数である。

指数関数は、その意味が通る全ての対象に対して、
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb1.jpeg)
という級数関数で定義される。
ここで、
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb2.jpeg)
(
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb3.jpeg)
を自明とする)は
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb4.jpeg)
の階乗である。
特に、指数関数は、実数、複素数、四元数、八元数、複素数を要素にもつ行列に対して、自然に定義される。


### 実数Rを変数にとった指数関数expのグラフ

![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/exp_on_R.png)

### 複素数Cを変数にとった指数関数expの実部と虚部

![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/Re(exp)_on_C.png)
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/Im(exp)_on_C.png)

双曲関数は、(実数、複素数、四元数、八元数のために)数値計算可能な級数関数として以下のように定義する：

### 双曲余弦関数：

![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb5.jpeg)

### 双曲余弦関数：

![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb6.jpeg)

### 双曲正接関数：

![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb7.jpeg)

### 実数Rを変数にとった三角関数 (cos: 紫; sin: 赤; tan: 青)

![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/trigonometric.png)

### 実数Rを変数にとった双曲関数(cosh: 紫; sinh: 赤; tanh: 青)

![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/hyperbolic.png)

双曲正弦関数は無限小から無限大までの範囲の実数上で一対一対応である。
一方で、双曲正接関数は
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb8.jpeg)
の範囲の実数上で一対一対応である。
そして、この二つの関数は逆関数を持っている。
双曲余弦関数は、
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb9.jpeg)
の範囲の実数上では
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb10.jpeg)
の範囲で、また
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb11.jpeg)
の範囲の実数上では
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb12.jpeg)
の範囲で一対一対応である。
ここで使う逆関数は変域
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb13.jpeg)
、値域
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb14.jpeg)
で定義される。

双曲正接関数の逆関数は逆双曲正接関数と呼び、数値計算では次のように扱う。
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb15.jpeg)

双曲正弦関数の逆関数は逆双曲正弦関数と呼び、数値計算では次のように扱う。
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb17.jpeg)
ただし
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb16.jpeg)
である。

双曲余弦関数の逆関数は逆双曲余弦関数と呼び、数値計算では次のように扱う。
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb18.jpeg)

シンク関数は指数関数によって次のように定義される。
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb19.jpeg)
のとき
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb20.jpeg)

我々は類似のものとして双曲シンク関数を指数関数によって次のように定義する。
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb21.jpeg)
のとき
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb22.jpeg)
これもまた滑かな曲線を描く関数である。

### 実数Rを変数にとり、πを要素に持つシンク関数(紫)と双曲シンク関数(赤)

![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/sinc_pi_and_sinhc_pi_on_R.png)

## <a id="Acknowledgements">Acknowledgements</a>

数式の編集には [Nisus Writer](http://www.nisus-soft.com/) を、グラフ等の編集には [Graphing Calculator](http://www.pacifict.com/) を使用した。
Jens Maurer氏にはプレビューの管理で協力して戴いた。
諸々の感謝については History の部分で述べる。
このライブラリを議論し協力してくださった方々に感謝する。

## <a id="Header_File">Header Files</a>

次のヘッダ一つ一つが、それぞれの関数のインターフェースと実装を提供する：

- acosh.hpp
- asinh.hpp
- atahn.hpp
- sinc.hpp
- sinhc.hpp

## <a id="Test_Program">Test Program</a>

テストプログラム *special_functions_test.cpp* は、float, double, long double型での関数のテストを行なう。
(*出力サンプル*)

以下の環境で動作確認をした：

- PowerPC G3 -- CodeWarrior for Mac OS Professional Edition v6(Metroworks)

## <a id="Synopsis">Synopsis</a>

```cpp
namespace boost
{

	namespace math
	{

		template<typename T> inline T									acosh(const T x);

		template<typename T> inline T									asinh(const T x);

		template<typename T> inline T									atanh(const T x);

		template<typename T> inline T									sinc_pi(const T x);

		template<typename T, template<typename> class U>	inline U<T>	sinc_pi(const U<T> x);

		template<typename T> inline T									sinhc_pi(const T x);

		template<typename T, template<typename> class U>	inline U<T>	sinhc_pi(const U<T> x);

	}

}
```
* acosh[link #acosh]
* asinh[link #asinh]
* atanh[link #atanh]
* sinc_pi[link #sinc_pi]
* sinc_pi[link #sinc_pi]
* sinhc_pi[link #sinhc_pi]
* sinhc_pi[link #sinhc_pi]

## <a id="Functions">Functions</a>

ここで実装される関数は標準例外を投げるが、例外指定子は作られていない。

### <a id="acosh">`acosh`</a>

```cpp
template<typename T> inline T acosh(const T x);
```

![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb29.jpeg)
での双曲余弦関数の逆関数を、変数を `x` として数値計算する。
精度を確保するため、1付近ではテイラー級数を使い、無限大付近ではローレンツ級数を使っている。

`x`が
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb27.jpeg)
であるなら、例外を発生せずにNaNを返す。
環境によっては、代わりにドメインエラーが発生する。

### <a id="asinh">`asinh`</a>

```cpp
template<typename T> inline T asinh(const T x);
```

双曲正弦関数の逆関数を数値計算する。
精度を確保するため、原点付近ではテイラー級数を使い、無限大付近ではローレンツ級数を使っている。

### <a id="atanh">`atanh`</a>

```cpp
template<typename T> inline T atanh(const T x);
```

双曲正接関数の逆関数を数値計算する。
精度を確保するため、原点付近ではテイラー級数を使っている。

`x` の範囲が
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb25.jpeg)
もしくは
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb26.jpeg)
ならば、例外を発生せずにNaNを返す。
環境によっては、代わりにドメインエラーが発生する。

`x` の範囲が
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb23.jpeg)
ならば、無限小(`numeric_limits<T>::epsilon()`を意味する
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb28.jpeg)
を返す。
環境によっては、`out_of_range`例外が発生する。

`x` の範囲が
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb24.jpeg)
ならば、無限大( `numeric_limits<T>::epsilon()` を意味する
![](https://www.boost.org/doc/libs/1_31_0/libs/math/special_functions/graphics/special_functions_blurb28.jpeg)
を返す。
環境によっては、`out_of_range` 例外が発生する。

### <a id="sinc_pi">`sinc_pi`</a>

```cpp
template<typename T> inline T 									sinc_pi(const T x);
template<typename T, template<typename> class U> inline U<T>	sinc_pi(const U<T> x);
```

シンク関数を数値計算する。
二つめの書式は複素数、四元数、八元数等のためのものである。
精度を確保するため、テイラー級数を使っている。

### <a id="sinhc_pi">`sinhc_pi`</a>

```cpp
template<typename T> inline T									sinhc_pi(const T x);
template<typename T, template<typename> class U> inline U<T>	sinhc_pi(const U<T> x);
```

双曲シンク関数を数値計算する。
二つめの書式は複素数、四元数、八元数等のためのものである。
精度を確保するため、テイラー級数を使っている。

## <a id="History">History</a>

- 1.4.0 - 14/09/2001: Eric Ford氏により、`acosh`, `asinh` を追加。
	John Maddock氏が提案したGcc 2.9.xのための修正を適用。精度が向上。
	テストプログラムにより精度を検査。
- 1.3.2 - 07/07/2001: `math`名前空間を導入。
- 1.3.1 - 07/06/2001: boostを再検討した結果、`special_functions.hpp` を `atanh.hpp`, `sinc.hpp`, `sinhc.hpp` に分割。
	Daryle Walker氏により、コンパイルタイムを駆使し`atanh`の効率が向上。
	Peter Schmitteckert氏により、全ての関数の精度が向上。
- 1.3.0 - 26/03/2001: シンク関数、双曲シンク関数に複素数等を扱える書式を追加。
- 1.2.0 - 31/01/2001: 関数名の引数に依存した検索(Koenig lookup)のために一部修正。
- 1.1.0 - 23/01/2001: boostに統合。
- 1.0.0 - 10/08/1999: 公開開始。

### 訳注

アドホックな：双曲シンク関数は双曲正弦関数やシンク関数のように学会で名前の通った関数ではない。

---

Revised 27 September 2001 (c) Copyright Hubert Holin 2001.
Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies.
This software is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

---

Japanese Translation Copyright (C) 2003 Mikmai Hayato&lt;fermi_kami@ybb.ne.jp&gt;.

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。
このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。
また、いかなる目的に対しても、その利用が適していることを関知しない。

