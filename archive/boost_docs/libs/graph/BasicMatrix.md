# BasicMatrix
BasicMatrix のコンセプトは2次元のテーブルの要素にアクセスするための 最小限のインタフェースを提供する。


## Refinement of
なし


## 表記

| 識別子 | 説明 |
|--------|------|
| {M,I,V}  | 行列, インデックス, 値の型 で、BasicMatrix のコンセプトをモデル化する。 |
| `A`      | 型 `M` のオブジェクト。 |
| `i`, `j` | 型 `I` のオブジェクト。 |


## 関連型
なし


## 有効な表現式

| 式 | 説明 |
|----|------|
| `A[i][j]` | インデックス `(i,j)` にある要素オブジェクトへの参照を返す。<br/> 返値の型: mutable `A` に対しては、`V&`。 constant `A` に対しては、`const V&`。 |


## 計算量の保証
要素へのアクセスは定数時間で終了する。


## コンセプトチェックするクラス
```cpp
template <class M, class I, class V>
struct BasicMatrixConcept
{
  void constraints() {
    V& elt = A[i][j];
    const_constraints(A);
    ignore_unused_variable_warning(elt);      
  }
  void const_constraints(const M& A) {
    const V& elt = A[i][j];
    ignore_unused_variable_warning(elt);      
  }
  M A;
  I i, j;
};
```

***
Copyright © 2000-2001 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<mailto:jsiek@osl.iu.edu>)

Japanese Translation Copyright (C) 2003 KANAHORI Toshihiro <mailto:kanahori@k.tsukuba-tech.ac.jp>

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

