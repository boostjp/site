#リファレンス

1. [関数](#functions)
2. [マクロ](#macros)
3. [基本コンセプト･チェック用クラス](#basic-concepts)
4. [イテレータ･コンセプト･チェック用クラス](#iterator-concepts)
5. [関数オブジェクト・コンセプト･チェック用クラス](#function-object-concepts)
6. [コンテナ･コンセプト･チェック用クラス](#container-concepts)
7. [基本原型クラス](#basic-archetype)
8. [イテレータ原型クラス](#iterator-archetype)
9. [関数オブジェクト原型クラス](#function-object-archetype)
10. [コンテナ原型クラス](#container-archetype)


## <a name="functions" href="functions">関数</a>
```cpp
template <class Concept>
void function_requires();
```

## <a name="macros" href="macros">マクロ</a>
```cpp
// クラス定義内でコンセプト・チェックに適用する
BOOST_CLASS_REQUIRE(type, namespace-of-concept, concept);
BOOST_CLASS_REQUIRE2(type1, type2, namespace-of-concept, concept);
BOOST_CLASS_REQUIRE3(type1, type2, type3, namespace-of-concept, concept);
BOOST_CLASS_REQUIRE4(type1, type2, type3, type4, namespace-of-concept, concept);
```
* type[italic]
* type1[italic]
* type2[italic]
* type3[italic]
* type4[italic]
* namespace-of-concept[italic]
* concept[italic]

推奨されないマクロ：

```cpp
// クラス定義内でコンセプト・チェックに適用する
BOOST_CLASS_REQUIRES(type, concept);
BOOST_CLASS_REQUIRES2(type1, type2, concept);
BOOST_CLASS_REQUIRES3(type1, type2, type3, concept);
BOOST_CLASS_REQUIRES4(type1, type2, type3, type4, concept);
```
* type[italic]
* type1[italic]
* type2[italic]
* type3[italic]
* type4[italic]
* concept[italic]


## <a name="basic-concepts" href="basic-concepts">基本コンセプト・チェック用クラス</a>
```cpp
template <class T>
struct IntegerConcept; // T は組み込み整数型であるか？

template <class T>
struct SignedIntegerConcept; // T は組み込み符号付き整数型であるか？

template <class T>
struct UnsignedIntegerConcept; // T は組み込み符号無し整数型であるか？

template <class X, class Y>
struct ConvertibleConcept; // X は Y へ変換可能か？

template <class T>
struct AssignableConcept; // 規格 23.1 参照

template <class T>
struct SGIAssignableConcept;

template <class T>
struct DefaultConstructibleConcept;

template <class T> 
struct CopyConstructibleConcept; // 規格 20.1.3 参照

template <class T> 
struct EqualityComparableConcept; // 規格 20.1.1 参照

template <class T>
struct LessThanComparableConcept; // 規格 20.1.2 参照

template <class T>
struct ComparableConcept; // SGI STL LessThanComparable コンセプト
```
* Assignable[link http://www.boost.org/doc/libs/1_31_0/libs/utility/Assignable.html]
* SGIAssignable[link http://www.sgi.com/tech/stl/Assignable.html]
* DefaultConstructible[link http://www.sgi.com/tech/stl/DefaultConstructible.html]
* CopyConstructible[link http://www.boost.org/doc/libs/1_31_0/libs/utility/CopyConstructible.html]
* EqualityComparable[link http://www.sgi.com/tech/stl/EqualityComparable.html]
* LessThanComparable[link http://www.boost.org/doc/libs/1_31_0/libs/utility/LessThanComparable.html]
* SGI STL LessThanComparable[link http://www.sgi.com/tech/stl/LessThanComparable.html]


## <a name="iterator-concepts" href="iterator-concepts">イテレータ･コンセプト･チェック用クラス</a>
```cpp
template <class Iter>
struct TrivialIteratorConcept;

template <class Iter>
struct Mutable_TrivialIteratorConcept;

template <class Iter>
struct InputIteratorConcept; // 規格24.1.1 Table 72参照

template <class Iter, class T> 
struct OutputIteratorConcept; // 規格24.1.2 Table 73参照

template <class Iter> 
struct ForwardIteratorConcept; // 規格24.1.3 Table 74参照

template <class Iter> 
struct Mutable_ForwardIteratorConcept;

template <class Iter> 
struct BidirectionalIteratorConcept; // 規格24.1.4 Table 75参照

template <class Iter> 
struct Mutable_BidirectionalIteratorConcept;

template <class Iter> 
struct RandomAccessIteratorConcept; // 規格24.1.5 Table 76参照

template <class Iter> 
struct Mutable_RandomAccessIteratorConcept;
```
* TrivialIterator[link http://www.sgi.com/tech/stl/trivial.html]
* InputIterator[link http://www.sgi.com/tech/stl/InputIterator.html]
* OutputIterator[link http://www.sgi.com/tech/stl/OutputIterator.html]
* ForwardIterator[link http://www.sgi.com/tech/stl/ForwardIterator.html]
* BidirectionalIterator[link http://www.sgi.com/tech/stl/BidirectionalIterator.html]
* RandomAccessIterator[link http://www.sgi.com/tech/stl/RandomAccessIterator.html]


## <a name="function-object-concepts" href="function-object-concepts">関数オブジェクト・コンセプト･チェック用クラス</a>
```cpp
template <class Func, class Return>
struct GeneratorConcept;

template <class Func, class Return, class Arg>
struct UnaryFunctionConcept;

template <class Func, class Return, class First, class Second>
struct BinaryFunctionConcept;

template <class Func, class Arg>
struct UnaryPredicateConcept;

template <class Func, class First, class Second>
struct BinaryPredicateConcept;

template <class Func, class First, class Second>
struct Const_BinaryPredicateConcept;

template <class Func, class Return>
struct AdaptableGeneratorConcept;

template <class Func, class Return, class Arg>
struct AdaptableUnaryFunctionConcept;

template <class Func, class First, class Second>
struct AdaptableBinaryFunctionConcept;

template <class Func, class Arg>
struct AdaptablePredicateConcept;

template <class Func, class First, class Second>
struct AdaptableBinaryPredicateConcept;
```

## <a name="container-concepts" href="container-concepts">コンテナ･コンセプト･チェック用クラス</a>
```cpp
template <class C>
struct ContainerConcept; // 規格 23.1 Table 65 参照

template <class C>
struct Mutable_ContainerConcept;

template <class C>
struct ForwardContainerConcept;

template <class C>
struct Mutable_ForwardContainerConcept;

template <class C>
struct ReversibleContainerConcept; // 規格 23.1 Table 66 参照

template <class C>
struct Mutable_ReversibleContainerConcept;

template <class C>
struct RandomAccessContainerConcept;

template <class C>
struct Mutable_RandomAccessContainerConcept;

template <class C>
struct SequenceConcept; // 規格 23.1.1 参照

template <class C>
struct FrontInsertionSequenceConcept;

template <class C>
struct BackInsertionSequenceConcept;

template <class C>
struct AssociativeContainerConcept; // 規格 23.1.2 Table 69 参照

template <class C>
struct UniqueAssociativeContainerConcept;

template <class C>
struct MultipleAssociativeContainerConcept;

template <class C>
struct SimpleAssociativeContainerConcept;

template <class C>
struct PairAssociativeContainerConcept;

template <class C>
struct SortedAssociativeContainerConcept;
```
* Container[link http://www.sgi.com/tech/stl/Container.html]
* ForwardIterator[link http://www.sgi.com/tech/stl/ForwardContainer.html]
* ReversibleContainer[link http://www.sgi.com/tech/stl/ReversibleContainer.html]
* RandomAccessContainer[link http://www.sgi.com/tech/stl/RandomAccessContainer.html]
* Sequence[link http://www.sgi.com/tech/stl/SequenceContainer.html]
* FrontInsertionSequence[link http://www.sgi.com/tech/stl/FrontInsertionSequence.html]
* BackInsertionSequence[link http://www.sgi.com/tech/stl/BackInsertionSequence.html]
* AssociativeContainer[link http://www.sgi.com/tech/stl/Associative.html]
* UniqueAssociativeContainer[link http://www.sgi.com/tech/stl/UniqueAssociativeContainer.html]
* MultipleAssociativeContainer[link http://www.sgi.com/tech/stl/MultipleAssociativeContainer.html]
* SimpleAssociativeContainer[link http://www.sgi.com/tech/stl/SimpleAssociativeContainer.html]
* PairAssociativeContainer[link http://www.sgi.com/tech/stl/PairAssociativeContainer.html]
* SortedAssociativeContainer[link http://www.sgi.com/tech/stl/SortedAssociativeContainer.html]


## <a name="basic-archetype" href="basic-archetype">基本原型クラス</a>
```cpp
template <class T = int>
class null_archetype; // モデル化するコンセプトが無いことを示す型

template <class Base = null_archetype>
class default_constructible_archetype;

template <class Base = null_archetype>
class assignable_archetype;

template <class Base = null_archetype>
class copy_constructible_archetype;

template <class Base = null_archetype>
class equality_comparable_archetype;

template <class T, class Base = null_archetype>
class convertible_to_archetype;
```


## <a name="iterator-archetype" href="iterator-archetype">イテレータ原型クラス</a>
```cpp
template <class ValueType>
class trivial_iterator_archetype;

template <class ValueType>
class mutable_trivial_iterator_archetype;

template <class ValueType>
class input_iterator_archetype;

template <class ValueType>
class forward_iterator_archetype;

template <class ValueType>
class bidirectional_iterator_archetype;

template <class ValueType>
class random_access_iterator_archetype;
```


## <a name="function-object-archetype" href="function-object-archetype">関数オブジェクト原型クラス</a>
```cpp
template <class Arg, class Return>
class unary_function_archetype;

template <class Arg1, class Arg2, class Return>
class binary_function_archetype;

template <class Arg>
class predicate_archetype;

template <class Arg1, class Arg2>
class binary_predicate_archetype;
```


## <a name="container-archetype" href="container-archetype">コンテナ原型クラス</a>
構築中


- [「はじめに」へ戻る](./concept_check.md)
- [前へ：「コンセプト・チェックの実装」](./implementation.md)

***
Copyright © 2000 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm)(<jsiek@osl.iu.edu>) Andrew Lumsdaine(<lums@osl.iu.edu>)

