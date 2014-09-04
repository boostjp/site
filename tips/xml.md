#XMLの読み込み／書き込み
XMLの読み込み、書き込みには、Boost Property Tree Libraryを使用する。Boost.PropertyTreeは、ツリー構造の汎用プロパティ管理のためのライブラリで、XML, JSON, INIファイルなどへの統一的なアクセス方法を提供する。

ここでは、Boost.PropertyTreeを使用したXMLファイルの読み込みと書き込みを紹介する。


Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>XML要素の読み込み](#TOC-XML-)</li><li class='goog-toc'>[<strong>2 </strong>属性の取得](#TOC--)</li><li class='goog-toc'>[<strong>3 </strong>XMLの書き込み](#TOC-XML-1)</li></ol>


<h4>XML要素の読み込み</h4>XMLの読み込みには、boost::property_tree::read_xml()関数を使用する。
この関数を使用するには、<boost/property_tree/xml_parser.hpp>をインクルードする。

以下のXMLファイルを読み込んでみよう。

data.xml
```cpp
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

```cpp
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


実行結果：
```cpp
Hello
1
2
3
```

まず、root/str要素を取得するには、XMLが読み込まれたboost::property_tree:ptreeに対して以下のように指定する：

<span style='font-family:monospace;line-height:13px'>```cpp
boost::optional<std::string> str = pt.get_optional<std::string>("root.str")
</span>


要素アクセスのパス指定には、XPathではなくドットによるアクセスを行う。
get_optional関数によって、指定された型に変換された要素が返される。要素の取得に失敗した場合は、boost::optionalの無効値が返される。



次に、root/values/valueの要素を列挙するには、boost::property_tree::ptreeに対して、get_child()関数でパス指定し、子ツリーを取得する。取得した子ツリーをBOOST_FOREACHでループし、文字列型(std::string)として取得される各value要素をintに変換して取得している。


<span style='line-height:13px'><span style='font-family:monospace'>```cpp
BOOST_FOREACH (const ptree::value_type& child, pt.get_child("root.values")
</span></span>


<h4>属性の取得</h4>XML要素の属性を取得するには、"<xmlattr>"という特殊な要素名をパス指定することにより、取得できる。以下は、属性のあるXMLを読み込む例である：
data.xml
```cpp
<?xml version="1.0" encoding="utf-8"?>

<root>
    <data id="3" name="str"/>
</root>

```cpp
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

実行結果：
```cpp
3
str



<h4>XMLの書き込み</h4>XMLを書き込むには、要素を追加するためにboost::property_tree::ptreeのadd()メンバ関数を使用し、put()メンバ関数で値を設定する。
保存には、boost::property_tree::write_xmlにファイル名とptreeを指定する。
```cpp
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

book.xml
```cpp
<?xml version="1.0" encoding="utf-8"?>
<bookList>
  <book title="D&E" author="Bjarne Stroustrup"/>
  <book title="MC++D" author="Andrei Alexandrescu"/>
</bookList>
```

write_xmlは、第3引数以降を省略した場合、インデントや改行が省略される。
xml_writer_make_settingsを使用することで、インデントとエンコーディングを設定することができる。


