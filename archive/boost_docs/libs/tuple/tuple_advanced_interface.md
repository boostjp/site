# Tuple library advanced features

この文書で解説されている上位の機能はすべて、名前空間 `::boost::tuples` にある。

## タプル型のためのメタ関数

`T` はタプル型であり、`N` は汎整数定数式であるとする。

```cpp
element<N, T>::type
```

これはタプル型 `T` の `N` 番目の要素の型となる。

```cpp
length<T>::value
```

これはタプル型 `T` の要素数となる。

## consリスト

タプルは内部的には *consリスト* として表現されている。
例えば、タプル

```cpp
tuple<A, B, C, D>
```

は、型

```cpp
cons<A, cons<B, cons<C, cons<D, null_type> > > >
```

を継承している。
タプル テンプレートは、consリストにアクセスするため、typedef名 `inherited` を提供している。
例えば: `tuple<A>::inherited` は型 `cons<A, null_type>` である。

#### 空タプル

空タプル `tuple<>` の内部表現は `null_type` である。

#### headとtail

タプル テンプレートとconsテンプレートのどちらも、typedef名 `head_type` と `tail_type` を提供している。
`head_type` は、タプル(またはconsリスト)の最初の要素の型となる。
`tail_type` は、最初の要素を除いたconsリストの残りの部分となる。
最初の要素は、メンバ変数 `head` に格納されており、tailリストはメンバ変数 `tail` にある。
consリストは、そのheadへの参照を得るためにメンバ関数 `get_head()` を、またtailへの参照を得るためにメンバ関数 `get_tail()` を提供している。
どちらの関数にも、constおよび非constのバージョンがある。

1要素のタプルにおいては、`tail_type` は `null_type` と等しく、`get_tail()` 関数は `null_type` のオブジェクトを返す。

空タプル(`null_type`)にはheadもtailも無い。
だから `get_head` および `get_tail` 関数は提供されない。

タプルをconsリストとして扱うと、タプルを操作するためのジェネリックな関数を定義するのが楽になる。
例えば、次の二つの関数テンプレートは、タプルのそれぞれの要素に0を代入する(もちろん、要素型にとって代入は正当な操作でなければならない):

```cpp
inline void set_to_zero(const null_type&) {};

template <class H, class T>
inline void set_to_zero(cons<H, T>& x) { x.get_head() = 0; set_to_zero(x.get_tail()); }
```

#### consリストを構築する

consリストは、もし全ての要素がデフォルト コンストラクト可能であれば、デフォルト コンストラクト可能である。

consリストは、headおよびtailから構築可能である。コンストラクタのプロトタイプは:

```cpp
cons(typename access_traits<head_type>::parameter_type h,
     const tail_type& t)
```

headパラメータの特性テンプレートは、任意の要素型に対して、適切なパラメータ型を選択する(参照型の要素では、パラメータ型は要素型と同じ、非参照型では、パラメータ型はconst非volatileへの参照となる)。

1要素のconsリストでは、tail引数(`null_type`)は省略してよい。

## タプル要素型の特性クラス

#### `access_traits`

テンプレート `access_traits` は3つの型関数を定義する。
`T` があるタプルの要素型であるとしよう。

- `access_traits<T>::type` は、非constのアクセス関数(非メンバおよびメンバの `get` 関数、`get_head` 関数)の返却値型になる。
- `access_traits<T>::const_type` は、constのアクセス関数の返却値型になる。
- `access_traits<T>::parameter_type` は、タプルのコンストラクタのパラメータ型になる。

#### `make_tuple_traits`

`make_tuple` 関数によって生成されるタプルの要素型は、型関数 `make_tuple_traits` により求められる。
型関数呼び出し `make_tuple_traits<T>::type` は、次のように型を対応付ける:

- 参照型 -&gt; *コンパイル時エラー*
- *配列型* -&gt; *配列型へのconst参照*
- `reference_wrapper<T>` -&gt; `T&`
- `T` -&gt; `T`

型 `reference_wrapper` のオブジェクトは、`ref` または `cref` 関数によって生成されるものである([`make_tuple` 関数](../tuple.md#make_tuple)を参照されたい)。

参照ラッパはそもそもはtuple libraryの一部であったが、今やboostの汎用的なユーティリティとなった。
`reference_wrapper` テンプレートと `ref` および `cref` 関数は、主boostインクルードディレクトリにある別のファイル `ref.hpp` において、直接 `boost` 名前空間に定義されている。

---

(c) Copyright Jaakko Jarvi 2001.

Japanese Translation Copyright (C) 2003 Yoshinori Tagawa.
オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の 複製、利用、変更、販売そして配布を認める。
このドキュメントは「あるがまま」 に提供されており、いかなる明示的、暗黙的保証も行わない。
また、 いかなる目的に対しても、その利用が適していることを関知しない。

