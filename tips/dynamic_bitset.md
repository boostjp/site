#サイズを動的に変更できるビット集合
サイズ固定のビット集合である`std::bitset` に対して、`boost::dynamic_bitset` はサイズを実行時に変更できるビット集合である。

##インデックス

- [サイズを指定する](#resize)
- [ビットの値を設定する](#nth-bit)
- [1の数を数える](#count-one)
- [ビットの値を検査する](#test-bit)
- [文字列との相互変換](#string-conversion)
- [ビットの値を反転する](#flip)
- [集合演算](#set)
- [2つの集合の包含関係を調べる](#is-subset-of)
- [1が立っているインデックスを走査する](#each-one-bits)
- [データサイズをカスタマイズする](#customize-data-size)


# <a name="resize" href="#resize">サイズを指定する</a>

コンストラクタ、もしくはメンバ関数`resize()`でビット集合のサイズを指定できる。

```cpp
#include <boost/dynamic_bitset.hpp>
#include <cassert>
#include <iostream>
using namespace std;

int main()
{
    boost::dynamic_bitset<> bs(3);  // サイズ3のビット集合(デフォルト値は全てのビットが0)
    assert(bs.size() == 3); 
    cout << bs << endl;   // -> 000

    bs.resize(5);         // サイズを5に変更
    assert(bs.size() == 5);
    cout << bs << endl;   // -> 00000
}
```
* bs(3)[color ff0000]
* resize(5)[color ff0000]


## <a name="nth-bit" href="#nth-bit">ビットの値を設定する</a>

メンバ関数`set`/`reset`、`[ ]`演算子でビットの値を設定できる。

```cpp
#include <boost/dynamic_bitset.hpp>
#include <iostream>
using namespace std;
int main()
{
    boost::dynamic_bitset<> bs(5);
    cout << bs << endl;    // -> 00000
    bs.set(0);             // メンバ関数setで0ビット目を1にする
    cout << bs << endl;    // -> 00001
    bs.set(1).set(2);      // setやresetは*thisを返すので、メソッドチェーン形式で記述可能
    cout << bs << endl;    // -> 00111
    bs.set(2, false);      // setの第2引数にはboolを指定可能
    cout << bs << endl;    // -> 00011
    bs.set();              // 引数なしのsetは全てのビットを1にする
    cout << bs << endl;    // -> 11111
    bs.reset(0);           // メンバ関数resetで0ビット目を0にする
    cout << bs << endl;    // -> 11110
    bs.reset();            // 引数なしのresetは全てのビットを0にする
    cout << bs << endl;    // -> 00000
    bs[0] = true;          // []演算子で0ビット目を1にする
    cout << bs << endl;    // -> 00001
}
```
* set(0)[color ff0000]
* set(1).set(2)[color ff0000]
* set(2, false)[color ff0000]
* set()[color ff0000]
* reset(0)[color ff0000]
* reset()[color ff0000]
* [0] = true[color ff0000]


## <a name="count-one" href="#count-one">1の数を数える</a>

メンバ関数`count()`を使う

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


## <a name="test-bit" href="#test-bit">ビットの値を検査する</a>
特定のビットが1かを調べるにはメンバ関数`test()`もしくは`[ ]`演算子を使う。

1のビットがあるかどうかを調べるにはメンバ関数`any()`, `none()`を使う。

すべてのビットが1かどうかを調べるにはメンバ関数`count()`と`size()`を組み合わせて使う。


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

    // 1のビットがあるか調べる
    assert(bs.any());

    // すべてのビットが1か調べる    
    bs.set();  // -> 111
    assert(bs.count() == bs.size());   
}
```
* none()[color ff0000]
* [0][color ff0000]
* test(0)[color ff0000]
* any()[color ff0000]
* bs.count() == bs.size()[color ff0000]


## <a name="string-conversion" href="#string-conversion">文字列との相互変換</a>

`boost::dynamic_bitset`クラスでは演算子`<<`および`>>`がオーバーロードされているため、`istream`/`ostream`を通して文字列との相互変換が可能である。

文字列からビット集合への変換は、コンストラクタに文字列を渡すことでも生成できる。

ビット集合から文字列への変換は、`boost::to_string()`関数を使用することもできる。

文字列は`'0'`か`'1'`のみから構成される必要があり、文字列の右端がインデックス`0`に対応することに注意。


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


## <a name="flip" href="#flip">ビットの値を反転する</a>

メンバ関数`flip()`でビットの値を反転できる。

```cpp
#include <boost/dynamic_bitset.hpp>
#include <iostream>
using namespace std;

int main()
{
    boost::dynamic_bitset<> bs(3);
    cout << bs << endl;    // -> 000
    bs.flip(0);            // メンバ関数flipで0ビット目を反転
    cout << bs << endl;    // -> 001
    bs.flip();             // 引数なしのflipは全てのビットを反転させる
    cout << bs << endl;    // -> 110
}
```
* flip(0)[color ff0000]
* flip()[color ff0000]


## <a name="set" href="#set">集合演算</a>
各種演算子(`&`, `|`, `^`, `~`,　`-`)およびその代入版(`&=`, `|=`, `^=`, `-=`)によるビット毎の論理演算により、集合演算ができる。

ただし、2項演算子の引数のサイズは等しくなければならない。

```cpp
#include <boost/dynamic_bitset.hpp>

int main()
{
    boost::dynamic_bitset<> bs1(4), bs2(4);
    bs1.set(0).set(1);    // -> 0011
    bs2.set(0).set(2);    // -> 0101

    ~bs1;        // -> 1100    ビット毎の否定 = 補集合
    bs1 & bs2;   // -> 0001    ビット毎の論理積 = 積集合
    bs1 | bs2;   // -> 0111    ビット毎の論理和 = 和集合
    bs1 ^ bs2;   // -> 0110    ビット毎の排他的論理和 = 対称差
    bs1 - bs2;   // -> 0010    差集合
}
```
* ~bs1[color ff0000]
* bs1 & bs2[color ff0000]
* bs1 | bs2[color ff0000]
* bs1 ^ bs2[color ff0000]
* bs1 - bs2[color ff0000]


## <a name="is-subset-of" href="#is-subset-of">2つの集合の包含関係を調べる</a>

ビット集合A, Bがある時、AがBの部分集合（A ⊆ B)かを調べるには、メンバ関数`is_subset_of()`を使う。

同様に、AがBの真部分集合（A ⊂ B）かを調べるには、メンバ関数`is_proper_subset_of`を、AとBが交差する（すなわち、AとBの積集合が空集合でない）かを調べるには、メンバ関数`intersects()`をそれぞれ使う。


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
* A.is_subset_of(A)[color ff0000]
* !A.is_proper_subset_of(A)[color ff0000]
* A.is_proper_subset_of(B)[color ff0000]
* A.intersects(B)[color ff0000]
* !B.intersects(C)[color ff0000]

 
## <a name="each-one-bits" href="#each-one-bits">1が立っているインデックスを走査する</a>

メンバ関数`find_first()`と`find_next()`を組み合わせて、`1`が立っているインデックスを走査できる。 

```cpp
#include <boost/dynamic_bitset.hpp>
#include <iostream>

int main()
{
    boost::dynamic_bitset<> bs(100);
    bs.set(10).set(20);

    // 1の立っているインデックスを走査
    for(boost::dynamic_bitset<>::size_type pos = bs.find_first();
        pos != bs.npos;
        pos = bs.find_next(pos))
    {
        std::cout << pos << std::endl;
    }
} 
```
* boost::dynamic_bitset<>::size_type pos = bs.find_first();[color ff0000]
* pos != bs.npos;[color ff0000]
* pos = bs.find_next(pos)[color ff0000]

出力：

```
10
20
```


## <a name="customize-data-size" href="#customize-data-size">データサイズをカスタマイズする</a>

`boost::dynamic_bitset`は、第1テンプレート引数の`Block`型の`std::vector`でビット列を管理する。

`Block`のデフォルト値は`unsigned long`であるが、別の型を指定することでデータサイズをカスタマイズできる。

ただし、`Block`は符号なし整数型でなければならない。

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

