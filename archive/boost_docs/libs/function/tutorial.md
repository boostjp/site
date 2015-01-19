#Boost.Function Tutorial
Boost.Function には 2 種類の文法がある。推奨文法と互換文法である。推奨文法は C++ にフィットし、考慮するテンプレートパラメータの数も減り、可読性を高めることが多い。しかし、コンパイラのバグのせいで、推奨文法が使えないコンパイラもある。互換文法は Boost.Function がサポートする全てのコンパイラで使える。どちらの文法を使うかは、下の表を見て決めてほしい。

| 推奨文法 | 互換文法 |
|----------|----------|
| GNU C++ 2.95.x, 3.0.x, 3.1.x, 3.2<br/> Comeau C++ 4.2.45.2<br/> SGI MIPSpro 7.3.0<br/> Intel C++ 5.0, 6.0<br/> Compaq's cxx 6.2 | Microsoft Visual C++ 6.0, 7.0<br/> Borland C++ 5.5.1<br/> Sun WorkShop 6 update 2 C++ 5.3<br/> Metrowerks CodeWarrior 8.1 |

あなたのコンパイラが表になければ、推奨文法を試してみて、結果を Boost MLに報告してほしい。この表を最新に保つためだ。


##Basic Usage
関数オブジェクトのラッパを定義するには、 `function` クラステンプレートをインスタンス化するだけだ。テンプレート引数には、戻り値型と引数型を関数型形式で指定する。ある実装定義の最大値 (デフォルトは 10) までなら、引数は何個でもかまわない。以下に、 2 つの `int` 型のパラメータを取り、`float` 型を返す関数オブジェクトのラッパ f の定義を示す。

| 推奨文法 | 互換文法 |
|----------|----------|
| `boost::function<float (int x, int y)> f;` | `boost::function2<float, int, int> f;` |

デフォルトでは、関数オブジェクトのラッパは空である。 `f` に代入する関数オブジェクトを作ろう。

```cpp
struct int_div { 
  float operator()(int x, int y) const { return ((float)x)/y; }; 
};

f = int_div();
```

これで、関数オブジェクト `int_div` を呼び出す代わりに `f` を使える。

```cpp
std::cout << f(5, 3) << std::endl;
```

`f` には、互換性があれば、どんな関数オブジェクトでも代入できる。 `int_div` が 2 つの `long` 型の引数をとると宣言されていれば、自動的に暗黙の型変換が適用される。引数型に対する唯一の制限は、コピーコンストラクト可能なことである。だから、参照や配列さえ使える。


| 推奨文法 | 互換文法 |
|----------|----------|
| `boost::function<void (int values[], int n, int& sum, float& avg)> sum_avg;` | `boost::function4<void, int[], int, int&, float> sum_avg;` |

```cpp
void do_sum_avg(int values[], int n, int& sum, float& avg)
{
  sum = 0;
  for (int i = 0; i < n; i++)
    sum += values[i];
  avg = (float)sum / n;
}

sum_avg = &do_sum_avg;
```

関数オブジェクトを格納していないラッパを呼び出すのは事前条件違反である。ヌルの関数ポインタを呼び出そうとするようなものだ。関数オブジェクトのラッパが空かどうかは `empty()` メソッドでチェックできる。もっと簡潔なのは、 `bool` 型の文脈でラッパを使う方法だ。ラッパは、空でなければ `true` と評価される。例えば、

```cpp
if (f)
  std::cout << f(5, 3) << std::endl;
else
  std::cout << "f has no target, so it is unsafe to call" << std::endl;
```

ラッパを空にするには、 `clear()` メンバ関数を使う。


##Free functions
非メンバ関数へのポインタは、 `const` な関数呼出し演算子を持つ (インスタンスが1つだけ存在する) 関数オブジェクトの一種とみなせる。よって、関数オブジェクトのラッパに直接代入できる。

```cpp
float mul_ints(int x, int y) { return ((float)x) * y; }
f = &mul_ints;
```

Microsoft Visual C++ version 6 を使う場合を除けば、本当は `&` は不要だ。


##Member functions
多くのシステムで、コールバックは特定のオブジェクトのメンバ関数を呼び出すことが多い。これは「引数の束縛」と呼ばれ、 Boost.Function の守備範囲外である。しかし、 Boost.Function には直接メンバ関数を扱う方法がある。以下のコードのように使う。

```cpp
struct X {
  int foo(int);
};
```

| 推奨文法 | 互換文法 |
|----------|----------|
| `boost::function<int (X*, int)> f;` | `boost::function2<int, X*, int> f;` |

```cpp
f = &X::foo;
  
X x;
f(&x, 5);
```

引数の束縛をサポートするライブラリはいくつかある。その内 3 つを以下に要約する。

- [Boost.Bind](../bind.md)。このライブラリを使えば、あらゆる関数オブジェクトの引数を束縛できる。軽くて移植性が高い。
- C++ 標準ライブラリ。 `std::bind1st` と `std::mem_fun` を一緒に使って、メンバ関数ポインタと (その対象となる) オブジェクトを束縛したものは、 Boost.Function で使える。

```cpp
struct X {
  int foo(int);
};
```

| 推奨文法 | 互換文法 |
|----------|----------|
| `boost::function<int (int)> f;` | `boost::function1<int, int> f;` |

```cpp
X x;
f = std::bind1st(std::mem_fun(&X::foo), &x);

f(5); // x.foo(5)を呼び出す
```

- [Boost.Lambda](../lambda.md.nolink) ライブラリ。このライブラリは、自然な C++ の文法を使って関数オブジェクトを構築する強力な機構を提供する。 Lambda は、コンパイラが C++ 標準にかなり準拠していないと使えない。


##References to Functions
Boost.Function による関数オブジェクトのコピーが高価 (または不正) な場合がある。そんな場合は、 Boost.Function に実際の関数オブジェクトの「参照」を格納させることができる。`ref` や `cref` を使うことで、関数オブジェクトの参照のラッパを作成できる。

| 推奨文法 | 互換文法 |
|----------|----------|
| `stateful_type a_function_object;`<br/> `boost::function<int (int)> f;`<br/> `f = ref(a_function_object);`<br/> `boost::function<int (int)> f2(f);` | `stateful_type a_function_object;`<br/> `boost::function1<int, int> f;`<br/> `f = ref(a_function_object);`<br/> `boost::function1<int, int> f2(f);` |

こうすれば、 `f` も `f2` も `a_function_object` のコピーを作成しない。さらに、関数オブジェクトの参照を使えば、 Boost.Function は代入、構築時に例外を起こさない。


***
Douglas Gregor

Last modified: Fri Oct 11 05:40:00 EDT 2002

Japanese Translation Copyright © 2003 [Hiroshi Ichikawa](mailto:gimite@mx12.freecom.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

このドキュメントの対象: Boost Version 1.29.0

