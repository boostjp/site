#参考文献

- [全体のインデックスへ](../date_time.md)
- [Gregorianのインデックスへ](gregorian.md)
- [Posix Timeのインデックスへ](posix_time.md)

以下に挙げるのは、日付・時間ドメインに関するリファレンスと情報元である。

- [Date Calendar References](#date-references)
- [Time References](#time-reference)
- [Other C/C++ Libraries](#other-cpp-libs)
- [JAVA Date-Time Libraries](#java-libs)
- [Scriping Language Libraries](#script-lang-libs)
- [関連する商業的かつ想像力に富んだページ](#related-commerical-fanciful-pages)
- [分解能, 精度, 正確度](#resolution-precision-accuracy)


## <a name="date-references" href="#date-references">Date Calendar References</a>

- ISO 8601 日付・時間の標準 -- [Markus Kuhnによるまとめ](http://www.cl.cam.ac.uk/~mgk25/iso-time.html)
- 書籍『[Calendrical Calculations](http://emr.cs.iit.edu/home/reingold/calendar-book/second-edition/)』 著者 Reingold & Dershowitz
- Calendar FAQ by Claus T?dering [[html](http://www.pauahtun.org/CalendarFAQ/cal/calendar24.html)][[pdf](http://www.pauahtun.org/CalendarFAQ/cal/calendar24.pdf)]
- Calendar zone <http://www.calendarzone.com/>
- [date timeのXMLスキーマ](http://www.w3.org/TR/xmlschema-2/#dateTime)
- Will Lindenの[Calendar Links](http://www.ecben.net/calendar.shtml)
- [XMAS calendar melt](http://www21.brinkster.com/lonwolve/melt/index.htm)


## <a name="time-reference" href="#time-reference">Time References</a>
- Martin Folwerの時間パターン
	- [Recurring Events for Calendars](http://www.aw.com/cseng/titles/0-201-89542-0/apsupp/events2-1.html)
	- Patterns for things that [Change with time](http://martinfowler.com/ap2/timeNarrative.html)
- アメリカ国立研究所の標準とテクノロジー [Time Exhibits](http://nist.time.gov/exhibits.html)
- [NTP.org](http://www.ntp.org/)のネットワーク時間プロトコル
- US Navy [Systems of Time](http://tycho.usno.navy.mil/systime.html)
- [国際原子時(International Atomic Time)](http://www.bipm.fr/enus/5_Scientific/c_time/time_1.html)
- [8.5. 日付/時刻データ型](https://www.postgresql.jp/document/9.6/html/datatype-datetime.html) PostgreSQLユーザーガイド


## <a name="other-cpp-libs" href="#other-cpp-libs">Other C/C++ Libraries</a>
- [ctime C](http://www.cplusplus.com/ref/ctime/index.html) Standard library reference at cplusplus.com
- [XTime C extension](http://www.cl.cam.ac.uk/~mgk25/c-time/) proposal
- [Another C library extension](http://david.tribble.com/text/c0xcalendar.html#author-info) proposal by David Tribble
- [libTAI](http://cr.yp.to/libtai.html) is a C based time library
- [Time Zone](http://www.twinsun.com/tz/tz-link.htm) Database C library for managing timezones/places
- International Components for Unicode by IBM (open source)
	- [Calendar Class](http://oss.software.ibm.com/icu/userguide/dateCalendar.html)
	- [Date Time Services](http://oss.software.ibm.com/icu/userguide/dateTime.html)
	- [Time Zone Class](http://oss.software.ibm.com/icu/userguide/dateTimezone.html)
	- [Date-Time Formatting](http://oss.software.ibm.com/icu/userguide/formatDateTime.html)
- [Julian Library in C by Mark Showalter -- NASA](http://ringside.arc.nasa.gov/www/toolkits/julian_13/aareadme.html)


## <a name="java-libs" href="#java-libs">JAVA Date & Time Library Quick Reference</a>
- [クラスCalendar](https://docs.oracle.com/javase/jp/8/docs/api/java/util/Calendar.html)
- [クラスGregorianCalendar](https://docs.oracle.com/javase/jp/8/docs/api/java/util/GregorianCalendar.html)
- [クラスDate](https://docs.oracle.com/javase/jp/8/docs/api/java/util/Date.html)
- [クラスjava.sql.Time](https://docs.oracle.com/javase/jp/8/docs/api/java/sql/Time.html)
- [クラスDateFormatSymbols](https://docs.oracle.com/javase/jp/8/docs/api/java/text/DateFormatSymbols.html)
- [クラスDateFormat](https://docs.oracle.com/javase/jp/8/docs/api/java/text/DateFormat.html)
- [クラスSimpleDateFormat](https://docs.oracle.com/javase/jp/8/docs/api/java/text/SimpleDateFormat.html)
- [クラスSimpleTimeZone](https://docs.oracle.com/javase/jp/8/docs/api/java/util/SimpleTimeZone.html)


## <a name="script-lang-libs" href="#script-lang-libs">Scripting Language Libraries</a>
- A python date library [MX Date Time](http://www.lemburg.com/files/python/mxDateTime.html)
- Perl date-time
	- [Date-Time packages at CPAN](http://search.cpan.org/Catalog/Data_and_Data_Type/Date/)
	- [Date::Calc](http://search.cpan.org/doc/TWEGNER/Date-Calc-4.3-bin56Mac/Calc.pm) at CPAN
	- [Date::Convert](http://search.cpan.org/doc/MORTY/DateConvert-0.16/Convert.pm) calendar conversions at CPAN
- A PHP library [Vlib Date Library](http://vlib.activefish.com/docs/vlibDate.html)


## <a name="related-commerical-fanciful-pages" href="#related-commerical-fanciful-pages">関連する商業的かつ想像力に富んだページ</a>
- [Leapsecond.com time](http://www.leapsecond.com/java/gpsclock.htm) page
- [World Time Server / TZ database](http://www.worldtimeserver.com/)
- [10000 year clock](http://www.longnow.org/10kclock/clock.htm) at Long Now Foundation
- [Timezones for PCs](http://www.timezonesforpcs.com/)


## <a name="resolution-precision-accuracy" href="#resolution-precision-accuracy">Resolution, Precision, and Accuracy</a>
- Definitions with pictures from [Agilent Technologies](http://metrologyforum.tm.agilent.com/specs.shtml)
- Another set of pictures from [Team Labs](http://www.teamlabs.com/catalog/performance.asp)
- Definitions from [Southampton Institute](http://www.solent.ac.uk/hydrography/notes/errorthe/accuracy.htm)
- Definitions from [Newport Corporation](http://www.newport.com/Support/Tutorials/OptoMech/om4a.asp) in the context of instrumentation


***
Last modified: Wed Aug 28 17:52:03 MST 2002 by [Jeff Garland](mailto:jeff@crystalclearsoftware.com) © 2000-2002 

Japanese Translation Copyright (C) 2014 [Akira Takahashi](mailto:faithandbrave@gmail.com).


