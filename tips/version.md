#Boostのバージョンを調べる

Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>基本的な使い方](#TOC--)</li></ol>


<h4>基本的な使い方</h4>```cpp
<code style='color:rgb(0,0,0)'>#include <boost/version.hpp></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>#include <iostream></code><br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>int main() {</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    std::cout << BOOST_VERSION << "\n" // 104601</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>              << BOOST_LIB_VERSION "\n"; // 1_46_1</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>}</code>
Boostのバージョンが x.yy.zz であれば、BOOST_VERSION マクロは x0yyzz という整数に展開される。また BOOST_LIB_VERSION マクロは文字列 "x_yy_zz" となるが、zz が 00 の場合、_zz の部分は省略される。