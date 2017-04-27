# BOOST_PP_IS_ITERATING

`BOOST_PP_IS_ITERATING` マクロは *ファイル繰り返し* が進行中の時に定義される。

## Usage

```cpp
#if !defined(BOOST_PP_IS_ITERATING) // ...
```

## Remarks

*ファイル繰り返し* が進行中の時、このマクロは `1` に定義される。
これは、次のものも動作することを意味する:

```cpp
#if !BOOST_PP_IS_ITERATING // ...
```

このマクロはファイルの無限繰り返しを防ぐために定義される。

