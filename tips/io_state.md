#ストリームの状態を戻す
Boost IO State Saver Libraryを使用すると、std::coutのストリーム状態を以前の状態に戻すことができる。

Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>フォーマットフラグを戻す](#TOC--)</li></ol>



<h4>フォーマットフラグを戻す</h4>boost::ios_flags_saverにistreamもしくはostreamの参照を渡すことで、そのスコープを抜ける際にフォーマットフラグを以前の状態に戻してくれる。

```cpp
#include <iostream>
#include <iomanip>
#include <boost/io/ios_state.hpp>

void disp_hex(std::ostream& os, int value)
{
    // スコープを抜けたらフォーマットフラグを戻す
    boost::io::ios_flags_saver ifs(os);

    os << std::hex << value << std::endl;
}

int main()
{
    disp_hex(std::cout, 10);      // 16進数で出力
    std::cout << 10 << std::endl; // 10進数で出力
}


実行結果：

```cpp
a
10


```
