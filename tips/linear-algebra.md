#線形代数
線形代数には、[Boost uBLAS Library](http://www.boost.org/doc/libs/release/libs/numeric/ublas/doc/index.htm)を使用する。

Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>ベクトルの基本操作](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>ベクトルの長さを取得する](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>ベクトルを正規化する](#TOC--2)</li><li class='goog-toc'>[<strong>4 </strong>2つのベクトルの内積を求める](#TOC-2-)</li><li class='goog-toc'>[<strong>5 </strong>2つのベクトルが成す角度を求める](#TOC-2-1)</li></ol>




###ベクトルの基本操作
ベクトルには、`boost::numeric::ublas`名前空間の[`vector`](http://www.boost.org/doc/libs/release/libs/numeric/ublas/doc/vector.htm#vector)クラステンプレートを使用する。


```cpp
#include <iostream>
#include <boost/numeric/ublas/vector.hpp>
#include <boost/numeric/ublas/io.hpp>

namespace ublas = boost::numeric::ublas;

int main()
{
    // double型を要素とする3次元ベクトル
    ublas::vector<double> v(3);

    // 各要素の参照と代入
    v[0] = 3.0; // x
    v[1] = 0.0; // y
    v[2] = 4.0; // z

    // 出力ストリーム
    std::cout << v << std::endl;

    ublas::vector<double> u(3);

    // ベクトルの演算
    ublas::vector<double> v1 = v + u;
    ublas::vector<double> v2 = v - u;
    ublas::vector<double> v3 = v * 2.0;
    ublas::vector<double> v4 = v / 3.0;

    // ベクトルの複合演算
    v += u;
    v -= u;
    v *= 2.0;
    v /= 3.0;
}


出力：
```cpp
[3](3,0,4)
```

`vector`クラスは、テンプレート引数で要素の型をとり、コンストラクタでは次元数を引数にとる。
各要素は、`operator[]()`で参照できる。

ベクトルの演算は、四則演算全てをサポートしており、各演算は以下の意味を持つ：

| | |
|-------------------|----------------------------------------------------------|
| `v + u` | `(v[0] + u[0], v[1] + u[1], ..., v[i] + u[i])` |
| `v - u` | `(v[0] - u[0], v[1] - u[1], ..., v[i] - u[i])` |
| `v * n` | `(v[0] * n, v[1] * n, ..., v[i] * n)` |
| `v / n` | `(v[0] / n, v[1] / n, ..., v[i] / n)` |


###ベクトルの長さを取得する
ベクトルの長さを取得するには、[`boost::numeric::ublas::norm_2()`](http://www.boost.org/doc/libs/release/libs/numeric/ublas/doc/vector_expression.htm#vector_reductions)関数を使用する。この関数は、ユークリッドノルム(2-ノルム)を計算して返す。

```cpp
#include <iostream>
#include <boost/numeric/ublas/vector.hpp>

namespace ublas = boost::numeric::ublas;

int main()
{
    ublas::vector<double> v(3);

    v[0] = 2.0;
    v[1] = 0.0;
    v[2] = 1.0;

    // ベクトルの長さを取得する
    const double length = ublas::norm_2(v);
    std::cout << length << std::endl;
}
```
* norm_2[color ff0000]

出力：
```cpp
2.23607
```

###ベクトルを正規化する
ベクトルの正規化とは、ベクトルの長さを1にする変換のことである。Boost.uBLASでは、正規化のための関数が直接的には用意されていないため、自分で計算する必要がある。
正規化の計算は、以下の`normalize()`関数のように、ベクトルを長さで割ることでできる。

```cpp
#include <iostream>
#include <boost/numeric/ublas/vector.hpp>
#include <boost/numeric/ublas/io.hpp>

namespace ublas = boost::numeric::ublas;

ublas::vector<double> normalize(const ublas::vector<double>& v)
{
    return v / ublas::norm_2(v);
}

int main()
{
    ublas::vector<double> v(3);

    v[0] = 2.0;
    v[1] = 0.0;
    v[2] = 1.0;

    // 正規化
    ublas::vector<double> normalized_vec = normalize(v);

    std::cout << "length : " << ublas::norm_2(normalized_vec) << std::endl;
    std::cout << normalized_vec << std::endl;
}
```
* v / ublas::norm_2(v)[color ff0000]

出力：
```cpp
length : 1
[3](0.894427,0,0.447214)
```

値の比率をそのままに、長さが1になっていることがわかる。


###2つのベクトルの内積を求める
2つのベクトルの内積を求めるには、[`boost::ublas::inner_prod()`](http://www.boost.org/doc/libs/release/libs/numeric/ublas/doc/vector_expression.htm#vector_operations)関数を使用する。この関数は、2つのベクトルを引数にとり、ベクトルの要素型で内積値を返す。


```cpp
#include <iostream>
#include <boost/numeric/ublas/vector.hpp>

namespace ublas = boost::numeric::ublas;

int main()
{
    ublas::vector<double> v(2);
    v[0] = -1;
    v[1] = 1;

    ublas::vector<double> u(2);
    u[0] = 1;
    u[1] = -2;

    const double result = ublas::inner_prod(v, u);
    std::cout << result << std::endl;
}



出力：```cpp
-3
内積は、2つのベクトルが同じ方向を向いていれば正の値、逆方向を向いていれば負の値を返すという特徴がある。
これを利用して、「負の値だったら位置ベクトルが目的地に到達した(衝突した)」と判定するのに応用できる。
```
* inner_prod[color ff0000]

###2つのベクトルが成す角度を求める
2つのベクトルが成す角度の計算を、以下の`angle()`関数の実装で示す。この関数は、2つのベクトルを与えると、ラジアンで角度が返される。


```cpp
#include <iostream>
#include <cmath>
#include <boost/numeric/ublas/vector.hpp>
#include <boost/algorithm/clamp.hpp>
#include <boost/geometry/util/math.hpp>
#include <boost/math/constants/constants.hpp>

namespace ublas = boost::numeric::ublas;

template <class T>
T angle(const ublas::vector<T>& v, const ublas::vector<T>& u)
{
    const T length = ublas::norm_2(v) * ublas::norm_2(u);
    if (boost::geometry::math::equals(length, static_cast<T>(0.0))) {
        return static_cast<T>(0.0);
    }

    const T x = ublas::inner_prod(v, u) / length;
    const T rounded = boost::algorithm::clamp(x, static_cast<T>(-1.0), static_cast<T>(1.0));
    return std::acos(rounded);
}

template <class T>
T radian_to_degree(const T& x)
{
    return x * static_cast<T>(180.0) / boost::math::constants::pi<T>();
}

int main()
{
    ublas::vector<double> v(2);
    v[0] = 1;
    v[1] = 0;

    ublas::vector<double> u(2);
    u[0] = 1;
    u[1] = 1;

    const double result = angle(v, u); // 角度がラジアンで返される
    std::cout << result << std::endl;

    const double deg = radian_to_degree(result); // ディグリに変換してみる
    std::cout << deg << std::endl;
}



出力：
```cpp
0.785398
45
```
* angle(const ublas::vector<T>& v, const ublas::vector<T>& u)[color ff0000]
* angle(v, u); // 角度がラジアンで返される[color ff0000]

計算の詳細は、Wikipediaを参照：
[ベクトルのなす角 - Wikipedia](http://ja.wikipedia.org/wiki/%E3%83%99%E3%82%AF%E3%83%88%E3%83%AB%E3%81%AE%E3%81%AA%E3%81%99%E8%A7%92)

documented boost version is 1.53.0

