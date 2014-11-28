#The Boost Format library

`<boost/format.hpp>` `format `クラスは `printf` に似た、ユーザ定義型も扱える型安全な書式化処理を提供する。 

(このライブラリは他の `boost` ライブラリに依存しない)


##目次
- [Synopsis](#synopsis)
- [How it works](#hot-it-works)
- [Examples](#examples)
- [Sample Files](#sample-files)
- Syntax
	- printf format-specification syntax
	- Incompatibilities with printf
- Manipulators and the internal stream state
- User-defined types
- Exceptions
- Alternatives


## <a name="synopsis" href="synopsis">Synopsis</a>
`format` オブジェクトは書式文字列から構築され、その後 `operator%` を繰り返し呼び出されることで引数を与えられる。 

それぞれの引数は文字列に変換され、書式文字列に従って順に一つの文字列へと結合される。

```cpp
cout << boost::format("writing %1%,  x=%2% : %3%-th try") % "toto" % 40.23 % 50; 
     // "writing toto,  x=40.230 : 50-th try"と表示
```


## <a name="hot-it-works" href="hot-it-works">How it works</a>

1.書式文字列 `s` を伴って `format(s)` を呼び出すと、あるオブジェクトが構築される。このオブジェクトは、書式文字列を構文解析してすべての命令を探し、次のステップのために内部構造を準備する。
2.そして、すぐに

```cpp
cout << format("%2% %1%") % 36 % 77 )
```

のようにするか、あるいは後で、

```cpp
format fmter("%2% %1%");
fmter % 36; fmter % 77;
```

とすることで、フォーマッタに変数を食わせることができる。 

変数は内部のストリームにダンプされる。ストリームの状態は、与えられた書式文字列の書式化オプション(あれば)によってセットされる。 `format` オブジェクトは最後のステップのための結果文字列を保持する。

3.すべての引数を与えてしまえば、その `format` オブジェクトをストリームにダンプしたり、メンバ関数 `str()` か名前空間 `boost::io` にある `str(const format&)` 関数で文字列を取り出すことができる。結果の文字列は、別の引数が与えられて再初期化されるまで、 `format` オブジェクトの中にアクセス可能な状態で残る。

```cpp
// 先ほど作って引数を与えた fmter の結果を表示:
cout << fmter ;  

// 結果の文字列を取り出せる:
string s  = fmter.str();

// 何度でも:
s = fmter.str( );

// すべてのステップを一度に行うこともできる:
cout << boost::format("%2% %1%") % 36 % 77; 
string s2 = boost::io::str( format("%2% %1%") % 36 % 77 );
```

4.ステップ３の後で `format` オブジェクトを再利用し、ステップ２からやり直すこともできる: `fmter % 18 % 39;`
新しい変数を同じ書式文字列で書式化する際は、こうすることでステップ１で生じる高価な処理を節約できる。

結局のところ、 `format` クラスは、書式文字列(`printf` に似た命令を用いる)を内部のストリームへの操作に翻訳する。そして最終的に、その書式化の結果を文字列として、あるいは直接に出力ストリームへと返す。


## <a name="examples" href="examples">Examples</a>

```cpp
using namespace std;
using boost::format;
using boost::io::group;
using boost::io::str;
```

- 並べ替えありの単純な出力:

```cpp
cout << format("%1% %2% %3% %2% %1% \n") % "11" % "22" % "333"; // '単純な'形式。
```

表示はこうなる : `"11 22 333 22 11 \n"`


- POSIX 版 `printf` の位置指定命令を用いた、より精細な書式化:

```cpp
cout << format("(x,y) = (%1$+5d,%2$+5d) \n") % -23 % 35;     // POSIX版Printf形式
```

表示はこうなる : `"(x,y) = ( -23, +35) \n"`


- 並べ替えのない、古典的な `printf` の命令:

```cpp
cout << format("writing %s,  x=%s : %d-th step \n") % "toto" % 40.23 % 50; 
```

表示はこうなる : `"writing toto, x=40.23 : 50-th step \n"`


- 同じことを表現するにもいろいろな方法がある:

```cpp
cout << format("(x,y) = (%+5d,%+5d) \n") % -23 % 35;
cout << format("(x,y) = (%|+5|,%|+5|) \n") % -23 % 35;

cout << format("(x,y) = (%1$+5d,%2$+5d) \n") % -23 % 35;
cout << format("(x,y) = (%|1$+5|,%|2$+5|) \n") % -23 % 35;
```

表示はどれも : `"(x,y) = ( -23, +35) \n"`


- マニピュレータによる書式文字列の修飾:

```cpp
format fmter("_%1$+5d_ %1$d \n");

format fmter2("_%1%_ %1% \n");
fmter2.modify_item(1, group(showpos, setw(5)) ); 

cout << fmter % 101 ;
cout << fmter2 % 101 ;
```

どちらも同じように表示する : `"_ +101_ 101 \n"`


- 引数を伴うマニピュレータ:

```cpp
cout << format("_%1%_ %1% \n") % group(showpos, setw(5), 101);
```

マニピュレータは、 `%1%` が現れるたびに適用されるので、出力はこうなる : `"_ +101_ +101 \n"`


- 新しいフォーマット機能「絶対桁送り(absolute tabulations)」はループの中で使うと便利である。これはあるフィールドを各行の同じ位置に出力する機能で、たとえ直前の引数の幅が大きく変化したとしても、同じ位置に出力することを保証してくれる。

```cpp
for(unsigned int i=0; i < names.size(); ++i)
    cout << format("%1%, %2%, %|40t|%3%\n") % names[i] % surname[i] % tel[i];
```

`names` 、 `surnames` 、そして `tel` などのベクタ(sample_new_features.cpp を参照)は次のように表示される :

```
Marc-Françis Michel, Durand,           +33 (0) 123 456 789
Jean, de Lattre de Tassigny,           +33 (0) 987 654 321
```


## <a name="sample-files" href="sample-files">Sample Files</a>
[sample_formats.cpp](./example/sample_formats.cpp.md) は `format` の簡単な使い方をデモする。

[sample_new_features.cpp](./example/sample_new_features.cpp.md) は、単純な位置指定命令、中寄せ、そして「桁送り」など、 `printf` の構文に追加された書式化機能のいくつかを説明する。

[sample_advanced.cpp](./example/sample_advanced.cpp.md) は、 `format` オブジェクトの 再利用や修飾といった、さらに進んだ機能の使い方をデモする。

そして [sample_userType.cpp](./example/sample_userType.cpp.md) はユーザ定義型に対する `format` の振る舞いを示す。


