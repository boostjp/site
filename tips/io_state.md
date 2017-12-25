# ストリームの状態を戻す
[Boost IO State Savers Library](http://www.boost.org/doc/libs/release/libs/io/doc/ios_state.html)を使用すると、ストリームオブジェクトを以前の状態に戻すことができる。

## インデックス
- [フォーマットフラグを戻す](#format-flags)


## <a id="format-flags" href="#format-flags">フォーマットフラグを戻す</a>
`boost::ios_flags_saver`に`istream`もしくは`ostream`オブジェクトへの参照を渡すことで、そのスコープを抜ける際にフォーマットフラグを以前の状態に戻してくれる。

```cpp example
#include <iostream>
#include <iomanip>
#include <boost/io/ios_state.hpp>

void disp_hex(std::ostream& os, int value)
{
    // スコープを抜けたらフォーマットフラグを戻す
    boost::io::ios_flags_saver ifs(os);

    os << std::hex << value << std::endl;
}

int main()
{
    disp_hex(std::cout, 10);      // 16進数で出力
    std::cout << 10 << std::endl; // 10進数で出力
}
```

実行結果：
```
a
10
```

