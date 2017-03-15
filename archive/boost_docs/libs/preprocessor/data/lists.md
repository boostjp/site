# Lists

*リスト*は頭部と尾部による単純な cons スタイルのリストである。
*リスト*の頭部には要素が入り、尾部には別の*リスト*かまたは `BOOST_PP_NIL` が入る。
例えば、

```cpp
(a, (b, (c, BOOST_PP_NIL)))
```

は `a`、`b`、`c` の三要素からなる*リスト*である。

この構造により、**マクロ引数は可変長となることができ(?)**、ユーザーが自力でサイズ変化を追尾することをせずとも、データのサイズを変更できる。

*リスト*の要素は `BOOST_PP_LIST_FIRST` や `BOOST_PP_LIST_REST` により展開される。

## Primitives

- [`BOOST_PP_LIST_FIRST`](../ref/list_first.md)
- [`BOOST_PP_LIST_REST`](../ref/list_rest.md)
- [`BOOST_PP_NIL`](../ref/nil.md)

