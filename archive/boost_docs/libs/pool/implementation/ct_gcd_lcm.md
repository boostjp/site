# ct_gcd_lcm - コンパイル時 GCD および LCM

## はじめに

`detail/ct_gcd_lcm.hpp` は2つのコンパイル時アルゴリズムを提供する。
最大公約数と最小公倍数である。

## 梗概

```cpp
namespace details {
namespace pool {

template <unsigned A, unsigned B>
struct ct_gcd
{
	static const unsigned value = ...;
};
template <unsigned A, unsigned B>
struct ct_lcm
{
	static const unsigned value = ...;
};

} // namespace pool
} // namespace details
```

## 意味

**Symbol Table**

| Symbol | Meaning |
|---|---|
| `A, B` | コンパイル時符号なし定整数 [5.19/1] |

**Semantics**

| Expression | Result Type | Value | Precondition |
|---|---|---|---|
| `ct_gcd<A, B>::value` | コンパイル時符号なし定整数 | `A` と `B` の最大公約数 | `A != 0 && B != 0` |
| `ct_lcm<A, B>::value` | コンパイル時符号なし定整数 | `A` と `B` の最小公倍数 | `A != 0 && B != 0` |

## 注意事項

コンパイル時アルゴリズムであるため、事前条件の違反はコンパイル時エラーを招く。

## 依存性

- `<boost/static_assert.hpp>` (see [Boost.Static_Assert](../../static_assert.md]), 事前条件が満たされていることを確認する
- `<boost/type_traits/ice.hpp>` (see Coding Guidelines for Integral Constant Expressions), 移植性の一助

## 標準文書からの抜粋

**5.19/1: Expressions: Constant Expressions:** ". . . *整定数式* は、リテラル(2.13)、列挙子、`const` 変数または定数式(8.5)で初期化された整数ないし列挙型の静的データメンバー、整数ないし列挙型の非型テンプレートパラメータ、`sizeof` 式のみを含むことができる。
浮動小数リテラル(2.13.3)は整数ないし列挙型にキャストされる場合のみ現れることができる。
整数ないし列挙型への型変換のみが使用できる。
特に、`sizeof` 式を除いて、関数、クラスオブジェクト、ポインタ、参照は使用できず、代入、増分、減分、関数呼び出し、カンマ演算子は使用できない。"

## 将来の方向性

このヘッダーは Boost compile-time algorithms ライブラリに置き換えられるかもしれない。

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright](../copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

