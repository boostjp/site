#Local Time Adjustment

- [全体のインデックスへ](../date_time.md)
- [Gregorianのインデックスへ](./gregorian.md)
- [Posix Timeのインデックスへ](./posix_time.md)

**Local Time Adjustment**

- [Header](#header)
- [Class Overview](#class-overview)


## <a name="introduction" href="introduction">Introduction</a>
時間表現において頻繁にぶつかる問題が、様々な地域時間の間の変換である。 一般に、これは参考時間システム(reference time system)を用いて解決される。 参考時間システムには、典型的に UTC が用いられる。

`posix_time` システムは内部で時間調整を行わないので、地域時間および UTC時間の両方を表わすために使用することができる。 しかしながら、ユーザーには変換と時間帯についての知識を処理することが委ねられる。

このライブラリは UTC から地域時間への変換を処理するための、2つの異なる方法を提示する。 一つ目は、コンピュータの時間帯設定を使う。 これは、ユーザーマシンのための UTC 時刻を変換することに対して、有用な解決法である。 このアプローチは ctime API に依存しており、もし環境設定が間違っていれば、正しくない結果を供給するであろう。 もうひとつのアプローチは、コンピュータの時間帯設定とは無関係に、任意の時間帯から UTC への変換を可能にする。[local utc conversionの例](./local_utc_conversion.cpp.md)では、これら両方の手法を示す。


## <a name="header" href="header">Header</a>
```cpp
#include "boost/date_time/gregorian/gregorian.hpp" //全ての型とI/Oを含む
```

もしくは

```cpp
#include "boost/date_time/gregorian/gregorian_types.hpp" //型のみでI/Oは含まない
```


## <a name="class-overview" href="class-overview">Class Overview</a>

| Class | Description | Example |
|-------|-------------|---------|
| `date_time::c_local_adjustor<ptime>::utc_to_local(ptime)` | 時間帯の設定および C API に基づいた UTC 時刻から、ローカルマシンの時刻を計算する | `typedef boost::date_time::c_local_adjustor<ptime> local_adj;`<br/> `ptime t10(date(2002,Jan,1), hours(7));`<br/> `ptime t11 = local_adj::utc_to_local(t10);` |
| `date_time::local_adjustor<ptime, utc_offset, dst_rules>::utc_to_local(ptime)` | UTC 時間に基づいた夏時間規則とUTCオフセットから、ローカルマシンの時刻を計算する | [例を参照](./local_utc_conversion.cpp.md) |
| `date_time::local_adjustor<ptime, utc_offset, dst_rules>::local_to_utc(ptime)` | 夏時間規則とUTCオフセットに基づいて、UTC時刻を計算する | [例を参照](./local_utc_conversion.cpp.md) |


***
Last modified: Wed Aug 28 17:52:03 MST 2002 by [Jeff Garland](jeff@crystalclearsoftware.com) © 2000-2002 

Japanese Translation Copyright (C) 2003 [Shoji Shinohara](sshino@cppll.jp).


