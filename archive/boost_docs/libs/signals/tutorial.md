# Boost.Signals チュートリアル

## <a name="intro">チュートリアルの読み方</a>

このチュートリアルは直線的に読むことを意図していない。
最上位の構成では、おおまかにライブラリにおける異なった概念(たとえば複数スロット呼び出しの扱い、スロットとの値の受け渡し)を分類している。
それぞれの概念に対して、まず基本的な考え方が提示され、その後、より複雑なライブラリの利用法について記述されている。
読者の便宜を図るため、各セクションは *初級* 、 *中級* 、 *上級* と区分されている。
*初級* セクションは、すべてのライブラリユーザが知っておくべき情報を含んでいる。
*初級* セクションのみを読み終えた段階で、Signals ライブラリの標準的な使用が可能になる。
*中級* セクションは*初級*セクションの基礎の上に立ち、ライブラリのやや複雑な使用法を提供する。
最後に *上級* セクションは Signals ライブラリの非常に高度な使用方法を詳述しており、しばしば *初級* 、 *中級* の項目に関する堅固な理解が要求される。
ほとんどのユーザは *上級* セクションを読む必要はない。

## 互換性に関する注記

Boost.Signals は二通りの文法形式を持つ。
preferred 形式は、より C++ に似合っており、考慮の必要がある隔てられたテンプレートパラメータの数を減少させ、たいてい可読性を向上させる。
しかしながらコンパイラのバグのため、 preferred 形式はすべてのプラットフォームではサポートされていない。
compatible 形式は Boost によってサポートされているすべてのコンパイラで動作する。
あなたのコンパイラでどちらの形式を利用するか決定するために、下の表が参考になる。

[Boost.Function](../function.md) の利用者は、Signals の prefered 形式は Function の preferred 形式と等価なことに注意。

### preferred 形式

- GNU C++ 2.95.x, 3.0.x, 3.1.x
- Comeau C++ 4.2.45.2
- SGI MIPSpro 7.3.0
- Intel C++ 5.0, 6.0
- Compaq's cxx 6.2

### compatible 形式

- Microsoft Visual C++ 6.0, 7.0
- Borland C++ 5.5.1
- Sun WorkShop 6 update 2 C++ 5.3
- Metrowerks CodeWarrior 8.1

アナタのコンパイラがこのリストに含まれていない場合、この表を最新の状態に保つため、 preferred 形式を試して結果を Boost メーリングリストに報告して欲しい。

## 大要

- *初級:* [Hello, World!](#hello_world)
- 複数スロットの呼び出し
	- *初級:* [複数スロットの接続](#multiple_slots)
	- *中級:* [スロット呼び出しグループの順序づけ](#ordering_slots)
- スロットとの値の受け渡し
	- *初級:* [スロットへの実引数](#slot_arguments)
	- *上級:* [シグナルの戻り値](#return_values)
- 接続管理
	- *初級:* [スロットの切断](#disconnecting)
	- *中級:* [変数スコープによって管理された接続](#scoped)
	- *中級:* [自動化された接続管理](#tracking)
- [スロットの受け渡し](#passing_slots)

## <a name="hello_world">Hello, World!</a>

次の例はシグナルとスロットを用いて "Hello, World!" を出力する。
はじめにシグナル `sig` を作成する。
これは引数を取らず戻り値もない。
次に `connect` メソッドを用いて、`hello` 関数オブジェクトをシグナルに接続する。
最後に、シグナル `sig` をスロットを呼び出す関数のように使用する。
これが `HelloWorld::operator()` を呼び出し "Hello, World!" を表示する。

### preferred 形式

```cpp
struct HelloWorld
{
	void operator()() const
	{
		std::cout << "Hello, World!" << std::endl;
	}
};

// ...

// 引数なし、戻り値なしのシグナル
boost::signal<void ()> sig;

// HelloWorld スロットに接続
HelloWorld hello;
sig.connect(hello);

// スロットをすべて呼び出す
sig();
```

### compatible 形式

```cpp
struct HelloWorld
{
	void operator()() const
	{
		std::cout << "Hello, World!" << std::endl;
	}
};

// ...

// 引数なし、戻り値なしのシグナル
boost::signal0<void> sig;

// HelloWorld スロットに接続
HelloWorld hello;
sig.connect(hello);

// スロットをすべて呼び出す
sig();
```

## <a name="multiple_slots">複数スロットの接続</a>

単一のシグナルから単一のスロットを呼び出すのは、あまり面白いとはいえない。
そこで "Hello, World!" を表示する仕事を二つの完全に分離されたスロットに分割することによって、 Hello, World プログラムをより興味深いものにする。
最初のスロットは "Hello" を表示するもので、次のようになるだろう。

```cpp
struct Hello
{
	void operator()() const
	{
		std::cout << "Hello";
	}
};
```

次のスロットは ", World!" と改行を表示し、プログラムを完全なものとする。
第二のスロットは次のようになるだろう。

```cpp
struct World
{
	void operator()() const
	{
		std::cout << ", World!" << std::endl;
	}
};
```

先の例と同様に、引数なし、戻り値型 `void` のシグナル `sig` を作成する。
ここで `hello` と `world` 両スロットを同一のシグナルに接続すると、シグナル呼び出しによって双方のスロットが呼ばれるだろう。

### preferred 形式

```cpp
boost::signal<void ()> sig;

sig.connect(Hello());
sig.connect(World());

sig();
```

### compatible 形式

```cpp
boost::signal0<void> sig;

sig.connect(Hello());
sig.connect(World());

sig();
```

ところで、このプログラムをコンパイルし実行すると、奇妙なものを目にするかもしれない。
出力は次のようになる可能性がある:

```cpp
  , World!
Hello
```

理由は、シグナルの順序が保証されないためだ。
シグナルは `Hello` と `World` のいずれを先に呼び出しても構わないが、何かまずいこと (例えば例外) が起きない限り、すべてのスロットが呼ばれる。
先を読み続けると "Hello, World!" が常に想定通りに表示されるように、順序を制御する方法を学ぶことができる。

## <a name="ordering_slots">スロット呼び出しグループの順序づけ</a>

スロットには副作用があってもかまわないため、他のスロットに先立って呼ぶ必要があるスロットが存在する可能性がある。
Boost.Signals ライブラリでは、スロットを何らかの方法で順序づけられたグループに配置することができる。
Hello, World プログラムでは "Hello" を ", World!" に先だって表示したいので、"Hello" を ", World!" が格納されるグループよりも先に実行されるグループに配置する。
このために、 `connect` の最初にグループを指定する追加のパラメタを与えることができる。
既定の状態では、グループ値は `int` であり整数の `<` 関係によって順序づけがなされる。
Hello, World を組み立てる方法は次の通りである:

### preferred 形式

```cpp
boost::signal<void ()> sig;
sig.connect(0, Hello());
sig.connect(1, World());
sig();
```

### compatible 形式

```cpp
boost::signal0<void> sig;
sig.connect(0, Hello());
sig.connect(1, World());
sig();
```

このプログラムは正しく "Hello, World!" を出力する。
なぜならグループ 0 に含まれる `Hello` オブジェクトは `World` オブジェクトが所属するグループ 1 よりも先に実行されるからだ。

実際のところ、グループパラメタはオプションである。
最初の Hello, World の例ではグループパラメタを省略した。
なぜなら、すべてのスロットが独立であればグループパラメタは不要だからだ。
それではグループパラメタを使用しているものと使用していないものを混在させたら、何が起きるだろうか？
"無名" スロット (グループ名を指定せずに接続されたスロット) は、他のすべてのグループの後にくる特殊な別グループに置かれる。
したがって、私たちの例に次のような新しいスロットを追加すると:

```cpp
struct GoodMorning
{
	void operator()() const
	{
		std::cout << "... and good morning!" << std::endl;
	}
};

sig.connect(GoodMorning());
```

…次のように、望み通りの結果を得られるだろう:

```cpp
Hello, World!
... and good morning!
```

スロットグループに関する最後の興味深い点は、複数のスロットが同一グループに接続された際の振る舞いである。
グループ内ではスロット呼び出しは順不同である:
スロット `A` と `B` を同一グループ名で同じシグナルに接続すると、 `A` と `B` いずれかが最初に呼ばれる (ただし両方とも呼ばれる)。
これは、我々が第二バージョンの Hello, World で見たのと同じ振る舞いであり、スロットが誤った順番で呼ばれ出力がめちゃくちゃになる可能性がある。

## <a name="slot_arguments">スロットへの実引数</a>

シグナルは、呼び出すそれぞれのスロットに対して引数を伝搬させることができる。
たとえばマウス動作イベントを伝搬させるシグナルは、新しいマウス座標とボタンが押されているか否かを渡したいだろう。

例として二つの `float` 引数をスロットに渡すシグナルを作成する。
そして、これらの値に対して様々な算術操作を行った結果を表示するスロットをいくつか作成する。

```cpp
void print_sum(float x, float y)
{
	std::cout << "The sum is " << x+y << std::endl;
}

void print_product(float x, float y)
{
	std::cout << "The product is " << x*y << std::endl;
}

void print_difference(float x, float y)
{
	std::cout << "The difference is " << x-y << std::endl;
}

void print_quotient(float x, float y)
{
	std::cout << "The quotient is " << x/y << std::endl;
}

boost::signal<void, float, float> sig;

sig.connect(&print_sum);
sig.connect(&print_product);
sig.connect(&print_difference);
sig.connect(&print_quotient);

sig(5, 3);
```

このプログラムは、行の順序は異なる可能性があるが、以下のような出力を行うだろう:

```cpp
The sum is 8
The difference is 2
The product is 15
The quotient is 1.66667
```

のように `sig` が関数のように呼び出される際に与えられた値は、いずれも各スロットに渡される。
シグナルを作成する際は、先頭でこれらの値の型を宣言しなければならない。
型 `boost::signal<void, float, float>` は、戻り値型 `void` を持ち二つの `float` 値をとるシグナルを意味する。

## <a name="return_values">シグナルの戻り値</a>

スロットが実引数を受け取れるのと同様、スロットは値を戻すこともできる。
これらの値は *統合子* を介してシグナルの呼び出し側に戻される。
統合子はスロット呼び出しの結果 (結果はないこともあれば百個に及ぶこともある; プログラムを実行するまで分からない) を受けとり、それを合体させて呼び出し側に戻す単一の値にする仕組みである。
その単一の値は、しばしばスロット呼び出しの結果に対する単純な関数である:
最後のスロット呼び出しの結果、スロットによって戻された値の最大値、すべての結果を格納したものなどがありうる。

先ほどの算術操作の例に少々手を加えて、それぞれのスロットが積、商、和もしくは差を返すように変更する。
これによってシグナルが結果に基づいた値を戻し、それを表示することが可能になる。

### preferred 形式

```cpp
float compute_product(float x, float y) { return x*y; }
float compute_quotient(float x, float y) { return x/y; }
float compute_sum(float x, float y) { return x+y; }
float compute_difference(float x, float y) { return x-y; }

boost::signal<float (float x, float y)> sig;

sig.connect(&compute_product);
sig.connect(&compute_quotient);
sig.connect(&compute_sum);
sig.connect(&compute_difference);

std::cout << sig(5, 3) << std::endl;
```

### compatible 形式

```cpp
float compute_product(float x, float y) { return x*y; }
float compute_quotient(float x, float y) { return x/y; }
float compute_sum(float x, float y) { return x+y; }
float compute_difference(float x, float y) { return x-y; }

boost::signal2<float, float, float> sig;

sig.connect(&compute_product);
sig.connect(&compute_quotient);
sig.connect(&compute_sum);
sig.connect(&compute_difference);

std::cout << sig(5, 3) << std::endl;
```

このプログラムは、シグナルが呼ばれる順序によるが、 `8`, `1.6667`, `15` もしくは `2` のいずれかを出力するだろう。
これは、戻り値型 (`float`, `boost::signal` クラステンプレートに与えられた最初の引数) を持つシグナルの既定の動作は、すべてのスロット呼び出した上で、最後のスロット呼び出しによって返された結果を返すことだからである。
正直なところ、今回の例に対してはこの振る舞いは馬鹿げている。
というのはスロットに副作用がないため、本質的に結果はスロットからランダムに選ばれるためだ。

すべてのスロットから戻された値の最大値は、より興味あるシグナルの結果だろう。
これを求めるために、次のようなカスタム統合子を作成する。

```cpp
template<typename T>
struct maximum
{
	typedef T result_type;

	template<typename InputIterator>
	T operator()(InputIterator first, InputIterator last) const
	{
		// If there are no slots to call, just return the
		// default-constructed value
		if (first == last)
			return T();

		T max_value = *first++;
		while (first != last) {
			if (max_value < *first)
				max_value = *first;
			++first;
		}

		return max_value;
	}
};
```

`maximum` クラステンプレートは関数オブジェクトとして機能する。
戻り値型はテンプレートパラメタとして与えられ、その型に基づいて最大値が計算される
(たとえば `maximum<float>` は `float` のシーケンスから、最大の `float` を見つけ出す)。
`maximum` オブジェクトが呼び出される際、すべてのスロット呼び出しの結果を含む入力イテレータのシーケンス `[first, last)` が与えられる。
`maximum` はこの入力イテレータのシーケンスを用いて最大の要素を計算し、その最大値を返す。

実際には、この関数オブジェクトの型をシグナルに対する統合子として導入し、利用する。
この型は、次のように *名前付きテンプレートパラメタ* を介して与える。

### preferred 形式

```cpp
boost::signal<float (float x, float y), maximum<float> > sig;
```

### compatible 形式

```cpp
boost::signal2<float, float, float, maximum<float> > sig;
```

これで、算術関数を計算するスロットを接続してシグナルを使うことができる。

```cpp
sig.connect(&compute_quotient);
sig.connect(&compute_product);
sig.connect(&compute_sum);
sig.connect(&compute_difference);

std::cout << sig(5, 3) << std::endl;
```

このプログラムの出力は `15` となるだろう。
なぜならスロットが呼ばれる順序にかかわらず、5 と 3 の積は商、和、差よりも大きくなるからだ。

別の場合には、スロットによって計算されたすべての値をまとめてひとつの大きなデータ構造で返したくなるかもしれない。
これは別の統合子によって、容易に実行できる。

```cpp
template<typename Container>
struct aggregate_values
{
	typedef Container result_type;

	template<typename InputIterator>
	Container operator()(InputIterator first, InputIterator last) const
	{
		return Container(first, last);
	}
};
```

再び、この新しい統合子を使ったシグナルを作ろう。

### preferred 形式

```cpp
boost::signal<float (float, float), aggregate_values<std::vector<float> > > sig;

sig.connect(&ompute_quotient);
sig.connect(&ompute_product);
sig.connect(&ompute_sum);
sig.connect(&ompute_difference);

std::vector<float> results = sig(5, 3);
std::copy(results.begin(), results.end(), std::ostream_iterator<float>(cout, " "));
```

### compatible 形式

```cpp
boost::signal2<float, float, float, aggregate_values<std::vector<float> > > sig;

sig.connect(&ompute_quotient);
sig.connect(&ompute_product);
sig.connect(&ompute_sum);
sig.connect(&ompute_difference);

std::vector<float> results = sig(5, 3);
std::copy(results.begin(), results.end(), std::ostream_iterator<float>(cout, " "));
```

このプログラムの出力は 15, 8, 1.6667 と 2 を含む (ただし順不同)。
`signal` クラスに対する最初のテンプレート実引数 `float` が、実際にはシグナルの戻り値型でないことは興味深い。
そうではなく、最初のテンプレート実引数は接続されたスロットの戻り値型であり、統合子に渡される入力イテレータの `value_type` として用いられる。
統合子それ自身は関数オブジェクトであり、統合子の `result_type` メンバ型がシグナルの戻り値型となる。

## <a name="disconnecting">スロットの切断</a>

スロットは、接続後、永遠に存在することは期待されていない。
しばしばスロットは 2, 3 のイベントを受け取るために用いられ、そして切断される。
そこでプログラマは、スロットを切断すべきタイミングを決定する制御を必要とする。

明示的な接続管理の入口は `boost::signal::connection` クラスである。
`connection` クラスは、それぞれ特定のシグナルと特定のスロットの間の接続を表している。
`connected()` メソッドはそのシグナルとスロットがまだ接続されているかを調べ、 `disconnect()` メソッドは、シグナルとスロットが接続されているなら呼び出される前に切断する。
シグナルの `connect()` メソッドはそれぞれ `connection` オブジェクトを返す。
そのオブジェクトは接続がまだ存在しているかを決定し、またシグナルとスロットを切断するために用いることができる。

```cpp
boost::signals::connection c = sig.connect(HelloWorld());
if (c.connected()) {
	// c はまだシグナルに接続されている
	sig(); // "Hello, World!" を表示する
}

c.disconnect(); // HelloWorld オブジェクトを切断する
assert(!c.connected()); // c はすでに接続されていない

sig(); // 何もしない : 接続されたスロットはない
```

## <a name="scoped">変数スコープによって管理された接続</a>

`boost::signals::scoped_connection` クラスは、 `scoped_connection` クラスがスコープからはずれると切断されるシグナル／スロット接続を参照する。
この機能は接続が一時的に必要な場合に有用である。
例を次に示す。

```cpp
{
	boost::signals::scoped_connection c = sig.connect(ShortLived());
	sig(); // ShortLived 関数オブジェクトを呼び出す
}
sig(); // ShortLived 関数オブジェクトは、もはや sig に接続されていない
```

## <a name="tracking">自動化された接続管理</a>

Boost.Signals は、スロット呼び出しに含まれるオブジェクトが破棄されたときに自動的にスロットを切断することも含めて、シグナル／スロット接続に関係するオブジェクトの寿命を自動的に追跡することができる。
たとえば、クライアントがニュース供給者に接続し、ニュース供給者は情報が届くとすべての接続されたクライアントにニュースを送るという、単純なニュース配信サービスを考えてみる。
ニュース配信サービスは、次のようになるだろう:

### preferred 形式

```cpp
class NewsItem { /* ... */ };

boost::signal<void (const NewsItem& latestNews)> deliverNews;
```

### compatible 形式

```cpp
class NewsItem { /* ... */ };

boost::signal1<void, const NewsItem> deliverNews;
```

ニュース更新を受け取りたいクライアントは、ニュース項目を受信できる関数オブジェクトを `deliverNews` シグナルに接続するだけで良い。
たとえば、アプリケーションにニュースのための特別なメッセージ領域があるとしよう。
例を次に示す:

```cpp
struct NewsMessageArea : public MessageArea
{
	public:
	// ...

	void displayNews(const NewsItem& news) const
	{
		messageText = news.text();
		update();
	}
};

// ...
NewsMessageArea newsMessageArea = new NewsMessageArea(/* ... */);
// ...
deliverNews.connect(boost::bind(&NewsMessageArea::displayNews, newsMessageArea, _1));
```

しかしながら、ユーザがニュースメッセージ領域を閉じ `deliverNews` が関知している `newsMessageArea` オブジェクトを破棄したら、どうなるだろうか？
おそらくセグメンテーションフォールトが起こるだろう。
だが Boost.Signals では `NewsMessageArea` を *trackable* にするだけでよい、
そうすれば `newsMessageArea` が破棄される時に `newsMessageArea` に含まれるスロットが切断される。
`boost::signals::trackable` から public 派生させることで、`NewsMessageArea` クラスは trackable になる。
例を次に示す:

```cpp
struct NewsMessageArea : public MessageArea, public boost::signals::trackable
{
	// ...
};
```

現在は、スロット接続を作成する際の `trackable` オブジェクトの使用法には、ひとつ重大な制約がある:
関数オブジェクトは Boost.Bind を用いて構築する必要がある。
したがって `trackable` オブジェクトは常に bind 式の中に現れる。
しかし、ユーザ定義の関数オブジェクトや他のライブラリ (Boost.Function や Boost.Lambda など) 由来の関数オブジェクトは `trackable` オブジェクト検出のために必要なインターフェースを実装していないため、 *bind された trackable オブジェクトは黙って無視される。*
将来の Boost ライブラリは、この制約に対処するだろう。

## <a name="passing_slots">スロットの受け渡し</a>

Boost.Signals ライブラリのスロットは任意の関数オブジェクトから作成されるため、特定の型を持たない。
しかしながら、テンプレートにできないインターフェースを介してスロットを受け渡すことが必要となるのは良くあることだ。
スロットは、それぞれのシグナル型に対応する `slot_type` を介して受け渡すことが可能であり、任意の有効な関数オブジェクトを `slot_type` 型のパラメタに渡すことができる。
例を次に示す:

### Preferred 形式

```cpp
class Button
{
	typedef boost::signal<void (int x, int y)> OnClick;

public:
	void doOnClick(const OnClick::slot_type& slot);

private:
	OnClick onClick;
};

void Button::doOnClick(const OnClick::slot_type& slot)
{
	onClick.connect(slot);
}
```

### Compatible 形式

```cpp
class Button
{
	typedef boost::signal2<void, int x, int y> OnClick;

public:
	void doOnClick(const OnClick::slot_type& slot);

private:
	OnClick onClick;
};

void Button::doOnClick(const OnClick::slot_type& slot)
{
	onClick.connect(slot);
}
```

`doOnClick` メソッドは `onClick` シグナルの `connect` メソッドと機能的に等価だが、いまや `doOnClick` メソッドの詳細は実装詳細ファイルに隠蔽することが可能になる。

[Doug Gregor](http://www.cs.rpi.edu/~gregod)

