# dates_as_strings.cpp

文字列の様々な解析および出力

```cpp
/*
以下は、日付と std::string との間の相互変換を示す簡単な例である

Expected output:
2001-Oct-09
2001-10-09
Tuesday October 9, 2001
An expected exception is next: 
  Exception: Month number is out of range 1..12

*/

#include "boost/date_time/gregorian/gregorian.hpp"
#include "boost/date_time/date_parsing.hpp"
#include <iostream>
#include <string>
 


int
main() 
{

  using namespace boost::gregorian;

  try {
    
    // 以下の日付は ISO 8601 拡張フォーマット (CCYY-MM-DD)
    std::string s("2001-10-9"); //2001-October-05
    date d(from_string(s));
    std::cout << to_simple_string(d) << std::endl;
    
    // ISO 標準(CCYYMMDD)を読んで ISO 拡張で出力
    std::string ud("20011009"); //2001-Oct-09
    date d1(from_undelimited_string(ud));
    std::cout << to_iso_extended_string(d1) << std::endl;
    
    //日付の構成要素を出力 - Tuesday October 9, 2001
    date::ymd_type ymd = d1.year_month_day();
    greg_weekday wd = d1.day_of_week();
    std::cout << wd.as_long_string() << " "
           << ymd.month.as_long_string() << " "
           << ymd.day << ", " << ymd.year
           << std::endl;

    
    // (偶然、)月に 25 を入れて、例外を生成してみよう
    std::string bad_date("20012509"); //2001-??-09
    std::cout << "An expected exception is next: " << std::endl;
    date wont_construct(from_undelimited_string(bad_date));
    
    // コンパイラが文句を言わないように wont_construct を使う。でも、ここにはたどり着かない
    std::cout << "oh oh, you should reach this line: " 
           << to_iso_string(wont_construct) << std::endl;
  }
  catch(std::exception& e) {
    std::cout << "  Exception: " <<  e.what() << std::endl;
  }


  return 0;
}
```

***
Generated Wed Aug 21 16:54:33 2002 by Doxygen for CrystalClear Software © 2000-2002


