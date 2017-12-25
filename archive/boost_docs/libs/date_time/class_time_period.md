# posix_time::time_period

- [全体のインデックスへ](../date_time.md)
- [Gregorianのインデックスへ](gregorian.md)
- [Posix Timeのインデックスへ](posix_time.md)

**Time Period Documentation**

- [Introduction](#introduction)
- [Header](#header)
- [Construction](#construction)
- [Accessors](#accessors)
- [Conversion To String](#conversion-to-string)
- [Operators](#operators)


## <a id="introduction" href="#introduction">Introduction</a>
クラス `boost::posix_time::time_period` は2つの時刻の範囲を直接表現する。 期間(period)は、プログラムの条件付きの論理を単純化することによって、ある種の計算を単純化する能力を提供する。

[time periods example](time_periods.cpp.md) は `time_period` の使用例を提供する。


## <a id="header" href="#header">Header</a>
```cpp
#include "boost/date_time/posix_time/posix_time.hpp" //全ての型とI/Oを含む
```

もしくは

```cpp
#include "boost/date_time/posix_time/posix_time_types.hpp" //型のみでI/Oは含まない
```


## <a id="construction" href="#construction">Construction</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `time_period(ptime begin, ptime last)` | `[begin, last)` で表される期間(period)を生成する。<br/> `last <= begin` のときは null となる。 | `date d(2002,Jan,01);`<br/> `ptime t(d, seconds(10)); //10 sec after midnight`<br/> `time_period tp(t, hours(3));` |
| `time_period(ptime start, ptime end)` | `[begin, begin+len)` で表される期間(period)を生成する。<br/> `len <= 0` のときは null となる。 | `date d(2002,Jan,01);`<br/> `ptime t1(d, seconds(10)); //10 sec after midnight`<br/> `ptime t2(d, hours(10)); //10 hours after midnight`<br/> `time_period tp(t1, t2);` |
| `time_period(time_period rhs)` | コピーコンストラクタ | `time_period tp1(tp);` |


## <a id="accessors" href="#accessors">Accessors</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `ptime begin() const` | 期間(period)の最初を返す | `date d(2002,Jan,01);`<br/> `ptime t1(d, seconds(10)); //10 sec after midnight`<br/> `ptime t2(d, hours(10)); //10 hours after midnight`<br/> `time_period tp(t1, t2); tp.begin() --> 2002-Jan-01 00:00:10` |
| `ptime last() const` | 期間(period)の最後を返す | `date d(2002,Jan,01);`<br/> `ptime t1(d, seconds(10)); //10 sec after midnight`<br/> `ptime t2(d, hours(10)); //10 hours after midnight`<br/> `time_period tp(t1, t2); tp.last() --> 2002-Jan-01 09:59:59.999999999` |
| `ptime end() const` | 期間(period)の最後の次を返す | `date d(2002,Jan,01);`<br/> `ptime t1(d, seconds(10)); //10 sec after midnight`<br/> `ptime t2(d, hours(10)); //10 hours after midnight`<br/> `time_period tp(t1, t2); tp.last() --> 2002-Jan-01 10:00:00` |
| `bool is_null() const` | 期間(period) が正しい形式でないとき`true`<br/> 例: `end`が`start`より小さい | |
| `bool contains(ptime) const` | `ptime` が期間(period)の範囲内にあるとき `true` | `date d(2002,Jan,01);`<br/> `ptime t1(d, seconds(10)); //10 sec after midnight`<br/> `ptime t2(d, hours(10)); //10 hours after midnight`<br/> `ptime t3(d, hours(2)); //2 hours after midnight`<br/> `time_period tp(t1, t2); tp.contains(t3) --> true` |
| `bool contains(time_period) const` | `time_period` が期間(period)の範囲内にあるとき `true` | `time_period tp1(ptime(d,hours(1)), ptime(d,hours(12)));`<br/> `time_period tp2(ptime(d,hours(2)), ptime(d,hours(4)));`<br/> `tp1.contains(tp2) --> true`<br/> `tp2.contains(tp1) --> false` |
| `bool intersects(time_period) const` | 期間(period)が重複するとき `true` | `time_period tp1(ptime(d,hours(1)), ptime(d,hours(12)));`<br/> `time_period tp2(ptime(d,hours(2)), ptime(d,hours(4)));`<br/> `tp2.intersects(tp1) --> true` |
| `time_period intersection(time_period) const` | 二つの期間(period)が重複する範囲を計算する。期間(period)が重複しないときは null が返る | |
| `time_period merge(time_period) const` | 二つの期間(period)を結合して返す。期間(period)が重複しないときは null が返る | |
| `time_period shift(time_duration)` | 時間長(time_duration)を `start` と `end` に加算する | |


## <a id="conversion-to-string" href="#conversion-to-string">Conversion To String</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `std::string to_simple_string(time_period dp)` | [YYYY-mmm-DD hh:mm:ss.fffffffff/YYYY-mmm-DD hh:mm:ss.fffffffff] 形式の文字列に変換する(mmm は月名の3文字短縮形) | [2002-Jan-01 01:25:10.000000001/2002-Jan-31 01:25:10.123456789] |


## <a id="operators" href="#operators">Operators</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `operator==, operator!=,`<br/> `operator>, operator<` | サポートする比較演算子 | `tp1 == tp2`, etc |
| `operator<` | `tp1.end()` が `tp2.begin()` よりも小さいとき `true` | `tp1 < tp2`, etc |
| `operator>` | `tp1.begin()` が `tp2.end()` よりも大きいとき `true` | `tp1 > tp2`, etc |


***
Last modified: Wed Aug 28 17:52:03 MST 2002 by [Jeff Garland](mailto:jeff@crystalclearsoftware.com) © 2000-2002 

Japanese Translation Copyright (C) 2003 [Shoji Shinohara](mailto:sshino@cppll.jp).


