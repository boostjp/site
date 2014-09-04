#演算子を自動定義する
C++は演算子のオーバーロードによって、ユーザー定義型に演算子を持たせることができる。各演算子には関連性があり、ひとつ定義すれば他の演算子も同じように書ける。たとえば、operator<()さえ定義すれば、operator>()、operator<=(), operator>=()が定義できる。Boost Operators Libraryは、このような関連演算子を自動的に定義する機構を提供する。


Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>基本的な使い方 - 整数型を定義する](#TOC---)</li><li class='goog-toc'>[<strong>2 </strong>算術演算子](#TOC--)<ol class='goog-toc'><li class='goog-toc'>[<strong>2.1 </strong>大小比較の演算子を自動定義する](#TOC--1)</li><li class='goog-toc'>[<strong>2.2 </strong>等値比較の演算子を自動定義する](#TOC--2)</li><li class='goog-toc'>[<strong>2.3 </strong>加算演算子の自動定義](#TOC--3)</li><li class='goog-toc'>[<strong>2.4 </strong>減算演算子の自動定義](#TOC--4)</li><li class='goog-toc'>[<strong>2.5 </strong>乗算演算子の自動定義](#TOC--5)</li><li class='goog-toc'>[<strong>2.6 </strong>除算演算子の自動定義](#TOC--6)</li><li class='goog-toc'>[<strong>2.7 </strong>剰余演算子の自動定義](#TOC--7)</li><li class='goog-toc'>[<strong>2.8 </strong>OR演算子の自動定義](#TOC-OR-)</li><li class='goog-toc'>[<strong>2.9 </strong>AND演算子の自動定義](#TOC-AND-)</li><li class='goog-toc'>[<strong>2.10 </strong>XOR演算子の自動定義](#TOC-XOR-)</li><li class='goog-toc'>[<strong>2.11 </strong>インクリメント演算子の自動定義](#TOC--8)</li><li class='goog-toc'>[<strong>2.12 </strong>デクリメント演算子の自動定義](#TOC--9)</li><li class='goog-toc'>[<strong>2.13 </strong>左シフト演算子の自動定義](#TOC--10)</li><li class='goog-toc'>[<strong>2.14 </strong>右シフト演算子の自動定義](#TOC--11)</li><li class='goog-toc'>[<strong>2.15 </strong>小なり演算子から、等値比較演算子を自動定義する](#TOC--12)</li></ol></li></ol>




###基本的な使い方 - 整数型を定義する
整数型をラップした型を作るためには、多くの演算子を定義する必要がある。
Boost Operatorsによって関連演算子を自動定義することによって、これだけで整数型を定義することができる。

```cpp
#include <cassert>
#include <boost/operators.hpp>

class MyInt : private boost::operators<MyInt> {
    int v;
public:
    MyInt(int v) : v(v) {}

    bool operator<(const MyInt& x) const { return v < x.v; }
    bool operator==(const MyInt& x) const { return v == x.v; }
    MyInt& operator+=(const MyInt& x) { v += x.v; return *this; }
    MyInt& operator-=(const MyInt& x) { v -= x.v; return *this; }
    MyInt& operator*=(const MyInt& x) { v *= x.v; return *this; }
    MyInt& operator/=(const MyInt& x) { v /= x.v; return *this; }
    MyInt& operator%=(const MyInt& x) { v %= x.v; return *this; }
    MyInt& operator|=(const MyInt& x) { v |= x.v; return *this; }
    MyInt& operator&=(const MyInt& x) { v &= x.v; return *this; }
    MyInt& operator^=(const MyInt& x) { v ^= x.v; return *this; }
    MyInt& operator++() { ++v; return *this; }
    MyInt& operator--() { --v; return *this; }
};

int main()
{
    // operator<()によって自動生成される演算子
    {
        const MyInt x = 3;
        assert(x <  MyInt(4));
        assert(x >  MyInt(2));
        assert(x <= MyInt(3));
        assert(x >= MyInt(3));
    }
    // operator==()によって自動生成される演算子
    {
        const MyInt x = 3;
        assert(x == MyInt(3));
        assert(x != MyInt(2));
    }
    // operator+=()によって自動生成される演算子
    {
        MyInt x = 3;
        x += MyInt(2);
        assert(x == MyInt(5));

        const MyInt y = x + MyInt(4);
        assert(y == MyInt(9));
    }
    // 以下略...
}


boost::operators型をprivate継承したクラスでは、

- operator<()を定義することによって、operator>()、operator<=()、operator>=()が自動的に定義され、
- operator==()を定義することによって、operator!=()が定義され、
- operator+=によってoperator+()が定義され、他の関連演算子も同様に自動的に定義される。
```

###算術演算子
<h4>大小比較の演算子を自動定義する</h4>大小比較の演算子、すなわち、operator<(), operator>(), operator<=(), operator>=()は、boost::less_than_comparableをprivate継承することにより、operator<()だけを定義すれば、それ以外の関連演算子が自動的に定義される。

<b>メンバ関数として定義する場合</b>

```cpp
#include <cassert>
#include <boost/operators.hpp>

class MyInt : private boost::less_than_comparable<MyInt> {
    int v;
public:
    MyInt(int v) : v(v) {}

    bool operator<(const MyInt& x) const { return v < x.v; }
};

int main()
{
    // operator<()によって自動生成される演算子
    {
        const MyInt x = 3;
        assert(x <  MyInt(4));
        assert(x >  MyInt(2));
        assert(x <= MyInt(3));
        assert(x >= MyInt(3));
    }
}

```

<b>フリー関数として定義する場合</b>

```cpp
#include <cassert>
#include <boost/operators.hpp>

class MyInt : private boost::less_than_comparable<MyInt, MyInt> {
    int v;
public:
    MyInt(int v) : v(v) {}

    friend bool operator<(const MyInt& a, const MyInt& b)
        { return a.v < b.v; }
};

int main()
{
    // operator<()によって自動生成される演算子
    {
        const MyInt x = 3;
        assert(x <  MyInt(4));
        assert(x >  MyInt(2));
        assert(x <= MyInt(3));
        assert(x >= MyInt(3));
    }
}


<h4>等値比較の演算子を自動定義する</h4>等値比較の演算子、すなわち、operator==(), operator!=()は、boost::equality_comprableをprivate継承することにより、operator==()だけを定義すれば、関連するoperator!=()が自動的に定義される。

<b>メンバ関数として定義する場合</b>


```cpp
#include <cassert>
#include <boost/operators.hpp>

class MyInt : private boost::equality_comparable<MyInt> {
    int v;
public:
    MyInt(int v) : v(v) {}

    bool operator==(const MyInt& x) const
        { return v == x.v; }
};

int main()
{
    // operator==()によって自動生成される演算子
    {
        const MyInt x = 3;
        assert(x == MyInt(3));
        assert(x != MyInt(2));
    }
}



<b>フリー関数として定義する場合</b>


```cpp
#include <cassert>
#include <boost/operators.hpp>

class MyInt : private boost::equality_comparable<MyInt, MyInt> {
    int v;
public:
    MyInt(int v) : v(v) {}

    friend bool operator==(const MyInt& a, const MyInt& b)
        { return a.v == b.v; }
};

int main()
{
    // operator==()によって自動生成される演算子
    {
        const MyInt x = 3;
        assert(x == MyInt(3));
        assert(x != MyInt(2));
    }
}



<h4>加算演算子の自動定義</h4>加算演算子、operator+=()、operator+()は、boost::addableをprivate継承することにより、operator+=()を定義するだけでoperator+()が自動的に定義される。


```cpp
#include <cassert>
#include <boost/operators.hpp>

class MyInt : private boost::addable<MyInt> {
public:
    int v;

    MyInt(int v) : v(v) {}

    MyInt& operator+=(const MyInt& x)
    {
        v += x.v;
        return *this;
    }
};

int main()
{
    // operator+=()によって自動生成される演算子
    MyInt x = 3;
    x += MyInt(2);
    assert(x.v == 5);

    const MyInt y = x + MyInt(4);
    assert(y.v == 9);
}



<h4>減算演算子の自動定義</h4>減算演算子、operator-=()、operator-()は、boost::subtractableをprivate継承することにより、operator-=()を定義するだけでoperator-()が自動的に定義される。


```cpp
#include <cassert>
#include <boost/operators.hpp>

class MyInt : private boost::subtractable<MyInt> {
public:
    int v;

    MyInt(int v) : v(v) {}

    MyInt& operator-=(const MyInt& x)
    {
        v -= x.v;
        return *this;
    }
};

int main()
{
    // operator-=()によって自動生成される演算子
    MyInt x = 5;
    x -= MyInt(2);
    assert(x.v == 3);

    const MyInt y = x - MyInt(1);
    assert(y.v == 2);
}


```

<h4>乗算演算子の自動定義</h4>乗算演算子、operator*=(), operator*()は、boost::multipliableをprivate継承することにより、operator*=()定義するだけで、自動的にoperator*()が定義される。

```cpp
#include <cassert>
#include <boost/operators.hpp>

class MyInt : private boost::multipliable<MyInt> {
public:
    int v;

    MyInt(int v) : v(v) {}

    MyInt& operator*=(const MyInt& x)
    {
        v *= x.v;
        return *this;
    }
};

int main()
{
    // operator*=()によって自動生成される演算子
    MyInt x = 5;
    x *= MyInt(2);
    assert(x.v == 10);

    const MyInt y = x * MyInt(2);
    assert(y.v == 20);
}
```

<h4>除算演算子の自動定義</h4>除算演算子、operator/=(), operator/()は、boost::dividableをprivate継承することにより、operator/=()を定義するだけで、operator/()が自動定義される。


```cpp
#include <cassert>
#include <boost/operators.hpp>

class MyInt : private boost::dividable<MyInt> {
public:
    int v;

    MyInt(int v) : v(v) {}

    MyInt& operator/=(const MyInt& x)
    {
        v /= x.v;
        return *this;
    }
};

int main()
{
    // operator/=()によって自動生成される演算子
    MyInt x = 20;
    x /= MyInt(2);
    assert(x.v == 10);

    const MyInt y = x / MyInt(2);
    assert(y.v == 5);
}



<h4>剰余演算子の自動定義</h4>剰余演算子、operator%=(), operator%()は、boost::modableをprivate継承することにより、operator%=()を定義するだけで、operator%()が自動定義される。

```cpp
#include <cassert>
#include <boost/operators.hpp>

class MyInt : private boost::modable<MyInt> {
public:
    int v;

    MyInt(int v) : v(v) {}

    MyInt& operator%=(const MyInt& x)
    {
        v %= x.v;
        return *this;
    }
};

int main()
{
    // operator%=()によって自動生成される演算子
    MyInt x = 20;
    x %= MyInt(2);
    assert(x.v == 0);

    const MyInt y = MyInt(7) % MyInt(2);
    assert(y.v == 1);
}
```

<h4>OR演算子の自動定義</h4>OR演算子、operator|=(), operator|()は、boost::orableをprivate継承することにより、operator|=()を定義するだけで、operator|()が自動定義される。

```cpp
#include <cassert>
#include <boost/operators.hpp>

class MyInt : private boost::orable<MyInt> {
public:
    int v;

    MyInt(int v) : v(v) {}

    MyInt& operator|=(const MyInt& x)
    {
        v |= x.v;
        return *this;
    }
};

int main()
{
    // operator|=()によって自動生成される演算子
    MyInt x = 0x55;
    x |= MyInt(0x0F);
    assert(x.v == 0x5F);

    const MyInt y = MyInt(0x55) | MyInt(0x0F);
    assert(y.v == 0x5F);
}
```

<h4>AND演算子の自動定義</h4>AND演算子、operator&=(), operator&()は、boost::andableをprivate継承することにより、operator&=()を定義するだけで、operator&()が自動定義される。

```cpp
#include <cassert>
#include <boost/operators.hpp>

class MyInt : private boost::andable<MyInt> {
public:
    int v;

    MyInt(int v) : v(v) {}

    MyInt& operator&=(const MyInt& x)
    {
        v &= x.v;
        return *this;
    }
};

int main()
{
    // operator&=()によって自動生成される演算子
    MyInt x = 0x55;
    x &= MyInt(0x0F);
    assert(x.v == 0x05);

    const MyInt y = MyInt(0x55) & MyInt(0x0F);
    assert(y.v == 0x05);
}


<h4>XOR演算子の自動定義</h4>XOR演算子、operator^=(), operator^()は、boost::xorableをprivate継承することにより、operator^=()を定義するだけで、operator^()が自動定義される。

```cpp
#include <cassert>
#include <boost/operators.hpp>

class MyInt : private boost::xorable<MyInt> {
public:
    int v;

    MyInt(int v) : v(v) {}

    MyInt& operator^=(const MyInt& x)
    {
        v ^= x.v;
        return *this;
    }
};

int main()
{
    // operator^=()によって自動生成される演算子
    MyInt x = 0x55;
    x ^= MyInt(0x0F);
    assert(x.v == 0x5A);

    const MyInt y = MyInt(0x55) ^ MyInt(0x0F);
    assert(y.v == 0x5A);
}
```

<h4>インクリメント演算子の自動定義</h4>インクリメント演算子、前置++(), 後置++()は、boost::incrementableをprivate継承することにより、前置++()を定義するだけで、後置++()が自動定義される。

```cpp
#include <cassert>
#include <boost/operators.hpp>

class MyInt : private boost::incrementable<MyInt> {
public:
    int v;

    MyInt(int v) : v(v) {}

    MyInt& operator++()
    {
        ++v;
        return *this;
    }
};

int main()
{
    // operator++()によって自動生成される演算子
    MyInt x = 1;
    assert((++x).v == 2);

    MyInt y = 1;
    assert((y++).v == 1);
    assert(y.v == 2);
}
```

<h4>デクリメント演算子の自動定義</h4>デクリメント演算子、前置--(), 後置--()は、boost::decrementableをprivate継承することにより、前置--()を定義するだけで、後置--()が自動定義される。

```cpp
#include <cassert>
#include <boost/operators.hpp>

class MyInt : private boost::decrementable<MyInt> {
public:
    int v;

    MyInt(int v) : v(v) {}

    MyInt& operator--()
    {
        --v;
        return *this;
    }
};

int main()
{
    // operator--()によって自動生成される演算子
    MyInt x = 2;
    assert((--x).v == 1);

    MyInt y = 2;
    assert((y--).v == 2);
    assert(y.v == 1);
}
```

<h4>左シフト演算子の自動定義</h4>左シフト演算子、operator<<=(), operator<<()は、boost::left_shiftableをprivate継承することにより、operator<<=()を定義するだけで、operator<<()が自動定義される。

```cpp
#include <cassert>
#include <boost/operators.hpp>

class MyInt : private boost::left_shiftable<MyInt> {
public:
    int v;

    MyInt(int v) : v(v) {}

    MyInt& operator<<=(MyInt x)
    {
        v <<= x.v;
        return *this;
    }
};

int main()
{
    // operator<<=()によって自動生成される演算子
    MyInt x = 100;
    x <<= MyInt(1);
    assert(x.v == 200);

    MyInt y = 100;
    y = y << MyInt(1);
    assert(y.v == 200);
}
```

<h4>右シフト演算子の自動定義</h4>右シフト演算子、operator>>=(), operator>>()は、boost::right_shiftableをprivate継承することにより、operator>>=()を定義するだけで、operator>>()が自動定義される。

```cpp
#include <cassert>
#include <boost/operators.hpp>

class MyInt : private boost::right_shiftable<MyInt> {
public:
    int v;

    MyInt(int v) : v(v) {}

    MyInt& operator>>=(MyInt x)
    {
        v >>= x.v;
        return *this;
    }
};

int main()
{
    // operator>>=()によって自動生成される演算子
    MyInt x = 100;
    x >>= MyInt(1);
    assert(x.v == 50);

    MyInt y = 100;
    y = y >> MyInt(1);
    assert(y.v == 50);
}


<h4>小なり演算子から、等値比較演算子を自動定義する</h4>等値比較演算子operator==()は、小なり演算子operator<()で定義することができる。
boost::equivalentをprivate継承することにより、operator<()を定義するだけで、operator==()が自動定義される。

```cpp
#include <cassert>
#include <boost/operators.hpp>

class MyInt : private boost::equivalent<MyInt> {
public:
    int v;

    MyInt(int v) : v(v) {}

    bool operator<(MyInt x) const
    {
        return v < x.v;
    }
};

int main()
{
    // operator<()によって自動生成される演算子
    assert(MyInt(1) <  MyInt(2));
    assert(MyInt(2) == MyInt(2));
}
```
