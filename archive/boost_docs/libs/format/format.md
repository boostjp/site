#The Boost Format library

`<boost/format.hpp>` `format `クラスは `printf` に似た、ユーザ定義型も扱える型安全な書式化処理を提供する。 

(このライブラリは他の `boost` ライブラリに依存しない)


##目次
- [概要](#synopsis)
- [どのように作用するか](#how-it-works)
- [コード例](#examples)
- [サンプルファイル](#sample-files)
- [構文](#syntax)
	- [printfフォーマット仕様](#printf-format-specifications)
	- [新たなフォーマット仕様](#new-format-specifications)
	- [printfとの振る舞いの違い](#differences-of-behavior-vs-printf)
- [ユーザー定義型の出力](#user-defined-types-output)
- [マニピュレータと、内部的なストリーム状態](#manipulators-and-the-internal-stream-state)
- [代替手段](#alternatives)
- [例外](#exceptions)
- [抜粋](#extract)
- [設計原理](#rationale)
- [クレジット](#credits)


## <a name="synopsis" href="synopsis">概要</a>
`format` オブジェクトは書式文字列から構築され、その後 `operator%` を繰り返し呼び出されることで引数を与えられる。 

それぞれの引数は文字列に変換され、書式文字列に従って順に一つの文字列へと結合される。

```cpp
cout << boost::format("writing %1%,  x=%2% : %3%-th try") % "toto" % 40.23 % 50; 
     // "writing toto,  x=40.230 : 50-th try"と表示
```


## <a name="how-it-works" href="how-it-works">どのように作用するか</a>

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


## <a name="examples" href="examples">コード例</a>

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


## <a name="sample-files" href="sample-files">サンプルファイル</a>
[sample_formats.cpp](./example/sample_formats.cpp.md) は `format` の簡単な使い方をデモする。

[sample_new_features.cpp](./example/sample_new_features.cpp.md) は、単純な位置指定命令、中寄せ、そして「桁送り」など、 `printf` の構文に追加された書式化機能のいくつかを説明する。

[sample_advanced.cpp](./example/sample_advanced.cpp.md) は、 `format` オブジェクトの 再利用や修飾といった、さらに進んだ機能の使い方をデモする。

そして [sample_userType.cpp](./example/sample_userType.cpp.md) はユーザ定義型に対する `format` の振る舞いを示す。


## <a name="syntax" href="syntax">構文</a>

```cpp
boost::format( format-string ) % arg1 % arg2 % ... % argN
```

**format-string** は特殊な命令を含むテキストである。これらの命令は、与えられた引数の書式化結果の文字列によって置換される。 

C/C++ の世界におけるレガシーな構文は `printf` で使われているものである。そのため `format` は `printf` の書式文字列をそのまま利用でき、同じ結果を生成する。(ほとんどの場合において。詳細は [`printf`との違い](#differences-of-behavior-vs-printf) を見よ) 

この中核となる構文は、新機能を許すだけでなく、 C++ のストリームの文脈に適合するために拡張された。そのため、 `format` は書式文字列のさまざまな形式の命令を受け付ける :

- レガシーな `printf` の書式文字列 : `%spec`　ここで **spec** は `printf` の書式指定子である 
	- **spec** は幅、アライメント、数値を書式化する際の基数、その他の特殊なフラグなどの書式化オプションを渡す。 しかし `printf` の古典的な型指定フラグは `format` ではより弱い意味しか持たない。 `format` は内部ストリームと書式化パラメータのどちらかまたは両方に適当なフラグをセットするだけで、対応する引数が指定した型であるかどうかは問わない。 
	- 例 : `2$x` という指定子は、 `printf` にとっては「整数である二つ目の引数を16進数で出力する」という意味であるが、 `format` においては「二つ目の引数を、ストリームの `basefield` フラグを `hex` にセットして出力する」という意味でしかない。
- `%|spec|` ここで **spec** は `printf` の書式指定子である。 
	- 括弧[訳注：米英語では、二つの記号の組み合わせで何かを囲むものはすべてbracket(括弧)と呼び、ここでは縦棒 `|` 二つを括弧と呼んでいる]は書式文字列の可読性を改善するが、本来は **spec** の型変換文字を省略可能にするために導入された。この情報は C++ の変数には不要だが、 `printf` の構文をそのまま用いる場合には、書式指定子の終端を決定するために必要だというだけの理由で、常に型変換文字を与える必要がある。 
	- 例 : `"%|-5|"` は 次の変数を幅を 5 、左寄せにフォーマットする。これは `printf` の以下の命令と同じものである : `"%-5g"`, `"%-5f"`, `"%-5s"` ..
- `%N%`
	- この単純な位置指定の表記は、 N 番目の引数を書式化オプションなしでフォーマットするよう要求するものである。 
	- (これは `printf` の位置指定命令(`"%N$s"` のような)の短縮形に過ぎないが、ずっと読みやすく、また「型変換指定」文字を用いないですむというご利益がある)

`printf` の標準の書式指定子に加えて、中寄せのような新しい機能が実装されている。詳細は [new format specification](#new-format-specifications) を参照。


### <a name="printf-format-specifications" href="printf-format-specifications">printfフォーマット仕様</a>
Boost.Format でサポートされる `printf` の書式指定子は、引数の位置指定をサポートしない標準 C の `printf` よりも、むしろ Unix98 [Open-group printf](http://www.opengroup.org/onlinepubs/7908799/xsh/fprintf.html) の構文に従っている。 (両者の間では共通のフラグは同じ意味を持つので、誰も頭痛に悩まされることはない) 

なお、一つの書式文字列に位置指定付きの書式指定子(例．`%3$+d`)と位置指定なしのもの(例．`%+d`)を混ぜて使用するのはエラーである。 
Open-group の仕様では同じ引数を複数回参照すること(例．`"%1$d %1$d"`)は未定義動作であるが、 Boost.Format では各引数を何度でも参照できる。ただ一つの制約は、書式文字列に現れる最大の引数の数が P であるとき、必ず P 個の引数を期待することである。(例．`"%1$d %10$d"` ならば P == 10) 

引数の数が多すぎても少なすぎても例外が起こる。 (そうでないようにセットされていなければ。 [exceptions](#exceptions) を参照)


書式指定子 **spec** は次の形式を持つ : [ **N**`$` ] [ **flags** ] [ **width** ] [ . **precision** ] **type-char**

大括弧で囲われたフィールドは省略可能である。 各フィールドは以下のリストのように説明される :

- **N**`$` (省略可能なフィールド)は、その書式指定子が N 番目の引数に適用されると指定する。(これは **位置指定書式指定子** と呼ばれる) 
- これが与えられない場合、引数は前から順番に解釈される。(ただし、その後に引数番号付きの書式指定子を与えるのはエラーである)
- **flags** は以下の任意のシーケンスである :

| フラグ | 意味 | 内部ストリームへの作用 |
|--------|------|------------------------|
| `'-'`  | 左寄せ | N/A (後で文字列に適用される) |
| `'='`  | 中寄せ | N/A (後で文字列に適用される)<br/> `printf` には存在しない(追加機能) |
| `'+'`  | 正の数であっても符号を表示する | `showpos` をセットする |
| `'#'`  | 基数および小数点を表示する     | `showbase` と `showpoint` をセットする |
| `'0'`  | 0 で穴埋めする(符号および基数表示の後に挿入)	左寄せでない場合、 `setfill('0')` を呼び出し `internal` をセットする<br/> [ユーザ定義型](#user-defined-types-output)を扱うためにストリーム変換の後に追加の動作を行う |
| `' '`  | 文字列が `+` または `-` から始まらない場合、変換された文字の前にスペースを挿入 | N/A (後で文字列に適用される) <br/> `printf` のものとは挙動が異なる : 内部のアライメントには影響されない |

- **width** は変換の結果文字列に対する最小の幅を指定する。 必要ならば、文字列はアライメントにあわせてパディングされ、文字で埋める。この文字はマニピュレータ経由でストリームにセットされたものか、あるいは書式文字列で指定された文字(例． `'0'`, `'-'`, ... などのフラグ)である。 
	- この幅は変換ストリームにセットされるのではないことに注意してほしい。 ユーザ定義型の出力をサポートする(これはいくつかのメンバに `operator<<` を何度も呼び出すことになりうる)ため、幅の取り扱いはすべての引数オブジェクトのストリーム変換の後に、 `format` クラスのコードの中で行われる。
- **precision** (小数点の後に続く)はストリームの精度をセットする。
	- 浮動少数点型の数値を出力する場合、
		- 固定小数点表示モードまたは指数表示モードでは、小数点より後ろの数字の最大文字数を設定する。
		- デフォルトモード(%g のような'ジェネラルモード')では、全体の数字の最大文字数を設定する。
	- **type-char** が `s` または `S` の場合は別の意味を持つ : 変換文字列は最初の **precision** 文字で切り詰められる。 (**width** によるパディングは、この切り詰めの後で施される。)
- **type-char** 。これは、対象になっている引数が指定した型のいずれかであることを強要しない。その型指定子に関連付けられたフラグをセットするだけである。

| 型変換指定文字 | 意味 | ストリームへの作用 |
|----------------|------|--------------------|
| `p` または `x` | １６進数で出力 | `hex` をセットする |
| `o`            | ８進数で出力   | `oct` をセットする |
| `e`            | 浮動小数点数の指数表記 | `floatfield` ビットを `scientific` にセットする |
| `f`            | 浮動小数点数の固定小数点表記	`floatfield` ビットを `fixed` にセットする |
| `g`            | 一般的な(デフォルトの)浮動小数点表記 | すべての `floatfield` ビットを**外す** |
| `X`, `E` または `G` | それぞれの小文字と同じように作用。ただし数値の出力に際して大文字を用いる。(指数、１６進数、..) | `'x'`, `'e'`, または `'g'` と同じ作用に**加え**、 `uppercase` をセットする。 |
| `d`, `i` または `u` | １０進数で出力 | `basefield` ビットを `dec` にセットする |
| `s` または `S` | 文字列を出力 | **precision** 指定子が外され、値は後の'切り詰め'のために内部フィールドへ送られる。 (上記の **precision** の説明を参照) |
| `c` または `C` | １文字出力 | 変換文字列の最初の文字のみが用いられる。 |
| `%` | 文字`%`を表示 | N/A |

`'n'` 型指定子は、こうした流れに合わないので、無視される(そして対応する引数も)。 

また、 `printf` の `'l'`, `'L'`, あるいは `'h'` 修飾子(ワイド、ロングおよびショート型を示す)もサポートされている(が、内部ストリームには何の作用もしない)。


### <a name="new-format-specifications" href="new-format-specifications">新たなフォーマット仕様</a>

- 前述の表で述べたように、中寄せフラグ `'='` が追加された。
- `%{n`**t**`}` は絶対桁送りを挿入する。ここで n は正の数である。 すなわち `format` は、必要であれば、作成済みの文字列の長さが n 文字に届くまで文字で埋め込む。 ([examples](#examples) を参照)
- `%{n`**T**`X}` も同様に桁送りを挿入するが、埋め込む文字としてストリームの現在の「埋め込み」文字の代わりに `X` を用いる。 (デフォルト状態のストリームではスペースを埋め込む)


### <a name="differences-of-behavior-vs-printf" href="differences-of-behavior-vs-printf">printfとの振る舞いの違い</a>
`x1`, `x2` という二つの変数(組み込み型で、 C の `printf` でサポートされているもの)と書式文字列`s`があって、 `printf` 関数で以下のように使われるとする :

```cpp
printf(s, x1, x2);
```

ほとんどすべてのケースで、その結果はこの命令と同じものになる :

```cpp
cout << format(s) % x1 % x2;
```

しかしいくつかの `printf` 書式指定子はストリームの書式化オプションに上手く翻訳されないため、 Boost.Format の `printf` エミュレーションには注意すべき僅かな不完全性がある。

`format` クラスは、 `printf` の書式文字列を常に受け付けてほとんど同じ出力を生成するように、どのような場合でもサポートしないオプションを黙って無視する。 

以下はそうした相違点のすべての一覧である :

- `'0'` および `' '` オプション : `printf` は数値以外の変換でこれらのオプションを無視するが、 `format` は変数のあらゆる型にそれらを適用する。 (そのためこれらのオプションをユーザ定義型に対して用いることができる。例． `Rational` クラスなど)
- 汎整数型の引数に対する **precision** は `printf` では特別な意味を持つ : 
	- `printf( "(%5.3d)" , 7 ) ;` は `«( 007) »` と出力する。 
	- 一方で `format` は、ストリームと同様に、汎整数型への変換に対する精度パラメータを無視する。
- `printf` の `'` オプション (三桁ごとに数値をグループ化する書式)) は `format` では無効である。
- `printf` では、幅または精度がアスタリスク (`*`) にセットされている場合、その値を与えられた引数から読み取る。例． `printf("%1$d:%2$.*3$d:%4$.*3$d\n", hour, min, precision, sec);` [訳注：この例では、 `min` と `sec` を表示する際の精度は第三引数 `precision` の値が用いられる。 `precision=3` なら `"%.3d"` だし、 `precision=10` なら `"%.10d"` になる。] 
	- このクラスは現在のところ、このメカニズムをサポートしない。そのためこのような精度または幅フィールドは構文解析の時点で黙って無視される。

同様に、特殊な `'n'` 型指定子 (書式化によって出力された文字数を変数に格納するよう `printf` に命じるのに用いる) は `format` では無効である。

そのためこの型指定子を含む書式文字列は `printf` でも `format` でも同じ変換文字列を生成する。 `printf` と `format` で書式化された文字列に違いは生じない。 

Boost.Format で書式化された文字数をを得るには以下のようにする :

```cpp
format formatter("%+5d");
cout << formatter % x;
unsigned int n = formatter.str().size();
```

## <a name="user-defined-types-output" href="user-defined-types-output">ユーザー定義型の出力</a>
ストリーム状態の修飾に翻訳されたすべてのフラグは、ユーザ定義型にも再帰的に作用する。 ( フラグはアクティブなまま残るので、 ユーザ定義クラスによって呼ばれる各々の `<<` 演算に対しても、期待するオプションが渡される) 

例．妥当なクラス `Rational` なら次のようになる :

```cpp
Rational ratio(16,9);
cerr << format("%#x \n")  % ratio;  // -> "0x10/0x9 \n"
```

その他の書式化オプションでは話は異なる。例えば、幅の設定はオブジェクトによって生成される最終出力に適用され、内部の各々の出力には適用されない。これは都合のいい話である :

```cpp
cerr << format("%-8d")  % ratio;  // -> "16/9    " であって、 "16      /9       " ではない
cerr << format("%=8d")  % ratio;  // -> "  16/9  " であって、 "   16   /    9   " ではない
```

しかし、 `0` や `' '` オプションにも同様に働くため、不自然なことになってしまう。(意地の悪いことに、 `'+'` が `showpos` によってストリームの状態へと直接翻訳できるのに対して、 `printf` のゼロやスペースに当たるオプションはストリームには存在しない) :

```cpp
cerr << format("%+08d \n")  % ratio;  // -> "+00016/9"
cerr << format("% 08d \n")  % ratio;  // -> "000 16/9"
```

## <a name="manipulators-and-the-internal-stream-state" href="manipulators-and-the-internal-stream-state">マニピュレータと、内部的なストリーム状態</a>
`format` の内部ストリームの状態は、引数を出力する直前に保存され、直後に復帰される。そのため、修飾子の影響は後まで引きづられずに、適用される引数にだけ作用する。 

ストリームのデフォルト状態は標準で述べられているように : 精度 6 、幅 0 、右寄せ、そして１０進数基数である。

`format` ストリームの内部ストリームの状態は引数と一緒に渡されるマニピュレータによって変えることができる； `group` 関数を経由して以下のようにできる :

```cpp
cout << format("%1% %2% %1%\n") % group(hex, showbase, 40) % 50; // "0x28 50 0x28\n" と表示
```

`group` の内側にある N 個の項目を渡すとき、 Boost.Format はマニピュレータに通常の引数とは異なる処理をする必要がある。そのため、 `group` の使用には以下の制限がある :

1. 表示されるオブジェクトは `group` の最後の項目として渡されなければならない
2. 先頭の N-1 個の項目はマニピュレータとして扱われるので、出力を生成しても破棄される

マニピュレータは、それが現れるごとに、後に続く引数の直前にストリームに渡される。 書式文字列で指定された書式化オプションは、この方法で渡されたストリーム状態修飾子によって上書きされる点に注意して欲しい。 例えば以下のコードで、 `hex` マニピュレータは、書式文字列の中で１０進数出力を設定している型指定子 d よりも高い優先度を持つ :

```cpp
cout << format("%1$d %2% %1%\n") % group(hex, showbase, 40) % 50; 
// "0x28 50 0x28\n" と表示
```

## <a name="alternatives" href="alternatives">代替手段</a>
- *printf* は古典的な代替手段である。型安全でなく、ユーザ定義型に対して拡張可能ではない。
- [ofrstream.cc](http://www.ece.ucdavis.edu/~kenelson/ofrstream.cc) Karl Nelson によるデザインはこの `format` クラスへのインスピレーションの大きな源となった。
- [format.hpp](http://groups.yahoo.com/group/boost/files/format/) Rüiger Loo による。 `boost:format` クラスの以前の提案だった。 デザインの簡易さにおいてこのクラスの起源である。最小主義的な `"%1 %2"` という構文はこのクラスでも借用している。
- [James Kanze's library](http://www.gabi-soft.de/code/gabi-lib.tgz) は非常に洗練された `format` クラス (`srcode/Extended/format`) を持っている。 そのデザインは、実際の変換に内部ストリームを用いる点や引数渡しに演算子を用いる点で、このクラスと共通している。 (しかし彼のクラス `ofrstream` は `operator%` ではなく `operator<<` を用いている)
- [Karl Nelson's library](http://groups.yahoo.com/group/boost/files/format3/) は、 Boost.Format のデザインのための boost メーリングリストの討論において、別の解決法を示すために用意された。


## <a name="exceptions" href="Exceptions">例外</a>
Boost.Format は `format` オブジェクトの使い方にいくつかのルールを強要する。書式文字列は前述の構文に従わなくてはならず、ユーザは最終的な出力までに正しい個数の引数を供給しなければならない。また `modify_item` や `bind_arg` を用いるなら、項目や引数のインデックスが範囲外を指してはならない。

ミスが見過ごされたり放置されたりしないように、 `format` はいずれかのルールが満たされていないことを検出すると対応する例外を発生する。

しかしユーザはこの振る舞いを必要に応じて変えることができる。また、どのエラーの型が発生するかを次の関数を用いて選択できる :

```cpp
unsigned char exceptions(unsigned char newexcept); // クエリおよび設定
unsigned char exceptions() const;                  // クエリのみ
```

ユーザは、以下のアトムを２進演算で結合することで引数 `newexcept` を算出できる :

- `boost::io::bad_format_string_bit` 書式文字列が適切でなければ例外を発生する。
- `boost::io::too_few_args_bit` すべての引数が渡される前に結果の文字列を尋ねられたとき、例外を発生する。
- `boost::io::too_many_args_bit` 渡された引数の数が多すぎれば例外を発生する。
- `boost::io::out_of_range_bit` `modify_item` や項目インデックスを取る他の関数の呼び出し(および引数のインデックス）の際に、ユーザの与えたインデックスが範囲外であれば例外を発生する。
- `boost::io::all_error_bits` すべてのエラーで例外を発生する。
- `boost::io::no_error_bits` いずれのエラーでも例外を発生しない。

例えば、 Boost.Format が引数の個数をチェックしないようにしたければ、適切な例外設定を施した `format` オブジェクトを作る特殊なラッパ関数を定義する :

```cpp
boost::format my_fmt(const std::string & f_string) {
    using namespace boost::io;
    format fmter(f_string);
    fmter.exceptions( all_error_bits ^ ( too_many_args_bit | too_few_args_bit )  );
    return fmter;
}
```

すると、必要とされるよりも多くの引数を与えても許される(単に無視される) :

```cpp
cout << my_fmt(" %1% %2% \n") % 1 % 2 % 3 % 4 % 5;
```

また、すべての引数が与えられる前に結果を問い合わせると、結果の対応する部分は単に空になる

```cpp
cout << my_fmt(" _%2%_ _%1%_ \n") % 1 ;
// prints      " __ _1_ \n"
```

## <a name="extract" href="extract">抜粋</a>

```cpp
namespace boost {

template<class charT, class Traits=std::char_traits<charT> > 
class basic_format 
{
public:
  typedef std::basic_string<charT, Traits> string_t,
  basic_format(const charT* str);
  basic_format(const charT* str, const std::locale & loc);
  basic_format(const string_t& s);
  basic_format(const string_t& s, const std::locale & loc);

  string_t str() const;

  // pass arguments through those operators :
  template<class T>  basic_format&   operator%(T& x);  
  template<class T>  basic_format&   operator%(const T& x);

  // dump buffers to ostream :
  friend std::basic_ostream<charT, Traits>& 
  operator<< <> ( std::basic_ostream<charT, Traits>& , basic_format& ); 

// ............  これはただの抜粋である .......
}; // basic_format

typedef basic_format<char >          format;
typedef basic_format<wchar_t >      wformat;


namespace io {
// free function for ease of use :
template<class charT, class Traits> 
std::basic_string<charT,Traits>  str(const basic_format<charT,Traits>& f) {
      return f.str();
}
} //namespace io


} // namespace boost
```

## <a name="rationale" href="rationale">設計原理</a>
このクラスのゴールは、より良い、 C++ 用の、型安全かつ型拡張性のある `printf` の等価物が、 ストリームとともに用いられるようにすることである。

正確には、 `format` は以下の機能を実現するようデザインされた :

- 引数の位置指定のサポート(国際化に必要)
- 個数無制限の引数を許す。
- 書式化命令の見た目を自然にする。
- 書式文字列の構文に加えて、引数の出力を修飾するためのマニピュレータをサポー ト。
- あらゆる型の変数を受け付ける。文字列への実際の変換はストリームに任せる。 これは特にユーザ定義型について、書式化オプションの作用が直観的に自然なものとなるよう考慮したものである。
- `printf` 互換性の提供、型安全で型拡張性のある文脈においてもできるだけ意味をなすようにする。

デザインの過程で多くの問題に直面し、いくつかの選択をすることになったが、 中には直観的には正しくないものもあった。しかしいずれのケースにも [何らかの意味がある](./choices.md)。


## <a name="credits" href="credits">クレジット</a>
Boost.Format の著者は Samuel Krempp である。彼は Rüiger Loos と Karl Nelson の両者の `format` クラスのアイディアを利用した。


***
February 19, 2002

© Copyright Samuel Krempp 2002. Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies. This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

Japanese Translation Copyright © 2003 [Kent.N](kn@mm.neweb.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

 
