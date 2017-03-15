# extended_type_info

## Motivation
serializationライブラリは、以下の機能を実現するために`type_info`/`typeid()`のような仕組みを必要とします。

- タイプ`T`のポインタが与えられたとき、それが示す真のタイプを見つける。
- 『外部』キーが与えられたとき、どんなタイプのオブジェクトを生成するか決定する。

## The problem with std::type_info

- 主として必要なる関数`std::typeid()`が、すべての環境で利用できるわけではありません。この関数のサポートは、実行時タイピング(RTTI)のサポートに依存します。この関数は、非効率という理由から、存在しないまたは、利用可能にされないかもしれません。
- `std::type_info`は、タイプ名からなる文字列を含みます。これは上記条件2を満たすようです。しかし、この文字列のフォーマットは、コンパイラ、ライブラリ、オペレーティングシステムをまたいで一貫していません。これでは、ポータブルなアーカイブをサポートすることはできません。
- もしタイプ名文字列をなんとかポータブルにすることができたとしても、異なるアプリケーションをまたいで、クラスヘッダが同じ名前空間に含まれるという保証はありません。
- 実際、異なるヘッダを異なる名前空間に置くことは、名前の衝突を避けるための手段です。このように、`namespace::class_name`は、キーとして利用することができないのです。
- 異なるクラスが、異なるtype idメカニズムを使う可能性があります。クラスヘッダはこの情報を含むかもしれません。アプリケーションをまたいでクラスヘッダをインポートしたいならば、異なるtype idシステムをサポートするのが便利です。

## Features
`extended_type_info`は以下の特徴を持つ`std::type_info`の実装です。

- `extended_type_info`の(シリアライズされるタイプごとに1つの)レコードの`set`を構築します。
- タイプに関係する任意の文字列キーを許可します。このキーは、しばしばクラス名となりますが、そうでなければならないということはありません。このキーはGUID(Global Unique IDentifier)と呼ばれます。それはこの宇宙で唯一でなければなりません。一般に、GUIDはヘッダファイルにおいて、アプリケーションをまたいでtypeをマッチさせるのに利用されます。マクロBOOST_CLASS_EXPORTを実行することで、文字列キーをどんな既知のタイプとでも結びつけることができます。これを"exported types"と呼びます。
- type info systemを混ぜることを許します。たとえば、あるクラスがtypeid()を外部のクラス識別しを見つけるために使っおり、別のクラスは使っていないということが許されます。文字列キーが与えられたとき、対応する方が見つけられるように、exported typeはグローバルなテーブルとして管理されます。この仕組みが、基底クラスポインタ経由でシリアライズされるタイプを作るために、serializationライブラリで利用されます。

```cpp
namespace boost {
namespace serialization {

class extended_type_info
{
protected:
    // this class can't be used as is. It's just the
    // common functionality for all type_info replacement
    // systems.  Hence, make these protected
    extended_type_info(
        const unsigned int type_info_key,
        const char * key
    );
    ~extended_type_info();
    void key_register();
    void key_unregister();
public:
    const char * get_key() const;
    bool operator<(const extended_type_info &rhs) const;
    bool operator==(const extended_type_info &rhs) const;
    bool operator!=(const extended_type_info &rhs) const {
        return !(operator==(rhs));
    }
    // for plugins
    virtual void * construct(unsigned int count = 0, ...) const;
    virtual void destroy(void const * const p) const;
    static const extended_type_info * find(const char *key);
};

} // namespace serialization
} // namespace boost
```

通常、それぞれのタイプのために作られる唯一の`extended_type_info`のインスタンスが存在します。しかし、これは実行可能なモジュールレベルだけで実施されます。つまり、プログラムがある種のsharedライブラリやDLLを含むならば、あるタイプに対応する`extended_type_info`のインスタンスが複数存在するかもしれません。この理由により、下記の比較関数では単にインスタンスのアドレスを比較することができません。インスタンス内部の実際の情報を比較する必要があります。

```cpp
extended_type_info(unsigned int type_info_key, const char *key);
```

このコンストラクタは、すべての派生クラスによって呼び出されなければなりません。 第1引数は、特定の実装を示す番号でなければなりません。

*訳注：型の番号ではなく、型システムの実装番号であることに注意*

`typeid()`によるこのデフォルトの実装のための値は1です。

それぞれのシステムは、それ自身を示す整数を持っていなければなりません。 この値は、異なる`typeinfo`システムのインターオペラビリティを実現するのに用いられます。

第2引数は、このレコードが対応づけられる名前を示す`const`文字列です。それはGUIDと呼ばれることがあります。これは、あるプログラムから別のプログラムに、アーカイブ内のユニークに識別するために渡されます。export機能を利用しない場合、この値は`NULL`となるでしょう。

```cpp
void key_register();
void key_unregister();
```

このシステムは、external文字列と`extended_type_info`レコードを関連づけるグローバルなテーブルを管理します。 ベースクラスポインタを経由してシリアライズされたオブジェクトをロードするとき、このテーブルは利用されます。 この場合、アーカイブは新たなオブジェクトを作るために、どの`extended_type_info`を使えばよいのか決定するためにテーブルを検索する際に用いる文字列を含みます。
これらの関数は、このテーブルのエントリを追加したり削除したりするために、`extended_type_info`を実装するクラスのコンストラクタと、デストラクタから呼び出されます。

```cpp
const char *get_key() const;
```

`extended_type_info`からキーを取り出します。

キーがインスタンスと関係しない場合、`NULL`が返ります。

```cpp
bool operator<(const extended_type_info & rhs) const;
bool operator==(const extended_type_info & rhs) const;
bool operator!=(const extended_type_info & rhs) const;
```

これらの関数は、2つの`extended_type_info`オブジェクトを比較するのに用いられます。

それらは、厳密な全順序を`extended_type_info`に要求します。

```cpp
virtual void * construct(unsigned int count = 0, ...) const;
```

この、`extended_type_info`レコードに対応するタイプの新しいインスタンスを作成します。 この関数は、可変引数リストとして最大4つまでの任意の型の引数をとります。 これらの引数は、実行時に、生成する型のコンストラクタに渡されます。 この仕組みを利用するために、コンストラクタのための型シーケンスを宣言せねばなりません。 タイプがexportされたとき、この関数の引数の個数は一致しなければならず、型も一致しなければなりません。

この関数は、`BOOST_CLASS_EXPORT`によって、exportされたGUIDだけから、インスタンスを生成します。 もしこれらのタイプがDLLや共有ライブラリで定義されるならば。

これらのモジュールが実行時にロードされる場合、アンロードされるまでの間、これらのコンストラクタを呼び出すことができます。

これらのモジュールはプラグインと呼ばれます。

```cpp
virtual void destroy(void const * const p) const;
```

上記コンストラクタで生成されたオブジェクトを破棄します。

```cpp
static const extended_type_info * find(const char *key);
```

文字列キーかGUIDを与えると、対応する`extended_type_info`オブジェクトを返します。


## Requirements
serializationライブラリによって利用されるために、`extended_type_info`(ETI)の実装は、`extended_type_info`を継承しなければなりません。さらに、以下を実装しなければなりません。

```cpp
template<class ETI>
const extended_type_info *
ETI::get_derived_extended_type_info(const T & t) const;
```

タイプ`T`の"true type"に対応する`extended_type_info`のインスタンスを返します。"true type"とはクラス継承階層でもっとも下にあるタイプです。 タイプTは常に"true type"に`static `castでキャストすることができます。

この関数の実装は、タイプIDシステムの間で異なることがあります。また、この関数は、特定の`extended_type_info`の実装と同一視可能な型Tを推定します。

*訳注：原文は以下。うまく訳せなかった thanはthatのtypoと考えて訳した↑*

> Implemention of this function will vary among type id systems 
> and sometimes will make presumptions about the type `T` than 
> can be identified with a particular `extended_type_info` 
> implementation.

```cpp
virtual bool ETI::is_less_than(const extended_type_info &rhs) const;
```

このインスタンスと同じ`extended_type_info`の実装を利用して、`rhs`と比較する。

```cpp
virtual bool ETI::is_equal(const extended_type_info &rhs) const;
```

このインスタンスと同じ`extended_type_info`の実装を利用して、`rhs`と比較する。 タイプが同じなら`true`を、そうでなければ`false`を返す。

```cpp
const char ETI::get_key() const;
```

このクラスの外部キー(別名GUID)を返します。

```cpp
virtual void * construct(unsigned int count, ...) const;
```

対応する型のインスタンスを引数リストから構築します。

```cpp
virtual void * destroy(void const * const ptr ) ) const;
```

この型のインスタンスを破棄します。適切なデストラクタを呼び出し、メモリを解放します。


## Models
serializationライブラリは、2つの異なった`extended_type_info`の実装を持っています。

### extended_type_info_typeid
`extended_type_info_typeid`は、標準的な`typeid()`によって実装されます。 コンパイラによって、RTTIサポートが有効になっていることを想定しています。

### extended_type_info_no_rtti
`extended_type_info_no_rtti`は、RTTIの存在に依存しない形で実装されています。

その代わり、すべてのポリモーフィックな型が明示的にexportされることを要求します。 それに加え、exportをベースクラスポインタ経由で行うならば、それらのタイプは以下の

```cpp
virtual const char * get_key();
```

すなわちクラスのもっとも継承されたクラス(Leafクラス)を返すシグニチャをもつ仮想関数を実装することを要求されます。

この関数は、上述の通り`get_derived_extended_type_info`によって必要とされる機能を実装するために仮想でなければなりません。


## Example
テスト・プログラムtest_no_rttiは、クラスに対応するexportキーを返すために、上記の`extended_type_info` APIに関して、この関数を実装します。

これは、非抽象型がエクスポートされることを要求します。

これは、`extended_type_info`の2つの異なる機能の間でとのインターオペラビリティもまた示します。

