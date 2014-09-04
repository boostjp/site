#iniファイルの読み込み／書き込み
iniの読み込み、書き込みには、Boost Property Tree Libraryを使用する。Boost.PropertyTreeは、ツリー構造の汎用プロパティ管理のためのライブラリで、XML, JSON, INIファイルなどへの統一的なアクセス方法を提供する。

ここでは、Boost.PropertyTreeを使用したiniファイルの読み込みと書き込みを紹介する。


Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>iniの読み込み](#TOC-ini-)</li><li class='goog-toc'>[<strong>2 </strong>iniの書き込み](#TOC-ini-1)</li></ol>


<h4>iniの読み込み</h4>iniの読み込みには、boost::property_tree::read_ini()関数を使用する。
この関数を使用するには、<boost/property_tree/ini_parser.hpp>をインクルードする。

以下のiniファイルを読み込んでみよう。

data.ini

```cpp
[Data]
value = 3
str = Hello



```cpp
#include <iostream>
#include <string>
#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/ini_parser.hpp>
#include <boost/optional.hpp>

using namespace boost::property_tree;

int main()
{
    ptree pt;
    read_ini("data.ini", pt);

    if (boost::optional<int> value = pt.get_optional<int>("Data.value")) {
        std::cout << "value : " << value.get() << std::endl;
    }
    else {
        std::cout << "value is nothing" << std::endl;
    }

    if (boost::optional<std::string> str = pt.get_optional<std::string>("Data.str")) {
        std::cout << "str : " << str.get() << std::endl;
    }
    else {
        std::cout << "str is nothing" << std::endl;
    }
}


実行結果：
```cpp
value : 3
str : Hello
```

Dataセクションのvalueキーの値を取得するには、iniが読み込まれたboost::property_tree:ptreeに対して以下のように指定する：


```cpp
boost::optional<int> value = pt.get_optional<int>("Data.value")


<b>「セクション名 . キー」</b>のようにしてパスを指定する。

<h4>iniの書き込み</h4>iniを書き込むには、要素を追加するためにboost::property_tree::ptreeのput()メンバ関数で値を設定する。
保存には、boost::property_tree::write_ini()にファイル名とptreeを指定する。
```


```cpp
#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/ini_parser.hpp>

using namespace boost::property_tree;

int main()
{
    ptree pt;

    pt.put("Data.value", 3);
    pt.put("Data.str", "Hello");

    write_ini("data_out.ini", pt);
}


出力されたdata_out.ini ：

```cpp
[Data]
value=3
str=Hello
```
