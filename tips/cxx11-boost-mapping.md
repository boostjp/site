# C++11とBoostの対応付け

## C++11にもBoostにも存在する機能

完全に同じとは限りません。同名のクラスでもメンバ名が異なるなど多少の差異が存在する場合があります。


| C++11         | Boost | 備考 |
|---------------|-------------------------|-----|
| `decltype` | `BOOST_TYPEOF` | |
| `auto`     | `BOOST_AUTO`   | |
| `std::addressof` | `boost::addressof` |
| `std::array` | `boost::array` |
| 統一初期化構文（`std::initializer_list`に関するもの） | Boost.Assign | |
| `std::bind`, `std::mem_fn` | `boost::bind`, `boost::mem_fn` | |
| `std::chrono` | `boost::chrono` | |
| 各種コンテナ | Boost.Container, Boost.Unordered | C++11に`flat_map`/`flat_set`は存在しません。<br/> Unorderedのハッシュ関数の定義方法が異なります。 |
| `std::declval` | `boost::declval` | |
| `std::enable_if` | `boost::enable_if_c` | |
| `std::conditional` | `boost::mpl::if_c` | |
| `std::common_type<T>` | `boost::mpl::identity<T>` | `std::common_type`でテンプレート引数を1つだけ指定したものは`identity`と同じ効果を持ちます。 |
| `std::exception_ptr`, `current_exception`, `rethrow_exception`, `make_exception_ptr` | `boost::exception_ptr`, `current_exception`, `rethrow_exception`, `copy_exception` | C++11は完全な例外伝播が可能なため、`enable_current_exception`, `unknown_exception`相当は不要になりました。 |
| 範囲`for`文 | `BOOST_FOREACH` | |
| `std::function` | `boost::function` | |
| `<cstdint>`, `<stdint.h>` | `<boost/cstdint.hpp>` | Boostには`intptr_t`/`uintptr_t`など一部存在しません |
| `std::iota` | `boost::iota` (Boost.Range) | |
| `std::numeric_limits` | `boost::integer_traits` | C++11の`numeric_limits`はメンバが軒並み`constexpr`化されており、コンパイル時定数として利用可能です。 |
| ラムダ式      | Boost.Lambda, Boost.Phoenix, Boost.LocalFunction | |
| `<cmath>`     | Boost.Math     | C99で追加された関数が両者に存在します。 |
| `std::minmax` | `boost::mimax` | |
| 右辺値参照 (`std::move`, `std::forward`) | Boost.Move (`boost::move`, `boost::forward`) | |
| `<random>` | `Boost.Random` | |
| `std::ratio` | `boost::ratio` | |
| `std::ref`, `std::reference_wrapper` | `boost::ref`, `boost::reference_wrapper` | |
| `std::regex` | `boost::regex` | |
| `std::result_of` | `boost::result_of` | |
| `std::shared_ptr`, `std::weak_ptr`, `std::make_shared`, `std::enable_shared_from_this` | `boost::shared_ptr`, `boost::weak_ptr`, `boost::make_shared`, `boost::enable_shared_from_this` | |
| `std::unique_ptr` | `boost::interprocess::unique_ptr`, `boost::scoped_ptr`, `boost::scoped_array` | |
| `std::default_delete` | `boost::checked_deleter`, `boost::checked_array_deleter` | |
| `std::tuple` | `boost::tuple`, `boost::fusion::vector` | |
| `static_assert` | `BOOST_STATIC_ASSERT`, `BOOST_MPL_ASSERT` | |
| `<type_traits>` | `<boost/type_traits.hpp>` | |
| `std::thread` | `boost::thread` | [threadのdetachとデストラクタ](http://d.hatena.ne.jp/yohhoy/20120206/p1)[C++11とBoost.ThreadのMutex/Lock比較表](http://d.hatena.ne.jp/yohhoy/20120427/p1) |
| `std::atomic` | `boost::atomic` | `kill_dependency()`と、フリー関数版のアトミック操作はない。前者はコンパイラが特殊処理を行う必要があるため。後者はCとの互換性のための機能であるため。 |


documented boost version is 1.53.0
