#ファイル／ディレクトリ操作
ファイル／ディレクトリ操作には、[Boost Filesystem Library](http://www.boost.org/libs/filesystem/doc/index.htm)を使用する。Boost Filesystem Libraryは、多くのプラットフォーム、コンパイラで動作する汎用的なファイル／ディレクトリ操作のライブラリである。このライブラリはビルドを必要する。


Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>エラーハンドリング](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>ファイルのコピー](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>ファイルの削除](#TOC--2)</li><li class='goog-toc'>[<strong>4 </strong>ファイルの移動 or ファイル名の変更](#TOC-or-)</li><li class='goog-toc'>[<strong>5 </strong>ファイルの存在チェック](#TOC--3)</li><li class='goog-toc'>[<strong>6 </strong>ファイルサイズの取得](#TOC--4)</li><li class='goog-toc'>[<strong>7 </strong>ファイルの最終更新日時を取得](#TOC--5)</li><li class='goog-toc'>[<strong>8 </strong>ディレクトリの作成](#TOC--6)</li><li class='goog-toc'>[<strong>9 </strong>ディレクトリ内のファイルを列挙](#TOC--7)</li><li class='goog-toc'>[<strong>10 </strong>ディレクトリ内の全てのファイルを再帰的に列挙](#TOC--8)</li></ol>



<h4>エラーハンドリング</h4>Boost Filesystem Libraryのエラーハンドリングは、例外を投げるバージョン、エラーを参照で返すバージョンの2種類が存在する。

<b>例外バージョン</b>

何も指定しなければ、Boost Filesystem Libraryの関数でエラーが出た場合にはboost::filesystem::filesystem_error例外が投げられる。

<code style='color:rgb(0,96,0)'>namespace fs = boost::filesystem;</code>
<code style='color:rgb(0,96,0)'>try {</code>
<code style='color:rgb(0,96,0)'>    fs::foo();</code>
<code style='color:rgb(0,96,0)'>}</code>
<code style='color:rgb(0,96,0)'>catch (fs::filesystem_error& ex) {</code>
<code style='color:rgb(0,96,0)'>    std::cout << "エラー発生！ : " << ex.what() << std::endl;</code><code style='color:rgb(0,96,0)'>}</code>

<b>エラーを参照で返すバージョン</b>

Boost Filesystem Libraryの最後の引数として、boost::system::error_codeの変数を渡せば、例外ではなく渡したエラー用変数にエラー情報が格納される。

<code style='color:rgb(0,96,0)'>namespace fs = boost::filesystem;</code>

<code style='color:rgb(0,96,0)'>boost::system::error_code error;</code>
<code style='color:rgb(0,96,0)'>fs::foo(error);</code>

<code style='color:rgb(0,96,0)'>if (error) {</code>
<code style='color:rgb(0,96,0)'>    std::cout << "エラー発生！ : " << error.message() << std::endl;</code>
<code style='color:rgb(0,96,0)'>}</code>

<h4>ファイルのコピー</h4>ファイルをコピーするには、boost::filesystem::copy_file()を使用する。
第1引数はコピー元のパス、第2引数はコピー先のパスである。
コピーに失敗した場合は例外が投げられる。

```cpp
#include <iostream>
#include <boost/filesystem.hpp>

namespace fs = boost::filesystem;

int main()
{
    const fs::path path("dir1/a.txt"); // コピー元
    const fs::path dest("dir2/a.txt"); // コピー先

    try {
        fs::copy_file(path, dest);
    }
    catch (fs::filesystem_error& ex) {
        std::cout << ex.what() << std::endl;
        throw;
    }
}
```

上書きコピーをする場合は、copy_file()関数に、copy_option::overwrite_if_existsオプションを指定する。

```cpp
#include <iostream>
#include <boost/filesystem.hpp>

namespace fs = boost::filesystem;

int main()
{
    const fs::path path("dir1/a.txt");
    const fs::path dest("dir2/a.txt");

    try {
        fs::copy_file(path, dest, fs::copy_option::overwrite_if_exists);
    }
    catch (fs::filesystem_error& ex) {
        std::cout << ex.what() << std::endl;
        throw;
    }
}
```

<h4>ファイルの削除</h4>ファイルを削除するには、boost::filesystem::remove()を使用する。

```cpp
#include <iostream>
#include <boost/filesystem.hpp>

namespace fs = boost::filesystem;

int main()
{
    const fs::path path("dir1/a.txt");

    try {
        fs::remove(path);
    }
    catch (fs::filesystem_error& ex) {
        std::cout << ex.what() << std::endl;
        throw;
    }
}
```

<h4>ファイルの移動 or ファイル名の変更</h4>ファイルの移動、ファイル名の変更には、boost::filesystem::rename()を使用する。
第1引数は、元となるファイルのパス。
第2引数は、移動先のファイルパス、もしくは新たなファイル名。

```cpp
#include <iostream>
#include <boost/filesystem.hpp>

namespace fs = boost::filesystem;

int main()
{
    const fs::path path("dir1/a.txt");
    const fs::path dest("dir2/b.txt");

    try {
        fs::rename(path, dest);
    }
    catch (fs::filesystem_error& ex) {
        std::cout << ex.what() << std::endl;
        throw;
    }
}
```

<h4>ファイルの存在チェック</h4>ファイルが存在するか調べるには、boost::filesystem::exists()を使用する。
ファイルが存在する場合はtrueを返し、存在しない場合はfalseを返す。
ファイルのステータス取得に失敗した場合はエラーを返す。

```cpp
#include <iostream>
#include <boost/filesystem.hpp>

namespace fs = boost::filesystem;

int main()
{
    const fs::path path("dir1/a.txt");

    boost::system::error_code error;
    const bool result = fs::exists(path, error);
    if (!result || error) {
        std::cout << "ファイルがない" << std::endl;
    }
    else {
        std::cout << "ファイルがあった" << std::endl;
    }
}
```

<h4>ファイルサイズの取得</h4>ファイルサイズを取得するには、boost::filesystem::file_size()を使用する。

```cpp
#include <iostream>
#include <boost/filesystem.hpp>

namespace fs = boost::filesystem;

int main()
{
    const fs::path path("dir1/a.txt");

    try {
        const boost::uintmax_t size = fs::file_size(path);

        std::cout << "ファイルサイズ: " << size << std::endl;
    }
    catch (fs::filesystem_error& ex) {
        std::cout << ex.what() << std::endl;
        throw;
    }
}
```

実行結果の例:
```cpp
ファイルサイズ: 5107200
```

<h4>ファイルの最終更新日時を取得</h4>ファイルの最終更新日時を取得するには、boost::filesystem::last_write_time()を使用する。
これは戻り値として、std::time_t型を返す。

```cpp
#include <iostream>
#include <boost/filesystem.hpp>
#include <boost/date_time/posix_time/posix_time.hpp>

namespace fs = boost::filesystem;

int main()
{
    try {
        const fs::path path("dir1/a.txt");
        const std::time_t last_update = fs::last_write_time(path);

        const boost::posix_time::ptime time = boost::posix_time::from_time_t(last_update);
        std::cout << time << std::endl;
    }
    catch (fs::filesystem_error& ex) {
        std::cout << "エラー発生！ : " << ex.what() << std::endl;
    }
}
```

実行結果の例：
```cpp
2011-Mar-30 05:56:11
```

<h4>ディレクトリの作成</h4>ディレクトリを作成するには、boost::filesystem::create_directory()を使用する。
引数として、ディレクトリのパスを指定する。
ネストしたディレクトリを一気に作ろうとした場合はエラーとなる。

```cpp
#include <iostream>
#include <boost/filesystem.hpp>

namespace fs = boost::filesystem;

int main()
{
    const fs::path path("dir");

    boost::system::error_code error;
    const bool result = fs::create_directory(path, error);
    if (!result || error) {
        std::cout << "ディレクトリの作成に失敗" << std::endl;
    }
}
```

ネストしたディレクトリを含めて一気に作成するには、boost::filesystem::create_directories()を使用する。

```cpp
#include <iostream>
#include <boost/filesystem.hpp>

namespace fs = boost::filesystem;

int main()
{
    const fs::path path("dir1/dir2");

    boost::system::error_code error;
    const bool result = fs::create_directories(path, error);
    if (!result || error) {
        std::cout << "ディレクトリの作成に失敗" << std::endl;
    }
}
```

<h4>ディレクトリ内のファイルを列挙</h4>ディレクトリ内のファイルを列挙するには、boost::filesystem::directory_iteratorを使用する。

```cpp
#include <iostream>
#include <boost/filesystem.hpp>
#include <boost/foreach.hpp>

namespace fs = boost::filesystem;

int main()
{
    const fs::path path("dir1");

    BOOST_FOREACH(const fs::path& p, std::make_pair(fs::directory_iterator(path),
                                                    fs::directory_iterator())) {
        if (!fs::is_directory(p))
            std::cout << p.filename() << std::endl;
    }
}
```

実行結果の例

```cpp
"a.txt"
"b.png"


<h4>ディレクトリ内の全てのファイルを再帰的に列挙</h4>ディレクトリ内の全てのファイルを再帰的に列挙するには、boost::filesystem::recursive_directory_iteratorを使用する。

```cpp
#include <iostream>
#include <boost/filesystem.hpp>
#include <boost/foreach.hpp>

namespace fs = boost::filesystem;

int main()
{
    const fs::path path("D:/boost_1_49_0/boost/filesystem");

    BOOST_FOREACH(const fs::path& p, std::make_pair(fs::recursive_directory_iterator(path),
                                                    fs::recursive_directory_iterator())) {
        if (!fs::is_directory(p))
            std::cout << p << std::endl;
    }
}
```

実行結果の例

```cpp
"D:/boost_1_49_0/boost/filesystem\config.hpp"
"D:/boost_1_49_0/boost/filesystem\convenience.hpp"
"D:/boost_1_49_0/boost/filesystem\detail\utf8_codecvt_facet.hpp"
"D:/boost_1_49_0/boost/filesystem\exception.hpp"
"D:/boost_1_49_0/boost/filesystem\fstream.hpp"
"D:/boost_1_49_0/boost/filesystem\operations.hpp"
"D:/boost_1_49_0/boost/filesystem\path.hpp"
"D:/boost_1_49_0/boost/filesystem\v2\config.hpp"
"D:/boost_1_49_0/boost/filesystem\v2\convenience.hpp"
"D:/boost_1_49_0/boost/filesystem\v2\exception.hpp"
"D:/boost_1_49_0/boost/filesystem\v2\fstream.hpp"
"D:/boost_1_49_0/boost/filesystem\v2\operations.hpp"
"D:/boost_1_49_0/boost/filesystem\v2\path.hpp"
"D:/boost_1_49_0/boost/filesystem\v3\config.hpp"
"D:/boost_1_49_0/boost/filesystem\v3\convenience.hpp"
"D:/boost_1_49_0/boost/filesystem\v3\exception.hpp"
"D:/boost_1_49_0/boost/filesystem\v3\fstream.hpp"
"D:/boost_1_49_0/boost/filesystem\v3\operations.hpp"
"D:/boost_1_49_0/boost/filesystem\v3\path.hpp"
"D:/boost_1_49_0/boost/filesystem\v3\path_traits.hpp"
```




