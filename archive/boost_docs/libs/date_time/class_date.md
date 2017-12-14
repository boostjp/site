# gregorian::date

- [全体のインデックスへ](../date_time.md)
- [Gregorianのインデックスへ](gregorian.md)
- [Posix Timeのインデックスへ](posix_time.md)

**Date Documentation**

- [Introduction](#introduction)
- [Header](#header)
- [Construction](#construction)
- [Construct from String](#construct-from-string)
- [Construct from Clock](#construct-from-clock)
- [Accessors](#accessors)
- [Conversion To String](#conversion-to-string)
- [Operators](#operators)


## <a name="introduction" href="#introduction">Introduction</a>
`boost::gregorian::date` クラスはライブラリユーザーにとって主要なインタフェースである。 一般に、日付クラスは代入可能ではあるが、一度構築されると不変である事が多い。

日付の生成について別の方法が[date iterators](date_iterators.md)と[date algorithms or generators](date_algorithms.md)に含まれている。


## <a name="header" href="#header">Header</a>
```cpp
#include "boost/date_time/gregorian/gregorian.hpp" //全ての型とI/Oを含む
```

もしくは

```cpp
#include "boost/date_time/gregorian/gregorian_types.hpp" //型のみでI/Oは含まない
```

## <a name="construction" href="#construction">Construction</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `date(greg_year year, greg_month month, greg_day day)` | 日付の要素から構築する。year, month, day の範囲が不正な場合、それぞれ `std::out_of_range` から派生した `bad_year`, `bad_day_of_month`, `bad_day_month` 例外を投げる。 | `date d(2002,Jan,10)` |
| `date(date d)` | コピーコンストラクタ | `date d1(d)` |
| `date(special_values sv)` | 無限大、無効値(not-a-date-time)、最大値、最小値を構築するコンストラクタ | `date d1(neg_infin);`<br/> `date d2(pos_infin);`<br/> `date d3(not_a_date_time);`<br/> `date d4(max_date);`<br/> `date d5(min_date);` |


## <a name="construct-from-string" href="#construct-from-string">Construction From String</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `date from_string(const std::string&)` | 年-月-日の順に区切られた文字列から　例:2002-1-25 | `std::string ds("2002/1/25");`<br/> `date d(from_string(ds))` |
| `date from_undelimited_string(const std::string&)` | 年-月-日の順のISO形式から　例:20020125 | `std::string ds("20020125");`<br/> `date d(from_string(ds))` |


## <a name="construct-from-clock" href="#construct-from-clock">Construction From Clock</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `day_clock::local_day()`     | 計算機に設定された時間帯に準じた地域時間を取得する | `date d(day_clock::local_day())` |
| `day_clock::universal_day()` | UTC 標準時を取得する | `date d(day_clock::universal_day())` |


## <a name="accessors" href="#accessors">Accessors</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `greg_year year() const`   | 年の部分を取得 | `date d(2002,Jan,10); d.year() --> 2002;` |
| `greg_month month() const` | 月の部分を取得 | `date d(2002,Jan,10); d.month() --> 1;` |
| `greg_day day() const`     | 日の部分を取得 | `date d(2002,Jan,10); d.day() --> 10;` |
| `greg_ymd year_month_day() const` | `greg_ymd` 構造体を返す<br/> 日付の3つの要素全てが必要なときに便利である | `date d(2002,Jan,10);`<br/> `date::ymd_type ymd = d.year_month_day(); ymd.year --> 2002, ymd.month --> 1, ymd.day --> 10` |
| `greg_day_of_week day_of_week() const` | 曜日を返す(例: `Sunday`, `Monday`, etc. | `date d(2002,Jan,10); d.day() --> Thursday;` |
| `bool is_infinity() const`    | 日付が正または負の無限大の時 `true` を返す | `date d(pos_infin); d.is_infinity() --> true;` |
| `bool is_neg_infinity() const` | 日付が負の無限大の時 `true` を返す | `date d(neg_infin); d.is_neg_infinity() --> true;` |
| `bool is_pos_infinity() const` | 日付が正の無限大の時 `true` を返す | `date d(neg_infin); d.is_pos_infinity() --> true;` |
| `bool is_not_a_date() const`   | 日付が無効値(not a date)の時 `true` を返す | `date d(not_a_date_time); d.is_not_a_date() --> true;` |


## <a name="conversion-to-string" href="#conversion-to-string">Conversion To String</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `std::string to_simple_string(date d)`       | YYYY-mmm-DD (mmm は月名の3文字短縮形)形式に変換 | 2002-Jan-01 |
| `std::string to_iso_string(date d)`          | YYYYMMDD 形式に変換                             | 20020131 |
| `std::string to_iso_extended_string(date d)` | YYYY-MM-DD 形式に変換                           | 2002-01-31 |


## <a name="operators" href="#operators">Operators</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `operator<<` | ストリーム出力演算子 | `date d(2002,Jan,1);`<br/> `std::cout << d << std::endl;` |
| `operator==, operator!=,`<br/> `operator>, operator<,`<br/> `operator>=, operator<=` | サポートする比較演算子 | `d1 == d2`, etc |
| `date operator+(date_duration) const` | オフセット日数 `date_duration` を加えた日付を返す | `date d(2002,Jan,1);`<br/> `date_duration dd(1);`<br/> `date d2 = d + dd;` |
| `date operator-(date_duration) const` | オフセット日数 `date_duration` を差し引いた日付を返す | `date d(2002,Jan,1);`<br/> `date_duration dd(1);`<br/> `date d2 = d - dd;` |
| `date_duration operator-(date) const` | 2つの日付を差し引いた日数(date duration)を返す | `date d1(2002,Jan,1);`<br/> `date d2(2002,Jan,2);`<br/> `date_duration dd = d2-d1;` |


***
Last modified: Wed Aug 28 17:52:03 MST 2002 by [Jeff Garland](mailto:jeff@crystalclearsoftware.com) © 2000-2002 

Japanese Translation Copyright (C) 2003 [Shoji Shinohara](mailto:sshino@cppll.jp).


