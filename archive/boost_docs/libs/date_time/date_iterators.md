#gregorian::date iterators

- [全体のインデックスへ](../date_time.md)
- [Gregorianのインデックスへ](gregorian.md)
- [Posix Timeのインデックスへ](posix_time.md)

**Date Documentation**

- [Introduction](#introduction)
- [Header](#header)
- [Class Overview](#class-overview)


## <a name="introduction" href="#introduction">Introduction</a>
日付イテレータは、日単位で反復するための標準的なメカニズムを提供する。 日付イテレータは(STLの)[入力イテレータ](http://www.sgi.com/tech/stl/InputIterator.html)のモデルであり、日付と他の日付生成タスクで集合を代入するために使われる。 例えば、[print month の例](print_month.cpp.md)では、1ヶ月の全ての日々を反復し、それらをプリントする。

ここにあるイテレータは全て `boost::gregorian::date_iterator` からの派生である。


## <a name="header" href="#header">Header</a>
```cpp
#include "boost/date_time/gregorian/gregorian.hpp" //全ての型とI/Oを含む
```

もしくは

```cpp
#include "boost/date_time/gregorian/gregorian_types.hpp" //型のみでI/Oは含まない
```


## <a name="class-overview" href="#class-overview">Class Overview</a>

| Class | Construction Parameters | Description |
|-------|-------------------------|-------------|
| `date_iterator` | | 全ての日付単位イテレータに共通な基底クラス |
| `day_iterator`  | `date start_date, int day_count=1` | `day_count` 日単位で反復する |
| `week_iterator` | `date start_date, int week_offset=1` | `week_offset` 週単位で反復する |
| `month_iterator` | `date start_date, int month_offset=1` | month_offset 月単位で反復する。<br/> 月末の取り扱いについては、特別な規則がある。 それは、最初の日が月の最終日であるときは、常にその月の最終日に合わせて調整されるというものである。 日付がその月末を越えている場合(例: 1月31日+1ヶ月)、月の最終日に合わせて調整される。 |
| `year_iterator`  | `date start_date, int year_offset=1` | `year_offset` 年単位で反復する |


***
Last modified: Wed Aug 28 17:52:03 MST 2002 by [Jeff Garland](mailto:jeff@crystalclearsoftware.com) © 2000-2002 

Japanese Translation Copyright (C) 2003 [Shoji Shinohara](mailto:sshino@cppll.jp).


