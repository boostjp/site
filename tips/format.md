#文字列フォーマット
C言語では、sprintfを使用してchar配列としての文字列をフォーマット設定することができたが、C++において、std::stringに対する文字列フォーマット機能は標準ライブラリとしては提供されていない。
Boost Format Libraryは、std::stringの文字列フォーマット、およびストリームへのフォーマット出力の機能を提供するライブラリである。


Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>基本的な使い方](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>printfライクな書式設定](#TOC-printf-)</li><li class='goog-toc'>[<strong>3 </strong>フォーマット設定されたstd::stringを作成する](#TOC-std::string-)</li></ol>


<h4>基本的な使い方</h4>Boost.Formatの基本的な使い方は、boost::format()に書式文字列を設定し、operator%()を使用して各プレースホルダーの置き換えとなる値を可変引数として設定するものである。
以下は、フォーマット指定した文字列を標準出力に出力している。

```cpp
#include <iostream>
#include <boost/format.hpp>

int main()
{
    std::cout <<
        boost::format("%2% %1%") % 3 % std::string("Hello")
    << std::endl;
}


実行結果：
```cpp
Hello 3

printfのフォーマットと違うところは、%dや%sといった型指定が必要ないということだ。
Boost.Formatでは、型指定の代わりに、%1%のようにして引数の番号を指定する。これによって、同じ引数を何度も使用することができ、順番も好きに入れ替えることができるのである。
この場合、%1%が3に置き換えられ、%2%が"Hello"に置き換えられて標準出力に出力される。
<h4>printfライクな書式設定</h4>Boost.Formatでは、printfライクな書式設定もサポートしている。

```cpp
#include <iostream>
#include <boost/format.hpp>

int main()
{
    std::cout <<
        boost::format("%d %s") % 3 % std::string("Hello")
    << std::endl;
}


実行結果：

```cpp
3 Hello



boost::formatにはprintfライクな%d, %sなどの書式設定が可能である。%dは整数型に対応し、%sは文字列型に対応している。
この場合、%dが3に置き換えられ、%sが"Hello"に置き換えられて標準出力に出力される。

<h4>フォーマット設定されたstd::stringを作成する</h4>Boost.Formatで書式設定されたstd::stringを作成するには、boost::formatのstr()メンバ関数を使用する。

```cpp
#include <iostream>
#include <string>
#include <boost/format.hpp>

int main()
{
    const std::string s = (boost::format("%2% %1%") % 3 % std::string("Hello")).str();

    std::cout << s << std::endl;
}


実行結果：

```cpp
Hello 3


```
