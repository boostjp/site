#多次元配列

多次元配列には、[Boost Multi-Array Library](http://www.boost.org/doc/libs/release/libs/multi_array/doc/index.html)を使用する。


##インデックス

- [基本的な使い方](#basic-usage)
- [部分配列の走査](#iterate-partial-array)


## <a name="basic-usage" href="#basic-usage">基本的な使い方</a>
`boost::multi_array`クラスはCスタイル多次元配列特有の分かりにくさを解消し、様々な走査を提供する。

ただし、`boost::array`とは違いオーバーヘッドが存在するため注意が必要である。

```cpp
#include <iostream>
#include <boost/multi_array.hpp>

int main()
{
    // Cスタイル (3x4x5 ? それとも 5x4x3 ?)
    int C_style[3][4][5];
    C_style[0][0][0] = 0; // ok
    C_style[4][3][2] = 0; // これは正しい？ (非常に分かりにくいが、境界の外に書き込もうとしている
    C_style[2][3][4] = 0; // こちらは正しい

    typedef boost::multi_array<int, 3> three_dim_array;

    // Boost.MultiArray (3x4x5)
    three_dim_array Boost_style(boost::extents[3][4][5]);
    Boost_style[0][0][0] = 0; // ok
    Boost_style[4][3][2] = 0; // 境界の外に書き込もうとしたので例外が投げられる
    Boost_style[2][3][4] = 0; // ok

    // Boost.MultiArray (3x4x5)
    boost::array<int, 3> shape = {{ 3,4,5 }};
    three_dim_array Another_style(shape); // 3,4,5で初期化されるわけではないことに注意されたい
}
```
* boost::multi_array<int, 3>[color ff0000]
* boost::extents[3][4][5][color ff0000]

**テンプレート引数**

`boost::multi_array`は第1テンプレート引数に要素の型、第2テンプレート引数に次元数を、第3テンプレート引数にアロケータをとる。通常、アロケータはデフォルトテンプレート引数をそのまま用いればよい。


**初期化**

`boost::multi_array`は`boost::extents`などによって各次元の次元長を設定するか、部分配列、ビューを用いて初期化することが可能である。


## <a name="iterate-partial-array" href="#iterate-partial-array">部分配列の走査</a>

`boost::multi_array`はCスタイルの配列では難しい部分配列への走査を提供している。

```cpp
#include <iostream>
#include <boost/multi_array.hpp>

int main()
{
    typedef boost::multi_array<int, 2> matrix_t;
    matrix_t matrix(boost::extents[5][5]);
    for (int i=0; i<5; ++i)
        for (int j=0; j<5; ++j)
            matrix[i][j] = i*j;

    typedef matrix_t::index_range         range;
    typedef matrix_t::array_view<1>::type view_t;
    view_t view = matrix[ boost::indices[range(1,4)][3] ];
    for (int i=0; i<3; ++i)
        std::cout << "matrix[" << (i + 1) << "][3] = " << view[i] << std::endl;
}
```
* index_range[color ff0000]
* array_view<1>::type[color ff0000]
* boost::indices[range(1,4)][3][color ff0000]

実行結果：
```
matrix[1][3] = 3
matrix[2][3] = 6
matrix[3][3] = 9
```

