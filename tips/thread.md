# スレッド
スレッドを扱うには、[Boost Thread Library](http://www.boost.org/doc/libs/release/doc/html/thread.html)を使用する。このライブラリは、複数の実行スレッドとそれに伴う共有データを、C++のポータブルなコードで扱えるようにするライブラリである。


## インデックス
- [スレッドを生成(開始)する](#create-thread)
- [引数付きでスレッドを生成(開始)する](#create-thread-with-argument)
- [[応用]オブジェクトのメンバ関数でスレッドを生成(開始)する](#create-thread-member-function)
- [スレッドの所有権を移動する](#move-ownership)
- [スレッドを破棄(終了)する](#terminate)
- [スレッドを手放す](#detach)
- [他スレッドの終了を待機する](#join)
- [スレッドを中断する](#interrupt)
- [自スレッドを一時停止(休眠)する](#sleep)
- [自スレッドの実行を他スレッドに譲る](#yield)
- [スレッドのハンドルを取得する](#thread-handle)
- [ハードウェアの並列度を取得する](#hardware-concurrency)
- [C++の国際標準規格上の類似する機能](#cpp-standard)


## <a id="create-thread" href="#create-thread">スレッドを生成(開始)する</a>
Boost.Threadを用いて新しいスレッドを作成するには、`thread`クラスに関数や関数オブジェクトを渡して`thread`オブジェクトを構築する。新しいスレッド上では、コンストラクタに指定した関数(または関数オブジェクト)が呼び出される。

(何も渡さずに構築すると、どのスレッドでもない状態(Not-A-Thread)を表す`thread`オブジェクトになる。)

```cpp
template <class Callable>
boost::thread(Callable func);
```

コンストラクタに渡された実引数は、`thread`オブジェクト内部にコピーされて保持される。このコピーを避ける場合は`boost::ref()`関数を利用する。

```cpp
callable x;
void f1() {
    boost::thread(boost::ref(x));
}
```


<a id="create-thread-with-argument" href="#create-thread-with-argument">引数付きでスレッドを生成(開始)する</a>
新しいスレッド上で引数をとる関数や関数オブジェクトを呼び出す場合は、コンストラクタにスレッドで呼び出す関数に続いて実引数を渡すことで、引数付きの新しいスレッドを作成することが出来る。

```cpp
template <class F, class A1, class A2,...>
thread(F f, A1 a1, A2 a2,...);
```

(これは`thread(boost::bind(f, a1, s2...))`のように動作する。引数無しスレッド作成の時と同じように、実引数のコピーを避けたい場合は`boost::ref()`関数を利用する。)


## <a id="create-thread-member-function" href="#create-thread-member-function">[応用]オブジェクトのメンバ関数でスレッドを生成(開始)する</a>
新しいスレッド上でクラスオブジェクトのメンバ関数を呼び出す場合、コンストラクタの第1引数にメンバ関数ポインタを、第2引数にクラスオブジェクトのポインタを指定する。(引数付きスレッドの応用例となっている。)

```cpp
class X {
public:
    void func();
};

void f()
{
    X obj;
    boost::thread th(&X::func, &obj);  // objのX::funcメンバ関数を呼び出す
}
```

作成されたスレッドでの処理期間と、スレッドに渡したオブジェクトの生存期間に注意すること。別スレッド処理中にオブジェクト生存期間が終了してデストラクトされた場合、未定義の動作を引き起こしてしまう。


## <a id="move-ownership" href="#move-ownership">スレッドの所有権を移動する</a>
Boost.Thradでは、1つの`thread`オブジェクトが1つのスレッドあるいはNot-A-Threadを表しているので`thread`オブジェクトのコピーはできないが、ムーブは可能である。

(コンパイラが右辺値参照をサポートしていればC++11のムーブを、そうでなければエミュレーションによってムーブの機能を提供する。)

`thread`クラスはムーブコンストラクタとムーブ代入演算子をサポートしているので、ムーブによってスレッドの所有権を移動できる。

```cpp
void f2() {
    boost::thread th1(some_func_addr);
    boost::thread th2;

    th2 = move(th1);                 // th1のスレッドをth2にムーブ
    boost::thread th3(move(th2));    // th2のスレッドをth3にムーブ
}
```

あるいは`boost::thread::swap()`関数によって2つの`thread`オブジェクトを交換することも出来る。


## <a id="terminate" href="#terminate">スレッドを破棄(終了)する</a>
作成されたスレッドは、通常その関数や関数オブジェクトの呼び出しが完了するか、プログラムが終了するまで実行を継続する。

`thread`オブジェクトが破棄(デストラクト)されるときには、単にそれが表すスレッドを`detach()`するだけであり、`detach()`されたスレッドが、`thread`オブジェクトの破棄に伴って即座に破棄されるわけではない。

(`boost::thread::join()`メンバ関数を使用することで、スレッドの終了を待機することが出来る。)
(`boost::thread::interrupt()`メンバ関数を使用することで、スレッドを中断することが出来る。)


## <a id="detach" href="#detach">スレッドを手放す</a>
`boost::thread::detach()`メンバ関数を使用することで、`thread`オブジェクトが表しているスレッドを`thread`オブジェクトから手放すことが出来る。(`boost::thread::detach`メンバ関数呼び出しは`thread`オブジェクトとスレッドの対応付けを解除するだけであり、この操作によって実行中のスレッド処理が中断することはない。)


## <a id="join" href="#join">他スレッドの終了を待機する</a>
`boost::thread::join()`メンバ関数を使用することで、その`thread`オブジェクトが表しているスレッドの終了を待機することが出来る。

`boost::thread::timed_join()`メンバ関数を使用することで、指定した時間(あるいは時刻まで)スレッドの終了を待機することが出来る。

これらの関数の戻り値は、指定した時間(あるいは時刻)がタイムアウトするまでにスレッドの実行が完了したかどうかを`bool`値で返す。

```cpp
void f3() {
    using namespace boost::posix_time;
    boost::thread th(func);
    time_duration const td = seconds(3);
    bool const has_completed = th.timed_join(td);
}
```


## <a id="interrupt" href="#interrupt">スレッドを中断する</a>
実行中のスレッドに対して他スレッドから処理中断させる場合、下記2通りの実装方法が考えられる。

1. Boost.Threadが提供している中断機構を利用する。
2. スレッド上の処理コードに中断機構を組み込む。

一般的に任意タイミングで対象スレッドの処理を中断することはできない。他スレッドから中断要求があった場合はそれを記録しておき、対象スレッドでの実行が中断ポイント可能ポイントに到達したとき、スレッド自身が中断要求を検知して後続処理フローを変更することで達成される。

以下では、方式1について説明する。Boost.Threadが提供するスレッド中断機構では、interruptにより中断通知を受けたスレッドが待機処理または明示的チェックを行うとき、初めて中断通知を受け取る(thread_interrupted例外送出)という方式で実現される。

`boost::thread::interrupt()`メンバ関数を使用することで、対象スレッドの実行が次回の`interruption_point`に達したときに`boost::thread_interrupted`例外が投げられ、これをうけてスレッド処理を中断することが出来る。あらかじめ定義されている`intrruption_point`は次のとおり：

- `boost::thread::join()`
- `boost::thread::timed_join()`
- `boost::condition_variable::wait()`
- `boost::condition_variable::timed_wait()`
- `boost::condition_variable_any::wait()`
- `boost::condition_variable_any::timed_wait()`
- `boost::thread::sleep()`
- `boost::this_thread::sleep()`
- `boost::this_thread::interruption_point()`

なお`boost::thread::disable_interruption`クラスによって、上記操作での`interruption`を一時的に無効化することが出来る。


## <a id="sleep" href="#sleep">自スレッドを一時停止(休眠)する</a>
`boost::thread::sleep()`静的メンバ関数を使用することで、この関数を呼び出した現在のスレッドを指定時刻まで、あるいは指定時間だけ一時停止(休眠)することが出来る。

`boost::this_thread`名前空間にある同名の非メンバ関数を使用して、同様に指定時刻まで、あるいは指定時間だけスレッドを一時停止(休眠)することも出来る。


## <a id="yield" href="#yield">自スレッドの実行を他スレッドに譲る</a>
`boost::thread::yield()`静的メンバ関数を使用することで、OSスケジューラから自スレッドに割り当てられたタイムスライスの残りを手放して、他の実行スレッドに処理を譲ることができる。

`boost::this_thread`名前空間にある同名の非メンバ関数も同様である。


## <a id="thread-handle" href="#thread-handle">スレッドのハンドルを取得する</a>
`boost::thread::native_handle`メンバ関数を使用することで、スレッドからそのプラットフォーム固有のhandleを取得することが出来る。

```cpp
void f4() {
    boost::thread th(some_func_addr);
    HANDLE hThread = th.native_handle();
    ::SetThreadPriority(hThread, THREAD_PRIORITY_HIGHEST);
}
```


## <a id="hardware-concurrency" href="#hardware-concurrency">ハードウェアの並列度を取得する</a>
`boost::thread::hardware_concurrency()`静的メンバ関数を使用することで、(たとえばCPUの数やコアの数やhyperthreading unitの数などから)現在のシステムで利用可能なhardware threadの数を取得することが出来る。


## <a id="cpp-standard" href="#cpp-standard">C++の国際標準規格上の類似する機能</a>
- [`std::thread`](https://cpprefjp.github.io/reference/thread/thread.html)
