#void_cast
<span style='font-family:Arial,Verdana,sans-serif;line-height:normal'>

##Motivation
<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>C++は、2つの関連したタイプの間で実行時でポインターをキャストするために、オペレーターdynamic_cast<T>（U * u）をもっています。</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>しかし、これが利用可能なのは、ポリモーフィックな関係にあるクラス間だけです。</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>つまり、これを使うためには、対象となるクラスが少なくとも1つの仮想関数を持っている必要があります。</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>ポインターのserializatonをそのようなクラスだけに制限することは、serializationライブラリの適用可能性を制限することにつながります。</p>

##Usage

以下の関数が、void_cast.hppにて定義されています。これらは、boost::serialization名前空間で宣言されています。
```cpp
<span>`template``<``class` `Derived``,` `class` `Base`<span>`>`
</span></span><span>`const`` void_cast_detail``::``void_caster `<span>`&`
</span></span><span style='font-family:monospace;white-space:pre'>`void_cast_register`<span>`(`
</span></span>`    Derived `<span>`const` `*`` derived ``=` `NULL``,` 
</span>`    Base `<span>`*` `const`` base ``=` <span>`NULL`
</span></span><span style='white-space:pre'>`)`
</span>
この関数は、1対の関連したタイプを『登録』します。<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>これは、DerivedをBBBから直接導出するための情報をグローバルなテーブルに保存します。</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>この『登録』は、プログラムのどこでも実行することができます。</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>pre-runtimeにビルドされるテーブルは、プログラムの他のどの場所でも利用できます。</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'><i>訳注：他の、とは、pre-runtimeのビルド中は除くという意味であろう</i></p>
隣接したbase/derivedペアだけは、登録する必要があります。
```cpp
`  void_cast_register`<span>`<``A``,`` B``>`<span>`();`
</span></span>`  void_cast_register``<``B``,`` C``>`<span style='white-space:pre'>`();`
</span>
を登録すれば、自動的にAはCにアップキャスト可能になります。逆(CからAへのダウンキャスト）も同様です。```cpp
<span>`void` <span>`*`
</span></span><span style='font-family:monospace;white-space:pre'>`void_upcast`<span>`(`
</span></span>`    extended_type_info `<span>`const` `&`` derived_type`<span>`,`
</span></span>`    extended_type_info `<span>`const` `&`` base_type`<span>`,`
</span></span>    <span>`void` `*` `const`` t `
</span><span style='font-family:monospace;white-space:pre'>`);`
</span>
<span style='font-family:monospace;white-space:pre'><span>
</span></span><span style='font-family:monospace;white-space:pre'><span>
</span></span>```cpp
<span>`void` <span><code>*
</code></span></span><span style='font-family:monospace;white-space:pre'>`void_downcast`<span><code>(
</code></span></span>`    extended_type_info `<span>`const` `&`` derived_type`<span><code>,
</code></span></span>`    extended_type_info `<span>`const` `&`` base_type`<span><code>,
</code></span></span>    <span>`void` `*` `const`<code> t 
</code></span><span style='white-space:pre'>`);`
</span>
これらの関数は、あるタイプからもう一つのタイプにvoidポインタをキャストします。<p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>変換元と変換先タイプは、対応するextended_type_infoレコードを参照することで指定されます。</p><p style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'><i>訳注：原文は以下の通りだが、definitionはdestinationの誤りと考えて訳している</i></p>```cpp
<span style='white-space:pre'>`The source and destination types are specified by passing`
</span>`references to the corresponding extended_type_info records.`
void_cast_registerで登録されていないタイプ間のキャストは、boost::archive::archive_exception例外を投げます。その際のexception_codeは、unregistered_castとなります。
</span>