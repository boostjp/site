#gregorian::date_duration

- [全体のインデックスへ](../date_time.md)
- [Gregorianのインデックスへ](./gregorian.md)
- [Posix Timeのインデックスへ](./posix_time.md)

**Date Documentation**

- [Introduction](#introduction)
- [Header](#header)
- [Construction](#construction)
- [Accessors](#accessors)
- [Operators](#operators)


## <a name="introduction" href="#introduction">Introduction</a>
`boost::gregorian::date_duration` は，`gregorian::date`の演算で使うシンプルな日数を表すクラスである。durationの値は正と負どちらも使用できる。


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
| `date_duration(long)` | 日数を生成 | `date_duration dd(3); //3 日` |


## <a name="accessors" href="#accessors">Accessors</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `long days() const`           | 日数を取得 | `date_duration dd(3); dd.days() --> 3` |
| `bool is_negative() const`    | 日数が`0`より小さいとき`true` | `date_duration dd(-1); dd.is_negative() --> true` |
| `static date_duration unit()` | duration type の取りうる最小単位を返す | `date_duration::unit() --> date_duration(1)` |


## <a name="operators" href="#operators">Operators</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `operator==, operator!=,`<br/> `operator>, operator<`<br/>`operator>=, operator<=` | サポートする比較演算子 | `dd1 == dd2`, etc |
| `date_duration operator+(date_duration) const` | 日数を加算する | `date_duration dd1(3);`<br/> `date_duration dd2(5);`<br/> `date_duration dd3 = dd1 + dd2;` |
| `date_duration operator-(date_duration) const` | 日数の差を取る | `date_duration dd1(3);`<br/> `date_duration dd2(5);`<br/> `date_duration dd3 = dd1 - dd2;` |


***
Last modified: Wed Aug 28 17:52:03 MST 2002 by [Jeff Garland](mailto:jeff@crystalclearsoftware.com) © 2000-2002 

Japanese Translation Copyright (C) 2003 [Shoji Shinohara](mailto:sshino@cppll.jp).

