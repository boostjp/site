#Boost.Signals: クラステンプレート `signalN`

##ヘッダ

`N` はサポートされているシグナルのパラメタ数である。
つまり、ヘッダ `<boost/signals/signal0.hpp>` には `signal0` が含まれており、ヘッダ `<boost/signals/signal1.hpp>` には `signal1` が含まれている。
サポートされているシグナルの最大パラメタ数は実装定義だが、最低 10 であることが要求される。

```cpp
#include <boost/signals/signalN.hpp>
```

##概要

本ドキュメントは複数の関係するクラス `signal0`, `signal1`, `signal2` などを扱う。
ここで末尾の数値は、シグナルとそれに接続されたスロットがとるパラメタ数を表す。
すべてのクラスを列挙する代わりに、単一の例 `signalN` について記述する。
なお `N` は関数のパラメタ数を表す。

```cpp
namespace boost {
	template<typename R,
		typename T1,
		typename T2,
		...
		typename TN,
		typename Combiner = last_value<R>,
		typename Group = int,
		typename GroupCompare = std::less<Group>,
		typename SlotFunction = boost::functionN<R, T1, T2, ..., TN>
	>
	class signalN :
	boost::noncopyable, // 開示用 : クラスは Noncopyable 要求を満たす
	boost::trackable
	{
	public:
		typedef typename Combiner::result_type result_type;
		typedef Combiner combiner_type;
		typedef Group group_type;
		typedef GroupCompare group_compare_type;
		typedef SlotFunction slot_function_type;
		typedef slot<slot_function_type> slot_type;
		typedef implementation-defined slot_result_type; // SlotFunction が戻り値型 void を持つ場合は void でない可能性がある; そのほかの場合には SlotFunction の戻り値型
		typedef implementation-defined slot_call_iterator; // `value_type` が `R` である InputIterator
		typedef T1 argument_type; // N == 1 のとき、シグナルは AdaptableUnaryFunction のモデルである
		typedef T1 first_argument_type; // N == 2 のとき、シグナルは AdaptableBinaryFunction のモデルである
		typedef T2 second_argument_type; // N == 2 のとき、シグナルは AdaptableBinaryFunction のモデルである

		typedef T1 arg1_type;
		typedef T2 arg2_type;
		.
		.
		.
		typedef TN argN_type;

		explicit signalN(const combiner_type& = combiner_type(), const group_compare_type& = group_compare_type());
		~signal();
		signals::connection connect(const slot_type&);
		signals::connection connect(const group_type&, const slot_type& slot);
		void disconnect(const group_type&);
		void disconnect_all_slots();
		bool empty() const;
		result_type operator()(T1 a1, T2 a2, ..., TN aN);
		result_type operator()(T1 a1, T2 a2, ..., TN aN) const;

	private:
		combiner_type combiner; // 開示用
	};
}
```
* Combiner[link #combiner]
* last_value[link last_value.md]
* Group[link #slot_group]
* GroupCompare[link #group_compare]
* SlotFunction[link #slot_function_type]
* boost::function[link ../../function.md]
* boost::trackable[link trackable.md]
* slot[link slot.md]
* slot_result_type[link #slot_result_type]
* slot_call_iterator[link #slot_call_iterator]
* InputIterator[link http://www.sgi.com/tech/stl/InputIterator.html]
* AdaptableUnaryFunction[link http://www.sgi.com/tech/stl/AdaptableUnaryFunction.html]
* AdaptableBinaryFunction[link http://www.sgi.com/tech/stl/AdaptableBinaryFunction.html]
* signalN[link #constructor]
* ~signal[link #destructor]
* connect[link #connect]
* connect[link #group_connect]
* disconnect[link #group_disconnect]
* disconnect_all_slots[link #disconnect_all]
* empty[link #empty]
* operator()[link #function_call_operator]

##関連型

###<a name="combiner">Combiner</a>

`Combiner` はイテレータのシーケンス `[first, last)` を受け取り、シーケンス中のいくつかのイテレータを参照外しして値を戻す関数オブジェクトである。
`Combiner` に渡されるイテレータの型は [slot call iterator](#slot_call_iterator) である。

###<a name="slot_group">Group</a>

`Group` は、接続をグループ化するために用いる型を定義する。
これは [`DefaultConstructible`](http://www.sgi.com/tech/stl/DefaultConstructible.html) かつ [`CopyConstructible`](http://www.sgi.com/tech/stl/CopyConstructible.html) でなければならない。

###<a name="group_compare">GroupCompare</a>

`GroupCompare` は、実引数型が [group type](#slot_group) と一致する [`BinaryPredicate`](http://www.sgi.com/tech/stl/BinaryPredicate.html) である。
これは接続グループの順序関係を定める。

###<a name="slot_function_type">SlotFunction</a>

`SlotFunction` は、他の互換性がある関数オブジェクトからコンストラクト可能な関数オブジェクトアダプタであることが要求される(互換性は `SlotFunction` それ自身によって定義される)。
`SlotFunction` は `T1, T2, .. TN` 型のパラメタを受け取り、シグナルのテンプレートパラメタ型 `R` に変換可能な結果を返す必要がある;
ただし `R` が `void` である場合には `SlotFunction` の戻り値型はすべて無視されることに注意。

他のシグナルへの接続、ならびに関数オブジェクトの参照への接続では、 `SlotFunction` は `reference_wrapper` オブジェクトを受理可能である必要がある。

##メンバ

###<a name="slot_result_type">`slot_result_type` 型</a>

`SlotFunction` が `void` を戻す場合、スロットの戻り値型は実装定義である; そうでないばあいにはスロットの戻り値型は `SlotFunction` 関数オブジェクトによって戻される型であることが要求される。

###<a name="slot_call_iterator">`slot_call_iterator` 型</a>

`value_type` が `R` であるような [`InputIterator`](http://www.sgi.com/tech/stl/InputIterator.html)。
`slot_call_iterator` の参照外し演算子は、指定された実引数を与えてスロットを呼び出し、その結果を戻す責任を負う。
イテレータを複数回参照外ししたときでもスロットが一度だけ呼び出されることを保証するため、結果はキャッシュされなければならない。

###<a name="constructor">コンストラクタ</a>

explicit signalN(const combiner_type& = combiner_type(), const group_compare_type& = group_compare_type());`

- **作用**: シグナルをスロットを含まない状態に初期化し、与えられた統合子を内部記憶域にコピーし、与えられたグループ比較関数オブジェクトを格納する。
- **事後条件**: `this->empty();`

###<a name="destructor">デストラクタ</a>

`~signal();`

- **作用**: すべてのスロット接続を切断する。

###接続管理

<a name="connect">`signals::connection connect(const slot_type& slot);`</a>

- **作用**: シグナル `this` を `slot` に接続する。
	スロットが *非アクティブ* である場合、たとえばスロット呼び出しに結合された [`trackable`](trackable.md) オブジェクトが破棄されている場合、`connect` 呼び出しは無視される。
- **戻り値**: 新規に作成されたシグナル・スロット間の接続を参照する [`signals::connection`](connection.md) オブジェクト;
	`slot` が非アクティブである場合、切断状態の接続が返る。
- **例外**: 強い例外保証。
	例外が発生すると常に、スロットはシグナルに接続された状態にならない。
- **計算量**: `O(lg n)`。
	ここで `n` はシグナルが認識しているスロット数。
- **注記**: シグナル呼び出し中に接続されたスロットが直ちに呼び出されるか否かは、不定である。

<a name="group_connect">`signals::connection connect(const group_type& group, const slot_type& slot);`</a>

- **作用**: 与えられたスロットを (`connect(slot)` と同様に) シグナルに接続し、このスロット接続を与えられたグループ `group` に関連づける。
- **戻り値**: 新規に作成されたシグナル・スロット間の接続を参照する [`signals::connection`](connection.md) オブジェクト。
- **例外**: 強い例外保証。例外が発生すると常に、スロットはシグナルに接続された状態にならない。
- **計算量**: `O(lg n)`。
	ここで `n` はシグナルが認識しているスロット数。
- **注記**: シグナル呼び出し中に接続されたスロットが直ちに呼び出されるか否かは、不定である。

<a name="group_disconnect">`void disconnect(const group_type& group);`</a>

- **作用**: 与えられたグループ中の全スロットが切断される。
- **例外**: ユーザのデストラクタが投げない限りは、例外を投げない。
	ユーザのデストラクタが例外を投げると、グループ中の全スロットが切断されない可能性がある。
- **計算量**: `O(lg n) + k`。
	ここで `n` はシグナルが認識しているスロット数であり、`k` は `group` に含まれるスロット数である。

<a name="disconnect_all">`void disconnect_all_slots();`</a>

- **作用**: シグナルに接続された全スロットを切断する。
- **事後条件**: `this->empty()`.
- **例外**: 切断するスロットが例外を投げる場合、すべてのスロットが切断されない可能性がある。
- **計算量**: シグナルが認識しているスロット数に比例。
- **注記**: シグナルがスロットを呼び出している最中を含めて、シグナルの生存期間中、いつでも呼び出してよい。

<a name="empty">`bool empty() const;`</a>

- **戻り値**: そのシグナルに接続されたスロットがない場合 `true`、そうでなければ `false`。
- **例外**: なし。
- **計算量**: シグナルが認識しているスロット数に比例。
- **論拠**: スロットは、そのスロットの実行中も含めて、任意の時点で切断することが可能である。
	したがって実装は切断されたスロットのリストを検索し、まだスロットが接続されているかを決定しなければならない可能性がある。

###シグナル呼び出し

<a name="function_call_operator">`result_type operator()(T1 a1, T2 a2, ..., TN aN); result_type operator()(T1 a1, T2 a2, ..., TN aN) const;`</a>

- **作用**: `slot_call_iterator` の範囲 `[first, last)` を与えて統合子を呼び出す (言い換えると `combiner(first, last)`)。
	この範囲は、各スロットに与えられたパラメタの集合 `a1, a2, ..., aN` を渡して呼び出した結果をイテレートする。
	スロットはグループ比較関数オブジェクトによって与えられる半順序関係にしたがって呼び出されるが、グループに所属しないスロットは最後に呼ばれる。
- **戻り値**: 統合子によって戻された結果。
- **例外**: スロット呼び出しによって例外が投げられた、あるいは統合子が渡されたスロットを参照外ししなかった場合、接続されたスロットの内部リストに含まれるその後のスロットは呼び出されない。
- **注記**: `const` 版の関数呼び出し演算子は統合子を `const` として実行する一方で、非`const` 版は統合子を非 `const` として実行する。
	同一グループ中のメンバー、ならびにグループに所属していないスロット間の順序は不定である。
	使用される統合子によっては、スロットが一つもシグナルに接続されていない状態で関数呼び出し演算子を呼び出すと未定義動作を引き起こす可能性がある。
	既定の統合子は、戻り値型が `void` の場合にはゼロ個のスロットに対しても正しく定義されているが、戻り値型が他の型の場合には未定義である (なぜなら戻り値を合成する方法がないから)。

[Doug Gregor](http://www.cs.rpi.edu/~gregod)

Last modified: Fri Oct 11 05:42:42 EDT 2002

