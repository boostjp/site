# 配列
[Boost.Array](http://www.boost.org/doc/libs/release/doc/html/array.html)

Boostでは、標準コンテナのインタフェースで使用できる固定長配列クラス、`boost::array`を提供する。

## インデックス

- [概要](#overview)
- [配列の要素数を取得する](#size)
- [添字による要素アクセス](#at)
- [イテレータを取得する](#iterator)


## <a name="overview" href="#overview">概要</a>
`boost::array`クラスは、組み込み配列にゼロオーバーヘッドな固定長配列クラスである。

このクラスは、組み込み配列とは異なり、`std::vector`や`std::list`のような標準コンテナのインタフェースを持つ。

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
```

実行結果：

```
3 1 4 
```


**テンプレート引数**

`boost::array`は、第1テンプレート引数に要素の型、第2テンプレート引数に要素数を取る。

この場合、「3要素の`int`型配列」を作成している。


**初期化**

`boost::array`は、組み込み配列と同様に、`{ 1, 2, 3 }`のような初期化子リストによる初期化が可能である。


**イテレータインタフェース**

`boost::array`は、`std::vector`や`std::list`と同じように、イテレータを返す`begin()`/`end()`のインタフェースを持つ。


## <a name="size" href="#size">配列の要素数を取得する</a>

配列の要素数を取得するには、`size()`メンバ関数を使用する。

```cpp
#include <iostream>
#include <boost/array.hpp>

int main()
{
    boost::array<int, 3> ar = {3, 1, 4};

    const std::size_t size = ar.size();
    std::cout << size << std::endl;
}
```


実行結果：

```
3
```


## <a name="at" href="#at">添字による要素アクセス</a>

`boost::array`は、組み込み配列や`std::vector`と同じように、`operator[]()`の添字演算子によって要素にランダムアクセスできる。

```cpp
#include <iostream>
#include <boost/array.hpp>

int main()
{
    boost::array<int, 3> ar = {3, 1, 4};

    for (std::size_t i = 0; i < ar.size(); ++i)
        std::cout << ar[i] << std::endl;
}
```


実行結果：

```
3
1
4
```

## <a name="iterator" href="#iterator">イテレータ</a>

`boost::array`は、`begin()`、`end()`メンバ関数によって、最初の要素を指すイテレータ、最後尾要素の次を指すイテレータを取得できる。


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
```

実行結果：

```
3
1
4
```


## <a name="iterator-type" href="#iterator-type">イテレータの型を取得する</a>

イテレータの型は、`boost::array<T, N>`クラスが持つ、以下のメンバ型で取得できる：

- `iterator` : 変更可能なイテレータ
- `const_iterator` : 読み取り専用イテレータ


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
```


実行結果：

```
1
4
```


