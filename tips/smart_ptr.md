# リソースを自動的に解放する
リソースを自動的に解放するには、「スマートポインタ」と呼ばれるクラスを使用する。スマートポインタとは、`new`のように動的に確保したオブジェクトへのポインタを保持して、自動的に解放するものである。また、通常のポインタのように利用することが可能である。


## インデックス
- [共有しないオブジェクトのスマートポインタ](#no-share-smart-pointer)
- [参照カウント方式のスマートポインタ](#share-smart-pointer)
    - [`shared_ptr`で避けること](#avoid-usage-shared-ptr)
    - [解放の方法を自分で決める](#customize-release-behavior-shared-ptr)
    - [弱い参照](#weak-reference)
- [侵入型参照カウント方式のスマートポインタ](#intrusive-pointer)


## <a name="no-share-smart-pointer" href="#no-share-smart-pointer">共有しないオブジェクトのスマートポインタ</a>
共有する必要がない`new`で確保したオブジェクト、例えばローカルスコープで`new`と`delete`を使うような状況では、`scoped_ptr`、`scoped_array`を使うことができる。`scoped_ptr`について、以下の点に注意する。

- `scoped_ptr`同士のコピーは不可
- 標準コンテナで保持できない
- `new []`で確保した配列を保持することはできない
- 不完全型や`void`をテンプレート引数に与えることはできない
- 解放の方法を自分で決めることはできない共有する必要がない`new []`で確保したオブジェクトを保持する場合は`scoped_array`を使う。デリーターがどうしても必要な場合はBoost.Interprocessの`scoped_ptr`/`scoeped_array`を使用すると良い。

`scoped_ptr`のサンプル：
```cpp
#include <iostream>
#include <boost/scoped_ptr.hpp>

struct object
{
    int num;

    object(int n) :
        num( n )
    { }

    ~object()
    {
        std::cout << "destroy" << std::endl;
    }
};

int main()
{
    boost::scoped_ptr<object> p( new object( 3 ) );

    // ポインタと同じように使うことが出来る
    std::cout << p->num << std::endl; 

} // ここでpが自動的にdeleteされる
```
* boost::scoped_ptr[color ff0000]
* // ここでpが自動的にdeleteされる[color ff0000]

実行結果：
```
3
destroy
```

`scoped_array`サンプル：
```cpp
#include <iostream>
#include <boost/scoped_array.hpp>

int main()
{
    const int N = 5;
    boost::scoped_array<int> p(new int[N]);

    // 通常の配列のように使うことが出来る
    for(int i = 0; i < N; ++i) {
        p[i] = i;
    }
    for(int i = 0; i < N; ++i) {
        std::cout << p[i] << " ";
    }
    std::cout << std::endl;
    
} // ここでpが自動的にdelete []される
```
* boost::scoped_array[color ff0000]
* // ここでpが自動的にdelete []される[color ff0000]

実行結果：
```
0 1 2 3 4
```

## <a name="share-smart-pointer" href="#share-smart-pointer">参照カウント方式のスマートポインタ</a>
`shared_ptr`は主に動的に割り当てられてたオブジェクトへのポインタを保持して、`shared_ptr`内部の参照カウントによって管理するものである。確保したオブジェクトを指す最後の`shared_ptr`が破棄またはリセットされるときに解放される。`shared_ptr`は以下のことが可能である。

- 標準コンテナで保持すること
- テンプレート引数に不完全型や`void`を与えること
- 自分で解放の方法を決めること
- `T*`から`U*`に暗黙の型変換が可能なとき、`shared_ptr<T>`から`shared_ptr<U>`の暗黙の変換
- `shared_ptr<T>`から`shared_ptr<void>`の暗黙の変換
- `shared_ptr<T>`から`shared_ptr<T const>`の暗黙の変換`new []`によって確保されたオブジェクトは`shared_array`を使う。

```cpp
#include <iostream>
#include <vector>
#include <boost/shared_ptr.hpp>

struct object
{
    int num;

    object(int n) :
        num( n )
    { }

    ~object()
    {
        std::cout << "destroy" << std::endl;
    }
};

int main()
{
    boost::shared_ptr<object> p0(new object(5));

    // ポインタのように使うことが出来る
    std::cout << p0->num << std::endl;

    // p1はp0と同じオブジェクトを指すshared_ptr
    boost::shared_ptr<object> p1(p0);
    p1->num = 3;
    std::cout << p0->num << std::endl;

    // STLで保持することも可能
    std::vector<boost::shared_ptr<object> > vec;
    vec.push_back(p1);
    std::cout << vec.front()->num << std::endl;
    
} // ここでp0もp1もvecも破棄されてp0で確保したオブジェクトがdeleteされる
```
* boost::shared_ptr[color ff0000]
* // ここでp0もp1もvecも破棄されてp0で確保したオブジェクトがdeleteされる[color ff0000]

実行結果：
```
5
3
3
destroy
```

### <a name="avoid-usage-shared-ptr" href="#avoid-usage-shared-ptr">shared_ptrで避けること</a>
名前のない一時的な`shared_ptr`オブジェクトは使わないほうがよい。次の例を考える。

```cpp
void f(boost::shared_ptr<int>, int);
void g(); // 例外を送出する可能性がある関数

void ok()
{
    boost::shared_ptr<int> p(new int(2));
    f(p, g());
}

void bad()
{
    f(boost::shared_ptr<int>(new int(2)), g());
}
```
* boost::shared_ptr[color ff0000]

`bad()`関数では関数の引数が評価される順序が不定である。`new int( 2 )`、`g()`の順に評価されたとき、`g()`が例外を送出すると`shared_ptr`のコンストラクタが呼ばれなくなり、確保したオブジェクトが解放されなくなってしまう。したがって、`ok()`関数のように名前のあるスマートポインタに格納するとよい。


### <a name="customize-release-behavior-shared-ptr" href="#customize-release-behavior-shared-ptr">解放の方法を自分で決める</a>
`shared_ptr`、`shared_array`は解放の方法を指定することが出来る。これによって`delete`以外の解放するための関数の使用やそもそも解放しないことも可能である。

```cpp
#include <iostream>
#include <cstdlib>
#include <boost/shared_ptr.hpp>

struct free_deleter
{
    template <class T>
    void operator()(T *p) const
    {
        std::free(static_cast<void *>(p));
        std::cout << "call deleter" << std::endl;
    }
};

int main()
{
    boost::shared_ptr<int> p(static_cast<int *>(std::malloc(sizeof(int))), free_deleter());
    *p = 5;
    std::cout << *p << std::endl;

} // ここでdeleteの代わりにfree_deleterのoperator()が呼び出される
```
* free_deleter[color ff0000]
* // ここでdeleteの代わりにfree_deleterのoperator()が呼び出される[color ff0000]

実行結果：
```
5
call deleter
```

### <a name="weak-reference" href="#weak-reference">弱い参照</a>
`weak_ptr`は`shared_ptr`に対する弱い参照で、`shared_ptr`の参照カウントを上げ下げせずにオブジェクトを指すものである。`weak_ptr`単独で用いられることはない。オブジェクトへのアクセスは`weak_ptr`の`lock()`メンバ関数、`shared_ptr`のコンストラクタによって対応する`shared_ptr`を得ることで可能である。`shared_ptr`が破棄されていた場合における動作は、`lock()`メンバ関数の場合は空の`shared_ptr`を返し、`shared_ptr`のコンストラクタの場合は`bad_weak_ptr`例外を送出する。

```cpp
#include <iostream>
#include <boost/shared_ptr.hpp>
#include <boost/weak_ptr.hpp>

int main()
{
    boost::shared_ptr<int> sp( new int( 5 ) );
    boost::weak_ptr<int> wp( sp );

    // shared_ptrのオブジェクトがあるかないか
    if( boost::shared_ptr<int> p = wp.lock() ) {
        std::cout << *p << std::endl;
    }
    else {
        std::cout << "deleted" << std::endl;
    }

    // ここで解放する
    sp.reset();

    // shared_ptrのオブジェクトがあるかないか
    if( boost::shared_ptr<int> p = wp.lock() ) {
        std::cout << *p << std::endl;
    }
    else {
        std::cout << "deleted" << std::endl; 
    }
}
```
* weak_ptr[color ff0000]
* lock[color ff0000]

実験結果：
```
5
deleted
```


### <a name="intrusive-smart-pointer" href="#intrusive-smart-pointer">侵入型参照カウント方式のスマートポインタ</a>
`intrusive_ptr`はユーザがオブジェクトの参照カウンタを上げ下げしなければならないようなときに適用できる。オブジェクトに対応する`intrusive_ptr_add_ref()`関数、`intrusive_ptr_release()`関数を定義することによって、`intrusive_ptr`が自動的に参照カウンタの上げ下げを行う。

```cpp
#include <iostream>
#include <vector>
#include <boost/intrusive_ptr.hpp>

namespace hoge {

    class object
    {
        int cnt_;
        
        object() :
            cnt_(1)
        { }

    public:
        ~object()
        {
            std::cout << "destroy" << std::endl;
        }

        void print() const
        {
            std::cout << "exist" << std::endl;
        }

        void add_ref()
        {
            ++cnt_;
        }

        void release()
        {
            if(--cnt_ == 0) {
                delete this;
            }
        }

        friend object *create();
    };

    object *create()
    {
        return new object;
    }

    void intrusive_ptr_add_ref(object *p)
    {
        p->add_ref();
    }

    void intrusive_ptr_release(object *p)
    {
        p->release();
    }
}

int main()
{
    // 第2引数はコンストラクト時に参照カウントを増加させるかどうか
    boost::intrusive_ptr<hoge::object> ptr(hoge::create(), false);

    // コンテナに入れても大丈夫
    std::vector<boost::intrusive_ptr<hoge::object> > vec;
    vec.push_back(ptr);
       
    ptr->print();
    
} // ここでvecとptrが破棄され、それぞれobjectのreleaseが呼ばれてdeleteされる
```
* intrusive_ptr_add_ref[color ff0000]
* intrusive_ptr_release[color ff0000]
* boost::intrusive_ptr[color ff0000]
* // ここでvecとptrが破棄され、それぞれobjectのreleaseが呼ばれてdeleteされる[color ff0000]

実行結果：
```
exist
destroy
```

