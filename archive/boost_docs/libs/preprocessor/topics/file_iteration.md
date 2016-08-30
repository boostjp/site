#File Iteration

File iteration is a complex, but powerful, vertical repetition construct.
It repeatedly includes a *file* for each number in a user-specified range.

##Tutorial

This mechanism requires two pieces of information to operate:
a range to iterate over and a file to include on each iteration.
It can optionally take a third piece of information that represents flags used to discriminate between different iterations of the same file.
This information is obtained by the mechanism through one or two *named external arguments*.
These arguments are specified as user-defined macros named `BOOST_PP_ITERATION_PARAMS_x` or the combination of `BOOST_PP_FILENAME_x` and `BOOST_PP_ITERATION_LIMITS`.

`BOOST_PP_ITERATION_LIMITS` specifies the range of values to iterate over.
It *must* expand to a *tuple* containing two elements--a lower and upper bound.
Both the upper and lower bounds must be numeric values in the range of *0* to `BOOST_PP_LIMIT_ITERATION`.
For example, if the user wishes a file to be included for numbers ranging from *0* to *10*, `BOOST_PP_ITERATION_LIMITS` would be defined like this:

```cpp
#define BOOST_PP_ITERATION_LIMITS (0, 10)
```

Note that there is whitespace after the name of the macro.
The macro *does not* take *two* arguments.
In the case above, if there was no whitespace, a preprocessing error would occur because *0* and *10* are invalid identifiers.

Both the upper and lower bounds specified in the `BOOST_PP_ITERATION_LIMITS` macro are *evaluated parameters*.
This implies that they can include simple arithmetic or logical expressions.
For instance, the above definition could easily have been written like this:

```cpp
#define N() 5
#define BOOST_PP_ITERATION_LIMITS (0, N() + 5)
```

Because of this, if the whitespace after the macro name is elided, it is possible for the definition to be syntactically valid:

```cpp
#define A 0
#define B 10
#define BOOST_PP_ITERATION_LIMITS(A, B)
	// note:  no whitespace      ^
```

If this happens, an error will occur inside the mechanism when it attempts to use this macro.
The error messages that result may be obscure, so always remember to include the whitespace.
A *correct* version of the above looks like this:

```cpp
#define A 0
#define B 10
#define BOOST_PP_ITERATION_LIMITS (A, B)
	// note:  has whitespace     ^
```

`BOOST_PP_FILENAME_x` specifies the file to iterate over.
The *x* is a placeholder for the dimension of iteration.
(For now, we'll assume this is *1* --i.e. the first dimension, so we are actually dealing with `BOOST_PP_FILENAME_1`.)
This macro must expand to a valid filename--in quotes or in angle brackets depending on how the file is accessed:

```cpp
#define BOOST_PP_FILENAME_1 "file.h"
// -or-
#define BOOST_PP_FILENAME_1 <file.h>
```

All that we need now to perform a simple file iteration is to invoke the mechanism:

```cpp
??=include BOOST_PP_ITERATE()
```

(The `??=` token is a trigraph for `#`.
 I use the trigraph to make it clear that I am *including* a file rather than defining or expanding a macro, but it is not necessary.
 Even the digraph version, `%:`, could be used.
 Some compilers do not readily accept trigraphs and digraphs, so keep that in mind.
 Other than that, use whichever one you prefer.)

So, if we wish to iterate "file.h" from *1* to *10*, we just need to put the pieces together:

```cpp
#define BOOST_PP_ITERATION_LIMITS (1, 10)
#define BOOST_PP_FILENAME_1 "file.h"
??=include BOOST_PP_ITERATE()
```

The above code has the effect of including "file.h" ten times in succession.

Alternately, both the range and the file to iterate over can be expressed in one macro, `BOOST_PP_ITERATION_PARAMS_x`.
Once again, the *x* is a placeholder for the dimension of iteration--which we'll assume is *1*.
This macro must expand to an *array* that includes the lower bound, upper bound, filename, and optional flags (in that order).

```cpp
#define BOOST_PP_ITERATION_PARAMS_1 (3, (1, 10, "file.h"))
??=include BOOST_PP_ITERATE()
```

This has the same effect as the previous version.
Only one of these two ways to specify the parameters can be used at a time.
(The reason that there are two different methods has to do with dimensional abstraction which I'll get to later.)

There is nothing particularly useful about including a file ten times.
The difference is that the current macro state changes each time.
For example, the current "iteration value" is available with `BOOST_PP_ITERATION()`.
If "file.h" is defined like this...

```cpp
// file.h
template<> struct sample<BOOST_PP_ITERATION()> { };
```

...and it is iterated as follows...

```cpp
template<int> struct sample;

#define BOOST_PP_ITERATION_PARAMS_1 (3, (1, 5, "file.h"))
??=include BOOST_PP_ITERATE()
```

...the result is different each time:

```cpp
template<> struct sample<1> { };
template<> struct sample<2> { };
template<> struct sample<3> { };
template<> struct sample<4> { };
template<> struct sample<5> { };
```

There is no reason that a file can't iterate over itself.
This has the advantage of keeping the code together.
The problem is that you have to discriminate the "regular" section of the file from the iterated section of the file.
The library provides the `BOOST_PP_IS_ITERATING` macro to help in this regard.
This macro is defined as *1* if an iteration is in progress.
For example, to merge the contents of "file.h" into the file that iterates it:

```cpp
// sample.h
#if !BOOST_PP_IS_ITERATING

	#ifndef SAMPLE_H
	#define SAMPLE_H

	#include <boost/preprocessor/iteration/iterate.hpp>

	template<int> struct sample;

	#define BOOST_PP_ITERATION_PARAMS_1 (3, (1, 5, "sample.h"))
	??=include BOOST_PP_ITERATE()

	#endif // SAMPLE_H

#else

	template<> struct sample<BOOST_PP_ITERATION()> { };

#endif
```

Using the same file like this raises another issue.
What happens when a file performs two separate file iterations over itself?
This is the purpose of the optional flags parameter.
It is used to discriminate between separate iterations.

```cpp
// sample.h
#if !BOOST_PP_IS_ITERATING

	#ifndef SAMPLE_H
	#define SAMPLE_H

	#include <boost/preprocessor/iteration/iterate.hpp>
	#include <boost/preprocessor/repetition/enum_params.hpp>
	#include <boost/preprocessor/repetition/enum_shifted_params.hpp>

	template<int> struct sample;

	#define BOOST_PP_ITERATION_PARAMS_1 (4, (1, 5, "sample.h", 1))
	??=include BOOST_PP_ITERATE()

	template<class T, class U> struct typelist_t {
		typedef T head;
		typedef U tail;
	};

	template<int> struct typelist;
	struct null_t;

	template<> struct typelist<1> {
		template<class T0> struct args {
			typedef typelist_t<T0, null_t> type;
		};
	};

	#ifndef TYPELIST_MAX
	#define TYPELIST_MAX 50
	#endif

	#define BOOST_PP_ITERATION_PARAMS_1 (4, (2, TYPELIST_MAX, "sample.h", 2))
	??=include BOOST_PP_ITERATE()

	#endif // SAMPLE_H

#elif BOOST_PP_ITERATION_FLAGS() == 1

	template<> struct sample<BOOST_PP_ITERATION()> { };

#elif BOOST_PP_ITERATION_FLAGS() == 2

	#define N BOOST_PP_ITERATION()

	template<> struct typelist<N> {
		template<BOOST_PP_ENUM_PARAMS(N, class T)> struct args {
			typedef typelist_t<
				T0,
				typename typelist<N - 1>::args<BOOST_PP_ENUM_SHIFTED_PARAMS(N, T)>::type
			> type;
		};
	};

	#undef N

#endif
```

Notice the use of the "flags" parameter (which is accessed through `BOOST_PP_ITERATION_FLAGS()`).
It discriminates between our recurring `sample` iteration and a typelist linearization iteration.

The second iteration illustrates the power of the file iteration mechanism.
It generates typelist linearizations of the form `typelist<3>::args<int, double, char>::type`.

Actually, to continue the typelist example, with the help of another iteration we can *fully* linearize typelist creation....

```cpp
// extract.h
#if !BOOST_PP_IS_ITERATING

	#ifndef EXTRACT_H
	#define EXTRACT_H

	#include <boost/preprocessor/iteration/iterate.hpp>
	#include <boost/preprocessor/repetition/enum.hpp>
	#include <boost/preprocessor/repetition/enum_params.hpp>
	#include <boost/preprocessor/repetition/enum_trailing_params.hpp>

	// certain types such as "void" can't be function argument types

	template<class T> struct incomplete {
		typedef T type;
	};

	template<class T> struct strip_incomplete {
		typedef T type;
	};

	template<class T> struct strip_incomplete<incomplete<T> > {
		typedef T type;
	};

	template<template<int> class output, class func_t> struct extract;

	#ifndef EXTRACT_MAX
	#define EXTRACT_MAX 50
	#endif

	#define BOOST_PP_ITERATION_PARAMS_1 (3, (1, EXTRACT_MAX, "extract.h"))
	??=include BOOST_PP_ITERATE()

	#endif // EXTRACT_H

#else

#define N BOOST_PP_ITERATION()
	#define STRIP(z, n, _) \
		typename strip_incomplete<T ## n>::type \
		/**/

	template<template<int> class output, class R BOOST_PP_ENUM_TRAILING_PARAMS(N, class T)>
	struct extract<R (BOOST_PP_ENUM_PARAMS(N, T))> {
		typedef typename output<N>::template args<BOOST_PP_ENUM(N, STRIP, nil)>::type type;
	};

	#undef STRIP
	#undef N

#endif
```

Now we can define a helper macro to finish the job:

```cpp
#define TYPELIST(args) extract<typelist, void args>::type

typedef TYPELIST((int, double, incomplete<void>)) xyz;
```

There are two minor caveats with this result.
First, certain types like `void` can't be the type of an argument, so they have to be wrapped with `incomplete<T>`.
Second, the necessary double parenthesis is annoying.
If and when C++ gets C99's variadic macros, `TYPELIST` can be redefined:

```cpp
#define TYPELIST(...) extract<typelist, void (__VA_ARGS__)>::type

typedef TYPELIST(int, double, short) xyz;
```

Note also that both the lower and upper bounds of an iteration are also accessible inside an iteration with `BOOST_PP_ITERATION_START()` and `BOOST_PP_ITERATION_FINISH()`.

It is my hope that the explanation and examples presented here demonstrate the power of file iteration.
Even so, this is just the beginning.
The file iteration mechanism also defines a full suite of facilities to support multidimensional iteration.

##Multiple Dimensions

The file iteration mechanism supports up to `BOOST_PP_LIMIT_ITERATION_DIM` dimensions.
The first dimension (i.e. the outermost) we have already used above.
In order to use the second dimension (inside the first), we simply have to replace the placeholder *x* with *2* instead of *1*.

```cpp
#define BOOST_PP_ITERATION_PARAMS_2 /* ... */
                                  ^
```

...or...

```cpp
#define BOOST_PP_FILENAME_2 /* ... */
                          ^
```

Each dimension must be used *in order* starting with *1*.
Therefore, the above can *only* be valid immediately inside the first dimension.

At this point, further explanation is necessary regarding `BOOST_PP_ITERATION`, `BOOST_PP_ITERATION_START`, and `BOOST_PP_ITERATION_FINISH`.
`BOOST_PP_ITERATION()` expands to the iteration value of the *current* dimension--regardless of what dimension that is.
Likewise, `BOOST_PP_ITERATION_START()` and `BOOST_PP_ITERATION_FINISH()` expand to the lower and upper bounds of the *current* dimension.
Using the following pseudo-code as reference:

```cpp
for (int i = start(1); i <= finish(1); ++i) {
	// A
	for (int j = start(2); j <= finish(2); ++j) {
		// B
	}
	// C
}
```

At point *A*, `BOOST_PP_ITERATION()` refers to `i`.
`BOOST_PP_ITERATION_START()` and `BOOST_PP_ITERATION_FINISH()` refer to `start(1)` and `finish(1)` respectively.
At point *B*, however, `BOOST_PP_ITERATION()` refers to `j` --the *current* iteration value at point *B*.
The same is true for `BOOST_PP_ITERATION_START()` which refers to `start(2)`, etc..

If separate files are used for each dimension, then there are no major problems, and using multiple dimensions is straightforward.
However, if more than one dimension is located in the same file, they need to be distinguished from one another.
The file iteration mechanism provides the macro `BOOST_PP_ITERATION_DEPTH` for this purpose:

```cpp
// file.h
#if !BOOST_PP_IS_ITERATING

	#ifndef FILE_H
	#define FILE_H

	#include <boost/preprocessor/iteration/iterate.hpp>

	#define BOOST_PP_ITERATION_PARAMS_1 (3, (1, 2, "file.h"))
	??=include BOOST_PP_ITERATE()

	#endif // FILE_H

#elif BOOST_PP_ITERATION_DEPTH() == 1

	// A
	+ BOOST_PP_ITERATION()

	#define BOOST_PP_ITERATION_PARAMS_2 (3, (1, 2, "file.h"))
	??=include BOOST_PP_ITERATE()

	// C

#elif BOOST_PP_ITERATION_DEPTH() == 2

	// B
	- BOOST_PP_ITERATION()

#endif
```

This will result to the following:

```cpp
+ 1
- 1
- 2
+ 2
- 1
- 2
```

Multiple dimensions raise another question.
How does one access the state of dimensions *other* than the current dimension?
In other words, how does one access `i` at point *A* ?
Because of the preprocessor's lazy evaluation, this *doesn't* work....

```cpp
// ...

#elif BOOST_PP_ITERATION_DEPTH() == 1

	#define I BOOST_PP_ITERATION()

	#define BOOST_PP_ITERATION_PARAMS_2 (3, (1, 2, "file.h"))
	??=include BOOST_PP_ITERATE()

	#undef I

#elif BOOST_PP_ITERATION_DEPTH() == 2

	#define J BOOST_PP_ITERATION()

	// use I and J

	#undef I

#endif
```

The problem here is that `I` refers to `BOOST_PP_ITERATION()`, not to the *value* of `BOOST_PP_ITERATION()` at the point of `I` 's definition.

The library provides macros to access these values in two ways--absolutely or relatively.
The first variety accesses a value of a specific iteration frame (i.e. dimension).
To access the iteration value of the first dimension--from *any* dimension-- `BOOST_PP_FRAME_ITERATION(1)` is used.
To access the iteration value of the second dimension, `BOOST_PP_FRAME_ITERATION(2)` is used, and so on.

There are also frame versions to access the lower bound, the upper bound, and the flags of a dimension:
`BOOST_PP_FRAME_START`, `BOOST_PP_FRAME_FINISH`, and `BOOST_PP_FRAME_FLAGS`.

So, to fix the last example, we modify the definition of `I` ....

```cpp
// ...

#elif BOOST_PP_ITERATION_DEPTH() == 1

	#define I BOOST_PP_FRAME_ITERATION(1)

// ...
```

The library also provides macros to access values in dimensions *relative* to the current dimension (e.g. the *previous* dimension).
These macros take an argument that is interpreted as an offset from the current frame.
For example, `BOOST_PP_RELATIVE_ITERATION(1)` always refers to the outer dimension immediately previous to the current dimension.
An argument of *0* is interpreted as an offset of *0* which causes `BOOST_PP_RELATIVE_ITERATION(0)` to be equivalent to `BOOST_PP_ITERATION()`.
`BOOST_PP_RELATIVE_ITERATION(2)` refers to the iteration value of the dimension immediately preceding the dimension that precedes the current dimension.

The lower and upper bounds of a dimension can be accessed in this fashion as well with `BOOST_PP_RELATIVE_START` and `BOOST_PP_RELATIVE_FINISH`.
The flags of a relative dimension can be accessed with `BOOST_PP_RELATIVE_FLAGS`.

##Relativity

I mentioned earlier that there is a reason that there are two ways to parametize the mechanism.
The reason is dimensional abstraction.
In certain situations the dimension is unknown by the code that is being iterated--possibly because the code is reused at multiple, different dimensions.
If that code needs to iterate again, it has to define the right parameters (based on the dimension) for the mechanism to consume.

All of the macro state maintained by the mechanism can be referred to in an indirect way relative to a dimension.
This is the purpose of the `BOOST_PP_RELATIVE_` accessors.

Likewise, the user-defined *named external arguments* can be defined this way as well-- *except* the name of the file to iterate.
Because the lower and upper boundaries are *evaluated* by the mechanism, the implementation no longer needs the macro `BOOST_PP_ITERATION_LIMITS`, and the identifier can be reused for each dimension of iteration.

Unfortunately, the filename is a different story.
The library has no way to evaluate the quoted (or angle-bracketed) text.
Therefore, it has to use a different macro for each dimension.
That is the purpose of the `BOOST_PP_FILENAME_x` macros.
They exist to isolate the only non-abstractable piece of data required by the mechanism.

In order to define the filename in an abstract fashion, you need to do something like this:

```cpp
#define UNIQUE_TO_FILE "some_file.h"

#if BOOST_PP_ITERATION_DEPTH() == 0
	#define BOOST_PP_FILENAME_1 UNIQUE_TO_FILE
#elif BOOST_PP_ITERATION_DEPTH() == 1
	#define BOOST_PP_FILENAME_2 UNIQUE_TO_FILE
#elif BOOST_PP_ITERATION_DEPTH() == 2
	#define BOOST_PP_FILENAME_3 UNIQUE_TO_FILE

// ... up to BOOST_PP_LIMIT_ITERATION_DIM

#endif
```

The intent is to avoid having to do this for anything but the filename.
If this needs to be done more than once in a file (`BOOST_PP_FILENAME_x` is undefined by the mechanism after it is used.), consider using a separate file to make the proper definition:

```cpp
#// detail/define_file_h.h
#ifndef FILE_H
#	error FILE_H is not defined
#endif
#
#if BOOST_PP_ITERATION_DEPTH() == 0
#	define BOOST_PP_FILENAME_1 FILE_H
#elif BOOST_PP_ITERATION_DEPTH() == 1
#	define BOOST_PP_FILENAME_2 FILE_H
#elif BOOST_PP_ITERATION_DEPTH() == 2
#	define BOOST_PP_FILENAME_3 FILE_H
#elif BOOST_PP_ITERATION_DEPTH() == 3
#	define BOOST_PP_FILENAME_4 FILE_H
#elif BOOST_PP_ITERATION_DEPTH() == 4
#	define BOOST_PP_FILENAME_5 FILE_H
#else
#	error unsupported iteration dimension
#endif
```

And then use it like this....

```cpp
// file.h
#if !BOOST_PP_IS_ITERATING

	#ifndef FILE_H
	#define FILE_H "file.h"

	#define BOOST_PP_ITERATION_LIMITS (1, 10)
	#include "detail/define_file_h.h"

	??=include BOOST_PP_ITERATE()

#endif // FILE_H

#else
	// iterated portion
#endif
```

With a little effort like this, it is possible to maintain the abstraction without the code bloat that would otherwise be required.
Unfortunately, this is not a completely general solution as it would need to be done for each unique filename, but it is better than nothing.

##Conclusion

That about covers the facilities that are available from the mechanism.
Using these facilities, let's implement a `function_traits` template to demonstrate a full-fledge use of the mechanism.

##Function Traits - An Involved Example

Implementing a comprehensive `function_traits` template metafunction requires the use of every major part of the file iteration mechanism.

(This example makes no attempt of work around compiler deficiencies and exists only to illustrate the mechanism.)

The result should have the following features:

- return type
- number and types of parameters
- whether or not the type is a pointer-to-function, reference-to-function, pointer-to-member-function, or a plain function type
- whether the type has an ellipsis
- if not a pointer-to-member-function, the equivalent pointer-to-function, reference-to-function, and function type
- otherwise, the pointer-to-member type, the class type to which it refers, and whether it is const and/or volatile qualified

There are a myriad of ways that this can be implemented.
I'll give a brief summary here of what is happening in the implementation below.

The implementation inherently has to deal with function arity.
Therefore, at minimum, we need to iterate over function arities and define partial specializations of the primary template `function_traits`.
The situation is further complicated by variadic functions (i.e. functions with an ellipsis).
Therefore, for every arity, we need a variadic version as well.

We also need to handle pointers-to-member-functions.
This implies that we have to handle not just arity and variadics, but also cv-qualifications.

For the sake of clarity, the implementation below handles function types and pointers-to-member-functions separately.
They could be merged, but the result would be significantly messier.

To handle function types, the implementation below iterates over function arities.
For each arity, it iterates over each parameter to provide access to each individually.
It then re-includes itself to define a variadic specialization of the same arity.
It performs the rough equivalent of the following pseudo-code:

```cpp
void make_spec(int i, bool variadic) {
	:open function_traits<i, variadic>
	for (int j = 0; j < i; ++j) {
		:parameter<j>
	}
	:close
	if (!variadic) {
		make_spec(i, true);
	}
	return;
}

void function_types(int max_arity) {
	for (int i = 0; i <= max_arity; ++i) {
		make_spec(i, false);
	}
	return;
}
```

The implementation of pointers-to-member-functions is a bit different.
First, it iterates over cv-qualifiers.
For each cv-qualifier, it iterates over function arities.
For each function arity, it iterates again over each parameter.
It then re-includes itself to define a variadic specialization of the same arity....

```cpp
void make_spec(int j, const char* cv, bool variadic) {
	:open function_traits<j, cv, variadic>
	for (int k = 0; k < j; ++k) {
		parameter<k>
	}
	:close
	if (!variadic) {
		make_spec(j, cv, true);
	}
	return;
}

void gen_arities(const char* cv, int max_arity) {
	for (int j = 0; j <= max_arity; ++j) {
		make_spec(j, cv, false);
	}
	return;
}

void pointers_to_members(int max_arity) {
	static const char* cv_qualifiers[] = { "", "const", "volatile", "const volatile" };
	for (int i = 0; i < 4; ++i) {
		gen_arities(cv_qualifiers[i], max_arity);
	}
	return;
}
```

Here is the complete implementation.
This example represents the power of the file iteration mechanism as well as the library in general, so follow it carefully if you wish to fully understand what the mechanism does....

```cpp
// function_traits.hpp

#if !BOOST_PP_IS_ITERATING

#ifndef FUNCTION_TRAITS_HPP
#define FUNCTION_TRAITS_HPP

#include <boost/preprocessor/cat.hpp>
#include <boost/preprocessor/facilities/apply.hpp>
#include <boost/preprocessor/iteration/iterate.hpp>
#include <boost/preprocessor/iteration/self.hpp>
#include <boost/preprocessor/repetition/enum_params.hpp>
#include <boost/preprocessor/repetition/enum_trailing_params.hpp>
#include <boost/preprocessor/tuple/elem.hpp>

// enable user-expansion
#ifndef FUNCTION_TRAITS_MAX_ARITY
	#define FUNCTION_TRAITS_MAX_ARITY 15
#endif

namespace detail {

// avoid replication of "default" values
struct function_traits_base {
	static const bool is_plain = false;
	static const bool is_pointer = false;
	static const bool is_reference = false;
	static const bool is_member = false;
};

} // detail

// no definition
template<class> struct function_traits;

// extract ellipsis state
#define ELLIPSIS(n) \
	BOOST_PP_APPLY( \
		BOOST_PP_TUPLE_ELEM(2, n, ELLIPSIS_I) \
	) \
	/**/

// iterate over function arities for function types
#define BOOST_PP_ITERATION_PARAMS_1 \
	(4, (0, FUNCTION_TRAITS_MAX_ARITY, "function_traits.hpp", 0)) \
	/**/
??=include BOOST_PP_ITERATE()

// obtain a cv-qualifier by index
#define QUALIFIER(n) \
	BOOST_PP_APPLY( \
		BOOST_PP_TUPLE_ELEM( \
			4, n, \
			(BOOST_PP_NIL, (const), (volatile), (const volatile)) \
		) \
	) \
	/**/

// iterate over cv-qualifiers for pointers-to-members
#define BOOST_PP_ITERATION_PARAMS_1 \
	(4, (0, 3, "function_traits.hpp", 1)) \
	/**/
??=include BOOST_PP_ITERATE()

// remove temporary macros
#undef QUALIFIER
#undef ELLIPSIS

// overriding jumper for pointers-to-functions
template<class T> struct function_traits<T*> : function_traits<T> {
	static const bool is_plain = false;
	static const bool is_pointer = true;
};

// overriding jumper for references-to-functions
template<class T> struct function_traits<T&> : function_traits<T> {
	static const bool is_plain = false;
	static const bool is_reference = true;
};

// eof
#endif // FUNCTION_TRAITS_HPP

// specializations for function types
#elif BOOST_PP_ITERATION_DEPTH() == 1 \
	&& BOOST_PP_ITERATION_FLAGS() == 0 \
	/**/

// define ellipsis state
	#if BOOST_PP_IS_SELFISH
		#define ELLIPSIS_I ((true), (...))
	#else
		#define ELLIPSIS_I ((false), BOOST_PP_NIL)
	#endif

	#define N BOOST_PP_ITERATION()

	template<class R BOOST_PP_ENUM_TRAILING_PARAMS(N, class T)>
	struct function_traits<R (BOOST_PP_ENUM_PARAMS(N, T) ELLIPSIS(1))>
		: detail::function_traits_base {
		static const bool is_plain = true;
		typedef R function_type(BOOST_PP_ENUM_PARAMS(N, T) ELLIPSIS(1));
		typedef function_type* pointer_type;
		typedef function_type& reference_type;
		static const bool has_ellipsis = ELLIPSIS(0);
		typedef R return_type;
		static const int parameter_count = N;
		template<int, class D = int> struct parameter;
		#if N
			// iterate over parameters
			#define BOOST_PP_ITERATION_PARAMS_2 \
				(3, (0, N - 1, "function_traits.hpp")) \
				/**/
			??=include BOOST_PP_ITERATE()
		#endif
	};

	#undef N
	#undef ELLIPSIS_I

	// re-include this section for an ellipsis variant
	#if !BOOST_PP_IS_SELFISH
	#define BOOST_PP_INDIRECT_SELF "function_traits.hpp"
		??=include BOOST_PP_INCLUDE_SELF()
	#endif

// iteration over cv-qualifiers
#elif BOOST_PP_ITERATION_DEPTH() == 1 \
	&& BOOST_PP_ITERATION_FLAGS() == 1 \
	/**/

	#define BOOST_PP_ITERATION_PARAMS_2 \
		(3, (0, FUNCTION_TRAITS_MAX_ARITY, "function_traits.hpp")) \
		/**/
	??=include BOOST_PP_ITERATE()

// generate specializations for pointers-to-members
#elif BOOST_PP_ITERATION_DEPTH() == 2 \
	&& BOOST_PP_FRAME_FLAGS(1) == 1 \

	// define ellipsis state
	#if BOOST_PP_IS_SELFISH
		#define ELLIPSIS_I ((true), (...))
	#else
		#define ELLIPSIS_I ((false), BOOST_PP_NIL)
	#endif

	#define N BOOST_PP_ITERATION()
	#define Q QUALIFIER(BOOST_PP_FRAME_ITERATION(1))

	template<class R, class O BOOST_PP_ENUM_TRAILING_PARAMS(N, class T)>
	struct function_traits<R (O::*)(BOOST_PP_ENUM_PARAMS(N, T) ELLIPSIS(1)) Q>
		: detail::function_traits_base {
		static const bool is_member = true;
		typedef R (O::* pointer_to_member_type)(BOOST_PP_ENUM_PARAMS(N, T) ELLIPSIS(1)) Q;
		typedef O class_type;
		typedef Q O qualified_class_type;
		static const bool has_ellipsis = ELLIPSIS(0);
		static const bool is_const =
			BOOST_PP_FRAME_ITERATION(1) == 1 || BOOST_PP_FRAME_ITERATION(1) == 3;
		static const bool is_volatile =
			BOOST_PP_FRAME_ITERATION(1) == 2 || BOOST_PP_FRAME_ITERATION(1) == 3;
		typedef R return_type;
		static const int parameter_count = N;
		template<int, class D = int> struct parameter;
		#if N
			// iterate over parameters
			#define BOOST_PP_ITERATION_PARAMS_3 \
				(3, (0, N - 1, "function_traits.hpp")) \
				/**/
			??=include BOOST_PP_ITERATE()
		#endif
	};

	#undef Q
	#undef N
	#undef ELLIPSIS_I

	// re-include this section for an ellipsis variant
	#if !BOOST_PP_IS_SELFISH
		#define BOOST_PP_INDIRECT_SELF "function_traits.hpp"
		??=include BOOST_PP_INCLUDE_SELF()
	#endif

// parameter specializations
#else

	#define X BOOST_PP_ITERATION()

		template<class D> struct parameter<X, D> {
			typedef BOOST_PP_CAT(T, X) type;
		};

	#undef X

#endif
```

One problem that still exists is the lack of support for `throw` specifications.
There is no way that we can completely handle it anyway because we cannot partially specialize on `throw` specifications.
However, we could accurately report the "actual" function type, etc., including the `throw` specification (which the above implementation doesn't do, as it reconstructs those types).
If you like, you can figure out how to do that on your own as an exercise.

##See Also

- [BOOST_PP_ITERATE](../ref/iterate.html)

---

Paul Mensonides

