#Boostを使用しているプロジェクト

見つけたら書いていってください。

Boostのどのライブラリを使用しているかも書くとさらにGood！Boostを使用したコードの参考にしてください。


##公式情報
- [商用製品](http://www.boost.org/users/uses_shrink.html)
- [オープンソースプロジェクト](http://www.boost.org/users/uses_open.html)
- [会社](http://www.boost.org/users/uses_inhouse.html)

- [Boost.Asioを使用しているプロジェクト](http://think-async.com/Asio/WhoIsUsingAsio)
- [Boost.Geometry(旧名GGL)を使用しているプロジェクト](http://trac.osgeo.org/ggl/wiki/WhoUsesGGL)
- [Boost.Graphを使用しているプロジェクト](http://www.boost.org/libs/graph/doc/users.html)


##boostjp
###オープンソースライブラリ
- [MongoDB](http://www.mongodb.org/) [[sourcecode](https://github.com/mongodb/mongo)]
データベースライブラリ。
Boost.Any, Boost.Asio, Boost.Bind, Boost.Filesystem, Boost.Function, Boost.ProgramOptions, Boost.SmartPtr, Boost.Spirit, Boost.Thread, Boost.Tuple, Boost.Utilityなどを使用している。

- [Cinder](http://libcinder.org/)
アーティスティック系ライブラリ。
Boost.SmartPtr, Boost.Threadなどを使用している。

- [OpenSGToolbox](http://www.vrac.iastate.edu/%7Edkabala/OpenSGToolbox/) [[sourcecode](https://github.com/djkabala/OpenSGToolbox)]
アーティスティック系ライブラリであるOpenSGの拡張ライブラリ。UI, FieldContainerEditor, Lua, ParticleSystem, ParticleTrail, 物理演算, サウンド, TextDom, ビデオ, Octree, AStarなどの機能がある。
Boost.Any, Boost.Assign, Boost.Bind, Boost.Filesystem, Boost.Format, Boost.LexicalCast, Boost.Random, Boost.Signals2, Boost.SmartPtr, Boost.StringAlgo, Boost.Xpressive, Boost.Functionなどを使用している。


- [Wt](http://www.webtoolkit.eu/wt/)
Web アプリケーションフレームワーク。Boost.Any, Boost.Array, Boost.Asio, Boost.Bind, Boost.DateTime, Boost.Filesystem, Boost.Function, Boost.Intrusive, Boost.Lambda, Boost.LexicalCast, Boost.Noncopyable, Boost.Optional, Boost.Pool, Boost.ProgramOptions, Boost.Regex, Boost.Ref, Boost.Range, Boost.Signals2, Boost.SmartPtr, Boost.Spirit, Boost.StringAlgo, Boost.Test, Boost.Thread, Boost.Tokenizer, Boost.Tuple, Boost.TypeTraits, Boost.uBlas, Boost.Unordered, Boost.Utilityなどを使用している。


- [Adobe Source Libraries](http://stlab.adobe.com/group__asl__home.html)
クロスプラットフォームのGUI構築とそれに付随するユーティリティライブラリ群。
GUI構築にAdam,Eveという2つの独自言語を採用しており、ウィジェット間依存関係、GUIレイアウトとロジックの記述をそれぞれと完全に分離できる。
少なくとも Boost.Utility,Function,Signals,Range,Bind,TypeTraits,ConceptCheck,MPL,FunctionTypes,Noncopyable,Fusion,Operators,Iterator,Array,Any,Tuple,SharedPtr,Integer,StaticAssert を使用している。

- [Nghttp2](https://nghttp2.org/)
通信プロトコルHTTPの最新版であるHTTP/2の実装を提供するCライブラリおよびアプリケーションプログラム。
C APIだけでなく、Boost.Asioベースの高水準なC++ APIが用意されている: [libnghttp2_asio: High level HTTP/2 C++ library](https://nghttp2.org/documentation/libnghttp2_asio.html)。

###オープンソースソフトウェア

- [DynamO](http://dynamomd.org/) [[sourcecode](https://github.com/toastedcrumpets/DynamO)]
イベント駆動シミュレータ。
Boost.Array, Boost.CircularBuffer, Boost.DateTime, Boost.Foreach, Boost.Function, Boost.Iostreams, Boost.LexicalCast, Boost.Math, Boost.ProgramOptions, Boost.Random, Boost.SmartPtr, Boost.Tokenizer, Boost.Tuple, Boost.Unorderedなどを使用している。


- Aptitude
Debian系Linuxディストリビューションで使用されているパッケージ管理システムaptの対話的フロントエンド。
Boost.Iostreamsを使用している。


- [Phusion Passenger](https://www.phusionpassenger.com/)
Ruby, Python, Node.jsのウェブアプリケーションフレームワークを動作されるアプリケーションサーバー。mod_rails, mod_rackなどとも呼ばれる。既存のウェブサーバー（Apacheまたはnginx）のモジュールとして動作するほか、単体でもHTTPサーバーとして動作する。
[dev/copy_boost_headers](https://github.com/phusion/passenger/blob/master/dev/copy_boost_headers)を見る限り、Boost.Thread、Boost.DateTime、Boost.SmartPtr、Boost.Function、Boost.Bindあたりを使用している模様。


- [Hiphop for PHP](https://github.com/facebook/hiphop-php)
PHPのソースコードからC++ソースコードを生成するトランスレータ。これ自体もC++で書かれており、Boostも使用されている模様。


- [Mosh: the mobile shell](https://mosh.mit.edu/)
SSHの置き換えを狙う端末アプリケーション。回線切断からの再接続やローカルエコーにより、SSHと比べ高信頼・快適な環境を売りにしている。


- [Mapnik](http://mapnik.org/)
地図データの扱い、描画に関するライブラリ。[INSTALL.md](https://github.com/mapnik/mapnik/blob/master/INSTALL.md)より、Filesystem、System、Thread、Regex、ProgramOptionsを使用していることの記載あり。


- [LibreOffice](http://ja.libreoffice.org/)
オフィススイート（文書作成、表計算、プレゼンテーション、etc.）。ver.4.0.1(2013/03/07)時点でのBoost使用状況をソースコードから[抽出して見る](https://gist.github.com/usagi/5108142)とArray、DateTime、Foreach、Preprocessor、Random、SmartPtr、Spirit、UnorderedMapなど使われている。ver.4のCalcからはRANDOM()にBoost.Randomを用いたメルセンヌツイスターを[採用](https://bugs.freedesktop.org/show_bug.cgi?id=33365)するなどBoostの利用も広まっている模様。


- [MySQL](http://www-jp.mysql.com/)
リレーショナルデータベース管理システム (RDBMS)。オープンソースのRDBMSにおいて、人気がある製品の1つである。
GIS関係の実装においてBoost.Geometoryを使用している。
参考: [MySQLの実装にBoost.Geometryが使われはじめた - Faith and Brave - C++で遊ぼう](http://faithandbrave.hateblo.jp/entry/2014/04/28/131514)


###商用製品
- [Shade](https://shade3d.jp/)
e-frontier社 3DCG作成ソフト。
プラグイン用SDKにBoostを含む。
Boost.TypeTraits、Boost.MPLなどを使用。

- [長崎ペンギン水族館バーチャルシアター](http://blog.penguin-aqua.jp/archives/2145)
3Dシアター。立体視CG描画のための3DエンジンにBoostを使用。
アセット管理にBoost.Filesystem、Boost.SmartPtr、Boost.Flyweight。
キャラクターの動きにBoost.Context、Boost.Random。




###会社
- [株式会社Aiming](https://aiming-inc.com/ja)
オンラインゲームのサーバー開発にBoost.Any、Boost.Array、Boost.Foreach、Boost.Format、Boost.Function、Boost.LexicalCast、Boost.Multi-Index、Boost.Optional、Boost.Regex、Boost.Spirit、Boost.StringAlgo、Boost.Tokenizer、Boost.Utility、Boost.Xpressiveなどを使用。



