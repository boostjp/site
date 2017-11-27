# 区間演算
[Boost Interval Arithmetic Library](http://www.boost.org/doc/libs/release/libs/numeric/interval/doc/interval.htm)

## インデックス
- [区間を表す型](#interval-type)
- [数値型を指定せずに区間を得る](#deduction-type)
- [区間の下限・上限を得る](#lower-upper)
- [区間内の要素が1個かどうかを判定する](#singleton)
- [四則演算を行う](#arithmetic-operation)


## <a name="interval-type" href="#interval-type">区間を表す型</a>
`boost::numeric::interval`は数値の区間を表すクラステンプレートである。区間は両端を含む。以下のコードのように数値型を指定して用いる。（必要に応じてポリシークラスも指定する。）

`boost::numeric::interval`を使うには、`<boost/numeric/interval.hpp>`をインクルードする。ストリームを用いて区間を出力したい場合は、`<boost/numeric/interval/io.hpp>`をインクルードする。

Boost.Intervalに関連するクラス・関数は `boost::numeric` 名前空間内に定義されている。（さらにネストされた名前空間内に定義されたものもある。）

```cpp example
#include <iostream>
#include <boost/numeric/interval.hpp>
#include <boost/numeric/interval/io.hpp>

int main()
{
  using boost::numeric::interval;

  interval<double> x(3.14, 3.15); // [3.14, 3.15]
  std::cout << x << '\n';
}
```

実行結果：
```
[3.14,3.15]
```


## <a name="deduction-type" href="#deduction-type">数値型を指定せずに区間を得る</a>
`boost::numeric::interval`型の変数を定義する際には、`interval<double>`のように数値型（この場合は`double`）を書かなければならない。関数に区間を渡すときなどに、テンプレート引数を自分で書かずに、自動的に推論されると便利である。`boost::numeric::hull()`を使うと、テンプレート引数が自動的に推論され、推論された数値型の`interval`オブジェクトが返される。

```cpp example
#include <iostream>
#include <boost/numeric/interval.hpp>
#include <boost/numeric/interval/io.hpp>

int main()
{
  using boost::numeric::hull;

  // std::cout << interval<double>(3.14, 3.15) << '\n'; ではなく
  std::cout << hull(3.14, 3.15) << '\n';
}
```

実行結果：
```
[3.14,3.15]
```

## <a name="lower-upper" href="#lower-upper">区間の下限・上限を得る</a>
`boost::numeric::interval`のメンバ関数`lower()`で下限、`upper()`で上限が得られる。非メンバ関数版もある。

```cpp example
#include <iostream>
#include <boost/numeric/interval.hpp>
 
int main()
{
  using boost::numeric::interval;

  interval<double> pi(3.14, 3.15);
  std::cout << "interval::lower: " << pi.lower() << '\n';
  std::cout << "interval::upper: " << pi.upper() << '\n';
 
  std::cout << "lower: " << lower(pi) << '\n';
  std::cout << "upper: " << upper(pi) << '\n';
}
```

実行結果：
```
interval::lower: 3.14
interval::upper: 3.15
lower: 3.14
upper: 3.15
```

## <a name="singleton" href="#singleton">区間内の要素が1個かどうかを判定する</a>
`boost::numeric::singleton()`関数で、区間の要素が1個かどうかを判定できる。

```cpp example
#include <iostream>
#include <boost/numeric/interval.hpp>

int main()
{
  using boost::numeric::interval;

  interval<int> three(3, 3);
  // threeの要素は3だけなのでtrue
  std::cout << std::boolalpha << singleton(three) << '\n';

  interval<int> three_to_five(3, 5);
  // three_to_fiveの要素は3, 4, 5の3個なのでfalse
  std::cout << singleton(three_to_five) << '\n';
}
```

実行結果：
```
true
false
```

## <a name="arithmetic-operation" href="#arithmetic-operation">四則演算を行う</a>
区間と区間、区間と数値の四則演算は通常の演算子`(+, -, *, /)`を用いて行う。

```cpp example
#include <iostream>
#include <boost/numeric/interval.hpp>
#include <boost/numeric/interval/io.hpp>
 
int main()
{
  using boost::numeric::interval;
 
  interval<double> pi(3.14, 3.15);
 
  // [3.14,3.15] + 1 = [4.14,4.15]
  std::cout << pi << " + " << 1 << " = " << pi + 1.0 << '\n';
 
  // [3.14,3.15] - 1 = [2.14,2.15]
  std::cout << pi << " - " << 1 << " = " << pi - 1.0 << '\n';
 
  // [3.14,3.15] * 2 = [6.28,6.3]
  std::cout << pi << " * " << 2 << " = " << pi * 2.0 << '\n';
 
  // [3.14,3.15] / 2 = [1.57,1.575]
  std::cout << pi << " / " << 2 << " = " << pi / 2.0 << '\n';
 
  std::cout << '\n';
 
  interval<double> _1_2(1, 2);
  interval<double> _2_3(2, 3);
 
  // [1,2] + [2,3] = [3,5]
  std::cout << _1_2 << " + " << _2_3 << " = " << _1_2 + _2_3 << '\n';
 
  // [1,2] - [2,3] = [-2,0]
  std::cout << _1_2 << " - " << _2_3 << " = " << _1_2 - _2_3 << '\n';
 
  // [1,2] * [2,3] = [2,6]
  std::cout << _1_2 << " * " << _2_3 << " = " << _1_2 * _2_3 << '\n';
 
  // [1,2] / [2,3] = [0.333...,1]
  std::cout << _1_2 << " / " << _2_3 << " = " << _1_2 / _2_3 << '\n';
}
```

実行結果：
```
[3.14,3.15] + 1 = [4.14,4.15]
[3.14,3.15] - 1 = [2.14,2.15]
[3.14,3.15] * 2 = [6.28,6.3]
[3.14,3.15] / 2 = [1.57,1.575]

[1,2] + [2,3] = [3,5]
[1,2] - [2,3] = [-2,0]
[1,2] * [2,3] = [2,6]
[1,2] / [2,3] = [0.333333,1]
```

複合代入の演算子`(+=, -=, *=, /=)`も使える。

```cpp example
#include <iostream>
#include <boost/numeric/interval.hpp>
#include <boost/numeric/interval/io.hpp>
 
int main()
{
  using boost::numeric::interval;
  using boost::numeric::hull;
 
  interval<double> x(1, 2);
 
  x += 1; // [1,2] -> [2,3]
  std::cout << x << '\n';
 
  x += hull(2, 3); // [2,3] -> [4,6]
  std::cout << x << '\n';
}
```

実行結果:
```
[2,3]
[4,6]
```

