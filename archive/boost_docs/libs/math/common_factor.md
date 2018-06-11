# Greatest Common Divisor & Least Common Multiple

`<boost/math/common_factor.hpp>` にあるクラステンプレート、関数テンプレートは、2つの整数の最大公約数(GCD)と最小公倍数(LCM)の実行時、及びコンパイル時における評価を提供する。
これらの機能は多くの数学指向のジェネリックプログラミングの問題に対して有用である。

## <a id="contents">Contents</a>

- [Contents](#contents)
- Header [`<boost/math/common_factor.hpp>`](#cf_hpp)
	- [Synopsis](#synopsis)
- Header [`<boost/math/common_factor_rt.hpp>`](#cfrt_hpp)
	- [GCD Function Object](#gcd_obj)
	- [LCM Function Object](#lcm_obj)
	- [Run-time GCD & LCM Determination](#run_gcd_lcm)
- [`<boost/math/common_factor_ct.hpp>`](#cfct_hpp)
- [Example](#example)
- [Demonstration Program](#demo)
- [Rationale](#rationale)
- [History](#history)
- [Credits](#credits)

## Header <a id="cf_hpp">`<boost/math/common_factor.hpp>`</a>

このヘッダは単に `<boost/math/common_factor_ct.hpp>` と `<boost/math/common_factor_rt.hpp>` をインクルードしているのみである。
以前はコードを含んでいたが、 コンパイル時及び実行時の機能が(これらは独立していたので)別々のヘッダに移されたため、このヘッダは互換性のために維持されている。

### <a id="synopsis">Synopsis</a>

```cpp
namespace boost
{
	namespace math
	{

		template < typename IntegerType >
			class gcd_evaluator;
		template < typename IntegerType >
			class lcm_evaluator;

		template < typename IntegerType >
			IntegerType  gcd( IntegerType const &a, IntegerType const &b );
		template < typename IntegerType >
			IntegerType  lcm( IntegerType const &a, IntegerType const &b );

		template < unsigned long Value1, unsigned long Value2 >
			struct static_gcd;
		template < unsigned long Value1, unsigned long Value2 >
			struct static_lcm;

	}
}
```

## Header <a id="cfrt_hpp">`<boost/math/common_factor_rt.hpp>`</a>

### <a id="gcd_obj">GCD Function Object</a>

```cpp
template < typename IntegerType >
class boost::math::gcd_evaluator
{
public:
	// Types
	typedef IntegerType  result_type;
	typedef IntegerType  first_argument_type;
	typedef IntegerType  second_argument_type;

	// Function object interface
	result_type  operator ()( first_argument_type const &a,
		second_argument_type const &b ) const;
};
```

`boost::math::gcd_evaluator` クラステンプレートは２つの整数の最大公約数を返す関数オブジェクトクラステンプレートを定義している。
テンプレートはここで `IntegerType` と呼ばれている単純な型によってパラメタ化される。
この型は整数を表現する数値型でなければならない。
たとえどちらかの引数が負であっても、関数オブジェクトが返す値はつねに非負である。

この関数オブジェクトクラステンプレートは対応する [GCD function template](#run_gcd_lcm) で使用されている。
もしある数値型の最大公約数の評価方法をカスタマイズしたいならば、`gcd_evaluator` クラステンプレートをその型で特殊化すること。

### <a id="lcm_obj">LCM Function Object</a>

```cpp
template < typename IntegerType >
class boost::math::lcm_evaluator
{
	public:
		// Types
		typedef IntegerType  result_type;
		typedef IntegerType  first_argument_type;
		typedef IntegerType  second_argument_type;

		// Function object interface
		result_type  operator ()( first_argument_type const &a,
			second_argument_type const &b ) const;
};
```

`boost::math::lcm_evaluator` クラステンプレートは２つの整数の最小公倍数を返す関数オブジェクトクラステンプレートを定義している。
テンプレートはここで `IntegerType` と呼ばれている単純な型によってパラメタ化される。
この型は整数を表現する数値型でなければならない。
たとえどちらかの引数が負であっても、関数オブジェクトが返す値はつねに非負である。
もし最小公倍数が整数型の範囲を超える場合、その結果は未定義である。

この関数オブジェクトクラステンプレートは対応する [LCM function template](#run_gcd_lcm) で使用されている。
もしある数値型の最小公倍数の評価方法をカスタマイズしたいならば、`lcm_evaluator` クラステンプレートをその型で特殊化すること。

### <a id="run_gcd_lcm">Run-time GCD & LCM Determination</a>

```cpp
template < typename IntegerType >
IntegerType  boost::math::gcd( IntegerType const &a, IntegerType const &b );

template < typename IntegerType >
IntegerType  boost::math::lcm( IntegerType const &a, IntegerType const &b );
```

`boost::math::gcd` 関数テンプレートは渡された2つの整数の(非負の)最大公約数を返す。
`boost::math::lcm` 関数テンプレートは渡された2つの整数の(非負の)最小公倍数を返す。
この関数テンプレートは引数の `IntegerType` によりパラメタ化される。
また返り値の型も同様である。
内部的には、これらの関数テンプレートは対応する [`gcd_evaluator`](#gcd_obj) と [`lcm_evaluator`](#lcm_obj) クラステンプレートのオブジェクトを使用する。

## Header <a id="cfct_hpp">`<boost/math/common_factor_ct.hpp>`</a>

```cpp
template < unsigned long Value1, unsigned long Value2 >
struct boost::math::static_gcd
{
	static unsigned long const  value = implementation_defined;
};

template < unsigned long Value1, unsigned long Value2 >
struct boost::math::static_lcm
{
	static unsigned long const  value = implementation_defined;
};
```

`boost::math::static_gcd` と `boost::math::static_lcm` クラステンプレートは2つの `unsigned long` 型の値ベースの引数を取り、同じ型の静的定数データメンバ `value` を1つ持つ。
メンバの `value` はテンプレートの引数の最大公約数か最小公倍数である。
最小公倍数が `unsigned long` の範囲を超える場合にはコンパイルエラーが起こるだろう。

## <a id="example">Example</a>

```cpp example
#include <boost/math/common_factor.hpp>
#include <algorithm>
#include <iterator>

int main()
{
	using std::cout;
	using std::endl;

	cout << "The GCD and LCM of 6 and 15 are "
		<< boost::math::gcd(6, 15) << " and "
		<< boost::math::lcm(6, 15) << ", respectively."
		<< endl;

	cout << "The GCD and LCM of 8 and 9 are "
		<< boost::math::static_gcd<8, 9>::value
		<< " and "
		<< boost::math::static_lcm<8, 9>::value
		<< ", respectively." << endl;

	int  a[] = { 4, 5, 6 }, b[] = { 7, 8, 9 }, c[3];
	std::transform( a, a + 3, b, c, boost::math::gcd_evaluator<int>() );
	std::copy( c, c + 3, std::ostream_iterator<int>(cout, " ") );
}
```

## <a id="demo">Demonstration Program</a>

プログラム `common_factor_test.cpp` は実行時のGCDとLCM関数テンプレート、およびコンパイル時のGCDとLCMクラステンプレートのいくつかの例を実体化した結果のデモンストレーションである。
(実行時のGCDとLCMクラステンプレートは実行時関数テンプレートを通して間接的にテストされる。)

## <a id="rationale">Rationale</a>

最大公約数と最小公倍数はいくつかの他のBoostライブラリを含むいくつかの数学のコンテキストでよく使われる。
これらの関数を１つのヘッダにまとめることはコードの局所化を促進し、メンテナンスを容易にする。

## <a id="history">History</a>

- 2 Jul 2002
	- コンパイル時と実行時の項目を新しいヘッダに分割した。
- 7 Nov 2001
	- 初版

## <a id="credits">Credits</a>

GCDとLCMの計算のBoost compilation の作者は Daryle Walker である。
このコードは Paul Moore の rational ライブラリとSteve Clearyの pool ライブラリに潜在していたコードに喚起されたものだ。
コードはHelmut Zeiselによって更新されている。

---

Revised July 2, 2002

(c) Copyright Daryle Walker 2001-2002.

Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies.
This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

