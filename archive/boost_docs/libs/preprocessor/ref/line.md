# BOOST_PP_LINE

`BOOST_PP_LINE` マクロは前処理出力でライン指令として符号化された注意を配置する。

## Usage

```cpp
#line BOOST_PP_LINE(line, file)
```

## Arguments

- `line` :
	追跡している行の新しい行番号。
	あらかじめ定義されているマクロ `__LINE__` は 広く使用されている。

- `file` :
	通常は現在のファイル名。
	しかし、どんな有益なテキストでも機能するだろう。
	このテキストは内部で文字列化されるので、引用符は不必要である。

## Remarks

もし、マクロ `BOOST_PP_CONFIG_EXTENDED_LINE_INFO` が `1` と定義され、かつ `file-iteration` が進行中であるならば、このマクロは `file-iteration` の状態に関するデバッギング情報を自動的に挿入するだろう。
この情報は最後に内部の最多の反復を備えたすべての現在の反復値を示すだろう。

エラーが同じソーステキストにおいて複数の反復に及んでいるかもしれないとき、この情報は役に立つ。
エラーが少しもないのを探すことはときどき決して簡単でない。
このマクロの使用はより簡単にこれを作成するための情報を提供できる。
たとえば、このようないくつかのエラーを得る代わりに：

```cpp
"file.hpp", line 2: error: expected a ";"
"file.hpp", line 4: error: improperly terminated macro invocation
```

このようなものを得るかもしれない･･･。

```cpp
"file.hpp [1]", line 2: error: expected a ";"
"file.hpp [5]", line 4: error: improperly terminated macro invocation
```

このエラーが同じソーステキスト複数の反復に及んでいるということは、すぐに明らかになる。
もしそうでなければ、同じエラーが各反復に生じるだろう。

しかしながら、いくつかのコンパイルは実際にファイルでないファイル名を受け付けないので、注意されるに違いない。
それらのコンパイラは概して悪いフィル名に関する警告を出す。
これは、デバッグするとき *だけ* 単に `BOOST_PP_CONFIG_EXTENDED_LINE_INFO` を `1` と定義することをよい考えとする。

## See Also

- [`BOOST_PP_CONFIG_EXTENDED_LINE_INFO`](config_extended_line_info.md)

## Requirements

Header: &lt;boost/preprocessor/debug/line.hpp&gt;

## Sample Code

```cpp
// sample.cpp
#if !defined(BOOST_PP_IS_ITERATING)

	#define BOOST_PP_CONFIG_EXTENDED_LINE_INFO 1

	#include <boost/preprocessor/arithmetic/dec.hpp>
	#include <boost/preprocessor/cat.hpp>
	#include <boost/preprocessor/debug/line.hpp>
	#include <boost/preprocessor/iteration/iterate.hpp>

	namespace sample {

	#define BOOST_PP_ITERATION_PARAMS_1 (3, (1, 5, "sample.cpp"))
	#include BOOST_PP_ITERATE()

	} // sample

	int main(void) {
		return 0;
	}

#else

	#line BOOST_PP_LINE(1, sample.cpp)

	int BOOST_PP_CAT(x, BOOST_PP_ITERATION())); // 余分な丸括弧

	struct BOOST_PP_CAT(s, BOOST_PP_DEC(BOOST_PP_ITERATION()) {
		// 丸括弧が不足している
		// ...
	};

#endif
```
* BOOST_PP_IS_ITERATING[link is_iterating.md]
* BOOST_PP_CONFIG_EXTENDED_LINE_INFO[link config_extended_line_info.md]
* BOOST_PP_ITERATION_PARAMS_1[link iteration_params_x.md]
* BOOST_PP_ITERATE[link iterate.md]
* BOOST_PP_LINE[link line.md]
* BOOST_PP_CAT[link cat.md]
* BOOST_PP_ITERATION[link iteration.md]
* BOOST_PP_DEC[link dec.md]

