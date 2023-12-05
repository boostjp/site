# 文字列フォーマット
C言語では、`sprintf`を使用して`char`配列としての文字列をフォーマット設定することができたが、C++において、`std::string`に対する文字列フォーマット機能は、C++14時点で標準ライブラリとしては提供されていない。

[Boost Format Library](http://www.boost.org/libs/format/)は、`std::string`の文字列フォーマット、およびストリームへのフォーマット出力の機能を提供するライブラリである。


## インデックス

- [基本的な使い方](#basic-usage)
- [`printf`風に書式を設定する](#printf-like-format)
- [フォーマット設定された`std::string`を作成する](#make-formatted-string)
- [C++の国際標準規格上の類似する機能](#cpp-standard)


## <a id="basic-usage" href="#basic-usage">基本的な使い方</a>

Boost.Formatの基本的な使い方は、`boost::format()`に書式文字列を設定し、`operator%()`を使用して各プレースホルダーを置き換える値を可変引数として設定する、というものである。

以下は、フォーマット指定した文字列を標準出力に出力している。

```cpp example
#include <iostream>
#include <boost/format.hpp>

int main()
{
    std::cout <<
        boost::format("%2% %1%") % 3 % std::string("Hello")
    << std::endl;
}
```

実行結果：

```
Hello 3
```

`printf()`のフォーマットと違うところは、`"%d"`や`"%s"`といった型指定が必ずしも必要ないということだ。

Boost.Formatでは、型指定の代わりに、`"%1%"`のようにして引数の番号を指定できる。これによって、同じ引数を何度も使用することができ、順番も好きに入れ替えることができるのである。

この場合、`"%1%"`が`3`に置き換えられ、`"%2%"`が""Hello""に置き換えられて標準出力に出力される。


## <a id="printf-like-format" href="#printf-like-format">`printf`風に書式を設定する</a>

Boost.Formatでは、`printf()`風の書式設定もサポートしている。

```cpp example
#include <iostream>
#include <boost/format.hpp>

int main()
{
    std::cout <<
        boost::format("%d %s") % 3 % std::string("Hello")
    << std::endl;
}
```

実行結果：

```
3 Hello
```


`boost::format`には、`printf()`関数がサポートしている`"%d"`や`"%s"`などの書式設定が可能である。`"%d"`は整数型に対応し、`"%s"`は文字列型に対応している。

この場合、`"%d"`が`3`に置き換えられ、`"%s"`が`"Hello"`に置き換えられて標準出力に出力される。


## <a id="make-formatted-string" href="#make-formatted-string">フォーマット設定されたstd::stringを作成する</a>

Boost.Formatで書式設定された`std::string`を作成するには、`boost::format`クラスの`str()`メンバ関数を使用する。

```cpp example
#include <iostream>
#include <string>
#include <boost/format.hpp>

int main()
{
    const std::string s = (boost::format("%2% %1%") % 3 % std::string("Hello")).str();

    std::cout << s << std::endl;
}
```

実行結果：

```
Hello 3
```

## <a id="cpp-standard" href="#cpp-standard">C++の国際標準規格上の類似する機能</a>
- [`std::format`](https://cpprefjp.github.io/reference/format/format.html)
