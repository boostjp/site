#posix_time::time_duration

- [全体のインデックスへ](../date_time.md)
- [Gregorianのインデックスへ](./gregorian.md)
- [Posix Timeのインデックスへ](./posix_time.md)

**Time Duration Documentation**
- [Introduction](#introduction)
- [Header](#header)
- [Construction](#construction)
- [Count Based Construction](#count-based-construction)
- [Construct from String](#construct-from-string)
- [Accessors](#accessors)
- [Conversion To String](#conversion-to-string)
- [Operators](#operators)


## <a name="introduction" href="introduction">Introduction</a>
`boost::posix_time::time_duration` クラスは時間の長さを確実に表現できる基底型である。 時間長(duration)は正あるいは負の値を取り得る。

以下に示すように、異なった分解能を調整するために基底の `time_duration` から継承するいくつかの小さなヘルパークラスがある。 これらのクラスによって、コードを短く、意図をより明確にすることができる。

![](http://www.boost.org/doc/libs/1_31_0/libs/date_time/doc/time_duration_inherit.png)

例:

```cpp
using namespace boost::gregorian;
using namespace boost::posix_time;

time_duration td = hours(1) + seconds(10); //01:00:01
td = hours(1) + nanosec(5); //01:00:00.000000005
```

注意：高分解能(たとえば`nanosec`)が存在するかどうかは、依存するインストールライブラリによって異なる。詳細は、[Build-Compiler Information](./BuildInfo.md)を参照。

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
| `time_duration(hours,minutes,seconds,fractional_seconds)` | 数値から時間長(duration)を生成する | `time_duration td(1,2,3,9); //1 hr 2 min 3 sec 9 nanoseconds` |


## <a name="count-based-construction" href="count-based-construction">Construction By Count</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `hours(long)`        | 時間単位で生成       | `time_duration td = hours(3);` |
| `minutes(long)`      | 分単位で生成         | `time_duration td = minutes(3);` |
| `seconds(long)`      | 秒単位で生成         | `time_duration td = seconds(3);` |
| `milliseconds(long)` | ミリ秒単位で生成     | `time_duration td = milliseconds(3);` |
| `microseconds(long)` | マイクロ秒単位で生成 | `time_duration td = microseconds(3);` |
| `nanoseconds(long)`  | ナノ秒単位で生成     | `time_duration td = nanoseconds(3);`  |


## <a name="conversion-to-string" href="conversion-to-string">Construction From String</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `time_duration duration_from_string(const std::string&)` | 区切られた文字列から生成 | `std::string ts("23:59:59.000");`<br/> `time_duraton td(duration_from_string(ts));` |


## <a name="accessors" href="accessors">Accessors</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `long hours() const` | 時間の部分を取得 | `time_duration td(1,2,3); td.hours() --> 1` |
| `long minutes() const` | 正規化された分の部分を取得 | `time_duration td(1,2,3); td.minutes() --> 2` |
| `long seconds() const` | 秒の部分を取得 | `time_duration td(1,2,3); td.hours() --> 3` |
| `long fractional_seconds() const` | 秒の小数部を取得 | `time_duration td(1,2,3, 1000); td.fractional_seconds() --> 1000` |
| `bool is_negative() const` | 時間長(duration)が負の時 `true` | `time_duration td(-1,0,0); td.is_negative() --> true` |
| `time_duration invert_sign() const` | 符号を反転させた時間長(duration)を新たに生成 | `time_duration td(-1,0,0); td.invert_sign() --> 01:00:00` |
| `static gdtl::time_resolutions resolution()` | `time_duration` クラスが表現可能な分解能 | `time_duration::resolution() --> nano` |
| `boost::int64_t ticks()` | 時間長(duration)型の生の数を返す | `time_duration td(0,0,0, 1000); td.ticks() --> 1000` |
| `static time_duration unit()` | 時間長(duration)型の扱える最小単位を返す(1ナノ秒) | `time_duration::unit() --> time_duration(0,0,0,1)` |


## <a name="conversion-to-string" href="conversion-to-string">Conversion To String</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `std::string to_simple_string(time_duration)` | HH:MM:SS.fffffffff 形式に変換する(fff...部は、秒の小数部が0でないときのみ含まれる) | 10:00:01.123456789 |
| `std::string to_iso_string(time_duration)` | HHMMSS,fffffffff 形式に変換する | 100001,123456789 |


## <a name="operators" href="operators">Operators</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `operator==, operator!=,`<br/> `operator>, operator<`<br/> `operator>=, operator<=` | サポートする比較演算子 | `dd1 == dd2`, etc |
| `time_duration operator+(time_duration) const` | 時間長(durations)を加算する | `time_duration td1(hours(1)+minutes(2));`<br/> `time_duration td2(seconds(10)); time_duration td3 = td1 + td2;` |
| `time_duration operator-(time_duration) const` 時間長(durations)を減算する | `time_duration td1(hours(1)+nanosec(2));`<br/> `time_duration td2 = td1 - minutes(1);` |


***
Last modified: Wed Aug 28 17:52:03 MST 2002 by [Jeff Garland](jeff@crystalclearsoftware.com) © 2000-2002 

Japanese Translation Copyright (C) 2003 [Shoji Shinohara](sshino@cppll.jp).


