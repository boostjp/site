# BOOST_PP_IS_SELFISH

`BOOST_PP_IS_SELFISH` マクロは *自己インクルード* が進行中の時に定義される。

## Usage

```cpp
#if !defined(BOOST_PP_IS_SELFISH) // ...
```

## Remarks

*自己インクルード* が進行中の時、このマクロは `1` に定義される。
これは、次のものも動作することを意味する:

```cpp
#if !BOOST_PP_IS_SELFISH // ...
```

このマクロはファイルの無限インクルードを防ぐために定義される。

