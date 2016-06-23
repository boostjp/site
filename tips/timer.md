#処理時間の計測
処理時間の計測には、 [Boost Timer Library](http://www.boost.org/doc/libs/release/libs/timer/doc/index.html) の`boost::timer::cpu_timer`クラスを使用する。


##インデックス
- [基本的な使い方](#basic-usage)
- [開始、停止、再開を制御する](#start-stop-resume)
- [処理時間の値を個別に取得する](#elapsed-values)
- [出力結果のフォーマットをカスタマイズする](#customize-format)


## <a name="basic-usage" href="#basic-usage">基本的な使い方</a>
`cpu_timer`クラスでは、コンストラクタで時間計測が開始され、`format()`メンバ関数で計測結果の`std::string`を返す。

```cpp
#include <iostream>
#include <cmath>
#include <boost/timer/timer.hpp>

int main ()
{
    boost::timer::cpu_timer timer; // 時間計測を開始

    for (long i = 0; i < 100000000; ++i) {
        std::sqrt(123.456L); // 時間のかかる処理
    }

    std::string result = timer.format(); // 結果文字列を取得する
    std::cout << result << std::endl;
}
```
* cpu_timer[color ff0000]

実行結果
```
 5.636670s wall, 5.600436s user + 0.000000s system = 5.600436s CPU (99.4%)
```

実行結果文字列には、以下の値が印字される：

| フォーマット | 分解能 | 説明 |
|--------------|--------|---------------------------------|
| wall         | ナノ秒 | 実際の経過時間(wall clock time) |
| user         | ナノ秒 | ユーザーCPU処理時間 |
| system       | ナノ秒 | システムCPU処理時間 |
| =後          | ナノ秒 | ユーザーCPU処理時間とシステムCPU処理時間の合計時間 |
| %表記        |        | ユーザーCPU処理時間 + システムCPU処理時間の合計時間による、実際の経過時間の%表現 |


## <a name="start-stop-resume" href="#start-stop-resume">開始、停止、再開を制御する</a>
`cpu_timer`の開始、停止、再開を制御するには、それぞれ`start()`、`stop()`、`resume()`メンバ関数を使用する。

```cpp
#include <iostream>
#include <cmath>
#include <boost/timer/timer.hpp>

int main ()
{
    boost::timer::cpu_timer timer;

    timer.start(); // 開始

    for (long i = 0; i < 100000000; ++i) {
        std::sqrt(123.456L); // 時間のかかる処理
    }

    timer.stop(); // 停止

    // 中間結果を出力
    {
        std::string result = timer.format();
        std::cout << result << std::endl;
    }

    timer.resume(); // 再開

    for (long i = 0; i < 100000000; ++i) {
        std::sqrt(123.456L); // 時間のかかる処理
    }

    // 最終結果を出力
    {
        std::string result = timer.format();
        std::cout << result << std::endl;
    }
}
```
* start[color ff0000]
* stop[color ff0000]
* resume[color ff0000]

実行例
```cpp
 5.942355s wall, 5.569236s user + 0.000000s system = 5.569236s CPU (93.7%)

 11.981387s wall, 11.247672s user + 0.000000s system = 11.247672s CPU (93.9%)
```


## <a name="elapsed-values" href="#elapsed-values">処理時間の値を個別に取得する</a>
処理時間の値を個別に取得するには、`elapsed()`メンバ関数を使用する。

```cpp
#include <iostream>
#include <cmath>
#include <boost/timer/timer.hpp>

int main ()
{
    boost::timer::cpu_timer timer;

    for (long i = 0; i < 100000000; ++i) {
        std::sqrt(123.456L); // 時間のかかる処理
    }

    boost::timer::cpu_times elapsed = timer.elapsed();

    std::cout << "wall : " << elapsed.wall << std::endl;
    std::cout << "user : " << elapsed.user << std::endl;
    std::cout << "system : " << elapsed.system << std::endl;
}
```
* elapsed[color ff0000]

実行例：
```
wall : 5622194896
user : 5553635600
system : 0
```

`elapsed()`メンバ関数は、`boost::timer::cpu_times`クラスのオブジェクトを返す。

`boost::timer::cpu_times`クラスは以下の`public`メンバ変数を持つ：

| 変数名 | 型 | 説明 |
|--------|------------------------------|-------------------------|
| wall   | `boost::timer::nanosecond_type` | 実際の経過時間(wall clock time) |
| user   | `boost::timer::nanosecond_type` | ユーザーCPU処理時間 |
| system | `boost::timer::nanosecond_type` | システムCPU処理時間 |

これらのメンバ変数は、ナノ秒分解能を表現する整数型である。


## <a name="customize-format" href="#customize-format">出力結果のフォーマットをカスタマイズする</a>
`cpu_timer::format()`メンバ関数は、デフォルトでは以下のようなフォーマットで印字される。

```cpp
 5.636670s wall, 5.600436s user + 0.000000s system = 5.600436s CPU (99.4%)
```

`format()`メンバ関数に以下のように指定することでフォーマットをカスタマイズできる。

```cpp
#include <iostream>
#include <cmath>
#include <boost/timer/timer.hpp>

int main ()
{
    boost::timer::cpu_timer timer;

    for (long i = 0; i < 100000000; ++i) {
        std::sqrt(123.456L); // 時間のかかる処理
    }

    std::string result = timer.format(9, "経過時間：%w秒\n"
                                         "ユーザーCPU処理時間：%u秒\n"
                                         "プロセスCPU処理時間：%s秒");
    std::cout << result << std::endl;
}
```

実行例
```
経過時間：5.985288294秒
ユーザーCPU処理時間：5.647236200秒
プロセスCPU処理時間：0.000000000秒
```

`format()`メンバ関数の第1引数には、出力される浮動小数点数値の精度を指定する。

デフォルトでは6であり、1～9の範囲で指定することができる(範囲外の場合は丸められる)。

第2引数の文字列フォーマットには、以下の置換シーケンスを指定することができる：

| シーケンス | 置き換えられる値 |
|------|----------------------------------------------|
| `%w` | 実際の経過時間(wall clock time) |
| `%u` | ユーザーCPU処理時間 |
| `%s` | システムCPU処理時間 |
| `%t` | ユーザーCPU処理時間 + システムCPU処理時間 |
| `%p` | ユーザーCPU処理時間 + システムCPU処理時間の合計時間による、実際の経過時間の%表現 |


