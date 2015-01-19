#posix_time::time iterators

- [全体のインデックスへ](../date_time.md)
- [Gregorianのインデックスへ](./gregorian.md)
- [Posix Timeのインデックスへ](./posix_time.md)

**Time Iterators**

- [Introduction](#introduction)
- [Header](#header)
- [Class Overview](#class-overview)


## <a name="introduction" href="#introduction">Introduction</a>
時間イテレータは、時間単位で反復するための標準的なメカニズムを提供する。 時間イテレータは(STLの)[入力イテレータ](http://www.sgi.com/tech/stl/InputIterator.html)のモデルであり、時間の集合の代入に用いることができる。 次の例は、15分間隔で反復する。

```cpp
using namespace boost::gregorian;
using namespace boost::posix_time;
date d(2000,Jan,20);
ptime start(d);//2000-Jan-20 00:00:00
time_iterator titr(start,minutes(15)); //iterate on 15 minute intervals
//produces 00:00:00, 00:15:00, 00:30:00, 00:45:00
for (; titr < ptime(d,hour(1)); ++titr) {
  std::cout << to_simple_string(*titr) << std::endl;
}
```

[print hours](./print_hours.cpp.md) の例は、1時間増加させ、その日の残りを繰り返す。


## <a name="header" href="#header">Header</a>
```cpp
#include "boost/date_time/posix_time/posix_time.hpp" //全ての型とI/Oを含む
```

もしくは

```cpp
#include "boost/date_time/posix_time/posix_time_types.hpp" //型のみでI/Oは含まない
```


## <a name="class-overview" href="#class-overview">Class Overview</a>

| Class | Construction Parameters | Description |
|-------|-------------------------|-------------|
| `time_iterator` | `ptime start_time, time_duration increment` | 指定された期間(`time_duration`)を増分として反復する |


***
Last modified: Wed Aug 28 17:52:03 MST 2002 by [Jeff Garland](mailto:jeff@crystalclearsoftware.com) © 2000-2002 

Japanese Translation Copyright (C) 2003 [Shoji Shinohara](mailto:sshino@cppll.jp).


