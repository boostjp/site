#gregorian::date_period

- [全体のインデックスへ](../date_time.md)
- [Gregorianのインデックスへ](./gregorian.md)
- [posix_timeのインデックスへ](./posix_time.md)

**Date Period Documentation**

- [Introduction](#introduction)
- [Header](#header)
- [Construction](#construction)
- [Accessors](#accessors)
- [Conversion To String](#conversion-to-string)
- [Operators](#operators)


## <a name="introduction" href="introduction">Introduction</a>
`boost::gregorian::date_period` クラスは、二つの日付の範囲(期間)を直接表現する。 プログラムの条件付きの論理を単純化することによって、ある種の計算を単純化する能力を提供する。 例えば、日付が週末あるいは休日のような不規則なスケジュールの中であるかどうか試すのは `date_period` のコレクションを使って達成され得る。 これは、`date_period` が別の期間(date period)と重複する場合に評価を許可する、あるいは重複している期間を生成する、といったいくつかの方法によって容易になる。 [period calculation example(期間計算の例)](./period_calc.cpp.md) はこの例を提供する。

無限値と組み合わせて使用される期間(date periods)は、「追って通知があるまで」といった複雑な概念を表現する能力を持っている。


## <a name="header" href="header">Header</a>
```cpp
#include "boost/date_time/gregorian/gregorian.hpp" //全ての型とI/Oを含む
```

もしくは

```cpp
#include "boost/date_time/gregorian/gregorian_types.hpp" //型のみでI/Oは含まない
```

## <a name="construction" href="construction">Construction</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `date_period(date begin, date last)` | `[begin, last)` で表される期間(period)を生成する。<br/> `last <= begin` のときは null となる。 | `date_period dp(date(2002,Jan,10), date_duration(2));` |
| `date_period(date start, date end)` | `[begin, begin+len)`で表される期間(period)を生成する。<br/> `len <= 0` のときは null となる。 | `date_period dp(date(2002,Jan,10), date_duration(2));` |
| `date_period(date_period rhs)` | コピーコンストラクタ | `date_period dp1(dp)` |


## <a name="accessors" href="accessors">Accessors</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `date begin() const` | 期間(period)の初日を返す | `date_period dp(date(2002,Jan,1), date(2002,Jan,10));`<br/> `dp.begin() --> 2002-Jan-01` |
| `date last() const`  | 期間(period)の最終日を返す | `date_period dp(date(2002,Jan,1), date(2002,Jan,10));`<br/> `dp.last() --> 2002-Jan-09` |
| `date end() const`   | 期間(period)の最終日の翌日を返す | `date_period dp(date(2002,Jan,1), date(2002,Jan,10));`<br/> `dp.end() --> 2002-Jan-10` |
| `bool is_null() const` | 期間(period)が正しい形式でないとき`true`<br/> 例: `end`が`start`より小さい | `date_period dp(date(2002,Jan,10), date(2002,Jan,1));`<br/> `dp.is_null() --> true` |
| `bool contains(date) const` | 日付が期間(period)の範囲内にあるとき`true` | `date_period dp(date(2002,Jan,1), date(2002,Jan,10));`<br/> `dp.contains(date(2002,Jan,2)) --> true` |
| `bool contains(date_period) const` | `date_period` が期間(period)の範囲内にあるとき`true` | `date_period dp1(date(2002,Jan,1), date(2002,Jan,10));`<br/> `date_period dp2(date(2002,Jan,2), date(2002,Jan,3));`<br/> `dp1.contains(dp2) --> true`<br/> `dp2.contains(dp1) --> false` |
| `bool intersects(date_period) const` | 期間(period)が重複するとき`true` | `date_period dp1(date(2002,Jan,1), date(2002,Jan,10));`<br/> `date_period dp2(date(2002,Jan,2), date(2002,Jan,3));`<br/> `dp2.intersects(dp1) --> true` |
| `date_period intersection(date_period) const` | 2つの期間(period)から重複する期間(period)を計算する。 期間(period)が重複しないときは null が返る | `date_period dp1(date(2002,Jan,1), date(2002,Jan,10));`<br/> `date_period dp2(date(2002,Jan,2), date(2002,Jan,3));`<br/> `dp2.intersects(dp1) --> dp2` |
| `date_period merge(date_period) const` | 2つの期間(period)を結合して返す。期間(period)が重複しないときは null が返る | `date_period dp1(date(2002,Jan,1), date(2002,Jan,10));`<br/> `date_period dp2(date(2002,Jan,9), date(2002,Jan,31));`<br/> `dp2.intersects(dp1) --> 2002-Jan-01/2002-Jan-31` |
| `date_period shift(date_duration)` | 初日と最終日に日数(date_duration)を加算する。 | `date_period dp1(date(2002,Jan,1), date(2002,Jan,10));`<br/> `dp1.shift(date_duration(1)); --> 2002-Jan-02/2002-Jan-11` |


## <a name="conversion-to-string" href="conversion-to-string">Conversion To String</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `std::string to_simple_string(date_period dp)` | [YYYY-mmm-DD/YYYY-mmm-DD] (mmm は月名の3文字短縮形)形式の文字列に変換 | [2002-Jan-01/2002-Jan-31] |


## <a name="operators" href="operators">Operators</a>

| Syntax | Description | Example |
|--------|-------------|---------|
| `operator==, operator!=,`<br/> `operator>, operator<` | サポートする比較演算子 | `dp1 == dp2`, etc |
| `operator<` | `dp1.end()`が`dp2.begin()`よりも小さいとき `true` | `dp1 < dp2`, etc |
| `operator>` | `dp1.begin()`が`dp2.end()`よりも大きいとき `true` | `dp1 > dp2`, etc |


***
Last modified: Wed Aug 28 17:52:03 MST 2002 by [Jeff Garland](jeff@crystalclearsoftware.com) © 2000-2002 

Japanese Translation Copyright (C) 2003 [Shoji Shinohara](sshino@cppll.jp).

