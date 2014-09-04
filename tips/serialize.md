#シリアライズ
データの保存、ネットワーク通信でのデータの送受信といった場面において、任意の型の特定のフォーマットへのシリアライズ、デシリアライズが必要になることがある。Boost Serialization Libraryは、標準ライブラリやBoostライブラリのあらゆる型へのシリアライズとデシリアライズと、ユーザー定義型のシリアライズ方法を提供するライブラリである。


Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>サポートされているフォーマット](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>ユーザー定義型をシリアライズする](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>非侵入型のシリアライズ関数を定義する](#TOC--2)</li><li class='goog-toc'>[<strong>4 </strong>非侵入型のシリアライズ関数で保存と読み込みで違う動作をさせる](#TOC--3)</li></ol>



<h4>サポートされているフォーマット</h4>Boost Serialization Libraryでは、以下のフォーマットへのシリアライズ、デシリアライズをサポートしている。


| | | |
|-------|------------------------------------------------------------------------|----------------|
| フォーマット | インクルード | 補足 |
| バイナリ | <boost/archive/binary_iarchive.hpp> <boost/archive/binary_oarchive.hpp> | プラットフォーム間の互換性なし |
| テキスト | <boost/archive/text_iarchive.hpp> <boost/archive/text_oarchive.hpp> |  |
| XML | <boost/archive/xml_iarchive.hpp> <boost/archive/xml_oarchive.hpp> |  |

<h4>ユーザー定義型をシリアライズする</h4>Boost.Serializationでは、ユーザー定義型に、

- boost::serialization::accessへのfriend指定し、
- serialize()メンバ関数を持たせ、Arhiveにシリアライズするメンバ変数を登録
することで、ユーザー定義型をシリアライズとデシリアライズが可能な型にすることができる。

次に、各フォーマットのアーカイブ型は、コンストラクタでstd::istream or std::ostreamを取る。
std::fstreamを渡すことでファイルに出力、std::stringstreamを渡すことで文字列に出力することができる。
アーカイブに対してシリアライズ可能な型をストリームで渡すことにより、ユーザー定義型をシリアライズ、デシリアライズすることができる。

ここでは、Data型をテキスト形式でシリアライズ、デシリアライズしている。

```cpp
#include <iostream>
#include <fstream>
#include <string>
#include <boost/archive/text_oarchive.hpp>
#include <boost/archive/text_iarchive.hpp>
#include <boost/serialization/serialization.hpp>
#include <boost/serialization/nvp.hpp>
#include <boost/serialization/string.hpp>

namespace boost { void tss_cleanup_implemented() {} }

class Data {
    int value;
    std::string str;
public:
    Data() {}
    Data(int value, const std::string& str)
        : value(value), str(str) {}

    void print()
    {
        std::cout << value << std::endl;
        std::cout << str << std::endl;
    }

private:
    friend class boost::serialization::access;
    template <class Archive>
    void serialize(Archive& ar, unsigned int /*version*/)
    {
        ar & boost::serialization::make_nvp("value", value);
        ar & boost::serialization::make_nvp("str", str);
    }
};

int main()
{
    {
        std::ofstream file("a.txt");
        boost::archive::text_oarchive ar(file);

        Data data(3, "abc");
        ar << boost::serialization::make_nvp("Data", data);
    }
    {
        std::ifstream file("a.txt");

        boost::archive::text_iarchive ar(file);

        Data data;
        ar >> boost::serialization::make_nvp("Data", data);
        
        data.print();
    }
}


出力ファイル a.txt：
```cpp
22 serialization::archive 9 0 0 3 3 abc
```

実行結果(出力ファイルの読込結果)：
```cpp
3
abc
```

boost::serialization::make_nvpのnvpはName Value Pairの略で、値に対して名前を関連付けている。
これは、XML形式のようなアーカイブを使用する際に、要素名として使用される。

ここではboost::archive::text_oarchiveを使用してテキスト形式にシリアライズしているが、これをboost::archive::xml_oarchiveに変えるだけでXML形式にシリアライズされる。

<h4>非侵入型のシリアライズ関数を定義する</h4>既に作成されたクラス、またはサードパーティで用意されているクラスをシリアライズしたい場合がある。
その場合は非侵入型のシリアライズを定義するのが良いだろう。
非侵入型シリアライズは boost::serialization 名前空間にシリアライズしたい型を受け取る serialize 関数を定義することで実現できる。

```cpp
#include <boost/serialization/serialization.hpp>
#include <boost/serialization/nvp.hpp>

struct Data {
    int number;
    double real;
};

namespace boost { namespace serialization {

template<class Archive>
void serialize(Archive & ar, Data & d, unsigned int /* version */) {
    ar & make_nvp("number", d.number);
    ar & make_nvp("real", d.real);
}

} } // namespace boost::serialization
```

当然ながら、非侵入型シリアライズが正しく動作するのは、クラス外部からアクセスできるデータでインスタンスが再構成可能なクラスに限られる。

<h4>非侵入型のシリアライズ関数で保存と読み込みで違う動作をさせる</h4>サードパーティで用意されているクラスをシリアライズする場合、専用の関数などをつかって構築する場合など、serialize 関数だけでは実装しづらい場合がある。
そのため、非侵入型でも save/load 関数に分解して保存時と読み込み時の動作を分ける方法が用意されている。使用するには split_free を用いる。

```cpp
#include <boost/serialization/serialization.hpp>
#include <boost/serialization/split_free.hpp>

struct Data {
    int value;
};

namespace boost { namespace serialization {

template<class Archive>
void serialize(Archive & ar, Data & d, unsigned int version) {
    split_free(ar, d, version);
}

template<class Archive>
void save(Archive & ar, Data const& d, unsigned int /* version */) {
    const int v = d.value ^ 0xFFFFFFFF;
    ar & v;
}

template<class Archive>
void load(Archive & ar, Data & d, unsigned int /* version */) {
    int v;
    ar & v;
    d.value = v ^ 0xFFFFFF;
}

} } // namespace boost::serialization
```
