#スレッド
Boost.Threadは複数の実行スレッドとそれに伴う共有データを、C++のポータブルなコードで扱えるようにするライブラリである。

Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>スレッドを生成(開始)する](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>引数付きでスレッドを生成(開始)する](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>[応用]オブジェクトのメンバ関数でスレッドを生成(開始)する](#TOC--2)</li><li class='goog-toc'>[<strong>4 </strong>スレッドの所有権を移動する](#TOC--3)</li><li class='goog-toc'>[<strong>5 </strong>スレッドを破棄(終了)する](#TOC--4)</li><li class='goog-toc'>[<strong>6 </strong>スレッドを手放す](#TOC--5)</li><li class='goog-toc'>[<strong>7 </strong>他スレッドの終了を待機する](#TOC--6)</li><li class='goog-toc'>[<strong>8 </strong>スレッドを中断する](#TOC--7)</li><li class='goog-toc'>[<strong>9 </strong>自スレッドを一時停止(休眠)する](#TOC--8)</li><li class='goog-toc'>[<strong>10 </strong>自スレッドの実行を他スレッドに譲る](#TOC--9)</li><li class='goog-toc'>[<strong>11 </strong>スレッドのハンドルを取得する](#TOC--10)</li><li class='goog-toc'>[<strong>12 </strong>ハードウェアの並列度を取得する](#TOC--11)</li></ol>


<h4>スレッドを生成(開始)する</h4>
boost::threadを用いて新しいスレッドを作成するには、threadクラスに関数や関数オブジェクトを渡してthreadオブジェクトを構築する。新しいスレッド上では、コンストラクタに指定した関数(または関数オブジェクト)が呼び出される。
(何も渡さずに構築すると、どのスレッドでもない状態(Not-A-Thread)を表すthreadオブジェクトになる。)
```cpp
template<typename Callable>
boost::thread(Callable func);
```

コンストラクタに渡された実引数は、threadオブジェクト内部にコピーされて保持される。このコピーを避ける場合はboost::refを利用する。
```cpp
void f1() {
    callable x;
    boost::thread(boost::ref(x));
}

<h4>引数付きでスレッドを生成(開始)する</h4>新しいスレッド上で引数をとる関数や関数オブジェクトを呼び出す場合は、コンストラクタにスレッドで呼び出す関数に続いて実引数を渡すことで、引数付きの新しいスレッドを作成することが出来る。
```cpp
template <class F, class A1, class A2,...>
thread(F f, A1 a1, A2 a2,...);

(これはthread(boost::bind(f, a1, s2...))のように動作する。引数無しスレッド作成の時と同じように、実引数のコピーを避けたい場合はboost::refを利用する。)<h4>[応用]オブジェクトのメンバ関数でスレッドを生成(開始)する</h4>新しいスレッド上でクラスオブジェクトのメンバ関数を呼び出す場合、コンストラクタの第1引数にメンバ関数ポインタを、第2引数にクラスオブジェクトのポインタを指定する。(引数付きスレッドの応用例となっている。)
```cpp
class X {public:  void func();};void f(){  X obj;  boost::thread th(&X::func, &<span style='color:rgb(0,0,0)'>obj);  // </span><span style='color:rgb(0,0,0)'>objのX::funcメンバ関数を呼び出す}</span>

作成されたスレッドでの処理期間と、スレッドに渡したオブジェクトの生存期間に注意すること。別スレッド処理中にオブジェクト生存期間が終了してデストラクトされた場合、未定義の動作を引き起こしてしまう。

<h4>スレッドの所有権を移動する</h4>boost::threadは、1つのthreadオブジェクトが1つのスレッドあるいはNot-A-Threadを表しているのでCopyableではないが、Movableである。
(コンパイラが右辺値参照をサポートしていればC++11のムーブを、そうでなければエミュレーションによってムーブの機能を提供する。)

ムーブコンストラクタとムーブ代入演算子をサポートしているので、ムーブによってスレッドの所有権を移動できる。
```cpp
void f2() {
    boost::thread th1(some_func_addr);
    boost::thread th2;

    th2 = move(th1);                 //th1のスレッドをth2にムーブ
    boost::thread th3(move(th2));    //th2のスレッドをth3にムーブ
}
```

あるいはboost::thread::swapによって2つのthreadオブジェクトを交換することも出来る。

<h4>スレッドを破棄(終了)する</h4>作成されたスレッドは、通常その関数や関数オブジェクトの呼び出しが完了するか、プログラムが終了するまで実行を継続する。
threadオブジェクトが破棄(デストラクト)されるときには、単にそれが表すスレッドをdetachするだけであり、
detachされたスレッドが、threadオブジェクトの破棄に伴って即座に破棄されるわけではない。

(boost::thread::joinメンバ関数を使用することで、スレッドの終了を待機することが出来る。)
(boost:thread::interruptメンバ関数を使用することで、スレッドを中断することが出来る。)

<h4>スレッドを手放す</h4>boost::thread::detachメンバ関数を使用することで、threadオブジェクトが表しているスレッドをthreadオブジェクトから手放すことが出来る。(boost::thread::detachメンバ関数呼び出しはthreadオブジェクトとスレッドの対応付けを解除するだけであり、この操作によって実行中のスレッド処理が中断することはない。)

<h4>他スレッドの終了を待機する</h4>boost::thread::joinメンバ関数を使用することで、そのthreadオブジェクトが表しているスレッドの終了を待機することが出来る。
boost::thread::timed_joinメンバ関数を使用することで、指定した時間(あるいは時刻まで)スレッドの終了を待機することが出来る。
戻り値は指定した時間(あるいは時刻)がタイムアウトするまでにスレッドの実行が完了したかどうかをbool値で返す。
```cpp
void f3() {
    using namespace boost::posix_time;
    boost::thread th(func);
    time_duration const td = seconds(3);
    bool const has_completed = th.timed_join(td);
}
```

<h4>スレッドを中断する</h4>実行中のスレッドに対して他スレッドから処理中断させる場合、下記2通りの実装方法が考えられる。
<ol>
- Boost.Thread提供の中断機構を利用する。
- スレッド上の処理コードに中断機構を組み込む。</ol>
一般的に任意タイミングで対象スレッドの処理を中断することはできない。他スレッドから中断要求があった場合はそれを記録しておき、対象スレッドでの実行が中断ポイント可能ポイントに到達したとき、スレッド自身が中断要求を検知して後続処理フローを変更することで達成される。以下では、方式1について説明する。Boost.Threadが提供するスレッド中断機構では、interruptにより中断通知を受けたスレッドが待機処理または明示的チェックを行うとき、初めて中断通知を受け取る(thread_interrupted例外送出)という方式で実現される。boost::thread::interruptメンバ関数を使用することで、対象スレッドの実行が次回のinterruption_pointに達したときに
boost::thread_interrupted例外が投げられ、これをうけてスレッド処理を中断することが出来る。予め定義されているintrruption_pointは次のとおり

- boost::thread::join()
- boost::thread::timed_join()
- boost::condition_variable::wait()
- boost::condition_variable::timed_wait()
- boost::condition_variable_any::wait()
- boost::condition_variable_any::timed_wait()
- boost::thread::sleep()
- boost::this_thread::sleep()
- boost::this_thread::interruption_point()
なおboost::thread::disable_interruptionクラスによって、上記操作でのinterruptionを一時的に無効化することが出来る。

<h4>自スレッドを一時停止(休眠)する</h4>boost::thread::sleep staticメンバ関数を使用することで、sleepを呼び出した現在のスレッドを指定時刻まで、あるいは指定時間だけ一時停止(休眠)することが出来る。
boost::this_thread名前空間にある同名のFree関数を使用して、同様に指定時刻まで、あるいは指定時間だけスレッドを一時停止(休眠)することも出来る。

<h4>自スレッドの実行を他スレッドに譲る</h4>boost::thread::yield staticメンバ関数を使用することで、OSスケジューラから自スレッドに割り当てられたタイムスライスの残りを手放して、他の実行スレッドに処理を譲ることができる。
boost::this_thread名前空間にある同名のFree関数も同様である。

<h4>スレッドのハンドルを取得する</h4>boost::thread::native_handleメンバ関数を使用することで、スレッドからそのプラットフォーム固有のhandleを取得することが出来る。
```cpp
void f4() {
    boost::thread th(some_func_addr);
    HANDLE hThread = th.native_handle();
    ::SetThreadPriority(hThread, THREAD_PRIORITY_HIGHEST);
}
```

<h4>ハードウェアの並列度を取得する</h4>boost::thread::hardware_concurrency staticメンバ関数を使用することで、(たとえばCPUの数やコアの数やhyperthreading unitの数などから)現在のシステムで利用可能なhardware threadの数を取得することが出来る。


