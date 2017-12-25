# Smart Pointer Changes

The February 2002 change to the Boost smart pointers introduced a number of changes.
Since the previous version of the smart pointers was in use for a long time, it's useful to have a detailed list of what changed from a library
user's point of view.

Note that for compilers that don't support member templates well enough, a separate implementation is used that lacks many of the new features and is more like the old version.

## Features Requiring Code Changes to Take Advantage

- The smart pointer class templates now each have their own header file.
  For compatibility, the [&lt;boost/smart_ptr.hpp&gt;](http://www.boost.org/doc/libs/1_31_0/boost/smart_ptr.hpp) header now includes the headers for the four classic smart pointer class templates.
- The `weak_ptr` template was added.
- The new `shared_ptr` and `shared_array` relax the requirement that the pointed-to object's destructor must be visible when instantiating the `shared_ptr` destructor.
  This makes it easier to have `shared_ptr` members in classes without explicit destructors.
- A custom deallocator can be passed in when creating a `shared_ptr` or `shared_array`.
- `shared_static_cast` and `shared_dynamic_cast` function templates are provided which work for `shared_ptr` and `weak_ptr` as `static_cast` and `dynamic_cast` do for pointers.
- The self-assignment misfeature has been removed from `shared_ptr::reset`, although it is still present in `scoped_ptr`, and in `std::auto_ptr`.
  Calling `reset` with a pointer to the object that's already owned by the `shared_ptr` results in undefined behavior (an assertion, or eventually a double-delete if assertions are off).
- The `BOOST_SMART_PTR_CONVERSION` feature has been removed.
- `shared_ptr<void>` is now allowed.

## Features That Improve Robustness

- The manipulation of use counts is now <a id="threadsafe">thread safe</a> on Windows, Linux, and platforms that support pthreads.
  See the [&lt;boost/detail/atomic_count.hpp&gt;](http://www.boost.org/doc/libs/1_31_0/boost/detail/atomic_count.hpp) file for details
- The new `shared_ptr` will always delete the object using the pointer it was originally constructed with.
  This prevents subtle problems that could happen if the last `shared_ptr` was a pointer to a sub-object of a class that did not have a virtual destructor.

## Implementation Details

- Some bugs in the assignment operator implementations and in `reset` have been fixed by using the &quot;copy and swap&quot; idiom.
- Assertions have been added to check preconditions of various functions; however, since these use the new [&lt;boost/assert.hpp&gt;](http://www.boost.org/doc/libs/1_31_0/boost/assert.hpp) header, the assertions are disabled by default.
- The partial specialization of `std::less` has been replaced by `operator<` overloads which accomplish the same thing without relying on undefined behavior.
- The incorrect overload of `std::swap` has been replaced by `boost::swap`, which has many of the same advantages for generic programming but does not violate the C++ standard.

---

Revised 1 February 2002

Copyright 2002 Darin Adler.
Permission to copy, use, modify, sell and distribute this document is granted provided this copyright notice appears in all copies.
This document is provided &quot;as is&quot; without express or implied warranty, and with no claim as to its suitability for any purpose.

