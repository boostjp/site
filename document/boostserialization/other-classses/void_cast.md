# void_cast
## Motivation
C++は、2つの関連したタイプの間で実行時でポインターをキャストするために、オペレーター`dynamic_cast<T>(U * u)`をもっています。

しかし、これが利用可能なのは、ポリモーフィックな関係にあるクラス間だけです。

つまり、これを使うためには、対象となるクラスが少なくとも1つの仮想関数を持っている必要があります。

ポインターのserializatonをそのようなクラスだけに制限することは、serializationライブラリの適用可能性を制限することにつながります。

## Usage
以下の関数が、void_cast.hppにて定義されています。これらは、`boost::serialization`名前空間で宣言されています。

```cpp
template<class Derived, class Base>
const void_cast_detail::void_caster &
void_cast_register(
    Derived const * derived = NULL,
    Base * const base = NULL
);
```

この関数は、1対の関連したタイプを『登録』します。

これは、`Derived`を`BBB`から直接導出するための情報をグローバルなテーブルに保存します。

この『登録』は、プログラムのどこでも実行することができます。

pre-runtimeにビルドされるテーブルは、プログラムの他のどの場所でも利用できます。

*訳注：他の、とは、pre-runtimeのビルド中は除くという意味であろう*

隣接した`base`/`derived`ペアだけは、登録する必要があります。

```cpp
void_cast_register<A, B>();
void_cast_register<B, C>();
```

を登録すれば、自動的に`A`は`C`にアップキャスト可能になります。逆(`C`から`A`へのダウンキャスト）も同様です。

```cpp
void *
void_upcast(
   extended_type_info const & derived_type,
   extended_type_info const & base_type,
   void * const t 
);
```

```cpp
void *
void_downcast(
   extended_type_info const & derived_type,
   extended_type_info const & base_type,
   void * const t 
);
```

これらの関数は、あるタイプからもう一つのタイプに`void`ポインタをキャストします。

変換元と変換先タイプは、対応する`extended_type_info`レコードを参照することで指定されます。

*訳注：原文は以下の通りだが、definitionはdestinationの誤りと考えて訳している*

> The source and destination types are specified by passing
> references to the corresponding extended_type_info records.

`void_cast_register`で登録されていないタイプ間のキャストは、`boost::archive::archive_exception`例外を投げます。その際の`exception_code`は、`unregistered_cast`となります。

