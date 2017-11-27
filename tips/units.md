# 単位演算

単位付きの値を扱うためには、[Boost Units Library](http://www.boost.org/doc/libs/release/doc/html/boost_units.html)を使用する。

## インデックス

- [用語](#term)
- [基本的な使い方](#basic-usage)

## <a name="term" href="#term">用語</a>

Boost Units を使用する上で理解が必要な用語を以下に挙げる。

* 基本次元(Base dimension) : 測定可能な何らかの量。
	* 例 : 長さ、重さ、時間
* 次元(Dimension) : 0個以上の基本次元の掛けあわせ。
	* 例 : 長さ = 長さ^1、面積 = 長さ^2、加速度 = 長さ^1 / 時間^2
* 基本単位(Base unit) : ある次元の特定の測定単位を表すもの。
	* 例 : 次元:長さ -> 基本単位:メートル、フィート
* 単位(Unit) : 基本単位の掛けあわせ
	* 例 : m^1, m^2, m^1/s^2
* 単位系(Unit system) : 関心のある領域の量を表すために必要な基本単位を集めたもの。
	* 例 : [Wikipedia:国際単位系](https://ja.wikipedia.org/wiki/国際単位系) 
* 量(Quantity) : 単位付きの値。
	* 例 : 長さ 5.5 m、面積 10.8 m^2 

## <a name="basic-usage" href="#basic-usage">基本的な使い方</a>

テンプレートクラス `boost::units::quantity` に単位を表す型と値を表す型をテンプレート引数として渡すことで量を表す型が得られる。また、値と単位型のオブジェクトを掛けあわせることで、量のオブジェクトが得られる。

```cpp example
#include <iostream>
#include <boost/units/systems/si.hpp>
#include <boost/units/io.hpp>	// std::ostream への出力に必要 

using namespace boost::units;

int main()
{
	// boost::units::quantity に単位型と値型を渡す事で
	// 単位付きの値型となる。
	// ここでは、単位型としてboost::units::si::length、
	// 値型としてdoubleを使用する。
	quantity<si::length, double> len;

	// 単位型のオブジェクトと値を掛けあわせることで、
	// 単位付きの値を作れる。
	len = 2.0 * si::meter; 	// si::meter は Boost Unitで定義しているsi::length 型のオブジェクト。 
							// 長さ 2.0 m

	// 値型のデフォルト値は double
	quantity<si::length> len2 = len; 

	std::cout << len << std::endl; // 2 m

    return 0;
}
```

