#Boost 多次元配列ライブラリ (Boost.MultiArray)

##Synopsis - 概要

Boost 多次元配列ライブラリは，多次元コンテナと，意味的に等価な連続データの配列へのアダプタを提供する。
このライブラリのクラス群は，できるだけ STL コンテナと近い振る舞いをし，また N 次元配列の慣用句 (formulation) である，
いわゆる "ベクタのベクタ" より便利でかつ有効な実装を提供する。
配列はひとたび構築されるとリサイズできないが，保持するデータへの代替ビューを提供することによって，スライス (sliced) されまた形作られ (shaped) 得る。

##Table of Contents - 目次

1. [Rationale](#sec_rationale)
2. [Related Work](#sec_related)
3. [Short Example](#sec_example)
4. [MultiArray Components](#sec_components)
5. [Construction and Assignment](#sec_assignment)
6. [Array View and Subarray Type Generators](#sec_generators)
7. [Specifying Array Dimensions](#sec_dimensions)
8. [Accessing Elements](#sec_access)
9. [Creating Views](#sec_views)
10. [Storage Ordering](#sec_storage)
11. [Setting the Array Base](#sec_base)
12. [Changing an Array's Shape](#sec_reshape)
13. [MultiArray Concept](#sec_concepts)
14. [Test Cases](#sec_testcases)


##<a name="sec_rationale">Rationale - 原論</a>

C++ 標準ライブラリはいくつかのジェネリックなコンテナを提供するが，多次元配列型はない。
`std::vector` を使うと "ネストしたベクタ" として N 次元配列をシミュレートできるが，巧みではなく (unwieldy) またメモリのオーバヘッドがかなりのものになり得る。
ネイティブな C++ 配列 (例えば `int arr[2][2][2];`) を使うこともできるし，連続データの配列を動的に確保し，それを多次元配列のように見なして使うこともできる。
`array_traits` を使えば静的に定義された C++ 配列からその次元に関係なくイテレータを抽出できる。
しかし，両者のケースでは，それらを受け付けるよう正しく特殊化されていない関数に渡すと，次元の情報は失われる。
上記の他，`std::vector` も C++ 配列ベースの解も，多次元配列の特定のサブセットや "ビュー" に研ぐの都合のよい方法 (a convenient method of honing in upon a specific subset or "view" of a multi-dimentional array) を提供しない。

Boost.MultiArray は MultiArray コンセプト (N 次元コンテナのジェネリックなインタフェース) を定義する。
このライブラリの主なコンポーネントは MultiArray をモデル化 (model) し，同様にユーザデータを MultiArray にモデル化できるよう適合することをサポートする。

##<a name="sec_related">Related Work - 関連するモノ</a>

[boost::array](../array.md) と [std::vector](http://www.sgi.com/tech/stl/Vector.html) はユーザデータの 1 次元コンテナである。
両者は自分自身のメモリを管理する。
`std::valarray` は低レベルな C++ 標準ライブラリで，数値アプリケーションに移植制のある高いパフォーマンスを提供することになっている。
[Blitz++](http://www.oonumerics.org/blitz/) は Todd Veldhuizen が開発した配列ライブラリである。
これは配列ベースの数値アプリケーションへ FORTRAN に近いパフォーマンスを提供するために高度な C++ テクニックを使っている。
`array_traits` は Boost のベータ版のライブラリで，ネイティブの C++ 配列からイテレータを作成することになっている。

このライブラリは [boost::array](../array.md) が C の 1 次元配列に対してするように C スタイルの N 次元配列を増加する。
(;´Д｀)? .oＯ(This library is analogous to [boost::array](../array.md) in that it augments C style N-dimensional arrays, as `boost::array` does for C one-dimensional arrays.)

##<a name="sec_example">Short Example - 短いサンプル</a>

下は `multi_array` を使う簡潔なサンプルである:

```cpp
#include "boost/multi_array.hpp"
#include <assert>

int main(){
    // Create a 3D array that is 3 x 4 x 2
    typedef boost::multi_array<double, 3> array_type;
    typedef array_type::index index;
    array_type A(boost::extents[3][4][2]);

  // Assign values to the elements
    int values = 0;
    for(index i = 0; i != 3; ++i) 
        for(index j = 0; j != 4; ++j)
            for(index k = 0; k != 2; ++k)
                A[i][j][k] = values++;

    // Verify values
    int verify = 0;
    for(index i = 0; i != 3; ++i) 
        for(index j = 0; j != 4; ++j)
            for(index k = 0; k != 2; ++k)
                assert(A[i][j][k] == verify++);

    return 0;
}
```

##<a name="sec_components">MultiArray Components</a>

Boost.MultiArray は 3 つのユーザレベルクラステンプレートを提供する:

1. [`multi_array`](http://www.boost.org/doc/libs/1_31_0/libs/multi_array/doc/reference.html#multi_array) - defined in "boost/multi_array.hpp",
2. [`multi_array_ref`](http://www.boost.org/doc/libs/1_31_0/libs/multi_array/doc/reference.html#multi_array_ref) - defined in "boost/multi_array_ref.hpp", and
3. [`const_multi_array_ref`](http://www.boost.org/doc/libs/1_31_0/libs/multi_array/doc/reference.html#const_multi_array_ref)  - defined in "boost/multi_array_ref.hpp"

`multi_array` はコンテナテンプレートである。
インスタンス化されると，構築時に指定された寸法（次元？）に相当する要素の個数分スペースを確保する。

`multi_array_ref` は既存データの配列が `multi_array` インタフェースを提供するよう適合させる。
`multi_array_ref` は渡されたデータを所有しない。

`const_multi_array_ref` は `multi_array_ref` と類似しているが配列の内容が不変であることを保証する。
従って型 `T const*` へのポインタをラップできる。

3 つのコンポーネントはとても類似した振る舞いを示す。
コンストラクタの引数を別にすると，`multi_array` と `multi_array_ref` は同じインタフェースをエクスポートする。
`const_multi_array_ref` は `multi_array_ref` インタフェースの const 部分だけを提供する。

##<a name="sec_assignment">Construction and Assignment - 構築と代入</a>

それぞれの配列型 - [`multi_array`](http://www.boost.org/doc/libs/1_31_0/libs/multi_array/doc/reference.html#multi_array)， [`multi_array_ref`](http://www.boost.org/doc/libs/1_31_0/libs/multi_array/doc/reference.html#multi_array_ref)，そして [`const_multi_array_ref`](http://www.boost.org/doc/libs/1_31_0/libs/multi_array/doc/reference.html#const_multi_array_ref) - はコンストラクタの特殊化された集合を提供する。
さらなる情報はリファレンスページを参照して欲しい。

このライブラリの非 const 配列型は全て代入演算子 `operator=()` を提供する。
それぞれの配列型 `multi_array`，`multi_array_ref`，`subarray`，そして `array_view` はその形 (shape) が合致する限り互いに代入できる。
const バリエーションである `const_multi_array_ref`，`const_subarray`，そして `const_array_view` は形が合致する配列にコピーする元となれる。
代入の結果は配列中に格納されたデータの深い (要素から要素へ) コピーを成す。

##<a name="sec_generators">Array View and Subarray Type Generators - 配列ビューとサブ配列生成子</a>

いくつかの場面で，`array_view` やサブ配列型へのネストした生成子を使うことは都合が悪い。
例えば，配列型でテンプレートパラメータ化した関数の中で余計な "template" キーワードが混乱を引き起こす。
もっと言えば (more likely though)，いくつかのコンパイラは，テンプレートパラメータ中のネストしたテンプレートを扱えない。
この理由により，型生成子 `subarray_gen`，`const_subarray_gen`，`array_view_gen`，そして `const_array_view_gen` が提供される。
従って，以下のサンプルにあるふたつの typedef は同じ型を得る。

```cpp
template <typename Array>
void my_function() {
    typedef typename Array::template array_view<3>::type view1_t;
    typedef typename boost::array_view_gen<Array,3>::type view2_t;
    // ...
}
```

##<a name="sec_dimensions">Specifying Array Dimensions - 配列次元の指定</a>

Boost.MultiArray コンポーネントを作成するとき，次元の数とそれぞれの大きさを指定する必要がある。
次元の数はいつもテンプレート引数として指定されるとしても，それぞれの大きさを指定するのにふたつの独立したメカニズムが提供される。

最初の方法は大きさの [Collection](http://www.boost.org/doc/libs/1_31_0/libs/utility/Collection.html) (最も一般的には `boost::array`)をコンストラクタに渡すことである。
コンストラクタはそのコンテナから介しイテレータを取得し， N 次元の大きさに相当する N 要素を取得する。
この方法は次元非依存のコードを書くときに役立つ。

###Example

```cpp
    typedef boost::multi_array<double, 3> array_type;
    boost::array<array_type::index, 3> shape = {{ 3, 4, 2 }};
    array_type A(shape);
```

二番目の方法はマトリクス次元 (matrix dimentions) を指定した `extent_gen` オブジェクトをコンストラクタに渡すことである。
デフォルトで，ライブラリはグローバルな `extent_gen` オブジェクトを `boost::extents` で構築する。
これらのオブジェクトが使用するメモリを気にするならば，ライブラリのヘッダをインクルードする前に `BOOST_MULTI_ARRAY_NO_GENERATORS` を定義すればこれらの構築を抑止できる。

###Example

```cpp
    typedef boost::multi_array<double, 3> array_type;
    array_type A(boost::extents[3][4][2]);
```

##<a name="sec_access">Accessing Elements - 要素のアクセス</a>

Boost.MultiArray コンポーネントは，コンテナ中の指定した要素をアクセスするのに 2 通りの方法を提供する。
最初は `operator[]` によって提供される伝統的な C 配列の記法を使うことである。

###Example

```cpp
    typedef boost::multi_array<double, 3> array_type;
    array_type A(boost::extents[3][4][2]);
    A[0][0][0] = 3.14;
    assert(A[0][0][0] == 3.14);
```

二番目の方法はインデクスの [Collection](http://www.boost.org/doc/libs/1_31_0/libs/utility/Collection.html) を `operator()` に渡すことである。
N 個のインデクスはコンテナの N 次元ぶん Collection から取得される。

###Example

```cpp
    typedef boost::multi_array<double, 3> array_type;
    array_type A(boost::extents[3][4][2]);
    boost::array<array_type::index,3> idx = {{0,0,0}};
    A(idx) = 3.14;
    assert(A(idx) == 3.14);
```

この方法は次元非依存のコードを書くのに役立ち，いくつかのコンパイラの下では `operator[]` よりも高いパフォーマンスをもたらす。

##<a name="sec_views">Creating Views - ビューの作成</a>

Boost.MultiArray は既存の配列コンポーネントのサブビュー (sub-view) を作成する方法 (facilities) を提供する。
オリジナル配列と同じまたはより少ない次元を保持するサブビューを作成することができる。

サブビューの作成は `index_gen` 型を渡して `operator[]` を呼ぶことで起こる。
`index_gen` は `index_range` オブジェクトを `operator[]` へ渡すことで (populated) 。
`boost::extents` と類似して，デフォルトで，ライブラリは `boost::indices` で構築する。
ライブラリヘッダをインクルードする前に `BOOST_MULTI_ARRAY_NO_GENERATORS` を定義することでこのオブジェクトを抑制できる。
単純なサブビュー作成のサンプルを以下に示す。

###Example

```cpp
    // myarray = 2 x 3 x 4

    //
    // array_view dims: [base,bound) (dimension striding default = 1)
    // dim 0: [0,2)
    // dim 1: [1,3)
    // dim 2: [0,4) (strided by 2),
    //

    typedef array_type::index_range range;
    array_type::array_view<3>::type myview =
        myarray[ boost::indices[range(0,2)][range(1,3)][range(0,4,2)] ];

    for (array_type::index i = 0; i != 2; ++i)
        for (array_type::index j = 0; j != 2; ++j)
            for (array_type::index k = 0; k != 2; ++k)
                assert(myview[i][j][k] == myarray[i][j+1][k*2]);
```

ひとつの整数値を `index_gen` へ渡すことで，オリジナルの配列コンポーネントより少ない次元でビューを作成できる(これはスライシング (slicing) とも呼ばれる)。

###Example

```cpp
    // myarray = 2 x 3 x 4

    //
    // array_view dims:
    // [base,stride,bound)
    // [0,1,2), 1, [0,2,4)
    //

    typedef array_type::index_range range;
    array_type::index_gen indices;
    array_type::array_view<2>::type myview =
        myarray[ indices[range(0,2)][1][range(0,4,2)] ];

    for (array_type::index i = 0; i != 2; ++i)
        for (array_type::index j = 0; j != 2; ++j)
            assert(myview[i][j] == myarray[i][1][j*2]);
```

###More on `index_range` - もっと `index_range`

`index_range` 型はサブビュー生成の範囲を指定する様々な方法を提供する。
ここでは同じ範囲を指定するいくつかの範囲インスタンス化を示す。

###Example

```cpp
    // [base,stride,bound)
    // [0,2,4)

    typedef array_type::index_range range;
    range a_range;
    a_range = range(0,4,2);
    a_range = range().start(0).finish(4).stride(2);
    a_range = range().start(0).stride(2).finish(4);
    a_range = 0 <= range().stride(2) < 4;
    a_range = 0 <= range().stride(2) <= 3;
```

スライス操作へ渡された `index_range` オブジェクトは，供給されなかった開始(かつ/または)終端値をその配列から継承する。
これは都合よく，あるケースで配列長の境界を知る必要があることから防ぐ。
例えば，デフォルトコンストラクトされた range は，使用する際に指定された次元の全範囲に適用される。

###Example

```cpp
    typedef array_type::index_range range;
    range a_range;

    // All elements in this dimension
    a_range = range();

    // indices i where 3 <= i
    a_range = range().start(3)
    a_range = 3 <= range();
    a_range = 2 < range();

    // indices i where i < 7
    a_range = range().finish(7)
    a_range = range() < 7;
    a_range = range() <= 6;
```

以下のサンプルは上で示したもののいくつかの代替表現を示す。

```cpp
    // take all of dimension 1
    // take i < 5 for dimension 2
    // take 4 <= j <= 7 for dimension 3 with stride 2
    myarray[ boost::indices[range()][range() < 5 ][4 <= range().stride(2) <= 7] ];
```

##<a name="sec_storage">Storage Ordering - 記憶域の順序</a>

それぞれの配列クラスは，記憶域の順序を示すパラメータを受け付ける。
これは，FORTRAN のような，標準 C と違う順序を要求するレガシーコードとの橋渡しをする際に役立つ。
可能な値は `c_storage_order`，`fortran_storage_order`，そして `general_storage_order` である。

`c_storage_order` はデフォルトであり，要素を C 配列と同じ順序，すなわち最後の次元からから最初の次元の順番で，メモリに格納する。

`fortran_storage_order` は要素を FORTRAN と同じ順序，すなわち最初の次元から最後の次元の順番で，メモリに格納する。
このパラメータの使用で注意すべきは，配列インデクスは相変わらず 0 ベースであることである。

###Example

```cpp
    typedef boost::multi_array<double,3> array_type;
    array_type A(boost::extents[3][4][2],boost::fortran_storage_order); 
    call_fortran_function(A.data());
```

`general_storage_order` はどのような順序で次元がメモリに格納されるか，また昇順でまたは降順で次元が格納されるかをカスタマイズ可能にする。

###Example

```cpp
  typedef boost::general_storage_order<3> storage;
  typedef boost::multi_array<int,3> array_type;

  // Store last dimension, then first, then middle
  array_type::size_type ordering[] = {2,0,1};

  // Store the first dimension(dimension 0) in descending order
  bool ascending[] = {false,true,true};

  array_type A(extents[3][4][2],storage(ordering,ascending));
```

##<a name="sec_base">Setting The Array Base - 配列起点の設定</a>

いくつかの状況で，0 ベースの配列は不都合で扱いにくい。
Boost.MultiArray コンポーネントは，配列の起点を変更するふたつの方法を提供する。
ひとつは，起点を設定するために範囲値のペアを `extent_gen` コンストラクタへ渡すことである。

###Example

```cpp
    typedef boost::multi_array<double, 3> array_type;
    typedef array_type::extent_range range;

    array_type::extent_gen extents;

    // dimension 0: 0-based
    // dimension 1: 1-based
    // dimension 2: -1 - based
    array_type A(extents[2][range(1,4)][range(-1,3)]);
```

代替の方法は，まず普通に配列を構築してから，起点を再設定することである。
全ての起点に同じ値を設定するには，新しいインデクス値を渡して `reindex` メンバ関数を使う。

###Example

```cpp
  typedef boost::multi_array<double, 3> array_type;
  typedef array_type::extent_range range;

  array_type::extent_gen extents;

  array_type A(extents[2][3][4]);
  // change to 1-based
  A.reindex(1)
```

もしくは，インデクス起点の Collection を `reindex` メンバ関数に渡すこと各々の起点を別々に設定する。

###Example

```cpp
    typedef boost::multi_array<double, 3> array_type;
    typedef array_type::extent_range range;

    array_type::extent_gen extents;

    // dimension 0: 0-based
    // dimension 1: 1-based
    // dimension 2: (-1)-based
    array_type A(extents[2][3][4]);
    boost::array<array_type::index,ndims> bases = {{0, 1, -1}};
    A.reindex(bases);
```

##<a name="sec_reshape">Changing an Array's Shape - 配列形の変更</a>

Boost.MultiArray は配列形を変更する操作を提供する。
次元の数が同じでなければならない，要素の総数を保持する限り，配列形は変更され得る。

###Example

```cpp
  typedef boost::multi_array<double, 3> array_type;
  typedef array_type::extent_range range;

  array_type::extent_gen extents;
  array_type A(extents[2][3][4]);
  boost::array<array_type::index,ndims> dims = {{4, 3, 2}};
  A.reshape(dims);
```

配列の再成形はインデクス付けに影響を与えないことに注意すること。

##<a name="sec_concepts">MultiArray Concept - MultiArray コンセプト</a>

Boost.MultiArray は [MultiArray](http://www.boost.org/doc/libs/1_31_0/libs/multi_array/doc/reference.html#MultiArray) コンセプトを定義し，使用する。
これは N 次元コンテナのインタフェースを指定する。

##<a name="sec_testcases">Test Cases - テストケース</a>

Boost.MultiArray には，同ライブラリの機能とセマンティクスを学習できるテストケースが一揃い付属する。
このテストケースの記述は[ここ](http://www.boost.org/doc/libs/1_31_0/libs/multi_array/doc/test_cases.html)ある。

##Credits
- [Ronald Garcia](mailto:garcia@osl.iu.edu) は，このライブラリの最初の作者である。
- [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm) は，このライブラリを助け，またアイデア，アドバイス，そして Microsoft Visual C++ に移植する手助けのための (sounding board) を提供した。
- [Giovanni Bavestrelli](mailto:gbavestrelli@yahoo.com) は，[Boost](http://www.boost.org/) メーリングリストのメンバから，N 次元配列の初期の実装に対するすばらしいフィードバックを提供した。
  この仕事におけるいくつかのデザインの決定は，この実装や引き出されたコメントに基づく。
- [Todd Veldhuizen](mailto:tveldhui@acm.org) は，このデザインのいくつかの側面に影響を与えた [Blitz++](http://oonumerics.org/blitz/) を書いた。
  更に，彼はこのライブラリの実装やデザインにフィードバックをもたらした。
- [Jeremiah Willcock](mailto:jewillco@osl.iu.edu) は，このライブラリの実装やデザインにフィードバックをもたらしたし，機能に対するいくつかの提案を行った。
- [Beman Dawes](mailto:bdawes@acm.org) は，このライブラリを Microsoft Windows コンパイラに移植するための，計り知れない援助をくれた。

[Ronald Garcia](mailto:garcia@.cs.indiana.edu)
Last modified: Tue Sep 10 11:14:15 EST 2002

翻訳: Tietew with BDT project<br>$Id $

Copyright (c) Ronald Garcia, Jeremy Siek 2001

Permission to use, copy, modify, distribute and sell this software and its documentation for any purpose is hereby granted without fee, provided that the above copyright notice appears in all copies and that both that copyright notice and this permission notice appear in supporting documentation.
Jeremy Siek makes no representations about the suitability of this software for any purpose.
It is provided "as is" without express or implied warranty.

