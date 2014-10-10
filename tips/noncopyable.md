#クラスをコピー不可にする
クラスをコピー不可にするには、`boost::noncopyable`クラスを`private`継承する。`boost::noncopyable`を使用するには、`<boost/noncopyable.hpp>`をインクルードする。


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

