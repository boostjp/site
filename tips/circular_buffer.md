# 循環バッファ
[Boost.Circular Buffer](http://www.boost.org/doc/libs/release/doc/html/circular_buffer.html)

## インデックス

- [概要](#overview)
- [基本的な使い方](#basic-usage)
- [イテレータ/逆イテレータ](#iterator)
- [実メモリアドレスとC API対応](#law-layer-api)
- [バッファの使用状況を確認する](#monitor)
- [バッファの先頭/末尾/ランダムアクセスの確認する](#element-access)


## <a id="overview" href="#overview">概要</a>

`boost::circular_buffer`は循環バッファのライブラリである。

　※FIFO (First In First Out) アルゴリズムが実現可能

実際にメモリ空間のコピーが発生しているのではなく、`boost::circular_buffer` が開始ポインタの位置を循環させている。


## <a id="basic-usage" href="#basic-usage">基本的な使い方</a>
### バッファの先頭に追加していく場合

**メモリアドレスイメージ**

```
 [0] [1] [2] 
 ___ ___ ___ 
|___|___|___|

push_front( 'a' )
 ___ ___ ___ 
|_a_|___|___|

push_front( 'b' )
 ___ ___ ___ 
|_b_|_a_|___|

push_front( 'c' )
 ___ ___ ___ 
|_c_|_b_|_a_|

push_front( 'd' )
 ___ ___ ___ 
|_d_|_c_|_b_|  <--- 'a'が消える
```


```cpp example
#include <iostream>
#include <boost/circular_buffer.hpp>

// コンソール表示
void disp( char x ) { std::cout << x << ' '; }

int main()
{
    boost::circular_buffer<char> c_buf(3);

    c_buf.push_front( 'a' );
    std::cout << c_buf[0] << std::endl;                  // バッファ内の任意の位置を指定可能
    std::for_each( c_buf.begin(), c_buf.end(), disp );   // arry同様開始/終了の指定も可能
    std::cout << std::endl;

    c_buf.push_front( 'b' );
    std::cout << c_buf[0] << " " << c_buf[1] << std::endl;

    c_buf.push_front( 'c' );
    std::cout << c_buf[0] << " " << c_buf[1] << " " << c_buf[2] << std::endl;

    c_buf.push_front( 'd' );
    std::cout << c_buf[0] << " " << c_buf[1] << " " << c_buf[2] << std::endl;

    return 0;
}
```
* c_buf.push_front[color ff0000]


実行結果：

```
a
a
b a
c b a
d c b
```


### バッファの末尾に追加していく場合

**メモリアドレスイメージ**

```
 [0] [1] [2] 
 ___ ___ ___ 
|___|___|___|

push_back( 'x' )
 ___ ___ ___ 
|___|___|_x_|

push_back( 'y' )
 ___ ___ ___ 
|___|_x_|_y_|

push_back( 'z' )
 ___ ___ ___ 
|_x_|_y_|_z_|

push_back( '1' )
 ___ ___ ___ 
|_y_|_z_|_1_|  <--- 'x'が消える
```


```cpp example
#include <iostream>
#include <boost/circular_buffer.hpp>

// コンソール表示
void disp( char x ) { std::cout << x << ' '; }

int main()
{
    boost::circular_buffer<char> c_buf(3);
    c_buf.push_back( 'x' );
    c_buf.push_back( 'y' );
    c_buf.push_back( 'z' );

    std::for_each( c_buf.begin(), c_buf.end(), disp );
    std::cout << std::endl;


    c_buf.push_back( '1' );

    std::for_each( c_buf.begin(), c_buf.end(), disp );
    std::cout << std::endl;

    return 0;
}
```
* c_buf.push_back[color ff0000]


実行結果：

```
x y z 
y z 1 
```


### バッファの削除をする場合


`std::vector`と同じく、popも利用可能

```cpp example
#include <iostream>
#include <boost/circular_buffer.hpp>

// コンソール表示
void disp( char x ) { std::cout << x << ' '; }

int main()
{
    boost::circular_buffer<char> c_buf(3);

    // 末尾に追加していく
    c_buf.push_back( 'x' );
    c_buf.push_back( 'y' );
    c_buf.push_back( 'z' );

    std::for_each( c_buf.begin(), c_buf.end(), disp );
    std::cout << std::endl;

    c_buf.pop_back();	// 末尾バッファ 'z' が削除
    std::for_each( c_buf.begin(), c_buf.end(), disp );
    std::cout << std::endl;

    c_buf.pop_front();	// 先頭バッファ 'x' が削除
    std::for_each( c_buf.begin(), c_buf.end(), disp );
    std::cout << std::endl;

    return 0;
}
```

実行結果：

```
x y z 
x y 
y 
```


## <a id="iterator" href="#iterator">イテレータ/逆イテレータ</a>

標準コンテナと同様に、イテレータと逆イテレータも利用可能

```
 [0] [1] [2] 
 ___ ___ ___ 
|_c_|_b_|_a_|
```


| メンバ関数  | 効果 |
|-------------|------|
| `begin()`   | `[0]`位置を指すイテレータが返る、値は `'c'`   |
| `end()`     | `[2]`位置の次を指すイテレータが返る           |
| `rbegin()`  | `[2]`位置を指す逆イテレータが返る、値は `'a'` |
| `rend()`    | `[0]`位置の前を指す逆イテレータが返る         |


```cpp example
#include <iostream>
#include <boost/circular_buffer.hpp>
    
// コンソール表示
void disp( char x ) { std::cout << x << ' '; }

int main()
{
    boost::circular_buffer<char> c_buf( 3 );
    c_buf.push_front( 'a' );
    c_buf.push_front( 'b' );
    c_buf.push_front( 'c' );

    std::for_each( c_buf.begin(), c_buf.end(), disp );
    std::cout << std::endl;

    std::for_each( c_buf.rbegin(), c_buf.rend(), disp );
    std::cout << std::endl;

    return 0;
}
```
* c_buf.begin[color ff0000]
* c_buf.end[color ff0000]
* c_buf.rbegin[color ff0000]
* c_buf.rend[color ff0000]


実行結果：
```
c b a 
a b c 
```


## <a id="law-layer-api" href="#law-layer-api">実メモリアドレスとC API対応</a>

`boost::circular_buffer`クラスには、循環バッファの中身をサイズ指定で一括出力させたいときなどに利用するメンバ関数として、`array_one()`と`array_two()`が用意されている。

また、`printf()`や`fwrite()`のようなC APIとやりとりするためのメンバ関数として、`linearize()`が用意されている。


＊循環バッファのメモリアドレスイメージ

```
___ ___ ___ ___ ___
|_H_|_G_|_F_|_E_|___|
```


＊実メモリアドレス

```
 ___ ___ ___ ___ ___
|_E_|___|_H_|_F_|_G_|
  +       +------------> array_one().first :位置取得
  |                      array_one().second:その位置からの個数取得
  +--------------------> array_two().first :位置取得
                         array_two().second:先頭位置からの個数取得
```

```cpp example
#include <iostream>
#include <boost/circular_buffer.hpp>
#include <boost/lambda/lambda.hpp>

using namespace boost::lambda;

// メモリ表示
void mem_dump( char *p, int num )
{
    std::for_each( p, p+num, ( std::cout << _1 << ' ' ));
    std::cout << std::endl;
}

int main()
{
    boost::circular_buffer<char> c_buf( 5 );
    c_buf.push_front( 'A' );
    c_buf.push_front( 'B' );
    c_buf.push_front( 'C' );
    c_buf.push_front( 'D' );
    c_buf.push_front( 'E' );
    c_buf.push_front( 'F' );    // これ以降、先の'A'から消える
    c_buf.push_front( 'G' );
    c_buf.push_front( 'H' );

    // --------------------------------------------------------------------------
    // 循環バッファのメモリアドレスイメージ
    //  ___ ___ ___ ___ ___
    // |_H_|_G_|_F_|_E_|_G_|
    // --------------------------------------------------------------------------
    std::for_each( c_buf.begin(), c_buf.end(), ( std::cout << _1 << ' ' ));
    std::cout << std::endl;

    // ------------------------------
    // 実メモリアドレスを意識
    // ------------------------------
    int num1 = c_buf.array_one().second;    // begin()から終端までの個数 '3'
    int num2 = c_buf.array_two().second;    // 実メモリ先頭からend()までの個数 '2'
    std::cout << num1 << std::endl;
    std::cout << num2 << std::endl;

    // --------------------------------------------------------------------------
    // 実メモリアドレス
    //  ___ ___ ___ ___ ___
    // |_E_|_D_|_H_|_F_|_G_|
    //       |   +--------------- 'H'がbegin()位置、この位置を含めて3つ続く
    //       +------------------- 'D'がend()  位置、先頭'E'を含めて2つ続く
    // --------------------------------------------------------------------------
    char* p1 = c_buf.array_one().first;
    char* p2 = c_buf.array_two().first;
    mem_dump( p1, num1 );                // begin()から実メモリ末尾までの出力
    mem_dump( p2, num2 );                // 実メモリ先頭からend()までの出力

    c_buf.pop_back();                    // 末尾を消してみる

    std::cout << std::endl;


    // --------------------------------------------------------------------------
    // 循環バッファのメモリアドレスイメージ
    //  ___ ___ ___ ___ ___
    // |_H_|_G_|_F_|_E_|___|
    // --------------------------------------------------------------------------
    std::for_each( c_buf.begin(), c_buf.end(), ( std::cout << _1 << ' ' ));
    std::cout << std::endl;

    num1 = c_buf.array_one().second;     // 再取得してみる
    num2 = c_buf.array_two().second;
    std::cout << num1  << std::endl;
    std::cout << num2  << std::endl;

    // --------------------------------------------------------------------------
    // 実メモリアドレス
    //  ___ ___ ___ ___ ___
    // |_E_|___|_H_|_F_|_G_|
    //   |       +--------------- 'H'がbegin()位置、この位置を含めて3つ続く
    //   +----------------------- 'E'がend()  位置、先頭'E'を含めて1つ続く
    // --------------------------------------------------------------------------
    p1 = c_buf.array_one().first;        // 再取得してみる
    p2 = c_buf.array_two().first;
    mem_dump( p1, num1 );
    mem_dump( p2, num2 );

    // linearize()を使えば、レガシーCの様な記載も可能
    mem_dump( c_buf.linearize(), 4 );

    return 0;
}
```
* c_buf.array_one().first[color ff0000]
* c_buf.array_two().first[color ff0000]
* c_buf.array_one().second[color ff0000]
* c_buf.array_two().second[color ff0000]
* c_buf.pop_back();[color ff0000]
* c_buf.linearize()[color ff0000]


実行結果：

```
H G F E D
3
2
H G F
E D

H G F E
3
1
H G F
E
H G F E
```

## <a id="monitor" href="#monitor">バッファの使用状況を確認する</a>

```cpp example
#include <iostream>
#include <boost/circular_buffer.hpp>

// コンソール表示
void disp( char x ) { std::cout << x << ' '; }

int main()
{
    // サイズ関連
    boost::circular_buffer<char> c_buf( 3 );

    c_buf.set_capacity( 7 );                            // バッファの許容サイズを7に拡張

    std::cout << c_buf.size() << std::endl;             // 今は空なのでサイズ0
    std::cout << c_buf.capacity() << std::endl;         // バッファの許容サイズ7
    if( c_buf.empty() ){                                // empty()==trueでバッファが空
        std::cout << "buffer empty." << std::endl;
    }

    c_buf.push_front( 'a' );
    std::cout << c_buf.size() << std::endl;             // 1つ入れたのでサイズ1

    c_buf.set_capacity( 5 );                            // 許容サイズを5に小さくする

    // あと、どれくらい入れれるの？
    std::cout << c_buf.reserve()  << std::endl;         // capacity()-size() の意味

    c_buf.push_front( 'b' );
    c_buf.push_front( 'c' );
    c_buf.push_front( 'd' );
    c_buf.push_front( 'e' );

    if( c_buf.full() ){                               // full()==trueでバッファが全て埋まっている
        std::cout << "buffer full." << std::endl;
    }
                                                        //  ___ ___ ___ ___ ___
    std::for_each( c_buf.begin(), c_buf.end(), disp );  // |_e_|_d_|_c_|_b_|_a_|
    std::cout << std::endl;
    std::cout << c_buf.size() << std::endl;             // サイズは5


    c_buf.set_capacity( 3 );                            // バッファの値が埋まっていても容量を3にできる
                                                        //  ___ ___ ___ 
    std::for_each( c_buf.begin(), c_buf.end(), disp );  // |_e_|_d_|_c_|
    std::cout << std::endl;
    std::cout << c_buf.size() << std::endl;             // サイズは3

    return 0;
}
```
* c_buf.set_capacity[color ff0000]
* c_buf.size()[color ff0000]
* c_buf.capacity()[color ff0000]
* c_buf.empty()[color ff0000]
* c_buf.reserve()[color ff0000]
* c_buf.full()[color ff0000]

実行結果：

```
0
7
buffer empty.
1
4
buffer full.
e d c b a
5
e d c
3
```


## <a id="element-access" href="#element-access">バッファの先頭/末尾/任意の位置にアクセスする</a>

```cpp example
#include <iostream>
#include <boost/circular_buffer.hpp>
    
// コンソール表示
void disp( char x ) { std::cout << x << ' '; }

int main()
{
    // サイズ設定
    boost::circular_buffer<char> c_buf( 5 );

    // イテレータ、begin/end
    c_buf.push_front( 'A' );
    c_buf.push_front( 'B' );
    c_buf.push_front( 'C' );

    //  ___ ___ ___ ___ ___
	// |_C_|_B_|_A_|___|___|
    std::for_each( c_buf.begin(), c_buf.end(), disp );
    std::cout << std::endl;

    boost::circular_buffer<char>::iterator it = c_buf.begin();

    // 先頭の要素を取得
    std::cout << c_buf.front()  << std::endl;       // 'C'
    std::cout << *it            << std::endl;       // front()と同じ意味 'C'

	 // 末尾の要素を取得
    std::cout << c_buf.back()   << std::endl;       // 'A'
    std::cout << *( c_buf.end() - 1 ) << std::endl; // back()と同じ意味 'A'
//  std::cout << *c_buf.end()   << std::endl;       // これはできない
    std::cout << std::endl;

    c_buf.push_front( 'D' );
    c_buf.push_front( 'E' );
    c_buf.push_front( 'F' );

    //  ___ ___ ___ ___ ___
    // |_F_|_E_|_D_|_C_|_B_|
    std::for_each( c_buf.begin(), c_buf.end(), disp );
    std::cout << std::endl;

    std::cout << *it << std::endl; // かつての先頭だった'C' 
    std::cout << std::endl;

    c_buf.push_front( 'G' );
    c_buf.push_front( 'H' );

    //  ___ ___ ___ ___ ___
    // |_H_|_G_|_F_|_E_|_D_|
    std::for_each( c_buf.begin(), c_buf.end(), disp ); 
    std::cout << std::endl;

//  std::cout << *it << std::endl; // 'C' は消えたので、イテレータが無効になった

    // ランダムアクセス
    std::cout << c_buf[0]     << std::endl; // 'H'
    std::cout << c_buf.at(0)  << std::endl; // 範囲チェック付きランダムアクセス 'H' 
    std::cout << std::endl;

    return 0;
}
```
* boost::circular_buffer<char>::iterator it[color ff0000]
* c_buf[0][color ff0000]
* c_buf.at[color ff0000]


実行結果：

```
C B A 
C
C
A
A

F E D C B 
C

H G F E D 
H
H
```


