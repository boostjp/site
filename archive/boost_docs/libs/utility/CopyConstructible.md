#Copy Constructible

- 翻訳元ドキュメント : <http://www.boost.org/doc/libs/1_31_0/libs/utility/CopyConstructible.html>

##説明
オブジェクトのコピーが可能である場合、その型はCopy Constructibleである。


##表記
- `T`はCopy Constructibleモデルの型
- `t`は`T`型のオブジェクト
- `u`は`const T`型のオブジェクト


##定義
##妥当な式

| 名前 | 式 | 戻り値の型 | 意味論 |
|------|----|------------|--------|
| コピーコンストラクタ | `T(t)`   | `T`  | `t`は`T(t)`と同等である |
| コピーコンストラクタ | `T(u)`   | `T`  | `u`は`T(u)`と同等である |
| デストラクタ         | `t.~T()` | `T`  | |
| アドレス演算子       | `&t`     | `T*` | `t`のアドレスを意味する |
| アドレス演算子       | `&u`     | `T*` | `u`のアドレスを意味する |


##モデル
- `int`
- `std::pair`


##コンセプトチェックするクラス
```cpp
template <class T>
struct CopyConstructibleConcept
{
  void constraints() {
    T a(b);            // require copy constructor
    T* ptr = &a;       // require address of operator
    const_constraints(a);
    ignore_unused_variable_warning(ptr);
  }
  void const_constraints(const T& a) {
    T c(a);            // require const copy constructor
    const T* ptr = &a; // require const address of operator
    ignore_unused_variable_warning(c);
    ignore_unused_variable_warning(ptr);
  }
  T b;
};
```


##関連項目
[Default Constructible](http://www.sgi.com/tech/stl/DefaultConstructible.html) and [Assignable](Assignable.md)


***
Copyright © 2000 [Jeremy Siek](http://www.lsc.nd.edu/~jsiek), Univ.of Notre Dame (<mailto:jsiek@lsc.nd.edu>)

Japanese Translation Copyright © 2014 [Akira Takahashi](mailto:faithandbrave@gmail.com)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。


