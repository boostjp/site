# 統計処理
統計処理には、[Boost Accumulators Library](http://www.boost.org/doc/libs/release/doc/html/accumulators.html)を使用する。


## インデックス
- [基本的な使い方](#basic-usage)
- [既存のコンテナにあるデータから統計をとる](#container-stats)
- [要素数を求める - `count`](#count)
- [共分散を求める - `covariance`](#covariance)
- [密度を求める - `density`](#density)
- [拡張カイ二乗を求める - `extended_q_square`](#extended_q_square)
- [尖度を求める - `kurtosis`](#kurtosis)
- [最小値を求める - `min`](#min)
- [最大値を求める - `max`](#max)
- [平均値を求める - `mean`](#mean)
- [中央値を求める - `median`](#median)
- [閾値法 POT:Peak Over Threshold](#pot_quantile)
- [歪度を求める - `skewness`](#skewness)
- [合計値を求める - `sum`](#sum)
- [重み付きサンプルやヒストグラムの統計量を求める - `weighted_*`](#weighted-stats)


## <a id="basic-usage" href="#basic-usage">基本的な使い方</a>
Boost.Accumulatorsを使用した統計処理には、`boost::accumulators::accumulator_set`というコンテナを使用し、そのテンプレートパラメータとして、統計したい処理を指定することで、内部でそれらの統計処理の組み合わせを効率よく処理してくれる。

以下は、最小値(min)、平均値(mean)、合計値(sum)を求める例である。

```cpp example
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
```

実行結果：
```
1
3
15
```


## <a id="container-stats" href="#container-stats">既存のコンテナにあるデータから統計をとる</a>
`std::vector`や配列のようなコンテナに、統計したいデータが入っていることがある。

そういったデータをBoost.Accumulatorsで統計をとるには、`for_each()`アルゴリズムを使用して`accumulator_set`にデータを入れる。

```cpp example
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
```

実行結果の例：
```
5
544.24
54424
```


## <a id="count" href="#count">要素数を求める - count</a>
要素数を求めるには、`count`を使用する。

```cpp example
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
```

実行結果：
```
3
```


## <a id="covariance" href="#covariance">共分散を求める - covariance</a>
共分散を求めるには、`covariance`を使用する。

```cpp example
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
```

実行結果：
```
-1.75
```


## <a id="density" href="#density">密度を求める - density</a>
密度を求めるには、`density`を使用する。

`density`は、サンプル分布のヒストグラムを返す。

```cpp example
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
```

実行結果：
```
First: -0.14 Second: 0
First: 0     Second: 0.142857
First: 0.14  Second: 0
First: 0.28  Second: 0.0952381
First: 0.42  Second: 0.238095
First: 0.56  Second: 0.333333
First: 0.7   Second: 0.190476
```

ソースの参考元： <http://www.dreamincode.net/forums/topic/151359-boost-accumulator-help/>


## <a id="extended_q_square" href="#extended_q_square">拡張カイ二乗を求める - extended_q_square</a>
拡張カイ二乗を求めるには、`extended_q_square`を使用する。

```cpp example
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
```

実行結果：
```
0.00120014
0.00940417
0.0965609
0.253513
0.505551
0.750821
0.899161
0.990776
0.999397
```


## <a id="kurtosis" href="#kurtosis">尖度を求める - kurtosis</a>
尖度を求めるには、`kurtosis`を使用する。

```cpp example
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
```

実行結果：
```
5
31.8
234.2
1863
-1.39965
```

## <a id="min" href="#min">最小値を求める - min</a>
最小値を求めるには、`min`を使用する。

```cpp example
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
```

実行結果：
```
1
```

## <a id="max" href="#max">最大値を求める - max</a>
最大値を求めるには、`max`を使用する。

```cpp example
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
```

実行結果：
```
3
```

## <a id="mean" href="#mean">平均値を求める - mean</a>
平均値を求めるには、`mean`を使用する。

```cpp example
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
```

実行結果：
```
2.5
```

## <a id="median" href="#median">中央値を求める - median</a>
中央値を求めるには、`median`を使用する。

```cpp example
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
```

実行結果：
```
3
```


注意：本処理で返される値は推定値であり、厳密な中央値ではない場合がある。参照： 

- [median and variants - Boost Accumulators Library Documentation](http://www.boost.org/doc/libs/release/doc/html/accumulators/user_s_guide.html#accumulators.user_s_guide.the_statistical_accumulators_library.median)


## <a id="pot_quantile" href="#pot_quantile">閾値法 POT:Peak Over Threshold</a>
閾値法を使用するには、`pot_quantile`を使用する。

```cpp example
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
```

実行結果：
```
3.10319
3.09056
-3.09408
-3.08917
6.93361
6.8952
```


## <a id="skewness" href="#skewness">歪度を求める - skewness</a>
歪度を求めるには、`skewness`を使用する。

```cpp example
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
```

実行結果：
```
5
31.8
234.2
0.40604
```


## <a id="sum" href="#sum">合計値を求める - sum</a>
合計値を求めるには、`sum`を使用する。

```cpp example
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
```

実行結果：
```
8
```


## <a id="weighted-stats" href="#weighted-stats">重み付きサンプルやヒストグラムの統計量を求める - `weighted_*`</a>
重み付きサンプルやヒストグラムの統計量を求めるには、各種`weighted_*`を使用する。

```cpp example
#include <iostream>
#include <boost/accumulators/accumulators.hpp>
#include <boost/accumulators/statistics.hpp>

using namespace boost::accumulators;

int main()
{
    accumulator_set<double,            // サンプルの型
        stats<tag::weighted_sum,       // 重み付き和
              tag::weighted_mean,      // 重み付き平均
              tag::weighted_variance,  // 重み付き分散
              tag::weighted_skewness,  // 重み付き歪度
              tag::weighted_kurtosis   // 重み付き尖度
        >,
        double                         // 重みの型
    > acc;

      // 重みは weight で指定
    acc(1.0, weight = 2.0);
    acc(2.0, weight = 3.0);
    acc(3.0, weight = 4.0);

    std::cout << extract::sum_of_weights(acc) << std::endl;    // 重みの総和
    std::cout << extract::sum(acc) << std::endl;
    std::cout << extract::mean(acc) << std::endl;
    std::cout << extract::variance(acc) << std::endl; 
    std::cout << extract::skewness(acc) << std::endl; 
    std::cout << extract::kurtosis(acc) << std::endl;
}
```

実行結果：
```
9
20
2.22222
0.617284
-0.41295
-1.2696
```

