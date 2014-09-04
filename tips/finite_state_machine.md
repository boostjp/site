#有限状態マシン
有限状態マシン(finite state machine)を扱うライブラリとしてBoost.statechartとBoost.msmのふたつが存在する。

ここではBoost.msmの利用方法を紹介する。


Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>有限状態マシンの定義と利用](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>状態の開始と終了のタイミングで任意の処理を行う](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>イベントを受け取ったタイミングで任意の処理を行う](#TOC--2)</li><li class='goog-toc'>[<strong>4 </strong>状態遷移を拒否する](#TOC--3)</li></ol>


<h4>有限状態マシンの定義と利用</h4>

　有限状態マシンを利用するために、状態・イベント・有限状態マシンをそれぞれ定義する必要がある。

状態遷移は有限状態マシンの中にテーブル状にして記述する。








#include <boost/msm/front/state_machine_def.hpp>

`#include <boost/msm/back/state_machine.hpp>`


<code>
</code>

`using namespace boost::msm::front;`



// 状態の定義

`struct my_state1 : <color=ff0000>state</color><> ``{`};

`struct my_state2 : <color=ff0000>state</color><> ``{`};

`struct my_state3 : <color=ff0000>state</color><> ``{`};



// イベントの定義

`struct my_event1 {};`

`struct my_event2 {};`



// 有限状態マシンの定義

`struct my_machine_ : <color=ff0000>state_machine_def</color>< my_machine_ >`

`{`

`    // 状態遷移テーブル`

`    struct transition_table : boost::mpl::vector`

`        //       ``source  |   event  |  target`

`        < <color=ff0000>_row</color>< my_state1, my_event1, my_state2 >`

`        , <color=ff0000>_row</color>< my_state2, my_event1, my_state1 >`

`        , <color=ff0000>_row</color>< my_state2, my_event2, my_state3 >`

`        > {};`

    

    // 初期状態

`    typedef my_state1 <color=ff0000>initial_state</color>;`

`};`



`typedef boost::msm::<color=ff0000>back::state_machine</color>< my_machine_ > my_machine;`



`int main()`

`{`

`    my_machine m;`

`    m.<color=ff0000>start</color>();                       // my_state1`

`    m.<color=ff0000>process_event</color>( my_event1() );  // my_state1 -> my_state2`

`    m.<color=ff0000>process_event</color>( my_event2() );  // my_state2 -> my_state3`

`}`






<h4>状態の開始と終了のタイミングで任意の処理を行う</h4>状態クラスに on_entry, on_exit メンバ関数を定義すると、それぞれ状態の開始と終了時に呼ばれる。  ```cpp
<code style='color:rgb(0,0,0)'>#include <iostream><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>#include <boost/msm/front/state_machine_def.hpp><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>#include <boost/msm/back/state_machine.hpp><br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>using namespace boost::msm::front;<br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>struct my_state1 : state<><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>{<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    // my_state1 状態が終わるときに呼ばれる。<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    <code style='color:rgb(0,0,0)'> template < class event_t, class fsm_t ><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    <code style='color:rgb(0,0,0)'>void on_exit( event_t const & e, fsm_t & machine )<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    <code style='color:rgb(0,0,0)'>{<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>   <code style='color:rgb(0,0,0)'>    <code style='color:rgb(0,0,0)'> <code style='color:rgb(0,0,0)'>std::cout << "exit: my_state1" << std::endl;<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    <code style='color:rgb(0,0,0)'>}<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>}; <br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>struct my_state2 : state<><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>{<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    <code style='color:rgb(0,0,0)'> // my_state2 状態が始まるときに呼ばれる。<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    <code style='color:rgb(0,0,0)'> template < class event_t, class fsm_t ><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    void <span style='color:rgb(255,0,0)'>on_entry( event_t const & e, fsm_t & machine )</span><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    <code style='color:rgb(0,0,0)'>{<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    <code style='color:rgb(0,0,0)'>    <code style='color:rgb(0,0,0)'>std::cout << "entry: my_state2" << std::endl;<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    <code style='color:rgb(0,0,0)'>}<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>};<br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>struct my_event1 {};<br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>struct my_machine_ : state_machine_def< my_machine_ ><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>{<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    <code style='color:rgb(0,0,0)'> struct transition_table : boost::mpl::vector<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    <code style='color:rgb(0,0,0)'> < _row< my_state1, my_event1, my_state2 > > {};<br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    <code style='color:rgb(0,0,0)'> typedef my_state1 initial_state;  <br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>};<br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>typedef boost::msm::back::state_machine< my_machine_ > my_machine;  <br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>int main()<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>{<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    <code style='color:rgb(0,0,0)'>my_machine m; <br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    <code style='color:rgb(0,0,0)'>m.start();                      // my_state1 <br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    <code style='color:rgb(0,0,0)'>m.process_event( my_event1() ); // my_state1 -> my_state2 <br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>} 
 実行結果：


exit: my_state1

entry: my_state2
```

<h4>イベントを受け取ったタイミングで任意の処理を行う</h4>
有限状態マシンがイベントを受け取ったとき、任意の処理を行うことができる。

状態遷移テーブルには _row のかわりに a_row を使う。 <code style='color:rgb(0,0,0)'>#include <iostream></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>#include <boost/msm/front/state_machine_def.hpp></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>#include <boost/msm/back/state_machine.hpp></code><br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>using namespace boost::msm::front;</code><br style='color:rgb(0,0,0)'/> <br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>struct my_state1 : state<> {};</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>struct my_state2 : state<> {};</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>struct my_state3 : state<> {};</code><br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>struct my_event1 {};</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>struct my_event2 {};</code><br style='color:rgb(0,0,0)'/> <br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>struct my_machine_ : state_machine_def< my_machine_ ></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>{</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>void on_event1( my_event1 const & ev ) { std::cout << "on_event1" << std::endl; }</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>void on_event2( my_event2 const & ev ) { std::cout << "on_event2" << std::endl; }</code><br style='color:rgb(0,0,0)'/> <br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>// 状態遷移テーブル </code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>struct transition_table : boost::mpl::vector </code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>   </code><code style='color:rgb(0,0,0)'>     </code><code style='color:rgb(0,0,0)'> </code><code style='color:rgb(0,0,0)'>// source | event | target | action </code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>   </code><code style='color:rgb(0,0,0)'>     </code><code style='color:rgb(0,0,0)'> </code><code style='color:rgb(0,0,0)'>< a_row< my_state1, my_event1, my_state2, & my_machine_::on_event1 > </code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>   </code><code style='color:rgb(0,0,0)'>     </code><code style='color:rgb(0,0,0)'> </code><code style='color:rgb(0,0,0)'>,  _row< my_state2, my_event1, my_state1                           > </code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>, a_row< my_state2, my_event2, my_state3, & my_machine_::on_event2 > </code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>> {}; </code><br style='color:rgb(0,0,0)'/> <br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>typedef my_state1 initial_state; </code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>}; </code><br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/> <br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>typedef boost::msm::back::state_machine< my_machine_ > my_machine; </code><br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/> <br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>int main() </code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>{ </code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>my_machine m; </code><br style='color:rgb(0,0,0)'/> <code style='color:rgb(0,0,0)'>    </code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>m.start();                      // my_state1 </code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>m.process_event( my_event1() ); // my_state1 -> my_state2 ( on_event1 ) </code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>m.process_event( my_event2() ); // my_state2 -> my_state3 ( on_event2 ) </code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>} </code>
実行結果：



`on_event1`

`on_event2`




<h4>状態遷移を拒否する</h4>

有限状態マシンがイベントを受け取ったとき、実行時に状態遷移を拒否することができる。

状態遷移テーブルには _row のかわりに g_row を使う。


g_row に指定したメンバ関数が false を返すとき、状態遷移は拒否される。  <code style='color:rgb(0,0,0)'>#include <iostream></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>#include <boost/msm/front/state_machine_def.hpp></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>#include <boost/msm/back/state_machine.hpp></code><br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>using namespace boost::msm::front;</code><br style='color:rgb(0,0,0)'/> <br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>// 状態の定義</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>struct my_state1 : state<> {};</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>struct my_state2 : state<></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>{</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>template < class event_t, class fsm_t ></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>void on_entry( event_t const & e, fsm_t & machine )</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>{</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>        std::cout << "entry: my_state2" << std::endl;</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>}</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>};</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>struct my_state3 : state<></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>{</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>template < class event_t, class fsm_t ></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>void on_entry( event_t const & e, fsm_t & machine )</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>{</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>        std::cout << "entry: my_state3" << std::endl;</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>}</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>};</code><br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>struct my_event1 {};</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>struct my_event2 {};</code><br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>struct my_machine_ : state_machine_def< my_machine_ ></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>{</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>bool guard_1( my_event1 const & ev ) { return true; }</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>bool guard_2( my_event2 const & ev ) { return false; }</code><br style='color:rgb(0,0,0)'/>     <code style='color:rgb(0,0,0)'>    </code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>    // 状態遷移テーブル</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>struct transition_table : boost::mpl::vector</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>//        source  |   event  |  target  |   guard</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>< g_row< my_state1, my_event1, my_state2, & my_machine_::guard_1 ></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>,   _row< my_state2, my_event1, my_state1                                                 ></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>, g_row< my_state2, my_event2, my_state3, & my_machine_::guard_2 ></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>> {};</code><br style='color:rgb(0,0,0)'/>     <code style='color:rgb(0,0,0)'>    </code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>    typedef my_state1 initial_state;</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>};</code><br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>typedef boost::msm::back::state_machine< my_machine_ > my_machine;</code><br style='color:rgb(0,0,0)'/> <br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>int main()</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>{</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>my_machine m;</code><br style='color:rgb(0,0,0)'/> <code style='color:rgb(0,0,0)'>    </code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>    m.start();</code><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>      </code><code style='color:rgb(0,0,0)'>// my_state1</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>m.process_event( my_event1() );  // my_state1 -> my_state2</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    </code><code style='color:rgb(0,0,0)'>m.process_event( my_event2() );  // 拒否。</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>}</code><br style='color:rgb(0,0,0)'/> 
<br style='color:rgb(0,0,0)'/> 実行結果：

```cpp
entry: my_state2
```
