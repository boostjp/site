# ロックフリーキュー
ロックフリーキューには、[Boost Lockfree Library](http://www.boost.org/libs/lockfree/)の[`boost::lockfree::queue`](http://www.boost.org/doc/libs/release/doc/html/boost/lockfree/queue.html)クラスを使用する。

## インデックス
- [基本的な使い方](#basic-usage)
- [キューに格納可能な型](#constraint-element-type)


## <a name="basic-usage" href="#basic-usage">基本的な使い方</a>
ここでは、ロックフリーキューの基本的な使い方を示す。以下は、Producer-Consumerパターンで、一方のスレッドがキューに値を供給し、もう一方のスレッドがキューの値を消費する処理を行っている。

```cpp
#include <iostream>
#include <thread>
#include <boost/lockfree/queue.hpp>

boost::lockfree::queue<int> que(128);

void producer()
{
    for (int i = 0;; ++i) {
        while (!que.push(i)) {} // キューに値を追加
    }
}

void consumer()
{
    for (;;) {
        int x = 0;
        if (que.pop(x)) { // キューから値を取り出す
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
* queue[color ff0000]
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

キューに格納する型は、[boost::lockfree::queue](http://www.boost.org/doc/libs/release/doc/html/boost/lockfree/queue.html)クラステンプレートの第1テンプレート引数で指定する。


**コンストラクタ**

[`boost::lockfree::queue`](http://www.boost.org/doc/libs/release/doc/html/boost/lockfree/queue.html)クラスのコンストラクタでは、キューの最大容量を設定する。最大容量を設定しない構築はできない。

キューへの追加＆取り出し操作は、最大容量を超えない範囲で行う。


**値の追加**

値の追加には、`queue::push()`メンバ関数を使用する。

この関数は失敗する可能性があるため、追加に成功したかどうかを`bool`で返す。


**値の取り出し**

値の取り出しには、`queue::pop()`メンバ関数を使用する。

この関数は、取り出した値をパラメータの参照で返し、取り出しに成功したら`true`、失敗したら`false`を返す。


## <a name="constraint-element-type" href="#constraint-element-type">キューに格納可能な型</a>
[boost::lockfree::queue](http://www.boost.org/doc/libs/release/doc/html/boost/lockfree/queue.html)クラスには、要素型としてtrivially copyable(`memcpy`可能)な型のみを格納できる。

参照： [Boost.Lockfree ロックフリーキューの制限](http://d.hatena.ne.jp/faith_and_brave/20130213/1360737911)


documented boost version is 1.53.0
