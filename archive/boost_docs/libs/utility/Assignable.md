#Assignable

##説明
その型のオブジェクトから、その型の他のオブジェクトに代入が可能である場合、その型はAssignableである。


##表記
- `T`はAssignableモデルの型
- `t`は`T`型のオブジェクト
- `u`は`T`型のオブジェクト、もしくは可能であれば`const T`型のオブジェクト


##定義

##妥当な式

| 名前 | 式 | 戻り値の型 | 意味論 |
|------|----|------------|--------|
| 代入 | `t = u` | `T&` | `t`は`u`と同等である |


##モデル
- `int`
- `std::pair`


##関連項目
[DefaultConstructible](http://www.sgi.com/tech/stl/DefaultConstructible.html) and [CopyConstructible](./copy_constructible.md)


***
Copyright © 2000 [Jeremy Siek](http://www.lsc.nd.edu/~jsiek), Univ.of Notre Dame (<jsiek@lsc.nd.edu>)

Japanese Translation Copyright © 2014 [Akira Takahashi](faithandbrave@gmail.com)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。


