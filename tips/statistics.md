#統計処理
統計処理には、[Boost Accumulators Library](http://www.boost.org/doc/libs/release/doc/html/accumulators.html)を使用する。

Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>基本的な使い方](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>既存のコンテナにあるデータから統計をとる](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>統計関数](#TOC--2)<ol class='goog-toc'><li class='goog-toc'>[<strong>3.1 </strong>要素数を求める - count](#TOC---count)</li><li class='goog-toc'>[<strong>3.2 </strong>共分散を求める - covariance](#TOC---covariance)</li><li class='goog-toc'>[<strong>3.3 </strong>密度を求める - density](#TOC---density)</li><li class='goog-toc'>[<strong>3.4 </strong>拡張カイ二乗を求める - extended q square](#TOC---extended-q-square)</li><li class='goog-toc'>[<strong>3.5 </strong>尖度を求める - kurtosis](#TOC---kurtosis)</li><li class='goog-toc'>[<strong>3.6 </strong>最小値を求める - min](#TOC---min)</li><li class='goog-toc'>[<strong>3.7 </strong>最大値を求める - max](#TOC---max)</li><li class='goog-toc'>[<strong>3.8 </strong>平均値を求める - mean](#TOC---mean)</li><li class='goog-toc'>[<strong>3.9 </strong>中央値を求める - median](#TOC---median)</li><li class='goog-toc'>[<strong>3.10 </strong>閾値法 POT:Peak Over Threshold](#TOC-POT:Peak-Over-Threshold)</li><li class='goog-toc'>[<strong>3.11 </strong>歪度を求める - skewness](#TOC---skewness)</li><li class='goog-toc'>[<strong>3.12 </strong>合計値を求める - sum](#TOC---sum)</li><li class='goog-toc'>[<strong>3.13 </strong>重み付きサンプルやヒストグラムの統計量を求める - weighted_*](#TOC---weighted_-)</li></ol></li></ol>




###基本的な使い方
Boost Accumulators Libraryを使用した統計処理には、boost::accumulators::accumulator_setというコンテナを使用し、そのテンプレートパラメータとして、統計したい処理を指定することで、内部でそれらの統計処理の組み合わせを効率よく処理してくれる。
以下は、最小値(min)、平均値(mean)、合計値(sum)を求める例である。


```cpp
#include <iostream>
#include <boost/accumulators/accumulators.hpp>
#include <boost/accumulators/statistics.hpp>

using namespace boost::accumulators;

int main()
{
    accumulator_set<double, stats<tag::min, tag::mean, tag::sum> > acc;

    acc(3.0);
    acc(1.0);
    acc(4.0);
    acc(2.0);
    acc(5.0);

    std::cout << extract::min(acc) << std::endl;  // 最小値
    std::cout << extract::mean(acc) << std::endl; // 平均値
    std::cout << extract::sum(acc) << std::endl;  // 合計値
}


実行結果：
```cpp
1
3
15

```

###既存のコンテナにあるデータから統計をとる
std::vectorや配列のようなコンテナに、統計したいデータが入っていることがある。
そういったデータをBoost.Accumulatorsで統計をとるには、for_eachを使用してaccumulator_setにデータを入れる。


```cpp
#include <iostream>
#include <boost/array.hpp>
#include <boost/random.hpp>
#include <boost/range/algorithm/generate.hpp>
#include <boost/range/algorithm/for_each.hpp>

#include <boost/bind.hpp>
#include <boost/ref.hpp>
#include <boost/accumulators/accumulators.hpp>
#include <boost/accumulators/statistics.hpp>

using namespace boost::accumulators;

// てきとうなデータを用意
void load(boost::array<int, 100>& ar)
{
    boost::mt19937 engine;
    boost::uniform_int<> distribution(1, 1000);
    boost::variate_generator<boost::mt19937, boost::uniform_int<> > generator(engine, distribution);

    boost::generate(ar, generator);
}

int main()
{
    boost::array<int, 100> ar;
    load(ar);

    accumulator_set<double, stats<tag::min, tag::mean, tag::sum> > acc;

    boost::for_each(ar, boost::bind(boost::ref(acc), _1));

    std::cout << extract::min(acc) << std::endl;  // 最小値
    std::cout << extract::mean(acc) << std::endl; // 中間値
    std::cout << extract::sum(acc) << std::endl;  // 合計値
}


実行結果の例：

```cpp
5
544.24
54424


```

###統計関数
<h4>要素数を求める - count</h4>要素数を求めるには、countを使用する。


```cpp
#include <iostream>
#include <boost/accumulators/accumulators.hpp>
#include <boost/accumulators/statistics.hpp>

using namespace boost::accumulators;

int main()
{
    accumulator_set<double, stats<tag::count> > acc;

    acc(3);
    acc(1);
    acc(4);

    std::cout << extract::count(acc) << std::endl;
}


実行結果：
```cpp
3


<h4>共分散を求める - covariance</h4>共分散を求めるには、covarianceを使用する。


```cpp
#include <iostream>
#include <boost/accumulators/accumulators.hpp>
#include <boost/accumulators/statistics.hpp>

using namespace boost::accumulators;

int main()
{
    accumulator_set<double, stats<tag::covariance<double, tag::covariate1> > > acc;

    acc(1.0, covariate1 = 2.0);
    acc(1.0, covariate1 = 4.0);
    acc(2.0, covariate1 = 3.0);
    acc(6.0, covariate1 = 1.0);

    std::cout << extract::covariance(acc) << std::endl;
}


実行結果：
```cpp
-1.75


<h4>密度を求める - density</h4>密度を求めるには、densityを使用する。
densityは、サンプル分布のヒストグラムを返す。


```cpp
#include <iostream>
#include <vector>
#include <utility>
#include <boost/range/algorithm/for_each.hpp>
#include <boost/bind.hpp>
#include <boost/ref.hpp>
#include <boost/foreach.hpp>
#include <boost/accumulators/accumulators.hpp>
#include <boost/accumulators/statistics.hpp>

using namespace boost::accumulators;

int main() {
    const double data[21] = {
        0,     0.5,    0.65,
        0.45,  0.7,    0.65,
        0.45,  0.7,    0.59,
        0,     0.05,   0.60,
        0.605, 0.405,  0.78,
        0.61,  0.605 , 0.405,
        0.71,  0.509 , 0.52
    };

    accumulator_set<double, stats<tag::density > >
        acc(tag::density::cache_size=10, tag::density::num_bins=5);

    boost::for_each(data, boost::bind(boost::ref(acc), _1));

    typedef
        boost::iterator_range<
            std::vector<std::pair<double, double> >::iterator
        >
    histogram_type;

    histogram_type histogram = density(acc);

    typedef std::pair<double, double> value_type;
    BOOST_FOREACH (const value_type& x, histogram) {
        std::cout << "First: " << x.first << "\t Second: " << x.second << std::endl;
    }
    
}


実行結果：

```cpp
First: -0.14 Second: 0
First: 0     Second: 0.142857
First: 0.14  Second: 0
First: 0.28  Second: 0.0952381
First: 0.42  Second: 0.238095
First: 0.56  Second: 0.333333
First: 0.7   Second: 0.190476


ソースの参考元： http://www.dreamincode.net/forums/topic/151359-boost-accumulator-help/
```
* http://www.dreamincode.net/forums/topic/151359-boost-accumulator-help/[link http://www.dreamincode.net/forums/topic/151359-boost-accumulator-help/]

<h4>拡張カイ二乗を求める - extended q square</h4>拡張カイ二乗を求めるには、extended_q_squareを使用する。


```cpp
#include <iostream>
#include <vector>
#include <boost/random.hpp>
#include <boost/accumulators/accumulators.hpp>
#include <boost/accumulators/statistics.hpp>
#include <boost/foreach.hpp>

using namespace boost::accumulators;

int main()
{
    boost::lagged_fibonacci607 rng;

    std::vector<double> probs;
    probs.push_back(0.001);
    probs.push_back(0.01 );
    probs.push_back(0.1  );
    probs.push_back(0.25 );
    probs.push_back(0.5  );
    probs.push_back(0.75 );
    probs.push_back(0.9  );
    probs.push_back(0.99 );
    probs.push_back(0.999);

    accumulator_set<double, stats<tag::extended_p_square> >
        acc(extended_p_square_probabilities = probs);

    for (std::size_t i = 0; i < 10000; ++i)
        acc(rng());

    for (std::size_t i = 0; i < probs.size(); ++i)
    {
        std::cout << extract::extended_p_square(acc)[i] << std::endl;
    }
}


実行結果：

```cpp
0.00120014
0.00940417
0.0965609
0.253513
0.505551
0.750821
0.899161
0.990776
0.999397



<h4>尖度を求める - kurtosis</h4>尖度を求めるには、kurtosisを使用する。
```cpp
#include <iostream>
#include <boost/accumulators/accumulators.hpp>
#include <boost/accumulators/statistics.hpp>

using namespace boost::accumulators;

int main()
{
    accumulator_set<int, stats<tag::kurtosis > > acc;

    acc(2);
    acc(7);
    acc(4);
    acc(9);
    acc(3);

    std::cout << extract::mean(acc) << std::endl;
    std::cout << extract::moment<2>(acc) << std::endl;
    std::cout << extract::moment<3>(acc) << std::endl;
    std::cout << extract::moment<4>(acc) << std::endl;
    std::cout << extract::kurtosis(acc) << std::endl;
}

実行結果：
```cpp
5
31.8
234.2
1863
-1.39965

<h4>最小値を求める - min</h4>
最小値を求めるには、minを使用する。


```cpp
#include <iostream>
#include <boost/accumulators/accumulators.hpp>
#include <boost/accumulators/statistics.hpp>

using namespace boost::accumulators;

int main()
{
    accumulator_set<int, stats<tag::min> > acc;

    acc(3);
    acc(1);
    acc(2);

    std::cout << extract::min(acc) << std::endl;
}


実行結果：
```cpp
1


<h4>最大値を求める - max</h4>最大値を求めるには、maxを使用する。


```cpp
#include <iostream>
#include <boost/accumulators/accumulators.hpp>
#include <boost/accumulators/statistics.hpp>

using namespace boost::accumulators;

int main()
{
    accumulator_set<int, stats<tag::max> > acc;

    acc(3);
    acc(1);
    acc(2);

    std::cout << extract::max(acc) << std::endl;
}


実行結果：
```cpp
3

<h4>平均値を求める - mean</h4>平均値を求めるには、meanを使用する。


```cpp
#include <iostream>
#include <boost/accumulators/accumulators.hpp>
#include <boost/accumulators/statistics.hpp>

using namespace boost::accumulators;

int main()
{
    accumulator_set<double, stats<tag::mean> > acc;

    acc(1);
    acc(2);
    acc(3);
    acc(4);

    std::cout << extract::mean(acc) << std::endl;
}


実行結果：
```cpp
2.5
```

<h4>中央値を求める - median</h4>中央値を求めるには、medianを使用する。


```cpp
#include <iostream>
#include <boost/accumulators/accumulators.hpp>
#include <boost/accumulators/statistics.hpp>

using namespace boost::accumulators;

int main()
{
    accumulator_set<double, stats<tag::median> > acc;

    acc(1);
    acc(2);
    acc(3);
    acc(4);

    std::cout << extract::median(acc) << std::endl;
}


実行結果：
```cpp
3


注意：本処理で返される値は推定値であり、厳密な中央値ではない場合がある<span style='background-color:transparent;line-height:1.5;font-size:10pt'>。</span>参照： 
http://www.boost.org/doc/libs/release/doc/html/accumulators/user_s_guide.html#accumulators.user_s_guide.the_statistical_accumulators_library.median

<h4>閾値法 POT:Peak Over Threshold</h4>閾値法を使用するには、pot_quantileを使用する。


```cpp
#include <iostream>
#include <boost/random.hpp>
#include <boost/accumulators/accumulators.hpp>
#include <boost/accumulators/statistics.hpp>

using namespace boost::accumulators;

int main()
{
    // 2つの擬似乱数生成器を用意
    boost::lagged_fibonacci607 rng;
    boost::normal_distribution<> mean_sigma(0,1);
    boost::exponential_distribution<> lambda(1);
    boost::variate_generator<boost::lagged_fibonacci607&, boost::normal_distribution<> > normal(rng, mean_sigma);
    boost::variate_generator<boost::lagged_fibonacci607&, boost::exponential_distribution<> > exponential(rng, lambda);

    accumulator_set<double, stats<tag::pot_quantile<right>(with_threshold_value)> > acc1(
        pot_threshold_value = 3.
    );
    accumulator_set<double, stats<tag::pot_quantile<right>(with_threshold_probability)> > acc2(
        right_tail_cache_size = 2000
      , pot_threshold_probability = 0.99
    );
    accumulator_set<double, stats<tag::pot_quantile<left>(with_threshold_value)> > acc3(
        pot_threshold_value = -3.
    );
    accumulator_set<double, stats<tag::pot_quantile<left>(with_threshold_probability)> > acc4(
        left_tail_cache_size = 2000
      , pot_threshold_probability = 0.01
    );

    accumulator_set<double, stats<tag::pot_quantile<right>(with_threshold_value)> > acc5(
        pot_threshold_value = 5.
    );
    accumulator_set<double, stats<tag::pot_quantile<right>(with_threshold_probability)> > acc6(
        right_tail_cache_size = 2000
      , pot_threshold_probability = 0.995
    );

    for (std::size_t i = 0; i < 100000; ++i)
    {
        double sample = normal();
        acc1(sample);
        acc2(sample);
        acc3(sample);
        acc4(sample);
    }

    for (std::size_t i = 0; i < 100000; ++i)
    {
        double sample = exponential();
        acc5(sample);
        acc6(sample);
    }

    std::cout << extract::quantile(acc1, quantile_probability = 0.999) << std::endl;
    std::cout << extract::quantile(acc2, quantile_probability = 0.999) << std::endl;
    std::cout << extract::quantile(acc3, quantile_probability = 0.001) << std::endl;
    std::cout << extract::quantile(acc4, quantile_probability = 0.001) << std::endl;

    std::cout << extract::quantile(acc5, quantile_probability = 0.999) << std::endl;
    std::cout << extract::quantile(acc6, quantile_probability = 0.999) << std::endl;
}


実行結果：

```cpp
3.10319
3.09056
-3.09408
-3.08917
6.93361
6.8952



<h4>歪度を求める - skewness</h4>歪度を求めるには、skewnessを使用する。


```cpp
#include <iostream>
#include <boost/accumulators/accumulators.hpp>
#include <boost/accumulators/statistics.hpp>

using namespace boost::accumulators;

int main()
{
    accumulator_set<int, stats<tag::skewness > > acc;

    acc(2);
    acc(7);
    acc(4);
    acc(9);
    acc(3);

    std::cout << extract::mean(acc) << std::endl;
    std::cout << extract::moment<2>(acc) << std::endl;
    std::cout << extract::moment<3>(acc) << std::endl;
    std::cout << extract::skewness(acc) << std::endl;
}


実行結果：

```cpp
5
31.8
234.2
0.40604



<h4>合計値を求める - sum</h4>合計値を求めるには、sumを使用する。


```cpp
#include <iostream>
#include <boost/accumulators/accumulators.hpp>
#include <boost/accumulators/statistics.hpp>

using namespace boost::accumulators;

int main()
{
    accumulator_set<int, stats<tag::sum> > acc;

    acc(3);
    acc(1);
    acc(4);

    std::cout << extract::sum(acc) << std::endl;
}



実行結果：```cpp
8
<h4>重み付きサンプルやヒストグラムの統計量を求める - weighted_*</h4>重み付きサンプルやヒストグラムの統計量を求めるには、各種weighted_*を使用する。
```
* http://www.boost.org/doc/libs/release/doc/html/accumulators/user_s_guide.html#accumulators.user_s_guide.the_statistical_accumulators_library.median[link http://www.boost.org/doc/libs/release/doc/html/accumulators/user_s_guide.html#accumulators.user_s_guide.the_statistical_accumulators_library.median]

```cpp
#include <iostream>
#include <boost/accumulators/accumulators.hpp>
#include <boost/accumulators/statistics.hpp>

using namespace boost::accumulators;

int main()
{
    accumulator_set<double,    <span>    <span>    // サンプルの型</span></span>
    <span>    </span>stats<tag::weighted_sum,    <span>   // 重み付き和</span>
              tag::weighted_mean,  <span>    // 重み付き平均</span>              tag::weighted_variance,  // 重み付き分散
              tag::weighted_skewness,  // 重み付き歪度
              tag::weighted_kurtosis   // 重み付き尖度
        >,
        double    <span>    <span>    <span>    <span>    <span>     // 重みの型</span></span></span></span></span>
    > acc;

      // 重みは weight で指定    acc(1.0, weight = 2.0);
    acc(2.0, weight = 3.0);
    acc(3.0, weight = 4.0);
    std::cout << extract::sum_of_weights(acc) << std::endl;<span>    // 重みの総和</span>
    std::cout << extract::sum(acc) << std::endl;
    std::cout << extract::mean(acc) << std::endl;
    std::cout << extract::variance(acc) << std::endl;
    std::cout << extract::skewness(acc) << std::endl;
    std::cout << extract::kurtosis(acc) << std::endl;}


実行結果：

```cpp
9
20
2.22222
0.617284
-0.41295
-1.2696
```
