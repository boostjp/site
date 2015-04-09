#Boostライブラリのビルド方法

ここではBoostライブラリのビルド方法について説明します。

Windowsとそれ以外に分けて説明します。また、LinuxではBoostライブラリがディストリビューションによって提供されていることがありますが、ここではビルド方法のみを扱います。

1.47.0からbjamだけではなく、b2も生成されるようになりました。また、公式がbjamからb2での説明に切り替わっています。なので、こちらもそれに合わせることにします。


##ダウンロード
現在の最新バージョンは、以下からダウンロードできます：

- [http://www.boost.org/users/download/#live](http://www.boost.org/users/download/#live)


開発バージョンは、Githubから取得できます：

- [https://github.com/boostorg](https://github.com/boostorg)

Github から clone する場合、具体的には [boostorg/boost](https://github.com/boostorg/boost) を clone し、実際の Boost ライブラリ群は `git submodule` で扱います。新たに clone する場合は次のように `--recursive` オプションを付けて clone します。

```sh
git clone --recursive git@github.com:boostorg/boost.git
```

もし、 `--recursive` せずに clone した場合や、`checkout` に伴い必要な場合には次のようにします。

```
cd boost
git submodule --init --recursive
```

##Windowsの場合
手順はここ([http://www.boost.org/doc/libs/release/more/getting_started/windows.html](http://www.boost.org/doc/libs/release/more/getting_started/windows.html))に書かれていますのでそれを翻訳します。


解凍したディレクトリに移動します。

```
> cd (解凍したディレクトリ)
```

以下のコマンドを実行します。

```
> bootstrap.bat
```

すると、b2.exe,bjam.exeが生成されます。

単になんの指定もしないビルドでは：

```
> b2.exe install -j2 --prefix=(インストールしたいディレクトリ)
```

となります。これでビルドし、インストールされるのを待つだけです。

Vista/7以降のWindows OSを使っている場合は、`--prefix=`で指定するディレクトリにはProgram FilesのようなCドライブの管理者権限が必要になるディレクトリは避けてください。権限がない場合はインストールに失敗しますのでご注意を。



##Windows以外、Linux/Macなどの場合
手順はここ([http://www.boost.org/doc/libs/release/more/getting_started/unix-variants.html](http://www.boost.org/doc/libs/release/more/getting_started/unix-variants.html))に書かれているのでそれを翻訳します。


解凍したディレクトリに移動します。

```
$ cd (解凍したディレクトリ)
```

以下のコマンドを実行します：

```
$ bootstrap.sh
```

これで実行可能ファイルのbjamおよびb2が生成されます。

単になんの指定もしないビルドでは：

```
$ ./b2 install -j2 --prefix=(インストールしたいディレクトリ)
```

となります。

Linuxを使っており、ディストリビューション提供のboostライブラリをインストールしている場合は、`--prefix`で<u>`/usr`以外を必ず指定</u>してください。`--prefix`を省略した場合`/usr/local`が選択されますが、多くの環境では$PATHの解決順序の関係上無条件で/usr/local上のBoostが選択されてしまうでしょう。

`/usr`以下を使用すると環境を壊すことになりかねないので、通常は`$HOME/local`や`$HOME/boost_1_51_0`といったディレクトリを用意するのが良いでしょう。

一部のディストリビューションでは$HOME/localを$PATHにデフォルトで登録しているものもあるので、複数人で共用している場合には便利です。


###並列ビルド
一般的なmake同様に、複数CPUを使ってビルドできます。`-j 8`のように、`-j N`と指定するとN個並列でビルド処理が実行されます。**これを指定しないとビルドが非常に遅くなるので、基本的に常に指定することをおすすめします。**

Nの数は、一般的にはCPUの物理コア数または物理コア数+1を指定することが多いようです。経験的に+1することでIO waitが隠蔽されるのを期待できます。

ノートPCだと熱が大変なことになるので、気になるようなら少し少なめにしても良いかもしれません。

***

**※ここからは完全に蛇足です。**

###b2/bjamが受け取るコマンド

`b2 --help`では多くのユーザーが期待するヘルプを参照することはできません。

b2およびbjamに関するヘルプを参照するにはboostを解凍したディレクトリ上で`b2 --help`を行なってください。


以下に紹介するb2/bjamへの引数に順序はありません。どのような順で指定しても正しく解釈されます。



コマンドラインの例:

```
./b2 toolset=msvc link=static,shared address-model=64 install
```

###プロパティ

####toolset
ひとつのマシンに複数種類のコンパイラがインストールされている場合はtoolsetコマンドで指定ができます。例えば、以下の指定が可能です。

| コンパイラ指定 | 説明 |
|----------------|----------------------------------------|
| `borland`      | Borland社のコンパイラ                  |
| `dmc`          | Digital Mars社のコンパイラ             |
| `darwin`       | Apple社の手によるgccコンパイラ(Mac OS) |
| `gcc`          | GNU プロジェクトによるコンパイラ       |
| `intel`        | Intel社によるコンパイラ                |
| `msvc`         | Microsoft社によるコンパイラ            |

msvc-9.0 (Visual C++ 2008)、msvc-10.0 (Visual C++ 2010)のように、コンパイラのバージョン指定も可能です。


####link
これはstatic, sharedライブラリを作るかどうかの指定をするコマンドです。以下のように指定して使用します。

```
link=static,shared
```

環境によって、以下のようなライブラリファイルを生成します。

|        | Windows | Mac OSX | Other Systems |
|--------|---------|---------|---------------|
| static | .lib    | .a      | .a            |
| shared | .dll    | .dylib  | .so           |



####threading

| 引数   | 説明                                       |
|--------|--------------------------------------------|
| multi  | マルチスレッドなライブラリを生成します。   |
| single | シングルスレッドなライブラリを生成します。 |

筆者の環境ではsingleがエラーが出てコンパイルできなかった。 (~~[#7105](https://svn.boost.org/trac/boost/ticket/7105)~~)

trunkで修正済み 1.53.0で修正されると思われる


####variant

| 引数    | 説明                         |
|---------|------------------------------|
| debug   | デバッグビルドを生成します。 |
| release | リリースビルドを生成します。 |


####デフォルトプロパティ
Windows環境においてはデフォルトで以下のプロパティが使用されます。

```
link=static threading=multi variant=debug,release runtime-link=shared
```


Linux環境においてはデフォルトで以下のプロパティが使用されます。

```
link=static,shared threading=multi variant=release
```

その他の環境についてはアンドキュメントとなっているので注意してください。


###アーキテクチャ
ターゲットアーキテクチャが異なる場合には、b2/bjamに`architecture=<target-architecture>`を指定すればよい。

`<target-architecture>`に指定できる値は以下のとおりです。


| 引数  | 説明 |
|-------|------------------|
| x86   | IA-32/x86_64向け |
| ia64  | IA-64向け        |
| arm   | Arm向け          |
| power | Power-PC向け     |
| sparc | Sparc向け        |

ただしtoolsetによってはサポートされていない場合があります。


###アドレスモデル
異なるアドレスモデルでビルドするにはb2/bjamに以下を指定する。

| 引数             | 説明 |
|------------------|------------------------------------|
| address-model=32 | 32ビットのライブラリを生成します。 |
| address-model=64 | 64ビットのライブラリを生成します。 |


###レイアウト
Boostをビルドする際にb2/bjamが生成するバイナリファイル名はデフォルトで環境によって異なります。

これは`--layout=<layout>`を渡すことで変更できます。`<layout>`に渡すことのできる値は以下のとおりです。


| 引数      | 説明 |
|-----------|------|
| versioned | バイナリファイル名にバージョンが入ります。Windowsではデフォルトでversionedが選択されます。 |
| tagged    | ビルド時に指定したプロパティ（variantやthreading等）がバイナリファイル名に含まれます。ただし、コンパイラ名、コンパイラのバージョン、Boostのバージョンは入りません。 |
| system    | システムへインテグレートするためにバージョン番号などは入りません。Unixではデフォルトでsystemが選択されます。 |


###ビルドのクリーン

`--clean`を渡すことでビルドをクリーンすることが可能です。

ただし、b2/bjamはプロパティなどの差から異なるビルドを生成します。その為クリーン対象のビルドと同一のプロパティを指定した上で`--clean`を渡す必要があります。


###コンパイラオプション、リンカオプション
ビルドする際にコンパイラやリンカにオプションを渡す必要がある場合は、b2/bjamの引数に以下を指定できます。

- cflags=(Cコンパイラオプション)
- cxxflags=(C++コンパイラオプション)
- linkflags=(リンカオプション)
- define=(プリプロセッサシンボル）
- include=(追加インクルードパス）
- library-path=(追加ライブラリパス）
- library-file=(追加オブジェクトファイル）
- find-static-library=(静的ライブラリ）
- find-shared-library=(動的ライブラリ）

この他にも多くのオプションを指定することができますが、toolsetによってはサポートされていないものもあります。


###特定のライブラリだけビルドする/ビルドしない

`--with-`*library* や `--without-`*library* と書くことで、特定のライブラリだけビルドする/ビルドしないを切り替えられます。

例えば `--with-python` とすれば、python ライブラリだけをビルドします。 `--without-iostreams` とすれば、iostreams ライブラリをビルドしません。


documented boost version is 1.53.0


