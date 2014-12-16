#Buffer Concept

Buffer とは、その中に何かしらアイテムを書き込んだり、削除したりできるものである。 Buffer のコンセプトは、ほとんど要求を持たない。 アイテムが格納の仕方や削除される時に関して、いかなる特定の順序付けも要求してはいないが、例によって、ソートに関しては順序付けのポリシーがいくつかある。


##表記

| 識別子 | 説明 |
|--------|------|
| `B`    | Buffer のモデルである型。 |
| `T`    | `B` の値の型。 |
| `t`    | `T` 型のオブジェクト。 |


##メンバ
Buffer をモデル化する型は、以下のメンバーを持たなければならない。

| メンバ | 説明 |
|--------|------|
| `value_type` | Buffer 内に格納されるオブジェクトの型。 その値の型は [Assignable](http://www.sgi.com/tech/stl/Assignable.html) でなければならない。 |
| `size_type`  | Buffer 内のオブジェクトの数を表す符号無し整数型。 |
| `void push(const T& t)` | `t` を Buffer 内に挿入する。 `size()` は 1 インクリメントされる。 |
| `void pop()`            | Buffer からオブジェクトを削除する。 `size()` は 1 デクリメントされる。<br/> 事前条件: `empty()` が `false` であること。 |
| `T& top()`              | Buffer 内のあるオブジェクトへの非 `const` な参照を返す。<br/> 事前条件: `empty()` が `false` であること。 |
| `const T& top() const`  | Buffer 内のあるオブジェクトへの `const` な参照を返す。<br/> 事前条件: `empty()` が `false` であること。 |
| `void size() const`     | Buffer 内のオブジェクトの数を返す。<br/> 不変式: `size() >= 0` |
| `bool empty() const`    | `b.size() == 0` と等価。 |


##計算量の保証
- `push()`、`pop()` と `size()` は Generalized Queue のサイズに関して、 高々線形時間の計算量でなければならない。
- `top()` と `empty()` は定数時間で終了しなければならない。


##モデル
- [`std::stack`](http://www.sgi.com/tech/stl/stack.html)
- `boost::mutable_queue`


***
Copyright © 2000-2001 [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University and C++ Library & Compiler Group/SGI (<jsiek@engr.sgi.com>)

