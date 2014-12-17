#Date Generators / Algorithms

- [全体のインデックスへ](../date_time.md)
- [Gregorianのインデックスへ](./gregorian.md)
- [Posix Timeのインデックスへ](./posix_time.md)

**Date Generators / Algorithms**

- [Introduction](#introduction)
- [Header](#header)
- [Class Overview](#class-overview)


## <a name="introduction" href="#introduction">Introduction</a>
日付アルゴリズムあるいはジェネレータは、他の日付あるいは日付のスケジュールを生成するためのツールである。 生成関数は、月と日のような日付のある部分で始まり、その後、具体的な日付を生成するために残りの部分を供給される。 これは、プログラマが「2月の最初の日曜日」のような概念を表わし、次に、1つ以上の年を供給された時に日付の具体的なセットを生成することを想定している。

```cpp
using namespace boost::gregorian; 
typedef boost::date_time::nth_kday_of_month<date> nkday;
nkday ldgen(nkday::first, Monday, Sep)); // US labor day (アメリカ合衆国 労働者の日)
date labor_day = ldgen.get_date(2002); // 2002年の労働者の日を計算
```

[print holidays example](./print_holidays.cpp.md) に詳細な使い方の例を示す。


## <a name="header" href="#header">Header</a>

```cpp
#include "boost/date_time/date_generators.hpp" 
```


## <a name="class-overview" href="#class-overview">Class Overview</a>

| Class              | Construction Parameters    | get_date Parameter | Description | Example |
|--------------------|----------------------------|--------------------|-------------|---------|
| `first_kday_after`  | `greg_day_of_week day_of_week` | `date start_day` | 2002年1月1日以降の最初の日曜日のといったものを計算する | `first_kday_after fkaf(Monday);`<br/>`date d = fkaf.get_date(date(2002,Jan,1));//2002-Jan-07` |
| `first_kday_before` | `greg_day_of_week day_of_week` | `date start_day` | 2002年2月1日以前の最初の月曜日といったものを計算する | `first_kday_before fkbf(Monday);`<br/> `date d = fkbf.get_date(date(2002,Feb,1));//2002-Jan-28` |
| `last_kday_of_month` | `greg_day_of_week day_of_week`<br/> `greg_month month` | `greg_year year` | 1月最後の月曜日といったものを計算する | `last_kday_of_month lkm(Monday,Jan);`<br/>`date d = lkm.get_date(2002);//2002-Jan-28` |
| `first_kday_of_month` | `greg_day_of_week day_of_week`<br/> `greg_month month` | `greg_year year` | 1月最初の月曜日といったものを計算する | `first_kday_of_month fkm(Monday,Jan);`<br/>`date d = fkm.get_date(2002);//2002-Jan-07` |
| `partial_date` | `greg_month month`<br/>`greg_day day_of_month` | `greg_year year` | 月および日を与えられた日付に、年を適用することにより日付を生成する | `partial_date pd(Jan,1);`<br/> `date d = pd.get_date(2002);//2002-Jan-01` |


***
Last modified: Tue Sep 3 16:02:55 MST 2002 by [Jeff Garland](jeff@crystalclearsoftware.com) © 2000-2002 

Japanese Translation Copyright (C) 2003 [Shoji Shinohara](sshino@cppll.jp).

