# BOOST_PP_FILENAME_x

`BOOST_PP_FILENAME_x` マクロは `BOOST_PP_ITERATE` で使われる、
ユーザ定義の *名前付けされた外部引数* である。
これは、繰り返されるファイルを表す。

## Usage

```cpp
#define BOOST_PP_FILENAME_x filename
```

## Arguments

- `x` :
	次の *ファイル繰り返し* の繰り返しの深さ。
	この値は現在の繰り返しの深さ `+ 1` で *なければならない。*

- `filename` :
	*ファイル繰り返し* のターゲットとして使われる、
	引用符、またはカギ括弧で囲まれたファイル名。

## Remarks

このマクロは `BOOST_PP_ITERATE` に引数を渡す第2の方法の一部である。
他の一部は `BOOST_PP_ITERATION_LIMITS` である。

このマクロは `BOOST_PP_ITERATE` の呼び出しによって、再利用のために自動的に未定義にされる。

## See Also

- [`BOOST_PP_ITERATE`](iterate.md)
- [`BOOST_PP_ITERATION_LIMITS`](iteration_limits.md)

