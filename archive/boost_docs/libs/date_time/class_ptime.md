#posix_time::ptime Documentation

- [全体のインデックスへ](../date_time.md)
- [Gregorianのインデックスへ](./gregorian.md)
- [Posix Timeのインデックスへ](./posix_time.md)

**ptime Documentation**

- [Introduction](#introduction)
- [Header](#header)
- [Construction](#construction)
- [Construct from String](#construct-from-string)
- [Construct from Clock](#construct-from-clock)
- [Accessors](#accessors)
- [Conversion To String](#conversion-to-string)
- [Operators](#operators)


## <a name="introduction" href="introduction">Introduction</a>
`boost::posix_time::ptime` クラスは時間位置(time point)を操作するための主要なインタフェースである。 一般に，`ptime` クラスは代入可能ではあるが，一度構築されると不変である事が多い。

クラス `ptime` は，時間位置(time point)の日付部分へのインタフェースである `gregorian::date` に依存する。

`ptime` を生成する別の手法が，[time iterators](./time_iterators.md) にある。


## <a name="header" href="header">Header</a>
```cpp
#include "boost/date_time/posix_time/posix_time.hpp" //全ての型とI/Oを含む
```

もしくは

```cpp
#include "boost/date_time/posix_time/posix_time_types.hpp" //型のみでI/Oは含まない
```


## <a name="construction" href="construction">Construction</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `ptime(date,time_duration)` | 日付とオフセットから構築 | `ptime t1(date(2002,Jan,10), time_duration(1,2,3));`<br/> `ptime t2(date(2002,Jan,10), hours(1)+nanosec(5));` |
| `ptime(ptime)` | コピーコンストラクタ | `ptime t3(t1)` |


## <a name="construct-from-string" href="construct-from-string">Construction From String</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `ptime time_from_string(const std::string&)` | 区切られた文字列から構築 | `std::string ts("2002-01-20 23:59:59.000");`<br/> `date d(time_from_string(ts));` |


## <a name="construct-from-clock" href="construct-from-clock">Construction From Clock</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `static ptime second_clock::local_time();` | 計算機の時間帯設定に基づいた地域時間(秒レベル分解能)で初期化 | `ptime t(second_clock::local_time());` |
| `static ptime second_clock::universal_time()` | UTC 時間で初期化 | `ptime t(second_clock::universal_day());` |


## <a name="accessors" href="accessors">Accessors</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `date date() const` | 時間の日付部分を取得 | `date d(2002,Jan,10);`<br/> `ptime t(d, hour(1));`<br/> `t.date() --> 2002-Jan-10;` |
| `time_duration time_of_day() const` | その日の時間オフセットを取得 | `date d(2002,Jan,10);`<br/> `ptime t(d, hour(1));`<br/> `t.time_of_day() --> 01:00:00;` |


## <a name="conversion-to-string" href="conversion-to-string">Conversion To String</a>

| Syntax | Description | Example |
| `std::string to_simple_string(ptime)` | YYYY-mmm-DD HH:MM:SS.fffffffff 形式の文字列(mmm は月名の3文字短縮名)に変換。 秒の小数部(.fffffffff)は0でないとき含まれる。 | 2002-Jan-01 10:00:01.123456789 |
| `std::string to_iso_string(ptime)` | YYYYMMDDTHHMMSS,fffffffff 形式(T は日付と時間の区切り) に変換 | 20020131T100001,123456789 |
| `std::string to_iso_extended_string(ptime)` | YYYY-MM-DDTHH:MM:SS,fffffffff 形式(T は日付と時間の区切り) に変換 | 2002-01-31T10:00:01,123456789 |


## <a name="operators" href="operators">Operators</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `operator==, operator!=,`<br/> `operator>, operator<` <br/> `operator>=, operator<=` | サポートする比較演算子 | `t1 == t2`, etc |
| `ptime operator+(date_duration) const` | オフセット日数(`date_duration`)を加えた `ptime` を返す | `date d(2002,Jan,1);`<br/> `ptime t(d,minutes(5));`<br/> `date_duration dd(1);`<br/> `ptime t2 = t + dd;` |
| `ptime operator-(date_duration) const` | オフセット日数(`date_duration`)を差し引いた `ptime` を返す | `date d(2002,Jan,1);`<br/> `ptime t(d,minutes(5));`<br/> `date_duration dd(1);`<br/> `ptime t2 = t - dd;` |
| `ptime operator+(time_duration) const` | 時間長(`time_duration`)を加えた `ptime` を返す | `date d(2002,Jan,1);`<br/> `ptime t(d,minutes(5));`<br/> `ptime t2 = t + hours(1) + minutes(2);` |
| `ptime operator-(time_duration) const` | 時間長(`time_duration`)を差し引いた `ptime` を返す | `date d(2002,Jan,1);`<br/> `ptime t(d,minutes(5));`<br/> `ptime t2 = t - minutes(2);` |
| `time_duration operator-(ptime) const` | 二つの時間の差を取る | `date d(2002,Jan,1);`<br/> `ptime t1(d,minutes(5));`<br/> `ptime t2(d,seconds(5));`<br/> `time_duration t3 = t2 - t1;//negative result` |


***
Last modified: Wed Aug 28 17:52:03 MST 2002 by [Jeff Garland](jeff@crystalclearsoftware.com) © 2000-2002 

Japanese Translation Copyright (C) 2003 [Shoji Shinohara](sshino@cppll.jp).


