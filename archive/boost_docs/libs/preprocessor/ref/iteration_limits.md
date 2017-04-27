# BOOST_PP_ITERATION_LIMITS

`BOOST_PP_ITERATION_LIMITS` マクロは `BOOST_PP_ITERATE` で利用される ユーザ定義の *名前付けされた外部引数* である。
これは *ファイル繰り返し* の下限と上限を表す。

## Usage

```cpp
#define BOOST_PP_ITERATION_LIMITS (start, finish)
```

## Arguments

- `start` :
	*ファイル繰り返し* の下限(この数を含む)。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_ITERATION` までである。

- `finish` :
	*ファイル繰り返し* の上限(この数を含む)。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_ITERATION` までである。

## Remarks

マクロ識別子の後に空白文字があることに注意せよ。

このマクロは、 `BOOST_PP_ITERATE` に引数を渡す2番目の方法の一部である。
他の部分は、 `BOOST_PP_FILENAME_x` である。
`start` と `finish` は両方とも *評価済みのパラメータ*である。
つまり、これらがただの数式であることを意味する。

このマクロは `BOOST_PP_ITERATE` が呼ばれたら、再び利用するために自動的に未定義にされる。

## See Also

- [`BOOST_PP_FILENAME_x`](filename_x.md)
- [`BOOST_PP_ITERATE`](iterate.md)
- [`BOOST_PP_LIMIT_ITERATION`](limit_iteration.md)

