#実行時アサート
実行時アサートには、`BOOST_ASSERT`マクロ、もしくは`BOOST_ASSERT_MSG`マクロを使用する。これらのマクロは、[`<boost/assert.hpp>`](http://www.boost.org/doc/libs/release/libs/utility/assert.html)ヘッダで定義される。


##インデックス
- [式を検証する](#assertion-expression)
- [メッセージ付きで式を検証する](#assertion-with-message)
- [検証失敗時の動作をカスタマイズする](#customize-fail-behavior)


## <a name="assertion-expression" href="assertion-expression">式を検証する</a>

式を検証するには、`BOOST_ASSERT`マクロを使用する。このマクロは引数として条件式をとる。条件式が`true`に評価される場合は検証成功となり、`false`の場合は検証失敗と見なされる。

検証失敗時は、プログラムが異常終了する。

デフォルトでは、`NDEBUG`が`#define`されていない場合(デバッグモード)のみ検証が行われる。

```cpp
#include <boost/assert.hpp>

int main()
{
    // 検証に成功するケース
    BOOST_ASSERT(1 == 1);

    // 検証に失敗するケース
    BOOST_ASSERT(1 != 1);
}
```
* BOOST_ASSERT[color ff0000]


出力例：

```
This application has requested the Runtime to terminate it in an unusual way.
Please contact the application's support team for more information.
Assertion failed!

Program: main.exe
File: main.cpp, Line 9

Expression: 1 != 1

```

## <a name="assertion-with-message" href="assertion-with-message">メッセージ付きで式を検証する</a>

検証失敗時にコンパイルエラーにエラーメッセージを出力するには、`BOOST_ASSERT_MSG`マクロを使用する。基本的な使い方は`BOOST_ASSERT`と同様で、第2引数にメッセージの文字列を取る。

```cpp
#include <boost/assert.hpp>

int main(int argc, char* argv[])
{
    BOOST_ASSERT_MSG(argc > 1, "you must specify at least one option");
}
```
* BOOST_ASSERT_MSG[color ff0000]

また、式を評価する必要が無く、該当箇所を通過した場合に単にデバッグ用途で無条件に落としたい場合、文字列を示すポインタの評価結果は常に真になることを利用して、イディオム的に以下のような書き方もできる。

```cpp
#include <iostream>
#include <boost/assert.hpp>

int main(int argc, char* argv[])
{
    if (argc == 1 + 1) {
        std::cout << "option 1: " << argv[1] << std::endl;
    } else {
        BOOST_ASSERT(!"unknown extra option specified");
    }
}
```
* BOOST_ASSERT[color ff0000]

これは`NDEBUG`が`#define`されているビルド（リリースビルド）では暗黙のうちに通過してしまいバグの原因となるので、あくまで簡易的なデバッグ用途に留めるべきである。


## <a name="customize-fail-behavior" href="customize-fail-behavior">検証失敗時の動作をカスタマイズする</a>

`BOOST_ASSERT`での検証失敗時の動作をカスタマイズしたい場合は、以下の方法をとる：

- `<boost/assert.hpp>`ヘッダをインクルードする前に、`BOOST_ENABLE_ASSERT_HANDLER`を`#define`する
- `boost`名前空間に`assertion_failed()`関数を定義する

この方法をとることによって、検証失敗時に、自分で定義した`assertion_failed()`関数が呼ばれるようになる。この関数には、以下のパラメータが渡される：

- 文字列化された式
- 関数名(形式は環境依存)
- ファイル名(`__FILE__`)
- 行番号(`__LINE__`)

```cpp
#define BOOST_ENABLE_ASSERT_HANDLER
#include <boost/assert.hpp>
#include <fstream>
#include <cstdlib>

namespace boost {
    void assertion_failed(const char* expr, const char* function, const char* file, long line)
    {
        // ログに出力して、アプリケーションを異常終了させる
        std::ofstream log("log.txt", std::ios::out | std::ios::app);
        log << "Expression : " << expr << '\n'
            << "Function : " << function << '\n'
            << "File : " << file << '\n'
            << "Line : " << line << std::endl;
        std::abort();
    }
}

int main()
{
    BOOST_ASSERT(1 == 2);
}
```
* BOOST_ENABLE_ASSERT_HANDLER[color ff0000]
* assertion_failed[color ff0000]


出力例：

```
This application has requested the Runtime to terminate it in an unusual way.
Please contact the application's support team for more information.

```

log.txt：

```
Expression : 1 == 2
Function : int main()
File : C:\language\cpp\main.cpp
Line : 21
```

`BOOST_ASSERT_MSG`の場合は、以下のようにする：

- `<boost/assert.hpp>`ヘッダをインクルードする前に、`BOOST_ENABLE_ASSERT_HANDLER`を`#define`する
- `boost`名前空間に`assertion_failed_msg()`関数を定義する

これによって、`BOOST_ASSERT_MSG`での検証失敗時に、自分で定義した`assertion_failed_msg()`関数が呼ばれるようになる。この関数には、以下のパラメータが渡される：

- 文字列化された式
- メッセージ
- 関数名(形式は環境依存)
- ファイル名(`__FILE__`)
- 行番号(`__LINE__`)</ol>

```cpp
#define BOOST_ENABLE_ASSERT_HANDLER
#include <boost/assert.hpp>
#include <fstream>
#include <cstdlib>

namespace boost {
    void assertion_failed_msg(const char* expr, const char* msg, const char* function,
                              const char* file, long line)
    {
        // ログに出力して、アプリケーションを異常終了させる
        std::ofstream log("log.txt", std::ios::out | std::ios::app);
        log << "Expression : " << expr << '\n'
            << "Message : " << msg << '\n'
            << "Function : " << function << '\n'
            << "File : " << file << '\n'
            << "Line : " << line << std::endl;
        std::abort();
    }
}

int main()
{
    BOOST_ASSERT_MSG(1 == 2, "1 is not 2");
}
```
* BOOST_ENABLE_ASSERT_HANDLER[color ff0000]
* assertion_failed_msg[color ff0000]

出力例：

```
This application has requested the Runtime to terminate it in an unusual way.
Please contact the application's support team for more information.

```

log.txt：

```
Expression : 1 == 2
Message : 1 is not 2
Function : int main()
File : C:\language\cpp\main.cpp
Line : 22
```

documented boost version is 1.52.0

