#コンパイラ間の差を吸収する
ここでは、コンパイラ間の差を吸収するための方法を挙げる。


Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>コンパイラが、あるC++11の機能をサポートしているかどうかでコードを変更する](#TOC-C-11-)</li><li class='goog-toc'>[<strong>2 </strong>コンパイラによって、テンプレート中の hoge<T>::type x; や fuga.f(); がコンパイルエラーになったりならなかったりする問題を回避する](#TOC-hoge-T-::type-x-fuga.f-)</li><li class='goog-toc'>[<strong>3 </strong>メンバ関数テンプレートの呼び出しでコンパイルエラーになる問題を回避する](#TOC--)</li></ol>


<h4>コンパイラが、あるC++11の機能をサポートしているかどうかでコードを変更する</h4>
以下は可変長テンプレート引数をサポートしているコンパイラならそれを使い、そうでなければ Boost.Preprocessor などでエミュレートする例```cpp
<code style='color:rgb(0,0,0)'>#include <boost/config.hpp><br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>#if defined BOOST_NO_CXX11_VARIADIC_TEMPLATES<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>#  include <boost/preprocessor/repetition/enum_params.hpp><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>#  include <boost/preprocessor/repetition/enum_binary_params.hpp><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>#  include <boost/preprocessor/facilities/intercept.hpp><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>// 他色々<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>#  if !defined MAX_PARAM_LIMIT<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>#    define MAX_PARAM_LIMIT 10<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>#  endif<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>#endif<br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>#if !defined BOOST_NO_CXX11_VARIADIC_TEMPLATES<br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>template<typename ...T><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>void f(T ...x) {<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    // fの定義<br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>}<br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>#else<br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>// fの定義（長くなるので省略）<br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>#endif

boost/config.hpp をインクルードすると、コンパイラやバージョンに応じて BOOST_NO_FEATURE_NAME が定義される。定義されているマクロ名に対応した機能は、現在のコンパイラでは使えない。

以下はそのマクロ一覧である。C++11の新機能については各々で調べたし。
```
* FEATURE_NAME[italic]

| | |
|----------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| マクロ名 | 説明 |
|BOOST_NO_CXX11_ALIGNAS | C++11のalignasキーワード |
|BOOST_NO_CXX11_ALLOCATOR | C++11バージョンのstd::allocator |
|BOOST_NO_CXX11_ATOMIC_SP | C++11のスマートポインタがアトミック操作をサポートしているか |
|BOOST_NO_CXX11_HDR_ARRAY | C++11の標準ライブラリ[<array>](/reference/array.md)ヘッダ |
|BOOST_NO_CXX11_HDR_CHRONO | C++11の標準ライブラリ[<chrono>](/reference/chrono.md)ヘッダ |
|BOOST_NO_CXX11_HDR_CODECVT | C++11の標準ライブラリ<codecvt>ヘッダ |
|BOOST_NO_CXX11_HDR_CONDITION_VARIABLE | C++11の標準ライブラリ[<condition_variable>](/reference/condition_variable.md)ヘッダ |
|BOOST_NO_CXX11_HDR_FORWARD_LIST | C++11の標準ライブラリ[<forward_list>](/reference/forward_list.md)ヘッダ |
|BOOST_NO_CXX11_HDR_FUNCTIONAL | C++11バージョンと互換のある[<functional>](/reference/functional.md)ヘッダ |
|BOOST_NO_CXX11_HDR_FUTURE | C++11の標準ライブラリ[<future>](/reference/future.md)ヘッダ |
|BOOST_NO_CXX11_HDR_INITIALIZER_LIST | C++11の標準ライブラリ[<initializer_list>](/reference/initializer_list.md)ヘッダ。 変数の初期化を {1, 2, 3} のような記述で行う |
|BOOST_NO_CXX11_HDR_MUTEX | C++11の標準ライブラリ[<mutex>](/reference/mutex.md)ヘッダ |
|BOOST_NO_CXX11_HDR_RANDOM | C++11の標準ライブラリ[<random>](/reference/random.md)ヘッダ |
|BOOST_NO_CXX11_HDR_RATIO | C++11の標準ライブラリ<ratio>ヘッダ |
|BOOST_NO_CXX11_HDR_REGEX | C++11の標準ライブラリ<regex>ヘッダ |
|BOOST_NO_CXX11_HDR_SYSTEM_ERROR | C++11の標準ライブラリ[<system_error>](/reference/system_error.md)ヘッダ |
|BOOST_NO_CXX11_HDR_THREAD | C++11の標準ライブラリ[<thread>](/reference/thread.md)ヘッダ |
|BOOST_NO_CXX11_HDR_TUPLE | C++11の標準ライブラリ[<tuple>](/reference/tuple.md)ヘッダ |
|BOOST_NO_CXX11_HDR_TYPEINDEX | C++11の標準ライブラリ[<tupeindex>](/reference/typeindex.md)ヘッダ |
|BOOST_NO_CXX11_HDR_TYPE_TRAITS | C++11の標準ライブラリ[<type_traits>](/reference/type_traits.md)ヘッダ |
|BOOST_NO_CXX11_HDR_UNORDERED_MAP | C++11の標準ライブラリ<unordered_map>ヘッダ |
|BOOST_NO_CXX11_HDR_UNORDERED_SET | C++11の標準ライブラリ[<unordered_set>](/reference/unordered_set.md)ヘッダ |
|BOOST_NO_CXX11_INLINE_NAMESPACES | inline namespace |
|BOOST_NO_CXX11_SMART_PTR | C++11のスマートポインタ、shared_ptrとunique_ptrを提供しているか |
|BOOST_NO_CXX11_AUTO_DECLARATIONS |auto による変数の型の自動決定<code style='color:rgb(0,0,0)'>// x の型は初期化式 expr から自動的に決定する</code><code style='color:rgb(0,0,0)'>auto x = expr;</code><br/> |
|BOOST_NO_CXX11_AUTO_MULTIDECLARATIONS |<br/>auto での宣言で、一度に複数の変数を宣言する<code style='color:rgb(0,0,0)'>auto x = expr1, y = expr2;</code><br/><br/> |
|BOOST_NO_CXX11_CHAR16_T |組み込み型 char16_t |
|BOOST_NO_CXX11_CHAR32_T |組み込み型 char32_t |
|BOOST_NO_CXX11_TEMPLATE_ALIASES |template の別名宣言。using template aliases, template typedef<br/>```cpp
<br/><br/><code style='color:rgb(0,0,0)'>template<typename T> using my_vector = std::vector<T, my_allocator<T> >;<br style='color:rgb(0,0,0)'/><br/><br style='color:rgb(0,0,0)'/><br/><code style='color:rgb(0,0,0)'><br/>// std::vector<T, my_allocator<T> > v; と同じ<br style='color:rgb(0,0,0)'/><br/><code style='color:rgb(0,0,0)'><br/>my_vector<T> v;<br/><br/> |
|BOOST_NO_CXX11_CONSTEXPR |コンパイル時に計算して定数に畳み込むことが可能なことを示す修飾子 |
|BOOST_NO_CXX11_DECLTYPE |Boost.Typeof のように式から型を取得する<code style='color:rgb(0,0,0)'>// x は expr1 の型として宣言され、// expr2 で初期化される<code style='color:rgb(0,0,0)'>decltype(expr1) x = expr2;<br/> |
|BOOST_NO_CXX11_DECLTYPE_N3276 | N3276仕様のdecltype |
|BOOST_NO_CXX11_DEFAULTED_FUNCTIONS |コンストラクタ、コピー代入演算子、デストラクタをデフォルト実装で宣言する |
|BOOST_NO_CXX11_DELETED_FUNCTIONS |関数の delete 宣言 |
|BOOST_NO_CXX11_EXPLICIT_CONVERSION_OPERATORS |型変換演算子に対する explicit 宣言 |
|BOOST_NO_CXX11_EXTERN_TEMPLATE |テンプレートのインスタンス化をその翻訳単位では行わないようにする |
|BOOST_NO_CXX11_FUNCTION_TEMPLATE_DEFAULT_ARGS |関数テンプレートのテンプレートパラメータにデフォルト引数を指定する |
|BOOST_NO_CXX11_LAMBDAS |ラムダ式、無名関数 |
|BOOST_NO_CXX11_LOCAL_CLASS_TEMPLATE_PARAMETERS | ローカルクラスをテンプレートパラメータに指定する |
|BOOST_NO_LONG_LONG |(unsigned) long long 型 |
|BOOST_NO_CXX11_NOEXCEPT |noexceptキーワード |
|BOOST_NO_CXX11_NULLPTR |ヌルポインタを示すキーワード |
|BOOST_NO_CXX11_RANGE_BASED_FOR |範囲for文 |
|BOOST_NO_CXX11_RAW_LITERALS |文字列リテラルの新しい表記法 |
|BOOST_NO_CXX11_RVALUE_REFERENCES |右辺値参照型 |
|BOOST_NO_CXX11_SCOPED_ENUMS |強い型付けを持つ列挙型 |
|BOOST_NO_CXX11_STATIC_ASSERT |条件式によってコンパイルエラーにするための static_assert 文 |
|BOOST_NO_CXX11_STD_UNORDERD |unordered_set, unordered_multiset, unordered_map, unordered_multimap の4つのコンテナクラステンプレート |
|BOOST_NO_CXX11_TRAILING_RESULT_TYPES |関数の戻り値型を後置 |
|BOOST_NO_CXX11_UNICODE_LITERALS |Unicode 文字・文字列リテラル(u8, u, U) |
|BOOST_NO_CXX11_UNIFIED_INITIALIZATION_SYNTAX |コンストラクタの呼び出しを初期化子リストと同じ構文で記述する |
|BOOST_NO_CXX11_USER_DEFINED_LITERALS |ユーザー定義リテラル |
|BOOST_NO_CXX11_VARIADIC_TEMPLATES |可変長テンプレートパラメータ |
|BOOST_NO_CXX11_VARIADIC_MACROS |可変長引数マクロ |
```
* N3276[link http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2011/n3276.pdf]

<h4>コンパイラによって、テンプレート中の hoge<T>::type x; や fuga.f(); がコンパイルエラーになったりならなかったりする問題を回避する</h4>
```cpp
<code style='color:rgb(0,0,0)'>struct hoge {</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    typedef int type;</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>};</code><br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>template<typename T></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>void f(T x) {</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    T::type x; // (a)</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    …</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>}</code><br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>void g() {</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    hoge x;</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    f(x); // この部分をコンパイルしようとすると (a) でコンパイルエラーが起きる</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    …</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>}</code>
関数テンプレートもしくはクラステンプレート内で、上の f のように内部でテンプレートパラメータの内部で宣言された型名を利用する場合、(a) の箇所では、T::type が型名であることを示す必要がある。具体的には typename キーワードを使って、 typename T::type x; のように記述する。しかし古いコンパイラなどでは、typename を付けずとも空気を読んで T::type が型であると判断することで、typename キーワードそのものをサポートしていない場合がある。次のように記述することで、この問題は回避可能である。<code style='color:rgb(0,0,0)'>template<typename T></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>void f() {</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    BOOST_DEDUCED_TYPENAME T::type x;</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    …</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>}</code>
BOOST_DEDUCED_TYPENAME マクロは、普通 typename になるが、かかる位置での typename をサポートしていないコンパイラでは空に展開される。<h4>メンバ関数テンプレートの呼び出しでコンパイルエラーになる問題を回避する</h4>上記の typename と似たような問題で、次のようなコードがコンパイラによって通ったり通らなかったりする：```cpp
<code style='color:rgb(0,0,0)'>struct hoge {</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    template<typename T></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    void f() {}</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    template<typename T></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    struct fuga {};</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>};</code><br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>template<typename T></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>void g(T & x) {</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    x.f<int>(); // (a)</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    T::fuga<int> y; // (b)</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>}</code><br style='color:rgb(0,0,0)'/><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>void h() {</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    hoge x;</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    g(x); // この関数呼び出しをコンパイルしようとすると (a) や (b) の箇所でコンパイルエラーが起きる</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>}</code>
(a) は int で実体化したメンバ関数テンプレートの呼び出しとは認識されず、(b) もメンバクラステンプレートを int で実体化した型の変数の宣言とは見なされない。次のように記述する必要がある。<code style='color:rgb(0,0,0)'>template<typename T></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>void g(T & x) {</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    x.template f<int>(); // (a')</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    typename T::template fuga<int> y; // (b')</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>}</code>
(a') では f の前に template キーワードを付けて、f がテンプレートであることを明記している。b' も同様に fuga がテンプレートであると示しているが、同時に T::template fuga<int> が型であることも示すために typename も付けている。しかし上の typename の問題と同様に、この template キーワードの使い方をサポートしないコンパイラが存在する。これについては BOOST_NESTED_TEMPLATE マクロを使うことで解決する。次のように使う：```cpp
<code style='color:rgb(0,0,0)'>template<typename T></code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>void g(T & x) {</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    x.BOOST_NESTED_TEMPLATE f<int>(); // (a')</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>    typename T::BOOST_NESTED_TEMPLATE fuga<int> y; // (b')</code><br style='color:rgb(0,0,0)'/><code style='color:rgb(0,0,0)'>}</code>
この template キーワードの使い方をサポートするコンパイラでは template と展開され、そうでないコンパイラでは空に展開される。
==
documented boost version is 1.51.0
