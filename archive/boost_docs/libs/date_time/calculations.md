# Date-Time Concepts - 計算

- [全体のインデックスへ](../date_time.md)
- [Gregorianのインデックスへ](gregorian.md)
- [Posix Timeのインデックスへ](posix_time.md)

**Calculation Documentation**

- [Timepoints](#timepoints)
- [Durations](#durations)
- [Interval](#interval)
- [Special Cases](#special-cases)

## <a name="timepoints" href="#timepoints">Timepoints</a>

このセクションでは，GDTL timepoints で行える基本的な算術規則をいくつか示す。

```cpp
Timepoint + Duration --> Timepoint
Timepoint - Duration --> Timepoint

Duration + Timepoint --> Undefined 
Duration - Timepoint --> Undefined

Timepoint + Timepoint --> Undefined
Timepoint - Timepoint --> Duration
```

## <a name="durations" href="#durations">Durations</a>
このセクションでは時間長(time duration)に関する標準的な演算を示す。

```cpp
Duration + Duration  --> Duration
Duration - Duration  --> Duration

Duration * Integer   --> Duration  
Integer  * Duration  --> Duration  

Duration(∞) * Integer --> Duration(∞) 
Duration(∞)/Integer   --> Duration(∞) 
```

## <a name="interval" href="#interval">Intervals</a>
ここに時間間隔(intervals)によって支援された"演算"がある。 それらは半開区間に基づいている。

```cpp
//These can be defined by either of 2 Timepoints or a Timepoint and Duration
Timeinterval intersects Timeinterval --> bool
Timeinterval intersection Timeinterval --> Timeperiod //results undefined if no intersection 
Timeinterval contains  Timepoint    --> bool
Timeinterval contains  Timeinterval --> bool  
Timeinterval shift Duration         --> shift start and end by duration amount
```


## <a name="special-cases" href="#special-cases">Special Cases</a>
一般に，非日時値(NADT;Not A Date Time)や無限大といった特別な値は，浮動小数点値のような規則に従うべきである。 戻り値として NADT を返す代わりに，例外を投げるNADTに基づいたシステムを形成することが可能であるべきであることに注意する必要がある。

```cpp
Timepoint(NADT) + Duration --> Timepoint(NADT)
Timepoint(∞) + Duration --> Timepoint(∞)
Timepoint + Duration(∞) --> Timepoint(∞)
Timepoint - Duration(∞) --> Timepoint(-∞)
```

***
Last modified: Wed Aug 28 17:52:03 MST 2002 by [Jeff Garland](mailto:jeff@crystalclearsoftware.com) © 2000-2002 

Japanese Translation Copyright (C) 2003 [Shoji Shinohara](mailto:sshino@cppll.jp).


