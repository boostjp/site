#MPL

Contents
<ol class='goog-toc'><li class='goog-toc'>[<strong>1 </strong>シーケンス](#TOC--)</li><li class='goog-toc'>[<strong>2 </strong>イテレータ](#TOC--1)</li><li class='goog-toc'>[<strong>3 </strong>アルゴリズム](#TOC--2)<ol class='goog-toc'><li class='goog-toc'>[<strong>3.1 </strong>シーケンスを変更しない操作](#TOC--3)<ol class='goog-toc'><li class='goog-toc'>[<strong>3.1.1 </strong>find](#TOC-find)</li><li class='goog-toc'>[<strong>3.1.2 </strong>find_if](#TOC-find_if)</li></ol></li></ol></li><li class='goog-toc'>[<strong>4 </strong>データ型](#TOC--4)</li><li class='goog-toc'>[<strong>5 </strong>マクロ](#TOC--5)</li></ol>


参照サイト：[Boost．MPL リファレンス](http://www.boost.org/doc/libs/1_46_1/libs/mpl/doc/refmanual/refmanual_toc.html)

##シーケンス


##イテレータ

##アルゴリズム

###シーケンスを変更しない操作
<h4>find</h4>概要：
template<
      typename Sequence
    , typename T
    >
struct find
{
    typedef <i>unspecified </i>type;
};



Sequence 内で、最初に is_same<_,T>::value == true であるイテレータを返す。

インクルード：
#include <boost/mpl/find.hpp>

<span style='font-family:monospace;white-space:pre;line-height:normal'><span style='font-family:Arial,sans-serif;line-height:19px;white-space:normal'>例：
typedef vector<char,int,unsigned,long,unsigned long> types;
typedef find<types,unsigned>::type iter;

BOOST_MPL_ASSERT(( is_same< deref<iter>::type, unsigned > ));
BOOST_MPL_ASSERT_RELATION( iter::pos::value, ==, 2 );


</span></span>

<h4>find_if</h4>概要：
template<
      typename Sequence
    , typename Pred
    >
struct find_if
{
    typedef <i>unspecified </i>type;
};



Sequence 内で、最初に Pred を満たすイテレータを返す。

インクルード：
#include <boost/mpl/find_if.hpp>

例：
typedef vector<char,int,unsigned,long,unsigned long> types;
typedef find_if<types, is_same<_1,unsigned> >::type iter;

BOOST_MPL_ASSERT(( is_same< deref<iter>::type, unsigned > ));
BOOST_MPL_ASSERT_RELATION( iter::pos::value, ==, 2 );






<h4></h4>メタ関数

##データ型

##マクロ

