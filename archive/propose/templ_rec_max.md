#テンプレートの再帰上限数workaround(rejected)
本提案の発起人： Akira Takahashi(@cpp_akira), Kohei Takahashi(@Flast_RO)


###内容

BOOST_TEMPLATE_RECURSION_MAXのようなマクロで、現在のコンパイラのテンプレート再帰上限数を取得できるようにする。C++03の規格では17推奨、
C++11の規格では1024推奨(予定)。


| | | |
|---------------------------|-------------|----------------------------|
| コンパイラ | テンプレートの再帰上限数 | 情報提供者(copyrightに書くかもしれない名前) |
| GCC 4.6.1(C++03, C++0xモード) | 900 | Kohei Takahashi |
| VC++2008 | 489 | Akira Takahashi |
| ICC 11.1 | 2000 | hotwatermorning |
| VC++6.0 | 1251 | Hirofumi Miki |
| VC++2003 | 1073 | Hirofumi Miki |
| VC++2005 | 489 | Hirofumi Miki |
| VC++2010 | 499 | Hirofumi Miki |
|  |  |  |


###課題

- Boost 1.47.0現在、Boost.Buildがテンプレートの再帰数を強制的に128に設定してしまう(Kohei Takahashi)→ 提案するときついでにバグ報告しましょう(Akira Takahashi)→ <c++-template-depth>nで変更可能です(Kohei Takahashi)
- 不明なコンパイラの場合、値をどうするか(Akira Takahashi)→ デフォルト値は提供せず、マクロを定義しないのがいいと思う。ユーザーはifdefでコンパイラごとのテンプレート再帰数がわかっているかどうかを判別し、わからない場合はライブラリ独自の値を定義する。(Akira Takahashi)
- VCのテンプレート再帰数の上限はアンドキュメント。上限を超えるとコンパイラがクラッシュする(Tomohiro Kashiwada)。[http://social.msdn.microsoft.com/Forums/eu/vclanguage/thread/2e5e4bf8-f62e-4444-a5eb-8409309a0c1d](http://social.msdn.microsoft.com/Forums/eu/vclanguage/thread/2e5e4bf8-f62e-4444-a5eb-8409309a0c1d)
- VCのテンプレート再帰数は500という情報もあるが、それに達する前にクラッシュすることがある。最低値を算出する必要がある(zak)。[http://channel9.msdn.com/Shows/Going+Deep/C9-Lectures-Stephan-T-Lavavej-Advanced-STL-1-of-n](http://channel9.msdn.com/Shows/Going+Deep/C9-Lectures-Stephan-T-Lavavej-Advanced-STL-1-of-n)[http://stackoverflow.com/questions/2638409/just-introducing-myself-to-tmping-and-came-across-a-quirk/2638485](http://stackoverflow.com/questions/2638409/just-introducing-myself-to-tmping-and-came-across-a-quirk/2638485)


###検証コード
VCはアンドキュメントなので実際に試してみるしかない。

<b>VC++2008</b>
```cpp
template <int N>
struct loop {
    static const int value = loop<N - 1>::value;
};

template <>
struct loop<0> {
    static const int value = 0;
};

static const int template_recursive_count = loop<489>::value; // 490でコンパイラが死ぬ

int main() {}
```

ICC 11.1
```cpp
typedef unsigned int u32_t;
template<u32_t N>
struct depth {
        static u32_t const value = depth<N - 1>::value;
};
 
template<>
struct depth<0>
{
        static u32_t const value = 0;
};
 
int main()
{
        static int const value = 2001;
        depth<value>::value;
}
```

VC++6.0
```cpp
template <int N>
struct loop {
    enum { value = loop<N - 1>::value };
};

template <>
struct loop<0> {
    enum { value = 0 };
};

static const int template_recursive_count = loop<1251>::value; // 1252でエラー

void main() {}
```

VC++2003
```cpp
template <int N>
struct loop {
    static const int value = loop<N - 1>::value;
};

template <>
struct loop<0> {
    static const int value = 0;
};

static const int template_recursive_count = loop<1073>::value; // 1074でエラー

void main() {}
```

VC++2005
<span style='line-height:13px;background-color:rgb(239,239,239)'>```cpp
template <int N>
struct loop {
    static const int value = loop<N - 1>::value;
};

template <>
struct loop<0> {
    static const int value = 0;
};

static const int template_recursive_count = loop<489>::value; // 490でエラー

void main() {}

</span>

VC++2010
<span style='line-height:13px;background-color:rgb(239,239,239)'>```cpp
template <int N>
struct loop {
    static const int value = loop<N - 1>::value;
};

template <>
struct loop<0> {
    static const int value = 0;
};

static const int template_recursive_count = loop<499>::value; // 500でエラー

void main() {}

</span>
```
