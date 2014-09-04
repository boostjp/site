#Boostライブラリのビルド方法

ここではBoostライブラリのビルド方法について説明します。

Windowsとそれ以外に分けて説明します。
また、LinuxではBoostライブラリがディストリビューションによって提供されていることがありますが、ここではビルド方法のみを扱います。

1.47.0からbjamだけではなく、b2も生成されるようになりました。
また、公式がbjamからb2での説明に切り替わっています。なので、こちらもそれに合わせることにします。


<h4>ダウンロード</h4>
現在の最新バージョンは、以下からダウンロードすることができます：

[http://www.boost.org/users/download/#live](http://www.boost.org/users/download/#live)


開発バージョンは、Githubから取得することができます：

[https://github.com/boostorg](https://github.com/boostorg)

<h4><b>Windowsの場合</b></h4>
手順はここ([http://www.boost.org/doc/libs/release/more/getting_started/windows.html](http://www.boost.org/doc/libs/release/more/getting_started/windows.html))に書かれていますのでそれを翻訳します。


解凍したディレクトリに移動します。
<b>> cd (解凍したディレクトリ)
> bootstrap.bat</b>
とします。
すると、b2.exe,bjam.exeが生成されます。

単になんの指定もしないビルドでは：
<b>> b2.exe install -j2 --prefix=(インストールしたいディレクトリ)</b>
となります。これでビルドし、インストールされるのを待つだけです。

Vista/7以降のWindows OSを使っている場合は、
--prefix=で指定するディレクトリにはProgram Filesのような
Cドライブの管理者権限が必要になるディレクトリは避けてください。
権限がない場合はインストールに失敗しますのでご注意を。



<h4><b>Windows以外、Linux/Macなどの場合</b></h4>
手順はここ([http://www.boost.org/doc/libs/release/more/getting_started/unix-variants.html](http://www.boost.org/doc/libs/release/more/getting_started/unix-variants.html))に書かれているのでそれを翻訳します。
解凍したディレクトリに移動します。
<b>$ cd (解凍したディレクトリ)</b>
<b>$ bootstrap</b><b>.sh</b>
これで実行可能ファイルのbjam,b2が生成されます。

単になんの指定もしないビルドでは：
<b>$ ./b2 install -j2 --prefix=(インストールしたいディレクトリ)</b>
となります。

Linuxを使っており、ディストリビューション提供のboostライブラリをインストールしている場合は、--prefixで<u>/usr以外を必ず指定</u>してください。--prefixを省略した場合/usr/localが選択されますが、多くの環境では$PATHの解決順序の関係上無条件で/usr/local上のBoostが選択されてしまうでしょう。
/usr以下を使用すると環境を壊すことになりかねないので、通常は$HOME/localや$HOME/boost_1_51_0といったディレクトリを用意するのが良いでしょう。
一部のディストリビューションでは$HOME/localを$PATHにデフォルトで登録しているものもあるので、複数人で共用している場合には便利です。


<h4>並列ビルド</h4>
一般的なmake同様に、複数CPUを使ってビルドできます。-j 8のように、-j Nと指定するとN個並列でビルド処理が実行されます。<b>これを指定しないとビルドが非常に遅くなるので、基本的に常に指定することをおすすめします。</b>

Nの数は、一般的にはCPUの物理コア数または物理コア数+1を指定することが多いようです。経験的に+1することでIO waitが隠蔽されるのを期待できます。
ノートPCだと熱が大変なことになるので、気になるようなら少し少なめにしても良いかもしれません。

<hr width='100%' size='2'/>

<b>※ここからは完全に蛇足です。</b>
<h4>b2/bjamが受け取るコマンド</h4>


b2 --helpでは多くのユーザーが期待するヘルプを参照することはできません。
b2/bjamに関するヘルプを参照するにはboostを解凍したディレクトリ上でb2 --helpを行なってください。


以下に紹介するb2/bjamへの引数に順序はありません。どのような順で指定しても正しく解釈されます。



コマンドラインの例:

./b2 toolset=msvc link=static,shared address-model=64 install




<h4>プロパティ</h4>

- <b>toolset</b>
ひとつのマシンに複数種類のコンパイラがインストールされている場合はtoolsetコマンドで指定ができます。
例えば：

<ul style='margin-left:40px'>
- borland  : Borland社のコンパイラ

- dmc          : Digital Mars社のコンパイラ

- darwin    : Apple社の手によるgccコンパイラ(Mac OS)

- gcc            : GNU プロジェクトによるコンパイラ

- intel         : Intel社によるコンパイラ

- msvc         : Microsoft社によるコンパイラ
の指定が可能です。msvc-9.0 (Visual C++ 2008)、msvc-10.0 (Visual C++ 2010)のようにコンパイラのバージョン指定も可能です。


- <b>link</b>
これはstatic, sharedライブラリを作るかどうかの指定をするコマンドです。
link=static,shared
のように指定して使います。

<ul style='margin-left:40px'>
- lib, dll (Windows)
<li>a, dylib (Mac OSX)
</li>

- a, so (Other Systems)
のようなライブラリファイルを生成します。


- <b>threading</b>


- multi:マルチスレッドなライブラリを生成します。

- single:シングルスレッドなライブラリを生成します。
筆者の環境ではsingleがエラーが出てコンパイルできなかった。 (<strike>[#7105](https://svn.boost.org/trac/boost/ticket/7105)</strike>)


trunkで修正済み 1.53.0で修正されると思われる





- <b>variant</b>


- debug: デバッグビルドを生成します。

- release: リリースビルドを生成します。



- <b>デフォルトプロパティ</b>
Windows環境においてはデフォルトで以下のプロパティが使用されます。



- link=static threading=multi variant=debug,release runtime-link=shared
Linux環境においてはデフォルトで以下のプロパティが使用されます。



- link=static,shared threading=multi variant=release
その他の環境についてはアンドキュメントとなっているので注意してください。


<h4>アーキテクチャ</h4>
ターゲットアーキテクチャが異なる場合には、b2/bjamにarchitecture=<target-architecture>を指定すればよい。
<target-architecture>に指定できる値は以下のとおりです。


<li>x86: IA-32/x86_64向け
</li>

- ia64: IA-64向け

- arm: Arm向け

- power: Power-PC向け

- sparc: Sparc向け

ただしtoolsetによってはサポートされていない場合があります。



<h4><b>アドレスモデル</b></h4>
異なるアドレスモデルでビルドするにはb2/bjamに


<ul style='margin-left:40px'>
- address-model=32: 32ビットのライブラリを生成します。

- address-model=64: 64ビットのライブラリを生成します。
を指定すればよい。




<h4>レイアウト</h4>

Boostをビルドする際にb2/bjamが生成するバイナリファイル名はデフォルトで環境によって異なります。
これは--layout=<layout>を渡すことで変更できます。<layout>に渡すことのできる値は以下のとおりです。



- versioned: バイナリファイル名にバージョンが入ります。Windowsではデフォルトでversionedが選択されます。

- tagged: ビルド時に指定したプロパティ（variantやthreading等）がバイナリファイル名に含まれます。ただし、コンパイラ名、コンパイラのバージョン、Boostのバージョンは入りません。

- system: システムへインテグレートするためにバージョン番号などは入りません。Unixではデフォルトでsystemが選択されます。


<h4>ビルドのクリーン</h4>


--cleanを渡すことでビルドをクリーンすることが可能です。
ただし、b2/bjamはプロパティなどの差から異なるビルドを生成します。その為クリーン対象のビルドと同一のプロパティを指定した上で--cleanを渡す必要があります。


<h4>コンパイラオプション、リンカオプション</h4>
ビルドする際にコンパイラやリンカにオプションを渡す必要がある場合はb2/bjamの引数に
<li>cflags=(Cコンパイラオプション)
</li>

- cxxflags=(C++コンパイラオプション)

- linkflags=(リンカオプション)

- define=(プリプロセッサシンボル）

- include=(追加インクルードパス）

- library-path=(追加ライブラリパス）

- library-file=(追加オブジェクトファイル）

- find-static-library=(静的ライブラリ）

- find-shared-library=(動的ライブラリ）
などを指定することができます。
この他にも多くのオプションを指定することができますが、toolsetによってはサポートされていないものもあります。


<h4>特定のライブラリだけビルドする/ビルドしない</h4>


--with-<i>library</i> や --without-<i>library</i> と書くことで、特定のライブラリだけビルドする/ビルドしないを切り替えられます。

例えば --with-python とすれば、python ライブラリだけをビルドします。 --without-iostreams とすれば、iostreams ライブラリをビルドしません。



documented boost version is 1.53.0


