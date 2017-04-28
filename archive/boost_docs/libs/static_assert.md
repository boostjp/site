# §ヘッダファイル（Header） &lt;[boost/static_assert.hpp](http://www.boost.org/doc/libs/1_31_0/boost/static_assert.hpp)&gt;

ヘッダファイル &lt;boost/static_assert.hpp&gt;はマクロ、BOOST_STATIC_ASSERT(x) を提供する。 BOOST_STATIC_ASSERT(x) は[汎整数定数式](/archive/boost_docs/document/int_const_guidelines.md) *x* を評価した結果、偽であるならばコンパイル時エラーメッセージを生成する。 つまり、コンパイル時に、assert マクロと同等の働きをするものである。 これは、「コンパイル時アサート（compile-time-assertion）」という名で知られているものであるが、このドキュメントでは「静的アサート（static assertion）」と記述することとする。 条件が真である時、このマクロはいかなるコードやデーターを生成しないことに注意すること。加えて、このマクロは namespace もしくは、クラス、もしくは、関数のスコープ内で利用される事にも注意すること。 このマクロがテンプレート内で利用されているばあいは、テンプレートより実体が生成される時に診断が実行される。 これは、特にテンプレート・パラメータを確認することに役立つ。

BOOST_STATIC_ASSERTの狙いのうちの1つは、可読性の高いエラー・メッセージを生成することである。 これらは、ユーザーにサポート外の方法でライブラリを利用しようとしたことを直接的に示す。 エラーメッセージがコンパイラ間で明らかに異なっていても、あなたは少なくとも、

```
Illegal use of COMPILE_TIME_ASSERTION_FAILURE<false>
```

これに似た記述を見ることになるだろう。

それは、少なからず目立つはずである。

あなたは、[クラス](#class)、[関数](#function)、[namespace](#namespace) のスコープにおいて、宣言を置くことができる箇所の全てで、BOOST_STATIC_ASSERT を利用できる。次に例を示す。

## <a name="namespace"></a>§namespaceスコープでの使用。(Use at namespace scope)

マクロは、常に真でなければならない前提条件がある場合に、namespace スコープで使うことが出来る。 通常、これはいくつかのプラットホーム依存の条件を意味する。 例えば、我々が **`int`** が少なくとも32ビット以上あり、**`wchar_t`** が符号無しであることを必要としていると想定する。 我々は次のようにして、コンパイル時にこれを検査することができる。

``` cpp
#include <climits>
#include <cwchar>
#include <boost/static_assert.hpp>

namespace my_conditions {

BOOST_STATIC_ASSERT(sizeof(int) * CHAR_BIT >= 32);
BOOST_STATIC_ASSERT(WCHAR_MIN >= 0);

} // namespace my_conditions
```

この例での、*my_conditions* namespace の使用に関して、若干の説明が必要だろう。 マクロBOOST_STATIC_ASSERT は目的実現の為に **typedef** 宣言を生成する。ここで、typedef は名前を持たなければならないので、マクロは仮の名に `__LINE__` の値(現在の行番号)を連結して一意の名前を自動的に生成する。 BOOST_STATIC_ASSERTがクラスまたは関数のスコープで使われる場合は、１行にマクロを複数記述しない限りにおいて、BOOST_STATIC_ASSERTの使用によって各々のスコープにおいて一意の名前が生成されることが保証される。 しかしながら、マクロがヘッダにおいて利用されるとき、namespace は複数のヘッダ間に渡ることがありうる。そして、同一の namespace を持つ複数のヘッダの、同じ行においてマクロが使用されたときに、同じ名前をもつ宣言を複数箇所で行うことになるかもしれない。 コンパイラは二重のtypedef宣言を暗黙のうちに無視しなければならないが、しかしながら、多くはそうしないが為に、意図しないエラーを引き起こしてしまう（また、仮に二重宣言を無視するにしても、そのような場合には警告を生成しても良いとなっている）。 よって、あなたがヘッダファイルにおいて、namespace スコープでBOOST_STATIC_ASSERTを使うならば、そのような潜在的な問題を避けるために、そのヘッダに特有の namespace で、BOOST_STATIC_ASSERT を囲まねばならない。

## <a name="function"></a>§関数スコープでの使用（Use at function scope）

マクロは典型的にテンプレート関数内において、テンプレート引数の検査が必要な時に利用される。 我々がiteratorによって捜査対象を指示される algorithm（iterator を受け取るテンプレート関数）を所持しており、それがランダムアクセスiterator を必要とすると想定する。 想定条件に合わない iterator を用いて algorithm が実体化された場合は、最終的にエラーが生成されることになるが、しかし、これは深く入れ子になった先のテンプレートの実体化によって引き起こされたエラーかもしれず、このことにが、ユーザーにとって何がエラーの原因かを特定することが難しくしている。 1つの選択としてはテンプレートのトップのレベルで、iterator の種別のコンパイル時判定を追加することである。もし、条件が合わない場合には、ユーザーにテンプレートが誤用されていることを明らかにするような形でエラーを生成できる。

```cpp
#include <iterator>
#include <boost/static_assert.hpp>
#include <boost/type_traits.hpp>

template <class RandomAccessIterator >
RandomAccessIterator foo(RandomAccessIterator from, RandomAccessIterator to)
{
   // this template can only be used with
   // random access iterators...
   // このテンプレートは、ランダムアクセス iterator でのみ利用可能である。
   typedef typename std::iterator_traits< RandomAccessIterator >::iterator_category cat;
   BOOST_STATIC_ASSERT((boost::is_convertible<cat, const std::random_access_iterator_tag&>::value));
   //
   // detail goes here...
   // 詳細は、これ以降...
   return from;
}
```

注: assertマクロのまわりの特別な括弧の組は、boost::is_convertible テンプレート中の「,」をプリプロセッサによってマクロ引数分離子として解釈されることを防いでいる。 boost::is_convertible の変換先の型が参照型であるため、若干のコンパイラにおいて型変換がユーザー定義コンストラクタを使用する時に boost::is_convvertible の使用に問題が生じる（いずれにしても、itarator tag クラスが、コピーコンストラクト可能であるという保証がない）

## <a name="class"></a>§クラス・スコープでの使用（Use at class scope）

マクロは典型的にテンプレートクラス内で使用される。 例えば、我々がテンプレート引数に最低でも16bit精度以上で符号無しの整数型を必要とするテンプレートクラスを利用する場合、我々はこの要請次のようにすることで満たすことが出来る：

```cpp
#include <climits>
#include <boost/static_assert.hpp>

template <class UnsignedInt>
class myclass
{
private:
   BOOST_STATIC_ASSERT(sizeof(UnsignedInt) * CHAR_BIT >= 16);
   BOOST_STATIC_ASSERT(std::numeric_limits<UnsignedInt>::is_specialized
                        && std::numeric_limits<UnsignedInt>::is_integer
                        && !std::numeric_limits<UnsignedInt>::is_signed);
public:
   /* details here */
   // 実装の詳細 はここに記述する
};
```

## §どのように実現されているか（How it works）

BOOST_STATIC_ASSERTは、次のようにして実現される。 STATIC_ASSERTION_FAILURE クラスが次のように定義されている：

```cpp
namespace boost{

template <bool> struct STATIC_ASSERTION_FAILURE;

template <> struct STATIC_ASSERTION_FAILURE<true>{};

}
```

鍵となる点は、未定義式 sizeof(STATIC_ASSERTION_FAILURE<0>) によって引き起こされるエラー・メッセージが多種多様なコンパイラ間で似通った表現である傾向があるということである。 動作原理の残りは BOOST_STATIC_ASSERT が、sizeof式をtypedef中に入れ込む手法である。 ここのマクロの使用は、いくぶん見苦しい。 boostの開発メンバーは、static assert をマクロの使用避けて作成しようとかなりの努力を費やした。しかしながら、それらは何れも成功しなかった。 結論として、static assert を namespace、関数、クラススコープでうまく利用出来るようにするにはマクロの醜さを考慮の外に置くしかないということだった。

## §テストプログラム（Test Programs ）

以下のテストプログラムが、このライブラリと共に提供される：


| テスト･プログラム | コンパイル可能か？ | 説明 |
| - | - | - |
| [static_assert_test.cpp](http://www.boost.org/doc/libs/1_31_0/libs/static_assert/static_assert_test.cpp) | はい | 使用法の例、および、コンパイラの互換性テストの為にコンパイルされるべきである。 |
| [static_assert_example_1.cpp](http://www.boost.org/doc/libs/1_31_0/libs/static_assert/static_assert_example_1.cpp) | プラットフォーム依存 | namespace スコープ・テストプログラムがコンパイルできるかは、プラットフォームに依存する。 |
| [static_assert_example_2.cpp](http://www.boost.org/doc/libs/1_31_0/libs/static_assert/static_assert_example_2.cpp) | はい | 関数スコープ・テストプログラム。 |
| [static_assert_example_3.cpp](http://www.boost.org/doc/libs/1_31_0/libs/static_assert/static_assert_example_3.cpp) | はい | クラススコープ・テストプログラム。 |
| [static_assert_test_fail_1.cpp](http://www.boost.org/doc/libs/1_31_0/libs/static_assert/static_assert_test_fail_1.cpp) | いいえ | namespace スコープでの失敗の例 |
| [static_assert_test_fail_2.cpp](http://www.boost.org/doc/libs/1_31_0/libs/static_assert/static_assert_test_fail_2.cpp) | いいえ | 非テンプレートの関数スコープでの失敗の例 |
| [static_assert_test_fail_3.cpp](http://www.boost.org/doc/libs/1_31_0/libs/static_assert/static_assert_test_fail_3.cpp) | いいえ | 非テンプレートのクラススコープでの失敗の例 |
| [static_assert_test_fail_4.cpp](http://www.boost.org/doc/libs/1_31_0/libs/static_assert/static_assert_test_fail_4.cpp) | いいえ | 非テンプレートのクラス・スコープでの失敗の例 |
| [static_assert_test_fail_5.cpp](http://www.boost.org/doc/libs/1_31_0/libs/static_assert/static_assert_test_fail_5.cpp) | いいえ | テンプレートクラス・スコープでの失敗の例 |
| [static_assert_test_fail_6.cpp](http://www.boost.org/doc/libs/1_31_0/libs/static_assert/static_assert_test_fail_6.cpp) | いいえ | テンプレートクラスのメンバー関数スコープでの失敗の例 |
| [static_assert_test_fail_7.cpp](http://www.boost.org/doc/libs/1_31_0/libs/static_assert/static_assert_test_fail_7.cpp) | いいえ | クラス・スコープでの失敗の例 |
| [static_assert_test_fail_8.cpp](http://www.boost.org/doc/libs/1_31_0/libs/static_assert/static_assert_test_fail_8.cpp) | いいえ | 関数スコープでの失敗の例 |
| [static_assert_test_fail_9.cpp](http://www.boost.org/doc/libs/1_31_0/libs/static_assert/static_assert_test_fail_9.cpp) | いいえ | 関数スコープでの失敗の例(その２) |

---

Revised 27th Nov 2000

Documentation © Copyright John Maddock 2000. Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies. This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

Based on contributions by Steve Cleary and John Maddock.

Maintained by [John Maddock](mailto:John_Maddock@compuserve.com), the latest version of this file can be found at [www.boost.org](http://www.boost.org/), and the boost discussion list at [www.yahoogroups.com/list/boost](http://www.yahoogroups.com/list/boost).

---

日本語版第１版 2003年 2月 14日(原文 2002/11/27日版ベース)

Japanese version - based 27th Nov 2000 - Revised 14th Feb 2003

Japanese Translation Copyright (C) 2003 [mikari(Mika.N)](mailto:mikarim@m18.alpha-net.ne.jp).

The project "Boost Japanese Translation" was proposed by [Kohske Takahashi](mailto:kohske@msc.biglobe.ne.jp).

オリジナルドキュメントは、 西暦 2000年 John Maddock によって作成された。

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。 このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。 また、いかなる目的に対しても、その利用が適していることを関知しない。

原文は、Steve Cleary と John Maddock の投稿に基づいており、[John Maddock](mailto:John_Maddock@compuserve.com) によって 保守されている。最新版は [www.boost.org](http://www.boost.org/)より得ることが出来る。 また、議論の記録は次の場所で参照できる（[www.yahoogroups.com/list/boost](http://www.yahoogroups.com/list/boost)）
