# gcd_lcm - GCD and LCM

## はじめに

`detail/gcd_lcm.hpp` は2つの汎用整数アルゴリズムを提供する。
最大公約数と最小公倍数である。

## 梗概

```cpp
namespace details {
namespace pool {

template <typename Integer>
Integer gcd(Integer A, Integer B);

template <typename Integer>
Integer lcm(Integer A, Integer B);

} // namespace pool
} // namespace details
```

## 意味

**Symbol Table**

| Symbol | Meaning |
|---|---|
| `Integer` | An integral type |
| `A, B` | Values of type `Integer` |

**Semantics**

| Expression | Result Type | Precondition | Notes |
|---|---|---|---|
| `gcd(A, B)` | Integer | `A > 0 && B > 0` | `A` と `B` の最大公約数を返す。 |
| `lcm(A, B)` | Integer | `A > 0 && B > 0` | `A` と `B` の最小公倍数を返す。 |

## 実装上の注意

速度のため、`A > B`とする。

## 依存性

なし。

## 将来の方向性

このヘッダーは Boost algorithms library に置き換えられるかもしれない。

---

Copyright (c) 2000, 2001 Stephen Cleary ([shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright](../copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

