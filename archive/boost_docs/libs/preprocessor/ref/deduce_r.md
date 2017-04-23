# BOOST_PP_DEDUCE_R

`BOOST_PP_DEDUCE_R` マクロは `BOOST_PP_FOR` の構築状態を手動で推論する。

## Usage

```cpp
BOOST_PP_DEDUCE_R()
```

## Remarks

このマクロは深い展開における*自動再帰*の使用を避けるためにある。
いくつかのプリプロセッサでは、そのような深さでの*自動再帰*は非効率的となり得る。
これは接尾辞 `_R` を持ったマクロの実行に直接使用されるためのものではない。
例えば:

```cpp
BOOST_PP_LIST_ENUM_R(BOOST_PP_DEDUCE_R(), (a, (b, (c, BOOST_PP_NIL))))
```

もしこのような文脈でこのマクロが使われた場合、`_R` マクロは失敗するだろう。
`_R` マクロは渡されたパラメータ `r` を直接、`BOOST_PP_DEDUCE_R()` が展開されるのを邪魔して、結合する。
さらに言えば、このマクロをさきの例のような状況で使用するのは無意味である。
効率を得るにはすでに遅すぎるからだ。

## See Also

- [`BOOST_PP_FOR`](for.md)

## Requirements

Header: &lt;boost/preprocessor/repetition/deduce_r.hpp&gt;

