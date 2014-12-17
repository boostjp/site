#有限状態マシン
有限状態マシン(finite state machine)を扱うライブラリとしてBoost.StatechartとBoost.MSM (Meta State Machine)のふたつが存在する。

ここではBoost.MSMの利用方法を紹介する。


##インデックス
- [有限状態マシンの定義と利用](#define-state-machine)
- [状態の開始と終了のタイミングで任意の処理を行う](#state-event)
- [状態遷移イベントを受け取ったタイミングで任意の処理を行う](#change-state-event)
- [状態遷移を拒否する](#guard)


## <a name="define-state-machine">有限状態マシンの定義と利用</a>

有限状態マシンを利用するために、状態・イベント・有限状態マシンをそれぞれ定義する必要がある。

状態遷移は有限状態マシンの中にテーブル状にして記述する。


```cpp
#include <boost/msm/front/state_machine_def.hpp>
#include <boost/msm/back/state_machine.hpp>

using namespace boost::msm::front;

// 状態の定義
struct my_state1 : state<> {};
struct my_state2 : state<> {};
struct my_state3 : state<> {};

// イベントの定義
struct my_event1 {};
struct my_event2 {};

// 有限状態マシンの定義
struct my_machine_ : state_machine_def< my_machine_ >
{
    // 状態遷移テーブル
    struct transition_table : boost::mpl::vector
        //       source  |   event  |  target
        < _row< my_state1, my_event1, my_state2 >
        , _row< my_state2, my_event1, my_state1 >
        , _row< my_state2, my_event2, my_state3 >
        > {};
    
    // 初期状態
    typedef my_state1 initial_state;
};

typedef boost::msm::back::state_machine< my_machine_ > my_machine;

int main()
{
    my_machine m;
    m.start();                       // my_state1
    m.process_event( my_event1() );  // my_state1 -> my_state2
    m.process_event( my_event2() );  // my_state2 -> my_state3
}
```
* state<>[color ff0000]
* state_machine_def[color ff0000]
* _row[color ff0000]
* initial_state[color ff0000]
* back::state_machine[color ff0000]
* start[color ff0000]
* process_event[color ff0000]


## <a name="state-event" href="#state-event">状態の開始と終了のタイミングで任意の処理を行う</a>

状態クラスに `on_entry()`, `on_exit()` メンバ関数を定義すると、それぞれ状態の開始と終了時に、自動的に呼ばれる。

```cpp
#include <iostream>
#include <boost/msm/front/state_machine_def.hpp>
#include <boost/msm/back/state_machine.hpp>

using namespace boost::msm::front;

struct my_state1 : state<>
{
    // my_state1 状態が終わるときに呼ばれる。
    template < class event_t, class fsm_t >
    void on_exit( event_t const & e, fsm_t & machine )
    {
       std::cout << "exit: my_state1" << std::endl;
    }
}; 

struct my_state2 : state<>
{
    // my_state2 状態が始まるときに呼ばれる。
    template < class event_t, class fsm_t >
    void on_entry( event_t const & e, fsm_t & machine )
    {
        std::cout << "entry: my_state2" << std::endl;
    }
};

struct my_event1 {};

struct my_machine_ : state_machine_def< my_machine_ >
{
    struct transition_table : boost::mpl::vector
    < _row< my_state1, my_event1, my_state2 > > {};

    typedef my_state1 initial_state; 
};


typedef boost::msm::back::state_machine< my_machine_ > my_machine; 


int main()
{
    my_machine m; 
    m.start();                      // my_state1 
    m.process_event( my_event1() ); // my_state1 -> my_state2 
}
```
* on_exit[color ff0000]
* on_entry[color ff0000]

実行結果：

```
exit: my_state1
entry: my_state2
```


## <a name="change-state-event" href="#change-state-event">状態遷移イベントを受け取ったタイミングで任意の処理を行う</a>

有限状態マシンがイベントを受け取ったとき、任意の処理を実行できる。

状態遷移テーブルには `_row` のかわりに `a_row` を使う。

```cpp
#include <iostream>
#include <boost/msm/front/state_machine_def.hpp>
#include <boost/msm/back/state_machine.hpp>

using namespace boost::msm::front;

struct my_state1 : state<> {};
struct my_state2 : state<> {};
struct my_state3 : state<> {};

struct my_event1 {};
struct my_event2 {};

struct my_machine_ : state_machine_def< my_machine_ >
{
    void on_event1( my_event1 const & ev ) { std::cout << "on_event1" << std::endl; }
    void on_event2( my_event2 const & ev ) { std::cout << "on_event2" << std::endl; }

    // 状態遷移テーブル 
    struct transition_table : boost::mpl::vector 
        // source | event | target | action 
        < a_row< my_state1, my_event1, my_state2, &my_machine_::on_event1 > 
        ,  _row< my_state2, my_event1, my_state1                          > 
        , a_row< my_state2, my_event2, my_state3, &my_machine_::on_event2 > 
        > {}; 

    typedef my_state1 initial_state; 
}; 


typedef boost::msm::back::state_machine< my_machine_ > my_machine; 


int main() 
{ 
    my_machine m; 
    
    m.start();                      // my_state1 
    m.process_event( my_event1() ); // my_state1 -> my_state2 ( on_event1 ) 
    m.process_event( my_event2() ); // my_state2 -> my_state3 ( on_event2 ) 
}
```
* on_event1[color ff0000]
* on_event2[color ff0000]
* a_row[color ff0000]
* &my_machine_::on_event1[color ff0000]
* &my_machine_::on_event2[color ff0000]


実行結果：

```
on_event1
on_event2
```

## <a name="guard" href="#guard">状態遷移を拒否する</a>

有限状態マシンがイベントを受け取ったとき、実行時に状態遷移を拒否することができる。

状態遷移テーブルには `_row` の代わりに `g_row` を使う。

`g_row` に指定したメンバ関数が `false` を返すとき、状態遷移は拒否される。

```cpp
#include <iostream>
#include <boost/msm/front/state_machine_def.hpp>
#include <boost/msm/back/state_machine.hpp>

using namespace boost::msm::front;

// 状態の定義
struct my_state1 : state<> {};
struct my_state2 : state<>
{
    template < class event_t, class fsm_t >
    void on_entry( event_t const & e, fsm_t & machine )
    {
        std::cout << "entry: my_state2" << std::endl;
    }
};
struct my_state3 : state<>
{
    template < class event_t, class fsm_t >
    void on_entry( event_t const & e, fsm_t & machine )
    {
        std::cout << "entry: my_state3" << std::endl;
    }
};

struct my_event1 {};
struct my_event2 {};

struct my_machine_ : state_machine_def< my_machine_ >
{
    bool guard_1( my_event1 const & ev ) { return true; }
    bool guard_2( my_event2 const & ev ) { return false; }
    
    // 状態遷移テーブル
    struct transition_table : boost::mpl::vector
        // source | event | target | guard
        < g_row< my_state1, my_event1, my_state2, &my_machine_::guard_1 >
        ,  _row< my_state2, my_event1, my_state1                        >
        , g_row< my_state2, my_event2, my_state3, &my_machine_::guard_2 >
        > {};
    
    typedef my_state1 initial_state;
};

typedef boost::msm::back::state_machine< my_machine_ > my_machine;

int main()
{
    my_machine m;
    
    m.start();                      // my_state1
    m.process_event( my_event1() ); // my_state1 -> my_state2
    m.process_event( my_event2() ); // 拒否。
}
```
* guard_1[color ff0000]
* guard_2[color ff0000]
* g_row[color ff0000]
* &my_machine_::guard_1[color ff0000]
* &my_machine_::guard_2[color ff0000]

実行結果：

```
entry: my_state2
```

