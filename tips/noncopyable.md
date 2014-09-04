#クラスをコピー不可にする
クラスをコピー不可にするには、boost::noncopyableクラスをprivate継承する。boost::noncopyableを使用するには、<boost/noncopyable.hpp>をインクルードする。


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
