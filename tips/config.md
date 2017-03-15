# コンパイラ間の差を吸収する
ここでは、コンパイラ間の差を吸収するための方法を挙げる。

## インデックス

- [コンパイラが、あるC++11の機能をサポートしているかどうかでコードを変更する](#support-cpp11)
- [コンパイラによって、テンプレート中の `hoge<T>::type x;` や `fuga.f();` がコンパイルエラーになったりならなかったりする問題を回避する](#deduced-typename)
- [メンバ関数テンプレートの呼び出しでコンパイルエラーになる問題を回避する](#nested-template)


## <a name="support-cpp11" href="#support-cpp11">コンパイラが、あるC++11の機能をサポートしているかどうかでコードを変更する</a>

以下は可変長テンプレート引数をサポートしているコンパイラならそれを使い、そうでなければ Boost.Preprocessor などでエミュレートする例

```cpp
#include <boost/config.hpp>

# if defined BOOST_NO_CXX11_VARIADIC_TEMPLATES
#  include <boost/preprocessor/repetition/enum_params.hpp>
#  include <boost/preprocessor/repetition/enum_binary_params.hpp>
#  include <boost/preprocessor/facilities/intercept.hpp>
// 他色々
#  if !defined MAX_PARAM_LIMIT
#    define MAX_PARAM_LIMIT 10
#  endif
# endif

# if !defined BOOST_NO_CXX11_VARIADIC_TEMPLATES

template<typename ...T>
void f(T ...x) {
    // fの定義
}

# else

// fの定義（長くなるので省略）

# endif
```

`boost/config.hpp` をインクルードすると、コンパイラやバージョンに応じて `BOOST_NO_`*FEATURE_NAME* が定義される。定義されているマクロ名に対応した機能は、そのコンパイラでは使えない。

以下はそのマクロ一覧である。C++11の新機能については各々で調べたし。


| マクロ名 | 説明 |
|----------|------|
| `BOOST_NO_CXX11_ALIGNAS`     | C++11の`alignas`キーワード |
| `BOOST_NO_CXX11_ALLOCATOR`   | C++11バージョンの`std::allocator` |
| `BOOST_NO_CXX11_ATOMIC_SP`   | C++11のスマートポインタがアトミック操作をサポートしているか |
| `BOOST_NO_CXX11_HDR_ARRAY`   | C++11の標準ライブラリ[`<array>`](https://cpprefjp.github.io/reference/array.html)ヘッダ |
| `BOOST_NO_CXX11_HDR_CHRONO`  | C++11の標準ライブラリ[`<chrono>`](https://cpprefjp.github.io/reference/chrono.html)ヘッダ |
| `BOOST_NO_CXX11_HDR_CODECVT` | C++11の標準ライブラリ[`<codecvt>`](https://cpprefjp.github.io/reference/codecvt.html)ヘッダ |
| `BOOST_NO_CXX11_HDR_CONDITION_VARIABLE` | C++11の標準ライブラリ[`<condition_variable>`](https://cpprefjp.github.io/reference/condition_variable.html)ヘッダ |
| `BOOST_NO_CXX11_HDR_FORWARD_LIST` | C++11の標準ライブラリ[`<forward_list>`](https://cpprefjp.github.io/reference/forward_list.html)ヘッダ |
| `BOOST_NO_CXX11_HDR_FUNCTIONAL` | C++11バージョンと互換のある[`<functional>`](https://cpprefjp.github.io/reference/functional.html)ヘッダ |
| `BOOST_NO_CXX11_HDR_FUTURE` | C++11の標準ライブラリ[`<future>`](https://cpprefjp.github.io/reference/future.html)ヘッダ |
| `BOOST_NO_CXX11_HDR_INITIALIZER_LIST` | C++11の標準ライブラリ[`<initializer_list>`](https://cpprefjp.github.io/reference/initializer_list.html)ヘッダ。 変数の初期化を `{1, 2, 3}` のような記述で行う |
| `BOOST_NO_CXX11_HDR_MUTEX` | C++11の標準ライブラリ[`<mutex>`](https://cpprefjp.github.io/reference/mutex.html)ヘッダ |
| `BOOST_NO_CXX11_HDR_RANDOM` | C++11の標準ライブラリ[`<random>`](https://cpprefjp.github.io/reference/random.html)ヘッダ |
| `BOOST_NO_CXX11_HDR_RATIO` | C++11の標準ライブラリ[`<ratio>`](https://cpprefjp.github.io/reference/ratio.html)ヘッダ |
| `BOOST_NO_CXX11_HDR_REGEX` | C++11の標準ライブラリ[`<regex>`](https://cpprefjp.github.io/reference/regex.html)ヘッダ |
| `BOOST_NO_CXX11_HDR_SYSTEM_ERROR` | C++11の標準ライブラリ[`<system_error>`](https://cpprefjp.github.io/reference/system_error.html)ヘッダ |
| `BOOST_NO_CXX11_HDR_THREAD` | C++11の標準ライブラリ[`<thread>`](https://cpprefjp.github.io/reference/thread.html)ヘッダ |
| `BOOST_NO_CXX11_HDR_TUPLE` | C++11の標準ライブラリ[`<tuple>`](https://cpprefjp.github.io/reference/tuple.html)ヘッダ |
| `BOOST_NO_CXX11_HDR_TYPEINDEX` | C++11の標準ライブラリ[`<typeindex>`](https://cpprefjp.github.io/reference/typeindex.html)ヘッダ |
| `BOOST_NO_CXX11_HDR_TYPE_TRAITS` | C++11の標準ライブラリ[`<type_traits>`](https://cpprefjp.github.io/reference/type_traits.html)ヘッダ |
| `BOOST_NO_CXX11_HDR_UNORDERED_MAP` | C++11の標準ライブラリ[`<unordered_map>`](https://cpprefjp.github.io/reference/unordered_map.html)ヘッダ |
| `BOOST_NO_CXX11_HDR_UNORDERED_SET` | C++11の標準ライブラリ[`<unordered_set>`](https://cpprefjp.github.io/reference/unordered_set.html)ヘッダ |
| `BOOST_NO_CXX11_INLINE_NAMESPACES` | `inline namespace` |
| `BOOST_NO_CXX11_SMART_PTR` | C++11のスマートポインタ、`shared_ptr`と`unique_ptr`を提供しているか |
| `BOOST_NO_CXX11_AUTO_DECLARATIONS` | `auto` による変数の型の自動決定<br/> `// x の型は初期化式 expr から自動的に決定する`<br/> `auto x = expr;` |
| `BOOST_NO_CXX11_AUTO_MULTIDECLARATIONS` | `auto` での宣言で、一度に複数の変数を宣言する<br/> `auto x = expr1, y = expr2;` |
| `BOOST_NO_CXX11_CHAR16_T` | 組み込み型 `char16_t` |
| `BOOST_NO_CXX11_CHAR32_T` | 組み込み型 `char32_t` |
| `BOOST_NO_CXX11_TEMPLATE_ALIASES` | `template` による別名宣言。<br/> `template<typename T> using my_vector = std::vector<T, my_allocator<T> >;`<br/> `my_vector<T> v;` |
| `BOOST_NO_CXX11_CONSTEXPR` | コンパイル時に計算して定数に畳み込むことが可能なことを示す修飾子 |
| `BOOST_NO_CXX11_DECLTYPE`  | Boost.Typeof のように式から型を取得する<br/> `// x は expr1 の型として宣言され、`<br/> `// expr2 で初期化される`<br/>`decltype(expr1) x = expr2;` |
| `BOOST_NO_CXX11_DECLTYPE_N3276`      | N3276仕様の`decltype` |
| `BOOST_NO_CXX11_DEFAULTED_FUNCTIONS` | コンストラクタ、コピー代入演算子、デストラクタをデフォルト実装で宣言する |
| `BOOST_NO_CXX11_DELETED_FUNCTIONS`   | 関数の `delete` 宣言 |
| `BOOST_NO_CXX11_EXPLICIT_CONVERSION_OPERATORS` | 型変換演算子に対する `explicit` 宣言 |
| `BOOST_NO_CXX11_EXTERN_TEMPLATE` |テンプレートのインスタンス化をその翻訳単位では行わないようにする |
| `BOOST_NO_CXX11_FUNCTION_TEMPLATE_DEFAULT_ARGS` |関数テンプレートのテンプレートパラメータにデフォルト引数を指定する |
| `BOOST_NO_CXX11_LAMBDAS` | ラムダ式 |
| `BOOST_NO_CXX11_LOCAL_CLASS_TEMPLATE_PARAMETERS` | ローカルクラスをテンプレートパラメータに指定する |
| `BOOST_NO_LONG_LONG`               | `(unsigned) long long` 型 |
| `BOOST_NO_CXX11_NOEXCEPT`          | `noexcept`キーワード |
| `BOOST_NO_CXX11_NULLPTR`           | ヌルポインタを示すキーワード |
| `BOOST_NO_CXX11_RANGE_BASED_FOR`   | 範囲`for`文 |
| `BOOST_NO_CXX11_RAW_LITERALS       | 文字列リテラルの新しい表記法 |
| `BOOST_NO_CXX11_RVALUE_REFERENCES` | 右辺値参照型 |
| `BOOST_NO_CXX11_SCOPED_ENUMS`      | スコープ付きの列挙型 |
| `BOOST_NO_CXX11_STATIC_ASSERT`     | 条件式によってコンパイルエラーにするための `static_assert` 文 |
| `BOOST_NO_CXX11_STD_UNORDERD`      | `unordered_set`, `unordered_multiset`, `unordered_map`, `unordered_multimap` の4つのコンテナクラステンプレート |
| `BOOST_NO_CXX11_TRAILING_RESULT_TYPES` | 関数の戻り値型を後置 |
| `BOOST_NO_CXX11_UNICODE_LITERALS` | Unicode 文字・文字列リテラル(`u8`, `u`, `U`) |
| `BOOST_NO_CXX11_UNIFIED_INITIALIZATION_SYNTAX` | コンストラクタの呼び出しを初期化子リストと同じ構文で記述する |
| `BOOST_NO_CXX11_USER_DEFINED_LITERALS` | ユーザー定義リテラル |
| `BOOST_NO_CXX11_VARIADIC_TEMPLATES` | 可変引数テンプレート |
| `BOOST_NO_CXX11_VARIADIC_MACROS`    | 可変引数マクロ |


## <a name="deduced-typename" href="#deduced-typename">コンパイラによって、テンプレート中の `hoge<T>::type x;` や `fuga.f();` がコンパイルエラーになったりならなかったりする問題を回避する</a>

```cpp
struct hoge {
    typedef int type;
};

template<typename T>
void f(T x) {
    T::type x; // (a)
    …
}

void g() {
    hoge x;
    f(x); // この部分をコンパイルしようとすると (a) でコンパイルエラーが起きる
    …
}
```

関数テンプレートもしくはクラステンプレート内で、上の `f` のように内部でテンプレートパラメータの内部で宣言された型名を利用する場合、(a) の箇所では、`T::type` が型名であることを示す必要がある。具体的には `typename` キーワードを使って、 `typename T::type x;` のように記述する。しかし古いコンパイラなどでは、`typename` を付けずとも空気を読んで `T::type` が型であると判断することで、`typename` キーワードそのものをサポートしていない場合がある。次のように記述することで、この問題は回避可能である。

```cpp
template<typename T>
void f() {
    BOOST_DEDUCED_TYPENAME T::type x;
    …
}
```

`BOOST_DEDUCED_TYPENAME` マクロは、普通 `typename` になるが、かかる位置での `typename` をサポートしていないコンパイラでは空に展開される。


## <a name="nested-template" href="#nested-template">メンバ関数テンプレートの呼び出しでコンパイルエラーになる問題を回避する</a>


上記の `typename` と似たような問題で、次のようなコードがコンパイラによって通ったり通らなかったりする：

```cpp
struct hoge {
    template<typename T>
    void f() {}
    template<typename T>
    struct fuga {};
};

template<typename T>
void g(T & x) {
    x.f<int>(); // (a)
    T::fuga<int> y; // (b)
}

void h() {
    hoge x;
    g(x); // この関数呼び出しをコンパイルしようとすると (a) や (b) の箇所でコンパイルエラーが起きる
}
```

(a) は `int` で実体化したメンバ関数テンプレートの呼び出しとは認識されず、(b) もメンバクラステンプレートを `int` で実体化した型の変数の宣言とは見なされない。次のように記述する必要がある。

```cpp
template<typename T>
void g(T & x) {
    x.template f<int>(); // (a’)
    typename T::template fuga<int> y; // (b’)
}
```

(a’) では `f` の前に `template` キーワードを付けて、`f` がテンプレートであることを明記している。(b’) も同様に `fuga` がテンプレートであると示しているが、同時に `T::template fuga<int>` が型であることも示すために `typename` も付けている。しかし上の `typename` の問題と同様に、この `template` キーワードの使い方をサポートしないコンパイラが存在する。これについては `BOOST_NESTED_TEMPLATE` マクロを使うことで解決する。次のように使う：

```cpp
template<typename T>
void g(T & x) {
    x.BOOST_NESTED_TEMPLATE f<int>(); // (a')
    typename T::BOOST_NESTED_TEMPLATE fuga<int> y; // (b')
}
```

この `template` キーワードの使い方をサポートするコンパイラでは `template` と展開され、そうでないコンパイラでは空に展開される。


documented boost version is 1.51.0

