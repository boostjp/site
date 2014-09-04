#Exporting Class Serialization
<span style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif;line-height:normal'>
このマニュアルの他の箇所([ExportKey](https://sites.google.com/site/boostjp/document/boostserialization/reference/serializableconcept/class-serialization-traits/export-key))で、BOOST_CLASS_EXPORTを解説しています。Exportは2つのことを意味します。

- 他で参照されないコードをインスタンス化します。
- シリアライズのために、external識別子とクラスを対応づけます。クラスが明示的に参照されないという事実は、この必要条件を示します。
C++では、明示的に参照されないコードは、仮想関数によって実装されます。よって、派生クラスを基底クラスのポインタまたは参照経由で操作するような用法の場合、exoprtが必要であることを意味します。

任意のアーカイブクラスのヘッダをインクスードするのと同じソースモジュールにあるBOOST_CLASS_EXPORTは、それらアーカイブクラスにポリモーフィックなポインタのシリアライズを要求するコードをインスタンス化します。

アーカイブクラスのヘッダが(BOOST_CLASS_EXPORTしているソースに)含まれないならば、どんなコードもインスタンス化されません。

BOOST_CLASS_EXPORTは、アーカイブクラスのインクルードよりもあとに配置する必要があります。

BOOST_CLASS_EXPORTを使うコードは、以下のようになります
```cpp
`#include <boost/archive/text_oarchive.hpp>`
<pre style='margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px'><span><code>#include <boost/archive/text_oarchive.hpp>
</code></span>`...` <span><code>// other archives
</code></span><span><code>
#include "a.hpp" </code></span><span><code>// header declaration for class a
</code></span>`BOOST_CLASS_EXPORT``(``a``)`
`...` `// other class headers and exports`</pre>
これは、スタンドアロンな実行ファイルや、スタティックライブラリ、ダイナミックまたはsharedライブラリであるかどうかに関係しません。
"a.hpp"でBOOST_CLASS_EXPORTをインクルードすることは、アーカイブヘッダをBOOST_CLASS_EXPORTよりも前にインクルードするという上記のルールに従うことを、困難にするまたは不可能にします。

このようなことが行いたい場合、ヘッダファイルの宣言にてBOOST_CLASS_EXPORT_KEYを用い、クラス定義を行うファイルでBOOST_CLASS_EXPORT_IMPLEMENTを用いることでうまく解決できます。

この仕組みは、コードをスタティックまたはsharedライブラリに置くことを考慮しています。

アーカイブクラスのヘッダも合わせてインクルードしない限り、ライブラリコードにBOOST_CLASS_EXPORTを配置しても効果はありません。

そんなわけで、ライブラリを作る際は、利用者が期待するすべてのアーカイブクラスのためのヘッダをインクルードしなければなりません。

あるいは、ポリモーフィックなアーカイブのためだけに、ヘッダファイルをインクルードすることができます。

厳密に言えば、すべてのポインタ経由のシリアライズが、もっとも派生したクラスによって発生するならば、exportは必要ではありません。

しかし、何が破壊的なエラーかを見つけるために、ライブラリはすべてのポインタ経由のポリモーフィックなシリアライズをトラップします。対象クラスが、exportされない、あるいは、登録されていないとしても。

現実には、ポインタ経由でシリアライズする1つまたはそれ以上の仮想関数を持つクラスをすべて登録またはexportします。

この機能の実現が、C++のベンダー拡張に依存することに注意してください。しかし、boostでテスとされるすべてのC++コンパイラは、要求された拡張を提供します。ライブラリは、それぞれのコンパイラで必要となる追加の宣言を含みます。将来C++コンパイラがこれらの拡張か、それと等価な何かをサポートするという予想は合理的と言えます。
</span>