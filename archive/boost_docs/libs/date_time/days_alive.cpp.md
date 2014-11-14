#days_alive.cpp

日数差と日数を使って、今日まで何日生きてきたかを計算してみる

```cpp
#include "boost/date_time/gregorian/gregorian.hpp"
#include "boost/date_time/date_parsing.hpp"
#include <iostream>

int
main() 
{
  
  using namespace boost::gregorian;
  std::string s;
  std::cout << "Enter birth day YYYY-MM-DD (eg: 2002-02-01): ";
  std::cin >> s;
  try {
    date birthday(boost::date_time::parse_date<date>(s));
    // 誕生日(2002年1月1日);
  
    date today = day_clock::local_day();
    date_duration days_alive = today - birthday;
    date_duration one_day(1);
    if (days_alive == one_day) {
      std::cout << "Born yesterday, very funny" << std::endl;
    }
    else if (days_alive < 
      std::cout << "Not born yet, hmm: " << days_alive.days() 
          << " days" <<std::endl;
    }
    else {
      std::cout << "Days alive: " << days_alive.days() << std::endl;
    }

  }
  catch(...) {
    std::cout << "Bad date entered: " << s << std::endl;
  }
  return 0;
}
```

***
Generated Wed Aug 21 16:54:33 2002 by Doxygen for CrystalClear Software © 2000-2002

