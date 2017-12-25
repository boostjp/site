# Boost.Function Reference Manual

## Header `<boost/function.hpp>` synopsis

以下で、 `MAX_ARGS` は実装定義の定数であり、 Boost.Function でサポートされる引数の数の最大値 (少なくとも 10) である。このドキュメント中で参照される `MAX_ARGS` 定数は、ライブラリ中で直接的には定義されていない。

```cpp
namespace boost {
  class function_base
  {
    typedef implementation-defined safe_bool;
    bool empty() const;
  };

  // [0, MAX_ARGS] の範囲の全ての N について
  template<typename Signature,
           typename Arg1,
	   typename Arg2,
           ...
           typename ArgN,
	   typename Policy    = empty_function_policy, // 推奨されない
	   typename Mixin     = empty_function_mixin, // 推奨されない
	   typename Allocator = std::allocator<function_base> >
  class functionN : public function_base, public Mixin
  {
    typedef ResultType result_type; // [1]
    typedef Policy     policy_type; // 推奨されない
    typedef Mixin      mixin_type; // 推奨されない
    typedef Allocator  allocator_type;

    typedef Arg1 argument_type;        // N == 1 の場合

    typedef Arg1 first_argument_type;  // N == 2 の場合
    typedef Arg2 second_argument_type; // N == 2 の場合

    typedef Arg1 arg1_type;
    typedef Arg2 arg2_type;
             .
             .
             .
    typedef ArgN argN_type;

    enum { arity = N };

    // 構築
    explicit functionN(const Mixin& = Mixin());
    functionN(const functionN&);
    template<typename F> functionN(F, const Mixin& = Mixin());
    template<typename F> functionN(reference_wrapper<F>);
    
    // 代入
    functionN& operator=(const functionN&);
    template<typename F> functionN& operator=(F);
    template<typename F> functionN& operator=(reference_wrapper<F>);
    void set(const functionN&); // 推奨されない
    template<typename F> void set(F); // 推奨されない
    void swap(functionN&);
    void clear();

    // bool 型の文脈
    operator safe_bool() const;
    bool operator!() const;

    // 呼び出し
    result_type operator()(Arg1 a1, Arg2 a2, ..., ArgN aN) const;
  };

  template<typename ResultType,
           typename Arg1,
	   typename Arg2,
           ...
	   typename ArgN,
           typename Policy, // 推奨されない
           typename Mixin, // 推奨されない
           typename Allocator>
  void swap(functionN<ResultType, Arg1, Arg2, ..., ArgN, Policy, Mixin, Allocator>&,
            functionN<ResultType, Arg1, Arg2, ..., ArgN, Policy, Mixin, Allocator>&);

  // [0, MAX_ARGS] の範囲の全ての N について
  template<typename Signature, // 関数型: ResultType (Arg1, Arg2, ..., ArgN)
	   typename Policy    = empty_function_policy, // 推奨されない
	   typename Mixin     = empty_function_mixin, // 推奨されない
	   typename Allocator = std::allocator<function_base> >
  class function : public functionN<ResultType, Arg1, Arg2, ..., ArgN>
  {
    // 構築
    function();
    function(const function&);
    function(const functionN<ResultType, Arg1, Arg2, ..., ArgN>&);
    template<typename F> functionN(F);
    
    // 代入
    function& operator=(const function&);
    function& operator=(const functionN<ResultType, Arg1, Arg2, ..., ArgN>&);
    template<typename F> function& operator=(F);
    void set(const function&); // 推奨されない
    void set(const functionN<ResultType, Arg1, Arg2, ..., ArgN>&); // 推奨されない
    template<typename F> void set(F); // 推奨されない
  };

  template<typename Signature, typename Policy, typename Mixin, typename Allocator>
  void swap(function<Signature, Policy, Mixin, Allocator>&,
            function<Signature, Policy, Mixin, Allocator>&);
}
```
* [1][link #note]

## <a id="definitions" href="#definitions">定義</a>
- 引数型 `Arg1`, `Arg2`, ..., `ArgN` と戻り値型 `ResultType` に対して、該当する以下の関数が適格な時、関数オブジェクト `f` は「 互換性がある 」という。

	```cpp
// 関数型が void 以外の場合
ResultType foo(Arg1 arg1, Arg2 arg2, ..., ArgN argN)
{
  return f(arg1, arg2, ..., argN);
}

// 関数型が void の場合
ResultType foo(Arg1 arg1, Arg2 arg2, ..., ArgN argN)
{
  f(arg1, arg2, ..., argN);
}
	```

	メンバ関数ポインタには、特別な規定がある。メンバ関数ポインタは関数オブジェクトではないが、 Boost.Function は内部的にメンバ関数ポインタを関数オブジェクトに作り変える。 `R (X::*mf)(Arg1, Arg2, ..., ArgN) cv-quals` の形のメンバ関数ポインタは、以下のように関数呼出し演算子をオーバロードした関数オブジェクトに作り変えられる。

	```cpp
template<typename P>
R operator()(cv-quals P& x, Arg1 arg1, Arg2 arg2, ..., ArgN argN) const
{
  return (*x).*mf(arg1, arg2, ..., argN);
}
	```

- `F` が関数ポインタであるか、 `boost::is_stateless<T>` が真の時、 `F` 型の関数オブジェクト `f` は「 状態を持たない 」という。状態を持たない関数オブジェクトの Boost.Function での構築/コピーは発生せず、例外は起きず、記憶域の割り当ても起きない。


## Class `function_base`
クラス `function_base` は全ての Boost.Function オブジェクトに共通する基底クラスだ。 `function_base` 型のオブジェクトが直接作られることはないだろう。

```cpp
bool empty() const
```

- 戻り値: 関数オブジェクトを格納していれば `true` 、そうでなければ `false` 。
- 例外: 例外を起こさない。


## Class template `functionN`
クラステンプレート `functionN` は実際には、 `function0`, `function1`, ... と、ある実装定義の最大値まで続く、関連するクラス群である。以下の文では、 `N` はパラメータの数、 `f` は暗黙のオブジェクトパラメータを表す。

```cpp
explicit functionN(const Mixin& = Mixin());
```

- 作用: 与えられたミックスインから `Mixin` 型サブオブジェクトを構築する。
- 事後条件: `f.empty()`
- 例外: `Mixin` 型サブオブジェクトの構築で例外が起きない限り、例外を起こさない。


```cpp
functionN(const functionN& g);
```

- 事後条件: `g` が空でなければ、 `f` は `g` が格納する関数オブジェクトのコピーを格納する。 `g.empty()` ならば `f` も空になる。 `f` のミックスインは、 `g` のミックスインからコピーされる。
- 例外: `g` が格納する関数オブジェクトのコピーや `Mixin` 型サブオブジェクトの構築で例外が起きない限り、例外を起こさない。


```cpp
template<typename F> functionN(F g, const Mixin& = Mixin());
```

- 必須事項: `g` は[互換性がある](#definitions)関数オブジェクトであること。
- 作用: 与えられたミックスインから `Mixin` 型サブオブジェクトを構築する。
- 事後条件: `g` が空でなければ、 `f` は `g` のコピーを格納する。 `g` が空ならば、 `f.empty()` が真となる。
- 例外: `Mixin` 型サブオブジェクトの構築で例外が起きず、 `g` が状態を持たない関数オブジェクトならば、例外を起こさない。


```cpp
template<typename F> functionN(reference_wrapper<F> g);
```

- 必須事項: `g.get()` は[互換性がある](#definitions)関数オブジェクトであること。
- 作用: 与えられたミックスインから `Mixin` 型サブオブジェクトを構築する。
- 事後条件: `g.get()` が空でなければ、 `this` は `g` (`g.get()`のコピーではない) を格納する。 `g.get()` が空ならば、 `this->empty()` が真となる。
- 例外: `Mixin` 型サブオブジェクトの構築で例外が起きない限り、例外を起こさない。


```cpp
functionN& operator=(const functionN& g);
```

- 事後条件: `g` が空でなければ、 `f` は `g` が格納する関数オブジェクトのコピーを格納する。 `g.empty()` ならば、 `f` も空になる。 `f` のミックスインには `g` のミックスインが代入される。
- 戻り値: `*this`
- 例外: `g` が[状態を持たない](#definitions)関数オブジェクトを格納しているか、 `g` が関数オブジェクトへの参照を格納してる場合は、例外を起こさない。ただし、 `Mixin` 型サブオブジェクトのコピーで例外が起きた場合を除く。


```cpp
template<typename F> functionN& operator=(F g);
```

- 必須事項: `g` は互換性がある関数オブジェクトであること。
- 事後条件: `g` が空でなければ、 `f` は `g` のコピーを格納する。 `g` が空ならば、 `f.empty()` が真となる。
- 戻り値: `*this`
- 例外: `g` が状態を持たない関数オブジェクトを格納していれば、例外を起こさない。


```cpp
template<typename F> functionN& operator=(reference_wrapper<F> g);
```

- 必須事項: `g.get()` が互換性がある関数オブジェクトであること。
- 事後条件: `g.get()` が空でなければ、 `f` は `g.get()` ( `g.get()` のコピーではない) を格納する。 `g.get()` が空ならば、 `f.empty()` が真となる。
- 戻り値: `*this`
- 例外: `this` が格納していた関数オブジェクトの破棄で例外が起きた場合のみ、例外を起こす。


```cpp
void set(const functionN& g);
```

- 作用: `*this = g`
- 注意: この関数の使用は推奨されない。この関数は Boost.Function の将来のバージョンで削除される。代わりに代入演算子を使って欲しい。


```cpp
template<typename F> void set(F g);
```

- 作用: `*this = g`
- 注意: この関数の使用は推奨されない。この関数は Boost.Function の将来のバージョンで削除される。代わりに代入演算子を使って欲しい。


```cpp
void swap(functionN& g);
```

- 作用: `f` と `g` が格納する関数オブジェクトを交換し、 `f` と `g` のミックスインを交換する。
- 例外: 例外は発生しない。


```cpp
void clear();
```

- 作用: `!empty()`ならば、格納する関数オブジェクトを破棄する。
- 事後条件: `empty()`が真になる。


```cpp
operator safe_bool() const;
```

- 戻り値: `!empty()`と等価な`safe_bool` 。
- 例外: 例外は発生しない。
- 注意: `safe_bool` 型は bool 型が予想される場所 (例: `if` の条件) に使用できる。しかし、 `bool` 型で起きる暗黙の型変換 (例: `int`型への変換) は許されない。これによってユーザの間違いの元を減らせることがある。


```cpp
bool operator!() const
```

- 戻り値: `this->empty()`
- 例外: 例外は発生しない。


```cpp
result_type operator()(Arg1 a1, Arg2 a2, ..., ArgN aN) const;
```

- 必須事項: !empty()
- 作用: 以下で、 `target` は格納された関数オブジェクトである。 `target` 変数には `const` 修飾子や `volatile` 修飾子が付いていない (ので、関数呼出し演算子に `const` 修飾子や `volatile` 修飾子が付いている必要はない) 。
	1. `policy_type policy;`
	2. `policy.precall(this);`
	3. `target(a1, a2, ..., aN);`
	4. `policy.postcall(this);`
- 戻り値: `target` の戻り値。
- 注意: 呼び出しポリシーは推奨されなくなり、今後のリリースで削除される。


## Class template `function`
クラステンプレート `function` は、番号付きクラステンプレート `function0`, `function1`, ... の薄いラッパである。 `MAX_ARGS` までの引数を受け付ける。 `N` 個の引数を渡されれば、 `functionN` (引数 `N` 個専用のクラス) から派生する。

クラステンプレート `function` のメンバ関数のセマンティクスは、全て `functionN` オブジェクトと同じである。ただし、 `function` オブジェクトの正しいコピーコンストラクトやコピーの代入のために、追加のメンバ関数を定義している。


### Operations

```cpp
template<typename ResultType,
         typename Arg1,
	 typename Arg2,
         ...
	 typename ArgN,
         typename Policy, // 推奨されない
         typename Mixin, // 推奨されない
         typename Allocator>
void swap(functionN<ResultType, Arg1, Arg2, ..., ArgN, Policy, Mixin, Allocator>& f,
          functionN<ResultType, Arg1, Arg2, ..., ArgN, Policy, Mixin, Allocator>& g);
```

- 作用: `f.swap(g);`

```cpp
template<typename Signature, typename Policy, typename Mixin, typename Allocator>
void swap(function<Signature, Policy, Mixin, Allocator>& f,
          function<Signature, Policy, Mixin, Allocator>& g);
```

- 作用: `f.swap(g);`


## <a id="note" href="#note">脚注</a>
- [1] : コンパイラが `void` 型の `return` をサポートしていない場合、 `ReturnType` に `void` を指定すると、 Boost.Function オブジェクトの `result_type` は実装依存になる。


***
Douglas Gregor

Last modified: Fri Oct 11 05:40:09 EDT 2002

Japanese Translation Copyright © 2003 [Hiroshi Ichikawa](mailto:gimite@mx12.freecom.ne.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

このドキュメントの対象: Boost Version 1.29.0

