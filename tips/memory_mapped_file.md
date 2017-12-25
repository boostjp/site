# メモリマップドファイル
メモリマップドファイルには [Boost Interprocess Library](http://www.boost.org/doc/libs/release/doc/html/interprocess.html) を使用する。

Boost.Interprocessは、プロセス間通信をサポートするための各種機能を提供しているライブラリである。ライブラリはビルドを必要としないが、[Boost DateTime Library](http://www.boost.org/doc/libs/release/doc/html/date_time.html) を利用している箇所があるため注意すること。

またこのページでManaged Memory Segmentsについての記述は基本的に`managed_mapped_file`以外のクラス(`managed_shared_memory`など)でも同様の動作を行う。


## インデックス
- [存在しているファイルからマッピングする](#file-mapping)
- [ファイルをテンポラリバッファとして利用する](#file-as-temporary-buffer)
- [ファイルをコンテナにマッピングする](#container-file-mapping)


## <a id="file-mapping" href="#file-mapping">存在しているファイルからマッピングする</a>

既に存在しているファイルをマッピングするには、`boost::interprocess::file_mapping`クラスを用いることで単純にマッピングすることができる。しかしこれだけではファイルにアクセスできないため、`boost::interprocess::mapped_region`クラスでビューを作成してアクセスする。

```cpp
namespace ipc = boost::interprocess;

ipc::file_mapping map("data.dat",ipc::read_only);
ipc::mapped_region view(map,ipc::read_only);

void* ptr = view.get_address();           // マッピングしたファイルの先頭アドレス
std::size_t const size = view.get_size(); // マッピングした領域のサイズ

std::vector<char> dat( size );
memcpy( dat.data(), ptr, size );
```


また、`mapped_region`クラスのコンストラクタ引数でマッピングする領域を指定して、必要な部分のみをビューとして取り出せる。

```cpp
std::size_t const offset = 0;   // マッピング領域の開始位置(ファイル先頭から)
std::size_t const size   = 128; // 領域のサイズ

ipc::mapped_region view(map,ipc::read_only,offset,size);

BOOST_ASSERT( size == view.get_size() );
```


## <a id="file-as-temporary-buffer" href="#file-as-temporary-buffer">ファイルをテンポラリバッファとして利用する</a>
メモリマップドファイルの機能をテンポラリデータ保存のために利用することもできる。Boost.InterprocessにはManaged Memory Segmentsというオブジェクト生成支援関数群が用意されており、ファイルをテンポラリバッファとして利用するのが簡単になる。

`managed_mapped_file`クラスの`construct()`メンバを使用し、`find()`メンバで検索可能なnamed instanceを生成、unique instanceやanonymous instanceも生成できる。

```cpp example
#include <boost/interprocess/managed_mapped_file.hpp>
#include <iostream>

int main()
{
    namespace ipc = boost::interprocess;

    ipc::file_mapping::remove( "tmp.dat" );
    ipc::managed_mapped_file mfile( ipc::create_only, "tmp.dat", 4096 );

    int* p = mfile.construct<int>("MyData")( 42 );

    BOOST_ASSERT( *p == 42 );
    BOOST_ASSERT( p == mfile.find<int>("MyData").first );

    mfile.destroy<int>("MyData");
    BOOST_ASSERT( !mfile.find<int>("MyData").first );

    int* t = mfile.construct<int>(ipc::anonymous_instance)(42);
    BOOST_ASSERT( *t == 42 );
    mfile.destroy_ptr(t);
}
```


## <a id="container-file-mapping" href="#container-file-mapping">ファイルをコンテナにマッピングする</a>
Boost.Interprocessには標準ライブラリと同様の使い方が可能なコンテナが用意されており、コンテナをManaged Memory Segmentsを使ってファイル上に直接構築することができる。また、[Boost Multi-Index Containers Library](http://www.boost.org/doc/libs/release/libs/multi_index/doc/index.html)も利用可能である。

基本的にはManaged Memory Segmentsクラスから取得できる`segment_manager`を使ってアロケータを構築、そのアロケータを使ったコンテナを生成することでコンテナ並びにコンテナの要素をファイル上に構築できる。

```cpp example
#include <boost/interprocess/managed_mapped_file.hpp>
#include <boost/interprocess/containers/vector.hpp>
#include <boost/interprocess/allocators/allocator.hpp>
#include <iostream>
#include <boost/range/algorithm/generate.hpp>
#include <boost/range/algorithm/for_each.hpp>

int main()
{
    namespace ipc = boost::interprocess;

    typedef ipc::allocator<int,ipc::managed_mapped_file::segment_manager> allocator_t;
    typedef ipc::vector<int,allocator_t> vector_t;

    ipc::file_mapping::remove( "tmp.dat" );
    ipc::managed_mapped_file mfile( ipc::create_only, "tmp.dat", 4096 );

    vector_t* vec = mfile.construct<vector_t>("MyVector")(mfile.get_segment_manager());

    vec->resize(10);
    boost::generate(*vec,[](){ return 42; });
    boost::for_each(*vec,[](int i) { std::cout << i << std::endl; } );
}
```

