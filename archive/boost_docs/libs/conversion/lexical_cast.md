#Header boost/lexical_cast.hpp

- [動機](#motivation)
- [例](#examples)
- [ヘッダ概要](#synopsis)
- [`lexical_cast`](#lexical_cast)
- [`bad_lexical_cast`](#bad_lexical_cast)
- [更新履歴](#changes)

***

## <a name="motivation" href="#motivation">動機</a>
例えば、`int`型のデータを`string`型で表現させるときや、逆に`string`型のインスタンスに格納された数値表現を`int`型に変換するなど、値を文字列の表現に変換しなければならないことがしばしばある。これらは、画面上の表示と設定ファイルの関係のように、プログラムの内部構造を外部に出力する際に良く用いられる手法である。

C/C++標準ライブラリは、先に述べた変換機能の数々を提供するが、それらは使いやすさや拡張性、安全性の面においてまちまちである。

例として、`atoi`に代表されるC標準関数における多くの制限について述べてみよう ：

- 変換は文字列から内部データ型への一方向に限られる。Cライブラリを用いた別の変換方法としては、sprintf関数が存在するが不便で安全性も低い。
- また、`itoa`関数のような非標準の機能を用いる方法もあるが、それでは移植性の低下を招いてしまう。
- サポートする型がプリミティブな数値型の一部(`int`, `long`, `double`)のみである。
- 文字列表現から複素数や有理数への変換のように、サポートする型を増やすことは通常できない。

`strtol`に代表される標準C関数では、いくつかの基本的な制限が存在するものの、変換に関する素晴らしい制御方法を提供してくれる。しかし、普通、そのような制御方法は必要ではないし、使われることもない。`scanf`とその関連する関数では、さらに優れた制御方法を提供してくれるものの、安全性と使いやすさにおいて優秀とは言い難い。

C++標準ライブラリは、ここで問題になっている種類のin-core 整形のために`stringstream` を提供している。これは、文字列による、任意の型と入出力との間の変換と整形に関して幅広く管理する。しかし単純な変換に関して言えば、`stringstream` を直接利用するのは不格好(余計なローカル変数を取る必要があり、中置記法の利便性を失う)であるか、或いは不明瞭になりうる(`stringstream` オブジェクトが式の中で一時的オブジェクトとして作成される場合)。これは多くの面で、包括的な概念及びテキスト表現の管理能力を提供するが、これらは比較的高水準なので、単純な変換のためにも極端に多くのことを巻き込まなければならない。

`lexical_cast`テンプレート関数はテキストで表現可能な任意の型同士の変換を便利で一貫性のある形、簡単に言えば式レベルでの便利な変換を提供する。

精度や書式において`lexical_cast`が標準で行うより柔軟な操作を必要とするとき、`stringstream`の使用を推奨する。また、数値型間の変換を行う場合、[`numeric_cast`](cast.md#numeric_cast)の方が適している。

文字列ベースの表現に関する問題点等に関する議論を扱ったものとして、Herb Sutterの記事 [The String Formatters of Manor Farm](http://www.gotw.ca/publications/mill19.htm)を紹介しておこう。これには、`stringstream`や`lexical_cast`等の比較も含まれている。


## <a name="examples" href="#examples">例</a>
以下のサンプルではコマンドラインから与えられた複数の引数を数値の列に変換している。

```cpp
int main(int argc, char * argv[])
{
    using boost::lexical_cast;
    using boost::bad_lexical_cast;

    std::vector<short> args;

    while(*++argv)
    {
        try
        {
            args.push_back(lexical_cast<short>(*argv));
        }
        catch(bad_lexical_cast &)
        {
            args.push_back(0);
        }
    }
    ...
}
```

以下のサンプルでは文字列の中に数値を埋め込んでいる。

```cpp
void log_message(const std::string &);

void log_errno(int yoko)
{
    log_message("Error " + boost::lexical_cast<std::string>(yoko) + ": " + strerror(yoko));
}
```

***

## <a name="synopsis" href="#synopsis">ヘッダ概要</a>
ライブラリの詳細："boost/lexical_cast.hpp"

```cpp
namespace boost
{
    class bad_lexical_cast;
    template<typename Target, typename Source>
      Target lexical_cast(Source arg);
}
```
* lexical_cast[link #lexical_cast]
* bad_lexical_cast[link #bad_lexical_cast]

テストコード："lexical_cast_test.cpp"


***

## <a name="lexical_cast" href="#lexical_cast">`lexical_cast`</a>
```cpp
template<typename Target, typename Source>
  Target lexical_cast(Source arg);
```

引数として受け取った`arg`を`std::stringstream`に流し込み、`Target`のデータに変換して返す。もし変換が失敗した場合、例外[`bad_lexical_cast`](#bad_lexical_cast)が発生する。

引数と戻り値の型の条件：

- `Source`は`OutputStreamable`（`stream`に出力可能）でなければならない。
	- つまり、`std::ostream`のオブジェクトを左辺に取り、引数の型（`Source`）のインスタンスを右辺に取る`operator<<`が定義されていなければならない。
- `Source`と`Target`は`CopyConstructible`（コピーコンストラクト可能）でなければならない。[20.1.3]
- `Target`は`InputStreamable`（`stream`から入力可能）でなければならない。
	- つまり、`std::istream`のオブジェクトを左辺に取り、戻り値の型（`Target`）のインスタンスを右辺に取る`operator>>`が定義されていなければならない。
- `Target`は`DefaultConstructible`（デフォルトコンストラクト可能）でなければならない。
	- つまり、`Target`のオブジェクトのデフォルト初期化が可能でなければならない。[8.5, 20.1.4]
- `Target`は`Assignable`でなければならない。[23.1]

`stream`におけるベースの文字型は、特にワイド文字を利用した変換を必要としない場合、`char`型を利用し、そうで無ければ、`wchar_t`型を利用する。ベースにワイド文字を必要とするのは、`wchar_t`、`wchar_t *`、`std::wstring`である。

より高度な変換を必要とする場合、`std::stringstream`および`std::wstringstream`を利用することをお勧めする。`stream`の機能の必要のない変換が要求されているのならば、`lexical_cast`を利用することは適さない。そのような特殊なケースための準備を`lexical_cast`は用意してないからである。

***

## <a name="bad_lexical_cast" href="#bad_lexical_cast">`bad_lexical_cast`</a>
```cpp
class bad_lexical_cast : public std::bad_cast
{
public:
    ... // std::exceptionと同様のメンバ関数を持つ
};
```

この例外は[`lexical_cast`](#lexical_cast)が失敗したことを示すために使用される。


## <a name="changes" href="#changes">更新履歴</a>
- 前バージョンの`lexical_cast`は、浮動小数型の変換のために`stream`のデフォルトの精度を利用していたが、現行版においては、`std::numeric_limits`を特殊化している型に関しては、それを元に変換を行うようになった。
- 前バージョンの`lexical_cast`は、任意のワイド文字型の変換をサポートしていなかった。ワイド文字型の完全な言語、ライブラリのサポートがなされているコンパイラにおいては、`lexical_cast`は`wchar_t`、`wchar_t *`、および`std::wstring`の変換をサポートする。
- 前バージョンの`lexical_cast`は、従来型のストリーム抽出演算子が値を読むために充分であると仮定していた。しかしながら、文字列入出力は、その空白文字が、文字列の内容ではなく、入出力セパレータの役目を演じてしまうという結果、非対称なのである。現在のバージョンでは`std::string`と`std::wstring`(サポートされているところでは) のでこの誤りが修正されている。例えば、`lexical_cast<std::string>("Hello, World")` は、`bad_lexical_cast`例外で失敗することなく、成功する。
- 前バージョンの`lexical_cast`は、ポインタへの危険なもしくは無意味な変換を許していたが、現行版においては、ポインタへの変換は例外`bad_lexical_cast`を投げるようになっている：コード`lexical_cast<char *>("Goodbye, World")`は未定義の振る舞いをする代わりに、例外を投げる。


***
© Copyright Kevlin Henney, 2000–2003


