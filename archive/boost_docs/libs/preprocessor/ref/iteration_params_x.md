# BOOST_PP_ITERATION_PARAMS_x

`BOOST_PP_ITERATION_PARAMS_x` マクロは `BOOST_PP_ITERATE` で使われる、ユーザ定義の *名前付けされた外部引数* である。
これは *ファイル繰り返し* の下限、上限、ファイル名を表す。
また同様に、 *ファイル繰り返し* に関連するフラグを示すことも可能である。

## Usage

```cpp
#define BOOST_PP_ITERATION_PARAMS_x (c, (start, finish, filename [, flags]))
```

## Arguments

- `x` :
	次の *ファイル繰り返し* の繰り返しの深さ。
	この値は、現在の繰り返しの深さ `+1` *でなければならない。*

- `c` :
	パラメータの数。
	`flags` が特定されるなら、この値は `4` でなければならない。
	そうでなければ、 `3` でなければならない。

- `start` :
	*ファイル繰り返し* の下限(この数を含む)。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_ITERATION` までである。

- `finish` :
	*ファイル繰り返し* の上限(この数を含む)。
	有効な値の範囲は `0` から `BOOST_PP_LIMIT_ITERATION` までである。

- `filename` :
	*ファイル繰り返し* のターゲットとして使われる、
	引用符付きの、又はかぎ括弧付きのファイル名。

- `[flags]` :
	*ファイル繰り返し* のターゲットとして使われる、
	引用符付きの、又はかぎ括弧付きのファイル名。
	(訳注: 原文は誤り。正しくは、*ファイル繰り返し* に関連するフラグ。省略可。)

## Remarks

マクロ識別子の後に空白文字があることに注意すること。

このマクロは上の二つの形式 (`flags` 有りと無し) のうちのひとつのなかで、引数の *配列* として定義される。
これは `BOOST_PP_ITERATE` に引数を渡す第1の方法である。
`start` と `finish` は *評価済みのパラメータ* であり、ただの数式が使われなければならない。

このマクロは `BOOST_PP_ITERATE` の呼び出しにより、再利用のために自動的に未定義にされる。

## See Also

- [`BOOST_PP_ITERATE`](iterate.md)
- [`BOOST_PP_LIMIT_ITERATION`](limit_iteration.md)

