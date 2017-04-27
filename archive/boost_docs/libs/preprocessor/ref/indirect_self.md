# BOOST_PP_INDIRECT_SELF

`BOOST_PP_INDIRECT_SELF` マクロは `BOOST_PP_INDIRECT_SELF` で使われる、
ユーザ定義の *名前付けされた外部引数* である。

## Usage

```cpp
#define BOOST_PP_INDIRECT_SELF filename
```

## Arguments

- `filename` :
	`BOOST_PP_INCLUDE_SELF` でインクルードされる、
	引用符、またはカギ括弧で囲まれたファイル名。

## Remarks

多くのプリプロセッサはファイルがそのファイル自身を直接インクルードすることを許さない。
例えファイルが、そのような状況を、自分自身で防いでいてもである。
このマクロを `BOOST_PP_INCLUDE_SELF` と組み合わせることで、ファイルがそのファイル自身を間接的にインクルードすることを可能にする。

このマクロは `BOOST_PP_INCLUDE_SELF` の呼び出しによって、
再利用のために自動的に未定義化される。

## See Also

- [`BOOST_PP_INCLUDE_SELF`](include_self.md)

