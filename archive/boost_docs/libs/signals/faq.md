# Boost.Signals FAQ

## Q: シグナルが noncopyable であるということは、シグナルをメンバとして保持するクラスもまた noncopyable であることを意味するのか？

いいえ。
コンパイラは、シグナルをメンバとして持つクラスに対してコピーコンストラクタならびに代入演算子を生成することはできないが、あなたがコピーコンストラクタや代入演算子を書くのは自由だ。
ただしシグナルをコピーしようと試みないように。

## Q: Boost.Signals はスレッドセーフか？

いいえ。
マルチスレッド環境下で Boost.Signals を利用することは大変危険であり、結果は満足とはほど遠いものとなるだろう。
将来 Boost.Signals はスレッドセーフをサポートするだろう。

## Q: Boost.Signals を Qt と共に使う方法は？

Qt とともに構築する場合、プロプロセッサマクロを用いて定義されている moc の予約語 `signals` と `slots` が、Boost.Signals と Qt を共に利用しているプログラムのコンパイルを失敗させる。
これは Qt の問題であり Boost.Signals の問題ではないのだが、Boost.Signals ライブラリを構築・利用するときに `BOOST_SIGNALS_NAMESPACE` を他の識別子 (例: signalslib) に定義することで、両方のシステムを共に使うことができる。
このとき Boost.Signals ライブラリの名前空間は `boost::signals` ではなく `boost::BOOST_SIGNALS_NAMESPACE` となる。
Qt と相互作用しない部分で元の名前空間名を保持しておくために、名前空間のエイリアスを用いることができる:

```cpp
namespace boost {
	namespace signals = BOOST_SIGNALS_NAMESPACE;
}
```

`BOOST_SIGNALS_NAMESPACE` を再定義すると、別の `BOOST_SIGNALS_NAMESPACE` 識別子を用いてコンパイルされたモジュールとのリンク互換性を失う。

[Doug Gregor](http://www.cs.rpi.edu/~gregod)

Last modified: Fri Oct 11 05:41:18 EDT 2002

