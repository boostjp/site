#静的な正規表現
正規表現には、[Boost Xpressive Library](http://www.boost.org/doc/libs/release/doc/html/xpressive.html)を使用する。
静的な正規表現の使い方を解説していく。


日本語リファレンス

[http://alpha.sourceforge.jp/devel/boost.xpressive_ja.pdf](http://alpha.sourceforge.jp/devel/boost.xpressive_ja.pdf)




Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>静的な正規表現とは](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>基本的な使い方](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>動的と静的の正規表現対応表](#TOC--2)</li><li class='goog-toc'>[<strong>4 </strong>文字列全体が正規表現にマッチするか調べる](#TOC--3)</li><li class='goog-toc'>[<strong>5 </strong>文字列が正規表現にマッチする部分文字列を含むか調べる](#TOC--4)</li><li class='goog-toc'>[<strong>6 </strong>正規表現にマッチした部分文字列をすべて置換する](#TOC--5)</li><li class='goog-toc'>[<strong>7 </strong>マッチ時に任意のアクションを行う](#TOC--6)</li><li class='goog-toc'>[<strong>8 </strong>マッチ条件を指定する](#TOC--7)</li></ol>






###静的な正規表現とは

ここで言う「静的な正規表現」とは、コンパイル時に正規表現を組み上げるということである。

式テンプレートを活用し、正規表現の正当性チェックがコンパイル時に行われる。


###基本的な使い方

静的な正規表現の基本的な使い方を解説する。まず、"Hello World!"という文字列から"Hello"と"World"という単語を抽出するコードは以下のようになる。



```cpp
#include <iostream>

#include <boost/xpressive/xpressive.hpp>
```

`using namespace boost::xpressive;`


`int main()`

`{`

`    std::string hello = "Hello World!";`


`    sregex rex = (s1= +_w) >> ' ' >> (s2= +_w) >> '!';`

`    smatch what;`

`    if (regex_match(hello, what, rex)) {`

`        std::cout << what[0] << std::endl; // マッチ全体`

`        std::cout << what[1] << std::endl; // 1 番目の捕捉`

`        std::cout << what[2] << std::endl; // 2 番目の捕捉`

`    }`

`}`




出力：


```cpp
Hello World!

Hello

World
```

正規表現は以下のように記述されている：


```cpp
(s1= +_w) >> ' ' >> (s2= +_w) >> '!'


```

これは、動的な正規表現では以下の記述に相当する：


```cpp
"(\\w+) (\\w+)!" 


```

静的な正規表現は、文字列ではなくC++の式で記述する。この方法をとることによる制限はいくつかある：

<ol>
- 「後続」を表すために>>演算子を使用する必要がある

- 「1回以上の繰り返し」を意味する+が前置である必要がある
</ol>

###動的と静的の正規表現対応表

ここでは、Boost.Xpressiveが提供する静的な正規表現と、通常の動的正規表現との対応表を紹介する。ここでは、動的正規表現としてPerl構文を例とする。




| | | |
|-----------------------------|-----------------------------------------------------------------------------|-------------------------------------------------------------------------|
| Perl | 静的Xpressive | 説明 |
|` .` |` _` |` 任意の1文字（Perlの/s修飾子が使われているとして）` |
|` ab` |` a >> b` |` aおよびb部分式の結合` |
|<code> a&#x7C;b</code> |<code> a &#x7C; b</code> |` aおよびb部分式の選択` |
|` (a)` |` (s1= a)` |` 後方参照のグループ化と捕捉` |
|` (?:a)` |` (a)` |` 後方参照の捕捉を伴わないグループ化` |
|` \1` |` s1` |` 以前捕捉した後方参照` |
|` a*` |` *a` |` 0回以上の貪欲な繰り返し` |
|` a+` |` +a` |` 1回以上の貪欲な繰り返し` |
|` a?` |` !a` |` 0回か1回の貪欲な繰り返し` |
|` a{n,m}` |` repeat<n,m>(a)` |` n回以上m回以下の貪欲な繰り返し` |
|` a*?` |` -*a` |` 0回以上の貪欲でない繰り返し` |
|` a+?` |` -+a` |` 1回以上の貪欲でない繰り返し` |
|` a??` |` -!a` |` 1回以上の貪欲でない繰り返し` |
|` a{n,m}?` |` -repeat<n,m>(a)` |` n回以上m回以下の貪欲でない繰り返し` |
|` ^` |` bos` |` シーケンスの先頭を表す表明` |
|` $` |` eos` |` シーケンスの終端を表す表明` |
|` \b` |` _b` |` 単語境界の表明` |
|` \B` |` ~_b` |` 単語境界以外の表明` |
|` \n` |` _n` |` リテラルの改行` |
|` .` |` ~_n` |` リテラルの改行以外の任意の1文字（Perlの/s修飾子が使われていないとして）` |
|<code> \r?\n&#x7C;\r</code> |` _ln` |` 論理改行` |
|` [^\r\n]` |` ~_ln` |` 論理改行以外の任意の1文字` |
|` \w` |` _w` |<code> 単語構成文字。set[alnum &#x7C; '_']と同じ</code> |
|` \W` |` ~_w` |<code> 単語構成文字以外。~set[alnum &#x7C;'_']と同じ</code> |
|` \d` |` _d` |` 数字` |
|` \D` |` ~_d` |` 数字以外` |
|` \s` |` _s` |` 空白類文字` |
|` \S` |` ~_s` |` 空白類文字以外` |
|` [:alnum:]` |` alnum` |` アルファベットおよび数値文字` |
|` [:alpha:]` |` alpha` |` アルファベット文字` |
|` [:blank:]` |` blank` |` 水平空白文字` |
|` [:cntrl:]` |` cntrl` |` 制御文字` |
|` [:digit:]` |` digit` |` 数字` |
|` [:graph:]` |` graph` |` グラフィカルな文字` |
|` [:lower:]` |` lower` |` 小文字` |
|` [:print:]` |` print` |` 印字可能な文字` |
|` [:punct:]` |` punct` |` 区切り文字` |
|` [:space:]` |` space` |` 空白類文字` |
|` [:upper:]` |` upper` |` 大文字` |
|` [:xdigit:]` |` xdigit` |` 16進数字` |
|` [0-9]` |` range('0','9')` |` '0'から'9'の範囲の文字` |
|` [abc]` |<code> as_xpr('a') &#x7C; 'b' &#x7C; 'c'</code> |` 'a'、'b'、または'c'のいずれかの文字` |
|` [abc]` |` (set= 'a','b','c')` |` 同上` |
|` [0-9abc]` |<code> set[ range('0','9') &#x7C; 'a' &#x7C; 'b' &#x7C; 'c' ]</code> |` 'a'、'b'、または'c'のいずれか、または'0'から'9'の範囲の文字` |
|` [0-9abc]` |<code> set[ range('0','9') &#x7C; (set= 'a','b','c') ]</code> |` 同上` |
|` [^abc]` |` ~(set= 'a','b','c')` |` 'a'、'b'、または'c'のいずれでもない文字` |
|` (?i:stuff)` |` icase(stuff)` |` stuffの大文字小文字を区別しないマッチを行う` |
|` (?>stuff)` |` keep(stuff)` |` 独立部分式。stuffのマッチを行いバックトラックを切る。` |
|` (?=stuff)` |` before(stuff)` |` 肯定先読み表明。stuffの前にマッチするが、stuff自身はマッチに含まない。` |
|` (?!stuff)` |` ~before(stuff)` |` 否定先読み表明。stuff の前以外にマッチ。` |
|` (?<=stuff)` |` after(stuff)` |` 肯定後読み表明。stuffの後にマッチするがstuff自身はマッチに含まない（stuffは固定長でなければならない）。` |
|` (?<!stuff)` |` ~after(stuff)` |` 否定後読み表明` |
|` (?P<name>stuff)` |` mark_tag name(n);`<br/>` ...`<br/>` (name= stuff)` |` 名前付きの補足を作成` |
|` (?P=name)` |` mark_tag name(n);`<br/>` ...`<br/>` name` |` 作成した名前付き捕捉への後方参照` |




###文字列全体が正規表現にマッチするか調べる

文字列全体が正規表現にマッチするか調べるには、[`boost::xpressive::regex_match()`](http://www.boost.org/doc/libs/release/doc/html/boost/xpressive/regex_match.html)関数を使用する。



この関数は、マッチに成功したら`true`を返し、そうでなければ`false`を返す。この関数が成功するのは、文字列全体の先頭から終端までが正規表現にマッチする場合である。

この関数に[`boost::xpressive::smatch`](http://www.boost.org/doc/libs/release/doc/html/xpressive/user_s_guide.html#boost_xpressive.user_s_guide.quick_start.know_your_iterator_type)オブジェクトへの参照を与えると、見つかったマーク済み部分式が書き込まれる。



「基本的な使い方」で示したコードと同じだが、再掲する。




```cpp
#include <iostream>

#include <boost/xpressive/xpressive.hpp>
```

`using namespace boost::xpressive;`


`int main()`

`{`

`    std::string hello = "Hello World!";`


`    sregex rex = (s1= +_w) >> ' ' >> (s2= +_w) >> '!';`

`    smatch what;`

`    if (<color=ff0000>regex_match</color>(hello, what, rex)) {`

`        std::cout << what[0] << std::endl; // マッチ全体`

`        std::cout << what[1] << std::endl; // 1 番目の捕捉`

`        std::cout << what[2] << std::endl; // 2 番目の捕捉`

`    }`

`}`





出力：



```cpp
Hello World!

Hello

World
```

###文字列が正規表現にマッチする部分文字列を含むか調べる

文字列が正規表現にマッチする部分文字列を含むか調べるには、[`boost::xpressive::regex_search()`](http://www.boost.org/doc/libs/release/doc/html/boost/xpressive/regex_search.html)関数を使用する。


この関数は、マッチする部分文字列が見つかったら`true`、そうでなければ`false`を返す。対象となる文字列の次の引数として[`boost::xpressive::smatch`](http://www.boost.org/doc/libs/release/doc/html/xpressive/user_s_guide.html#boost_xpressive.user_s_guide.quick_start.know_your_iterator_type)オブジェクトへの参照を与えると、見つかったマーク済み部分式が書き込まれる。




```cpp
#include <iostream>

#include <boost/xpressive/xpressive.hpp>
```

using namespace boost::xpressive;


int main()

{

    std::string str = "私は1973/5/30の午前7時に生まれた。";


    // s1、s2、...よりも意味のある名前でカスタムのmark_tagsを定義する

    mark_tag day(1), month(2), year(3), delim(4);


    // この正規表現は日付を検索する

    sregex date = (year=  repeat<1,4>(_d))          // 先頭に年があり...

               >> (delim= (set= '/','-'))           // その後ろに区切りがあり ...

               >> (month= repeat<1,2>(_d)) >> delim // さらに後ろに月と、同じ区切りがあり ...

               >> (day=   repeat<1,2>(_d));         // 最後に日がある。


    smatch what;

    if (<color=ff0000>regex_search(str, what, date)) {</color>

        std::cout << what[0]     << '\n'; // マッチ全体

        std::cout << what[year]  << '\n'; // 年

        std::cout << what[month] << '\n'; // 月

        std::cout << what[day]   << '\n'; // 日

        std::cout << what[delim] << '\n'; // 区切り

    }

}



出力：


```cpp
1973/5/30

1973

5

30

/
```

この例では、カスタムの[`mark_tag`](http://www.boost.org/doc/libs/release/doc/html/boost/xpressive/mark_tag.html)を使ってパターンを読みやすくしている。後で[`mark_tag`](http://www.boost.org/doc/libs/release/doc/html/boost/xpressive/mark_tag.html)を[boost::xpressive::smatch](http://www.boost.org/doc/libs/release/doc/html/xpressive/user_s_guide.html#boost_xpressive.user_s_guide.quick_start.know_your_iterator_type)の添字に使っている。




###正規表現にマッチした部分文字列をすべて置換する

正規表現にマッチした部分文字列をすべて置換するには、[`boost::xpressive::regex_replace()`](http://www.boost.org/doc/libs/release/doc/html/boost/xpressive/regex_replace.html)関数を使用する。


この関数は、以下の引数をとる：


- 第1引数 ： 対象文字列

- 第2引数 ： 正規表現

- 第3引数 ： 置き換え規則

戻り値として、置き換え後の新たな文字列が返される。


ここでは、日付にマッチする正規表現を書き、マッチした部分をHTMLの<date>タグで囲む、ということをしている。`"$&"`はマッチした全体の部分文字列を表す。




```cpp
#include <iostream>

#include <boost/xpressive/xpressive.hpp>
```

using namespace boost::xpressive;


int main()

{

    std::string str = "私は1973/5/30の午前7時に生まれた。";


    sregex date = repeat<1,4>(_d)

               >> as_xpr('/')

               >> repeat<1,2>(_d)

               >> as_xpr('/')

               >> repeat<1,2>(_d);


    std::string format = "<date>$&</date>";


    str = <color=ff0000>regex_replace(str, date, format);</color>

    std::cout << str << std::endl;

}




出力：


```cpp
私は<date>1973/5/30</date>の午前7時に生まれた。


```

###マッチ時に任意のアクションを行う

マッチ時に任意のアクションを行うには、「[セマンティックアクション](http://www.boost.org/doc/libs/release/doc/html/xpressive/user_s_guide.html#boost_xpressive.user_s_guide.semantic_actions_and_user_defined_assertions)」という機能を使用する。

セマンティックアクションには、各部分式の後ろに [ ... ] という形式で記述する。


以下は、日付が含まれる文章から、年、月、日を抽出し、各要素を変数に代入する処理である：




```cpp
#include <iostream>

#include <boost/xpressive/xpressive.hpp>

#include <boost/xpressive/regex_actions.hpp>
```

`using namespace boost::xpressive;`


`int main()`

`{`

`    std::string str = "私は1973/5/30の午前7時に生まれた。";`


`    int year = 0;`

`    int month = 0;`

`    int day = 0;`


`    // この正規表現は日付を検索する`

`    sregex date = repeat<1,4>(_d)[ <color=ff0000>ref(year) = as<int>(_)</color> ]`

`               >> as_xpr('/')`

`               >> repeat<1,2>(_d)[ ref(month) = as<int>(_) ]`

`               >> as_xpr('/')`

`               >> repeat<1,2>(_d)[ ref(day) = as<int>(_) ];`


`    if (!regex_search(str, date)) {`

`        std::cout << "match failed" << std::endl;`

`        return 1;`

`    }`


`    std::cout << year << std::endl;`

`    std::cout << month << std::endl;`

`    std::cout << day << std::endl;`

`}`




出力：


```cpp
1973

5

30
```

`ref()`は、変数を参照するための関数である。ref()でラップしないで変数を記述すると、正規表現を定義した段階での変数の値が使用されてしまう。


`as<T>()`は、マッチした値を任意の型に変換するための関数である。

その引数として渡している `_` は「プレースホルダー」と呼ばれる特殊な値で、マッチした値で置き換えられる。



###マッチ条件を指定する

整数や文字といったパターンにマッチした後、より詳細な値チェックが通ったらマッチ成功と見なす方法として、セマンティックアクションでの`check()`関数が提供されている。


以下は、日付の値チェックをする例である：


```cpp
#include <iostream>

#include <boost/xpressive/xpressive.hpp>

#include <boost/xpressive/regex_actions.hpp>
```

`using namespace boost::xpressive;`


`int main()`

`{`

`    std::string str = "私は1973/5/30の午前7時に生まれた。";`


`    mark_tag day(1), month(2), year(3), delim(4);`


`    sregex date = (year=  repeat<1,4>(_d)) [ <color=ff0000>check</color>(as<int>(_) >= 1970) ]`

`               >> (delim= (set= '/','-'))`

`               >> (month= repeat<1,2>(_d)) [ check(as<int>(_) >= 1 &&`

`                                                   as<int>(_) <= 12) ]`

`               >> delim`

`               >> (day=   repeat<1,2>(_d)) [ check(as<int>(_) >= 1 &&`

`                                                   as<int>(_) <= 31) ];`


`    smatch what;`

`    if (regex_search(str, what, date)) {`

`        std::cout << what[0]     << std::endl; // マッチ全体`

`        std::cout << what[year]  << std::endl; // 年`

`        std::cout << what[month] << std::endl; // 月`

`        std::cout << what[day]   << std::endl; // 日`

`        std::cout << what[delim] << std::endl; // 区切り`

`    }`

`    else {`

`        std::cout << "match failed" << std::endl;`

`    }`

`}`




出力：


```cpp
1973/5/30

1973

5

30

/
```

この場合、年、月、日が範囲外の値だったらマッチ失敗と見なされる。




documentation version is 1.52.0

