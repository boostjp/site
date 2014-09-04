#singleton
<span style='font-family:Arial,Verdana,sans-serif;line-height:normal'>

##Motivation
<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>serializationライブラリは、いくつかの静的変数とテーブルが存在し、それが実行時のタイプに関連する情報を格納することに基づいています。 たとえば、exportされた名前とタイプを関連づけるテーブルや、基底クラスと派生クラスとを関連づけるテーブルです。 これらの変数の生成と破棄、そして利用においては、以下に示す問題の考慮が必要です。</p><ul style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>
- いくつかの静的なデータ変数と定数は、他の要素を参照します。初期化の順序は任意ではだめで、適切な順序でなければなりません。
- 多くの静的変数は、明示的に参照されることがなく、特別な予防措置を講じない限り、最適化によって取り除かれてしまいます。
- これらの変数の多くはテンプレートで作られます。そして、それらがインスタンス化されることを確実にする配慮が必要です。
- マルチスレッドシステムでは、これら静的変数に別々のスレッドから並行的にアクセスすることが可能です。これは、予測不可能な振る舞いでレースコンディションを生み出します。<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>このsingletonクラスは上記問題を解決します。</p>

##Features
<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>このsingleton実装は、以下の特徴を持ちます。</p><ul style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>
- あらゆるインスタンスがそれにアクセスが試みられる前に構築されます。
- あらゆるクラステンプレートのインスタンスが、インスタンス化されることを保証します。
- インスタンスが明示的に参照されるかどうかにかかわらず、リリースモードでビルドした際も最適化で消去され宇ことはありません。
- すべてのインスタンスがmain関数が呼び出される前に、プログラム内で参照される際に構築されます。マルチタスクシステムにおいて、あらゆるインスタンスの生成の間、レースコンディションが発生しないことを保証します。この保証をするためにスレッドのロックは必要ありません。
- 上記は、どんなconstインスタンスでも、プログラム全体でスレッドセーフであることを意味します。もう一度言いますが、スレッドのロックは必要ありません。
- mutableなインスタンスが作られ、main関数がマルチスレッドシステムで呼び出されたあとに変更されるならば、レースコンディションが発生する可能性があります。serializationライブラリでは、mutableなsingletonが必要となるわずかな場所において、main関数が呼び出されたあとに、それが変更されないように注意します。より一般的な目的のため、このsingleton上でロックを行うスレッドを簡単に実装することができましたが、serializationライブラリがそれを必要としなかったので、実装しませんでした。<h1 style='font-weight:bold;letter-spacing:-0.018em;font-size:19px;margin-top:0.15em;margin-right:1em;margin-bottom:0.5em'>Class Interface```cpp
<span>`namespace`` boost ``{` 
</span><span>`namespace`` serialization `<span>`{`
</span></span><span style='font-family:monospace;font-size:13px;white-space:pre'><span>
`template`</span> 
</span><span>`class` `singleton` `:` `public`` boost``::``noncopyable`
</span><span style='font-family:monospace;font-size:13px;white-space:pre'>`{`
</span><span>`public`<span>`:`
</span></span>    <span>`static` `const`` T ``&`` get_const_instance`<span>`();`
</span></span>    <span>`static`` T ``&`` get_mutable_instance`<span>`();`
</span></span><span style='font-family:monospace;font-size:13px;white-space:pre'>`};`
</span><span style='font-family:monospace;font-size:13px;white-space:pre'><span>
`}`</span> <span><code>// namespace serialization 
</code></span></span><span>`}` <span>`// namespace boost`
</span></span>
<span style='font-size:13px'><span style='font-family:monospace;white-space:pre'>
</span>```cpp
`static` `const`` T ``&`<span style='white-space:pre'>` get_const_instance``();`
</span>
</span>このタイプのsingletonへのconst参照を返します。</h1>```cpp
`static T & get_mutable_instance();`
このタイプのsingletonへのmutable参照を返します。

##Requirements
<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>singleton<T>として使えるように、型Tはdefault constructibleでなければなりません。</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>それ(T?)は静的変数を持っているかもしれませんが、静的変数を必要としません。</p><pre style='background-color:rgb(247,247,247);border-top-width:1px;border-right-width:1px;border-bottom-width:1px;border-left-width:1px;border-top-style:solid;border-right-style:solid;border-bottom-style:solid;border-left-style:solid;border-top-color:rgb(215,215,215);border-right-color:rgb(215,215,215);border-bottom-color:rgb(215,215,215);border-left-color:rgb(215,215,215);margin-top:1em;margin-right:1.75em;margin-bottom:1em;margin-left:1.75em;padding-top:0.25em;padding-right:0.25em;padding-bottom:0.25em;padding-left:0.25em;overflow-x:auto;overflow-y:auto;font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>It doesn't require static variables -though it may have them.
</pre><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>ライブラリが、singleton<T>の唯一のインスタンスへのすべてのアクセスが、上記静的インターフェースを介して行われるため、Tの一般的なメンバ関数は、機能的には、静的メンバ関数と同等となります。</p>

##Examples

このクラステンプレートには少なくとも2つの異なる使用法があります。 これらは両方ともserializationライブラリで用いられています。 最初の利用方法を、下記のコードを含むextended_type_info.cppから抜粋します。
```cpp
<span>`typedef`` std``::``set ktmap`<span>`;`
</span></span><span style='font-family:monospace;white-space:pre'>`...`
</span><span style='font-family:monospace;white-space:pre'>`void`
</span>`extended_type_info`<span>`::``key_register``(``const` `char` `*``key``)` <span>`{`
</span></span><span style='font-family:monospace;white-space:pre'>    <span>`...`
</span></span>`    result `<span>`=`` singleton``::``get_mutable_instance``().``insert``(``this`<span>`);`
</span></span><span style='font-family:monospace;white-space:pre'>    <span>`...`
</span></span><span style='white-space:pre'>`}`
</span>
プログラムのどこからでもsingletonのインスタンスを参照することで、その型(この例ではktmap)の唯一のインスタンスがプログラムを通して存在することを保証します。 他に宣言や定義は必要ありません。
2つめの利用方法は、型の基底クラスの1つとしてsingleton<T>を用います。 extended_type_info_typeid.hppから単純化した抜粋を示します。
```cpp
<span>`template``<``class` `T`<span>`>`
</span></span><span>`class` `extended_type_info_typeid` `:` 
</span>    <span>`public`` detail``::``extended_type_info_typeid_0`<span>`,`
</span></span>    <span>`public`` singleton``<``extended_type_info_typeid``<``const`` T``>` <span>`>`
</span></span><span style='font-family:monospace;white-space:pre'>`{`
</span>    <span>`friend` `class` `singleton``<``extended_type_info_typeid``<``const`` T``>` `>`<span>`;`
</span></span><span>`private`<span>`:`
</span></span><span style='font-family:monospace;white-space:pre'>    <span>`// private constructor to inhibit any existence other than the `
</span></span><span style='font-family:monospace;white-space:pre'>    <span>`// static one.  Note: not all compilers support this !!!`
</span></span>`    extended_type_info_typeid`<span>`()` <span>`:`
</span></span>`        detail`<span>`::``extended_type_info_typeid_0`<span>`()`
</span></span><span style='font-family:monospace;white-space:pre'>    <span>`{`
</span></span>`        type_register`<span>`(``typeid``(``T`<span>`));`
</span></span><span style='font-family:monospace;white-space:pre'>    <span>`}`
</span></span>    <span>`~``extended_type_info_typeid`<span>`(){}`
</span></span><span style='font-family:monospace;white-space:pre'>    <span>`...`
</span></span><span style='white-space:pre'>`};`
</span>
この利用法は、以下のより自然なシンタックスが利用可能です。```cpp
`extended_type_info_typeid``<``T``>::`<span style='white-space:pre'>`get_const_instance``()`
</span>
どこでも上記の文を1つ以上プログラムに含むならば、唯一のインスタンスが生成され、参照されることを保証します。

##Multi-Threading
<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>このsingletonは、次の単純なルールにしたがうことで、マルチスレッドアプリケーションから安全に使うことができます。</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>複数のスレッドが走っているとき、get_mutable_instanceを呼び出さないこと!</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>serializationライブラリで利用されるすべてのsingletonはこのルールに従います。</p>
ミスによるこのルール違反を発見するのを助けるために、lock/unlock機能が存在します。
```cpp
`boost`<span>`::``serialization``::``global_lock``::``get_mutable_instance``().``lock`<span>`();`
</span></span>`boost``::``serialization``::``global_lock``::``get_mutable_instance``().`<span style='white-space:pre'>`unlock``();`
</span>
プログラムをデバッグ用にコンパイルしている間、ライブラリが"locked"状態でのget_mutable_instance()の呼び出しはassertionとしてトラップされます。<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>main関数が呼び出される前に、静的変数の変更を許可するためのgloal_lock状態は"unlocked"で初期化されます。</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>すべてのserializationテストはプログラムの開始時にlock()を呼び出します。</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>リリースモードでコンパイルされるプログラムでは、これらの関数は何の影響も与えません。</p></span>