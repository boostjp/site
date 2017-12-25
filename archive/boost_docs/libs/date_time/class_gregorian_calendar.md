# gregorian::gregorian_calendar

- [全体のインデックスへ](../date_time.md)
- [Gregorianのインデックスへ](gregorian.md)
- [Posix Timeのインデックスへ](posix_time.md)

**Date Documentation**

- [Introduction](#introduction)
- [Header](#header)
- [Functions](#functions)


## <a id="introduction" href="#introduction">Introduction</a>
`boost::gregorian::gregorian_calendar` クラスは、グレゴリオ暦の日付システムを生成するのに必要な機能を実装する。 これは、年-月-日 形式の日付と日付番号表現との相互変換を行う。

このクラスは、主に [`gregorian::date`](class_date.md) によってアクセスされることを意図しており、ユーザによって直接使用される事はない。 しかしながら、`end_of_month_day`機能に役に立つ、有用な機能がある。

サンプル [print month](print_month.cpp.md) で、この例を説明している。


## <a id="header" href="#header">Header</a>
```cpp
#include "boost/date_time/gregorian/gregorian.hpp" //全ての型とI/Oを含む
```

もしくは

```cpp
#include "boost/date_time/gregorian/gregorian_types.hpp" //型のみでI/Oは含まない
```


## <a id="functions" href="#functions">Functions</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `static short day_of_week(ymd_type)` | 曜日を返す (0==Sunday, 1==Monday, etc) | 参照: `gregorian::date day_of_week` |
| `static date_int_type day_number(ymd_type)` | `ymd_type` を日付番号に変換する。日付番号は、エポック(Epoch)からの通算日数の絶対値である | |
| `static short end_of_month_day(year_type, month_type)` | 与えられた年と月から、その月の最終日を決定する | |
| `static ymd_type from_day_number(date_int_type)` | 日付番号を `ymd` 構造体に変換する | |
| `static bool is_leap_year(year_type)` | 指定した年がうるう年なら `true` を返す | `gregorian_calendar::is_leap_year(2000) --> true` |


***
Last modified: Wed Aug 28 17:52:03 MST 2002 by [Jeff Garland](mailto:jeff@crystalclearsoftware.com) © 2000-2002 

Japanese Translation Copyright (C) 2003 [Shoji Shinohara](mailto:sshino@cppll.jp).


