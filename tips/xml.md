# XMLの読み込み／書き込み
XMLの読み込み、書き込みには、[Boost Property Tree Library](http://www.boost.org/doc/libs/release/doc/html/property_tree.html)を使用する。Boost.PropertyTreeは、ツリー構造の汎用プロパティ管理のためのライブラリで、XML, JSON, INIファイルなどへの統一的なアクセス方法を提供する。

ここでは、Boost.PropertyTreeを使用したXMLファイルの読み込みと書き込みを紹介する。


## インデックス
- [XMLを読み込む](#read)
- [属性を取得する](#get-attribute)
- [XMLを書き込む](#write)


## <a id="read" href="#read">XMLを読み込む</a>
XMLの読み込みには、`boost::property_tree::read_xml()`関数を使用する。

この関数を使用するには、`<boost/property_tree/xml_parser.hpp>`をインクルードする。

以下のXMLファイルを読み込んでみよう。

data.xml：
```
<?xml version="1.0" encoding="utf-8"?>

<root>
    <str>Hello</str>
    <values>
        <value>1</value>
        <value>2</value>
        <value>3</value>
    </values>
</root>
```

```cpp example
#include <iostream>
#include <string>
#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/xml_parser.hpp>
#include <boost/foreach.hpp>
#include <boost/lexical_cast.hpp>

int main()
{
    using namespace boost::property_tree;

    ptree pt;
    read_xml("data.xml", pt);

    if (boost::optional<std::string> str = pt.get_optional<std::string>("root.str")) {
        std::cout << str.get() << std::endl;
    }
    else {
        std::cout << "root.str is nothing" << std::endl;
    }

    BOOST_FOREACH (const ptree::value_type& child, pt.get_child("root.values")) {
        const int value = boost::lexical_cast<int>(child.second.data());
        std::cout << value << std::endl;
    }
}
```

実行結果：
```
Hello
1
2
3
```

まず、`root/str`要素を取得するには、XMLが読み込まれた`boost::property_tree:ptree`オブジェクトに対して以下のように指定する：

```cpp
boost::optional<std::string> str = pt.get_optional<std::string>("root.str");
```

要素アクセスのパス指定には、XPathではなくドットによるアクセスを行う。

`get_optional()`メンバ関数によって、指定された型に変換された要素が返される。要素の取得に失敗した場合は、`boost::optional`の無効値が返される。

次に、`root/values/value`の要素を列挙するには、`boost::property_tree::ptree`オブジェクトに対して、`get_child()`メンバ関数でパス指定し、子ツリーを取得する。取得した子ツリーを`BOOST_FOREACH`でループし、文字列型(`std::string`)として取得される各`value`要素を`int`に変換して取得している。

```cpp
BOOST_FOREACH (const ptree::value_type& child, pt.get_child("root.values") {
    …
}
```


## <a id="get-attribute" href="#get-attribute">属性を取得する</a>
XML要素の属性を取得するには、`"<xmlattr>"`という特殊な要素名をパス指定する。以下は、属性のあるXMLを読み込む例である：

data.xml：
```
<?xml version="1.0" encoding="utf-8"?>

<root>
    <data id="3" name="str"/>
</root>
```

```cpp example
#include <iostream>
#include <string>
#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/xml_parser.hpp>

int main()
{
    using namespace boost::property_tree;

    ptree pt;
    read_xml("data.xml", pt);

    if (boost::optional<int> id = pt.get_optional<int>("root.data.<xmlattr>.id")) {
        std::cout << id.get() << std::endl;
    }
    else {
        std::cout << "id is nothing" << std::endl;
    }

    if (boost::optional<std::string> name =
            pt.get_optional<std::string>("root.data.<xmlattr>.name")) {
        std::cout << name.get() << std::endl;
    }
    else {
        std::cout << "name is nothing" << std::endl;
    }
}
```
* <xmlattr>[color ff0000]

実行結果：
```
3
str
```


## <a id="write" href="#write">XMLを書き込む</a>
XMLを書き込むには、要素を追加するために`boost::property_tree::ptree`の`add()`メンバ関数を使用し、`put()`メンバ関数で値を設定する。

保存には、`boost::property_tree::write_xml()`関数に、ファイル名と`ptree`オブジェクトを指定する。

```cpp example
#include <vector>
#include <string>
#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/xml_parser.hpp>
#include <boost/foreach.hpp>

struct Book {
    std::string title;
    std::string author;

    Book() {}
    Book(const Book& other)
        : title(other.title), author(other.author) {}

    Book(const std::string& title, const std::string& author)
        : title(title), author(author) {}
};

int main()
{
    std::vector<Book> books;
    books.reserve(2);
    books.push_back(Book("D&E", "Bjarne Stroustrup"));
    books.push_back(Book("MC++D", "Andrei, Alexandrescu"));

    using boost::property_tree::ptree;

    ptree pt;
    BOOST_FOREACH (const Book& book, books) {
        ptree& child = pt.add("bookList.book", "");
        child.put("<xmlattr>.title",    book.title);
        child.put("<xmlattr>.author",   book.author);
    }

    using namespace boost::property_tree::xml_parser;
    const int indent = 2;
    write_xml("book.xml", pt, std::locale(),
        xml_writer_make_settings(' ', indent, widen<char>("utf-8")));
}
```

book.xml：
```
<?xml version="1.0" encoding="utf-8"?>
<bookList>
  <book title="D&E" author="Bjarne Stroustrup"/>
  <book title="MC++D" author="Andrei Alexandrescu"/>
</bookList>
```

`write_xml()`関数は、第3引数以降を省略した場合、インデントや改行が省略される。

`xml_writer_make_settings`を使用することで、インデントとエンコーディングを設定できる。


