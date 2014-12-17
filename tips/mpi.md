#MPI による並列計算
[Boost MPI Library](http://www.boost.org/doc/libs/release/doc/html/mpi.html)はメッセージ通信インターフェイスである MPI を C++ でより簡単に扱えるようにしたライブラリである。

このライブラリを使用する際には MPI の実装 (OpenMPI, MPICH...) が必要になるため注意すること。

また、 C MPI と Boost.MPI の対応は [Mapping from C MPI to Boost.MPI](http://www.boost.org/doc/libs/release/doc/html/mpi/tutorial.html#mpi.c_mapping) を参照。

とくに断りがなければ、ここで紹介するプログラムは C++11 を使用する。


##インデックス
- [Boost.MPI を使ったプログラムをビルドする](#build)
- [MPI の初期化を行う](#initialize)
- [自身のランクやノード数を調べる](#rank-and-size)
- [計算するデータを均等に分散させる](#scatter)
- [あるデータを全てのランクで共有する](#broadcast)
- [計算したデータをあるランクに集める](#gather)
- [1対1の通信を行う](#peer-to-peer)
- [1対1の通信を非同期で行う](#async-peer-to-peer)
- [非プリミティブ型を他のノードへ送信する](#serialize)
- [全てのランクが同じ環境であった場合の高速化](#speed-up-all-same-rank)


## <a name="build" href="#build">Boost.MPI を使ったプログラムをビルドする</a>
ビルド自体は mpic++、 mpicxx などのインストールした MPI 実装で用意されている C++ 用コンパイラを用いればよいが、Boost.MPI および Boost.Serialization ライブラリをリンクする必要がある。

以下は Boost.MPI を用いたコード bmpi.cpp をビルドするコマンドである。

```
$ mpicxx -I/boost/include -L/boost/lib -o bmpi bmpi.cpp -lboost_mpi -lboost_serialization
```


## <a name="initialize" href="#initialize">MPI の初期化を行う</a>
Boost.MPI で `MPI_Init()`、 `MPI_Finalize()` 相当の処理を行う場合、 `boost::mpi::environment` クラスを使用する。

```cpp
#include <boost/mpi/environment.hpp>

namespace bmpi = boost::mpi;

int main(int argc, char** argv)
{
    bmpi::environment env(argc, argv);
}
```

`environment` クラスは、 コンストラクタで `MPI_Init()` を呼び出し、 デストラクタで `MPI_Finalize()` を呼び出す。


## <a name="rank-and-size" href="#rank-and-size">自身のランクやノード数を調べる</a>
自身のランクや、 全体のノード数を調べるときは `boost::mpi::communicator` クラスを使用する。

その `rank()` メンバ関数で自身のランク数、 `size()` メンバ関数でノード数を取得できる。

```cpp
#include <boost/mpi/environment.hpp>
#include <boost/mpi/communicator.hpp>
#include <iostream>

namespace bmpi = boost::mpi;

int main(int argc, char** argv)
{
    bmpi::environment env(argc, argv);
    bmpi::communicator world;

    std::cout << "Rank : " << world.rank() << std::endl;
    std::cout << "Number of Node : " << world.size() << std::endl;
}
```


## <a name="scatter" href="#scatter">計算するデータを均等に分散させる</a>
計算したいデータはおそらく大抵の場合ファイルなど外部から入力されるデータである。

そのため、データはあるランクで生成し、その後全てのランクにデータを分散させた方が効率が良いと考えられる。

`scatter()` 関数は、データを均等に全てのノードに分散させる関数である。

以下のプログラムは、 ベクトルをランク 0 で生成して全てのノードに均等に分散するものである。

```cpp
#include <boost/mpi/communicator.hpp>
#include <boost/mpi/environment.hpp>
#include <boost/mpi/collectives.hpp>
#include <vector>
#include <ctime>
#include <cassert>
#include <algorithm>

namespace bmpi = boost::mpi;

int main(int argc, char** argv)
{
    bmpi::environment env(argc, argv);
    bmpi::communicator world;

    constexpr int N = 8;
    assert(N % world.size() == 0);
    std::vector<double> v;

    if(world.rank() == 0)
    {
        v.resize(N);
        std::srand(std::time(0));
        std::generate(std::begin(v), std::end(v), []() { return double(std::rand()) / RAND_MAX; });
    }
    else
    {
        v.resize(N / world.size());
    }
    bmpi::scatter(world, v, v.data(), N / world.size(), 0);
   
    if(world.rank() == 0)
    {
        v.resize(N / world.size());
    }
   
    std::for_each(std::begin(v), std::end(v)
        , [&](double i) { std::cout << "Rank : " << world.rank() << ", " << i << std::endl; });
}
```

## <a name="broadcast" href="#broadcast">あるデータを全てのランクで共有する</a>
あるデータを全ノードで共有したい場合、 `broadcast()` を用いる。

以下は、ランク 0 で計算したデータを他のランクへ共有するプログラムである。

```cpp
#include <boost/mpi/communicator.hpp>
#include <boost/mpi/environment.hpp>
#include <boost/mpi/collectives.hpp>
#include <vector>
#include <ctime>
#include <cstdlib>
#include <algorithm>

namespace bmpi = boost::mpi;

int main(int argc, char** argv)
{
  bmpi::environment env(argc, argv);
  bmpi::communicator world;

  constexpr int N = 128;
  std::vector<double> v(N);

  if(world.rank() == 0)
  {
    std::srand(std::time(0));
    std::generate(std::begin(v), std::end(v), []() { return double(std::rand()) / RAND_MAX; });
  }
  bmpi::broadcast(world, v, 0);
}
```

## <a name="gather" href="#gather">計算したデータをあるランクに集める</a>
ある計算を MPI で分散させたいとする。その際、分散したデータをどこかに集計しておく必要がある。

その場合は `gather()` 関数を用いることで、あるランクに計算結果を集めることができる。

`gather()` 関数では出力先の変数に `std::vector` を渡すことができる。 `std::vector` を渡した場合、 `gather()` 関数は `std::vector` のサイズを必要分だけ `resize()` する。

以下のプログラムはベクトルの加算演算を MPI で計算するものである。

```cpp
#include <boost/mpi/communicator.hpp>
#include <boost/mpi/environment.hpp>
#include <boost/mpi/collectives.hpp>
#include <iostream>
#include <ctime>
#include <cstdlib>

namespace bmpi = boost::mpi;

int main(int argc, char** argv)
{
    bmpi::environment env(argc, argv);
    bmpi::communicator world;
   
    std::vector<double> x;
    std::vector<double> y;
   
    if(world.rank() == 0)
    {
        std::srand(std::time(0));
        x.resize(world.size());
        y.resize(world.size());
        auto f = []() { return double(std::rand()) / RAND_MAX; };
        std::generate(std::begin(x), std::end(x), f);
        std::generate(std::begin(y), std::end(y), f);
    }
   
    double x_value;
    double y_value;
    bmpi::scatter(world, x, x_value, 0);
    bmpi::scatter(world, y, y_value, 0);
   
    const double result = x_value + y_value;
    bmpi::gather(world, result, x, 0);
   
    if(world.rank() == 0)
    {
        std::cout << "Result." << std::endl;;
        std::for_each(std::begin(x), std::end(x), [](double i) { std::cout << i << std::endl; });
    }
}
```


## <a name="peer-to-peer" href="#peer-to-peer">1対1の通信を行う</a>
1対1通信には `boost::mpi::communicator` クラスの `send()` メンバ関数、および `recv()` 関数を用いる。 `send()`、 `recv()` は同期通信であり、非同期で通信する場合は次で紹介する `isend()`、`irecv()` を用いる。

`send()`、 `recv()` では「タグ」という数値を設定して、型や転送するデータの区別ができる。 `isend()`、`irecv()` も同様。

以下は、偶数ランクのノードが奇数ランクのノードに対し、適当にデータを生成して送信するプログラムである。

```cpp
#include <boost/mpi/communicator.hpp>
#include <boost/mpi/environment.hpp>
#include <boost/mpi/nonblocking.hpp>
#include <iostream>
#include <ctime>
#include <cstdlib>

namespace bmpi = boost::mpi;

int main(int argc, char** argv)
{
    bmpi::environment env(argc, argv);
    bmpi::communicator world;
   
    std::srand(std::time(0));
   
    if(world.rank() % 2 == 0)
    {
        const int target_node = world.rank() + 1;
        double value = double(std::rand()) / RAND_MAX;
        world.send(target_node, 0, value);
        std::cout << "send : " << value << std::endl;
    }
    else
    {
        const int target_node = world.rank() - 1;
        double value;
        world.recv(target_node, 0, value);
        std::cout << "recv : " << value << std::endl;
    }
}
```

## <a name="async-peer-to-peer" href="#async-peer-to-peer">1対1の通信を非同期で行う</a>
非同期で1対1通信を行う際には、`boost::mpi::communicator` クラスの `isend()` メンバ関数、および `irecv()` メンバ関数を用いる。

`isend()`、 `irecv()` は戻り値として `boost::mpi::request` クラスのオブジェクトを返し、非同期通信が終わったかどうか、非同期通信の完了まで待つといった操作ができる。複数のリクエストを同時に操作する為にイテレータを使用する `wait_all()`、`wait_any()` などの関数が用意されている。

以下のプログラムはランク 0 から適当なデータを生成して送信し、他のランクは受け取って表示するだけのプログラムである。ランク 0 は他のノード全てにデータを送信するため非同期で行い、全ての送信リクエストの完了を待つ。他のランクはデータを1つ受け取るだけなので同期受信の `recv()` メンバ関数を使用している。

```cpp
#include <boost/mpi/communicator.hpp>
#include <boost/mpi/environment.hpp>
#include <boost/mpi/nonblocking.hpp>
#include <iostream>
#include <ctime>
#include <cstdlib>
#include <vector>

namespace bmpi = boost::mpi;

int main(int argc, char** argv) {
  bmpi::environment env(argc, argv);
  bmpi::communicator world;

  std::srand(std::time(0));

  if(world.rank() == 0)
  {
    std::vector<bmpi::request> reqs;
    for(int i = 1 ; i < world.size() ; ++i) {
      double r = double(std::rand()) / RAND_MAX;
      reqs.push_back(world.isend(i, 0, r));
    }
    bmpi::wait_all(std::begin(reqs), std::end(reqs));
  }
  else
  {
    double r;
    world.recv(0, 0, r);
    std::cout << "Rank : " << world.rank() << ", Value : " << r << std::endl;
  }
}
```

## <a name="serialize" href="#serialize">非プリミティブ型を他のノードへ送信する</a>
Boost.MPI では非プリミティブな型、自作のクラスなどを [Boost.Serialization](./serialize.md) を用いてシリアライズして他のランクへ送信することができる。

Boost.Serialization の使用方法自体は他に譲るとして、Boost.MPI では固定サイズであるか、またはメンバにポインタを持たないユーザ定義型を MPI DataType としてマークできる。例えば `gps_positions` クラスがあるとして、

```cpp
namespace boost { namespace mpi {
  template<>
  struct is_mpi_datatype<gps_positions> : mpl::true_ {};
} }
```

または

```cpp
BOOST_IS_MPI_DATATYPE(gps_positions)
```

を使用すればいい。

また、シリアライズのパフォーマンスを上げるために、Boost.Serialization のトラッキングやバージョンチェックなどを省くと良いと紹介している。

```cpp
BOOST_CLASS_TRACKING(gps_positions, boost::serialization::track_never)
BOOST_CLASS_IMPLEMENTATION(gps_positions, boost::serialization::object_serializable)
```

また、 `std::string` などの標準ライブラリのクラスは Boost.Serialization で既にシリアライズが定義されているので、Boost.MPI で転送することができる。

以下のプログラムは、 `gps_positions` クラスをブロードキャストするプログラムである。

```cpp
#include <boost/mpi/communicator.hpp>
#include <boost/mpi/environment.hpp>
#include <boost/mpi/collectives.hpp>
#include <boost/serialization/serialization.hpp>
#include <iostream>
#include <ctime>

namespace bmpi = boost::mpi;

struct gps_positions {
  double gx;
  double gy;

  friend class boost::serialization::access;
  template<class Archive>
  void serialize(Archive & ar, unsigned int version)
  {
    ar & gx;
    ar & gy;
  }
};

std::ostream& operator<<(std::ostream& os, gps_positions const& p) {
  os << "(" << p.gx << ", " << p.gy << ")";
  return os;
}

BOOST_IS_MPI_DATATYPE(gps_positions)
BOOST_CLASS_IMPLEMENTATION(gps_positions, boost::serialization::object_serializable)

int main(int argc, char** argv)
{
  bmpi::environment env(argc, argv);
  bmpi::communicator world;

  gps_positions pos;

  if(world.rank() == 0)
  {
    std::srand(std::time(0));
    pos.gx = double(std::rand()) / RAND_MAX;
    pos.gy = double(std::rand()) / RAND_MAX;
  }
  bmpi::broadcast(world, pos, 0);

  std::cout << "Rank : " << world.rank() << ", " << pos << std::endl;
}
```

## <a name="speed-up-all-same-rank" href="#speed-up-all-same-rank">全てのランクが同じ環境であった場合の高速化</a>
MPI は複数のコンピュータで実行することができる、あるいは実行することが目的だが、このコンピュータ全てが同じアーキテクチャであった (Homogeneous Machines) 場合、`MPI_PACK`/`UNPACK` を避けてデータを直接転送するような方法に切り替えることで、通信の高速化が行えるようになっている。

その場合は、`BOOST_MPI_HOMOGENEOUS` マクロを Boost.MPI のライブラリ自身と Boost.MPI を使用したアプリをビルドする際に定義すればいい。

