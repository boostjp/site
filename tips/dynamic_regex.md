# 動的な正規表現
動的な正規表現には、[Boost.Xpressive](http://www.boost.org/doc/libs/release/doc/html/xpressive.html)を使用する。


日本語リファレンス：

- [http://alpha.sourceforge.jp/devel/boost.regex_ja.pdf](http://alpha.sourceforge.jp/devel/boost.regex_ja.pdf)


静的な正規表現は以下のページを参照：

- [静的な正規表現](static_regex.md)


## インデックス

- [文字列全体が正規表現にマッチするか調べる](#regex-match)
- [文字列が正規表現にマッチする部分文字列を含むか調べる](#regex-search)
- [正規表現にマッチした部分文字列をすべて置換する](#regex-replace)
- [正規表現の記述時に、エスケープシーケンスを無視する]


## <a name="regex-match" href="#regex-match">文字列全体が正規表現にマッチするか調べる</a>

文字列全体が正規表現にマッチするか調べるには、[`boost::xpressive::regex_match()`](http://www.boost.org/doc/libs/release/doc/html/boost/xpressive/regex_match.html)関数を使用する。

この関数は、マッチに成功したら`true`を返し、そうでなければ`false`を返す。この関数が成功するのは、文字列全体の先頭から終端までが正規表現にマッチする場合である。

この関数に[`boost::xpressive::smatch`](http://www.boost.org/doc/libs/release/doc/html/xpressive/user_s_guide.html#boost_xpressive.user_s_guide.quick_start.know_your_iterator_type)オブジェクトへの参照を与えると、見つかったマーク済み部分式が書き込まれる。


```cpp
#include <iostream>
#include <boost/xpressive/xpressive.hpp>

using namespace boost::xpressive;

int main()
{
    std::string hello = "Hello World!";

    sregex rex = sregex::compile("(\\w+) (\\w+)!");
    smatch what;
    if (regex_match(hello, what, rex)) {
        std::cout << what[0] << std::endl; // マッチ全体
        std::cout << what[1] << std::endl; // 1 番目の捕捉
        std::cout << what[2] << std::endl; // 2 番目の捕捉
    }
}
```
* regex_match[color ff0000]

出力：

```
Hello World!
Hello
World
```


## <a name="regex-search" href="#regex-search">文字列が正規表現にマッチする部分文字列を含むか調べる</a>

文字列が正規表現にマッチする部分文字列を含むか調べるには、[`boost::xpressive::regex_search()`](http://www.boost.org/doc/libs/release/doc/html/boost/xpressive/regex_search.html)関数を使用する。

この関数は、マッチする部分文字列が見つかったら`true`、そうでなければ`false`を返す。対象となる文字列の次の引数として[`boost::xpressive::smatch`](http://www.boost.org/doc/libs/release/doc/html/xpressive/user_s_guide.html#boost_xpressive.user_s_guide.quick_start.know_your_iterator_type)オブジェクトへの参照を与えると、見つかったマーク済み部分式が書き込まれる。

```cpp
#include <iostream>
#include <boost/xpressive/xpressive.hpp>

using namespace boost::xpressive;

int main()
{
    std::string str = "私は1973/5/30の午前7時に生まれた。";

    sregex rex = sregex::compile("(\\d{4})/(\\d{1,2})/(\\d{1,2})");
    smatch what;
    if (regex_search(str, what, rex)) {
        std::cout << what[0] << std::endl; // マッチ全体
        std::cout << what[1] << std::endl; // 年
        std::cout << what[2] << std::endl; // 月
        std::cout << what[3] << std::endl; // 日
    }
}
```

出力：

```
1973/5/30
1973
5
30
```


## <a name="regex-replace" href="#regex-replace">正規表現にマッチした部分文字列をすべて置換する</a>

正規表現にマッチした部分文字列をすべて置換するには、[`boost::xpressive::regex_replace()`](http://www.boost.org/doc/libs/release/doc/html/boost/xpressive/regex_replace.html)関数を使用する。


この関数は、以下の引数をとる：

- 第1引数 ： 対象文字列
- 第2引数 ： 正規表現
- 第3引数 ： 置き換え規則

戻り値として、置き換え後の新たな文字列が返される。

ここでは、日付にマッチする正規表現を書き、マッチした部分を`<date>`タグで囲む、ということをしている。`"$&"`はマッチした全体の部分文字列を表す。

```cpp
#include <iostream>
#include <boost/xpressive/xpressive.hpp>

using namespace boost::xpressive;

int main()
{
    std::string str = "私は1973/5/30の午前7時に生まれた。";

    sregex date = sregex::compile("\\d{4}/\\d{1,2}/\\d{1,2}");
    std::string format = "<date>$&</date>";

    str = regex_replace(str, date, format);
    std::cout << str << std::endl;
}
```

出力：

```
私は<date>1973/5/30</date>の午前7時に生まれた。
```


## <a name="ignore-escape-sequence" href="#ignore-escape-sequence">正規表現の記述時に、エスケープシーケンスを無視する</a>

通常の文字列リテラルで正規表現を記述する場合、`\`がエスケープシーケンスであることを示すため、`\d`を`"\\d"`と書かなければならない。この問題を回避するためには、生文字列リテラル(Raw String Literals)を使用する。この機能は、C++11以降で使用できる。

生文字列リテラルは、`R`プレフィックスを付けた文字列リテラルで、丸カッコで囲まれた範囲のエスケープシーケンスを無視する。

```cpp
#include <iostream>
#include <boost/xpressive/xpressive.hpp>

using namespace boost::xpressive;

int main()
{
    std::string str = "私は1973/5/30の午前7時に生まれた。";

    sregex rex = sregex::compile(R"((\d{4})/(\d{1,2})/(\d{1,2}))");
    smatch what;
    if (regex_search(str, what, rex)) {
        std::cout << what[0] << std::endl; // マッチ全体
        std::cout << what[1] << std::endl; // 年
        std::cout << what[2] << std::endl; // 月
        std::cout << what[3] << std::endl; // 日
    }
}
```

出力：

```
1973/5/30
1973
5
30
```

documented boost version is 1.52.0
