#Boost Date-Time Library Documentation
Version 1.00

- 翻訳元ドキュメント： <http://www.boost.org/doc/libs/1_31_0/libs/date_time/doc/index.html>


##目次

**概要**

- [Introduction](#introduction)
- [Motivation](#motivation)
- [Usage Examples](#usage-examples)
- [Domain Concepts](#domain-concepts)
- [Tests](#tests)
- [Design and Extensions](#design-and-extensions)
- [Acknowledgements](#acknowledgements)
- [More Info](#more-info)

[Build-Compiler Information](#build-compiler-information)


**日付プログラミング**

[Gregorian Date System](./date_time/gregorian.md)

- [Class date](./date_time/class_date.md)
- [Class date_duration](./date_time/class_date_duration.md)
- [Class date_period](./date_time/class_date_period.md)
- [Date Iterators](./date_time/date_iterators.md)
- [Date Generators / Algorithms](./date_time/date_algorithms.md)
- [Class gregorian_calendar](./date_time/class_gregorian_calendar.md)
- [Class day_clock](./class_date.md#construct-from-clock)


**時間プログラミング**

[Posix Time System](./date_time/posix_time.md)

- [Class ptime](./date_time/class_ptime.md)
- [Class time_duration](./date_time/class_time_duration.md)
- [Class time_period](./date_time/class_time_period.md)
- [Time Iterators](./date_time/time_iterators.md)
- UTC / Local Time Adjustments


## <a name="introduction" href="introduction">Introduction</a>
ジェネリックプログラミングの概念に基づいた日付・時間ライブラリ


## <a name="motivation" href="motivation">Motivation</a>
このライブラリの開発動機は、多くのプロジェクトの多くの日付時間ライブラリで動作すること、また、それらの構築を手助けすることである。 日付時間ライブラリは多くの開発プロジェクトに対して、基礎的な構造を提供する。 しかしそれらの多くは、計算、書式化、変換、その他のいくつかの機能に限界がある。 例えば多くのライブラリは、うるう秒を正しく扱うこと、無限のような概念を提供すること、高分解能の時間資源やネットワーク上の時間資源を利用することが出来ない。 そのうえ、これらのライブラリは、どれも日付や時間の表現形式が厳密である傾向にあるため、プロジェクトやサブプロジェクトのためにカスタマイズすることが出来ない。

日付や時間に関するプログラミングは、文字列や整数に関するプログラミングと同じくらいシンプルで自然であるべきである。 多くの時間論理を備えたアプリケーションは、演算子と計算能力の頑健な集合により、根本的に単純化することができる。 クラスは日付時間の比較、時間の長さ(length)や期間(duration)の加算、時計からの日付時間の取得、日付時間間隔(interval)に関する自然な動作を提供すべきである。


## <a name="usage-examples" href="usage-examples">Usage Examples</a>
次に，グレゴリオ暦システムの使用例を示す。 詳細は「[日付プログラミング](./date_time/gregorian.md)」で解説する。

```cpp
using namespace boost::gregorian; 
date weekstart(2002,Feb,1);
date weekend  (2002,Feb,7);
date_duration fiveDays(5); 
date d3 = d1 + fiveDays;
date today = day_clock::local_day();
if (d3 >= today) {} //date comparison operators

date_period thisWeek(d1,d2);
if (thisWeek.contains(today)) {}//do something

//iterate and print the week
day_iterator itr(weekstart);
for (; itr <= weekend; ++itr) {
  std::cout << to_iso_extended_string(*itr) << std::endl;
}
```

そして `posix_time` システムの使用例である。 詳細は「[時間プログラミング](./date_time/posix_time.md)」で解説する。

```cpp
using namespace boost::posix_time; 
date d(2002,Feb,1); //an arbitrary date
ptime t1(d, hours(5)+nanosec(100));//date + time of day offset
ptime t2 = t1 - minutes(4)+seconds(2);
ptime now = second_clock::local_time(); //use the clock
//Get the date part out of the time
date today = now.date();
date tommorrow = today + date_duration(1);
ptime tommorrow_start(tommorrow); //midnight 

//starting at current time iterator adds by one hour
time_iterator titr(now,hours(1)); 
for (; titr < tommorrow_start; ++titr) {
  std::cout << to_simple_string(*titr) << std::endl;
}
```


## <a name="domain-concepts" href="domain-concepts">Domain Concepts</a>
日付・時間の分野には専門用語と問題が多い。以下はライブラリ中に見られる概念の簡単な紹介である。

このライブラリは3つの基本的な時間型をサポートする。

- Time Point
	- 時間位置。時刻。連続する時間内での位置を示す
- Time Duration
	- 時間長。時間連続体においてどの位置にも結びついていない時間の長さ
- Time Interval
	- 時間間隔。時間連続体の特定の位置に結びついた時間長。期間とも

これらの時間型にはそれぞれ表現可能な最小の時間間隔(duration)で定義される **分解能** がある。 **時法系(Time system)** は、時刻にラベルを付けて計算するための規則はもちろんのこと、これらすべての時間型も提供する。 **暦法系(Calendar system)** は最大の分解能(1日)を持っている簡素な時法系である。 **グレゴリオ暦** は今日最も広く使われている暦法系である(ISOシステムは基本的にこれの派生物である)。 しかし、他にも多くの暦法系がある。 **UTC(Coordinated Universal Time;協定標準時)** は広く使われている民間の時法系である。UTC がうるう秒（これは、必要に応じて適用されるもので、予測可能ではない）の使用によって経度0において地球自転に対して調整される。 たいていの **地域時間システム** が UTC に基づいているが、地球自転に対して同じように調整されるために、昼時間はどこでも同じである。 さらに、夏の昼時間を長くするためのサマータイム(DST)調整を含む地域時間もある。

**クロックデバイス** は時法系に関して現在の日付あるいは時刻を供給する(あるハードウェアに結び付けられた)ソフトウェアコンポーネントである。

ライブラリは日付と時間の計算をサポートする。しかしながら、時間の計算は整数の計算と全く同じというわけにはいかない。 もし、時間計算の正確度(accuracy)が重要ならば、[Stability, Predictability, and Approximations(安定性、予測性と近似)](./date_time/Tradeoffs.md)を読む必要がある。

追加資料を以下に示す

- [Basic Terminology](./date_time/BasicTerms.md)
- [Calculations](./date_time/Caluculations.md)
- [安定性、予測性と近似](./date_time/Tradeoffs.md)
- [References](./date_time/References.md)


## <a name="tests" href="tests">Tests</a>

ライブラリは、以下のディレクトリで多数のテストを提供している。

- libs/date_time/test 
- libs/date_time/test/gregorian
- libs/date_time/test/posix_time

これらのテストをビルドして実行することで、ライブラリが正しくインストールされ、確実に機能していることを確認できる。 加えて、これらのテストは新しいコンパイラへの移植を容易にする。 最後に、テストは使用例で明示的に記述されない多くの機能の例を提供する。


## <a name="design-and-extensions" href="design-and-extensions">Design and Extensions</a>
このライブラリの起源の大部分は（今まで）ほとんどの日付時間ライブラリがカスタマイズと拡張を許す方法で構築されないという観察であった。 典型的な例では、カレンダーロジックは直接日付クラスに構築される。 あるいは時計検索機能は直接時間クラスに作り上げられる。 これらのデザイン決定は通常、拡張したりライブラリの振る舞いを変更することを不可能にする。 もっと基本的なレベルにおいては、時間表現あるいはグレゴリオ暦の分解能について通常仮定がある。

高分解能の時間表現やそれ以外の仮定からの要求を、時間ライブラリの実装が満たすことが出来ないために、結果的に不完全なライブラリを使わざるをえない、というのは、よくあることである。 この種のライブラリの開発は、まったく些細なことではないので、こういう結果は非常に残念なことである。

（このライブラリの）設計は完璧というには程遠いが、それでも現在の設計は、著者の知るどんな時間ライブラリよりもはるかに柔軟である。 将来のバージョンでは、拡張性のさまざまな面について、さらに文書化されることが期待される。 ライブラリの設計目標についての情報は[ここ](./date_time/DesignGoals.md)に要約されている。


## <a name="acknowledgements" href="acknowledgements">Acknowledgements</a>
Many people have contributed to the development of this library. In particular Hugo Duncan and Joel de Guzman for help with porting to various compilers. For initial development of concepts and design Corwin Joy and Michael Kenniston deserve special thanks. Also extra thanks to Michael for writing up the theory and tradeoffs part of the documentation. Dave Zumbro for initial inspiration and sage thoughts. Many thanks to boost reviewers and users including: William Seymour, Kjell Elster, Beman Dawes, Gary Powell, Andrew Maclean, William Kempf, Peter Dimov, Chris Little, David Moore, Darin Adler, Gennadiy Rozental, Joachim Achtzehnter, Paul Bristow, Jan Langer, Mark Rodgers, Glen Knowles, Matthew Denman, and George Heintzelman.


## <a name="more-info" href="more-info">More Info</a>
現在、ライブラリの設計はWikiと電子メールによる議論によって発展している。 詳しい情報はこちらへ:

- [Boost Wiki GDTL Start Page](http://www.crystalclearsoftware.com/cgi-bin/boost_wiki/wiki.pl?GDTL)
- [Full Doxygen Reference Manual](http://www.crystalclearsoftware.com/libraries/date_time/index.html)


***
Last modified: Thu Sep 5 07:22:00 MST 2002 by Jeff Garland © 2000-2002 

Japanese Translation Copyright (C) 2003 [Shoji Shinohara](sshino@cppll.jp).

