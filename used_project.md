#Boostを使用しているプロジェクト


Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>公式情報](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>boostjp](#TOC-boostjp)<ol class='goog-toc'><li class='goog-toc'>[<strong>2.1 </strong>オープンソースライブラリ](#TOC--1)</li><li class='goog-toc'>[<strong>2.2 </strong>オープンソースソフトウェア](#TOC--2)</li><li class='goog-toc'>[<strong>2.3 </strong>商用製品](#TOC--3)</li><li class='goog-toc'>[<strong>2.4 </strong>会社](#TOC--4)</li></ol></li></ol>



見つけたら書いていってください。

Boostのどのライブラリを使用しているかも書くとさらにGood!


Boostを使用したコードの参考にしてください。



###公式情報

[商用製品](http://www.boost.org/users/uses_shrink.html)

[オープンソースプロジェクト](http://www.boost.org/users/uses_open.html)

[会社](http://www.boost.org/users/uses_inhouse.html)


[Boost.Asioを使用しているプロジェクト](http://think-async.com/Asio/WhoIsUsingAsio)

[Boost.Geometry(旧名GGL)を使用しているプロジェクト](http://trac.osgeo.org/ggl/wiki/WhoUsesGGL)

[Boost.Graphを使用しているプロジェクト](http://www.boost.org/libs/graph/doc/users.html)



###boostjp

<h4 style='font-family:Trebuchet MS,arial,sans-serif;font-size:1.2em;background-color:rgb(238,238,238);border-top-style:dotted;border-right-style:dotted;border-bottom-style:dotted;border-left-style:dotted;border-top-width:1px;border-right-width:1px;border-bottom-width:1px;border-left-width:1px;border-top-color:rgb(199,199,199);border-right-color:rgb(199,199,199);border-bottom-color:rgb(199,199,199);border-left-color:rgb(199,199,199);color:rgb(26,66,146);padding-top:3px;padding-right:5px;padding-bottom:3px;padding-left:5px;background-repeat:initial initial'>オープンソースライブラリ</h4>

<li style='list-style-position:outside;list-style-type:square'>[MongoDB](http://www.mongodb.org/) [[sourcecode](https://github.com/mongodb/mongo)]
データベースライブラリ。
Boost.Any, Boost.Asio, Boost.Bind, Boost.Filesystem, Boost.Function, Boost.ProgramOptions, Boost.SmartPtr, Boost.Spirit, Boost.Thread, Boost.Tuple, Boost.Utilityなどを使用している。

</li>
<li style='list-style-position:outside;list-style-type:square'>[Cinder](http://libcinder.org/)
アーティスティック系ライブラリ。
Boost.SmartPtr, Boost.Threadなどを使用している。

</li>
<li style='list-style-position:outside;list-style-type:square'>[OpenSGToolbox](http://www.vrac.iastate.edu/%7Edkabala/OpenSGToolbox/) [[sourcecode](https://github.com/djkabala/OpenSGToolbox)]
アーティスティック系ライブラリであるOpenSGの拡張ライブラリ。UI, FieldContainerEditor, Lua, ParticleSystem, ParticleTrail, 物理演算, サウンド, TextDom, ビデオ, Octree, AStarなどの機能がある。
Boost.Any, Boost.Assign, Boost.Bind, Boost.Filesystem, Boost.Format, Boost.LexicalCast, Boost.Random, Boost.Signals2, Boost.SmartPtr, Boost.StringAlgo, Boost.Xpressive, Boost.Function<span style='font-family:helvetica,arial,freesans,clean,sans-serif;line-height:normal'>などを使用している。

</span></li>
<li style='list-style-position:outside;list-style-type:square'><span style='font-family:helvetica,arial,freesans,clean,sans-serif;line-height:normal'>[Wt](http://www.webtoolkit.eu/wt/)
Web アプリケーションフレームワーク。Boost.Any, Boost.Array, Boost.Asio, Boost.Bind, Boost.DateTime, Boost.Filesystem, Boost.Function, Boost.Intrusive, Boost.Lambda, Boost.LexicalCast, Boost.Noncopyable, Boost.Optional, Boost.Pool, Boost.ProgramOptions, Boost.Regex, Boost.Ref, Boost.Range, Boost.Signals2, Boost.SmartPtr, Boost.Spirit, Boost.StringAlgo, Boost.Test, Boost.Thread, Boost.Tokenizer, Boost.Tuple, Boost.TypeTraits, </span><span style='font-family:helvetica,arial,freesans,clean,sans-serif;line-height:normal'>Boost.uBlas, Boost.Unordered, Boost.Utilityなどを使用している。

</span></li>
<li style='list-style-position:outside;list-style-type:square'><span style='font-family:helvetica,arial,freesans,clean,sans-serif;line-height:normal'>[Adobe Source Libraries](http://stlab.adobe.com/group__asl__home.html)
クロスプラットフォームのGUI構築とそれに付随するユーティリティライブラリ群。
GUI構築にAdam,Eveという2つの独自言語を採用しており、</span>ウィジェット間依存関係、GUIレイアウトとロジックの記述をそれぞれと完全に分離できる。
<span style='font-family:helvetica,arial,freesans,clean,sans-serif;line-height:normal'>少なくとも Boost.{Utility,Function,Signals,Range,Bind,TypeTraits,ConceptCheck,MPL,FunctionTypes
,Noncopyable,Fusion,Operators,Iterator,Array,Any,Tuple,SharedPtr,Integer,StaticAssert} を使用している。
</span></li>

<h4 style='font-family:Trebuchet MS,arial,sans-serif;font-size:1.2em;background-color:rgb(238,238,238);border-top-style:dotted;border-right-style:dotted;border-bottom-style:dotted;border-left-style:dotted;border-top-width:1px;border-right-width:1px;border-bottom-width:1px;border-left-width:1px;border-top-color:rgb(199,199,199);border-right-color:rgb(199,199,199);border-bottom-color:rgb(199,199,199);border-left-color:rgb(199,199,199);color:rgb(26,66,146);padding-top:3px;padding-right:5px;padding-bottom:3px;padding-left:5px;background-repeat:initial initial'>オープンソースソフトウェア</h4>

<li style='list-style-position:outside;list-style-type:square'>[DynamO](http://www.marcusbannerman.co.uk/dynamo) [[sourcecode](https://github.com/toastedcrumpets/DynamO)]
イベント駆動シミュレータ。
Boost.Array, Boost.CircularBuffer, Boost.DateTime, Boost.Foreach, Boost.Function, Boost.Iostreams, Boost.LexicalCast, Boost.Math, Boost.ProgramOptions, Boost.Random, Boost.SmartPtr, Boost.Tokenizer, Boost.Tuple, Boost.Unorderedなどを使用している。

</li>
<li style='list-style-position:outside;list-style-type:square'>Aptitude
Debian系Linuxディストリビューションで使用されているパッケージ管理システムaptの対話的フロントエンド。
Boost.Iostreamsを使用している。

</li>
<li style='list-style-position:outside;list-style-type:square'>[Phusion Passenger](http://www.modrails.com/)
Ruby on RailsをはじめとするRubyのウェブアプリケーションフレームワークを動作されるためのミドルウェア（ApacheモジュールとNginxモジュール）。mod_rails, mod_rackなどとも呼ばれる。
[copy_boost_headers.rb](https://github.com/FooBarWidget/passenger/blob/master/dev/copy_boost_headers.rb)を見る限り、Boost.Thread、Boost.DateTime、Boost.SmartPtr、Boost.Function、Boost.Bindあたりを使用している模様。

</li>
<li style='list-style-position:outside;list-style-type:square'>[VirtualBox](http://www.virtualbox.org/)
x86およびx86-64の仮想マシン環境を提供するソフトウェア。SunからOracleへと引き継がれた。
[trunk/src/libs](http://www.virtualbox.org/browser/trunk/src/libs)以下のディレクトリに使用しているヘッダを置いているようだ。リビジョン37986 (2011/07/16)時点ではBoost.Exceptions、Boost.SmartPtrのファイルが存在する。

</li>
<li style='list-style-position:outside;list-style-type:square'>[Hiphop for PHP](https://github.com/facebook/hiphop-php)
PHPのソースコードからC++ソースコードを生成するトランスレータ。これ自体もC++で書かれており、Boostも使用されている模様。
</li>
<li style='list-style-position:outside;list-style-type:square'>[Mosh: the mobile shell](http://mosh.mit.edu/)
SSHの置き換えを狙う端末アプリケーション。回線切断からの再接続やローカルエコーにより、SSHと比べ高信頼・快適な環境を売りにしている。
</li>
<li style='list-style-position:outside;list-style-type:square'>[Mapnik](http://mapnik.org/)
地図データの扱い、描画に関するライブラリ。[INSTALL.md](https://github.com/mapnik/mapnik/blob/master/INSTALL.md)より、Filesystem、System、Thread、Regex、ProgramOptionsを使用していることの記載あり。
</li><li style='list-style-position:outside;list-style-type:square'>[LibreOffice](http://ja.libreoffice.org/)オフィススイート（文書作成、表計算、プレゼンテーション、etc.）。ver.4.0.1(2013/03/07)時点でのBoost使用状況をソースコードから[抽出して見る](https://gist.github.com/usagi/5108142)とArray、DateTime、Foreach、Preprocessor、Random、SmartPtr、Spirit、UnorderedMapなど使われている。ver.4のCalcからはRANDOM()にBoost.Randomを用いたメルセンヌツイスターを[採用](https://bugs.freedesktop.org/show_bug.cgi?id=33365)するなどBoostの利用も広まっている模様。</li>
<h4><b>商用製品</b></h4>

<li>[Shade](http://shade.e-frontier.co.jp/)
<span style='font-family:arial,sans-serif'>e-frontier社 3DCG作成ソフト。
</span><span style='font-family:arial,sans-serif'>プラグイン用SDKにBoostを含む。
</span>Boost.TypeTraits、Boost.MPLなどを使用。</li>

<li>[長崎ペンギン水族館バーチャルシアター](http://blog.penguin-aqua.jp/archives/2145)
<span style='font-family:arial,sans-serif'>3Dシアター。立体視CG描画のための3DエンジンにBoostを使用。
</span><span style='font-family:arial,sans-serif'>アセット管理にBoost.Filesystem、Boost.SmartPtr、Boost.Flyweight。
</span>キャラクターの動きにBoost.Context、Boost.Random。</li>





<h4 style='font-family:Trebuchet MS,arial,sans-serif;font-size:1.2em;background-color:rgb(238,238,238);border-top-style:dotted;border-right-style:dotted;border-bottom-style:dotted;border-left-style:dotted;border-top-width:1px;border-right-width:1px;border-bottom-width:1px;border-left-width:1px;border-top-color:rgb(199,199,199);border-right-color:rgb(199,199,199);border-bottom-color:rgb(199,199,199);border-left-color:rgb(199,199,199);color:rgb(26,66,146);padding-top:3px;padding-right:5px;padding-bottom:3px;padding-left:5px;background-repeat:initial initial'>会社</h4>

<li style='list-style-position:outside;list-style-type:square'>[株式会社Aiming](http://aiming-inc.com/)
オンラインゲームのサーバー開発にBoost.Any、Boost.Array、Boost.Foreach、Boost.Format、Boost.Function、Boost.LexicalCast、Boost.Multi-Index、Boost.Optional、Boost.Regex、Boost.Spirit、Boost.StringAlgo、Boost.Tokenizer、Boost.Utility、Boost.Xpressiveなどを使用。

</li>


