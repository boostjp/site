#Date-Timeの専門用語

- [全体のインデックスへ](../date_time.md)
- [Gregorianのインデックスへ](./gregorian.md)
- [Posix Timeのインデックスへ](./posix_time.md)

以下は日付・時間分野に関する用語である。


時間型の分類:

- **時間位置(Timepoint)**
	- 時間連続体(time continuum)の中の特定の位置を表す。定規の目盛に似ている
- **時間長(Timelength)**
	- 時間連続体中のどの時間位置にも関係しない時間の長さ
- **時間間隔(Timeinterval)**
	- 時間連続体中の特定の時間位置に関係する時間の長さ


他の用語:

- **正確度(Accuracy)**
	- 誤差の単位, クロックから読み出した時間と真の時間との差
- **暦法系(Calendar System)**
	- 日付レベルの分解能で時間位置(time points)にラベルを付ける体系
- **クロックデバイス**
	- 暦法系あるいは時法系に関して現在の日付や時刻を供給する(あるハードウェアに結び付けられた)ソフトウェアコンポーネント。
- **精密度(Precision)**
	- クロック間隔の計測単位
- **分解能(Resolution)**
	- 時法系/暦法系あるいは時間型で表現可能な最小の時間間隔(例: 1秒，一世紀)
- **安定性(Stability)**
	- 根本的な表現（実装）が特定の（抽象的な）値に関連付いたことを示すクラスの特性は決して変化しない。
- **時法系(Time System)**
	- 日付レベルより高い分解能で時間位置(time points)にラベル付けするための体系。


標準的な日付・時間用語:

- **エポック(Epoch)**
	- 時法系/暦法系の始点となる時間位置
- **夏時間(DST)**
	- Daylight Savings Time; いくつかの地域で夏期に日照時間を延長するために使われている地域時間の調整
- **時間帯(Time zone)**
	- 「地域時間」を提供するために、夏時間(DST)規則と協定標準時(UT)からのオフセットで定義される地球上の地域
- **協定標準時(UTC Time)**
	- Coordinated Universal Time; 経度0 で計測される民間の時法系。 うるう秒を使用することで、地球自転に適応されている。 ズールー時間(Zulu Time)として知られる。 グリニッジ標準時(Greenwich Mean Time)として知られている類似の時法系を置き換えた。 詳細は <http://aa.usno.navy.mil/faq/docs/UT.html> を参照されたい
- **TAI Time**
	- 世界中の原子時計を使って 0.1 マイクロ秒の分解能で計測される、高精度で単調な時法系(もっと良い用語が必要)。 地球の自転には適応していない。詳細は <http://www.bipm.fr/enus/5_Scientific/c_time/time_server.html> を参照されたい


さらにいくつかの実験的なもの:

- **地域時間(Local Time)**
	- 世界の特定の地域で測定される時間
- **Time Label**
	- 暦法系あるいは時法系に関して、完全にあるいは部分的に特定の日付時間を明示するタプル。これは年-月-日の表現である。
- **時間長の調整(Adjusting Time Length)**
	- その時々に依存した物理的な時間の長さを表現する時間長(duration)。 例えば、1ヶ月間の時間長(duration)は一般に日数の定数ではない。 その実際の長さは、評価する日付に依存して決定される。


設計に関する用語:

- **生成関数(Generation function)**
	- 一つ以上のパラメータからなる特定の時間位置(time points), 長さ(length), あるいは間隔(intervals)の集合を生成する関数


***
訳注: 

時間用語の訳語について、国土地理院の地理情報標準第2版にある[時間スキーマ](http://www.gsi.go.jp/GIS/stdind/stdindpdf/jsgi02.pdf)を参考にしてみました。

Accuracy と Precision の使い分けは[ここ](http://www.mathworks.com/access/helpdesk/jhelp/toolbox/daq/c1_int15.shtml)を参考にしました。


***
Last modified: Wed Aug 28 17:52:03 MST 2002 by [Jeff Garland](mailto:jeff@crystalclearsoftware.com) © 2000-2002 

Japanese Translation Copyright (C) 2003 [Shoji Shinohara](mailto:sshino@cppll.jp).


