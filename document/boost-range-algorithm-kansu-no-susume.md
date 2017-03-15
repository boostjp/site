# Boost.Range アルゴリズム関数のすすめ

Egtraです。[C++ Advent Calender jp 2010](http://atnd.org/events/10573)の参加記事です。実は、[高専カンファレンス 2010秋 in 東京](http://kosenconf.jp/?014tokyo)でも同じような内容で発表していました。そのときの内容をベースとしています。

C++のソートを行う関数の1つに`sort`があります。

```cpp
std::vector<string> v;
v.push_back("Foo");
v.push_back("Bar");

std::sort(v.begin(), v.end());
```

さて、「なんで`.begin()`とか`.end()`とか付けないといけないの？」と思ったことありませんか？ないですか。ありますよね。Boost 1.43より搭載されているBoost.Range 2.0なら、`boost::sort(v);`と書けます。書けるようになりました。

```cpp
#include <vector>
#include <iostream>
#include <boost/range/algorithm.hpp>

int main()
{
	std::vector<int> v;
	v.push_back(3);
	v.push_back(2);
	v.push_back(1);
	boost::sort(v);

	for (std::size_t i = 0; i < v.size(); ++i)
	{
		std::cout << v[i] << std::endl;
	}
}
```

`<algorithm>`の代わりに`<boost/range/algorithm.hpp>`をインクルードします。もちろん、`<numeric>`に対する`<boost/range/numeric.hpp>`もあります。

```cpp
#include <vector>
#include <iostream>
#include <string>
#include <boost/range/numeric.hpp>

int main()
{
	std::vector<int> v;
	v.push_back(100);
	v.push_back(50);
	v.push_back(150);

	int sum = boost::accumulate(v, 0);
	// int sum = std::accumulate(v.begin(), v.end(), 0);
	int average = sum / v.size(); // 平均値を求める
	std::cout << average << std::endl;
}
```

なお、出力イテレータの部分に関してはそのままです。入力イテレータ～ランダムアクセスイテレータが対象というわけですね。

```cpp
#include <iostream>
#include <string>
#include <iterator>
#include <cctype>
#include <boost/range/algorithm.hpp>

int main()
{
	std::string s = "hoge";
	std::string upper;
	boost::transform(s, std::back_inserter(upper), std::toupper);
	// std::transform(s.begin(), s.end(), std::back_inserter(upper), std::toupper);
	std::cout << upper << std::endl;
}
```

以下に従ってSTLのアルゴリズム関数の代わりにBoost.Rangeのアルゴリズム関数を使っていて外れはありません。

- `std`名前空間の代わりに`boost`名前空間で定義されている同名の関数を呼びます。
- それを呼ぶ場合、引数中の`x.begin(), x.end()`の並びを単に`x`に変えます。

`find`など、イテレータを戻り値とする関数は、このRangeアルゴリズム関数でも同様にイテレータを戻り値とします。実際には、それに加えて、さらに種類をあるのですが、本稿では取り上げません。

```cpp
#include <vector>
#include <string>
#include <boost/range/algorithm.hpp>

int main()
{
	std::vector<std::string> v;
	v.push_back("Tokyo");
	v.push_back("Nagoya");
	v.push_back("Kyoto");
	v.push_back("Shin-Osaka");

	std::vector<std::string>::iterator it = boost::find(v, "Kyoto");
}
```

STLコンテナだけでなく、`boost::array`や`std::array`などももちろん対応しています。ほか、組込の配列にも使用可能です。

```cpp
#include <iostream>
#include <iterator>
#include <boost/range/algorithm.hpp>

int main()
{
	int a[] = {1, 2, 3};
	boost::copy(a, std::ostream_iterator<int>(std::cout, " "));
	// std::copy(a, a + sizeof (a) / sizeof (a[0]), std::ostream_iterator<int>(std::cout, " "));
	std::cout << std::endl;
}
```

さらに、`first`, `last`のイテレータを`std::pair`の形をしたものも同様に扱えます。最初の例で言うと、`std::pair<iterator>(v.begin(), v.end())`と`boost::sort(v)`と`boost::sort(std::make_pair(v.begin(), v.end()))`が同じということです。これは、ちょうどイテレータのペアを返す関数にぴったりはまります。

```cpp
#include <map>
#include <iostream>
#include <string>
#include <iterator>
#include <boost/range/algorithm.hpp>

void output(const std::pair<char, std::string>& pair)
{
	std::cout << pair.second << std::endl;
}

int main()
{
	std::multimap<char, std::string> m;
	m.insert(std::make_pair('F', "Fukushima"));
	m.insert(std::make_pair('F', "Fukuoka"));
	m.insert(std::make_pair('F', "Fukui"));
	m.insert(std::make_pair('S', "Saitama"));

	boost::for_each(m.equal_range('F'), output); // キーが'F'である要素を出力。
}
```

最後に、もう1つ。`<boost/range/algorithm_ext.hpp>`には、STLアルゴリズム関数の単純なラッパではない独自の関数がいくつかあります。その中の`remove_erase`と`remove_erase_if`は、コンテナのメンバ関数`erase`とSTLアルゴリズム関数`remove`または`remove_if`を組み合わせて、コンテナから特定の要素を削除するパターンをラップしたものです。Effective STLにも紹介されているこの組み合わせ、もう引数の順番に悩むことなくなり便利です。

```cpp
#include <vector>
#include <iostream>
#include <boost/range/algorithm.hpp>
#include <boost/range/algorithm_ext.hpp>

struct is_even : std::unary_function<int, bool>
{
	result_type operator ()(argument_type x) const
	{
		return (x % 2) == 0;
	}
};

int main()
{
	std::vector<int> v;
	v.push_back(1);
	v.push_back(2);
	v.push_back(3);
	v.push_back(4);
	v.push_back(5);

	boost::remove_erase_if(v, is_even());
	// v.erase(std::remove_if(v.begin(), v.end(), is_even()), v.end());

	boost::copy(v, std::ostream_iterator<int>(std::cout, " "));
	// std::copy(v.begin(), v.end(), std::ostream_iterator<int>(std::cout, " "));
	std::cout << std::endl;
}
```

## 関連
というわけで、まだ入れていない方はBoostを入れましょう。こちらを参考に: [letsboost::インストール](http://www.kmonos.net/alang/boost/install.html)。

今回、Range（レンジ）のレの字も出しませんでした。そもそもRangeとはなんぞやという方はこちらを参考に: [letsboost::range](http://www.kmonos.net/alang/boost/classes/range.html)。2010年12月28日現在、Boost.Range 1.0 (Boost 1.42まで)ベースの解説となっています。

本家ドキュメントはこちらです: [Boost.Range (boost.org)](http://www.boost.org/libs/range/)。

