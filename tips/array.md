#配列
Boostでは、標準コンテナのインタフェースで使用できる固定長配列クラス、boost::arrayを提供する。

Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>概要](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>配列のサイズを取得する](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>添字による要素アクセス](#TOC--2)</li><li class='goog-toc'>[<strong>4 </strong>begin/endイテレータ](#TOC-begin-end-)</li><li class='goog-toc'>[<strong>5 </strong>イテレータの型を取得する](#TOC--3)</li></ol>


<h4>概要</h4>boost::arrayクラスは、組み込み配列にゼロオーバーヘッドな固定長配列クラスである。
このクラスは、組み込み配列とは異なり、std::vectorやstd::listのような標準コンテナのインタフェースを持つ。

```cpp
#include <iostream>
#include <boost/array.hpp>
#include <algorithm>

void disp(int x) { std::cout << x << ' '; }

int main()
{
    boost::array<int, 3> ar = {3, 1, 4};

    std::for_each(ar.begin(), ar.end(), disp);
}


実行結果：
```cpp
3 1 4 


<b>テンプレート引数</b>
boost::arrayは、第1テンプレート引数に要素の型、第2テンプレート引数に要素数を取る。
この場合、「3要素のint型配列」を作成している。

<b>初期化</b>
boost::arrayは、組み込み配列と同様に、{ 1, 2, 3 }のような初期化子リストによる初期化が可能である。

<b>イテレータインタフェース</b>
boost::arrayは、std::vectorやstd::listと同じように、イテレータを返すbegin()/end()のインタフェースを持つ。
```

<h4>配列のサイズを取得する</h4>配列のサイズを取得するには、size()メンバ関数を使用する。

```cpp
#include <iostream>
#include <boost/array.hpp>

int main()
{
    boost::array<int, 3> ar = {3, 1, 4};

    const std::size_t size = ar.size();
    std::cout << size << std::endl;
}


実行結果：
```cpp
3


<h4>添字による要素アクセス</h4>boost::arrayは、組み込み配列やstd::vectorと同じように、operator[]()の添字演算子によって要素にランダムアクセスすることができる。

```cpp
#include <iostream>
#include <boost/array.hpp>

int main()
{
    boost::array<int, 3> ar = {3, 1, 4};

    for (std::size_t i = 0; i < ar.size(); ++i)
        std::cout << ar[i] << std::endl;
}


実行結果：
```cpp
3
1
4
```

<h4>begin/endイテレータ</h4>boost::arrayは、begin(), end()メンバ関数によって、最初の要素を指すイテレータ、最後尾要素の次を指すイテレータを取得することができる。


```cpp
#include <iostream>
#include <boost/array.hpp>
#include <algorithm>

void disp(int x) { std::cout << x << ' '; }

int main()
{
    boost::array<int, 3> ar = {3, 1, 4};

    std::for_each(ar.begin(), ar.end(), disp);
}


実行結果：
```cpp
3
1
4


<h4>イテレータの型を取得する</h4>イテレータの型は、boost::array<T, N>::iterator、boost::array<T, N>::const_iteratorによって取得することができる。


```cpp
#include <iostream>
#include <boost/array.hpp>
#include <algorithm>

int main()
{
    typedef boost::array<int, 3> Array;
    Array ar = {3, 1, 4};

    {
        Array::iterator it = std::find(ar.begin(), ar.end(), 1);
        if (it != ar.end())
            std::cout << *it << std::endl;
    }
    {
        Array::const_iterator it = std::find(ar.begin(), ar.end(), 4);
        if (it != ar.end())
            std::cout << *it << std::endl;
    }
}


実行結果：
```cpp
1
4
```
