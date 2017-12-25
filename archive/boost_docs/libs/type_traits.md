# Header &lt;[boost/type_traits.hpp](http://www.boost.org/doc/libs/1_31_0/boost/type_traits.hpp)&gt;

&lt;boost/type_traits.hpp&gt; の内容は boost 名前空間内で宣言される。

ファイル &lt;[boost/type_traits.hpp](http://www.boost.org/doc/libs/1_31_0/boost/type_traits.hpp)&gt; は、型の基本的な特徴を説明する様々なテンプレートクラスを含んでいる。
各クラスは単一の型の特徴または単一の型の変形を意味する。
本ライブラリに不慣れであれば、付随する [記事](http://www.boost.org/doc/libs/1_31_0/libs/type_traits/c++_type_traits.htm) を最初に読むこと。

このドキュメントは以下のセクションに分割される。

- [Primary Type Categorisation](#primary)
- [Secondary Type Categorisation](#secondary)
- [Type Properties](#properties)
- [Relationships Between Types](#relationships)
- [Transformations Between Types](#transformations)
- [Synthesizing Types](#synthesized)
- [Function Traits](#function_traits)
- [Compiler Support Information](#compiler)
- [Type traits headers](#headers)
- [Example Code](#example)

本ライブラリにおける汎整数式はすべて [*汎整数定数式*](http://www.boost.org/doc/libs/1_31_0/more/int_const_guidelines.htm) である。
それらの使用は時折コンパイラの問題に遭遇する原因となるため, 本ライブラリを用いて移植性のあるコードを書くための手引きとして [コーディングガイドライン](http://www.boost.org/doc/libs/1_31_0/more/int_const_guidelines.htm) に関連した事項がある。

## <a id="primary">Primary Type Categorisation</a>

以下の型特性（type traits）テンプレートは型がどの型分類に属しているかを識別する。
どんな型を与えた場合でも、以下の式のうちのひとつは確実に真に評価される。

`is_integral<T>::value` と `is_float<T>::value` は組み込み型についてのみ当てはまることに注意。
あたかも汎整数型や浮動小数点型のように振舞うユーザ定義型を調べるのであれば、代わりに `std::numeric_limits` テンプレートを使うこと。

| Expression | Description | Reference | Compiler requirements |
|------------|-------------|-----------|-----------------------|
| `::boost::is_void<T>::value` | `T` が const/volatile 修飾された void 型であれば真に評価する。 | 3.9.1p9 | |
| `::boost::is_integral<T>::value` | `T` が const/volatile 修飾された汎整数型であれば真に評価する。 | 3.9.1p7 | |
| `::boost::is_float<T>::value` | `T` が const/volatile 修飾された浮動小数点型であれば真に評価する。 | 3.9.1p8 | |
| `::boost::is_pointer<T>::value` | `T` が const/volatile 修飾されたポインタ型であれば真に評価する（関数ポインタは含まれるが、メンバへのポインタは含まない）。 | 3.9.2p2, 8.3.1 | |
| `::boost::is_reference<T>::value` | `T` が参照型であれば真に評価する。 | 3.9.2, 8.3.2 | |
| `::boost::is_member_pointer<T>::value` | `T` が const/volatile 修飾されたデータメンバまたはメンバ関数へのポインタであれば真に評価する。 | 3.9.2, 8.3.3 | |
| `::boost::is_array<T>::value` | `T` が配列型であれば真に評価する。 | 3.9.2, 8.3.4 | コンパイラがクラステンプレートの部分特殊化版をサポートしていない場合、型によっては間違って配列と認識されることがある（主に関数型）。 |
| `::boost::is_union<T>::value` | `T` が共用体型であれば真に評価する。現時点ではある種のコンパイラのサポートを必要とし、それ以外では共用体はクラスとして識別される。 | 3.9.2, 9.5 | C |
| `::boost::is_class<T>::value` | `T` がクラス/構造体型であれば真に評価する。 | 3.9.2, 9.2 | C |
| `::boost::is_enum<T>::value` | `T` が列挙型であれば真に評価する。 | 3.9.2, 7.2 | `is_convertible` テンプレートが正しく機能することが必要（現時点では `is_enum` が Borland C++ では使えないという意味）。 |
| `::boost::is_function<T>::value` | `T` が関数型であれば真に評価する（関数への参照やポインタではない）。 | 3.9.2p1, 8.3.5 | 部分特殊化版がサポートされない場合、このテンプレートは参照型についてはコンパイルできない。 |

## <a id="secondary">Secondary Type Categorisation</a>

以下の型分類は１つ以上の primary type categorisations を組み合わせて作られている。
ある型は、primary type categorisations の分類に加えて、これらの分類のうちの１つ以上に属している可能性がある。

| Expression | Description | Reference | Compiler requirements |
|------------|-------------|-----------|-----------------------|
| `::boost::is_arithmetic<T>::value` | `T` が const/volatile 修飾された算術型であれば真に評価する。汎整数型か浮動小数点型のいずれかがこれにあたる。 | 3.9.1p8 | |
| `::boost::is_fundamental<T>::value` | `T` が const/volatile 修飾された基本型であれば真に評価する。汎整数型、浮動小数点型、void 型のいずれかがこれにあたる。 | 3.9.1 | |
| `::boost::is_object<T>::value` | `T` が const/volatile 修飾されたオブジェクト型であれば真に評価する。関数型、参照型、void 型以外がこれにあたる。 | 3.9p9 | |
| `::boost::is_scalar<T>::value` | `T` が const/volatile 修飾されたスカラ型であれば真に評価する。算術型、ポインタ型、メンバへのポインタ型がこれにあたる。 | 3.9p10 | |
| `::boost::is_compound<T>::value` | `T` が複合型であれば真に評価する。関数型、ポインタ型、参照型、列挙型、共用体型、クラス型、メンバ関数型がこれにあたる。 | 3.9.2 | |
| `::boost::is_member_function_pointer<T>::value` | `T` がメンバ関数へのポインタ型（メンバオブジェクトへのポインタではない）であれば真に評価する。このテンプレートは `is_member_pointer` を２つの副分類に分割する。 | 3.9.2, 8.3.3 | |

## <a id="properties">Type Properties</a>

以下のテンプレートは型が持っている特徴を識別する。

| Expression | Description | Reference | Compiler requirements |
|------------|-------------|-----------|-----------------------|
| `::boost::alignment_of<T>::value` | `T` が必要とするアラインメントを識別する。実際に返される値は、Tが必要とする実際のアラインメントの倍数となることが保証される。 | | |
| `::boost::is_empty<T>::value` | `T` が空の構造体やクラスである場合に真。コンパイラが &quot;空の基底クラスのサイズを 0 にする&quot; 最適化を実装しているのであれば、 `is_empty` は `T` が空であることを正しく推察する。 `is_class` が `T` がクラス型であることを判別できることが前提。 | 10p5 | PCD |
| `::boost::is_const<T>::value` | `T` がトップレベルで const 修飾されている場合に真に評価する。 | 3.9.3 | |
| `::boost::is_volatile<T>::value` | `T` が volatile 修飾されていれば真に評価する。 | 3.9.3 | |
| `::boost::is_POD<T>::value` | `T` が const/volatile 修飾された POD 型（訳註:Plain Old Data。非静的データメンバ、仮想関数、基本クラス、ユーザー定義コンストラクタ、コピーコンストラクタ、コピー代入演算子、およびデストラクタが含まれる）であれば真に評価する。 | 3.9p10, 9p4 | |
| `::boost::has_trivial_constructor<T>::value` | `T` が自明なデフォルトコンストラクタを持っている、すなわち `T()` が `memset` と同等であれば真。 | | PC |
| `::boost::has_trivial_copy<T>::value` | `T` が自明なコピーコンストラクタを持っている、すなわち `T(const T&)` が `memcpy` と同等であれば真。 | | PC |
| `::boost::has_trivial_assign<T>::value` | `T` が自明な代入演算子を持っている、すなわち `T::operator=(const T&)` が `memcpy` と同等であれば真。 | | PC |
| `::boost::has_trivial_destructor<T>::value` | `T` が自明なデストラクタを持っている、すなわち `T::~T()` が効果なしであれば真。 | | PC |
| `::boost::is_stateless<T>::value` | `T` が実体を持たない、要するに `T` が記憶領域を持たず、コンストラクタとデストラクタがトリビアルであれば真。 | | PC |
| `::boost::has_nothrow_constructor<T>::value` | `T` が例外を発生させないデフォルトコンストラクタを持っていれば真。 | | PC |
| `::boost::has_nothrow_copy<T>::value` | `T` が例外を発生させないコピーコンストラクタを持っていれば真。 | | PC |
| `::boost::has_nothrow_assign<T>::value` | `T` が例外を発生させない代入演算子を持っていれば真。 | | PC |

## <a id="relationships">Relationships Between Types</a>

以下のテンプレートは２つの型の間に関連性があるかどうかを調べる。

| Expression | Description | Reference | Compiler requirements |
|------------|-------------|-----------|-----------------------|
| `::boost::is_same<T,U>::value` | `T` と `U` が同じ型であれば真に評価する。 | | |
| `::boost::is_convertible<T,U>::value` | 型 `T` が型 `U` に変換できるのであれば真に評価する。 | 4, 8.5 | このテンプレートは、Borland のコンパイラではコンストラクタベースの変換について、Metrowerks のコンパイラではすべての場合について、現時点では使用できないことに注意。 |
| `::boost::is_base_and_derived<T,U>::value` | 型 `T` が型 `U` の基底クラスであれば真に評価する。 | 10 | P |

`is_convertible` および `is_base_and_derived` では、変換があいまいな場合にはコンパイラがエラーを出すので注意すること。

```cpp
struct A {};
struct B : A {};
struct C : A {};
struct D : B, C {};
bool const x = boost::is_base_and_derived<A,D>::value;  // エラー
bool const y = boost::is_convertible<D*,A*>::value;     // エラー
```

## <a id="transformations">Transformations Between Types</a>

以下のテンプレートは、ある型を別の型に、いくつかの明確な規則に基づいて変形する。
各テンプレートにはテンプレート引数 `T` を変形した結果である `type` という名のメンバがひとつだけ含まれている。

| Expression | Description | Reference | Compiler requirements |
|------------|-------------|-----------|-----------------------|
| `::boost::remove_const<T>::type` | `T` と同じ型であるが、トップレベルの const 修飾子を取り除いた型を作る。例えば、`const int` は `int` になるが、`const int*` は変化しないままとなる。 | 3.9.3 | P |
| `::boost::remove_volatile<T>::type` | `T` と同じ型であるが、トップレベルの volatile 修飾子を取り除いた型を作る。例えば、`volatile int` は `int` になる。 | 3.9.3 | P |
| `::boost::remove_cv<T>::type` | `T` と同じ型であるが、トップレベルの const/volatile 修飾子を取り除いた型を作る。例えば、`const volatile int` は `int` になるが、`const int*` は変化せずそのままとなる。 | 3.9.3 | P |
| `::boost::remove_reference<T>::type` | `T` が参照型であれば参照を取り除き、そうでなければ `T` は変化せずそのままとなる。例えば、`int&` は `int` になるが、`int*` は変化しないままである。 | 8.3.2 | P |
| `::boost::remove_bounds<T>::type` | `T` が配列型であれば `T` からトップレベルの配列修飾子を取り除き、そうでなければ `T` は変化せずそのままとなる。例えば、`int[2][3]` は `int[3]` になる。 | 8.3.4 | P |
| `::boost::remove_pointer<T>::type` | `T` がポインタ型であれば `T` から間接修飾を取り除き、そうでなければ `T` は変化せずそのままとなる。例えば、`int*` は `int` になるが、`int&` は変化しないままである。 | 8.3.1 | P |
| `::boost::add_reference<T>::type` | `T` が参照型であれば `T` は変化せずそのままとなり、そうでなければ `T` への参照型に変換する。例えば、`int&` は変化せずにそのままであるが、`double` は `double&` になる。 | 8.3.2 | P |
| `::boost::add_pointer<T>::type` | `t` が `T` のインスタンスであるとき、`add_pointer<T>::type` は `&t` が返す型である。例えば、`int` と `int&` はともに `int*` になる。 | 8.3.1 | P |
| `::boost::add_const<T>::type` | あらゆる `T` に対して `T const` と同じ。 | 3.9.3 | |
| `::boost::add_volatile<T>::type` | あらゆる `T` に対して `T volatile` と同じ。 | 3.9.3 | |
| `::boost::add_cv<T>::type` | あらゆる `T` に対して `T const volatile` と同じ。 | 3.9.3 | |

上記の表が示すように、型変形テンプレートを正しく実装するには部分特殊化版のサポートが必要である。
一方で、経験上この分類に属するテンプレートの多くは非常に有益であり、ジェネリックライブラリの実装においてしばしば必須となる。
これらのテンプレートが不足していると、それらのライブラリを部分特殊化版の言語仕様をまだサポートしていないコンパイラに移植する上で大きな制約要因となる。
そうしたコンパイラの中にはしばらく部分特殊化版をサポートしないものがあり、少なくともそのうちの１つは非常に広く普及しているため、ライブラリでは移植を実現させるための回避手段を提供することにした。
回避手段を裏付ける基本的なアイデアは以下の通り。

- 全ての基本型と、それらから導かれる１段階および２段階の const/volatile 修飾された（または修飾されていない）全てポインタ型についての全型変形テンプレートの完全な特殊化版を手作業で定義する。そして、
- いかなるユーザ定義型 `T` に対してそうした明示的な特殊化版を定義できるようようにユーザレベルマクロを提供する。

最初の内容はこのようなものであり、コンパイルに成功することが保証されている。

```cpp
BOOST_STATIC_ASSERT((is_same<char, remove_reference<char&>::type>::value));

BOOST_STATIC_ASSERT((is_same<char const, remove_reference<char const&>::type>::value));

BOOST_STATIC_ASSERT((is_same<char volatile, remove_reference<char volatile&>::type>::value));

BOOST_STATIC_ASSERT((is_same<char const volatile, remove_reference<char const volatile&>::type>::value));

BOOST_STATIC_ASSERT((is_same<char*, remove_reference<char*&>::type>::value));

BOOST_STATIC_ASSERT((is_same<char const*, remove_reference<char const*&>::type>::value));

...

BOOST_STATIC_ASSERT((is_same<char const volatile* const volatile* const volatile, remove_reference<char const volatile* const volatile* const volatile&>::type>::value));
```

そして次の内容は `char`、`int` や他の組み込み型だけでなく、独自に定義された型に対しても上記のコードを働かせるための仕組みをライブラリのユーザに提供する。

```cpp
struct my {};

BOOST_BROKEN_COMPILER_TYPE_TRAITS_SPECIALIZATION(my)

BOOST_STATIC_ASSERT((is_same<my, remove_reference<my&>::type>::value));

BOOST_STATIC_ASSERT((is_same<my, remove_const<my const>::type>::value));

// etc.
```

部分特殊化版がサポートされないコンパイラでは、`BOOST_BROKEN_COMPILER_TYPE_TRAITS_SPECIALIZATION` は中身のないマクロとして評価されることに注意。

## <a id="synthesized">Synthesizing Types</a>

以下のテンプレートは要求した特徴を持った型を作り出す。

| Expression | Description | Reference | Compiler requirements |
|------------|-------------|-----------|-----------------------|
| `::boost::type_with_alignment<Align>::type` | Align の倍数に整列された組み込み型または POD 型を見つける。 | | |

## <a id="function_traits">Function Traits</a>

`::boost::function_traits` クラステンプレートは関数型から情報を取り出す。

| Expression | Description | Reference | Compiler requirements |
|------------|-------------|-----------|-----------------------|
| `::boost::function_traits<F>::arity` | 関数型 `F` の引数の数を調べる。 | | 部分特殊化版がサポートされない場合、このテンプレートは参照型についてはコンパイルできない。 |
| `::boost::function_traits<F>::result_type` | 関数型 `F` が返す型。 | | P |
| `::boost::function_traits<F>::argN_type` | 関数型 `F` の第 *N* （1≦N≦Fの引数の数）引数の型。 | | P |

## <a id="compiler">Compiler Support Information</a>

上の表中にある記号の意味は以下の通り。

- **P**: クラスが正しく働くためにはクラステンプレートの部分特殊化版のサポートを必要としていることを示す。
- **C**: その特性クラスのためにコンパイラの直接的なサポートが必要であることを示す。
- **D**: 特性クラスがコンパイラの直接的なサポートを必要とするクラスに依存していることを示す。

D や C の印が付いたクラスに対して、コンパイラのサポートが受けられなければ、この型特性は実際には &quot;真&quot; が正しい場合に &quot;偽&quot; を返すことがある。
この規則の唯一の例外は `is_class` で、`T` が本当にクラスかどうかの推量を試みるにあたって、実際には &quot;偽&quot; が正しい場合に &quot;真&quot; を返すことがある。
こうしたことが起こるのは、`T` が共用体あるいはコンパイラ独自のスカラ型（それらの型特性が特化されていない）の場合である。

*コンパイラがサポートしていない場合*、これらの特性が *常に* 正しい値を返すことを保証するには、ユーザ定義のそれぞれの共用体型に対して `is_union` を、ユーザ定義のそれぞれの空の複合型に対して `is_empty` を、そしてユーザ定義のそれぞれの POD 型に対して `is_POD` を特化しなければならない。
ユーザ定義型が `has_*` 特性を持っており POD *はない* 場合には、`has_*` 特性もまた特化すべきである。

以下の規則が自動的に当てはまる。

- `is_enum` は `is_POD` でもある。
- `is_POD` は `has_*` でもある。

これが意味するのは、例えば、空の POD 構造体がある場合には、`is_empty` と `is_POD` を特化し、すべての `has_*` が真を返すようにするということである。

## <a id="headers">Type Traits Headers</a>

型特性ライブラリは通常下記をインクルードする。

```cpp
#include <boost/type_traits.hpp>
```

とはいえ、ライブラリは実際にはいくつかのより小さいヘッダに分かれており、ときには実際に必要な型特性クラスを得るためにその中のひとつを直接インクルードする方が便利なことがある。
しかし型特性クラスは相互依存性が高いことに注意すること。
したがって、この方法は意外に節減にはならないかもしれない。
以下の表では型特性クラスをアルファベット順に、各テンプレートが収められたヘッダとともに並べる。

| Template class               | Header                                      |
|------------------------------|---------------------------------------------|
| `add_const`                  | `<boost/type_traits/transform_traits.hpp>`  |
| `add_const`                  | `<boost/type_traits/transform_traits.hpp>`  |
| `add_pointer`                | `<boost/type_traits/transform_traits.hpp>`  |
| `add_reference`              | `<boost/type_traits/transform_traits.hpp>`  |
| `add_volatile`               | `<boost/type_traits/transform_traits.hpp>`  |
| `alignment_of`               | `<boost/type_traits/alignment_traits.hpp>`  |
| `has_trivial_assign`         | `<boost/type_traits/object_traits.hpp>`     |
| `function_traits`            | `<boost/type_traits/function_traits.hpp>`   |
| `has_trivial_constructor`    | `<boost/type_traits/object_traits.hpp>`     |
| `has_trivial_copy`           | `<boost/type_traits/object_traits.hpp>`     |
| `has_trivial_destructor`     | `<boost/type_traits/object_traits.hpp>`     |
| `is_arithmetic`              | `<boost/type_traits/arithmetic_traits.hpp>` |
| `is_array`                   | `<boost/type_traits/composite_traits.hpp>`  |
| `is_base_and_derived`        | `<boost/type_traits/object_traits.hpp>`     |
| `is_class`                   | `<boost/type_traits/object_traits.hpp>`     |
| `is_compound`                | `<boost/type_traits/object_traits.hpp>`     |
| `is_const`                   | `<boost/type_traits/cv_traits.hpp>`         |
| `is_convertible`             | `<boost/type_traits/conversion_traits.hpp>` |
| `is_empty`                   | `<boost/type_traits/object_traits.hpp>`     |
| `is_enum`                    | `<boost/type_traits/composite_traits.hpp>`  |
| `is_float`                   | `<boost/type_traits/arithmetic_traits.hpp>` |
| `is_function`                | `<boost/type_traits/function_traits.hpp>`   |
| `is_fundamental`             | `<boost/type_traits/arithmetic_traits.hpp>` |
| `is_integral`                | `<boost/type_traits/arithmetic_traits.hpp>` |
| `is_member_pointer`          | `<boost/type_traits/composite_traits.hpp>`  |
| `is_member_function_pointer` | `<boost/type_traits/composite_traits.hpp>`  |
| `is_object`                  | `<boost/type_traits/object_traits.hpp>`     |
| `is_POD`                     | `<boost/type_traits/object_traits.hpp>`     |
| `is_pointer`                 | `<boost/type_traits/composite_traits.hpp>`  |
| `is_reference`               | `<boost/type_traits/composite_traits.hpp>`  |
| `is_same`                    | `<boost/type_traits/same_traits.hpp>`       |
| `is_scalar`                  | `<boost/type_traits/object_traits.hpp>`     |
| `is_union`                   | `<boost/type_traits/composite_traits.hpp>`  |
| `is_void`                    | `<boost/type_traits/arithmetic_traits.hpp>` |
| `is_volatile`                | `<boost/type_traits/cv_traits.hpp>`         |
| `remove_bounds`              | `<boost/type_traits/transform_traits.hpp>`  |
| `remove_const`               | `<boost/type_traits/cv_traits.hpp>`         |
| `remove_cv`                  | `<boost/type_traits/cv_traits.hpp>`         |
| `remove_pointer`             | `<boost/type_traits/transform_traits.hpp>`  |
| `remove_reference`           | `<boost/type_traits/transform_traits.hpp>`  |
| `remove_volatile`            | `<boost/type_traits/cv_traits.hpp>`         |
| `type_with_alignment`        | `<boost/type_traits/alignment_traits.hpp>`  |

## <a id="example">Example code</a>

型特性テンプレートを使用できるいくつかの方法を説明したプログラム例が４つある。

### Copy_example.cpp

`std::copy` のコピー操作を最適化するために適宜 `memcpy` を使用するバージョンを示す。

```cpp
//
// opt::copy
// std::copy と同じセマンティクス
// 適宜 memcpy を呼び出す。
//

namespace detail{

template<typename I1, typename I2>
I2 copy_imp(I1 first, I1 last, I2 out)
{
	while(first != last)
	{
		*out = *first;
		++out;
		++first;
	}
	return out;
}

template <bool b>
struct copier
{
	template<typename I1, typename I2>
	static I2 do_copy(I1 first, I1 last, I2 out)
	{ return copy_imp(first, last, out); }
};

template <>
struct copier<true>
{
	template<typename I1, typename I2>
	static I2* do_copy(I1* first, I1* last, I2* out)
	{
		memcpy(out, first, (last-first)*sizeof(I2));
		return out+(last-first);
	}
};

}

template<typename I1, typename I2>
inline I2 copy(I1 first, I1 last, I2 out)
{
	typedef typename boost::remove_cv<typename std::iterator_traits<I1>::value_type>::type v1_t;
	typedef typename boost::remove_cv<typename std::iterator_traits<I2>::value_type>::type v2_t;
	return detail::copier<
		::boost::type_traits::ice_and<
			::boost::is_same<v1_t, v2_t>::value,
			::boost::is_pointer<I1>::value,
			::boost::is_pointer<I2>::value,
			::boost::has_trivial_assign<v1_t>::value
		>::value>::do_copy(first, last, out);
}
```

### fill_example.cpp

`std::fill` の充填操作を最適化するために適宜 `memset` を使用するバージョンを示す。
また、エイリアシング問題を避けるため、引数の受け渡しを最適化するために `call_traits` を使用する。

```cpp
namespace opt{
//
// fill
// std::fill と同じ。引数の受け渡しの"最適化"のために
// call_traits とともに適宜 memset を使用する。
//
//
namespace detail{

template <typename I, typename T>
void do_fill_(I first, I last, typename boost::call_traits<T>::param_type val)
{
	while(first != last)
	{
		*first = val;
		++first;
	}
}

template <bool opt>
struct filler
{
	template <typename I, typename T>
	struct rebind
	{
		static void do_fill(I first, I last, typename boost::call_traits<T>::param_type val)
		{ do_fill_<I,T>(first, last, val); }
	};
};

template <>
struct filler<true>
{
	template <typename I, typename T>
	struct rebind
	{
		static void do_fill(I first, I last, T val)
		{
			std::memset(first, val, last-first);
		}
	};
};

}

template <class I, class T>
inline void fill(I first, I last, const T& val)
{
	typedef detail::filler<
		::boost::type_traits::ice_and<
			::boost::is_pointer<I>::value,
			::boost::is_arithmetic<T>::value,
			(sizeof(T) == 1)
		>::value> filler_t;
	typedef typename filler_t:: template rebind<I,T> binder;
	binder::do_fill(first, last, val);
}

};   // namespace opt
```

### iter_swap_example.cpp

`std::iter_swap` の正規のものと同様の代替イテレータとともに動作するバージョンを示す。
それは、正規のイテレータに対して `std::swap` を呼び出すか、あるいは &quot;遅いけれども安全&quot; な `swap` を呼び出す。

```cpp
namespace opt{
//
// iter_swap:
// イテレータが代替イテレータかどうかを調べ、
// それに応じて最適な形式を使う。
//
namespace detail{

template <bool b>
struct swapper
{
	template <typename I>
	static void do_swap(I one, I two)
	{
		typedef typename std::iterator_traits<I>::value_type v_t;
		v_t v = *one;
		*one = *two;
		*two = v;
	}
};

template <>
struct swapper<true>
{
	template <typename I>
	static void do_swap(I one, I two)
	{
		using std::swap;
		swap(*one, *two);
	}
};

}

template <typename I1, typename I2>
inline void iter_swap(I1 one, I2 two)
{
	typedef typename std::iterator_traits<I1>::reference r1_t;
	typedef typename std::iterator_traits<I2>::reference r2_t;
	detail::swapper<
		::boost::type_traits::ice_and<
			::boost::is_reference<r1_t>::value,
			::boost::is_reference<r2_t>::value,
			::boost::is_same<r1_t, r2_t>::value
		>::value>::do_swap(one, two);
}

};   // namespace opt
```

### Trivial_destructor_example.cpp

このアルゴリズムは `std::uninitialized_copy` の逆である。
初期化済みのメモリブロックを受け取り、その中のすべてのオブジェクトに対してデストラクタを呼び出す。
これは一般には自分自身でメモリ管理を行うコンテナクラスの内部で使われる。

```cpp
namespace opt{
//
// アルゴリズムdestroy_array:
// std::unitialized_copyの逆で、初期化済みのメモリブロックを受け取り、
// その中の全オブジェクトに対してデストラクタを呼び出す。
//

namespace detail{

template <bool>
struct array_destroyer
{
	template <class T>
	static void destroy_array(T* i, T* j){ do_destroy_array(i, j); }
};

template <>
struct array_destroyer<true>
{
	template <class T>
	static void destroy_array(T*, T*){}
};

template <class T>
void do_destroy_array(T* first, T* last)
{
	while(first != last)
	{
		first->~T();
		++first;
	}
}

}; // namespace detail

template <class T>
inline void destroy_array(T* p1, T* p2)
{
	detail::array_destroyer<boost::has_trivial_destructor<T>::value>::destroy_array(p1, p2);
}
} // namespace opt
```

Revised 22 April 2001

Documentation (c) Copyright John Maddock 2001.
Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies.
This document is provided &quot;as is&quot; without express or implied warranty, and with no claim as to its suitability for any purpose.

The type traits library is based on contributions by Steve Cleary, Beman Dawes, Aleksey Gurtovoy, Howard Hinnant, Jesse Jones, Mat Marcus, John Maddock and Jeremy Siek.

Mat Marcus and Jesse Jones have worked on, and published a [paper](http://opensource.adobe.com/project4/project.shtml) describing the partial specialisation workarounds used in this library.

The is_convertible template is based on code originally devised by Andrei Alexandrescu, see &quot;[Generic&lt;Programming&gt;: Mappings between Types and Values](http://www.cuj.com/experts/1810/alexandr.htm?topic=experts)&quot;.

Maintained by [John Maddock](http://www.boost.org/doc/libs/1_31_0/people/john_maddock.htm), the latest version of this file can be found at [www.boost.org](http://www.boost.org/), and the boost discussion list at [www.yahoogroups.com/list/boost](http://www.yahoogroups.com/list/boost).

Japanese Translation Copyright (c) 2003 [Takagi,Yusei](mailto:yusei-t@mx15.freecom.ne.jp)

*オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。*
*このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。*
*また、いかなる目的に対しても、その利用が適していることを関知しない。*

