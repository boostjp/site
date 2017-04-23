# BOOST_PP_CONFIG_EXTENDED_LINE_INFO

`BOOST_PP_CONFIG_EXTENDED_LINE_INFO` は、`BOOST_PP_LINE` が拡張*ファイル繰り返し*状態情報を出力するかを決定するユーザー定義マクロである。

## Usage

```cpp
#define BOOST_PP_CONFIG_EXTENDED_LINE_INFO n
```

## Arguments

- `n` :
	`BOOST_PP_LINE` が拡張*ファイル繰り返し*情報を出力するかを決定する値。
	この値は `0` か `1` でなければならない。

## Remarks

`n` が `1` ならば、`BOOST_PP_LINE` は拡張データを出力するだろう。
デフォルトでは、このマクロは `0` に設定されている。

## See Also

- [`BOOST_PP_LINE`](line.md)

