#Archive Concepts
<span style='font-family:Arial,Verdana,sans-serif;line-height:normal'><span style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>

##Notaion

- SAはSaving Archive Conceptのモデルである
- saはSAのインスタンスである
- LAはLoading Archive Conceptのモデルである
- laはLAのインスタンスである
- Tはシリアライズ可能な型である
- xはT型のインスタンスである
- u,vはT型のインスタンスへのポインタである
- countは、std::size_tに変換可能な型のインスタンスである

##Saving Archive Concept

###Associated Types

直感的に、このモデル概念はC++のデータ構造のセットに対応するバイトシーケンスを生成します。

セーブする概念(SA)と、ロードする概念(LA)は、対応します。

これらはそれぞれ逆の働きをします。

つまり、SAによって生成されたバイト列を与えると、LAは、元のC++データ構造の等価物を生成します。

###Valid Expressions

SA::is_saving
</span><blockquote style='margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:40px;border-top-style:none;border-right-style:none;border-bottom-style:none;border-left-style:none;border-width:initial;border-color:initial;padding-top:0px;padding-right:0px;padding-bottom:0px;padding-left:0px'><span style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>
boost mplの整数定数型 boost::mpl::bool_<true>を返します。
</span></blockquote><span style='font-family:Verdana,Arial,Bitstream Vera Sans,Helvetica,sans-serif'>
SA::is_loading
<blockquote>
boost mplの整数定数型 boost::mpl::bool_<false>を返します。
</blockquote>
sa << x sa & x
<blockquote>
これらの式は、性格に同じ機能を果たさねばなりません。これらは、他の情報とともにxの値を、saに追加します。他の情報はアーカイブの実装によって定義されます。この情報は、saに対応するlaのアーカイブタイプによって正しくxを復元するのに必要です。
</blockquote><blockquote>
saの参照を返します。
</blockquote>
sa.save_binary(u, count)
<blockquote>
uからsize_t(count)バイト分の内容をアーカイブに追加します。
</blockquote>
sa.register_type<T>() sa.register_type(u)
<blockquote>
クラスTに関する情報をアーカイブに追加します。この情報は、派生クラスのポインタが対応するアーカイブタイプによってロードされるときに、正しいクラスを構築するのに利用されます。このメンバ関数の実行は、クラス登録と呼ばれます。これに関しては、[Special Considerations](https://sites.google.com/site/boostjp/document/boostserialization/reference/special-considerations)のDerivedPointersにて詳細に説明します。saがテンプレートパラメタである場合、規格を満たさないコンパイラが、この機能を呼び出せるように2番目の構文が用意されています。詳細は、テンプレート実施構文を見てください。
</blockquote></span></span>