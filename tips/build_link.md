#ヘッダオンリー or ビルドが必要なライブラリ
ここでは、Boostの各ライブラリが、ヘッダオンリーなのか、ビルドが必要なのか、どの外部ライブラリが必要なのか、といったものをまとめる。

バージョン： 1.54.0


| ライブラリ名       | ビルド種類 | 依存ライブラリ | 備考 |
|--------------------|----------------|--|--|
| Accumulators       | ヘッダオンリー |  |  |
| Algorithm          | ヘッダオンリー |  |  |
| Any                | ヘッダオンリー |  |  |
| Array              | ヘッダオンリー |  |  |
| Asio               | ヘッダオンリー。 SSL通信を使用する場合はOpenSSLが必要。 | Date Time, Regex, System | SSL通信以外では、以下のマクロをdefineすることでヘッダオンリーで使用可能。 `BOOST_DATE_TIME_NO_LIB`、`BOOST_REGEX_NO_LIB`、`BOOST_ERROR_CODE_HEADER_ONLY`、`BOOST_SYSTEM_NO_LIB`。Regexを使用しない場合、正規表現を使用する受信関数が使用不能となる。 |
| Assign             | ヘッダオンリー |  |  |
| Atomic             | ビルドが必要   |  |  |
| Bimap              | ヘッダオンリー |  |  |
| Bind               | ヘッダオンリー |  |  |
| Call Traits        | ヘッダオンリー |  |  |
| Chrono             | ビルドが必要   |  | 以下のマクロをdefineすることで、ヘッダオンリーで使用可能。 `BOOST_CHRONO_HEADER_ONLY` |
| Circular Buffer    | ヘッダオンリー |  |  |
| Compatibility      | ヘッダオンリー |  |  |
| Compressed Pair    | ヘッダオンリー |  |  |
| Concept Checp      | ヘッダオンリー |  |  |
| Config             | ヘッダオンリー |  |  |
| Container          | ヘッダオンリー |  |  |
| Context            | ビルドが必要   |  |  |
| Conversion         | ヘッダオンリー |  |  |
| CRC                | ヘッダオンリー |  |  |
| Coroutine          | ヘッダオンリー | Context |  |
| Date Time          | ビルドが必要   |  | posix timeのみを使用する場合は、以下のマクロをdefineすることでヘッダオンリーで使用可能。 `BOOST_DATE_TIME_NO_LIB` |
| Disjoint Sets      | ヘッダオンリー |  |  |
| Dynamic Bitset     | ヘッダオンリー |  |  |
| Enable If          | ヘッダオンリー |  |  |
| Exception          | ヘッダオンリー |  |  |
| Filesystem         | ビルドが必要   | System |  |
| Flyweight          | ヘッダオンリー |  |  |
| Foreach            | ヘッダオンリー |  |  |
| Format             | ヘッダオンリー |  |  |
| Function           | ヘッダオンリー |  |  |
| Functional         | ヘッダオンリー |  |  |
| Functional/Factory | ヘッダオンリー |  |  |
| Functional/Forward | ヘッダオンリー |  |  |
| Functional/Hash    | ヘッダオンリー |  |  |
| Functional/OverloadedFunction | ヘッダオンリー |  |  |
| Fusion             | ヘッダオンリー |  |  |
| Geometry           | ヘッダオンリー |  |  |
| GIL                | pngを使用する場合はlibpng jpegを使用する場合はlibjpeg tiffを使用する場合はlibtiffが必要 |  |  |
| Graph              | ヘッダオンリー。 GraphMLを使用する場合はビルドが必要。 |  |  |
| Heap               | ヘッダオンリー |  |  |
| ICL                | ヘッダオンリー |  |  |
| Identity Type      | ヘッダオンリー |  |  |
| In Place Factory, Typed In Place Factory | ヘッダオンリー |  |  |
| Integer            |  |  |  |
| Interprocess       | ヘッダオンリー | Date Time | Boost.DateTimeの機能としてposix timeしか使用していないため、以下のマクロをdefineすることでヘッダオンリーで使用可能。 `BOOST_DATE_TIME_NO_LIB` |
| Interval           | ヘッダオンリー |  |  |
| Intrusive          | ヘッダオンリー |  |  |
| IO State Savers    | ヘッダオンリー |  |  |
| Iostreams          | ビルドが必要。 zlib, gzipを使用する場合はzlib bzip2を使用する場合はlibbz2が必要。 | Regex | インストールマニュアルを参照 [Installation](http://www.boost.org/libs/iostreams/doc/installation.html) |
| Iterators          | ヘッダオンリー |  |  |
| Lambda             | ヘッダオンリー |  |  |
| Lexical Cast       | ヘッダオンリー |  |  |
| Local Function     | ヘッダオンリー |  |  |
| Locale             | ビルドが必要   | System | ICUバックエンドを使用する際は、ビルドオプションを設定する必要がある。 [Building The Library](http://www.boost.org/doc/libs/release/libs/locale/doc/html/building_boost_locale.html) |
| Lockfree           | ヘッダオンリー | Atomic | C++11環境では内部的に`std::atomic`を使用するため、依存ライブラリなし。 |
| Log                | ビルドが必要   |  |  |
| Math               | ヘッダオンリー |  |  |
| Math Common Factor | ヘッダオンリー |  |  |
| Math Octonion      | ヘッダオンリー |  |  |
| Math Quaternion    | ヘッダオンリー |  |  |
| Math / Special Functions        | ヘッダオンリー |  |  |
| Math / Statistical Distribution | ヘッダオンリー |  |  |
| Member Functions   | ヘッダオンリー |  |  |
| Meta State Machine | ヘッダオンリー |  |  |
| Move               | ヘッダオンリー |  |  |
| Min-Max            | ヘッダオンリー |  |  |
| MPI | ビルドが必要 |  | インストールマニュアルを参照 [Installing and Using Boost.MPI](http://www.boost.org/doc/html/mpi/getting_started.html#mpi.installation) |
| MPL                | ヘッダオンリー |  |  |
| Multi-Array        | ヘッダオンリー |  |  |
| Multi-Index        | ヘッダオンリー |  |  |
| Multiprecision     | ヘッダオンリー |  |  |
| Numeric Conversion | ヘッダオンリー |  |  |
| Odeint             | ヘッダオンリー |  |  |
| Operators          | ヘッダオンリー |  |  |
| Optional           | ヘッダオンリー |  |  |
| Parameter          | ヘッダオンリー |  |  |
| Phoenix            | ヘッダオンリー |  |  |
| Pointer Container  | ヘッダオンリー |  |  |
| Polygon            | ヘッダオンリー |  |  |
| Pool               | ヘッダオンリー |  |  |
| Preprocessor       | ヘッダオンリー |  |  |
| Program Options    | ビルドが必要   |  |  |
| Property Map       | ヘッダオンリー |  |  |
| Property Tree      | ヘッダオンリー |  |  |
| Proto              | ヘッダオンリー |  |  |
| Python             |  |  |  |
| Random             | ビルドが必要 |  | `random_device`を使用しない場合、ヘッダオンリーで使用可能。 |
| Range              | ヘッダオンリー |  |  |
| Ratio              | ヘッダオンリー |  |  |
| Rational           | ヘッダオンリー |  |  |
| Ref                | ヘッダオンリー |  |  |
| Regex              | ビルドが必要   |  |  |
| Result Of          | ヘッダオンリー |  |  |
| Scope Exit         | ヘッダオンリー |  |  |
| Serialization      | ビルドが必要   |  |  |
| Signals            | ビルドが必要 |  |  |
| Signals2           | ヘッダオンリー |  |  |
| Smart Ptr          | ヘッダオンリー |  |  |
| Spirit             | ヘッダオンリー |  |  |
| Statechart         | ヘッダオンリー |  |  |
| Static Assert      | ヘッダオンリー |  |  |
| String Algo        | ヘッダオンリー |  |  |
| Swap               | ヘッダオンリー |  |  |
| System             | ビルドが必要 |  | 以下のマクロをdefineすることでヘッダオンリーとして使用可能。 `BOOST_ERROR_CODE_HEADER_ONLY`、`BOOST_SYSTEM_NO_LIB` |
| Test | ビルドが必要 |  | minimal test、もしくは`boost/test/included`以下のヘッダをインクルードすることで、ヘッダオンリーとして使用可能。 |
| Thread             | ビルドが必要   | System, Chrono |  |
| Timer              | ヘッダオンリー |  |  |
| Tokenizer          | ヘッダオンリー |  |  |
| TR1                | ヘッダオンリー |  |  |
| Tribool            | ヘッダオンリー |  |  |
| TTI                | ヘッダオンリー |  |  |
| Tuple              | ヘッダオンリー |  |  |
| Type Erasure       | ヘッダオンリー |  |  |
| Type Traits        | ヘッダオンリー |  |  |
| Typeof             | ヘッダオンリー |  |  |
| uBLAS              | ヘッダオンリー | Serialization | シリアライズを使用しない場合は、以下のマクロをdefineすることで、自動リンクを解除できる。`BOOST_SERIALIZATION_NO_LIB` |
| Units              | ヘッダオンリー |  |  |
| Unordered          | ヘッダオンリー |  |  |
| Utility            | ヘッダオンリー |  |  |
| Uuid               | ヘッダオンリー |  |  |
| Value Initialized  | ヘッダオンリー |  |  |
| Variant            | ヘッダオンリー |  |  |
| Wave               | ヘッダオンリー |  |  |
| Xpressive          | ヘッダオンリー |  |  |


