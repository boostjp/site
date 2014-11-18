#Gregorian Date System Documentation

[全体のインデックスへ](../date_time.md)


##目次

- [Introduction](#introduction)
- [Usage Examples](#usage-examples)

**Temporal Types**

- [Class date](./class_date.md)
- [Class date_duration](./class_date_duration.md)
- [Class date_period](./class_date_period.md)

**Other Topics**

- Date Iterators
- [Date Generators / Algorithms](./date_algorithms.md)
- Class gregorian_calendar
- Class day_clock


## <a name="introduction" href="introduction">Introduction</a>
gregorian date system はグレゴリオ暦に基づいた日付プログラミングシステムを提供する。 現在の実装は，1400-Jan-01から10000-Jan-01の範囲の日付をサポートする。 実装された暦は、"予想グレゴリオ暦？(proleptic Gregorian calendar)" で、(グレゴリオ暦が)最初に採用された 1582 年以前に遡る拡張がなされている。

(訳注: [proleptic Gregorian calendar](http://www.wikipedia.org/wiki/Proleptic_Gregorian_Calendar))

歴史上の日付を扱うとき，局地的に採用された様々な暦法との調整が必要な事に注意すべきである。 Reingold と Dershowitz による [Calendrical Calculations](http://emr.cs.iit.edu/home/reingold/calendar-book/second-edition/) に詳しい説明がある。 暦法の現在の歴史上の範囲はアルゴリズムによって制限されてはいない。 しかしそれよりもむしろ、時間の正当性を保証するためにテストを書いて実行する。 この暦法系の範囲が将来増加し続けるであろうと思われる。

[Calendrical Calculations](http://emr.cs.iit.edu/home/reingold/calendar-book/second-edition/) からの日付情報がグレゴリオ暦の実装の正当性をクロステストするために使われた。

gregorian system の全ての型は `boost::gregorian` 名前空間で見つかる。 ライブラリは入出力に依存しない全てのクラスが収められた便宜的なヘッダ `boost/date_time/gregorian/gregorian_types.hpp` をサポートする。

もう一つのヘッダ `boost/date_time/gregorian/gregorian.hpp` は型と入出力コードを含む。

[`boost::gregorian::date`](./class_date.md) クラスはユーザーにとって主要な時間型である。 もし，"4月の第1日曜日"を見つけるといった特別な日付計算プログラムの書き方に興味があるなら、[date generators and algorithms](./date_algorithms.md)ページを見ると良い。


## <a name="usage-examples" href="usage-examples">Usage Examples</a>

| コード例 | 説明 |
|----------|------|
| [Days Alive](./days_alive.cpp.md)<br/> [Days Till New Year](./days_till_new_year.cpp.md) | 簡単な日数計算。現在の日付を時計から取得 |
| [Dates as strings](./dates_as_strings.cpp.md) | 日付と文字列の相互変換、簡単な解析と書式化 |
| [Date Period Calculations](./period_calc.cpp.md) | 日付が、期間(periods)の集合に含まれるか調べる (例: 休日・週末の判定) |
| [Print a month](./print_month.cpp.md) | コマンドラインで与えた月の日付を全て出力する小さなユーティリティプログラム。 1999年1月1日が金曜だったか土曜だったか知る必要がある? このプログラムはその方法を示す |
| [Print Holidays](./print_holidays.cpp.md) | 抽象的な指定を具体的な日付の集合に変換するために、日付ジェネレータを使う |


***
Last modified: Thu Sep 5 07:33:06 MST 2002 by Jeff Garland © 2000-2002 

Japanese Translation Copyright (C) 2003 [Shoji Shinohara](sshino@cppll.jp).

