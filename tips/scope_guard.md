#スコープを抜ける際に実行されるブロック
スコープを抜ける際に、リソースを確実に解放するのはC++のRAIIという手法で行われる。しかし、RAIIはクラスと、そのデストラクタを書くことによってリソースを解放するため、関数ローカルにおいて即興で必要となる場合にはコード量が多くなってしまう。

Boost C++ Librariesでは、関数を抜ける際に実行される式、またはブロックを定義する方法をいくつか提供している。


##インデックス
- [Boost Scope Exit Libraryを使用する](#scope-exit)


## <a name="scope-exit" href="scope-exit">Boost Scope Exit Libraryを使用する</a>
Boost.ScopeExitは、関数のスコープを抜ける際に実行されるブロックを定義するための`BOOST_SCOPE_EXIT`マクロを提供する。

以下がその基本的な使い方である：

```cpp
#include <iostream>
#include <boost/scope_exit.hpp>

struct X {
    int value;

    void foo()
    {
        value = 0;

        BOOST_SCOPE_EXIT((&value)) {
            value = 2;
        } BOOST_SCOPE_EXIT_END

        value = 1;
    }
};

int main()
{
    X x;
    x.foo();

    std::cout << x.value << std::endl;
}
```

実行結果：
```
2
```

関数`X::foo()`の中では、関数の先頭で`value`に`0`を代入し、関数を抜ける直前で`value`に`1`を代入している。

そして、`BOOST_SCOPE_EXIT`マクロで定義されたブロックの中で`value`に`2`が代入されているが、このブロックが`X::foo()`を抜けるタイミングで呼び出されることで、最終的に`value`の値が`2`になっている。

Boost.ScopeExitは **変数のキャプチャ** という機能を持っており、

```cpp
&value
```

という表記によって、変数`value`への参照をScope Exit構文の中で使用できるようにしている。

```cpp
value
```

と書いた場合には、変数`value`のコピーをScope Exit構文の中で使用できるようになる。

また、以下のように、変数をカッコで囲んで連続で記述することにより、複数の変数をキャプチャすることができる。
```cpp
BOOST_SCOPE_EXIT((&x)(&y)) {
    x = x + 1;
    y = y + 1;
} BOOST_SCOPE_EXIT_END
```

なお、Boost-1.50以降ではラムダ式を用いたC++11版の[`BOOST_SCOPE_EXIT_ALL`](http://www.boost.org/doc/libs/1_50_0/libs/scope_exit/doc/html/BOOST_SCOPE_EXIT_ALL.html)マクロが追加され、次のように簡潔なコードも可能になった。

```cpp
BOOST_SCOPE_EXIT_ALL(&x, &y) {
    x = x + 1;
    y = y + 1;
};
```

`BOOST_SCOPE_EXIT_ALL`では引数をカンマで区切り、それぞれに`=`または`&`により値キャプチャーと参照キャプチャーを定義でき、`BOOST_SCOPE_EXIT_END`に相当する終端マクロは不要になった。ただし、スコープ定義の終わりにはステートメント終端のセミコロンが必要になっている点に注意されたい。

`BOOST_SCOPE_EXIT`と`BOOST_SCOPE_EXIT_TPL`の内部実装を`BOOST_SCOPE_EXIT_ALL`と同様にラムダ式を使うバージョンに切り替えるための[`BOOST_SCOPE_EXIT_CONFIG_USE_LAMBDAS`](http://www.boost.org/doc/libs/1_50_0/libs/scope_exit/doc/html/BOOST_SCOPE_EXIT_CONFIG_USE_LAMBDAS.html)マクロも用意されている。


**Boost.ScopeExitの使いどころ**

Boost ScopeExitは主にメンバ変数に対する関数内でのコミット／ロールバックを目的に使用されることが多い。

たとえば、ボタンクラスを作成することを考える。

ボタンは、「押した」「離した」という状態をボタン自身に伝える機能を持ち、内部で通常状態と押下状態の画像を切り替えることができる。

```cpp
class Button {
public:
    void down();
    void up();

    bool is_down() const;
    bool in_rect(const Point& p) const;
};
```

そして、ボタンをメンバ変数として持つ画面クラスが、画面のある位置をクリックした場合に呼ばれるハンドラを持っているとしよう。

以下のように書くことでボタンの画像切り替えロジックが書ける。

```cpp
class View {
    Button back_button_;
public:
    void on_click_down(const Point& p)
    {
        if (back_button_.in_rect(p)) {
            back_button_.down(); // 押下状態の画像に切替える
        }
    }

    void on_click_up(const Point& p)
    {
        if (back_button_.is_down() &&
            back_button_.in_rect(p)) {
            back_button_.up(); // 通常状態の画像に切り替える
            on_back_button();
        }
    }

    // 戻るボタンが押された
    void on_back_button()
    {
        ...
    }
};
```

ここでは、`on_click_up()`の中で「押されていたら離して処理する」ということをしている。

このプログラムが問題になるのは、ボタンが増えたときや、途中で`return`する必要が出てきた場合である。押されている状態からでなければ離すことはできないので、関数の始めに離すことはできず、途中で`return`されることを考えると関数の最後で離すこともできない。

そういったときに、Boost.ScopeExitを使用することで、関数のスコープを抜けた際に、全てのボタンを確実に離すことができる。
```cpp
class View {
    Button back_button_;
    Button next_button_;
public:
    void on_click_down(const Point& p)
    {
        if (back_button_.in_rect(p)) {
            back_button_.down(); // 押下状態の画像に切替える
        }

        if (next_button_.in_rect(p)) {
            next_button_.down();
        }
    }

    void on_click_up(const Point& p)
    {
        BOOST_SCOPE_EXIT((&back_button_)(&next_button_)) {
            // スコープを抜ける際に全てのボタンを離す
            back_button_.up();
            next_button_.up();
        } BOOST_SCOPE_EXIT_END

        if (back_button_.is_down() &&
            back_button_.in_rect(p)) {
            on_back_button();
        }

        if (next_button_.is_down() &&
            next_button_.in_rect(p)) {
            on_next_button();
        }
    }

    // 戻るボタンが押された
    void on_back_button()
    {
        ...
    }

    // 次へボタンが押された
    void on_next_button()
    {
        ...
    }
};
```

