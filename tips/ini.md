#iniファイルの読み込み／書き込み
iniの読み込み、書き込みには、[Boost Property Tree Library](http://www.boost.org/doc/libs/release/doc/html/property_tree.html)を使用する。Boost.PropertyTreeは、ツリー構造の汎用プロパティ管理のためのライブラリで、XML, JSON, INIファイルなどへの統一的なアクセス方法を提供する。

ここでは、Boost.PropertyTreeを使用したiniファイルの読み込みと書き込みを紹介する。


##インデックス
- [iniの読み込み](#read)
- [iniの書き込み](#write)


## <a name="read" href="read">iniの読み込み</a>
iniの読み込みには、`boost::property_tree::read_ini()`関数を使用する。

この関数を使用するには、`<boost/property_tree/ini_parser.hpp>`をインクルードする。

以下のiniファイルを読み込んでみよう。

data.ini

```
[Data]
value = 3
str = Hello
```


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
```

実行結果：

```
value : 3
str : Hello
```


Dataセクションのvalueキーの値を取得するには、iniが読み込まれた`boost::property_tree::ptree`に対して以下のように指定する：

```cpp
boost::optional<int> value = pt.get_optional<int>("Data.value");
```


**「セクション名 . キー」**のようにしてパスを指定する。


## <a name="write" href="write">iniの書き込み</a>
iniを書き込むには、要素を追加するために`boost::property_tree::ptree`の`put()`メンバ関数で値を設定する。

保存には、`boost::property_tree::write_ini()`関数に、ファイル名と`ptree`オブジェクトを指定する。


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
```

出力されたdata_out.ini ：

```
[Data]
value=3
str=Hello
```

