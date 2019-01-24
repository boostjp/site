# 演算子を自動定義する
C++は演算子のオーバーロードによって、ユーザー定義型に演算子を持たせることができる。各演算子には関連性があり、ひとつ定義すれば他の演算子も同じように書ける。たとえば、`operator<()`さえ定義すれば、`operator>()`、`operator<=()`, `operator>=()`は`operator<()`から定義できる。[Boost Operators Library](http://www.boost.org/doc/libs/release/libs/utility/operators.htm)は、このような関連演算子を自動的に定義する機構を提供する。


## インデックス
- [基本的な使い方 - 整数型を定義する](#basic-usage)
- [算術演算子](#arithmetic-operators)
    - [大小比較の演算子を自動定義する](#less-than-comparable)
    - [等値比較の演算子を自動定義する](#equality-comparable)
    - [加算演算子を自動定義する](#addable)
    - [減算演算子を自動定義する](#subtractable)
    - [乗算演算子を自動定義する](#multipliable)
    - [除算演算子を自動定義する](#dividable)
    - [剰余演算子を自動定義する](#modable)
    - [OR演算子を自動定義する](#orable)
    - [AND演算子を自動定義する](#andable)
    - [XOR演算子を自動定義する](#xorable)
    - [インクリメント演算子を自動定義する](#incrementable)
    - [デクリメント演算子を自動定義する](#decrementable)
    - [左シフト演算子を自動定義する](#left_shiftable)
    - [右シフト演算子を自動定義する](#right_shiftable)
    - [小なり演算子から、等値比較演算子を自動定義する](#equivalent)


## <a id="basic-usage" href="#basic-usage">基本的な使い方 - 整数型を定義する</a>
整数型をラップした型を作るためには、多くの演算子を定義する必要がある。

Boost.Operatorsによって関連演算子を自動定義することによって、これだけで整数型を定義することができる。

```cpp example
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
```

`boost::operators`型を`private`継承したクラスでは、

- `operator<()`を定義することによって、`operator>()`、`operator<=()`、`operator>=()`が自動的に定義され、
- `operator==()`を定義することによって、`operator!=()`が定義され、
- `operator+=`によって`operator+()`が定義され、他の関連演算子も同様に自動的に定義される。


## <a id="arithmetic-operators" href="#arithmetic-operators">算術演算子</a>

### <a id="less-than-comparable" href="#less-than-comparable">大小比較の演算子を自動定義する</a>
大小比較の演算子、すなわち、`operator<()`、`operator>()`、`operator<=()`、`operator>=()`は、`boost::less_than_comparable`を`private`継承することにより、`operator<()`だけを定義すれば、それ以外の関連演算子が自動的に定義される。


**メンバ関数として定義する場合**

```cpp example
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

**非メンバ関数として定義する場合**

```cpp example
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
```


### <a id="equality-comparable" href="#equality-comparable">等値比較の演算子を自動定義する</a>
等値比較の演算子、すなわち、`operator==()`、`operator!=()`は、`boost::equality_comparable`を`private`継承することにより、`operator==()`だけを定義すれば、関連する`operator!=()`が自動的に定義される。


**メンバ関数として定義する場合**

```cpp example
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
```


**非メンバ関数として定義する場合**

```cpp example
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
```


### <a id="addable" href="#addable">加算演算子を自動定義する</a>
加算演算子である`operator+=()`、`operator+()`は、`boost::addable`を`private`継承することにより、`operator+=()`を定義するだけで`operator+()`が自動的に定義される。

```cpp example
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
```


### <a id="subtractable" href="#subtractable">減算演算子を自動定義する</a>
減算演算子である`operator-=()`、`operator-()`は、`boost::subtractable`を`private`継承することにより、`operator-=()`を定義するだけで`operator-()`が自動的に定義される。

```cpp example
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


### <a id="multipliable" href="#multipliable">乗算演算子を自動定義する</a>
乗算演算子である`operator*=()`, `operator*()`は、`boost::multipliable`を`private`継承することにより、`operator*=()`定義するだけで、自動的に`operator*()`が定義される。

```cpp example
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


### <a id="dividable" href="#dividable">除算演算子を自動定義する</a>
除算演算子である`operator/=()`、`operator/()`は、`boost::dividable`を`private`継承することにより、`operator/=()`を定義するだけで、`operator/()`が自動定義される。

```cpp example
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
```


### <a id="modable" href="#modable">剰余演算子を自動定義する</a>
剰余演算子である`operator%=()`、`operator%()`は、`boost::modable`を`private`継承することにより、`operator%=()`を定義するだけで、`operator%()`が自動定義される。

```cpp example
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


## <a id="orable" href="#orable">OR演算子の自動定義</a>
OR演算子である`operator|=()`、`operator|()`は、`boost::orable`を`private`継承することにより、`operator|=()`を定義するだけで、`operator|()`が自動定義される。

```cpp example
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


### <a id="andable" href="#andable">AND演算子を自動定義する</a>
AND演算子、`operator&=()`、`operator&()`は、`boost::andable`を`private`継承することにより、`operator&=()`を定義するだけで、`operator&()`が自動定義される。

```cpp example
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
```


### <a id="xorable" href="#xorable">XOR演算子の自動定義</a>
XOR演算子である`operator^=()`、`operator^()`は、`boost::xorable`を`private`継承することにより、`operator^=()`を定義するだけで、`operator^()`が自動定義される。

```cpp example
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


### <a id="incrementable" href="#incrementable">インクリメント演算子を自動定義する</a>
インクリメント演算子である前置`++()`, 後置`++()`は、`boost::incrementable`を`private`継承することにより、前置`++()`を定義するだけで、後置`++()`が自動定義される。

```cpp example
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


### <a id="decrementable" href="#decrementable">デクリメント演算子を自動定義する</a>
デクリメント演算子である前置`--()`、後置`--()`は、`boost::decrementable`を`private`継承することにより、前置`--()`を定義するだけで、後置`--()`が自動定義される。

```cpp example
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


### <a id="left_shiftable" href="#left_shiftable">左シフト演算子を自動定義する</a>
左シフト演算子である`operator<<=()`、`operator<<()`は、`boost::left_shiftable`を`private`継承することにより、`operator<<=()`を定義するだけで、`operator<<()`が自動定義される。

```cpp example
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


### <a id="right_shiftable" href="#right_shiftable">右シフト演算子を自動定義する</a>
右シフト演算子である`operator>>=()`、`operator>>()`は、`boost::right_shiftable`を`private`継承することにより、`operator>>=()`を定義するだけで、`operator>>()`が自動定義される。

```cpp example
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
```


### <a id="equivalent" href="#equivalent">小なり演算子から、等値比較演算子を自動定義する</a>
等値比較演算子である`operator==()`は、小なり演算子`operator<()`で定義することができる。

`boost::equivalent`を`private`継承することにより、`operator<()`を定義するだけで、`operator==()`が自動定義される。

```cpp example
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

