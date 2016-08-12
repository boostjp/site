#Boost.Signals

Boost.Signals ライブラリは、管理されたシグナル・スロット機構の実装である。
シグナルは複数のターゲットに対するコールバックを表し、同じ機構のパブリッシャやイベントから発信される。
シグナルはスロットの集合に接続され、シグナルが「発信」されるとそれらのスロットが呼び出しを受ける。
スロットはコールバックの受信者であり、イベントターゲット、もしくはサブスクライバとも呼ばれる。

シグナルとスロットは管理されており、それらのシグナルとスロット (より正確にはスロットの一部として存在するオブジェクト) はすべての接続を追跡しているため、シグナル・スロットのいずれか一方が破棄されると自動的にシグナル・スロット接続を切断できる。
これによりユーザは、関係する全オブジェクトの寿命から影響を受けるシグナル・スロット接続の寿命管理に大変な労力を払うことなくシグナル・スロット接続を利用することが可能になる。

シグナルが複数のスロットに接続されている場合は、スロットの戻り値とシグナルの戻り値の関係について問題がある。
Boost.Signals では、ユーザが複数の戻り値を結合させる方法を指定できる。

##目次

- [チュートリアル](signals/tutorial.md)
- リファレンス
	- クラステンプレート [`signal`](signals/reference/signal.md)
	- クラステンプレート [`signalN`](signals/reference/signalN.md)
	- クラステンプレート [`slot`](signals/reference/slot.md)
	- クラス [`trackable`](signals/reference/trackable.md)
	- ヘッダ [`boost/connection.hpp`](signals/reference/connection.md)
	- クラステンプレート [`last_value`](signals/reference/last_value.md)
	- 関数テンプレート [`visit_each`](signals/reference/visit_each.md)
- [FAQ](signals/faq.md)
- [Boost.Signals の設計](signals/design.md)
- [設計の論拠とその他のシグナル・スロット実装との比較](signals/design_rationale.md)
- [改訂履歴](signals/history.md)

[Doug Gregor](http://www.cs.rpi.edu/~gregod)

Last modified: Fri Oct 11 05:41:39 EDT 2002

