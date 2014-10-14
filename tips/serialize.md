#シリアライズ
データの保存、ネットワーク通信でのデータの送受信といった場面において、任意の型の特定のフォーマットへのシリアライズ、デシリアライズが必要になることがある。[Boost Serialization Library](http://www.boost.org/doc/libs/release/libs/serialization/doc/index.html)は、標準ライブラリやBoostライブラリのあらゆる型へのシリアライズとデシリアライズと、ユーザー定義型のシリアライズ方法を提供するライブラリである。


##インデックス
- [サポートされているフォーマット](#support-format)
- [ユーザー定義型をシリアライズする](#serialize-user-defined-type)
- [非侵入型のシリアライズ関数を定義する](#non-intrusive)
- [非侵入型のシリアライズ関数で保存と読み込みで違う動作をさせる](#different-bahavior-serialize-deserialize)


## <a name="support-format" href="support-format">サポートされているフォーマット</a>
Boost.Serializationでは、以下のフォーマットへのシリアライズ、デシリアライズをサポートしている。


| フォーマット | インクルード | 補足 |
|----------|------------------------------------------------------------------------|----------------|
| バイナリ | `<boost/archive/binary_iarchive.hpp>`<br/> `<boost/archive/binary_oarchive.hpp>` | プラットフォーム間の互換性なし |
| テキスト | `<boost/archive/text_iarchive.hpp>`<br/> `<boost/archive/text_oarchive.hpp>` |  |
| XML      | `<boost/archive/xml_iarchive.hpp>`<br/> `<boost/archive/xml_oarchive.hpp>` |  |


## <a name="serialize-user-defined-type" href="serialize-user-defined-type">ユーザー定義型をシリアライズする</a>
Boost.Serializationでは、ユーザー定義型に、

- `boost::serialization::access`への`friend`指定を行い、
- `serialize()`メンバ関数を持たせ、`Arhive`にシリアライズするメンバ変数を登録

することで、ユーザー定義型をシリアライズとデシリアライズが可能な型にすることができる。

次に、各フォーマットのアーカイブ型は、コンストラクタで`std::istream`もしくは`std::ostream`を取る。

`std::fstream`を渡すことでファイルに出力、`std::stringstream`を渡すことで文字列に出力することができる。

アーカイブに対してシリアライズ可能な型をストリームで渡すことにより、ユーザー定義型をシリアライズ、デシリアライズすることができる。

ここでは、`Data`型をテキスト形式でシリアライズ、デシリアライズしている。

```cpp
#include <iostream>
#include <fstream>
#include <string>
#include <boost/archive/text_oarchive.hpp>
#include <boost/archive/text_iarchive.hpp>
#include <boost/serialization/serialization.hpp>
#include <boost/serialization/nvp.hpp>
#include <boost/serialization/string.hpp>

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
```

出力ファイル a.txt：
```
22 serialization::archive 9 0 0 3 3 abc
```

実行結果(出力ファイルの読込結果)：
```
3
abc
```

`boost::serialization::make_nvp`の`nvp`はName Value Pairの略で、値に対して名前を関連付けている。

これは、XML形式のようなアーカイブを使用する際に、要素名として使用される。

ここでは`boost::archive::text_oarchive`を使用してテキスト形式にシリアライズしているが、これを`boost::archive::xml_oarchive`に変えるだけでXML形式にシリアライズされる。


## <a name="non-intrusive" href="non-intrusive">非侵入型のシリアライズ関数を定義する</a>
すでに作成されたクラス、またはサードパーティで用意されているクラスをシリアライズしたい場合がある。

その場合は非侵入型のシリアライズを定義するのが良いだろう。

非侵入型シリアライズは `boost::serialization` 名前空間にシリアライズしたい型を受け取る `serialize()` 関数を定義することで実現できる。


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


## <a name="different-bahavior-serialize-deserialize" href="different-bahavior-serialize-deserialize">非侵入型のシリアライズ関数で保存と読み込みで違う動作をさせる</a>
サードパーティで用意されているクラスをシリアライズする場合、専用の関数などをつかって構築する場合など、`serialize()` 関数だけでは実装しにくい場合がある。

そのため、非侵入型でも `save()`/`load()` 関数に分解して保存時と読み込み時の動作を分ける方法が用意されている。使用するには `split_free()` 関数を用いる。

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

