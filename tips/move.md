#ムーブ可能なクラスを定義する
Boost1.49から導入されたBoost.Moveライブラリを使用することで、

C++03環境でもムーブセマンティクスをエミュレートし、

C++11とC++03の両方でムーブセマンティクスが使用できるポータブルなコードを書くことができる。

(TODO： エミュレーションの制限を書く)




Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>コピー可能／ムーブ可能なクラスを定義する](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>ムーブ可能な基底クラス／メンバ変数を使用する](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>コピー不可／ムーブ可能なクラスを定義する](#TOC--2)</li><li class='goog-toc'>[<strong>4 </strong>ムーブセマンティクスに対応したコンテナを使用する](#TOC--3)</li><li class='goog-toc'>[<strong>5 </strong>エミュレーションの制限](#TOC--4)</li></ol>






<h4>コピー可能／ムーブ可能なクラスを定義する</h4>



- クラス宣言のprivateセクションにBOOST_COPYABLE_AND_MOVABLE(クラス名)を置く。

- クラスの型のconst参照を引数に取るコピーコンストラクタを定義する。

- BOOST_COPY_ASSIGN_REF(クラス名)を引数に取るコピー代入演算子を定義する。

- BOOST_RV_REF(クラス名)を引数に取るムーブコンストラクタとムーブ代入演算子を定義する。

```cpp
template <class T>

class clone_ptr

{

    private:

    //コピー可能／ムーブ可能であることを示す

    BOOST_COPYABLE_AND_MOVABLE(clone_ptr)
```

`    T* ptr;`


`    public:`

`    //コンストラクタ`

`    explicit clone_ptr(T* p = 0) : ptr(p) {}`


`    //コンストラクタ`

`    ~clone_ptr() { delete ptr; }`


`    //コピーセマンティクス`


`    //コピーコンストラクタ(クラスの型のconst参照を引数にとる)`

`    clone_ptr(const clone_ptr& p)`

`        : ptr(p.ptr ? p.ptr->clone() : 0) {}`


`    // コピー代入演算子(BOOST_COPY_ASSIGN_REF(クラス名)を引数に取る)`

`    clone_ptr& operator=(BOOST_COPY_ASSIGN_REF(clone_ptr) p)`

`    {`

`        if (this != &p){`

`            T *tmp_p = p.ptr ? p.ptr->clone() : 0;`

`            delete ptr;`

`            ptr = tmp_p;`

`        }`

`        return *this;`

`    }`


`    //ムーブセマンティクス`


`    //ムーブコンストラクタ(BOOST_RV_REF(クラス名)を引数に取る)`

`    clone_ptr(BOOST_RV_REF(clone_ptr) p)`

`        : ptr(p.ptr) { p.ptr = 0; }`


`    //ムーブ代入演算子(BOOST_RV_REF(クラス名)を引数に取る)`

`    clone_ptr& operator=(BOOST_RV_REF(clone_ptr) p)`

`    {`

`        if (this != &p){`

`            delete ptr;`

`            ptr = p.ptr;`

`            p.ptr = 0;`

`        }`

`        return *this;`

`    }`

`};`


※ なにもリソースを保持していないクラス(例えばstd::complexなど)は自分でコピーコンストラクタを定義する必要ない。

(コンパイラがデフォルトで最適なコピーコンストラクタを定義するため)

<h4>ムーブ可能な基底クラス／メンバ変数を使用する</h4>
クラスのムーブコンストラクタ／ムーブ代入演算子が呼ばれる際に、適切に基底クラス、メンバ変数のムーブコンストラクタ／ムーブ代入演算子が呼ばれるようにする。




```cpp
class Base

{

    BOOST_COPYABLE_AND_MOVABLE(Base)
```

`    public:`

`    Base(){}`


`    Base(const Base &x) {/**/}             // コピーコンストラクタ`


`    Base(BOOST_RV_REF(Base) x) {/**/}      // ムーブコンストラクタ`


`    Base& operator=(BOOST_RV_REF(Base) x)`

`    {/**/ return *this;}                   // ムーブ代入演算子`


`    Base& operator=(BOOST_COPY_ASSIGN_REF(Base) x)`

`    {/**/ return *this;}                   // コピー代入演算子`


`    virtual Base *clone() const`

`    {  return new Base(*this);  }`


`    virtual ~Base(){}`

`};`


`class Member`

`{`

`    BOOST_COPYABLE_AND_MOVABLE(Member)`


`    public:`

`    Member(){}`


`    // コンパイラが生成したコピーコンストラクタ...`


`    Member(BOOST_RV_REF(Member))  {/**/}      // ムーブコンストラクタ`

`   `

`    Member &operator=(BOOST_RV_REF(Member))   // ムーブ代入演算子`

`    {/**/ return *this;  }`


`    Member &operator=(BOOST_COPY_ASSIGN_REF(Member))   // コピー代入演算子`

`    {/**/ return *this;  }`

`};`


`class Derived : public Base`

`{`

`    BOOST_COPYABLE_AND_MOVABLE(Derived)`

`    Member mem_;`


`    public:`

`    Derived(){}`


`    // コンパイラが生成したコピーコンストラクタ...`


`    Derived(BOOST_RV_REF(Derived) x)             // ムーブコンストラクタ`

`        : Base(boost::move(static_cast<Base&>(x))),`

`            mem_(boost::move(x.mem_)) { }`


`    Derived& operator=(BOOST_RV_REF(Derived) x)  // ムーブ代入演算子`

`    {`

`        Base::operator=(boost::move(static_cast<Base&>(x)));`

`        mem_  = boost::move(x.mem_);`

`        return *this;`

`    }`


`    Derived& operator=(BOOST_COPY_ASSIGN_REF(Derived) x)  // コピー代入演算子`

`    {`

`        Base::operator=(static_cast<const Base&>(x));`

`        mem_  = x.mem_;`

`        return *this;`

`    }`

`    // ...`

`};`

※ C++03のコンパイラでのエミュレーションによるムーブセマンティクスの制限として、

上記のムーブコンストラクタではムーブの直前にBase &へキャストする必要がある。

(これによって正しくBaseクラスのムーブコンストラクタが呼ばれるようになる)



<h4>コピー不可／ムーブ可能なクラスを定義する</h4>

unique_ptrやthreadなど、コピー不可／ムーブ可能なクラスを、

Boost.Moveを使用して定義できる。



- クラスのprivateセクションにBOOST_MOVABLE_BUT_NOT_COPYABLE(クラス名)を置く。

- BOOST_RV_REF(クラス名)を引数に取るムーブコンストラクタとムーブ代入演算子を定義する。





```cpp
#include <boost/move/move.hpp>

#include <stdexcept>
```

`class file_descriptor`

`{`

`    int os_descr_;`


`    private:`

`    //コピー不可／ムーブ可能であることを示す`

`    BOOST_MOVABLE_BUT_NOT_COPYABLE(file_descriptor)`


`    public:`

`    //コンストラクタ`

`    explicit file_descriptor(const char *filename = 0)`

`        : os_descr_(filename ? operating_system_open_file(filename) : 0)`

`    {  if(!os_descr_) throw std::runtime_error("file not found");  }`


`    //デストラクタ`

`    ~file_descriptor()`

`    {  if(!os_descr_)  operating_system_close_file(os_descr_);  }`


`    //ムーブコンストラクタ(BOOST_RV_REF(クラス名)を引数に取る)`

`    file_descriptor(BOOST_RV_REF(file_descriptor) x)`

`        :  os_descr_(x.os_descr_)`

`    {  x.os_descr_ = 0;  }`


`    //ムーブ代入演算子(BOOST_RV_REV(クラス名)を引数に取る)`

`    file_descriptor& operator=(BOOST_RV_REF(file_descriptor) x)`

`    {`

`        if(!os_descr_) operating_system_close_file(os_descr_);`

`        os_descr_   = x.os_descr_;`

`        x.os_descr_ = 0;`

`        return *this;`

`    }`


`    bool empty() const   {  return os_descr_ == 0;  }`

`};`


<h4>ムーブセマンティクスに対応したコンテナを使用する</h4>

Boost.Containerなど、ムーブセマンティクスに対応したコンテナを使用すると、

コピー不可／ムーブ可能なクラスをコンテナに入れて扱える。





```cpp
#include <boost/container/vector.hpp>

#include <cassert>
```

`//'file_descriptor'クラスはコピー不可であるが、`

`//ムーブセマンティクスのおかげで関数から返すことが可能である`

`file_descriptor create_file_descriptor(const char *filename)`

`{  return file_descriptor(filename);  }`


`int main()`

`{`

`    //ファイルを開いてディスクリプタを取得する`

`    //'create_file_descriptor'から返される一時オブジェクトは'fd'にムーブされる`

`    file_descriptor fd = create_file_descriptor("filename");`

`    assert(!fd.empty());`


`    //fdをvectorの中へmoveする`

`    boost::container::vector<file_descriptor> v;`

`    v.push_back(boost::move(fd));`


`    //所有権が移動したことを確認`

`    assert(fd.empty());`

`    assert(!v[0].empty());`


`    //file_descriptorがコピー不可であり、vectorのコピーコンストラクタは`

`    //value_typeのコピーコンストラクタを要求するので、`

`    //以下のコメントアウトを外すとコンパイルエラーが発生する`

`    //boost::container::vector<file_descriptor> v2(v);`

`    return 0;`

`}`



<h4>エミュレーションの制限</h4>To be written...

