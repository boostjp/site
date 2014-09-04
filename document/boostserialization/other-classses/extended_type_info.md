#extended_type_info
<span style='font-family:Arial,Verdana,sans-serif;line-height:normal'>

##Motivation
<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>serializationライブラリは、以下の機能を実現するためにtype_info/typeid()のような仕組みを必要とします。</p><ol style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>
- タイプTのポインタが与えられたとき、それが示す真のタイプを見つける。
- 『外部』キーが与えられたとき、どんなタイプのオブジェクトを生成するか決定する。</ol>

##The problem with std::type_info
<ul style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>
- 主として必要なる関数std::typeid()が、すべての環境で利用できるわけではありません。この関数のサポートは、実行時タイピング(RTTI)のサポートに依存します。この関数は、非効率という理由から、存在しないまたは、利用可能にされないかもしれません。
- std::type_infoは、タイプ名からなる文字列を含みます。これは上記条件2を満たすようです。しかし、この文字列のフォーマットは、コンパイラ、ライブラリ、オペレーティングシステムをまたいで一貫していません。これでは、ポータブルなアーカイブをサポートすることはできません。
- もしタイプ名文字列をなんとかポータブルにすることができたとしても、異なるアプリケーションをまたいで、クラスヘッダが同じ名前空間に含まれるという保証はありません。
- 実際、異なるヘッダを異なる名前空間に置くことは、名前の衝突を避けるための手段です。このように、namespace::class_nameは、キーとして利用することができないのです。
- 異なるクラスが、異なるtype idメカニズムを使う可能性があります。クラスヘッダはこの情報を含むかもしれません。アプリケーションをまたいでクラスヘッダをインポートしたいならば、異なるtype idシステムをサポートするのが便利です。

##Features
<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>extended_type_infoは以下の特徴を持つstd::type_infoの実装です。</p><ul style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>
- extended_type_infoの(シリアライズされるタイプごとに1つの)レコードのsetを構築します。
- タイプに関係する任意の文字列キーを許可します。このキーは、しばしばクラス名となりますが、そうでなければならないということはありません。このキーはGUID(Global Unique IDentifier)と呼ばれます。それはこの宇宙で唯一でなければなりません。一般に、GUIDはヘッダファイルにおいて、アプリケーションをまたいでtypeをマッチさせるのに利用されます。マクロBOOST_CLASS_EXPORTを実行することで、文字列キーをどんな既知のタイプとでも結びつけることができます。これを"exported types"と呼びます。
- type info systemを混ぜることを許します。たとえば、あるクラスがtypeid()を外部のクラス識別しを見つけるために使っおり、別のクラスは使っていないということが許されます。<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>文字列キーが与えられたとき、対応する方が見つけられるように、exported typeはグローバルなテーブルとして管理されます。この仕組みが、基底クラスポインタ経由でシリアライズされるタイプを作るために、serializationライブラリで利用されます。</p><h1 style='font-family:Arial,Verdana,Bitstream Vera Sans,Helvetica,sans-serif;font-weight:bold;letter-spacing:-0.018em;font-size:19px;margin-top:0.15em;margin-right:1em;margin-bottom:0.5em'>Runtime Interface</h1>```cpp
`namespace boost { `
`namespace serialization {`

`class extended_type_info`
`{`
`protected:`
`    // this class can't be used as is. It's just the `
`    // common functionality for all type_info replacement`
`    // systems.  Hence, make these protected`
`    extended_type_info(`
`        const unsigned int type_info_key,`
`        const char * key`
`    );`
`    ~extended_type_info();`
`    void key_register();`
`    void key_unregister();`
`public:`
`    const char * get_key() const;`
`    bool operator<(const extended_type_info &rhs) const;`
`    bool operator==(const extended_type_info &rhs) const;`
`    bool operator!=(const extended_type_info &rhs) const {`
`        return !(operator==(rhs));`
`    }`
`    // for plugins`
`    virtual void * construct(unsigned int count = 0, ...) const;`
`    virtual void destroy(void const * const p) const;`
`    static const extended_type_info * find(const char *key);`
`};`

`} // namespace serialization `
`} // namespace boost`



通常、それぞれのタイプのために作られる唯一のextended_type_infoのインスタンスが存在します。しかし、これは実行可能なモジュールレベルだけで実施されます。つまり、プログラムがある種のsharedライブラリやDLLを含むならば、あるタイプに対応するextended_type_infoのインスタンスが複数存在するかもしれません。この理由により、下記の比較関数では単にインスタンスのアドレスを比較することができません。インスタンス内部の実際の情報を比較する必要があります。
```cpp
`extended_type_info(unsigned int type_info_key, const char *key);`
このコンストラクタは、すべての派生クラスによって呼び出されなければなりません。 第1引数は、特定の実装を示す番号でなければなりません。<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'><i>訳注：型の番号ではなく、型システムの実装番号であることに注意</i></p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>typeid()によるこのデフォルトの実装のための値は1です。</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>それぞれのシステムは、それ自身を示す整数を持っていなければなりません。 この値は、異なるtypeinfoシステムのインターオペラビリティを実現するのに用いられます。</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>第2引数は、このレコードが対応づけられる名前を示すconst文字列です。それはGUIDと呼ばれることがあります。これは、あるプログラムから別のプログラムに、アーカイブ内のユニークに識別するために渡されます。export機能を利用しない場合、この値はNULLとなるでしょう。</p>```cpp
`void key_register();``void key_unregister();`
このシステムは、external文字列とextended_type_infoレコードを関連づけるグローバルなテーブルを管理します。 ベースクラスポインタを経由してシリアライズされたオブジェクトをロードするとき、このテーブルは利用されます。 この場合、アーカイブは新たなオブジェクトを作るために、どのextended_type_infoを使えばよいのか決定するためにテーブルを検索する際に用いる文字列を含みます。
これらの関数は、このテーブルのエントリを追加したり削除したりするために、extended_type_infoを実装するクラスのコンストラクタと、デストラクタから呼び出されます。
```cpp
`const` `char` `*``get_key``()` `const`<span style='white-space:pre'>`;`
</span>
extended_type_infoからキーを取り出します。
キーがインスタンスと関係しない場合、NULLが帰ります。
```cpp
<span>`bool` `operator``<``(``const`` extended_type_info ``&`` rhs``)` `const`<span>`;`
</span></span><span>`bool` `operator``==``(``const`` extended_type_info ``&`` rhs``)` `const`<span>`;`
</span></span>`bool` `operator``!=``(``const`` extended_type_info ``&`` rhs``)` `const`<span style='white-space:pre'>`;`
</span>
これらの関数は、2つのextended_type_infoオブジェクトを比較するのに用いられます。
それらは、厳密な全順序をextended_type_infoに要求します。
```cpp
`virtual` `void` `*`` construct``(``unsigned` `int`` count ``=` `0``,` `...)` `const`<span style='white-space:pre'>`;`
</span>
この、extended_type_infoレコードに対応するタイプの新しいインスタンスを作成します。 この関数は、可変引数リストとして最大4つまでの任意の型の引数をとります。 これらの引数は、実行時に、生成する型のコンストラクタに渡されます。 この仕組みを利用するために、コンストラクタのための型シーケンスを宣言せねばなりません。 タイプがexportされたとき、この関数の引数の個数は一致しなければならず、型も一致しなければなりません。<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>この関数は、BOOST_CLASS_EXPORTによって、exportされたGUIDだけから、インスタンスを生成します。 もしこれらのタイプがDLLや共有ライブラリで定義されるならば。</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>これらのモジュールが実行時にロードされる場合、アンロードされるまでの間、これらのコンストラクタを呼び出すことができます。</p>
これらのモジュールはプラグインと呼ばれます。
```cpp
`virtual` `void`` destroy``(``void` `const` `*` `const`` p``)` `const`<span style='white-space:pre'>`;`
</span>
上記コンストラクタで生成されたオブジェクトを破棄します。```cpp
`static` `const`` extended_type_info ``*`` find``(``const` `char` `*`<span style='white-space:pre'>`key``);`
</span>
文字列キーかGUIDを与えると、対応するextended_type_infoオブジェクトを返します。

##Requirements

serializationライブラリによって利用されるために、extended_type_info(ETI)の実装は、extended_type_infoを継承しなければなりません。さらに、以下を実装しなければなりません。
```cpp
<span>`template``<``class` `ETI`<span>`>`
</span></span><span>`const`` extended_type_info `<span>`*`
</span></span>`ETI``::``get_derived_extended_type_info``(``const`` T ``&`` t``)` `const`<span style='white-space:pre'>`;`
</span>
タイプTの"true type"に対応するextended_type_infoのインスタンスを返します。"true type"とはクラス継承階層でもっとも下にあるタイプです。 タイプTは常に"true type"にstatic castでキャストすることができます。<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'></p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>この関数の実装は、タイプIDシステムの間で異なることがあります。また、この関数は、特定のextended_type_infoの実装と同一視可能な型Tを推定します。</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'><i>訳注：原文は以下。うまく訳せなかった thanはthatのtypoと考えて訳した↑</i></p><pre style='background-color:rgb(247,247,247);border-top-width:1px;border-right-width:1px;border-bottom-width:1px;border-left-width:1px;border-top-style:solid;border-right-style:solid;border-bottom-style:solid;border-left-style:solid;border-top-color:rgb(215,215,215);border-right-color:rgb(215,215,215);border-bottom-color:rgb(215,215,215);border-left-color:rgb(215,215,215);margin-top:1em;margin-right:1.75em;margin-bottom:1em;margin-left:1.75em;padding-top:0.25em;padding-right:0.25em;padding-bottom:0.25em;padding-left:0.25em;overflow-x:auto;overflow-y:auto'>Implemention of this function will vary among type id systems 
and sometimes will make presumptions about the type T than 
can be identified with a particular extended_type_info 
implementation.
<span></span></pre>```cpp
`virtual bool ETI::is_less_than(const extended_type_info &rhs) const;`
<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>このインスタンスと同じextended_type_infoの実装を利用して、rhsと比較する。</p>```cpp
`virtual bool ETI::is_equal(const extended_type_info &rhs) const;`
<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>このインスタンスと同じextended_type_infoの実装を利用して、rhsと比較する。 タイプが同じならtrueを、そうでなければfalseを返す。</p>```cpp
`const char ETI::get_key() const;`
<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>このクラスの外部キー(別名GUID)を返します。</p>```cpp
`virtual void * construct(unsigned int count, ...) const;`
<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>対応する型のインスタンスを引数リストから構築します。</p>```cpp
`virtual void * destroy(void const * const ptr ) ) const;`
<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>この型のインスタンスを破棄します。適切なデストラクタを呼び出し、メモリを解放します。</p>

##Models
<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>serializationライブラリは、2つの異なったextended_type_infoの実装を持っています。</p>

###extended_type_info_typeid
<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>extended_type_info_typeidは、標準的なtypeid()によって実装されます。 コンパイラによって、RTTIサポートが有効になっていることを想定しています。</p>

###extended_type_info_no_rtti
<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>extended_type_info_no_rttiは、RTTIの存在に依存しない形で実装されています。</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>その代わり、すべてのポリモーフィックな型が明示的にexportされることを要求します。 それに加え、exportをベースクラスポインタ経由で行うならば、それらのタイプは以下の</p>```cpp
`virtual const char * get_key();`
<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>すなわちクラスのもっとも継承されたクラス(Leafクラス)を返すシグニチャをもつ仮想関数を実装することを要求されます。</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>この関数は、上述の通りget_derived_extended_type_infoによって必要とされる機能を実装するために仮想でなければなりません。</p>

##Example
<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>テスト・プログラムtest_no_rttiは、クラスに対応するexportキーを返すために、上記のextended_type_info APIに関して、この関数を実装します。</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>これは、非抽象型がエクスポートされることを要求します。</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>これは、extended_type_infoの2つの異なる機能の間でとのインターオペラビリティもまた示します。</p></span>