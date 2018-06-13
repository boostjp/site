# The Boost Lambda Library

Copyright (c) 1999-2004 Jaakko Järvi, Gary Powell

The Boost Lambda Library is free software; Permission to copy, use, modify and distribute this software and its documentation is granted, provided this copyright notice appears in all copies.

---

## Table of Contents

- 1\. [In a nutshell](#introduction)
- 2\. [Getting Started](lambda/ar01s02.md)
	- 2\.1\. [Installing the library](lambda/ar01s02.md#id2790109)
	- 2\.2\. [Conventions used in this document](lambda/ar01s02.md#id2741935)
- 3\. [Introduction](lambda/ar01s03.md)
	- 3\. 1\. [Motivation](lambda/ar01s03.md#id2741989)
	- 3\. 2\. [Introduction to lambda expressions](lambda/ar01s03.md#id2742784)
- 4\. [Using the library](lambda/ar01s04.md)
	- 4\.1\. [Introductory Examples](lambda/ar01s04.md#sect_introductory_examples)
	- 4\.2\. [Parameter and return types of lambda functors](lambda/ar01s04.md#sect_parameter_and_return_types)
	- 4\.3\. [About actual arguments to lambda functors](lambda/ar01s04.md#sect_actual_arguments_to_lambda_functors)
	- 4\.4\. [Storing bound arguments in lambda functions](lambda/ar01s04.md#sect_storing_bound_arguments)
- 5\. [Lambda expressions in details](lambda/ar01s05.md)
	- 5\.1\. [Placeholders](lambda/ar01s05.md#sect_placeholders)
	- 5\.2\. [Operator expressions](lambda/ar01s05.md#sect_operator_expressions)
	- 5\.3\. [Bind expressions](lambda/ar01s05.md#sect_bind_expressions)
	- 5\.4\. [Overriding the deduced return type](lambda/ar01s05.md#sect_overriding_deduced_return_type)
	- 5\.5\. [Delaying constants and variables](lambda/ar01s05.md#sect_delaying_constants_and_variables)
	- 5\.6\. [Lambda expressions for control structures](lambda/ar01s05.md#sect_lambda_expressions_for_control_structures)
	- 5\.7\. [Exceptions](lambda/ar01s05.md#sect_exceptions)
	- 5\.8\. [Construction and destruction](lambda/ar01s05.md#sect_construction_and_destruction)
	- 5\.9\. [Special lambda expressions](lambda/ar01s05.md#id2805476)
	- 5\.10\. [Casts, sizeof and typeid](lambda/ar01s05.md#id2806049)
	- 5\.11\. [Nesting STL algorithm invocations](lambda/ar01s05.md#sect_nested_stl_algorithms)
- 6\. [Extending return type deduction system](lambda/ar01s06.md)
- 7\. [Practical considerations](lambda/ar01s07.md)
	- 7\.1\. [Performance](lambda/ar01s07.md#id2807564)
	- 7\.2\. [About compiling](lambda/ar01s07.md#id2808056)
	- 7\.3\. [Portability](lambda/ar01s07.md#id2808118)
- 8\. [Relation to other Boost libraries](lambda/ar01s08.md)
	- 8\.1\. [Boost Function](lambda/ar01s08.md#id2808509)
	- 8\.2\. [Boost Bind](lambda/ar01s08.md#id2808613)
- 9\. [Contributors](lambda/ar01s09.md)
- A\. [Rationale for some of the design decisions](lambda/apa.md)
	- 1\. [Lambda functor arity](lambda/apa.md#sect_why_weak_arity)
- [Bibliography](lambda/bi01.md)

## <a id="introduction">1. In a nutshell</a>

Boost Lambda Library(以降BLL)はC++においての *λ抽象* の型を実装したC++のテンプレートライブラリである。
この言葉はλ抽象によって無名の関数を定義する関数型言語やλ計算に由来する。
BLLの主な動機はSTLのアルゴリズムのための無名の関数オブジェクトを定義する柔軟で簡便な方法を提供することである。
このライブラリについて説明するにあたって、簡単なコードを見るほうが理解しやすい。
次の一行はあるSTLコンテナ `a` の要素を空白で区切って出力する。

```cpp
for_each(a.begin(), a.end(), std::cout << _1 << ' ');
```

`std::cout << _1 << ' '` は単項関数オブジェクトを定義している。
変数 `_1` はこの関数の仮引数であり、実引数のためのプレースホルダーである。
`for_each` の繰り返しのたびに、この関数は `a` の一つの要素を実引数として呼出される。
この実引数はプレースホルダーとして抽象化され、この関数の"本体"が評価される。

BLLの本質は上にあげたような小さな無名の関数オブジェクトを、STLアルゴリズムを呼出す位置で直接定義することを可能にすることである。

