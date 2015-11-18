#bind.hpp

- 翻訳元ドキュメント： <http://www.boost.org/doc/libs/1_31_0/libs/bind/bind.html>

##目次
- [目的](#purpose)
	- [関数と関数ポインタに対して`bind`を使用する](#using-bind-with-function-and-function-pointer)
	- [関数オブジェクトに対して`bind`を使用する](#using-bind-with-function-object)
	- [メンバへのポインタに対して`bind`を使用する](#using-bind-with-pointer-to-member)
	- [関数合成のために入れ子の`bind`を使用する](#using-nested-binds-for-function-composition)
- [コード例](#examples)
	- [標準アルゴリズムに対して`bind`を使用する](#using-bind-with-standard-algorithms)
	- [Boost.Functionと`bind`を組み合わせて使用する](#using-bind-with-boost-function)
- [制限](#limitation)
- [よくある質問と回答](#frequently-asked-questions)
	- [どうしてコンパイルできない？](#why-doesnt-this-compile)
	- [どうしてコンパイルできちゃう？ エラーになる筈なのに。](#why-does-this-compile)
	- [`bind(f, ...)` と `bind<R>(f, ...)` はどう違う？](#what-is-the-difference-between-bind-and-bind-r)
	- [bind は Windows の API 関数に対して使える？](#does-bind-work-with-win-api)
	- [bind は COM のメソッドに使える？](#does-bind-work-with-com-methods)
	- [bind は Mac の Toolbox 関数に使える？](#does-bind-work-with-mac-toolbox)
	- [bind は extern "C" な関数に使える？](#does-bind-work-with-extern-c-functions)
	- [どうして bind は非標準の関数を自動的に認識しない？](#why-doesnt-bind-automatically-recognize-nonstd-functions)
- [トラブルシューティング](#troubleshooting)
	- [引数の数が不正](#incorrect-number-of-arguments)
	- [関数オブジェクトは指定された引数とともに呼び出すことはできない](#function-object-cannot-be-called-with-the-specified-arguments)
	- [存在しない引数へのアクセス](#access-arg-does-not-exist)
	- [`bind(f, ...)` の不適切な使用](#inappropriate-use-of-bind)
	- [`bind<R>(f, ...)` の不適切な使用](#inappropriate-use-of-bind-r)
	- [非標準の関数を束縛](#binding-a-nonstd-function)
	- [シグネチャが const を含む](#const-in-signatures)
	- MSVC specific: using boost::bind;
	- MSVC specific: class templates shadow function templates
	- MSVC specific: ... in signatures treated as type
- Interface
	- Synopsis
	- Common requirements
	- Common definitions
	- bind
	- Additional overloads
- Implementation
	- Files
	- Dependencies
	- Number of Arguments
	- "__stdcall", "__fastcall", and "pascal" Support
	- Using the BOOST_BIND macro
	- visit_each support
- Acknowledgements


## <a name="purpose" href="#purpose">目的</a>
`boost::bind` は標準ライブラリの関数 `std::bind1st` および `std::bind2nd` を汎用化したものである。 関数オブジェクトだけでなく、関数や関数へのポインタ、メンバ関数へのポインタをサポートし、任意の引数を特定の値に束縛したり、入力引数を、もとの順番に関係なく自由な位置に移し替えることができる。 `bind` が扱うことのできる関数オブジェクトには、特別な条件はない。 特に、標準関数が要求する `typedef result_type` や `first_argument_type` および `second_argument_type` は必須ではない。

- 【訳注：このような関数を一般に「バインダ」または「束縛子」と呼ぶ。】
- 【訳注：「入力引数」とは、`bind` によって生成された関数オブジェクトを呼び出す時に渡される引数。例えば、`bind(f, _1, 5)(x)` における `x` のこと。】


### <a name="using-bind-with-function-and-function-pointer" href="#using-bind-with-function-and-function-pointer">関数と関数ポインタに対して`bind`を使用する</a>
以下の関数が定義されているとき、

```cpp
int f(int a, int b)
{
    return a + b;
}

int g(int a, int b, int c)
{
    return a + b + c;
}
```

`bind(f, 1, 2)` は "nullary" (無項)、つまり引数をとらない関数オブジェクトを生成する。これを評価すると `f(1, 2)` を返す。 同様に、`bind(g, 1, 2, 3)()` は `g(1, 2, 3)` と等価である。

【訳注："nullary" は boost の造語のようで、「いくつかの邪悪な提案のうち、いちばんマシ」として選ばれたとの記述が [compose ライブラリのコメント](compose.md) にある。】

引数のうちいくつかだけを、選択的に束縛することもできる。 例えば、`bind(f, _1, 5)(x)` は `f(x, 5)` と等価である。 ここで、`_1` は「最初の入力引数によって置き換えられる」ことを意味するプレースホルダである。

【訳注：残念ながら、`bind(f, _1, 5)(10)` のように、入力引数にリテラルを渡すことはできない。詳しくは、[制限の項](#limitation) を参照。】

比較のため、同じ操作を標準ライブラリのプリミティブを使って書くとこうなる。

```cpp
std::bind2nd(std::ptr_fun(f), 5)(x);
```

`bind` は `std::bind1st` の機能もカバーしている。

```cpp
std::bind1st(std::ptr_fun(f), 5)(x);   // f(5, x)
bind(f, 5, _1)(x);                     // f(5, x)
```

`bind` は二つ以上の引数を持つ関数を扱うことができる。 また、引数の置き換え機能はより一般化されている。

```cpp
bind(f, _2, _1)(x, y);                 // f(y, x)
bind(g, _1, 9, _1)(x);                 // g(x, 9, x)
bind(g, _3, _3, _3)(x, y, z);          // g(z, z, z)
bind(g, _1, _1, _1)(x, y, z);          // g(x, x, x)
```

最後の例で、`bind(g, _1, _1, _1)` が生成する関数オブジェクトは入力引数を一つしか受け取らないにも関わらず、複数の引数を付けて呼び出せることに注意。 このように、余分な引数は黙って無視され、エラーにはならない。 同様に、三番目の例では最初の引数 `x` と二番目の引数 `y` は無視される。

`bind` に渡される引数はコピーされ、生成された関数オブジェクトの内部に保持される。 例えば、以下のコードでは、

```cpp
int i = 5;
bind(f, i, _1);
```

`i` の値のコピーが関数オブジェクトに格納される。 コピーではなく参照を関数オブジェクトに格納したい場合には、[`boost::ref`](bind/ref.md) および [`boost::cref`](bind/ref.md) を使う必要がある。

```cpp
int i = 5;
bind(f, ref(i), _1);
```

【訳注：詳しくは、[`ref` のドキュメント](bind/ref.md)を参照。】


### <a name="using-bind-with-function-object" href="#using-bind-with-function-object">関数オブジェクトに対して`bind`を使用する</a>
`bind` は通常の関数だけでなく、任意の関数オブジェクトを受け付ける。 一般的には（標準 C++ には `typeof` 演算子がなく、戻り型を推論できないため）、生成される関数オブジェクトの `operator()` の戻り型を以下のように明示的に指定する必要がある。

```cpp
struct F
{
    int operator()(int a, int b) { return a - b; }
    bool operator()(long a, long b) { return a == b; }
};

F f;

int x = 104;

bind<int>(f, _1, _1)(x);		// f(x, x) つまり、ゼロ
```

関数オブジェクトが `result_type` という名前の入れ子の型を開示している場合、戻り型を明示的に書く必要はない。

```cpp
nt x = 8;

bind(std::less<int>(), _1, 9)(x);	// x < 9
```

【注意：戻り型を省略する機能は、コンパイラによっては利用できない場合がある。】


### <a name="using-bind-with-pointer-to-member" href="#using-bind-with-pointer-to-member">メンバへのポインタに対して`bind`を使用する</a>
メンバ関数へのポインタやデータメンバへのポインタは `operator()` を持たないので、関数オブジェクトではない。 しかし、それでは不便なので、`bind` は最初の引数としてメンバへのポインタも受け付ける。 この場合、[`boost::mem_fn`](mem_fn.md) によってメンバへのポインタが関数オブジェクトに変換されて渡されたかのように振る舞う。 すなわち、式

```cpp
bind(&X::f, args)
```
* args[italic]

は以下の式と等価である。

```cpp
bind<R>(mem_fn(&X::f), args)
```
* args[italic]

ここで、`R` は `X::f` の戻り型（メンバ関数の場合）、またはメンバの型への `const` な参照（データメンバの場合）である。

【注意：`mem_fn` が生成する関数オブジェクトを呼び出す際には、最初の引数としてオブジェクトのポインタ、参照またはスマートポインタを渡す。 詳しくは、[`mem_fn` のドキュメント](mem_fn.md)を参照。】

例：
```cpp
struct X
{
    bool f(int a);
};

X x;

shared_ptr<X> p(new X);

int i = 5;

bind(&X::f, ref(x), _1)(i);		// x.f(i)
bind(&X::f, &x, _1)(i);			// (&x)->f(i)
bind(&X::f, x, _1)(i);			// (x の内部的なコピー).f(i)
bind(&X::f, p, _1)(i);			// (p の内部的なコピー)->f(i)
```

最後の二つの例は「自己充足な」関数オブジェクトを生成する興味深い例である。 `bind(&X::f, x, _1)` は `x` のコピーを保持する。 `bind(&X::f, p, _1)` は `p` のコピーを保持し、`p` が `boost::shared_ptr` であるため、関数オブジェクトは `X` のインスタンスへの参照を持ち、それは `p` のスコープを抜けたり `reset()` されたりしても有効である。

【訳注：つまり、`bind` の最初の引数がメンバ関数へのポインタである場合、次の引数はそのメンバ関数を持つクラスまたは派生クラスのオブジェクトまたはポインタ、`ref()`、スマートポインタでなければならない。】


### <a name="using-nested-binds-for-function-composition" href="#using-nested-binds-for-function-composition">関数合成のために入れ子の`bind`を使用する</a>
`bind` に渡される引数のうちいくつかは、それ自体が `bind` の入れ子になった式でもよい。

```cpp
bind(f, bind(g, _1))(x);               // f(g(x))
```

`bind` によって生成された関数オブジェクトを呼び出す時には、外側の `bind` 式が呼ばれる前に内側の `bind` 式が、複数ある場合は順不同で評価される。 次に、その結果は外側の `bind` が評価される際の引数として渡される。 上の例で、関数オブジェクトが引数リスト `(x)` とともに呼び出される場合、`bind(g, _1)(x)` がまず評価されて `g(x)` となり、次に `bind(f, g(x))(x)` が評価され、最終的な結果は `f(g(x))` となる。

`bind` のこの機能は、関数を合成するために使用することができる。 詳しくは、[`bind_as_compose.cpp`](bind/bind_as_compose.cpp.md) に `bind` を使って [Boost.Compose](compose.md) と同様の効果を得るサンプルがあるので、それを参照のこと。

ただし、（`bind` 関数の）最初の引数、つまり束縛される関数オブジェクトは、評価されないので注意すること。 特に、関数オブジェクトが `bind` で生成されたものや、プレースホルダ引数の場合でも評価されないので、次の例は期待通りには動かない。

```cpp
typedef void (*pf)(int);

std::vector<pf> v;

std::for_each(v.begin(), v.end(), bind(_1, 5));
```

【訳注：動かないというか、コンパイルできない。】

期待通りの結果を得るには、ヘルパ関数オブジェクト `apply` を使用する必要がある。 `apply` はその最初の引数である関数オブジェクトを、残りの引数リストに対して適用する。 `apply` 関数は `boost/bind/apply.hpp` ヘッダファイルに定義されている。 上の例は、この `apply` を使って次のように書き直せばよい。

```cpp
typedef void (*pf)(int);

std::vector<pf> v;

std::for_each(v.begin(), v.end(), bind(apply<void>(), _1, 5));
```

時には、最初の引数だけでなく、入れ子になった `bind` 部分式であるような他の引数を評価したくない場合もある。 この場合は、別のヘルパ関数 `protect` を使用するとよい。 これにより、引数の型がマスクされ、`bind` が認識されず、評価されない。 呼び出し時には、`protect` は単純に引数リストを他の関数オブジェクトのそのまま渡す。

`protect` 関数は `boost/bind/protect.hpp` ヘッダに含まれている。 `bind` 関数オブジェクトを評価されないように保護するには、`protect(bind(f, ...))` と書けばよい。


## <a name="examples" href="#examples">コード例</a>
### <a name="using-bind-with-standard-algorithms" href="#using-bind-with-standard-algorithms">標準アルゴリズムと`bind`を組み合わせて使用する</a>
```cpp
class image;

class animation
{
public:

    void advance(int ms);
    bool inactive() const;
    void render(image & target) const;
};

std::vector<animation> anims;

template<class C, class P> void erase_if(C & c, P pred)
{
    c.erase(std::remove_if(c.begin(), c.end(), pred), c.end());
}

void update(int ms)
{
    std::for_each(anims.begin(), anims.end(), boost::bind(&animation::advance, _1, ms));
    erase_if(anims, boost::mem_fn(&animation::inactive));
}

void render(image & target)
{
    std::for_each(anims.begin(), anims.end(), boost::bind(&animation::render, _1, boost::ref(target)));
}
```

### <a name="using-bind-with-boost-function" href="#using-bind-with-boost-function">Boost.Functionと`bind`を組み合わせて使用する</a>
```cpp
class button
{
public:

    boost::function<void> onClick;
};

class player
{
public:

    void play();
    void stop();
};

button playButton, stopButton;
player thePlayer;

void connect()
{
    playButton.onClick = boost::bind(&player::play, &thePlayer);
    stopButton.onClick = boost::bind(&player::stop, &thePlayer);
}
```

## <a name="limitation" href="#limitation">制限</a>
`bind` が生成する関数オブジェクトは、引数を参照渡しで受け取る。このため、`const` でない一時オブジェクトやリテラル定数を受け取ることはできない。 これは、C++ 言語自体の制約であり、「転送する関数の問題（？）」として知られている。

任意の型の引数を受け取り、それらをそのまま渡すために、`bind` ライブラリでは、

```cpp
template<class T> void f(T & t);
```

という形式のシグネチャを（訳注：仮引数に）使っている。 上記のように、この方法は `const` でない右辺値には使えない。

この問題に対して、次のようにオーバーロードを追加する「解決策」がよく提案される。

```cpp
template<class T> void f(T & t);
template<class T> void f(T const & t);
```

残念ながら、この方法は (a) 引数が 9 つある場合、512 ものオーバーロードを提供する必要があり、(b) 引数が `const` である場合、シグネチャが全く同じであるために半順序（？）を定義できず、左辺値にも右辺値にもうまく働かない。

【注意：これは C++ 言語の暗い隅（？）であり、該当する問題はまだ解決されていない。】


## <a name="frequently-asked-questions" href="#frequently-asked-questions">よくある質問と回答</a>
### <a name="why-doesnt-this-compile" href="#why-doesnt-this-compile">どうしてコンパイルできない？</a>
[トラブルシューティング](#troubleshooting) の項を参照。


### <a name="why-does-this-compile" href="#why-does-this-compile">どうしてコンパイルできちゃう？ エラーになる筈なのに。</a>
おそらく、`bind<R>(f, ...)` という汎用の構文を使っているためであろう。この書き方は、`bind` に対して `f` の引数の数や戻り型に関するエラーチェックをしないように指示するものである。


### <a name="what-is-the-difference-between-bind-and-bind-r" href="#what-is-the-difference-between-bind-and-bind-r">`bind(f, ...)` と `bind<R>(f, ...)` はどう違う？</a>
最初の形式は `bind` に `f` の型を調べて、引数の数や戻り型を解決するように指示する。 引数の数の間違いは「バインド時」に検出される。 この構文はもちろん、`f` に対していくつかのことを要求する。 つまり、`f` は関数、関数ポインタ、メンバ関数へのポインタのいずれかであるか、関数オブジェクトの場合には `result_type` という入れ子の型を定義する必要がある。簡単に言えば、`bind` が認識できるものでなければならない。

二番目の形式は `bind` に `f` の型を識別しないように指示する。 これは一般的には、`result_type` を開示しない、あるいはできない関数オブジェクトとともに用いられるが、その他に非標準の関数に対しても用いることができる。 たとえば、現在の実装は `printf` のような可変引数の関数を自動的に認識しないため、`bind<int>(printf, ...)` と書く必要がある。

【訳注：「非標準」は原文では nonstandard だが、printf が「非標準」というのは変だなぁ。】

他に考慮すべき重要な点として、コンパイラがテンプレートの部分特殊化版や関数テンプレートの半順序（？）に対応していない場合、`f` が関数オブジェクトであれば最初の形式は扱えず、また、`f` が関数（ポインタ）やメンバ関数へのポインタであれば二番目の形式は扱えないことが多い。


### <a name="does-bind-work-with-win-api" href="#does-bind-work-with-win-api">bind は Windows の API 関数に対して使える？</a>
はい、`#define BOOST_BIND_ENABLE_STDCALL` すれば。 または、目的の関数を [generic function object](#using-bind-with-function-object) として扱って、`bind<R>(f, ...)` の構文を使っても良い。


### <a name="does-bind-work-with-com-methods" href="#does-bind-work-with-com-methods">bind は COM のメソッドに使える？</a>
はい、`#define BOOST_MEM_FN_ENABLE_STDCALL` すれば。


### <a name="does-bind-work-with-mac-toolbox" href="#does-bind-work-with-mac-toolbox">bind は Mac の Toolbox 関数に使える？</a>
はい、`#define BOOST_BIND_ENABLE_PASCAL` すれば。 または、目的の関数を [generic function object](#using-bind-with-function-object) として扱って、`bind<R>(f, ...)` の構文を使っても良い。


### <a name="does-bind-work-with-extern-c-functions" href="#does-bind-work-with-extern-c-functions">bind は extern "C" な関数に使える？</a>
場合による。 いくつかのプラットフォームでは、`extern "C"` な関数へのポインタは「通常の」関数ポインタと等価であり、問題なく動く。 他のプラットフォームでは、それらは別物として扱われる。 プラットフォーム固有の `bind` の実装があれば、問題を透過的に解決できることが期待されるが、この実装はそうなっていない。 いつものように、回避策は目的の関数を [generic function object](#using-bind-with-function-object) として扱って、`bind<R>(f, ...)` の構文を使うことである。

【訳注：「この実装」とあるが、このドキュメントは `bind` の仕様を定義するもので、附属の実装は「サンプル実装」という位置付けで書かれているものと思われる。（？）】


### <a name="why-doesnt-bind-automatically-recognize-nonstd-functions" href="#why-doesnt-bind-automatically-recognize-nonstd-functions">どうして bind は非標準の関数を自動的に認識しない？</a>
特定のベンダに縛られることを防ぐために、非標準の拡張は一般的にデフォルトでオフにすべきである。 もしも[固有のマクロ](##does-bind-work-with-win-api)が自動的に定義されたら、そのつもりがないのにそれらの機能を使ってしまい、知らない間に互換性を損なってしまう危険性がある。 また、いくつかのコンパイラは `__stdcall (__fastcall)` をデフォルトの呼び出し規約とするオプションを用意しており、特別なサポートは必要ない。


## <a name="troubleshooting" href="#troubleshooting">トラブルシューティング</a>
### <a name="incorrect-number-of-arguments" href="#incorrect-number-of-arguments">引数の数が不正(Incorrect number of arguments)</a>
式 `bind(f, a1, a2, ..., aN)` において、関数オブジェクト `f` はちょうど `N` 個の引数を取らなければならない。 このエラーは、通常「バインド時」に検出される。すなわち、`bind()` を呼び出している行に対してコンパイルエラーが報告される。

```cpp
int f(int, int);

int main()
{
    boost::bind(f, 1);    // エラー、f は二つの引数を取る
    boost::bind(f, 1, 2); // OK
}
```

このエラーの変種として、メンバ関数に対する暗黙の「`this`」引数を忘れることも多い。

```cpp
struct X
{
    int f(int);
};

int main()
{
    boost::bind(&X::f, 1);     // エラー、X::f は二つの引数を取る
    boost::bind(&X::f, _1, 1); // OK
}
```

【訳注：`bind` では、メンバ関数へのポインタは、通常の引数の前に暗黙の「`this`」引数をとるものとみなす。】


### <a name="function-object-cannot-be-called-with-the-specified-arguments" href="#function-object-cannot-be-called-with-the-specified-arguments">関数オブジェクトは指定された引数とともに呼び出すことはできない(The function object cannot be called with the specified arguments)</a>
通常の関数呼び出しと同様、束縛される関数オブジェクトは引数リストと互換性を持つ必要がある。 非互換性は、通常コンパイラによって「呼び出し時」に検出され、`bind.hpp` の次のような行に対するエラーとなる。

```
    return f(a[a1_], a[a2_]);
```

An example of this kind of error:

```cpp
int f(int);

int main()
{
    boost::bind(f, "incompatible");      // OK、呼び出さないので
    boost::bind(f, "incompatible")();    // エラー、"incompatible" は int ではない
    boost::bind(f, _1);                  // OK
    boost::bind(f, _1)("incompatible");  // エラー、"incompatible" は int ではない
}
```

### <a name="access-arg-does-not-exist" href="#access-arg-does-not-exist">存在しない引数へのアクセス(Accessing an argument that does not exist)</a>
プレースホルダ `_N` は引数リストの `N` 番目の引数を、「呼び出し時」に選択する。 当然、引数リストの範囲外のものにアクセスしようとすればエラーになる。

```cpp
int f(int);

int main()
{
    boost::bind(f, _1);                  // OK
    boost::bind(f, _1)();                // エラー、一番目の引数は存在しない
}
```

このエラーは、通常 `bind.hpp` の次のような行に対して報告される。

```
    return f(a[a1_]);
```

`std::bind1st(f, a)` の代わりに使う場合、`bind(f, a, _1)` ではなく間違って `bind(f, a, _2)` としてしまうことも多い。


### <a name="inappropriate-use-of-bind" href="#inappropriate-use-of-bind">`bind(f, ...)` の不適切な使用(Inappropriate use of `bind(f, ...)`)</a>
`bind(f, a1, a2, ..., aN)` の[形式](#what-is-the-difference-between-bind-and-bind-r)は `f` を自動的に認識させる。 これは、任意の関数オブジェクトに対して働くわけではない。`f` は関数またはメンバ関数へのポインタでなければならない。

この形式を `result_type` を定義する関数オブジェクトに使えるのは、部分特殊化版や半順序（？）をサポートしているコンパイラに限られる。 特に、MSVC のバージョン 7.0 までは、関数オブジェクトに対するこの構文はサポートしない。

【訳注：原文では MSVC up to version 7.0 となっているが、これは 7.0 を含むのだろうか？】


### <a name="inappropriate-use-of-bind-r" href="#inappropriate-use-of-bind-r">`bind<R>(f, ...)` の不適切な使用(Inappropriate use of `bind<R>(f, ...)`)</a>
`bind<R>(f, a1, a2, ..., aN)`の[形式](#what-is-the-difference-between-bind-and-bind-r)は、任意の関数オブジェクトをサポートする。

この形式を、(推奨はしないが)関数もしくメンバ関数ポインタに使えるのは、半順序をサポートしているコンパイラに限られる。特に、MSVC のバージョン 7.0 までは、関数とメンバ関数ポインタに対するこの構文はサポートしない。


### <a name="binding-a-nonstd-function" href="#binding-a-nonstd-function">非標準の関数を束縛(Binding a nonstandard function)</a>
デフォルトでは、`bind(f, a1, a2, ..., aN)` の[形式](#what-is-the-difference-between-bind-and-bind)は、「通常」のC++関数と関数ポインタのみを受け入れる。[関数が異なる呼び出し規約を使っていたり](#does-bind-work-with-win-api)、`std::printf`のような可変引数の関数では、動作しない。汎用的な`bind<R>(f, a1, a2, ..., aN)`[形式](#what-is-the-difference-between-bind-and-bind-r)なら、そのような非標準関数に対しても動作する。

いくつかのプラットフォームでは、`extern "C"`の付いた`stdcmp`のような関数は、短い形式の`bind`では動作しない。

["`__stdcall`"](#does-bind-work-with-win-api)や["`pascal`"](#does-bind-work-with-mac-toolbox)のサポートを参照。


### <a name="const-in-signatures" href="#const-in-signatures">シグネチャが const を含む(const in signatures)</a>
MSVC 6.0やBorland C++ 5.5.1を含むいくつかのプラットフォームでは、関数のシグニチャがトップレベルの`const`を持っていることが問題になる：

```cpp
int f(int const);

int main()
{
    boost::bind(f, 1);     // エラー
}
```

回避策は、引数の形式から`const`修飾を削除することだ。


***
以下、未翻訳。


***
Copyright © 2001, 2002 by Peter Dimov and Multi Media Ltd. Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies. This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

