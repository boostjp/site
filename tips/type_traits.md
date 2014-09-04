#型特性
Boost Type Traits Libraryでは、型がどういった特徴を持っているかを判定するメタ関数が多く提供されている。

Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>型の分類](#TOC--)<ol class='goog-toc'><li class='goog-toc'>[<strong>1.1 </strong>配列型かどうかの判定](#TOC--1)</li><li class='goog-toc'>[<strong>1.2 </strong>クラスかどうかの判定](#TOC--2)</li><li class='goog-toc'>[<strong>1.3 </strong>std::complex型かどうかの判定](#TOC-std::complex-)</li><li class='goog-toc'>[<strong>1.4 </strong>enum型かどうかの判定](#TOC-enum-)</li><li class='goog-toc'>[<strong>1.5 </strong>浮動小数点数型かどうかの判定](#TOC--3)</li><li class='goog-toc'>[<strong>1.6 </strong>関数型かどうかの判定](#TOC--4)</li><li class='goog-toc'>[<strong>1.7 </strong>整数型かどうかの判定](#TOC--5)</li><li class='goog-toc'>[<strong>1.8 </strong>メンバ関数ポインタかどうかの判定](#TOC--6)</li><li class='goog-toc'>[<strong>1.9 </strong>メンバ変数ポインタかどうかの判定](#TOC--7)</li><li class='goog-toc'>[<strong>1.10 </strong>ポインタかどうかの判定](#TOC--8)</li><li class='goog-toc'>[<strong>1.11 </strong>左辺値参照かどうかの判定](#TOC--9)</li><li class='goog-toc'>[<strong>1.12 </strong>右辺値参照かどうかの判定](#TOC--10)</li><li class='goog-toc'>[<strong>1.13 </strong>共用体かどうかの判定](#TOC--11)</li><li class='goog-toc'>[<strong>1.14 </strong>voidかどうかの判定](#TOC-void-)</li><li class='goog-toc'>[<strong>1.15 </strong>算術型かどうかの判定](#TOC--12)</li><li class='goog-toc'>[<strong>1.16 </strong>複合型かどうかの判定](#TOC--13)</li><li class='goog-toc'>[<strong>1.17 </strong>基本型かどうかの判定](#TOC--14)</li><li class='goog-toc'>[<strong>1.18 </strong>メンバポインタかどうかの判定](#TOC--15)</li><li class='goog-toc'>[<strong>1.19 </strong>オブジェクト型かどうかを判定する](#TOC--16)</li><li class='goog-toc'>[<strong>1.20 </strong>参照型かどうかを判定する](#TOC--17)</li><li class='goog-toc'>[<strong>1.21 </strong>スカラ型かどうかを判定する](#TOC--18)</li></ol></li><li class='goog-toc'>[<strong>2 </strong>型の性質](#TOC--19)<ol class='goog-toc'><li class='goog-toc'>[<strong>2.1 </strong>アライメントの取得](#TOC--20)</li><li class='goog-toc'>[<strong>2.2 </strong>new演算子を持っている型か判定](#TOC-new-)</li><li class='goog-toc'>[<strong>2.3 </strong>例外を投げない代入演算子を持っている型か判定](#TOC--21)</li><li class='goog-toc'>[<strong>2.4 </strong>例外を投げないコンストラクタを持っている型か判定](#TOC--22)</li><li class='goog-toc'>[<strong>2.5 </strong>例外を投げないコピーコンストラクタを持っている型か判定](#TOC--23)</li><li class='goog-toc'>[<strong>2.6 </strong>自明な代入演算子を持っている型か判定](#TOC--24)</li><li class='goog-toc'>[<strong>2.7 </strong>自明なコンストラクタを持っている型か判定](#TOC--25)</li><li class='goog-toc'>[<strong>2.8 </strong>自明なコピーコンストラクタを持っている型か判定](#TOC--26)</li><li class='goog-toc'>[<strong>2.9 </strong>自明なデストラクタを持っている型か判定](#TOC--27)</li><li class='goog-toc'>[<strong>2.10 </strong>仮想デストラクタを持っている型か判定](#TOC--28)</li><li class='goog-toc'>[<strong>2.11 </strong>抽象型かを判定](#TOC--29)</li><li class='goog-toc'>[<strong>2.12 </strong>const修飾された型かを判定](#TOC-const-)</li><li class='goog-toc'>[<strong>2.13 </strong>空クラスかを判定](#TOC--30)</li><li class='goog-toc'>[<strong>2.14 </strong>stateless型かを判定](#TOC-stateless-)</li><li class='goog-toc'>[<strong>2.15 </strong>POD型かを判定](#TOC-POD-)</li><li class='goog-toc'>[<strong>2.16 </strong>多相的に振る舞う型かを判定](#TOC--31)</li><li class='goog-toc'>[<strong>2.17 </strong>符号付き整数型かを判定](#TOC--32)</li><li class='goog-toc'>[<strong>2.18 </strong>符号なし整数型かを判定](#TOC--33)</li><li class='goog-toc'>[<strong>2.19 </strong>volatile修飾された型かを判定](#TOC-volatile-)</li><li class='goog-toc'>[<strong>2.20 </strong>配列のN次元目の要素数を取得](#TOC-N-)</li><li class='goog-toc'>[<strong>2.21 </strong>配列の次元数を取得](#TOC--34)</li></ol></li><li class='goog-toc'>[<strong>3 </strong>2つの型の関係性](#TOC-2-)<ol class='goog-toc'><li class='goog-toc'>[<strong>3.1 </strong>継承関係にある型かを判定](#TOC--35)</li><li class='goog-toc'>[<strong>3.2 </strong>仮想継承の関係にある型かを判定](#TOC--36)</li><li class='goog-toc'>[<strong>3.3 </strong>変換可能な型かを判定](#TOC--37)</li><li class='goog-toc'>[<strong>3.4 </strong>2つの型が同じかを判定](#TOC-2-1)</li></ol></li><li class='goog-toc'>[<strong>4 </strong>型の変換](#TOC--38)<ol class='goog-toc'><li class='goog-toc'>[<strong>4.1 </strong>const修飾を付加](#TOC-const-1)</li><li class='goog-toc'>[<strong>4.2 </strong>volatile修飾を付加](#TOC-volatile-1)</li><li class='goog-toc'>[<strong>4.3 </strong>const volatile修飾を付加](#TOC-const-volatile-)</li><li class='goog-toc'>[<strong>4.4 </strong>左辺値参照を付加](#TOC--39)</li><li class='goog-toc'>[<strong>4.5 </strong>右辺値参照を付加](#TOC--40)</li><li class='goog-toc'>[<strong>4.6 </strong>参照を付加](#TOC--41)</li><li class='goog-toc'>[<strong>4.7 </strong>ポインタを付加](#TOC--42)</li><li class='goog-toc'>[<strong>4.8 </strong>条件式](#TOC--43)</li><li class='goog-toc'>[<strong>4.9 </strong>共通の型を取得](#TOC--44)</li><li class='goog-toc'>[<strong>4.10 </strong>推論される型の取得](#TOC--45)</li><li class='goog-toc'>[<strong>4.11 </strong>浮動小数点数型を昇格する](#TOC--46)</li><li class='goog-toc'>[<strong>4.12 </strong>整数型を昇格する](#TOC--47)</li><li class='goog-toc'>[<strong>4.13 </strong>型を昇格する](#TOC--48)</li><li class='goog-toc'>[<strong>4.14 </strong>符号なし型から符号あり型に変換](#TOC--49)</li><li class='goog-toc'>[<strong>4.15 </strong>符号あり型から符号なし型に変換](#TOC--50)</li><li class='goog-toc'>[<strong>4.16 </strong>配列の次元を削除](#TOC--51)</li><li class='goog-toc'>[<strong>4.17 </strong>配列の次元を全て削除](#TOC--52)</li><li class='goog-toc'>[<strong>4.18 </strong>const修飾を削除](#TOC-const-2)</li><li class='goog-toc'>[<strong>4.19 </strong>const volatile修飾を削除](#TOC-const-volatile-1)</li><li class='goog-toc'>[<strong>4.20 </strong>ポインタを削除](#TOC--53)</li><li class='goog-toc'>[<strong>4.21 </strong>参照を削除](#TOC--54)</li><li class='goog-toc'>[<strong>4.22 </strong>volatile修飾を削除](#TOC-volatile-2)</li></ol></li><li class='goog-toc'>[<strong>5 </strong>特定アライメントを持った型の合成](#TOC--55)<ol class='goog-toc'><li class='goog-toc'>[<strong>5.1 </strong>特定のアライメントを持つ型の取得](#TOC--56)</li><li class='goog-toc'>[<strong>5.2 </strong>適切にアライメントされた型を作成する](#TOC--57)</li></ol></li></ol>




###型の分類
<h4>配列型かどうかの判定</h4>boost::is_array<T>

インクルード：
<boost/type_traits/is_array.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_array<int[2]>::value == true
is_array<char[2][3]>::type == true
is_array<double[]>::value == true
```

<h4>クラスかどうかの判定</h4>boost::is_class<T>

インクルード：
<boost/type_traits/is_class.hpp>
<boost/type_traits.hpp>

例：

```cpp
class MyClass;

is_class<MyClass>::value == true
is_class<MyClass const>::value == true
is_class<MyClass&>::value == false
is_class<MyClass*>::value == false



<h4>std::complex型かどうかの判定</h4>boost::is_complex<T>

インクルード：
<boost/type_traits/is_complex.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_complex<std::complex<T> >::value == true
```

<h4>enum型かどうかの判定</h4>boost::is_enum<T>

インクルード：
<boost/type_traits/is_enum.hpp>
<boost/type_traits.hpp>

例：

```cpp
enum my_enum { one, two };

is_enum<my_enum>::value == true
is_enum<my_enum const>::type == true
is_enum<my_enum&>::value == false
is_enum<my_enum*>::value == false



<h4>浮動小数点数型かどうかの判定</h4>boost::is_floating_point<T>

インクルード：
<boost/type_traits/is_floating_point.hpp>
<boost/type_traits.hpp>

例：

```cpp
is_floating_point<float>::value == true
is_floating_point<double>::value == true
is_floating_point<long double>::value == true



<h4>関数型かどうかの判定</h4>boost::is_function<T>

インクルード：
<boost/type_traits/is_function.hpp>
<boost/type_traits.hpp>

例：

```cpp
is_function<int (void)>::value == true
is_function<long (double, int)>::value == true

is_function<long (*)(double, int)>::value == false // 関数型ではなく関数へのポインタ
is_function<long (&)(double, int)>::value == false // 関数型ではなく関数への参照

is_function<long (MyClass::*)(double, int)>::value == false // メンバ関数へのポインタ



<h4>整数型かどうかの判定</h4>boost::is_integral<T>

インクルード：
<boost/type_traits/is_integral.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_integral<int>::value == true
is_integral<const char>::value == true
is_integral<long>::value == true


<h4>メンバ関数ポインタかどうかの判定</h4>boost::is_member_function<T>

インクルード：
<boost/type_traits/is_member_function.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_member_function_pointer<int (MyClass::*)(void)>::value == true
is_member_function_pointer<int (MyClass::*)(char)>::value == true
is_member_function_pointer<int (MyClass::*)(void)const>::value == true
is_member_function_pointer<int (MyClass::*)>::value == false // データメンバへのポインタ


<h4>メンバ変数ポインタかどうかの判定</h4>boost::is_member_object<T>

インクルード：
<boost/type_traits/is_member_object.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_member_object_pointer<int (MyClass::*)>::value == true
is_member_object_pointer<double (MyClass::*)>::value == true
is_member_object_pointer<const int (MyClass::*)>::value == true
is_member_object_pointer<int (MyClass::*)(void)>::value == false // メンバ関数ポインタ


<h4>ポインタかどうかの判定</h4>boost::is_pointer<T>

インクルード：
<boost/type_traits/is_pointer.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_pointer<int*>::value == true
is_pointer<char* const>::type == true
is_pointer<int (*)(long)>::value == true
is_pointer<int (MyClass::*)(long)>::value == false
is_pointer<int (MyClass::*)>::value == false


<h4>左辺値参照かどうかの判定</h4>boost::is_lvalue_reference<T>

インクルード：
<boost/type_traits/is_lvalue_reference.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_lvalue_reference<int&>::value == true
is_lvalue_reference<int const&>::value == true
is_lvalue_reference<int const&&>::value == false
is_lvalue_reference<int (&)(long)>::value == true


<h4>右辺値参照かどうかの判定</h4>boost::is_rvalue_reference<T>

インクルード：
<boost/type_traits/is_rvalue_reference.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_rvalue_reference<int&&>::value == true
is_rvalue_reference<int const&&>::value == true
is_rvalue_reference<int const&>::value == false
is_rvalue_reference<int (&&)(long)>::value == true


<h4>共用体かどうかの判定</h4>boost::is_union<T>

インクルード：
<boost/type_traits/is_union.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_union<void>::value == true
is_union<const void>::value == true
is_union<void*>::value == false


<h4>voidかどうかの判定</h4>boost::is_void<T>

インクルード：
<boost/type_traits/is_void.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_void<void>::value == true
is_void<const void>::value == true
is_void<void*>::value == false


<h4>算術型かどうかの判定</h4>boost::is_arithmetic<T>

インクルード：
<boost/type_traits/is_arithmetic.hpp>
<boost/type_traits.hpp>

算術型は以下を含む：

- 整数型(is_integral)
- 浮動小数点数型(is_floating_point)

例：
```cpp
is_arithmetic<int>::value == true
is_arithmetic<char>::value == true
is_arithmetic<double>::value == true


<h4>複合型かどうかの判定</h4>boost::is_compound<T>

インクルード：
<boost/type_traits/is_compound.hpp>
<boost/type_traits.hpp>

複合型は、基本型(is_fundamental)以外の型である。

例：
```cpp
is_compound<MyClass>::value == true
is_compound<MyEnum>::value == true
is_compound<int*>::value == true
is_compound<int&>::value == true
is_compound<int>::value == false


<h4>基本型かどうかの判定</h4>boost::is_fundamental<T>

基本型は以下を含む：

- 整数型(is_integral)
- 浮動小数点数型(is_floating_point)
- void型(is_void)

インクルード：
<boost/type_traits/is_fundamental.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_fundamental<int)>::value == true
is_fundamental<double const>::value == true
is_fundamental<void>::value == true


<h4>メンバポインタかどうかの判定</h4>boost::is_member_pointer<T>

メンバポインタは以下を含む：

- メンバ関数ポインタ(is_member_function)
- メンバ変数ポインタ(is_member_object)

インクルード：
<boost/type_traits/is_member_pointer.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_member_pointer<int (MyClass::*)>::value == true
is_member_pointer<int (MyClass::*)(char)>::value == true
is_member_pointer<int (MyClass::*)(void)const>::value == true


<h4>オブジェクト型かどうかを判定する</h4>boost::is_object<T>

オブジェクト型は、参照、void、関数型以外の型である。

インクルード：
<boost/type_traits/is_object.hpp>
<boost/type_traits.hpp>

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

<h4>参照型かどうかを判定する</h4>
boost::is_referece<T>

参照型は、左辺値参照と右辺値参照を含む型である。

インクルード：
<boost/type_traits/is_reference.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_reference<int&>:: == true
is_reference<int const&>::value == true
is_reference<int const&&>::value == true
is_reference<int (&)(long)>::value == true // 関数への参照
```

<h4>スカラ型かどうかを判定する</h4>boost::is_scalar<T>

スカラ型は以下を含む：

- 整数型
- 浮動小数点数型
- 列挙型
- ポインタ型
- メンバポインタ型

インクルード：
<boost/type_traits/is_scalar.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_scalar<int*>::value == true
is_scalar<int>::value == true
is_scalar<double>::value == true
is_scalar<int (*)(long)>::value == true
is_scalar<int (MyClass::*)(long)>::value == true
is_scalar<int (MyClass::*)>::value == true
```

###型の性質

<h4>アライメントの取得</h4>boost::alignment_of<T>

型Tのアライメントを取得する。

インクルード：
<boost/type_traits/alignment_of.hpp>
<boost/type_traits.hpp>

例：
```cpp
const std::size_t a = alignment_of<int>::value;
```

<h4>new演算子を持っている型か判定</h4>boost::has_new_operator<T>

インクルード：
<boost/type_traits/has_new_operator.hpp>
<boost/type_traits.hpp>

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

<h4>例外を投げない代入演算子を持っている型か判定</h4>boost::has_nothrow_assign<T>

インクルード：
<boost/type_traits/has_nothrow_assign.hpp>
<boost/type_traits.hpp>

<h4>例外を投げないコンストラクタを持っている型か判定</h4>boost::has_nothrow_constructor<T>
boost::has_nothrow_default_constructor<T>

インクルード：
<boost/type_traits/has_nothrow_constructor.hpp>
<boost/type_traits.hpp>

<h4>例外を投げないコピーコンストラクタを持っている型か判定</h4>boost::has_nothrow_copy<T>
boost::has_nothrow_copy_constructor<T>

インクルード：
<boost/type_traits/has_nothrow_copy.hpp>
<boost/type_traits/has_nothrow_copy_constructor.hpp>
<boost/type_traits.hpp>

<h4>自明な代入演算子を持っている型か判定</h4>boost::has_trivial_assign<T>

インクルード：
<boost/type_traits/has_trivial_assign.hpp>
<boost/type_traits.hpp>

例：
```cpp
has_trivial_assign<int>::value == true
has_trivial_assign<char*>::value == true
has_trivial_assign<int (*)(long)>::value == true
has_trivial_assign<MyClass>::value == false
```

<h4>自明なコンストラクタを持っている型か判定</h4>boost::has_trivial_constructor<T>
boost::has_trivial_default_constructor<T>

インクルード：
<boost/type_traits/has_trivial_constructor.hpp>
<boost/type_traits.hpp>

例：
```cpp
has_trivial_constructor<int>::value == true
has_trivial_constructor<char*>::value == true
has_trivial_constructor<int (*)(long)>::value == true
has_trivial_constructor<MyClass>::value == false
```

<h4>自明なコピーコンストラクタを持っている型か判定</h4>boost::has_trivial_copy<T>
boost::has_trivial_copy_constructor<T>

インクルード：
<boost/type_traits/has_trivial_copy.hpp>
<boost/type_traits.hpp>

例：
```cpp
has_trivial_copy<int>::value == true
has_trivial_copy<char*>::value == true
has_trivial_copy<int (*)(long)>::value == true
has_trivial_copy<MyClass>::value == false
```

<h4>自明なデストラクタを持っている型か判定</h4>boost::has_trivial_destructor<T>

インクルード：
<boost/type_traits/has_trivial_destructor.hpp>
<boost/type_traits.hpp>

例：
```cpp
has_trivial_destructor<int>::value == true
has_trivial_destructor<char*>::value == true
has_trivial_destructor<int (*)(long)>::value == true
has_trivial_destructor<MyClass>::value == false
```

<h4>仮想デストラクタを持っている型か判定</h4>boost::has_virtual_destructor<T>

インクルード：
<boost/type_traits/has_virtual_destructor.hpp>
<boost/type_traits.hpp>

<h4>抽象型かを判定</h4>boost::is_abstract<T>

インクルード：
<boost/type_traits/is_abstract.hpp>
<boost/type_traits.hpp>

例：
```cpp
class abc{ virtual ~abc() = 0; }; 

is_abstract<abc>::value == true
is_abstract<abc const>::value == true
```

<h4>const修飾された型かを判定</h4>boost::is_const<T>

インクルード：
<boost/type_traits/is_const.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_const<int const>::value == true
is_const<int const volatile>::value == true
is_const<int* const>::value == true
is_const<int const*>::value == false
is_const<int const&>::value == false
is_const<int>::value == false
```

<h4>空クラスかを判定</h4>boost::is_empty<T>

継承してもサイズが増えない型ならtrue

インクルード：
<boost/type_traits/is_empty.hpp>
<boost/type_traits.hpp>

例：
```cpp
struct empty_class {}; 

is_empty<empty_class>::value == true
is_empty<empty_class const>::value == true
is_empty<empty_class>::value == true
```

<h4>stateless型かを判定</h4>boost::is_stateless<T>

ストレージを持たず、コンストラクタとデストラクタが自明な型ならtrue

インクルード：
<boost/type_traits/is_stateless.hpp>
<boost/type_traits.hpp>

<h4>POD型かを判定</h4>boost::is_pod<T>

インクルード：
<boost/type_traits/is_pod.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_pod<int>::value == true
is_pod<char*>::value == true
is_pod<int (*)(long)>::value == true
is_pod<MyClass>::value == false
```

<h4>多相的に振る舞う型かを判定</h4>boost::is_polymorphic<T>

インクルード：
<boost/type_traits/is_polymorphic.hpp>
<boost/type_traits.hpp>

例：
```cpp
class poly{ virtual ~poly(); };

is_polymorphic<poly>::value == true
is_polymorphic<poly const>::value == true
is_polymorphic<poly>::value == true
```

<h4>符号付き整数型かを判定</h4>boost::is_signed<T>

インクルード：
<boost/type_traits/is_signed.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_signed<int>::value == true
is_signed<int const volatile>::value == true
is_signed<unsigned int>::value == false
is_signed<myclass>::value == false
is_signed<char>::valueは、charの符号性質に依存する
is_signed<long long>::value == true
```

<h4>符号なし整数型かを判定</h4>boost::is_unsigned<T>

インクルード：
<boost/type_traits/is_unsigned.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_unsigned<unsigned int>::value == true
is_unsigned<unsigned int const volatile>::value == true
is_unsigned<int>::value == false
is_unsigned<myclass>::value == false
is_unsigned<char>::valueは、charの符号性質に依存する
is_unsigned<unsigned long long>::value == true
```

<h4>volatile修飾された型かを判定</h4>boost::is_volatile<T>

インクルード：
<boost/type_traits/is_volatile.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_volatile<volatile int>::value == true
is_volatile<const volatile int>::value == true
is_volatile<int* volatile>::value == true
is_volatile<int volatile*>::value == false
```

<h4>配列のN次元目の要素数を取得</h4>boost::extent<T>
boost::extent<T, N>

インクルード：
<boost/type_traits/extent.hpp>
<boost/type_traits.hpp>

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

<h4>配列の次元数を取得</h4>boost::rank<T>

インクルード：
<boost/type_traits/rank.hpp>
<boost/type_traits.hpp>

例：
```cpp
rank<int[]>::value == 1
rank<double[2][3][4]>::value == 3
rank<int[1]>::value == 1
rank<int[][2]>::value == 2
rank<int*>::value == 0
rank<boost::array<int, 3> >::value == 0
```

###2つの型の関係性
<h4>継承関係にある型かを判定</h4>boost::is_base_of<Base, Derived>

インクルード：
<boost/type_traits/is_base_of.hpp>
<boost/type_traits.hpp>

例：
```cpp
class Base{};
class Derived : public Base{}; 

is_base_of<Base, Derived>::value == true
is_base_of<Base, Base>::value == true
```

<h4>仮想継承の関係にある型かを判定</h4>boost::is_virtual_base_of<Base, Derived>

インクルード：
<boost/type_traits/is_virtual_base_of.hpp>
<boost/type_traits.hpp>

例：
```cpp
class Base{};
class Derived : public virtual Base{}; 

is_virtual_base_of<Base, Derived>::value == true
is_virtual_base_of<Base, Base>::value == true
```

<h4>変換可能な型かを判定</h4>boost::is_convertible<From, To>

インクルード：
<boost/type_traits/is_convertible.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_convertible<int, double>::value == true
is_convertible<const int, double>::value == true
is_convertible<int* const, int*>::value == true
is_convertible<int const*, int*>::value == false // const_castが必要
is_convertible<int const&, long>::value == true
is_convertible<int, int>::value == true
```

<h4>2つの型が同じかを判定</h4>boost::is_same<T, U>

インクルード：
<boost/type_traits/is_same.hpp>
<boost/type_traits.hpp>

例：
```cpp
is_same<int, int>::value == true
is_same<int const, int>::value == false
is_same<int&, int>::value == false
```

###型の変換
<h4>const修飾を付加</h4>boost::add_const<T>

T const型を返す

インクルード：
<boost/type_traits/add_const.hpp>
<boost/type_traits.hpp>

例：
```cpp
add_const<int>::type       : int const
add_const<int&>::type      : int&
add_const<int*>::type      : int* const
add_const<int const>::type : int const
```

<h4>volatile修飾を付加</h4>boost::add_volatile<T>

T volatile型を返す

インクルード：
<boost/type_traits/add_volatile.hpp>
<boost/type_traits.hpp>
例：
```cpp
add_volatile<int>::type : int volatile
add_volatile<int&>::type : int&
add_volatile<int*>::type : int* volatile
add_volatile<int const>::type : int const volatile
```

<h4>const volatile修飾を付加</h4>boost::add_cv<T>

T const volatile型を返す

インクルード：
<boost/type_traits/add_cv.hpp>
<boost/type_traits.hpp>

例：
```cpp
add_cv<int>::type       : int const volatile
add_cv<int&>::type      : int&
add_cv<int*>::type      : int* const volatile
add_cv<int const>::type : int const volatile
```

<h4>左辺値参照を付加</h4>boost::add_lvalue_reference<T>

T&型を返す

インクルード：
<boost/type_traits/add_lvalue_reference.hpp>
<boost/type_traits.hpp>

例：
```cpp
add_lvalue_reference<int>::type        : int&
add_lvalue_reference<int const&>::type : int const&
add_lvalue_reference<int*>::type       : int*&
add_lvalue_reference<int*&>::type      : int*&
add_lvalue_reference<int&&>::type      : int&
add_lvalue_reference<void>::type       : void
```

<h4>右辺値参照を付加</h4>boost::add_rvalue_reference<T>

T&&型を返す

インクルード：
<boost/type_traits/add_rvalue_reference.hpp>
<boost/type_traits.hpp>例：
```cpp
add_rvalue_reference<int>::type        : int&&
add_rvalue_reference<int const&>::type : int const&
add_rvalue_reference<int*>::type       : int*&&
add_rvalue_reference<int*&>::type      : int*&
add_rvalue_reference<int&&>::type      : int&&
add_rvalue_reference<void>::type       : void
```

<h4>参照を付加</h4>boost::add_reference<T>

T&型を返す

インクルード：
<boost/type_traits/add_reference.hpp>
<boost/type_traits.hpp>

例：
```cpp
add_reference<int>::type        : int&
add_reference<int const&>::type : int const&
add_reference<int*>::type       : int*&
add_reference<int*&>::type      : int*&
```

<h4>ポインタを付加</h4>boost::add_pointer<T>

T*型を返す

インクルード：
<boost/type_traits/add_pointer.hpp>
<boost/type_traits.hpp>

例：
```cpp
add_pointer<int>::type        : int*
add_pointer<int const&>::type : int const*
add_pointer<int*>::type       : int**
add_pointer<int*&>::type      : int**
```

<h4>条件式</h4>boost::conditional<Cond, Then, Else>

コンパイル時条件Condがtrueの場合はThen型を返し、それ以外の場合はElse型を返す。

インクルード：
<boost/type_traits/conditional.hpp>
<boost/type_traits.hpp>

例：
```cpp
conditional<true, int, char>::type  : int
conditional<false, int, char>::type : char
```

<h4>共通の型を取得</h4>boost::common_type<T...>

複数の型から、共通に変換可能な型を推定して返す。

インクルード：
<boost/type_traits/common_type.hpp>
<boost/type_traits.hpp>

例：
```cpp
template <class ...T>
typename common_type<T...>::type min(T... t);
```

<h4>推論される型の取得</h4>boost::decay<T>

template<class T> void f(T x);

によって推論される型を取得する。

```cpp
decay<int[2][3]>::type      : int[3]*
decay<int(&)[2]>::type      : int*
decay<int(&)(double)>::type : int(*)(double)
int(*)(double)              : int(*)(double)
int(double)                 : int(*)(double)
```

<h4>浮動小数点数型を昇格する</h4>booost::floating_point_promotion<T>

floatをdoubleなどに昇格。

インクルード：
<boost/type_traits/floating_point_promotion.hpp>
<boost/type_traits.hpp>

例：
```cpp
floating_point_promotion<float const>::type : double const
floating_point_promotion<float&>::type      : float&
floating_point_promotion<short>::type       : short
```

<h4>整数型を昇格する</h4>boost::integral_promotion<T>

shortをintなどに昇格。

インクルード：
<boost/type_traits/integral_promotion.hpp>
<boost/type_traits.hpp>

例：
```cpp
integral_promotion<short const>::type                 : int const
integral_promotion<short&>::type                      : short&
integral_promotion<enum std::float_round_style>::type : int
```

<h4>型を昇格する</h4>boost::promote<T>

整数型もしくは浮動小数点数型を昇格。

インクルード：
<boost/type_traits/promote.hpp>
<boost/type_traits.hpp>

例：
```cpp
promote<short volatile>::type : int volatile
promote<float const>::type    : double const
promote<short&>::type         : short&
```

<h4>符号なし型から符号あり型に変換</h4>boost::make_signed<T>

インクルード：
<boost/type_traits/make_signed.hpp>
<boost/type_traits.hpp>

例：
```cpp
make_signed<int>::type                      : int
make_signed<unsigned int const>::type       : int const
make_signed<const unsigned long long>::type : const long long
make_signed<my_enum>::type                  : enumと同じ幅を持つ符号付き整数型
make_signed<wchar_t>::type                  : wchar_tと同じ幅を持つ符号付き整数型
```

<h4>符号あり型から符号なし型に変換</h4>boost::make_unsigned<T>

インクルード：
<boost/type_traits/make_unsigned.hpp>
<boost/type_traits.hpp>

例：
```cpp
make_unsigned<int>::type                      : unsigned int
make_unsigned<unsigned int const>::type       : unsigned int const
make_unsigned<const unsigned long long>::type : const unsigned long long
make_unsigned<my_enum>::type                  : enumと同じ幅を持つ符号なし整数型
make_unsigned<wchar_t>::type                  : wchar_tと同じ幅を持つ符号なし整数型
```

<h4>配列の次元を削除</h4>boost::remove_extent<T>

インクルード：
<boost/type_traits/remove_extent.hpp>
<boost/type_traits.hpp>

例：
```cpp
remove_extent<int>::type          : int
remove_extent<int const[2]>::type : int const
remove_extent<int[2][4]>::type    : int[4]
remove_extent<int[][2]>::type     : int[2]
remove_extent<int const*>::type   : int const*
```

<h4>配列の次元を全て削除</h4>boost::remove_all_extents<T>

インクルード：
<boost/type_traits/remove_all_extents.hpp>
<boost/type_traits.hpp>

例：

```cpp
remove_all_extents<int>::type          : int
remove_all_extents<int const[2]>::type : int const
remove_all_extents<int[][2]>::type     : int
remove_all_extents<int[2][3][4]>::type : int
remove_all_extents<int const*>::type   : int const*



<h4>const修飾を削除</h4>boost::remove_const<T>

インクルード：
<boost/type_traits/remove_const.hpp>
<boost/type_traits.hpp>

例：
```cpp
remove_const<int>::type : int
remove_const<int const>::type : int
remove_const<int const volatile>::type : int volatile
remove_const<int const&>::type : int const&
remove_const<int const*>::type : int const*
```

<h4>const volatile修飾を削除</h4>boost::remove_cv<T>

インクルード：
<boost/type_traits/remove_cv.hpp>
<boost/type_traits.hpp>

例：
```cpp
remove_cv<int>::type                : int
remove_cv<int const>::type          : int
remove_cv<int const volatile>::type : int
remove_cv<int const&>::type         : int const&
remove_cv<int const*>::type         : int const*
```

<h4>ポインタを削除</h4>boost::remove_pointer<T>

インクルード：
<boost/type_traits/remove_pointer.hpp>
<boost/type_traits.hpp>

例：
```cpp
remove_pointer<int>::type         : int
remove_pointer<int const*>::type  : int const
remove_pointer<int const**>::type : int const*
remove_pointer<int&>::type        : int&
remove_pointer<int*&>::type       : int*&
```

<h4>参照を削除</h4>boost::remove_reference<T>

インクルード：
<boost/type_traits/remove_reference.hpp>
<boost/type_traits.hpp>

例：

```cpp
remove_reference<int>::type        : int
remove_reference<int const&>::type : int const
remove_reference<int&&>::type      : int
remove_reference<int*>::type       : int*
remove_reference<int*&>::type      : int*



<h4>volatile修飾を削除</h4>boost::remove_volatile<T>

インクルード：
<boost/type_traits/remove_volatile.hpp>
<boost/type_traits.hpp>

例：
```cpp
remove_volatile<int>::type                : int
remove_volatile<int volatile>::type       : int
remove_volatile<int const volatile>::type : int const
remove_volatile<int volatile&>::type      : int volatile&
remove_volatile<int volatile*>::type      : int volatile*
```

###特定アライメントを持った型の合成
<h4>特定のアライメントを持つ型の取得</h4>boost::type_with_alignment<Align>

インクルード：
<boost/type_traits/type_with_alignment.hpp>
<boost/type_traits.hpp>

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


実行結果：
```cpp
union boost::detail::lower_alignment<1>
```

<h4>適切にアライメントされた型を作成する</h4>boost::aligned_storage<Len, Align>

Alignアライメント、LenサイズのPOD型を返す。

インクルード：
<boost/type_traits/aligned_storage.hpp>
<boost/type_traits.hpp>

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
