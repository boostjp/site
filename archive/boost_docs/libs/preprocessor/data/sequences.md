# Sequences

A *sequence* (abbreviated to *seq*) is a group of adjacent parenthesized elements.
For example,

```cpp
(a)(b)(c)
```

...is a `seq` of `3` elements--`a`, `b`, and `c`.

*Sequences* are data structures that merge the properties of both *lists* and *tuples* with the exception that a *seq* cannot be empty.
Therefore, an "empty" *seq* is considered a special case scenario that must be handled separately in C++.

```cpp
# define SEQ (x)(y)(z)
# define REVERSE(s, state, elem) (elem) state
	// append to head                 ^

BOOST_PP_SEQ_FOLD_LEFT(REVERSE, BOOST_PP_EMPTY, SEQ)()
	//                          #1                  #2
	// 1) placeholder for "empty" seq
	// 2) remove placeholder

# define SEQ_B (1)(2)(3)
# define INC(s, state, elem) state (BOOST_PP_INC(elem))
	// append to tail            ^

BOOST_PP_SEQ_FOLD_RIGHT(INC, BOOST_PP_SEQ_NIL, SEQ)
	//                       ^
	// special placeholder that will be "eaten"
	// by appending to the tail
```

*Sequences* are extremely efficient.
Element access speed approaches random access--even with *seqs* of up to *256* elements.
This is because element access (among other things) is implemented iteratively rather than recursively.
Therefore, elements can be accessed at extremely high indices even on preprocessors with low maximum expansion depths.

Elements of a *seq* can be extracted with `BOOST_PP_SEQ_ELEM`.

## Primitives

- `BOOST_PP_SEQ_ELEM`

