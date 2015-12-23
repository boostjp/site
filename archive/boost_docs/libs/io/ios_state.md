<!--
<p>The header <cite><a
href="../../../boost/io/ios_state.hpp">boost/io/ios_state.hpp</a></cite>
covers saving the stream state of objects in the C++ IOStreams
system.</p>
-->

#Header &lt;boost/io/ios_state.hpp&gt;

boost/io/ios_state.hppは、C++の入出力ストリームシステムにおけるオブジェクトのストリーム状態を保持することを保証する。


##目次
- [Rationale](#rationale)
- [Header Synopsis](#header)
- [Savers for Basic Standard Attributes](#base_savers)
- [Savers for Advanced Standard Attributes](#adv_savers)
- [Savers for User-Defined Attributes](#user_savers)
- [Savers for Combined Attributes](#combo_savers)
- [Example](#example)
- [References](#refer)
- [Credits](#credits)
    - [Contributors](#contributors)
    - [History](#history)

##<a name="rationale">Rationale</a>

<!--
<p>Sometimes a certain value has to change only for a limited scope. 
Saver classes save a copy of the current state of some object (or an
aspect of an object), and reset the object's state at destruction time,
undoing any change the object may have gone through.</p>
-->
時々、ある値が制限されたスコープ内でのみ変化しなければならない時がある。
セーバークラス群は、オブジェクトの現在の状態（またはオブジェクトの様相）のコピーを保持し、デストラクト時にスコープ内で発生した変更を全て元通りにして、そのオブジェクトの状態を回復する。

<!--
<p>The saver class strategy is helpful when using I/O stream objects. 
Manipulator objects can change some aspect of a stream during input or
output.  The state changed by the manipulator usually sticks to its new
value after the I/O transaction.  This can be a problem if manipulators
are used in a function that is not supposed to externally change a
stream's state.</p>
-->
セーバークラスの戦略は、入出力ストリームオブジェクトを使う時に有効である。
マニピュレータオブジェクトは、入力または出力時のストリームの様相を変更できる。
普通マニピュレータによって入出力ストリームの状態を変更すると、処理が終わった後の次の値に対しても影響が残ってしまう。
これは、マニピュレータを外面的にはストリームの状態を変更しないと仮定している関数の中で使う場合に問題になるかもしれない。

```cpp
#include <ostream>
#include <ios>

void  hex_my_byte( std::ostream &os, char byte )
{
    os << std::hex << static_cast<unsigned>(byte);
}
```

<!--
<p>The <var>os</var> stream will retain its new hexadecimal printing
mode after the call to <code>hex_my_byte</code>.  The stream's printing
mode can be saved and restored with manual calls to the stream's state
inspecting and mutating member functions.  The manual method becomes
unwieldy if the main functionality is complex and/or needs to be
exception safe.  A saver class can implement the better &quot;resource
acquisition is initialization&quot; strategy.</p>
-->
`os` ストリームは、`hex_my_byte`を呼んだ後も16進表記モードを保持し続ける。
ストリームの表記モードは、ストリームの状態を調べたり、変更するためのメンバー関数を手動で呼び出すことで変更されたり、元に戻されたりする。
この手動による方法は、メインとなる関数の性質が複雑、且つ／または例外安全である必要がある場合には扱いにくいものになってしまう。
セーバークラスを使うことで、「リソースの確保は初期化時に」というより優れた戦略を採ることができるようになる。

<!--
<p>See the <a href="#example">example</a> below for better code, using
saver classes.</p>
-->
セーバークラスを使ったより優れたコードの[例](#example)を下の方に示す。

##<a name="header">Header Synopsis</a>

```cpp
#include <iosfwd>  // for std::char_traits (declaration)

namespace boost
{
namespace io
{

class ios_flags_saver;
class ios_precision_saver;
class ios_width_saver;
class ios_base_all_saver;

template < typename Ch, class Tr = ::std::char_traits<Ch> >
    class basic_ios_iostate_saver;
template < typename Ch, class Tr = ::std::char_traits<Ch> >
    class basic_ios_exception_saver;
template < typename Ch, class Tr = ::std::char_traits<Ch> >
    class basic_ios_tie_saver;
template < typename Ch, class Tr = ::std::char_traits<Ch> >
    class basic_ios_rdbuf_saver;
template < typename Ch, class Tr = ::std::char_traits<Ch> >
    class basic_ios_fill_saver;
template < typename Ch, class Tr = ::std::char_traits<Ch> >
    class basic_ios_locale_saver;
template < typename Ch, class Tr = ::std::char_traits<Ch> >
    class basic_ios_all_saver;

typedef basic_ios_iostate_saver<char>        ios_iostate_saver;
typedef basic_ios_iostate_saver<wchar_t>    wios_iostate_saver;
typedef basic_ios_exception_saver<char>      ios_exception_saver;
typedef basic_ios_exception_saver<wchar_t>  wios_exception_saver;
typedef basic_ios_tie_saver<char>            ios_tie_saver;
typedef basic_ios_tie_saver<wchar_t>        wios_tie_saver;
typedef basic_ios_rdbuf_saver<char>          ios_rdbuf_saver;
typedef basic_ios_rdbuf_saver<wchar_t>      wios_rdbuf_saver;
typedef basic_ios_fill_saver<char>           ios_fill_saver;
typedef basic_ios_fill_saver<wchar_t>       wios_fill_saver;
typedef basic_ios_locale_saver<char>         ios_locale_saver;
typedef basic_ios_locale_saver<wchar_t>     wios_locale_saver;
typedef basic_ios_all_saver<char>            ios_all_saver;
typedef basic_ios_all_saver<wchar_t>        wios_all_saver;

class ios_iword_saver;
class ios_pword_saver;
class ios_all_word_saver;

}
}
```

##<a name="base_savers">Savers for Basic Standard Attributes</a>

<!--
<p>The basic saver classes have this format:</p>
-->
基本セーバークラスは、次のようなフォーマットを持っている。:

```cpp
class saver_class
{
    typedef std::ios_base           state_type;
    typedef implementation_defined  aspect_type;

    explicit  saver_class( state_type &s );
              saver_class( state_type &s, aspect_type const &new_value );
             ~saver_class();
};
```

<!--
<p>The <var>state_type</var> is the IOStreams base class
<code>std::ios_base</code>.  The user would usually place an actual
input, output, or combined stream object for the state-type parameter,
and not a base class object.  The first constructor takes a stream
object and saves a reference to the stream and the current value of a
particular stream attribute.  The second constructor works like the
first, and uses its second argument to change the stream's attribute to
the new <var>aspect_type</var> value given.  The destructor changes the
stream's attribute back to the saved value.</p>
-->
`state_type`は、入出力ストリーム基本クラスの`std::ios_base`のことである。
ユーザが通常`state-type`パラメータに置くのは、実際の入力(ストリーム)、出力(ストリーム)、または入出力ストリームオブジェクトであって、基底クラスのオブジェクトではないだろう。
最初のコンストラクタは、ストリームオブジェクトを１つ取り、そのストリームへの参照とストリーム固有の属性とを保持する。
２番目のコンストラクタは一つ目のと同様に働くが、さらにそれに加えて第２引数に新しい`aspect_type`を指定することでストリームの属性を変更できる。
デストラクタはストリームの属性を保持しておいた状態に戻す。

###Basic IOStreams State Saver Classes
| Class | Saved Attribute | Attribute Type | Reading Method | Writing Method |
|---|---|---|---|---|
| `boost::io::ios_flags_saver` | Format control flags | `std::ios_base::fmtflags` | `flags` | `flags` |
| `boost::io::ios_precision_saver` | Number of digits to print after decimal point | `std::streamsize` | `precision` | `precision` |
| `boost::io::ios_width_saver` | Minimum field width for printing objects | `std::streamsize` | `width` | `width` |

##<a name="adv_savers">Savers for Advanced Standard Attributes</a>

<!--
<p>The saver class templates have this format:</p>
-->
セーバークラステンプレートは次のようなフォーマットを持つ:

```cpp
template < typename Ch, class Tr >
class saver_class
{
    typedef std::basic_ios<Ch, Tr>  state_type;
    typedef implementation_defined  aspect_type;

    explicit  saver_class( state_type &s );
              saver_class( state_type &s, aspect_type const &new_value );
             ~saver_class();
};
```

<!--
<p>The <var>state_type</var> is a version of the IOStreams base class
template <code>std::basic_ios&lt;Ch, Tr&gt;</code>, where
<code>Ch</code> is a character type and <code>Tr</code> is a character
traits class.  The user would usually place an actual input, output, or
combined stream object for the state-type parameter, and not a base
class object.  The first constructor takes a stream object and saves a
reference to the stream and the current value of a particular stream
attribute.  The second constructor works like the first, and uses its
second argument to change the stream's attribute to the new
<var>aspect_type</var> value given.  The destructor changes the stream's
attribute back to the saved value.</p>
-->
`state_type`は、入出力ストリーム基本クラステンプレート`std::basic_ios<Ch, Tr>`のことである。
ここで`Ch`は、文字タイプ、`Tr`は文字特性のことである。
ユーザが通常`state-type`パラメータに置くのは、実際の入力(ストリーム)、出力(ストリーム)、または入出力ストリームオブジェクトであって、基底クラスのオブジェクトではないだろう。
最初のコンストラクタは、ストリームオブジェクトを１つ取り、そのストリームへの参照とストリーム固有の属性とを保持する。
２番目のコンストラクタは一つ目のと同様に働くが、さらにそれに加えて第２引数に新しい`aspect_type`を指定することでストリームの属性を変更できる。
デストラクタはストリームの属性を保持しておいた状態に戻す。

###Advanced IOStreams State Saver Class Templates
| Class Template | Saved Attribute | Attribute Type | Reading Method | Writing Method |
|---|---|---|---|---|
| `boost::io::basic_ios_iostate_saver<Ch, Tr>` | Failure state of the stream [[1]](#Note1) | `std::ios_base::iostate` | `rdstate` | `clear` |
| `boost::io::basic_ios_exception_saver<Ch, Tr>` | Which failure states trigger an exception [[1]](#Note1) | `std::ios_base::iostate` | `exceptions` | `exceptions` |
| `boost::io::basic_ios_tie_saver<Ch, Tr>` | Output stream synchronized with the stream | `std::basic_ostream<Ch, Tr> *` | `tie` | `tie` |
| `boost::io::basic_ios_rdbuf_saver<Ch, Tr>` | Stream buffer associated with the stream [[2]](#Note2) | `std::basic_streambuf<Ch, Tr> *` | `rdbuf` | `rdbuf` |
| `boost::io::basic_ios_fill_saver<Ch, Tr>` | Character used to pad oversized field widths | `Ch` | `fill` | `fill` |
| `boost::io::basic_ios_locale_saver<Ch, Tr>` | Locale information associated with the stream [[3]](#Note3) | `std::locale` | `getloc` (from `std::ios_base`) | `imbue` (from `std::basic_ios<Ch, Tr>`) |

###Notes

<!--
	<li>When the failure state flags and/or the failure state exception
		watching flags are changed, an exception is thrown if a match
		occurs among the two sets of flags.  This could mean that
		the <a name="Note1">constructor or destructor of these class
		templates may throw</a>. 
-->
- 失敗状態フラグとフラグを監視している失敗状態例外の両方またはどちらかが変化した場合、もし２つのフラグが一致したら例外が投げられる。
  これは、<a name="Note1">これらのクラステンプレートのコンストラクタまたはデストラクタが例外を投げることを意味するかもしれない。</a>

<!--
	<li>When the associated stream buffer is changed, the stream's
		failure state set is reset to "good" if the given stream
		buffer's address is non-NULL, but the "bad" failure
		state is set if that address is NULL.  Given a NULL stream
		buffer address, an exception is thrown if the "bad"
		failure state is being watched.  This could mean that the 
		<a name="Note2">constructor or destructor of this class template may throw</a>. 
-->
- 関連ストリームバッファが変化した場合、もし指定したストリームバッファのアドレスがNULLでないならばストリームの失敗状態は"good"にリセットされるが、NULLだった場合には"bad"失敗状態がセットされる。
  NULLストリームバッファアドレスを指定した場合、もし"bad"失敗状態が監視されていると例外が投げられる。
  これは、<a name="Note2">このクラステンプレートのコンストラクタまたはデストラクタが例外を投げることを意味するかもしれない。</a>

<!--
	<li>The <a name="Note3">saver for the locale uses the
		<code>std::basic_ios&lt;Ch, Tr&gt;</code> class to extract their
		information</a>, although it could have used the functionality
		in <code>std::ios_base</code>.  The problem is that the versions
		of the needed member functions in <code>ios_base</code> are not
		polymorphically related to the ones in <code>basic_ios</code>. 
		The stream classes that will be used with the saver classes
		should use the versions of the member functions closest to them
		by inheritance, which means the ones in
		<code>basic_ios</code>.</li>
-->
- <a name="Note3">ロケール用のセーバーは、`std::ios_base`の関数をロケール情報を取り出すために使用できたかもしれないが、そうはせずに`std::basic_ios<Ch, Tr>`クラスを使用して情報を取り出している。</a>
  この問題は、`basic_ios`の中の必要とするメンバ関数が多態的に`basic_ios`のそれに結びついていないためである。
  セーバークラスと共に使用されるストリームクラスは継承によってそれらに最も近いメンバ関数を使用するべきである。
</ol>

##<a name="user_savers">Savers for User-Defined Attributes</a>

<!--
<p>The saver classes for user-defined formatting information have this
format:</p>
-->
ユーザー定義の情報の為のセーバークラスは、次のようなフォーマットを持つ。

```cpp
#include <iosfwd>  // for std::ios_base (declaration)

class saver_class
{
    typedef std::ios_base           state_type;
    typedef int                     index_type;
    typedef implementation_defined  aspect_type;

    explicit  saver_class( state_type &s, index_type i );
              saver_class( state_type &s, index_type i, aspect_type &new_value );
             ~saver_class();
};
```

<!--
<p>The index <var>i</var> differentiates between specific user-defined
formatting attributes.  The index can only be determined at run-time
(most likely with the class-static <code>std::ios_base::xalloc</code>
member function).</p>
-->
インデックス`i`は、ユーザー定義の属性を区別するのに使用される。
インデックスは、実行時にのみ決定できる。
（それはおそらく静的メンバ関数`std::ios_base::xalloc`と同時だろう。）

<!--
<p>The <var>state_type</var> is the base class of the IOStreams system,
<code>std::ios_base</code>.  The user would usually place an actual
input, output, or combined stream object for the state-type parameter,
and not a base class object.  The first constructor takes a stream
object and index and saves a reference to the stream and the current
value of a particular stream attribute.  The second constructor works
like the first, and uses its third argument to change the stream's
attribute to the new <var>aspect_type</var> value given.  The destructor
changes the stream's attribute back to the saved value.</p>
-->
`state_type`は、入出力ストリームシステムの基本クラス`std::ios_base`である。
ユーザが通常`state-type`パラメータに置くのは、実際の入力(ストリーム)、出力(ストリーム)、または入出力ストリームオブジェクトであって、基底クラスのオブジェクトではないだろう。
最初のコンストラクタは、ストリームオブジェクトを１つ取り、そのストリームへの参照とストリーム固有の属性とを保持する。
２番目のコンストラクタは一つ目のと同様に働くが、さらにそれに加えて第３引数に新しい`aspect_type`を指定することでストリームの属性を変更できる。
デストラクタはストリームの属性を保持しておいた状態に戻す。

###IOStream User-Defined State Saver Classes
| Class | Saved Attribute | Attribute Type | Reference Method |
|---|---|---|---|
| `boost::io::ios_iword_saver` | Numeric user-defined format flag | `long` | `iword` |
| `boost::io::ios_pword_saver` | Pointer user-defined format flag | `void *` | `pword` |

##<a name="combo_savers">Savers for Combined Attributes</a>

<!--
<p>There are three class (templates) for combined attribute savers.  The
<code>boost:io::ios_base_all_saver</code> saver class combines the
functionality of all the basic attribute saver classes.  It has a
constructor that takes the stream to have its state preserved.  The
<code>boost::io::basic_ios_all_saver</code> combines the functionality
of all the advanced attribute saver class templates and the combined
basic attribute saver class.  It has a constructor that takes the stream
to have its state preserved.  The
<code>boost::io::ios_all_word_saver</code> saver class combines the
saver classes that preserve user-defined formatting information.  Its
constructor takes the stream to have its attributes saved and the index
of the user-defined attributes.</p>
-->
属性セーバークラスを統合するために３つのクラス（テンプレート）がある。
`boost:io::ios_base_all_saver`セーバークラスは、全ての基本属性セーバークラスの機能を統合している。
このクラスには引数に状態を保持させたいストリームを取ることのできるコンストラクタが一つある。
`boost::io::basic_ios_all_saver`セーバークラスは、全ての高等属性セーバークラステンプレートの機能と基本属性セーバークラスを統合している。
このクラスには引数に状態を保持させたいストリームを取ることのできるコンストラクタが一つある。
`boost::io::ios_all_word_saver`セーバークラスは、ユーザー定義の情報を保持するクラスを結合する。
このコンストラクタは、属性を保持させたいストリームとユーザーが定義した属性のインデックスを引数に取る。

##<a name="example">Example</a>

<!--
<p>The code used in the <A href="#rationale">rationale</a> can be
improved at two places.  The printing function could use a saver around
the code that changes the formatting state.  Or the calling function can
surround the call with a saver.  Or both can be done for paranoia's
sake.</p>
-->
[Rationale](#rationale)で使用したコードは２つの点で改善できる。
表示出力関数は書式設定状態を変更するコードの周りでセーバーを使えるかもしれない。
または関数の呼び出し側でその関数の周りをセーバーで囲むこともできる。
または両方を偏執症患者のために行うこともできる。

```cpp
#include <boost/io/ios_state.hpp>
#include <ios>
#include <iostream>
#include <ostream>

void  new_hex_my_byte( std::ostream &os, char byte )
{
    boost::io::ios_flags_saver  ifs( os );

    os << std::hex << static_cast<unsigned>(byte);
}

int  main()
{
    using std::cout;

    //...

    {
        boost::io::ios_all_saver  ias( cout );

        new_hex_my_byte( cout, 'A' );
    }

    //...
}
```

##<a name="refer">References</a>

- The I/O state saver library header itself: boost/io/ios_state.hpp
- Some test/example code: ios_state_test.cpp

##<a name="credits">Credits</a>

###<a name="contributors">Contributors</a>

- <A href="../../../people/daryle_walker.html">Daryle Walker</a>

<!--
	<dd>Started the library.  Contributed the initial versions of the
		format flags, precision, width, and user-defined format flags
		saver classes.  Contributed the initial versions of the success
		state, success state exception flags, output stream tie, stream
		buffer, character fill, and locale saver class templates. 
		Contributed the combined attribute classes and class template. 
		Contributed the test file <cite><A
		 href="../test/ios_state_test.cpp" >ios_state_test.cpp</a></cite>.</dd>
-->
    - このライブラリを開始した。
      フォーマットフラグ、精度、幅、そしてユーザー定義のフォーマットフラグを保持するクラスの初期バージョンに貢献した。
      成功状態、成功状態例外フラグ、出力ストリームタイ、ストリームバッファ、文字埋め、そしてロケールをセーブするクラステンプレートの初期バージョンに貢献した。
	属性クラスとクラステンプレートを統合するのに貢献した。
	テストファイルios_state_test.cppに貢献した。

###<a name="history">History</a>

- 13 Mar 2002, Daryle Walker
    - Initial version

--

Revised: 13 March 2002

Copyright c Daryle Walker 2002.  Permission to copy, use,
modify, sell and distribute this document is granted provided this
copyright notice appears in all copies.  This document is provided
"as is" without express or implied warranty, and with no claim
as to its suitability for any purpose.


Japanese Translation Copyright (C) 2003 MINAMI Takeshi.
オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の
複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」
に提供されており、いかなる明示的、暗黙的保証も行わない。また、
いかなる目的に対しても、その利用が適していることを関知しない。

