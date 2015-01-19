#Posix Time System Documentation

- [全体のインデックスへ](../date_time.md)
- [Gregorianのインデックスへ](./gregorian.md)


##目次

- [Introduction](#introduction)
- [Usage Examples](#usage-examples)

**Temporal Types**

- [Class ptime](./class_ptime.md)
- [Class time_duration](./class_time_duration.md)
- [Class time_period](./class_time_period.md)

**Other Topics**

- [Time Iterators](./time_iterators.md)
- [UTC / Local Time Adjustments](./local_time_adjust.md)


## <a name="introduction" href="#introduction">Introduction</a>
ナノ秒分解能および安定した計算特性を備えた、調整されていない時間システムを定義する。 この時間システムは、時間表現における日付部分の実装にグレゴリオ暦を使用する。


## <a name="usage-examples" href="#usage-examples">Usage Examples</a>

| Example | Description |
|---------|-------------|
| [Time Math](./time_math.cpp.md)       | `ptime` と `time_durations` を使ったいくつかの単純な計算 |
| [Print Hours](./print_hours.cpp.md)   | `time_iterator` を使用してクロックから時刻を取得する |
| [Local to UTC Conversion](./local_utc_conversion.cpp.md) | 地域時間からUTC時間への夏時間規則を含んだ変換について、2つの異なる方法を実証する |
| [Time periods](./time_periods.cpp.md) | 期間(time periods)の交差および表示の簡単な例 |


***
Last modified: Wed Aug 28 17:52:03 MST 2002 by [Jeff Garland](mailto:jeff@crystalclearsoftware.com) © 2000-2002 

Japanese Translation Copyright (C) 2003 [Shoji Shinohara](mailto:sshino@cppll.jp).

