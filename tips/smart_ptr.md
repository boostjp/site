#リソースを自動的に解放する
リソースを自動的に解放するには、「スマートポインタ」と呼ばれるクラスを使用する。スマートポインタとは、newのように動的に確保したオブジェクトへのポインタを保持して、自動的に解放するものである。また、通常のポインタのように利用することが可能である。
Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>共有しないオブジェクトのスマートポインタ](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>参照カウント方式のスマートポインタ](#TOC--1)<ol class='goog-toc'><li class='goog-toc'>[<strong>2.1 </strong>shared_ptrで避けること](#TOC-shared_ptr-)</li><li class='goog-toc'>[<strong>2.2 </strong>解放の方法を自分で決める](#TOC--2)</li><li class='goog-toc'>[<strong>2.3 </strong>弱い参照](#TOC--3)</li></ol></li><li class='goog-toc'>[<strong>3 </strong>侵入型参照カウント方式のスマートポインタ](#TOC--4)</li></ol>



###共有しないオブジェクトのスマートポインタ
共有する必要がないnewで確保したオブジェクト、例えばローカルスコープでnewとdeleteを使うような状況では、scoped_ptr、scoped_arrayを使うことができる。scoped_ptrについて、以下の点に注意する。
- scoped_ptr同士のコピーは不可
- STLのコンテナで保持できない
- new []で確保した配列を保持することはできない
- 不完全型やvoidをテンプレート引数に与えることはできない
- 解放の方法を自分で決めることはできない共有する必要がないnew []で確保したオブジェクトを保持する場合はscoped_arrayを使う。デリーターがどうしても必要な場合はBoost.Interprocessのscoped_ptr/scoeped_arrayを使用すると良い。<b>scoped_ptrサンプル</b>```cpp
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

実行結果：
```cpp
3
destroy

<b>scoped_arrayサンプル</b>
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
* boost::scoped_ptr[color ff0000]
* // ここでpが自動的にdeleteされる[color ff0000]
* boost::scoped_array[color ff0000]
* // ここでpが自動的にdelete []される[color ff0000]

実行結果：
```cpp
0 1 2 3 4
```

###参照カウント方式のスマートポインタ
shared_ptrは主に動的に割り当てられてたオブジェクトへのポインタを保持して、shared_ptr内部の参照カウントによって管理するものである。確保したオブジェクトを指す最後のshared_ptrが破棄またはリセットされるときに解放される。shared_ptrは以下のことが可能である。
- STLのコンテナで保持すること
- テンプレート引数に不完全型やvoidを与えること
- 自分で解放の方法を決めること
- T *からU *に暗黙の型変換が可能なとき、shared_ptr<T>からshared_ptr<U>の暗黙の変換
- shared_ptr<T>からshared_ptr<void>の暗黙の変換
- shared_ptr<T>からshared_ptr<T const>の暗黙の変換new []によって確保されたオブジェクトはshared_arrayを使う。
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

実行結果：
```cpp
5
3
3
destroy

<h4>shared_ptrで避けること</h4>名前のない一時的なshared_ptrを使わないほうがよい。次の例を考える。
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
* boost::shared_ptr[color ff0000]
* boost::shared_ptr[color ff0000]
* // ここでp0もp1もvecも破棄されてp0で確保したオブジェクトがdeleteされる[color ff0000]

bad関数では関数の引数が評価される順序が不定である。new int( 2 )、g()の順に評価されたとき、g()が例外を送出するとshared_ptrのコンストラクタが呼ばれなくなり、確保したオブジェクトが解放されなくなってしまう。したがって、ok関数のように名前のあるスマートポインタに格納するとよい。<h4>解放の方法を自分で決める</h4>shared_ptr、shared_arrayは解放の方法を指定することが出来る。これによってdelete以外の解放するための関数の使用やそもそも解放しないことも可能である。
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

実行結果：
```cpp
5
call deleter
```
* free_deleter[color ff0000]
* // ここでdeleteの代わりにfree_deleterのoperator()が呼び出される[color ff0000]

<h4>弱い参照</h4>weak_ptrはshared_ptrに対する弱い参照で、shared_ptrの参照カウントを上げ下げせずにオブジェクトを指すものである。weak_ptr単独で用いられることはない。オブジェクトへのアクセスはweak_ptrのlock関数、shared_ptrのコンストラクタによって対応するshared_ptrを得ることで可能である。shared_ptrが破棄されていた場合における動作は、lock関数の場合は空のshared_ptrを返し、shared_ptrのコンストラクタの場合はbad_weak_ptrを送出する。

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


実験結果：
```cpp
5
deleted
```
* weak_ptr[color ff0000]
* lock[color ff0000]
* lock[color ff0000]

###侵入型参照カウント方式のスマートポインタ
intrusive_ptrはユーザがオブジェクトの参照カウンタを上げ下げしなければならないようなときに適用できる。オブジェクトに対応するintrusive_ptr_add_ref関数、intrusive_ptr_release関数を定義することによって、intrusive_ptrが自動的に参照カウンタの上げ下げを行う。
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
* boost::intrusive_pt[color ff0000]
* // ここでvecとptrが破棄され、それぞれobjectのreleaseが呼ばれてdeleteされる[color ff0000]

実行結果：
```cpp
exist
destroy

```
