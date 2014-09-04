#数学

Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>円周率を取得する](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>最大公約数を求める](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>最小公倍数を求める](#TOC--2)</li></ol>




###円周率を取得する
円周率を取得するには、[Boost Math Library](http://www.boost.org/doc/libs/release/libs/math/)の`boost::math::constants::pi()`関数を使用する。この関数を使用するには、<boost/math/constants/constants.hpp>ヘッダをインクルードする。
`pi()`関数のテンプレート引数として、浮動小数点数型を指定することができ、`double`だけでなく、`float`や`long double`、[多倍長浮動小数点数型](https://sites.google.com/site/boostjp/tips/multiprec-float)として円周率を取得することもできる。

```cpp
#include <iostream>
#include <limits>
#include <boost/math/constants/constants.hpp>

int main ()
{
    double pi = boost::math::constants::pi<double>();

    std::cout.precision(std::numeric_limits<double>::max_digits10);
    std::cout << pi << std::endl;
}
```
* pi[color ff0000]

出力：
```cpp
3.1415926535897931
```

参考：
[C++で円周率を取得する - pepshisoの日記](http://d.hatena.ne.jp/pepshiso/20120501)


###最大公約数を求める
最大公約数を求めるには、Boost Math Libraryの[`boost::math::gcd()`](http://www.boost.org/doc/libs/release/libs/math/doc/html/math_toolkit/run_time.html)関数を使用する。この関数を使用するには、<boost/math/common_factor_rt.hpp>ヘッダをインクルードする。
この関数には、2つの整数型の値を指定する。戻り値として、その整数型としての最大公約数が返される。

```cpp
#include <iostream>
#include <boost/math/common_factor_rt.hpp>

int main()
{
    // 12と18の最大公約数を求める
    int result = boost::math::gcd(12, 18);

    std::cout << result << std::endl;
}
```
* gcd[color ff0000]

出力：
```cpp
6
```

###最小公倍数を求める
最小公倍数を求めるには、Boost Math Libraryの[`boost::math::lcm()`](http://www.boost.org/doc/libs/release/libs/math/doc/html/math_toolkit/run_time.html)関数を使用する。この関数を使用するには、<boost/math/common_factor_rt.hpp>ヘッダをインクルードする。
この関数には、2つの整数型の値を指定する。戻り値として、その整数型としての最小公倍数が返される。

```cpp
#include <iostream>
#include <boost/math/common_factor_rt.hpp>

int main()
{
    // 2と3の最小公倍数を求める
    int result = boost::math::lcm(2, 3);

    std::cout << result << std::endl;
}
```
* lcm[color ff0000]

出力：
```cpp
6
```
