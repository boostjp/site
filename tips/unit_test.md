# 単体テスト
単体テストには、[Boost Test Library](http://www.boost.org/doc/libs/release/libs/test/doc/html/index.html)を使用する。


## インデックス
- [等値テスト](#equality-test)
- [浮動小数点数の等値テスト](#floating-point-equality-test)
- [例外が投げられるかどうかのテスト](#throw-test)


## <a id="equality-test" href="#equality-test">等値テスト</a>
等値テストには、`BOOST_CHECK`マクロに条件式を指定する。

```cpp
# define BOOST_TEST_MAIN
#include <boost/test/included/unit_test.hpp>

BOOST_AUTO_TEST_CASE(test1)
{
    const int x = 1;
    BOOST_CHECK(x == 1);
}
```

実行結果：
```
Running 1 test case...

*** No errors detected
```


## <a id="floating-point-equality-test" href="#floating-point-equality-test">浮動小数点数の等値テスト</a>
浮動小数点数の等値テストには、`BOOST_CHECK_CLOSE`マクロに、比較対象の2つの変数と、許容する誤差（%）を指定する。

```cpp
# define BOOST_TEST_MAIN
#include <boost/test/included/unit_test.hpp>

BOOST_AUTO_TEST_CASE(test1)
{
    const double v1 = 1.23456e28;
    const double v2 = 1.23457e28;
 
    BOOST_CHECK_CLOSE(v1, v2, 0.0001);
}
```

実行結果：
```
Running 1 test case...
test.cpp(9): error in "test1": difference{0.000809999%} between v1{1.2345599999999999e+028} and v2{1.23457e+028} exceeds 0.0001%

*** 1 failure detected in test suite "Master Test Suite"
```

`0`との等値テストには`BOOST_CHECK_CLOSE`マクロが使えない。代わりに、`BOOST_CHECK_SMALL`マクロに、比較対象の変数と、許容する誤差（絶対誤差）を指定する。

```cpp
# define BOOST_TEST_MAIN
#include <boost/test/included/unit_test.hpp>

BOOST_AUTO_TEST_CASE( test1 )
{
    const double v = -1.23456e-3;

    BOOST_CHECK_SMALL( v, 1e-4 );
}
```

実行結果：
```
Running 1 test case...
test.cpp(8): error in "test1": absolute value of v{-0.00123456} exceeds 0.0001

*** 1 failure detected in test suite "Master Test Suite"
```


## <a id="throw-test" href="#throw-test">例外が投げられるかどうかのテスト</a>
`BOOST_CHECK_THROW`マクロは、ある式が指定した例外を投げるかどうかをテストする。

```cpp
# define BOOST_TEST_MAIN
#include <vector>
#include <boost/test/included/unit_test.hpp>

BOOST_AUTO_TEST_CASE(test1)
{
    std::vector<int> v;
    BOOST_CHECK_THROW(v.at(1), std::out_of_range);
}
```


実行結果：
```
Running 1 test case...

*** No errors detected
```

