#メモリマップドファイル
メモリマップドファイルを利用するには[ Boost Interprocess Library](http://www.boost.org/doc/libs/1_46_1/doc/html/interprocess.html) を用いる。
Boost Interprocessは、プロセス間通信をサポートするための各種機能を提供しているライブラリである。ライブラリはビルドを必要としないが、[Boost DateTime Library](http://www.boost.org/doc/libs/1_46_1/doc/html/date_time.html) を利用している箇所があるため注意すること。
またこのページでManaged Memory Segmentsについての記述は基本的にmanaged_mapped_file以外のクラス(managed_shared_memoryなど)でも同様の動作を行う。


Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>既存のファイルのマッピング](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>テンポラリバッファとしての利用](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>コンテナの利用](#TOC--2)</li></ol>



<h4>既存のファイルのマッピング</h4>既に存在しているファイルをマッピングするには、boost::interprocess::file_mappingを用いることで単純にマッピングすることができる。しかしこれだけではファイルにアクセスできないためboost::interprocess::mapped_regionでビューを作成してアクセスする。

```cpp
namespace ipc = boost::interprocess;

ipc::file_mapping map("data.dat",ipc::read_only);	ipc::mapped_region view(map,ipc::read_only);void* ptr = view.get_address();           // マッピングしたファイルの先頭アドレス
std::size_t const size = view.get_size(); // マッピングした領域のサイズ

std::vector<char> dat( size );
memcpy( dat.data(), ptr, size );
```


また、mapped_regionの引数でマッピングする領域を指定して必要な部分のみをビューとして取り出すことができる。

```cpp
std::size_t const offset = 0;<span>   // マッピング領域の開始位置(ファイル先頭から)</span>
std::size_t const size   = 128; // 領域のサイズ

ipc::mapped_region view(map,ipc::read_only,offset,size);

BOOST_ASSERT( size == view.get_size() );


<h4>テンポラリバッファとしての利用</h4>メモリマップドファイルの機能をテンポラリデータ保存のために利用することもできる。InterprocessにはManaged Memory Segmentsというオブジェクト生成支援関数群が用意されており、ファイルをテンポラリバッファとして利用するのが簡単になる。
constructメソッドを用いてfindメソッドで検索可能なnamed instanceを生成、unique instanceやanonymous instanceも生成できる。

```cpp
#include <boost/interprocess/managed_mapped_file.hpp>
#include <iostream>

int main()
{
<span>    namespace ipc = boost::interprocess;</span>

<span>    ipc::file_mapping::remove( "tmp.dat" );</span>
<span>    ipc::managed_mapped_file mfile( ipc::create_only, "tmp.dat", 4096 );</span>

<span>    int* p = mfile.construct<int>("MyData")( 42 );</span><span></span>
<span></span>
<span>    BOOST_ASSERT( *p == 42 );</span>
<span><span>    BOOST_ASSERT( p == mfile.find<int>("MyData").first );</span></span><span><span></span></span>
<span><span></span></span>
<span><span><span>    mfile.destroy<int>("MyData");</span></span></span><span><span><span></span></span></span>
<span><span><span><span>    BOOST_ASSERT( !mfile.find<int>("MyData").first );</span></span></span></span>
<span><span><span><span></span></span></span></span>
<span><span><span><span><span>    int* t = mfile.construct<int>(ipc::anonymous_instance)(42);</span></span></span></span></span>
<span><span><span><span><span><span>    BOOST_ASSERT( *t == 42 );</span></span></span></span></span></span>
<span><span><span><span><span><span><span>    mfile.destroy_ptr(t);</span></span></span></span></span></span></span>
}
```


<h4>コンテナの利用</h4>InterprocessにはSTLと同様の使い方が可能なコンテナが用意されており、コンテナをManaged Memory Segmentsを使ってファイル上に直接構築することができる。また、[Boost Multi-Index Containers Library](http://www.boost.org/doc/libs/1_46_1/libs/multi_index/doc/index.html)も利用可能である。
基本的にはManaged Memory Segmentsクラスから取得できるsegment_managerを使ってアロケータを構築、そのアロケータを使ったコンテナを生成することでコンテナ並びにコンテナの要素をファイル上に構築できる。

```cpp
#include <boost/interprocess/managed_mapped_file.hpp>#include <boost/interprocess/containers/vector.hpp>#include <boost/interprocess/allocators/allocator.hpp>#include <iostream>#include <boost/range/algorithm/generate.hpp>#include <boost/range/algorithm/for_each.hpp>int main(){	<span>    namespace ipc = boost::interprocess;	    typedef ipc::allocator<int,ipc::managed_mapped_file::segment_manager> allocator_t;	    typedef ipc::vector<int,allocator_t> vector_t;	    ipc::file_mapping::remove( "tmp.dat" );	    ipc::managed_mapped_file mfile( ipc::create_only, "tmp.dat", 4096 );</span>
	<span>    vector_t* vec = mfile.construct<vector_t>("MyVector")(mfile.get_segment_manager());	    vec->resize(10);	    boost::generate(*vec,[](){ return 42; });	    boost::for_each(*vec,[](int i) { std::cout << i << std::endl; } );}</span>


