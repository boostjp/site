#サイズを動的に変更できるビット集合
サイズ固定のビット集合であるstd::bitset に対して、boost::dynamic_bitset はサイズを実行時に変更できるビット集合である。



Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>サイズを指定する](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>ビットの値を設定する](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>1の数を数える](#TOC-1-)</li><li class='goog-toc'>[<strong>4 </strong>ビットの値を検査する](#TOC--2)</li><li class='goog-toc'>[<strong>5 </strong>文字列との相互変換](#TOC--3)</li><li class='goog-toc'>[<strong>6 </strong>ビットの値を反転する](#TOC--4)</li><li class='goog-toc'>[<strong>7 </strong>集合演算](#TOC--5)</li><li class='goog-toc'>[<strong>8 </strong>2つの集合の包含関係を調べる](#TOC-2-)</li><li class='goog-toc'>[<strong>9 </strong>1が立っているインデックスを走査する](#TOC-1-1)</li><li class='goog-toc'>[<strong>10 </strong>データサイズをカスタマイズする](#TOC--6)</li></ol>




<h4>サイズを指定する</h4>
コンストラクタやメンバ関数resizeでビット集合のサイズを指定できる。










```cpp
#include <boost/dynamic_bitset.hpp>

#include <cassert>

#include <iostream>

using namespace std;
```

int main()

{

    boost::dynamic_bitset<> bs(3);  // サイズ3のビット集合(デフォルト値は全てのビットが0)

    assert(bs.size() == 3);	

    cout << bs << endl;   // -> 000


    bs.<color=ff0000>resize(5)</color>;    <span>    <span> <span>// サイズを5に変更</span></span></span>

<span><span><span>    assert(bs.size() == 5);</span></span></span>

    cout << bs << endl;   // -> 00000

}






<h4>ビットの値を設定する</h4>
メンバ関数set/reset、[ ]演算子でビットの値を設定できる。





```cpp
#include <boost/dynamic_bitset.hpp>

#include <iostream>

using namespace std;


int main()

{

    boost::dynamic_bitset<> bs(5);

    cout << bs << endl;    // -> 00000

    bs.set(0);             // メンバ関数setで0ビット目を1にする
```
* set(0)[color ff0000]

    cout << bs << endl;    // -> 00001

    bs.<color=ff0000>set(1).set(2)</color>;      // setやresetは*thisを返すので、メソッドチェーン形式で記述可能

    cout << bs << endl;    // -> 00111

    bs.<color=ff0000>set(2, false)</color>;      // setの第2引数にはboolを指定可能

    cout << bs << endl;    // -> 00011

    bs.<color=ff0000>set()</color>;              // 引数なしのsetは全てのビットを1にする

    cout << bs << endl;    // -> 11111

    bs.<color=ff0000>reset(0)</color>;           // メンバ関数resetで0ビット目を0にする

    cout << bs << endl;    // -> 11110

    bs.<color=ff0000>reset()</color>;            // 引数なしのresetは全てのビットを0にする

    cout << bs << endl;    // -> 00000

    bs<color=ff0000>[0]</color> = <color=ff0000>true</color>;          // []演算子で0ビット目を1にする

    cout << bs << endl;    // -> 00001

}

</code>





<h4>1の数を数える</h4>
メンバ関数countを使う




```cpp
#include <boost/dynamic_bitset.hpp>

#include <cassert>





int main()

{

    boost::dynamic_bitset<> bs(3); // -> 000


    assert(bs.count() == 0);

    bs.set();    // -> 111

    assert(bs.count() == 3);

}

```
* count()[color ff0000]
* count()[color ff0000]

<h4>ビットの値を検査する</h4>
特定のビットが1かを調べるにはメンバ関数testや演算子[ ]を使う。

1のビットがあるかどうかを調べるにはメンバ関数any, noneを使う。

すべてのビットが1かどうかを調べるにはメンバ関数countとsizeを組み合わせて使う。




```cpp
#include <boost/dynamic_bitset.hpp>

#include <cassert>

#include <iostream>

using namespace std;




int main()

{

    // すべてのビットが0か調べる

    boost::dynamic_bitset<> bs(3);  // -> 000


    assert(bs.none());     

    

    // 特定のビットが1か調べる

    bs[0] = true;   // -> 001

    assert(bs[0]);

    assert(bs.test(0));


```
* none()[color ff0000]
* [0][color ff0000]
* test(0)[color ff0000]

    // 1のビットがあるか調べる

    assert(bs.<color=ff0000>any()</color>);



    // すべてのビットが1か調べる    

    bs.set();  // -> 111

    assert(<color=ff0000>bs.count() == bs.size());   </color><code>
`}`

</code>





<h4>文字列との相互変換</h4>演算子<<および>>がオーバーロードされているため、istream/ostreamを通して文字列との相互変換が可能である。
文字列->ビット集合の変換に関しては、コンストラクタに文字列を渡すことでも生成できる。
ビット集合->文字列の変換に関しては、to_string関数を使用する事もできる。
文字列は'0'か'1'のみから構成される必要があり、文字列の右端がインデックス0に対応することに注意。

```cpp
#include <boost/dynamic_bitset.hpp>
#include <boost/lexical_cast.hpp>

int main()
{
    using boost::dynamic_bitset;
    using boost::lexical_cast;

    // std::string → dynamic_bitset
    dynamic_bitset<> bs(std::string("01"));  // コンストラクタに文字列を渡す
    assert(bs[0]);
    assert(!bs[1]);
    // dynamic_bitset → std::stirng
    std::string str;
    boost::to_string(bs, str);  // to_string 関数による変換

    // 演算子<<, >> がオーバーロードされているため、boost::lexical_castによる変換も出来る
    dynamic_bitset<> bs2 = lexical_cast<dynamic_bitset<> >("01");
    std::string str2 = lexical_cast<std::string>(bs2);
}
```
* bs(std::string("01"))[color ff0000]
* to_string(bs, str)[color ff0000]
* lexical_cast<dynamic_bitset<> >("01");[color ff0000]
* lexical_cast<std::string>(bs2);[color ff0000]

<h4>ビットの値を反転する</h4>
メンバ関数flipでビットの値を反転できる。




```cpp
#include <boost/dynamic_bitset.hpp>

#include <iostream>

using namespace std;


```

`int main()`

`{`

    boost::dynamic_bitset<> bs(3);

    cout << bs << endl;    // -> 000
    bs.<color=ff0000>flip(0);            // メンバ関数flipで0ビット目を反転</color>

    cout << bs << endl;    // -> 001
    bs.<color=ff0000>flip();    <span>    <span>     // 引数なしのflipは全てのビットを反転させる</span></span></color>

    cout << bs << endl;    // -> 110

`}`






<h4>集合演算</h4>
各種演算子(&, |, ^, ~,　-)およびその代入版(&=, |=, ^=, -=)によるビット毎の論理演算により、集合演算ができる。


ただし、2項演算子の引数のサイズは等しくなければならない。




```cpp
#include <boost/dynamic_bitset.hpp>


```

int main()

{

    boost::dynamic_bitset<> bs1(4), bs2(4);

    bs1.set(0).set(1);    // -> 0011

    bs2.set(0).set(2);    // -> 0101



    <color=ff0000>~</color>bs1;        // -> 1100    ビット毎の否定 = 補集合

    bs1 <color=ff0000>&</color> bs2;   // -> 0001    ビット毎の論理積 = 積集合

    bs1<color=ff0000> |</color> bs2;   // -> 0111    ビット毎の論理和 = 和集合

    bs1 <color=ff0000>^</color> bs2;   // -> 0110    ビット毎の排他的論理和 = 対称差

    bs1 <color=ff0000>-</color> bs2;   // -> 0010    差集合

}



<h4>2つの集合の包含関係を調べる</h4>ビット集合A, Bがある時、AがBの部分集合（A ⊆ B)かを調べるには、メンバ関数is_subset_ofを使う。
同様に、AがBの真部分集合（A ⊂ B）かを調べるには、メンバ関数is_proper_subset_ofを、
AとBが交差する（すなわち、AとBの積集合が空集合でない）かを調べるには、メンバ関数intersectsをそれぞれ使う。

```cpp
#include <boost/dynamic_bitset.hpp>
#include <cassert>

int main()
{
    
    boost::dynamic_bitset<> A(4), B(4), C(4);
    A.set(0);           // -> 0001
    B.set(0).set(1);    // -> 0011
    C.set(2).set(3);    // -> 1100
    
    assert(A.is_subset_of(A));  // AはA自身の部分集合
    assert(!A.is_proper_subset_of(A));   // AはA自身の真部分集合ではない
    assert(A.is_proper_subset_of(B));    // AはBの真部分集合
    assert(A.intersects(B));    // AはBと交差する
    assert(!B.intersects(C));   // BはCと交差しない    
}
```
* A.is_subset_of(A));  // AはA自身の部分集合[color ff0000]
* !A.is_proper_subset_of(A));   // AはA自身の真部分集合ではない[color ff0000]
* A.is_proper_subset_of(B));    // AはBの真部分集合[color ff0000]
* A.intersects(B));    // AはBと交差する[color ff0000]
* !B.intersects(C));   // BはCと交差しない[color ff0000]

 
<h4>1が立っているインデックスを走査する</h4>
メンバ関数find_firstとfind_nextを組み合わせて、1が立っているインデックスを走査できる。 
```cpp
#include <boost/dynamic_bitset.hpp>
#include <iostream>

int main()
{
    boost::dynamic_bitset<> bs(100);
<span>    </span>bs.set(10).set(20);

    // 1の立っているインデックスを走査
    for(boost::dynamic_bitset<>::size_type pos = bs.find_first();
    <span>    </span>pos != bs.npos;
        pos = bs.find_next(pos))
    {
        std::cout << pos << std::endl;
    }
} 
```
*     <span>    </span>pos != bs.npos;[color ff0000]
*         pos = bs.find_next(pos)[color ff0000]

出力```cpp
10
20
```

<h4>データサイズをカスタマイズする</h4>dynamic_bitsetは、第一テンプレート引数のBlock型のvectorでビット列を管理する。
Blockのデフォルト値はunsigned longであるが、別の型を指定することでデータサイズをカスタマイズできる。
ただし、Blockはunsigned 整数型でなければならない。


```cpp
#include <boost/dynamic_bitset.hpp>
#include <cassert>

using boost::dynamic_bitset;

// デフォルトはunsigned long
static_assert(dynamic_bitset<>::bits_per_block == sizeof(unsigned long)*8, "");
// unsigned shortに変更
static_assert(dynamic_bitset<unsigned short>::bits_per_block == sizeof(unsigned short)*8, "");	


```
* unsigned short[color ff0000]
