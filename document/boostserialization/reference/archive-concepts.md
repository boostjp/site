#Archive Concepts
##Notaion

- `SA`はSaving Archive Conceptのモデルである
- `sa`は`SA`のインスタンスである
- `LA`はLoading Archive Conceptのモデルである
- `la`は`LA`のインスタンスである
- `T`はシリアライズ可能な型である
- `x`は`T`型のインスタンスである
- `u`,`v`は`T`型のインスタンスへのポインタである
- `count`は、`std::size_t`に変換可能な型のインスタンスである

##Saving Archive Concept
###Associated Types

直感的に、このモデル概念はC++のデータ構造のセットに対応するバイトシーケンスを生成します。

セーブする概念(SA)と、ロードする概念(LA)は、対応します。

これらはそれぞれ逆の働きをします。

つまり、SAによって生成されたバイト列を与えると、LAは、元のC++データ構造の等価物を生成します。

###Valid Expressions

```
SA::is_saving
```
boost mplの整数定数型 `boost::mpl::bool_<true>`を返します。

```
SA::is_loading
```

boost mplの整数定数型 `boost::mpl::bool_<false>`を返します。

```
sa << x
sa & x
```

これらの式は、正確に同じ機能を果たさねばなりません。これらは、他の情報とともに`x`の値を、`sa`に追加します。他の情報はアーカイブの実装によって定義されます。この情報は、`sa`に対応する`la`のアーカイブタイプによって正しく`x`を復元するのに必要です。

`sa`の参照を返します。

```
sa.save_binary(u, count)
```

`u`から`size_t(count)`バイト分の内容をアーカイブに追加します。

```
sa.register_type<T>() sa.register_type(u)
```

クラス`T`に関する情報をアーカイブに追加します。この情報は、派生クラスのポインタが対応するアーカイブタイプによってロードされるときに、正しいクラスを構築するのに利用されます。このメンバ関数の実行は、クラス登録と呼ばれます。これに関しては、[Special Considerations](./special-considerations.md)のDerivedPointersにて詳細に説明します。`sa`がテンプレートパラメタである場合、規格を満たさないコンパイラが、この機能を呼び出せるように2番目の構文が用意されています。詳細は、テンプレート実施構文を見てください。

