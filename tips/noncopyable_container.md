#コピー不可なオブジェクトを持ちまわる
ボタンやテクスチャ、コネクション、ファイルといったデータはコピー禁止に設定されていることが多い。そういったデータを、コピー可能であることを要求するコンテナに格納するには、`boost::shared_ptr`に入れる。

```cpp
#include <iostream>
#include <vector>
#include <string>
#include <boost/noncopyable.hpp>
#include <boost/make_shared.hpp>
#include <boost/foreach.hpp>
#include <boost/range/adaptor/indirected.hpp>

class Button : private boost::noncopyable {
    std::string caption_;
public:
    explicit Button(const std::string& caption)
        : caption_(caption) {}

    std::string caption() const { return caption_; }
};

int main()
{
    std::vector<boost::shared_ptr<Button> > buttons;

    // コピー不可なクラスオブジェクトをコンテナに格納
    buttons.push_back(boost::make_shared<Button>("OK"));
    buttons.push_back(boost::make_shared<Button>("Cancel"));

    // ボタンのコンテナをループする
    BOOST_FOREACH (const Button& button, buttons | boost::adaptors::indirected) {
        std::cout << button.caption() << std::endl;
    }
}
```

実行結果：

```
OK
Cancel
```

