# ロックフリースタック
ロックフリースタックには、[Boost Lockfree Library](http://www.boost.org/libs/lockfree/)の[`boost::lockfree::stack`](http://www.boost.org/doc/libs/release/doc/html/boost/lockfree/stack.html)クラスを使用する。

## インデックス
- [基本的な使い方](#basic-usage)


## <a id="basic-usage" href="#basic-usage">基本的な使い方</a>
ここでは、ロックフリースタックの基本的な使い方を示す。以下は、Producer-Consumerパターンで、一方のスレッドがスタックに値を供給し、もう一方のスレッドがスタックの値を消費する処理を行っている。

```cpp example
#include <iostream>
#include <thread>
#include <boost/lockfree/stack.hpp>

boost::lockfree::stack<int> stk(128);

void producer()
{
    for (int i = 0;; ++i) {
        while (!stk.push(i)) {} // スタックに値を追加
    }
}

void consumer()
{
    for (;;) {
        int x = 0;
        if (stk.pop(x)) { // スタックから値を取り出す
            std::cout << x << std::endl;
        }
    }
}

int main()
{
    std::thread t1(producer);
    std::thread t2(consumer);

    t1.join();
    t2.join();
}
```
* stack[color ff0000]
* push[color ff0000]
* pop[color ff0000]

出力：
```
0
1
2
3
4
…
```

**要素型**

スタックに格納する型は、[`boost::lockfree::stack`](http://www.boost.org/doc/libs/release/doc/html/boost/lockfree/stack.html)クラステンプレートの第1テンプレート引数で指定する。


**コンストラクタ**

[`boost::lockfree::stack`](http://www.boost.org/doc/libs/release/doc/html/boost/lockfree/stack.html)クラスのコンストラクタでは、スタックの最大容量を設定する。最大容量を設定しない構築はできない。

スタックへの追加＆取り出し操作は、最大容量を超えない範囲で行う。


**値の追加**

値の追加には、`stack::push()`メンバ関数を使用する。

この関数は失敗する可能性があるため、追加に成功したかどうかを`bool`で返す。


**値の取り出し**

値の取り出しには、`stack::pop()`メンバ関数を使用する。

この関数は、取り出した値をパラメータの参照で返し、取り出しに成功したら`true`、失敗したら`false`を返す。

