#循環バッファ

Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>概要](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>基本的な使い方](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>イテレータ/逆イテレータ](#TOC--2)</li><li class='goog-toc'>[<strong>4 </strong>実メモリアドレスとレガシーC対応](#TOC-C-)</li><li class='goog-toc'>[<strong>5 </strong>バッファの使用状況を確認する](#TOC--3)</li><li class='goog-toc'>[<strong>6 </strong>バッファの先頭/末尾/ランダムアクセスの確認する](#TOC--4)</li></ol>


<h4><b>概要</b></h4>
boost::circular_bufferは循環バッファのライブラリである

　※FIFO (First In First Out) アルゴリズムが実現可能

実際にメモリ空間のコピーが発生しているのではなく、boost::circular_buffer が開始ポインタの位置を循環させている


<h4><b>基本的な使い方</b></h4>
-------------------------------------------------

<b>バッファの先頭に追加していく場合</b>

-------------------------------------------------

メモリアドレスイメージ
<span style='line-height:13px'>`<span style='font-family:Arial,sans-serif'><code style='color:rgb(0,96,0)'> ``[0] [1] [2]`<code style='color:rgb(0,96,0)'> </code>
</span><span style='font-family:Arial,sans-serif'><code style='color:rgb(0,96,0)'> </code>`___ ___ ___ `
</span>|___|___|___|</code>
<code style='color:rgb(0,96,0)'></code>
<code style='color:rgb(0,96,0)'>push_front( 'a' )</code>
</span>

<span style='line-height:13px'><code style='color:rgb(0,96,0)'><span style='color:rgb(0,96,0)'><span style='font-family:Arial,sans-serif;color:rgb(0,0,0)'><code style='color:rgb(0,96,0)'> ___ ___ ___ </code>
</span></span>|_a_|___|___|</code>
<code style='color:rgb(0,96,0)'></code>
<code style='color:rgb(0,96,0)'>push_front( 'b' )</code>
</span>

<span style='line-height:13px'><code style='color:rgb(0,96,0)'><span style='color:rgb(0,96,0)'><span style='font-family:Arial,sans-serif;color:rgb(0,0,0)'><code style='color:rgb(0,96,0)'> ___ ___ ___ </code>
</span></span>|_b_|_a_|___|</code>
<code style='color:rgb(0,96,0)'></code>
<code style='color:rgb(0,96,0)'>push_front( 'c' )</code>
</span><span style='line-height:13px'><code style='color:rgb(0,96,0)'><span style='color:rgb(0,96,0)'><span style='font-family:Arial,sans-serif;color:rgb(0,0,0)'><code style='color:rgb(0,96,0)'> ___ ___ ___ </code>
</span></span>|_c_|_b_|_a_|</code>
<code style='color:rgb(0,96,0)'></code>
<code style='color:rgb(0,96,0)'>push_front( 'd' )</code>
</span><span style='line-height:13px'><code style='color:rgb(0,96,0)'><span style='color:rgb(0,96,0)'><span style='font-family:Arial,sans-serif;color:rgb(0,0,0)'><code style='color:rgb(0,96,0)'> ___ ___ ___ </code>
</span></span>|_d_|_c_|_b_|  <--- 'a'が消える</code>
<code style='color:rgb(0,96,0)'></code>
</span>

```cpp
#include <iostream>

#include <boost/circular_buffer.hpp>
```

`// コンソール表示`

`void disp( char x ) { std::cout << x << ' '; }`


`int main()`

`{`

`    boost::circular_buffer<char> c_buf(3);`


`    c_buf.push_front( 'a' );`

`    std::cout << c_buf[0] << std::endl;                  // バッファ内の任意の位置を指定可能`

`    std::for_each( c_buf.begin(), c_buf.end(), disp );   // arry同様開始/終了の指定も可能`

`    std::cout << std::endl;`


`    c_buf.push_front( 'b' );`

`    std::cout << c_buf[0] << " " << c_buf[1] << std::endl;`


`    c_buf.push_front( 'c' );`

`    std::cout << c_buf[0] << " " << c_buf[1] << " " << c_buf[2] << std::endl;`


`    c_buf.push_front( 'd' );`

`    std::cout << c_buf[0] << " " << c_buf[1] << " " << c_buf[2] << std::endl;`


`    return 0;`

`}`


実行結果：

```cpp
a

a

b a

c b a

d c b
```

-------------------------------------------------

<b>バッファの末尾に追加していく場合</b>

-------------------------------------------------



メモリアドレスイメージ
<span style='line-height:13px'><code style='color:rgb(0,96,0)'><span style='font-family:Arial,sans-serif'><code style='color:rgb(0,96,0)'> </code><code style='color:rgb(0,96,0)'>[0] [1] [2]</code><code style='color:rgb(0,96,0)'> </code>
</span><span style='font-family:Arial,sans-serif'><code style='color:rgb(0,96,0)'> </code><code style='color:rgb(0,96,0)'>___ ___ ___ </code>
</span>|___|___|___|</code>
<code style='color:rgb(0,96,0)'></code>
<code style='color:rgb(0,96,0)'>push_back( 'x' )</code>
</span>
<span style='line-height:13px'><code style='color:rgb(0,96,0)'><span style='color:rgb(0,96,0)'><span style='font-family:Arial,sans-serif;color:rgb(0,0,0)'><code style='color:rgb(0,96,0)'> ___ ___ ___ </code>
</span></span>|___|___|_x_|</code>
<code style='color:rgb(0,96,0)'></code>
<code style='color:rgb(0,96,0)'>push_back( 'y' )</code>
</span>
<span style='line-height:13px'><code style='color:rgb(0,96,0)'><span style='color:rgb(0,96,0)'><span style='font-family:Arial,sans-serif;color:rgb(0,0,0)'><code style='color:rgb(0,96,0)'> ___ ___ ___ </code>
</span></span>|___|_x_|_y_|</code>
<code style='color:rgb(0,96,0)'></code>
<code style='color:rgb(0,96,0)'>push_back( 'z' )</code>
</span><span style='line-height:13px'><code style='color:rgb(0,96,0)'><span style='color:rgb(0,96,0)'><span style='font-family:Arial,sans-serif;color:rgb(0,0,0)'><code style='color:rgb(0,96,0)'> ___ ___ ___ </code>
</span></span>|_x_|_y_|_z_|</code>
<code style='color:rgb(0,96,0)'></code>
<code style='color:rgb(0,96,0)'>push_back( '1' )</code>
</span><span style='line-height:13px'><code style='color:rgb(0,96,0)'><span style='color:rgb(0,96,0)'><span style='font-family:Arial,sans-serif;color:rgb(0,0,0)'><code style='color:rgb(0,96,0)'> ___ ___ ___ </code>
</span></span>|_y_|_z_|_1_|  <--- 'x'が消える</code>
<code style='color:rgb(0,96,0)'></code>
</span>


```cpp
#include <iostream>

#include <boost/circular_buffer.hpp>
```

`// コンソール表示`

`void disp( char x ) { std::cout << x << ' '; }`


`int main()`

<code style='color:rgb(0,96,0)'>{</code>
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


実行結果：```cpp
<code style='color:rgb(0,0,0)'>x y z<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>y z 1
```

-------------------------------------------------<b>バッファの削除をする場合</b>
-------------------------------------------------


std::vectorなどと同じく、popも利用可能

```cpp
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
```

    return 0;
}
</code>

<span style='font-family:Arial,sans-serif;line-height:19px'>
実行結果：</span>
```cpp
x y z
x y
y
```

<h4 style='font-family:Trebuchet MS,arial,sans-serif;font-size:1.2em;background-color:rgb(238,238,238);border-top-style:dotted;border-right-style:dotted;border-bottom-style:dotted;border-left-style:dotted;border-top-width:1px;border-right-width:1px;border-bottom-width:1px;border-left-width:1px;border-top-color:rgb(199,199,199);border-right-color:rgb(199,199,199);border-bottom-color:rgb(199,199,199);border-left-color:rgb(199,199,199);color:rgb(26,66,146);padding-top:3px;padding-right:5px;padding-bottom:3px;padding-left:5px;font-weight:normal;line-height:19px'><b>イテレータ/逆イテレータ</b></h4>std::vectorなどと同じく、逆イテレータも利用可能

<span style='line-height:13px'><code style='color:rgb(0,96,0)'><span style='font-family:Arial,sans-serif'><code style='color:rgb(0,96,0)'> </code><code style='color:rgb(0,96,0)'>[0] [1] [2]</code><code style='color:rgb(0,96,0)'> </code>
</span><span style='font-family:Arial,sans-serif'><code style='color:rgb(0,96,0)'> </code><code style='color:rgb(0,96,0)'>___ ___ ___ </code>
</span>|_c_|_b_|_a_|</code>
</span>
begin()   [0]位置が返る、値は 'c' 
end()     [2]の終わり、つまり[3]相当の位置が返る
rbegin()  [2]位置が返る、値は 'a'
rend()    [0]位置の前、つまり[-1]相当の位置が返る

```cpp
#include <iostream>
#include <boost/circular_buffer.hpp>
    
// コンソール表示
void disp( char x ) { std::cout << x << ' '; }

int main()
{
<span style='white-space:pre'><span style='font-family:monospace;white-space:normal'>    boost::circular_buffer<char> c_buf( 3 );
</span></span>
    c_buf.push_front( 'a' );
<span style='font-family:Arial,sans-serif'><code style='color:rgb(0,96,0)'>    c_buf.push_front( 'b' );
</span>    c_buf.push_front( 'c' );

	std::for_each( c_buf.begin(), c_buf.end(), disp );
	std::cout << std::endl;

	std::for_each( c_buf.rbegin(), c_buf.rend(), disp );
	std::cout << std::endl;

```

`    return 0;`

}



実行結果：
c b a
<code style='color:rgb(0,96,0)'>a b c</code>




<h4 style='font-family:Trebuchet MS,arial,sans-serif;font-size:1.2em;background-color:rgb(238,238,238);border-top-style:dotted;border-right-style:dotted;border-bottom-style:dotted;border-left-style:dotted;border-top-width:1px;border-right-width:1px;border-bottom-width:1px;border-left-width:1px;border-top-color:rgb(199,199,199);border-right-color:rgb(199,199,199);border-bottom-color:rgb(199,199,199);border-left-color:rgb(199,199,199);color:rgb(26,66,146);padding-top:3px;padding-right:5px;padding-bottom:3px;padding-left:5px;line-height:19px'><b>実メモリアドレスとレガシーC対応</b></h4>
循環バッファの中身をサイズ指定で一括出力させたいときなどに利用する
レガシーCでのprintf()やfwrite()などで利用用途あり

＊循環バッファのメモリアドレスイメージ
<span style='line-height:13px'>`<span style='font-family:Arial,sans-serif;color:rgb(0,0,0)'><code style='color:rgb(0,96,0)'> ___ ___ ___ ___ ___`
</span>|_H_|_G_|_F_|_E_|___|</code>

</span>
＊実メモリアドレス
`<span style='font-family:Arial,sans-serif'><code> ___ ___ ___ ___ ___`
</span>|_E_|___|_H_|_F_|_G_|</code>
`  +       +------------> array_one().first :位置取得`
`  |                      array_one().second:その位置からの個数取得`
`  +--------------------> `array_two().first :位置取得
                         array_two().second:先頭位置からの個数取得


```cpp
#include <iostream>
#include <boost/circular_buffer.hpp>
#include <boost/lambda/lambda.hpp>

using namespace boost::lambda;
```

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




実行結果：
H G F E D
<code>3
2
H G F
E D

H G F E
3
1
H G F
E
H G F E
</code>


<h4 style='font-weight:normal;font-family:Trebuchet MS,arial,sans-serif;font-size:1.2em;background-color:rgb(238,238,238);border-top-style:dotted;border-right-style:dotted;border-bottom-style:dotted;border-left-style:dotted;border-top-width:1px;border-right-width:1px;border-bottom-width:1px;border-left-width:1px;border-top-color:rgb(199,199,199);border-right-color:rgb(199,199,199);border-bottom-color:rgb(199,199,199);border-left-color:rgb(199,199,199);color:rgb(26,66,146);padding-top:3px;padding-right:5px;padding-bottom:3px;padding-left:5px;line-height:19px'><b>バッファの使用状況を確認する</b></h4><code style='color:rgb(0,96,0)'>#include <iostream></code>
<code style='color:rgb(0,96,0)'>#include <boost/circular_buffer.hpp></code>
<code style='color:rgb(0,96,0)'></code>
<code>// コンソール表示
void disp( char x ) { std::cout << x << ' '; }

int _tmain(int argc, _TCHAR* argv[])
{
    // サイズ関連
    boost::circular_buffer<char> c_buf( 3 );

    <color=ff0000>c_buf.set_capacity</color>( 7 );                            // バッファの許容サイズを'7'に拡張

    std::cout << <color=ff0000>c_buf.size()</color> << std::endl;             // 今は空なのでサイズ'0'
    std::cout << <color=ff0000>c_buf.capacity()</color> << std::endl;         // バッファの許容範囲 '7'
    if( <color=ff0000>c_buf.empty()</color> ){                                // empty()=TRUEでバッファが空
        std::cout << "buffer empty." << std::endl;
    }

    c_buf.push_front( 'a' );
    std::cout << c_buf.size() << std::endl;             // 1つ入れたのでサイズ'1'

    <color=ff0000>c_buf.set_capacity</color>( 5 );                            // 許容サイズを'5'に小さくする

    // あと、どれくらい入れれるの？
    std::cout << <color=ff0000>c_buf.reserve()</color>  << std::endl;         // capacity()-size() の意味

    c_buf.push_front( 'b' );
    c_buf.push_front( 'c' );
    c_buf.push_front( 'd' );
    c_buf.push_front( 'e' );

    if( <color=ff0000>c_buf.full()</color> ){                               // full()=TRUEでバッファが全て埋まっている
        std::cout << "buffer full." << std::endl;
    }
                                                        //  ___ ___ ___ ___ ___
    std::for_each( c_buf.begin(), c_buf.end(), disp );  // |_e_|_d_|_c_|_b_|_a_|
    std::cout << std::endl;
    std::cout << c_buf.size() << std::endl;             // サイズは'5'

    c_buf.set_capacity( 3 );                            // バッファの値が埋まっていても'3'に出来る
                                                        //  ___ ___ ___ 
    std::for_each( c_buf.begin(), c_buf.end(), disp );  // |_e_|_d_|_c_|
    std::cout << std::endl;
    std::cout << c_buf.size() << std::endl;             // サイズは'3'

    return 0;
}

</code>



実行結果：
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



<h4 style='font-family:Trebuchet MS,arial,sans-serif;font-size:1.2em;background-color:rgb(238,238,238);border-top-style:dotted;border-right-style:dotted;border-bottom-style:dotted;border-left-style:dotted;border-top-width:1px;border-right-width:1px;border-bottom-width:1px;border-left-width:1px;border-top-color:rgb(199,199,199);border-right-color:rgb(199,199,199);border-bottom-color:rgb(199,199,199);border-left-color:rgb(199,199,199);color:rgb(26,66,146);padding-top:3px;padding-right:5px;padding-bottom:3px;padding-left:5px;line-height:19px'><b>バッファの先頭/末尾/ランダムアクセスの確認する</b></h4>```cpp
<code style='color:rgb(0,96,0)'>#include <iostream>
<code style='color:rgb(0,96,0)'>#include <boost/circular_buffer.hpp>
<code style='color:rgb(0,96,0)'>    
<code style='color:rgb(0,96,0)'>// コンソール表示
<code style='color:rgb(0,96,0)'>void disp( char x ) { std::cout << x << ' '; }

<code style='color:rgb(0,96,0)'>int main()
<code style='color:rgb(0,96,0)'>{
    // =========================================================================
    // 循環バッファの先頭/末尾/ランダムアクセスの確認方法
    // =========================================================================

    // -------------------------------------
    // サイズ
    // -------------------------------------
    boost::circular_buffer<char> c_buf( 5 );

    // -----------------------------
    // イテレータ、begin/end
    // -----------------------------
    c_buf.push_front( 'A' );
    c_buf.push_front( 'B' );
    c_buf.push_front( 'C' );
                                                        //  ___ ___ ___ ___ ___
    std::for_each( c_buf.begin(), c_buf.end(), disp );  // |_C_|_B_|_A_|___|___|
    std::cout << std::endl;

    boost::circular_buffer<char>::iterator it = c_buf.begin();

    std::cout << c_buf.front()  << std::endl;           // 先頭の値取得 'C'
    std::cout << *it            << std::endl;           // 先頭の値 front()と同じ意味 'A'

    std::cout << c_buf.back()   << std::endl;           // 末尾の値取得 'A'
    std::cout << *( c_buf.end() - 1 ) << std::endl;     // 末尾の値 back()と同じ意味 'C'
//  std::cout << *c_buf.end()   << std::endl;           // これはできない
    std::cout << std::endl;

    c_buf.push_front( 'D' );
    c_buf.push_front( 'E' );
    c_buf.push_front( 'F' );
                                                        //  ___ ___ ___ ___ ___
    std::for_each( c_buf.begin(), c_buf.end(), disp );  // |_F_|_E_|_D_|_C_|_B_|
    std::cout << std::endl;

    std::cout << *it << std::endl;                      // かつての先頭だった'C' 
    std::cout << std::endl;

    c_buf.push_front( 'G' );
    c_buf.push_front( 'H' );
                                                        //  ___ ___ ___ ___ ___
    std::for_each( c_buf.begin(), c_buf.end(), disp );  // |_H_|_G_|_F_|_E_|_D_|
    std::cout << std::endl;

//  std::cout << *it << std::endl;                      // 'C' は消えたので、これはできない

    // -----------------------------
    // ランダムアクセス
    // -----------------------------
    std::cout << c_buf[0]     << std::endl;             // 'H'
    std::cout << c_buf.at(2)  << std::endl;             // c_buf[2]と同じ 'F' 
    std::cout << std::endl;

```
* c_buf[0][color ff0000]
* c_buf.at[color ff0000]

<code style='color:rgb(0,96,0)'>    return 0;</code>

<code style='color:rgb(0,96,0)'>}</code>


実行結果：
C B A
C
C
A
A

F E D C B
C

H G F E D
H
F



