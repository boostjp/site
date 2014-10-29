#型特性
[Boost Type Traits Library](http://www.boost.org/doc/libs/release/libs/type_traits/doc/html/index.html)では、型がどういった特徴を持っているかを判定するメタ関数が多く提供されている。


##インデックス
- [型の分類](#type-category)
    - [配列型かどうかを判定する](#is-array)
    - [クラスかどうかを判定する](#is-class)
    - [`std::complex`型かどうかを判定する](#is-complex)
    - [`enum`型かどうかを判定する](#is-enum)
    - [浮動小数点数型かどうかを判定する](#is-floating-point)
    - [関数型かどうかを判定する](#is-function)
    - [整数型かどうかを判定する](#is-integral)
    - [メンバ関数ポインタかどうかを判定する](#is-member-function)
    - [メンバ変数ポインタかどうかを判定する](#is-member-object)
    - [ポインタかどうかを判定する](#is-pointer)
    - [左辺値参照かどうかを判定する](#is-lvalue-reference)
    - [右辺値参照かどうかを判定する](#is-rvalue-reference)
    - [共用体かどうかを判定する](#is-union)
    - [`void`かどうかを判定する](#is-void)
    - [算術型かどうかを判定する](#is-arithmetic)
    - [複合型かどうかを判定する](#is-compound)
    - [基本型かどうかを判定する](#is-fundamental)
    - [メンバポインタかどうかを判定する](#is-member-pointer)
    - [オブジェクト型かどうかを判定する](#is-object)
    - [参照型かどうかを判定する](#is-reference)
    - [スカラ型かどうかを判定する](#is-scalar)
- [型の性質](#general-type-properties)
    - [アライメントを取得する](#alignment-of)
    - [`new`演算子を持っている型かどうかを判定する](#has-new-operator)
    - [例外を投げない代入演算子を持っている型かどうかを判定する](#has-nothrow-assign)
    - [例外を投げないコンストラクタを持っている型かどうかを判定する](#has-nothrow-constructor)
    - [例外を投げないコピーコンストラクタを持っている型かどうかを判定する](#has-nothrow-copy-constructor)
    - [自明な代入演算子を持っている型かどうかを判定する](#has-trivial-assign)
    - [自明なコンストラクタを持っている型かどうかを判定する](#has-trivial-constructor)
    - [自明なコピーコンストラクタを持っている型かどうかを判定する](#has-trivial-copy-constructor)
    - [自明なデストラクタを持っている型かどうかを判定する](#has-trivial-destructor)
    - [仮想デストラクタを持っている型かどうかを判定する](#has-virtual-destructor)
    - [抽象型かどうかを判定する](#is-abstract)
    - [`const`修飾された型かどうかを判定する](#is-const)
    - [空クラスかどうかを判定する](#is-empty)
    - [`stateless`型かどうかを判定する](#is-stateless)
    - [POD型かどうかを判定する](#is-pod)
    - [多相的に振る舞う型かどうかを判定する](#is-polymorphic)
    - [符号付き整数型かどうかを判定する](#is-signed)
    - [符号なし整数型かどうかを判定する](#is-unsigned)
    - [`volatile`修飾された型かどうかを判定する](#is-volatile)
    - [配列のN次元目の要素数を取得する](#extent)
    - [配列の次元数を取得する](#rank)
- [2つの型の関係性](#relationships-between-two-types)
    - [継承関係にある型かどうかを判定する](#is-base-of)
    - [仮想継承の関係にある型かどうかを判定する](#is-virtual-base-of)
    - [変換可能な型かどうかを判定する](#is-convertible)
    - [2つの型が同じかを判定する](#is-same)
- [型の変換する](#transform-type-to-another)
    - [`const`修飾を付加する](#add-const)
    - [`volatile`修飾を付加する](#add-volatile)
    - [`const volatile`修飾を付加する](#add-cv)
    - [左辺値参照を付加する](#add-lvalue-reference)
    - [右辺値参照を付加する](#add-rvalue-reference)
    - [参照を付加する](#add-reference)
    - [ポインタを付加する](#add-pointer)
    - [条件によって型を選択する](#conditional)
    - [共通の型を取得する](#common-type)
    - [推論される型の取得する](#decay)
    - [浮動小数点数型を昇格する](#floating-point-promotion)
    - [整数型を昇格する](#integral-promotion)
    - [型を昇格する](#promote)
    - [符号なし型から符号あり型に変換する](#make-signed)
    - [符号あり型から符号なし型に変換する](#make-unsigned)
    - [配列の次元を削除する](#remove-extent)
    - [配列の次元を全て削除する](#remove-all-extents)
    - [`const`修飾を削除する](#remove-const)
    - [`volatile`修飾を削除する](#remove-volatile)
    - [`const volatile`修飾を削除する](#remove-cv)
    - [ポインタを削除する](#remove-pointer)
    - [参照を削除する](#remove-reference)
- [特定アライメントを持った型の合成](#synthesizing-types-with-specific-alignments)
    - [特定のアライメントを持つ型の取得する](#type-with-alignment)
    - [適切にアライメントされた型を作成する](#aligned-storage)


### <a name="type-category" href="type-category">型の分類を判定する</a>
### <a name="is-array" href="is-array">配列型かどうかを判定する</a>
`boost::is_array<T>`メタ関数を使用する。


インクルード：

- `<boost/type_traits/is_array.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
is_array<int[2]>::value == true
is_array<char[2][3]>::type == true
is_array<double[]>::value == true
```


### <a name="is-class" href="is-class">クラスかどうかを判定する</a>
`boost::is_class<T>`メタ関数を使用する。


インクルード：

- `<boost/type_traits/is_class.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
class MyClass;

is_class<MyClass>::value == true
is_class<MyClass const>::value == true
is_class<MyClass&>::value == false
is_class<MyClass*>::value == false
```


### <a name="is-complex" href="is-complex">std::complex型かどうかを判定する</a>
`boost::is_complex<T>`メタ関数を使用する。


インクルード：
- `<boost/type_traits/is_complex.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
is_complex<std::complex<T> >::value == true
```


### <a name="is-enum" href="is-enum">`enum`型かどうかを判定する</a>
`boost::is_enum<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/is_enum.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
enum my_enum { one, two };

is_enum<my_enum>::value == true
is_enum<my_enum const>::type == true
is_enum<my_enum&>::value == false
is_enum<my_enum*>::value == false
```


### <a name="is-floating-point" href="is-floating-point">浮動小数点数型かどうかを判定する</a>
`boost::is_floating_point<T>`メタ関数を使用する。


インクルード：

- `<boost/type_traits/is_floating_point.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
is_floating_point<float>::value == true
is_floating_point<double>::value == true
is_floating_point<long double>::value == true
```


### <a name="is-function" href="is-function">関数型かどうかを判定する</a>
`boost::is_function<T>`メタ関数を使用する。


インクルード：

- `<boost/type_traits/is_function.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
is_function<int (void)>::value == true
is_function<long (double, int)>::value == true

is_function<long (*)(double, int)>::value == false // 関数型ではなく関数へのポインタ
is_function<long (&)(double, int)>::value == false // 関数型ではなく関数への参照

is_function<long (MyClass::*)(double, int)>::value == false // メンバ関数へのポインタ
```


### <a name="is-integral" href="is-integral">整数型かどうかを判定する</a>
`boost::is_integral<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/is_integral.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
is_integral<int>::value == true
is_integral<const char>::value == true
is_integral<long>::value == true
```


### <a name="is-member-function" href="is-member-function">メンバ関数ポインタかどうかを判定する</a>
`boost::is_member_function<T>`メタ関数を使用する。


インクルード：

- `<boost/type_traits/is_member_function.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
is_member_function_pointer<int (MyClass::*)(void)>::value == true
is_member_function_pointer<int (MyClass::*)(char)>::value == true
is_member_function_pointer<int (MyClass::*)(void)const>::value == true
is_member_function_pointer<int (MyClass::*)>::value == false // データメンバへのポインタ
```


### <a name="is-member-object" href="is-member-object">メンバ変数ポインタかどうかを判定する</a>
`boost::is_member_object<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/is_member_object.hpp>`
- `<boost/type_traits.hpp>`


例：
```cpp
is_member_object_pointer<int (MyClass::*)>::value == true
is_member_object_pointer<double (MyClass::*)>::value == true
is_member_object_pointer<const int (MyClass::*)>::value == true
is_member_object_pointer<int (MyClass::*)(void)>::value == false // メンバ関数ポインタ
```


### <a name="is-pointer" href="is-pointer">ポインタかどうかを判定する</a>
`boost::is_pointer<T>`メタ関数を使用する。


インクルード：

- `<boost/type_traits/is_pointer.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
is_pointer<int*>::value == true
is_pointer<char* const>::type == true
is_pointer<int (*)(long)>::value == true
is_pointer<int (MyClass::*)(long)>::value == false
is_pointer<int (MyClass::*)>::value == false
```


### <a name="is-lvalue-reference" href="is-lvalue-reference">左辺値参照かどうかを判定する</a>
`boost::is_lvalue_reference<T>`メタ関数を使用する。


インクルード：

- `<boost/type_traits/is_lvalue_reference.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
is_lvalue_reference<int&>::value == true
is_lvalue_reference<int const&>::value == true
is_lvalue_reference<int const&&>::value == false
is_lvalue_reference<int (&)(long)>::value == true
```


### <a name="is-rvalue-reference" href="is-rvalue-reference">右辺値参照かどうかを判定する</a>
`boost::is_rvalue_reference<T>`メタ関数を使用する。


インクルード：
- `<boost/type_traits/is_rvalue_reference.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
is_rvalue_reference<int&&>::value == true
is_rvalue_reference<int const&&>::value == true
is_rvalue_reference<int const&>::value == false
is_rvalue_reference<int (&&)(long)>::value == true
```


### <a name="is-union" href="is-union">共用体かどうかを判定する</a>
`boost::is_union<T>`メタ関数を使用する。


インクルード：

- `<boost/type_traits/is_union.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
is_union<void>::value == true
is_union<const void>::value == true
is_union<void*>::value == false
```


### <a name="is-void" href="is-void">voidかどうかを判定する</a>
`boost::is_void<T>`メタ関数を使用する。


インクルード：

- `<boost/type_traits/is_void.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
is_void<void>::value == true
is_void<const void>::value == true
is_void<void*>::value == false
```


### <a name="is-arithmetic" href="is-arithmetic">算術型かどうかを判定する</a>
`boost::is_arithmetic<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/is_arithmetic.hpp>`
- `<boost/type_traits.hpp>`

算術型は以下を含む：

- [整数型(`is_integral`)](#is-integral)
- [浮動小数点数型(`is_floating_point`)](#is-floating-point)

例：
```cpp
is_arithmetic<int>::value == true
is_arithmetic<char>::value == true
is_arithmetic<double>::value == true
```


### <a name="is-compound" href="is-compound">複合型かどうかを判定する</a>
`boost::is_compound<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/is_compound.hpp>`
- `<boost/type_traits.hpp>`

複合型は、[基本型(`is_fundamental`)](#is-fundamental)以外の型である。

例：
```cpp
is_compound<MyClass>::value == true
is_compound<MyEnum>::value == true
is_compound<int*>::value == true
is_compound<int&>::value == true
is_compound<int>::value == false
```


### <a name="is-fundamental" href="is-fundamental">基本型かどうかを判定する</a>
`boost::is_fundamental<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/is_fundamental.hpp>`
- `<boost/type_traits.hpp>`

基本型は以下を含む：

- [整数型(`is_integral`)](#is-integral)
- [浮動小数点数型(`is_floating_point`)](#is-floating-point)
- [`void`型(`is_void`)](#is-void)

例：
```cpp
is_fundamental<int)>::value == true
is_fundamental<double const>::value == true
is_fundamental<void>::value == true
```


### <a name="is-member-pointer" href="is-member-pointer">メンバポインタかどうかの判定</a>
`boost::is_member_pointer<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/is_member_pointer.hpp>`
- `<boost/type_traits.hpp>`

メンバポインタは以下を含む：

- [メンバ関数ポインタ(`is_member_function`)](#is-member-function)
- [メンバ変数ポインタ(`is_member_object`)](#is-member-object)


例：
```cpp
is_member_pointer<int (MyClass::*)>::value == true
is_member_pointer<int (MyClass::*)(char)>::value == true
is_member_pointer<int (MyClass::*)(void)const>::value == true
```


### <a name="is-object" href="is-object">オブジェクト型かどうかを判定する</a>
`boost::is_object<T>`メタ関数を使用する。

インクルード：
- `<boost/type_traits/is_object.hpp>`
- `<boost/type_traits.hpp>`

オブジェクト型は、参照、`void`、関数型以外の型である。

例：
```cpp
is_object<int>::value == true
is_object<int*>::value == true
is_object<int (*)(void)>::value == true
is_object<int (MyClass::*)(void)const>::value == true
is_object<int &>::value == false // 参照型はオブジェクトではない
is_object<int (double)>::value == false // 参照型はオブジェクトではない
is_object<const void>::value == false // void型はオブジェクトではない
```


### <a name="is-reference" href="is-reference">参照型かどうかを判定する</a>
`boost::is_referece<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/is_reference.hpp>`
- `<boost/type_traits.hpp>`

参照型は、左辺値参照と右辺値参照を含む型である。

例：
```cpp
is_reference<int&>:: == true
is_reference<int const&>::value == true
is_reference<int const&&>::value == true
is_reference<int (&)(long)>::value == true // 関数への参照
```

### <a name="is-scalar" href="is-scalar">スカラ型かどうかを判定する</a>
`boost::is_scalar<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/is_scalar.hpp>`
- `<boost/type_traits.hpp>`

スカラ型は以下を含む：

- [整数型(`is_integral`)](#is-integral)
- [浮動小数点数型(`is_floating_point`)](#is-floating-point)
- [列挙型(`is_enum`)](#is-enum)
- [ポインタ型(`is_pointer`)](#is-pointer)
- [メンバポインタ型(`is_member_pointer`)](#is-member-pointer)


例：
```cpp
is_scalar<int*>::value == true
is_scalar<int>::value == true
is_scalar<double>::value == true
is_scalar<int (*)(long)>::value == true
is_scalar<int (MyClass::*)(long)>::value == true
is_scalar<int (MyClass::*)>::value == true
```


## <a name="general-type-properties" href="general-type-properties">型の性質</a>

### <a name="alignment-of" href="alignment-of">アライメントを取得する</a>
`boost::alignment_of<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/alignment_of.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
const std::size_t a = alignment_of<int>::value;
```


### <a name="has-new-operator" href="has-new-operator">new演算子を持っている型かどうかを判定する</a>
`boost::has_new_operator<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/has_new_operator.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
class A { void* operator new(std::size_t); };
class B { void* operator new(std::size_t, const std::nothrow&); };
class C { void* operator new(std::size_t, void*); };
class D { void* operator new[](std::size_t); };
class E { void* operator new[](std::size_t, const std::nothrow&); };
class F { void* operator new[](std::size_t, void*); };

has_new_operator<A>::value == true
has_new_operator<B>::value == true
has_new_operator<C>::value == true
has_new_operator<D>::value == true
has_new_operator<E>::value == true
has_new_operator<F>::value == true
```


### <a name="has-nothrow-assign" href="has-nothrow-assign">例外を投げない代入演算子を持っている型かどうかを判定する</a>
`boost::has_nothrow_assign<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/has_nothrow_assign.hpp>`
- `<boost/type_traits.hpp>`


### <a name="has-nothrow-constructor" href="has-nothrow-constructor">例外を投げないコンストラクタを持っている型かどうかを判定する</a>
`boost::has_nothrow_constructor<T>`もしくは`boost::has_nothrow_default_constructor<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/has_nothrow_constructor.hpp>`
- `<boost/type_traits.hpp>`


### <a name="has-nothrow-copy-constructor" href="has-nothrow-copy-constructor">例外を投げないコピーコンストラクタを持っている型かどうかを判定する</a>
`boost::has_nothrow_copy<T>`もしくは`boost::has_nothrow_copy_constructor<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/has_nothrow_copy.hpp>`
- `<boost/type_traits/has_nothrow_copy_constructor.hpp>`
- `<boost/type_traits.hpp>`


### <a name="has-trivial-assign" href="has-trivial-assign">自明な代入演算子を持っている型かどうかを判定する</a>
`boost::has_trivial_assign<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/has_trivial_assign.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
has_trivial_assign<int>::value == true
has_trivial_assign<char*>::value == true
has_trivial_assign<int (*)(long)>::value == true
has_trivial_assign<MyClass>::value == false
```

### <a name="has-trivial-constructor" href="has-trivial-constructor">自明なコンストラクタを持っている型かどうかを判定する</a>
`boost::has_trivial_constructor<T>`もしくは`boost::has_trivial_default_constructor<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/has_trivial_constructor.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
has_trivial_constructor<int>::value == true
has_trivial_constructor<char*>::value == true
has_trivial_constructor<int (*)(long)>::value == true
has_trivial_constructor<MyClass>::value == false
```


### <a name="has-trivial-copy-constructor" href="has-trivial-copy-constructor">自明なコピーコンストラクタを持っている型か判定する</a>
`boost::has_trivial_copy<T>`もしくは`boost::has_trivial_copy_constructor<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/has_trivial_copy.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
has_trivial_copy<int>::value == true
has_trivial_copy<char*>::value == true
has_trivial_copy<int (*)(long)>::value == true
has_trivial_copy<MyClass>::value == false
```


### <a name="has-trivial-destructor" href="has-trivial-destructor">自明なデストラクタを持っている型かどうかを判定する</a>
`boost::has_trivial_destructor<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/has_trivial_destructor.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
has_trivial_destructor<int>::value == true
has_trivial_destructor<char*>::value == true
has_trivial_destructor<int (*)(long)>::value == true
has_trivial_destructor<MyClass>::value == false
```


### <a name="has-virtual-destructor" href="has-virtual-destructor">仮想デストラクタを持っている型かどうかを判定する</a>
`boost::has_virtual_destructor<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/has_virtual_destructor.hpp>`
- `<boost/type_traits.hpp>`


### <a name="is-abstract" href="is-abstract">抽象型かどうかを判定する</a>
`boost::is_abstract<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/is_abstract.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
class abc{ virtual ~abc() = 0; }; 

is_abstract<abc>::value == true
is_abstract<abc const>::value == true
```


### <a name="is-const" href="is-const">const修飾された型かどうかを判定する</a>
`boost::is_const<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/is_const.hpp>`
- `<boost/type_traits.hpp>@

例：
```cpp
is_const<int const>::value == true
is_const<int const volatile>::value == true
is_const<int* const>::value == true
is_const<int const*>::value == false
is_const<int const&>::value == false
is_const<int>::value == false
```


### <a name="is-empty" href="is-empty">空クラスかどうかを判定する</a>
`boost::is_empty<T>`メタ関数を使用する。

継承してもサイズが増えない型なら`true`。

インクルード：

- `<boost/type_traits/is_empty.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
struct empty_class {}; 

is_empty<empty_class>::value == true
is_empty<empty_class const>::value == true
is_empty<empty_class>::value == true
```


### <a name="is-stateless" href="is-stateless">stateless型かどうかを判定する</a>
`boost::is_stateless<T>`メタ関数を使用する。

ストレージを持たず、コンストラクタとデストラクタが自明な型なら`true`。

インクルード：

- `<boost/type_traits/is_stateless.hpp>`
- `<boost/type_traits.hpp>`


### <a name="is-pod" href="is-pod">POD型かどうかを判定する</a>
`boost::is_pod<T>`メタ関数を使用する。

インクルード：

- `<boost/type_traits/is_pod.hpp>`
- `<boost/type_traits.hpp>`


例：
```cpp
is_pod<int>::value == true
is_pod<char*>::value == true
is_pod<int (*)(long)>::value == true
is_pod<MyClass>::value == false
```

### <a name="is-polymorphic" href="is-polymorphic">多相的に振る舞う型かどうかを判定する</a>
`boost::is_polymorphic<T>`メタ関数を使用する。

インクルード：

- `boost/type_traits/is_polymorphic.hpp`
- `boost/type_traits.hpp`

例：
```cpp
class poly{ virtual ~poly(); };

is_polymorphic<poly>::value == true
is_polymorphic<poly const>::value == true
is_polymorphic<poly>::value == true
```


### <a name="is-signed" href="is-signed">符号付き整数型かどうかを判定する</a>
`boost::is_signed<T>`メタ関数を使用する。

インクルード：

- `boost/type_traits/is_signed.hpp`
- `boost/type_traits.hpp`

例：
```cpp
is_signed<int>::value == true
is_signed<int const volatile>::value == true
is_signed<unsigned int>::value == false
is_signed<myclass>::value == false
is_signed<char>::valueは、charの符号性質に依存する
is_signed<long long>::value == true
```


### <a name="is-unsigned" href="is-unsigned">符号なし整数型かどうかを判定する</a>
`boost::is_unsigned<T>`メタ関数を使用する。

インクルード：

- `boost/type_traits/is_unsigned.hpp`
- `boost/type_traits.hpp`

例：
```cpp
is_unsigned<unsigned int>::value == true
is_unsigned<unsigned int const volatile>::value == true
is_unsigned<int>::value == false
is_unsigned<myclass>::value == false
is_unsigned<char>::valueは、charの符号性質に依存する
is_unsigned<unsigned long long>::value == true
```


### <a name="is-volatile" href="is-volatile">volatile修飾された型かどうかを判定する</a>
`boost::is_volatile<T>`メタ関数を使用する。

インクルード：

- `boost/type_traits/is_volatile.hpp`
- `boost/type_traits.hpp`

例：
```cpp
is_volatile<volatile int>::value == true
is_volatile<const volatile int>::value == true
is_volatile<int* volatile>::value == true
is_volatile<int volatile*>::value == false
```


### <a name="extent" href="extent">配列のN次元目の要素数を取得する</a>
`boost::extent<T>`もしくは`boost::extent<T, N>`メタ関数を使用する。

インクルード：

- `boost/type_traits/extent.hpp`
- `boost/type_traits.hpp`

例：
```cpp
extent<int[1]>::value == 1
extent<double[2][3][4], 0>::value == 2
extent<double[2][3][4], 1>::value
extent<double[2][3][4], 3>::value == 4
extent<int[][2]>::value == 0
extent<int[][2], 1>::value == 2
extent<int*>::value == 0
extent<boost::array<int, 3> >::value == 0
```


### <a name="rank" href="rank">配列の次元数を取得する</a>
`boost::rank<T>`メタ関数を使用する。

インクルード：

- `boost/type_traits/rank.hpp`
- `boost/type_traits.hpp`

例：
```cpp
rank<int[]>::value == 1
rank<double[2][3][4]>::value == 3
rank<int[1]>::value == 1
rank<int[][2]>::value == 2
rank<int*>::value == 0
rank<boost::array<int, 3> >::value == 0
```


## <a name="relationships-between-two-types" href="relationships-between-two-types">2つの型の関係性</a>
### <a name="is-base-of" href="is-base-of">継承関係にある型かどうかを判定する</a>
`boost::is_base_of<Base, Derived>`メタ関数を使用する。

インクルード：

- `boost/type_traits/is_base_of.hpp`
- `boost/type_traits.hpp`

例：
```cpp
class Base{};
class Derived : public Base{}; 

is_base_of<Base, Derived>::value == true
is_base_of<Base, Base>::value == true
```


### <a name="is-virtual-base-of" href="is-virtual-base-of">仮想継承の関係にある型かどうかを判定する</a>
`boost::is_virtual_base_of<Base, Derived>`メタ関数を使用する。

インクルード：

- `boost/type_traits/is_virtual_base_of.hpp`
- `boost/type_traits.hpp`

例：
```cpp
class Base{};
class Derived : public virtual Base{}; 

is_virtual_base_of<Base, Derived>::value == true
is_virtual_base_of<Base, Base>::value == true
```


### <a name="is-convertible" href="is-convertible">変換可能な型かどうかを判定する</a>
`boost::is_convertible<From, To>`メタ関数を使用する。

インクルード：

- `boost/type_traits/is_convertible.hpp`
- `boost/type_traits.hpp`

例：
```cpp
is_convertible<int, double>::value == true
is_convertible<const int, double>::value == true
is_convertible<int* const, int*>::value == true
is_convertible<int const*, int*>::value == false // const_castが必要
is_convertible<int const&, long>::value == true
is_convertible<int, int>::value == true
```


### <a name="is-same" href="is-same">2つの型が同じかを判定する</a>
`boost::is_same<T, U>`メタ関数を使用する。

インクルード：

- `boost/type_traits/is_same.hpp`
- `boost/type_traits.hpp`

例：
```cpp
is_same<int, int>::value == true
is_same<int const, int>::value == false
is_same<int&, int>::value == false
```

## <a name="transform-type-to-another" href="transform-type-to-another">型の変換する</a>
### <a name="add-const" href="add-const">const修飾を付加する</a>
`boost::add_const<T>`メタ関数を使用する。

`T const`型を返す。

インクルード：

- `boost/type_traits/add_const.hpp`
- `boost/type_traits.hpp`

例：
```cpp
add_const<int>::type       : int const
add_const<int&>::type      : int&
add_const<int*>::type      : int* const
add_const<int const>::type : int const
```


### <a name="add-volatile" href="add-volatile">volatile修飾を付加する</a>
`boost::add_volatile<T>`メタ関数を使用する。

`T volatile`型を返す。

インクルード：

- `boost/type_traits/add_volatile.hpp`
- `boost/type_traits.hpp`

例：
```cpp
add_volatile<int>::type : int volatile
add_volatile<int&>::type : int&
add_volatile<int*>::type : int* volatile
add_volatile<int const>::type : int const volatile
```

### <a name="add-cv" href="add-cv">const volatile修飾を付加する</a>
`boost::add_cv<T>`メタ関数を使用する。

`T const volatile`型を返す。

インクルード：

- `boost/type_traits/add_cv.hpp`
- `boost/type_traits.hpp`

例：
```cpp
add_cv<int>::type       : int const volatile
add_cv<int&>::type      : int&
add_cv<int*>::type      : int* const volatile
add_cv<int const>::type : int const volatile
```


### <a name="add-lvalue-reference" href="add-lvalue-reference">左辺値参照を付加する</a>
`boost::add_lvalue_reference<T>`メタ関数を使用する。

`T&`型を返す。

インクルード：

- `boost/type_traits/add_lvalue_reference.hpp`
- `boost/type_traits.hpp`

例：
```cpp
add_lvalue_reference<int>::type        : int&
add_lvalue_reference<int const&>::type : int const&
add_lvalue_reference<int*>::type       : int*&
add_lvalue_reference<int*&>::type      : int*&
add_lvalue_reference<int&&>::type      : int&
add_lvalue_reference<void>::type       : void
```


### <a name="add-rvalue-reference" href="add-rvalue-reference">右辺値参照を付加する</a>
`boost::add_rvalue_reference<T>`メタ関数を使用する。

`T&&`型を返す。


インクルード：

- `boost/type_traits/add_rvalue_reference.hpp`
- `boost/type_traits.hpp`例：

```cpp
add_rvalue_reference<int>::type        : int&&
add_rvalue_reference<int const&>::type : int const&
add_rvalue_reference<int*>::type       : int*&&
add_rvalue_reference<int*&>::type      : int*&
add_rvalue_reference<int&&>::type      : int&&
add_rvalue_reference<void>::type       : void
```


### <a name="add-reference" href="add-reference">参照を付加する</a>
`boost::add_reference<T>`メタ関数を使用する。

`T&`型を返す。

インクルード：

- `boost/type_traits/add_reference.hpp`
- `boost/type_traits.hpp`

例：
```cpp
add_reference<int>::type        : int&
add_reference<int const&>::type : int const&
add_reference<int*>::type       : int*&
add_reference<int*&>::type      : int*&
```


### <a name="add-pointer" href="add-pointer">ポインタを付加する</a>
`boost::add_pointer<T>`メタ関数を使用する。

`T*`型を返す。


インクルード：

- `boost/type_traits/add_pointer.hpp`
- `boost/type_traits.hpp`

例：
```cpp
add_pointer<int>::type        : int*
add_pointer<int const&>::type : int const*
add_pointer<int*>::type       : int**
add_pointer<int*&>::type      : int**
```


### <a name="conditional" href="conditional">条件によって型を選択する</a>
`boost::conditional<Cond, Then, Else>`メタ関数を使用する。

コンパイル時条件`Cond`が`true`の場合は`Then`型を返し、それ以外の場合は`Else`型を返す。


インクルード：

- `boost/type_traits/conditional.hpp`
- `boost/type_traits.hpp`

例：
```cpp
conditional<true, int, char>::type  : int
conditional<false, int, char>::type : char
```


### <a name="common-type" href="common-type">共通の型を取得する</a>
`boost::common_type<T...>`メタ関数を使用する。

複数の型から、共通に変換可能な型を推定して返す。


インクルード：

- `boost/type_traits/common_type.hpp`
- `boost/type_traits.hpp`

例：
```cpp
template <class ...T>
typename common_type<T...>::type min(T... t);
```


### <a name="decay" href="decay">推論される型の取得する</a>
`boost::decay<T>`メタ関数を使用する。

以下のような関数テンプレートによって推論される型を取得する。

```cpp
template<class T> void f(T x);
```

インクルード：

- `<boost/type_traits/decay.hpp>`
- `<boost/type_traits.hpp>`

例：
```cpp
decay<int[2][3]>::type      : int[3]*
decay<int(&)[2]>::type      : int*
decay<int(&)(double)>::type : int(*)(double)
int(*)(double)              : int(*)(double)
int(double)                 : int(*)(double)
```


### <a name="floating-point-promotion" href="floating-point-promotion">浮動小数点数型を昇格する</a>
`booost::floating_point_promotion<T>`メタ関数を使用する。

`float`を`double`、`double`を`long double`に昇格。

インクルード：

- `boost/type_traits/floating_point_promotion.hpp`
- `boost/type_traits.hpp`

例：
```cpp
floating_point_promotion<float const>::type : double const
floating_point_promotion<float&>::type      : float&
floating_point_promotion<short>::type       : short
```


### <a name="integral-promotion" href="integral-promotion">整数型を昇格する</a>
`boost::integral_promotion<T>`メタ関数を使用する。

`short`を`int`、`int`を`long`に、といった昇格を行う。

インクルード：

- `boost/type_traits/integral_promotion.hpp`
- `boost/type_traits.hpp`

例：
```cpp
integral_promotion<short const>::type                 : int const
integral_promotion<short&>::type                      : short&
integral_promotion<enum std::float_round_style>::type : int
```


### <a name="promote" href="promote">型を昇格する</a>
`boost::promote<T>`メタ関数を使用する。

整数型もしくは浮動小数点数型を昇格。

インクルード：

- `boost/type_traits/promote.hpp`
- `boost/type_traits.hpp`

例：
```cpp
promote<short volatile>::type : int volatile
promote<float const>::type    : double const
promote<short&>::type         : short&
```


### <a name="make-signed" href="make-signed">符号なし型から符号あり型に変換する</a>
`boost::make_signed<T>`メタ関数を使用する。

インクルード：

- `boost/type_traits/make_signed.hpp`
- `boost/type_traits.hpp`

例：
```cpp
make_signed<int>::type                      : int
make_signed<unsigned int const>::type       : int const
make_signed<const unsigned long long>::type : const long long
make_signed<my_enum>::type                  : enumと同じ幅を持つ符号付き整数型
make_signed<wchar_t>::type                  : wchar_tと同じ幅を持つ符号付き整数型
```


### <a name="make-unsigned" href="make-unsigned">符号あり型から符号なし型に変換する</a>
`boost::make_unsigned<T>`メタ関数を使用する。

インクルード：

- `boost/type_traits/make_unsigned.hpp`
- `boost/type_traits.hpp`

例：
```cpp
make_unsigned<int>::type                      : unsigned int
make_unsigned<unsigned int const>::type       : unsigned int const
make_unsigned<const unsigned long long>::type : const unsigned long long
make_unsigned<my_enum>::type                  : enumと同じ幅を持つ符号なし整数型
make_unsigned<wchar_t>::type                  : wchar_tと同じ幅を持つ符号なし整数型
```


### <a name="remove-extent" href="remove-extent">配列の次元を削除する</a>
`boost::remove_extent<T>`メタ関数を使用する。

インクルード：

- `boost/type_traits/remove_extent.hpp`
- `boost/type_traits.hpp`

例：
```cpp
remove_extent<int>::type          : int
remove_extent<int const[2]>::type : int const
remove_extent<int[2][4]>::type    : int[4]
remove_extent<int[][2]>::type     : int[2]
remove_extent<int const*>::type   : int const*
```


### <a name="remove-all-extents" href="remove-all-extents">配列の次元を全て削除する</a>
`boost::remove_all_extents<T>`メタ関数を使用する。

インクルード：

- `boost/type_traits/remove_all_extents.hpp`
- `boost/type_traits.hpp`

例：
```cpp
remove_all_extents<int>::type          : int
remove_all_extents<int const[2]>::type : int const
remove_all_extents<int[][2]>::type     : int
remove_all_extents<int[2][3][4]>::type : int
remove_all_extents<int const*>::type   : int const*
```


### <a name="remove-const" href="remove-const">const修飾を削除する</a>
`boost::remove_const<T>`メタ関数を使用する。

インクルード：

- `boost/type_traits/remove_const.hpp`
- `boost/type_traits.hpp`

例：
```cpp
remove_const<int>::type : int
remove_const<int const>::type : int
remove_const<int const volatile>::type : int volatile
remove_const<int const&>::type : int const&
remove_const<int const*>::type : int const*
```


### <a name="remove-volatile" href="remove-volatile">volatile修飾を削除する</a>
`boost::remove_volatile<T>`メタ関数を使用する。

インクルード：

- `boost/type_traits/remove_volatile.hpp`
- `boost/type_traits.hpp`

例：
```cpp
remove_volatile<int>::type                : int
remove_volatile<int volatile>::type       : int
remove_volatile<int const volatile>::type : int const
remove_volatile<int volatile&>::type      : int volatile&
remove_volatile<int volatile*>::type      : int volatile*
```


### <a name="remove-cv" href="remove-cv">const volatile修飾を削除する</a>
`boost::remove_cv<T>`メタ関数を使用する。

インクルード：

- `boost/type_traits/remove_cv.hpp`
- `boost/type_traits.hpp`

例：
```cpp
remove_cv<int>::type                : int
remove_cv<int const>::type          : int
remove_cv<int const volatile>::type : int
remove_cv<int const&>::type         : int const&
remove_cv<int const*>::type         : int const*
```


### <a name="remove-pointer" href="remove-pointer">ポインタを削除する</a>
`boost::remove_pointer<T>`メタ関数を使用する。

インクルード：

- `boost/type_traits/remove_pointer.hpp`
- `boost/type_traits.hpp`

例：
```cpp
remove_pointer<int>::type         : int
remove_pointer<int const*>::type  : int const
remove_pointer<int const**>::type : int const*
remove_pointer<int&>::type        : int&
remove_pointer<int*&>::type       : int*&
```


### <a name="remove-reference" href="remove-reference">参照を削除する</a>
`boost::remove_reference<T>`メタ関数を使用する。

インクルード：

- `boost/type_traits/remove_reference.hpp`
- `boost/type_traits.hpp`

例：
```cpp
remove_reference<int>::type        : int
remove_reference<int const&>::type : int const
remove_reference<int&&>::type      : int
remove_reference<int*>::type       : int*
remove_reference<int*&>::type      : int*
```


## <a name="synthesizing-types-with-specific-alignments" href="synthesizing-types-with-specific-alignments">特定アライメントを持った型の合成</a>
### <a name="type-with-alignment" href="type-with-alignment">特定のアライメントを持つ型の取得する</a>
`boost::type_with_alignment<Align>`メタ関数を使用する。

インクルード：

- `boost/type_traits/type_with_alignment.hpp`
- `boost/type_traits.hpp`

例：
```cpp
#include <iostream>
#include <boost/type_traits/alignment_of.hpp>
#include <boost/type_traits/type_with_alignment.hpp>

int main()
{
    std::cout << typeid(
        boost::type_with_alignment<
            boost::alignment_of<char>::value
        >::type
    ).name() << std::endl;
}
```

実行結果：
```
union boost::detail::lower_alignment<1>
```


### <a name="aligned-storage" href="aligned-storage">適切にアライメントされた型を作成する</a>
`boost::aligned_storage<Len, Align>`メタ関数を使用する。

`Align`アライメント、`Len`サイズのPOD型を返す。

インクルード：

- `boost/type_traits/aligned_storage.hpp`
- `boost/type_traits.hpp`

例：
```cpp
// via http://d.hatena.ne.jp/Cryolite/20051102#p1

template<class T>
class scoped_destroy : boost::noncopyable
{
public:
    explicit scoped_destroy(T* p) : ptr_(p) {}
    ~scoped_destroy(){ptr_->~T();}
    T& operator*()const{return *ptr_;}
    T* operator->()const{return ptr_;}
    T* get()const{return ptr_;}
private:
    T* ptr_;
};

int main()
{
    boost::aligned_storage<
        sizeof(MyClass), boost::alignment_of<MyClass>::value
    >::type buf;

    scoped_destroy<MyClass> p(::new (static_cast<void*>(&buf)) MyClass());

    ... // p.get(), p->(), *p を用いて構築したオブジェクトを利用する

    // ここで明示的なデストラクタの呼び出しは不要
}
```

