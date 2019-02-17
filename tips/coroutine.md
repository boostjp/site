# コルーチン
コルーチンには、[Boost.Coroutine2](https://www.boost.org/doc/libs/1_69_0/libs/coroutine2/doc/html/index.html)を使用する。

## インデックス
- [コルーチンについて](#description_of_coroutine)
- [基本的な使い方](#basic_usage)
    - [他の実行コンテキストからデータを転送する](#pull_type)
    - [他の実行コンテキストにデータを転送する](#push_type)
- [範囲イテレータを使う](#range_iterator)
    - [入力反復子](#input_iterator)
    - [出力反復子](#output_iterator)

## <a id="description_of_coroutine" href="#description_of_coroutine">コルーチンについて</a>
コルーチンは、プログラミングの構造の一種である。また、コルーチンは特別な種類の制御フローを提供する言語レベルの構成要素と見なすことができる。通常、サブルーチン（関数）を呼びだすとそれが終了するまで呼びだし元に制御は帰らないが、コルーチンは一旦処理を中断し、制御を呼びだし元に戻した後に、中断したポイントの続きから処理を再開できる。

## <a id="basic_usage" href="#basic_usage">基本的な使い方</a>
Boost.Coroutine2 では、`coroutine<>::pull_type`、`coroutine<>::pull_type`をセットで用いる。これらの非対称コルーチン型は、単方向のデータ転送を提供している。また、Boost.Coroutine2 の実装には、コンテキストの切り替えに Boost.Context を使用しており、ライブラリのリンクが必要である。

### <a id="pull_type" href="#pull_type">別の実行コンテキストからデータを転送する</a>

次の例では、コルーチン関数からデータを転送している。

```cpp example
#include <boost/coroutine2/coroutine.hpp>
#include <iostream>

typedef boost::coroutines2::coroutine<int> coro_t;

void func(coro_t::push_type& sink) 
{
  std::cout << 2 << " ";
  sink(3); // {3}をメインコンテキストに戻す
  std::cout << 5 << " ";
  sink(6); // {6}をメインコンテキストに戻す
}

int main() 
{
  std::cout << 1 << " ";
  coro_t::pull_type source(func); // コンストラクタがコルーチン関数に入る
    
  if (source) //プルコルーチンが有効かどうかをテストする
    std::cout << source.get() << " "; // データ値にアクセス
    
  std::cout << 4 << " ";
    
  if (source) {
    source(); // コンテキストスイッチ
    std::cout << source.get() << " "; // データ値にアクセス
  }
  
  std::cout << 7;
}
```

実行結果：
```
1 2 3 4 5 6 7
```

実行制御がコルーチン関数から返された後のコルーチンの状態は、`coroutine<>::pull_type::operator bool`で確認でき、コルーチンがまだ有効であれば`true`を返す。(`true`ならばコルーチン関数は終了していない）。また、最初のテンプレートパラメータが`void`でない限り、`true`はデータ値が利用可能であることも意味する。

### <a id="push_type" href="#push_type">別の実行コンテキストにデータを転送する</a>

```cpp example
#include <boost/coroutine2/coroutine.hpp>
#include <iostream>

typedef boost::coroutines2::coroutine<int> coro_t;

void func(coro_t::pull_type& source) 
{
  std::cout << source.get() << " "; // データ値にアクセス
  std::cout << 3 << " ";
  source(); // 制御を戻す
  std::cout << source.get() << " "; 
}

int main() 
{
  std::cout << 1 << " ";
  coro_t::push_type sink(func); // コンストラクタはコルーチン関数に入らない
  sink(2); // {2}をコルーチン関数に push する
  std::cout << 4 << " ";
  sink(5); // {5}をコルーチン関数に push する
  std::cout << 6 << " ";
}
```

実行結果：
```
1 2 3 4 5 6
```

## <a id="range_iterator" href="#range_iterator">範囲イテレータを使う</a>

Boost.Coroutine2 は出力反復子と入力反復子を提供している。

### <a id="input_iterator" href="#input_iterator">入力反復子</a>
入力反復子は、`coroutine<>::pull_type`から作成できる。

```cpp example
#include <boost/coroutine2/coroutine.hpp>
#include <iostream>

typedef boost::coroutines2::coroutine<int> coro_t;

int main() 
{
  coro_t::pull_type source(
    [](coro_t::push_type & sink) 
    {
      for (auto i = 0; i < 10; ++i)
        sink(i);
    });

  for (auto i : source)
    std::cout << i <<  " ";
}
```

実行結果：
```
0 1 2 3 4 5 6 7 8 9 
```

### <a id="output_iterator" href="#output_iterator">出力反復子</a>
出力反復子は、`coroutine<>::push_type`から作成できる。

```cpp example
#include <boost/coroutine2/coroutine.hpp>
#include <algorithm>
#include <iostream>

typedef boost::coroutines2::coroutine<int> coro_t;

int main() 
{
  coro_t::push_type sink(
    [&](coro_t::pull_type& source){
      while(source){
        std::cout << source.get() <<  " ";
        source();
      }
    });

  std::vector<int> v{1, 1, 2, 3, 5};
  std::copy(begin(v), end(v), begin(sink));
}
```

実行結果：
```
1 1 2 3 5 
```
