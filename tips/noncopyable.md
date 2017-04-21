# クラスをコピー不可にする
クラスをコピー不可にするには、`boost::noncopyable`クラスを`private`継承する。`boost::noncopyable`を使用するには、[`<boost/noncopyable.hpp>`](http://www.boost.org/doc/libs/release/libs/core/doc/html/core/noncopyable.html)をインクルードする。


```cpp
#include <boost/noncopyable.hpp>

class X : private boost::noncopyable {
};

int main()
{
    X a;
//  X b = a; // エラー！
}
```

