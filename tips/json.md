#JSONの読み込み／書き込み
JSONの読み込み、書き込みには、Boost Property Tree Libraryを使用する。Boost.PropertyTreeは、ツリー構造の汎用プロパティ管理のためのライブラリで、XML, JSON, INIファイルなどへの統一的なアクセス方法を提供する。

ここでは、Boost.PropertyTreeを使用したJSONファイルの読み込みと書き込みを紹介する。


Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>JSONの読み込み](#TOC-JSON-)</li><li class='goog-toc'>[<strong>2 </strong>JSONの書き込み](#TOC-JSON-1)</li><li class='goog-toc'>[<strong>3 </strong>応用編：キーにドット（.）が含まれる場合の子ノードの挿入](#TOC-.-)</li></ol>


<h4>JSONの読み込み</h4>JSONの読み込みには、boost::property_tree::read_json()関数を使用する。
この関数を使用するには、<boost/property_tree/json_parser.hpp>をインクルードする。

以下のJSONファイルを読み込んでみよう。

data.json
```cpp
{
   "Data": 
   {
      "value": 3,
      "str": "Hello",
      "info": 
      [
         {"id": 1, "name": "Alice"},
         {"id": 2, "name": "Millia"}
      ]
   }
}
```


```cpp
#include <iostream>
#include <string>
#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/json_parser.hpp>
#include <boost/foreach.hpp>
#include <boost/optional.hpp>

using namespace boost::property_tree;

int main()
{
    ptree pt;
    read_json("data.json", pt);

    // Data.value
    if (boost::optional<int> value = pt.get_optional<int>("Data.value")) {
        std::cout << "value : " << value.get() << std::endl;
    }
    else {
        std::cout << "value is nothing" << std::endl;
    }

    // Data.str
    if (boost::optional<std::string> str = pt.get_optional<std::string>("Data.str")) {
        std::cout << "str : " << str.get() << std::endl;
    }
    else {
        std::cout << "str is nothing" << std::endl;
    }

    // Data.info
    BOOST_FOREACH (const ptree::value_type& child, pt.get_child("Data.info")) {
        const ptree& info = child.second;

        // Data.info.id
        if (boost::optional<int> id = info.get_optional<int>("id")) {
            std::cout << "id : " << id.get() << std::endl;
        }
        else {
            std::cout << "id is nothing" << std::endl;
        }

        // Data.info.name
        if (boost::optional<std::string> name = info.get_optional<std::string>("name")) {
            std::cout << "name : " << name.get() << std::endl;
        }
        else {
            std::cout << "name is nothing" << std::endl;
        }
    }
}


実行結果：
```cpp
value : 3
str : Hello
id : 1
name : Alice
id : 2
name : Millia
```

まず、data.value要素を取得するには、JSONが読み込まれたboost::property_tree:ptreeに対して以下のように指定する：


```cpp
boost::optional<int> value = pt.get_optional<int>("Data.value")


要素アクセスのパス指定には、ドットによるアクセスを行う。
get_optional関数によって、指定された型に変換された要素が返される。要素の取得に失敗した場合は、boost::optionalの無効値が返される。


次に、Data.infoの要素を列挙するには、boost::property_tree::ptreeに対して、get_child()関数でパス指定し、子ツリーを取得する。取得した子ツリーをBOOST_FOREACHでループし、各要素を取得する。



```cpp
BOOST_FOREACH (const ptree::value_type& child, pt.get_child("Data.info"))



<h4>JSONの書き込み</h4>JSONを書き込むには、要素を設定するためにboost::property_tree::ptreeのput()メンバ関数を使用し、add_childで子ツリーに登録する。
保存には、boost::property_tree::write_jsonにファイル名とptreeを指定する。
```


```cpp
#include <iostream>
#include <string>
#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/json_parser.hpp>
#include <boost/foreach.hpp>
#include <boost/optional.hpp>

using namespace boost::property_tree;

int main()
{
    ptree pt;

    pt.put("Data.value", 3);
    pt.put("Data.str", "Hello");

    ptree child;
    {
        ptree info;
        info.put("id", 1);
        info.put("name", "Alice");
        child.push_back(std::make_pair("", info));
    }
    {
        ptree info;
        info.put("id", 2);
        info.put("name", "Millia");
        child.push_back(std::make_pair("", info));
    }
    pt.add_child("Data.info", child);

    write_json("data_out.json", pt);
}


出力されたdata_out.json：

```cpp
{
    "Data":
    {
        "value": "3",
        "str": "Hello",
        "info":
        [
            {
                "id": "1",
                "name": "Alice"
            },
            {
                "id": "2",
                "name": "Millia"
            }
        ]
    }
}
```

<h4>応用編：キーにドット（.）が含まれる場合の子ノードの挿入</h4>通常、`ptree` に子要素を追加する場合は `put_child()` または `add_child()` メンバ関数を利用するが、これら高レベル関数ではドットがセパレータとして扱われるので、キーにドットが含まれる場合は挿入がうまく行かない。

```cpp
【擬似コードによる処理の流れ】ptree::put_child(key_str, node) {　　key_strをパーズしてセパレータを認識する；　　this->push_back(パーズした子階層, node)；}
```

そこで、セパレータを無効にしたいキーがある場合は、そのキーに対して明示的にboost::property_tree::pathを初期化するステップを踏む。

```cpp
pt.put_child(    property_tree::path("result for \"test.dat\"", '\0') // セパレータを無効化    , {"success"});
```

出力例：
```cpp
{  "result for \"test.dat\"": "success"}



この方法は結構万能である。さらなる子階層への追加は operator / を利用し以下のようにする。

```cpp
property_tree::ptree result_data_pt;result_data_pt.push_back({"", 1234});result_data_pt.push_back({"", 5678});pt.put_child(    property_tree::path("result for \"test.dat\"", '\0') // セパレータを無効化        / "result_data",    result_data_pt);
```


 出力例：
```cpp
{    "result for \"test.dat\"": {        "result_data": [            1234,            5678        ]    }}
```
