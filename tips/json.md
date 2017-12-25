# JSONの読み込み／書き込み
JSONの読み込み、書き込みには、[Boost Property Tree Library](http://www.boost.org/doc/libs/release/doc/html/property_tree.html)を使用する。Boost.PropertyTreeは、ツリー構造の汎用プロパティ管理のためのライブラリで、XML, JSON, INIファイルなどへの統一的なアクセス方法を提供する。

ここでは、Boost.PropertyTreeを使用したJSONファイルの読み込みと書き込みを紹介する。


# インデックス
- [JSONの読み込み](#read)
- [JSONの書き込み](#write)
- [応用編：キーにドット（.）が含まれる場合の子ノードの挿入](#key-includes-dot)


## <a id="read" href="#read">JSONの読み込み</a>
JSONの読み込みには、`Pboost::property_tree::read_json()`関数を使用する。

この関数を使用するには、`<boost/property_tree/json_parser.hpp>`をインクルードする。

以下のJSONファイルを読み込んでみよう。

data.json
```
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


```cpp example
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
```

実行結果：
```
value : 3
str : Hello
id : 1
name : Alice
id : 2
name : Millia
```

まず、「Data.value」要素を取得するには、JSONが読み込まれた`boost::property_tree:ptree`に対して以下のように指定する：

```cpp
boost::optional<int> value = pt.get_optional<int>("Data.value");
```

要素アクセスのパス指定には、ドットによるアクセスを行う。

`ptree`クラスの`get_optional()`メンバ関数によって、指定された型に変換された要素が返される。要素の取得に失敗した場合は、`boost::optional`型の無効値が返される。


次に、「Data.info」の要素を列挙するには、`boost::property_tree::ptree`オブジェクトに対して、`get_child()`メンバ関数でパス指定し、子ツリーを取得する。取得した子ツリーを`BOOST_FOREACH`でループし、各要素を取得する。

```cpp
BOOST_FOREACH (const ptree::value_type& child, pt.get_child("Data.info")) {
    …
}
```


## <a id="write" href="#write">JSONの書き込み</a>
JSONを書き込むには、要素を設定するために`boost::property_tree::ptree`クラスの`put()`メンバ関数を使用し、`add_child()`メンバで子ツリーに登録する。

保存には、`boost::property_tree::write_json()`関数に、ファイル名と`ptree`オブジェクトを指定する。


```cpp example
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
```

出力されたdata_out.json：
```
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


## <a id="key-includes-dot" href="#key-includes-dot">応用編：キーにドット（.）が含まれる場合の子ノードの挿入</a>
通常、`ptree`オブジェクト に子要素を追加する場合は `put_child()`メンバ関数 または `add_child()` メンバ関数を利用するが、これら高レベル関数ではドットが区切り文字として扱われるので、キーにドットが含まれる場合は挿入がうまく行かない。

```cpp
【擬似コードによる処理の流れ】
R ptree::put_child(key_str, node) {
    key_strをパーズしてセパレータを認識する；
    this->push_back(パーズした子階層, node);
}
```

そこで、区切り文字を無効にしたいキーがある場合は、そのキーに対して明示的に`boost::property_tree::path`クラスを初期化するステップを踏む。

```cpp
pt.put_child(
      property_tree::path("result for \"test.dat\"", '\0') // セパレータを無効化
    , {"success"}
);
```

出力例：
```
{
    "result for \"test.dat\"": "success"
}
```

この方法は結構万能である。さらなる子階層への追加は `operator /` を利用し以下のようにする。

```cpp
property_tree::ptree result_data_pt;
result_data_pt.push_back({"", 1234});
result_data_pt.push_back({"", 5678});
pt.put_child(
    property_tree::path("result for \"test.dat\"", '\0') // セパレータを無効化
        / "result_data",
    result_data_pt);
```


出力例：
```
{
    "result for \"test.dat\"": {
        "result_data": [
            1234,
            5678
        ]
    }
}
```

