# days_till_new_year.cpp

新年まであと何日か計算してみる

```cpp
// このサンプルは、新年まであと何日かを表示する

#include "boost/date_time/gregorian/gregorian.hpp"
#include <iostream>

int
main() 
{
  
  using namespace boost::gregorian;

  date::ymd_type today = day_clock::local_day_ymd();
  date new_years_day(today.year + 1,1,1);
  date_duration dd = new_years_day - date(today);
  
  std::cout << "Days till new year: " << dd.days() << std::endl;
  return 0;
}
```

***
Generated Wed Aug 21 16:54:33 2002 by Doxygen for CrystalClear Software © 2000-2002

