# エラーと例外のハンドリング

- 翻訳元：<http://www.boost.org/community/error_handling.html>


## 参照
次の文書は堅牢で汎用的なコンポーネントを書くときのいくつかの問題に対する、 良い手引きである。

- D. Abrahams: ["Exception Safety in Generic Components"(邦訳：「ジェネリックコンポーネントにおける例外安全性」)](generic_exception_safety.md), originally published in [M. Jazayeri, R. Loos, D. Musser (eds.): Generic Programming, Proc. of a Dagstuhl Seminar, Lecture Notes on Computer Science 1766](http://www.springer.de/cgi-bin/search_book.pl?isbn=3-540-41090-2)


## ガイドライン
### いつ例外を使うべきか?
単純な答えは: 「例外のセマンティクスとパフォーマンスの性質が適していればいつでも」

よく引用されるガイドラインは 「これは例外的な(或いは期待されていない)状況なのか?」 とあなた自身に問うことである。このガイドラインはその問題に対して、 魅力的な響きがするが、通常間違っている。問題はある人間の「例外的」 が、別の人間の 「期待通り」 である、ということである: その述語をあなたが本当に注意深く見るとき、例外的と期待通りの間の区別は消えて無くなり、 ガイドラインはもはやあなたのもとには残らない。 結局、もしエラーの状態をチェックするなら、ある意味であなたはそれが起こるのを期待しているか、 そうでなければそのチェックは全く無駄なコードなのである。

この問題により相応しい問いは: 「ここでスタックを巻き戻したいか?」 ということである。実際に例外を扱うことは、コードの主流を実行するより かなり遅いと考えられるので、あなたは更にこう問うべきである: 「私はここでスタックを巻き戻す余裕があるのか?」 例えば長い計算を行っているデスクトップアプリケーションは、ユーザがキャンセルボタンを押したかどうか、 定期的にチェックするだろう。例外を投げれば、キャンセルは美しく行われる。 一方、この計算の内側のループで例外を投げ、 *扱う* ことはおそらく適していない。 パフォーマンスにおおいに影響するからである。


### プログラマのエラーについては?
開発者として、もし私が自分の使っているライブラリの事前条件を違反したなら、 私はスタックを巻き戻したくはない。私が行いたいことは、コアダンプを吐くか、 それと同等のことである。つまり、問題が発見された実際の場所で、 プログラムの状態を調べる方法が欲しいのである。 これは通常、 `assert()` などである。

ほとんどの種類の、クライアントの誤用に耐えうる、 回復力のある API が必要なときもあるだろう。 しかし、このアプローチには通常、大きなコストが伴う。 例えば、これは通常、クライアントが使うオブジェクトそれぞれについて追跡することで、 その妥当性をチェックすることが出来るだろう。 もしその種の保護を行う必要があるなら、通常、単純な API の最も上の層として 提供することができる。もっともこれは、中途半端な方法だということに気づかなければならない。 多くの誤用に - しかし全てではない - 対する回復を約束する API は災いを招く。 クライアントはその保護に頼り、その期待はインタフェースが守らない部分にまでふくらむだろう。

**Windows 開発者のための注意** : 不幸にも、多くの Windows コンパイラに寄って使われるネイティブの例外操作は、 あなたが `assert()` を使ったときに、実際に例外を投げる。 実際、これはセグメンテーション違反や、ゼロ除算などの他のプログラマのエラーについては正しい。 これに関するひとつの問題は、もしあなたが JIT(Just In Time) デバッグを行えば、 デバッガが動く前に対応する例外巻き戻しが起こってしまうということである。 幸運にも、単純だが余り知られていない回避手段がある。それは、 次の決まり文句を使うことである:

```cpp
extern "C" void straight_to_debugger(unsigned int, EXCEPTION_POINTERS*)
{
    throw;
}
extern "C" void (*old_translator)(unsigned, EXCEPTION_POINTERS*)
         = _set_se_translator(straight_to_debugger);
```

***

© Copyright David Abrahams 2001. Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies. This document is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

Revised 19 August, 2001

***

Japanese Translation Copyright (C) 2003 [Kohske Takahashi](mailto:k_takahashi@cppll.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の 複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」 に提供されており、いかなる明示的、暗黙的保証も行わない。また、 いかなる目的に対しても、その利用が適していることを関知しない。

