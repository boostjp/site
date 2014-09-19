#日付の計算

日付の計算には、Boost.DateTimeライブラリのGregorianを使用する。

##インデックス

- [月末日の取得](#end-of-month-day)
- [日付の加減算](#date-add-subtract)
- [月を表す`enum`値](#month-enum)


## <a name="end-of-month-day" href="end-of-month-day">月末日の取得</a>

月末日を取得するには、`boost::gregorian::gregorian_calendar::end_of_month_day()`関数を使用する。


```cpp
#include <iostream>
#include <boost/date_time/gregorian/gregorian.hpp>

int main()
{
    using namespace boost::gregorian;
  
    const int day = gregorian_calendar::end_of_month_day(2011, 2);
    std::cout << day << std::endl;
}
```


実行結果：

```
28
```


## <a name="date-add-subtract" href="date-add-subtract">日付の加減算</a>

Boost.DateTimeの`boost::gregorian::date`型は、`operator+()`や`operator-()`を使用して、日付の加減算を行うことができる。

年の加減算には`years`型、月の加減算には`months`型、日付の加減算には`days`型を使用する。

以下の例では、2011年4月1日に1ヶ月を加算し、その後1日を減算することで、2011年4月の末日を求めている。

```cpp
#include <iostream>
#include <boost/date_time/gregorian/gregorian.hpp>

using namespace boost::gregorian;

int main()
{
    const date d1(2011, Apr, 1);
    const date d2 = d1 + months(1) - days(1);

    std::cout << to_simple_string(d2) << std::endl;
}
```

実行結果：

```
2011-Apr-30
```

## <a name="month-enum" href="month-enum">月を表すenum値</a>

Boost.Dateの月を表す`enum`値は、`boost::date_time`名前空間において、以下のように定義されている：


| `enum`値 | 月 |
|--------|----|
| `Jan`  | 1 |
| `Feb`  | 2 |
| `Mar`  | 3 |
| `Apr`  | 4 |
| `May`  | 5 |
| `Jun`  | 6 |
| `Jul`  | 7 |
| `Aug`  | 8 |
| `Sep`  | 9 |
| `Oct`  | 10 |
| `Nov`  | 11 |
| `Dec`  | 12 |


