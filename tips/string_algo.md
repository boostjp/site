#文字列操作
標準ライブラリの文字列に対する操作は、不足しているものが多い。たとえば、前後のスペースを削除する`trim()`関数や、指定した区切り文字で文字列を分解してくれる`split(`)関数などだ。[Boost String Algo Library](http://www.boost.org/doc/libs/release/libs/algorithm/string/)は、このような文字列に対するアルゴリズムの関数を提供するライブラリである。


##インデックス
- [前後のスペースを削除する](#trim)
- [左のスペースを削除する](#trim-left)
- [右のスペースを削除する](#trim-right)
- [区切り文字で文字列を分割する](#split)
- [区切り文字を指定して、コンテナを文字列化する](#join)
- [拡張子を判定する](#iends-with)
- [全て置き換える](#replace-all)


## <a name="trim" href="#trim">前後のスペースを削除する</a>
文字列の前後にあるスペースを削除するには、[`boost::algorithm::trim()`](http://www.boost.org/doc/libs/release/doc/html/boost/algorithm/trim.html)関数、もしくは[`boost::algorithm::trim_copy()`](http://www.boost.org/doc/libs/release/doc/html/boost/algorithm/trim_copy.html)関数を使用する。

`trim()`関数は引数として渡された文字列自身を書き換え、`trim_copy()`関数は、前後のスペースを削除した文字列のコピーを返す。

```cpp
#include <iostream>
#include <string>
#include <boost/algorithm/string/trim.hpp>

int main()
{
    // 破壊的な変更を行うバージョン
    {
        std::string s = "  abc   ";

        boost::algorithm::trim(s);
        std::cout << '[' << s << ']' << std::endl;
    }

    // コピーを返すバージョン
    {
        const std::string s = "  abc   ";

        const std::string result = boost::algorithm::trim_copy(s);
        std::cout << '[' << result << ']' << std::endl;
    }
}
```

実行結果：
```
[abc]
[abc]
```


## <a name="trim-left" href="#trim-left">左のスペースを削除する</a>
左のスペースを削除するには、[`boost::algorithm::trim_left()`](http://www.boost.org/doc/libs/release/doc/html/boost/algorithm/trim_left.html)関数、もしくは[`boost::algorithm::trim_left_copy()`](http://www.boost.org/doc/libs/release/doc/html/boost/algorithm/trim_left_copy.html)関数を使用する。

`trim_left()`関数は、引数として渡された文字列自身を書き換え、`trim_left_copy()`関数は、左のスペースを削除した文字列のコピーを返す。

```cpp
#include <iostream>
#include <string>
#include <boost/algorithm/string/trim.hpp>

int main()
{
    // 破壊的な変更を行うバージョン
    {
        std::string s = "  abc   ";

        boost::algorithm::trim_left(s);
        std::cout << '[' << s << ']' << std::endl;
    }

    // コピーを返すバージョン
    {
        const std::string s = "  abc   ";

        const std::string result = boost::algorithm::trim_left_copy(s);
        std::cout << '[' << result << ']' << std::endl;
    }
}
```

実行結果：
```
[abc   ]
[abc   ]
```


## <a name="trim-right" href="#trim-right">右のスペースを削除する</a>
左のスペースを削除するには、[`boost::algorithm::trim_right()`](http://www.boost.org/doc/libs/release/doc/html/boost/algorithm/trim_right.html)関数、もしくは[`boost::algorithm::trim_right_copy()`](http://www.boost.org/doc/libs/release/doc/html/boost/algorithm/trim_right_copy.html)関数を使用する。

`trim_right()`関数は、引数として渡された文字列自身を書き換え、`trim_right_copy()`関数は、右のスペースを削除した文字列のコピーを返す。

```cpp
#include <iostream>
#include <string>
#include <boost/algorithm/string/trim.hpp>

int main()
{
    // 破壊的な変更を行うバージョン
    {
        std::string s = "  abc   ";

        boost::algorithm::trim_right(s);
        std::cout << '[' << s << ']' << std::endl;
    }

    // コピーを返すバージョン
    {
        const std::string s = "  abc   ";

        const std::string result = boost::algorithm::trim_right_copy(s);
        std::cout << '[' << result << ']' << std::endl;
    }
}
```

実行結果：
```
[  abc]
[  abc]
```


## <a name="split" href="#split">区切り文字で文字列を分割する</a>
指定した区切り文字で文字列を分割するには、[`boost::algorithm::split()`](http://www.boost.org/doc/libs/1_53_0/doc/html/boost/algorithm/split_idp83847184.html)関数を使用する。

第1引数には、分割された文字列の結果を受け取るコンテナ、第2引数には対象となる文字列、第3引数には区切り文字かどうかを判定する述語を指定する。

```cpp
#include <iostream>
#include <string>
#include <vector>
#include <boost/algorithm/string/classification.hpp> // is_any_of
#include <boost/algorithm/string/split.hpp>
#include <boost/range/algorithm/for_each.hpp>

void disp(const std::string& s)
{
    std::cout << s << std::endl;
}

int main()
{
    const std::string s = "abc,123,xyz";

    std::vector<std::string> result;
    boost::algorithm::split(result, s, boost::is_any_of(",")); // カンマで分割

    boost::for_each(result, disp);
}
```

実行結果：
```
abc
123
xyz
```


## <a name="join" href="#join">区切り文字を指定して、コンテナを文字列化する</a>
区切り文字を指定してコンテナを文字列化するには、[`boost::algorithm::join()`](http://www.boost.org/doc/libs/release/doc/html/boost/algorithm/join.html)関数を使用する。

第1引数には文字列のコンテナ、第2引数には、区切り文字列を指定する。

```cpp
#include <iostream>
#include <vector>
#include <string>
#include <boost/algorithm/string/join.hpp>

int main()
{
    const std::vector<std::string> v = {"a", "b", "c"};

    // カンマ区切りの文字列にする
    const std::string s = boost::algorithm::join(v, ",");
    std::cout << s << std::endl;
}
```
* join[color ff0000]

実行結果：
```
a,b,c
```


## <a name="iends-with" href="#iends-with">拡張子を判定する</a>
拡張子の判定には、[`boost::algorithm::iends_with()`](http://www.boost.org/doc/libs/release/doc/html/boost/algorithm/iends_with.html)関数を使用する。

この関数は、第1引数の対象文字列が、第2引数の文字列で終了するかどうかを判定する。

```cpp
#include <iostream>
#include <string>
#include <boost/algorithm/string/predicate.hpp> // iends_with

bool is_cpp_file(const std::string& filename)
{
    return boost::algorithm::iends_with(filename, ".cpp");
}

int main()
{
    const std::string filename = "example.cpp";

    const bool result = is_cpp_file(filename);
    std::cout << std::boolalpha << result << std::endl;
}
```

実行結果：
```
true
```


## <a name="replace-all" href="#replace-all">全て置き換える</a>
標準ライブラリの`replace()`関数は、最初に見つけた要素しか置き換えない。
[`boost::algorithm::replace_all()`](http://www.boost.org/doc/libs/release/doc/html/boost/algorithm/replace_all.html)関数、もしくは[`boost::algorithm::replace_all_copy()`](http://www.boost.org/doc/libs/release/doc/html/boost/algorithm/replace_all_copy.html)関数を使用すれば、該当する要素全てを置き換えることができる。

```cpp
#include <iostream>
#include <string>
#include <boost/algorithm/string/replace.hpp>

int main()
{
    // 破壊的な変更を行うバージョン
    {
        std::string s = "Hello Jane, Hello World!";

        // 全ての"Hello"を"Goodbye"に置き換える
        boost::algorithm::replace_all(s, "Hello", "Goodbye");
        std::cout << s << std::endl;
    }

    // コピーを返すバージョン
    {
        const std::string s = "Hello Jane, Hello World!";

        const std::string result = boost::algorithm::replace_all_copy(s, "Hello", "Goodbye");
        std::cout << result << std::endl;
    }
}
```

実行結果：
```
Goodbye Jane, Goodbye World!
Goodbye Jane, Goodbye World!
```

