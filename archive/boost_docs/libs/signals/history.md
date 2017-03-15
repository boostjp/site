# Boost.Signals Revision History

### 2002-06-10

- Added workarounds for Qt's rude introduction of keywords `signals` and `slots` (patch by Thomas Witt)

### 2002-05-17

- Integrated into Boost CVS
- Document call behavior when no slots present (Thomas Witt)
- Document default combiner is `last_value`

### 2002-04-10

- Added [Frequently Asked Questions](faq.md) document.
- Added `visit_each` discussion to the [design document](design.md).
- Made `deletion_test` actually perform tests.
- Fixed `slot_call_iterator` behavior when a slot deletes the next slot after incrementing the slot call iterator to that slot (i.e., when using the `*first++` syntax) *again*.
- Moved `last_value` into the top-level Boost directory and removed dependencies on Signals library.
- Moved implementation detail headers `signal_base.hpp`, `signals_common.hpp` and `slot_call_iterator.hpp` into `boost/signals/detail`.
- Moved `trackable` and `connection` classes into namespace `boost::signals`.
- Moved implementation details from namespace `detail::signals` to namespace `signals::detail`.
- Fixed `signalN.hpp` headers to use types `T1, T2, ..., TN` instead of `T0, T1, ..., TN-1`.
	Added appropriate typedefs `argument_type`, `first_argument_type` and `second_argument_type`.
- Minor exception safety updates in constructors.
- Removed "controlling" connections from the public interface. Added the `scoped_connection` class to pick up the slack, but with more obvious semantics.
- Slot names have become connection groups. Slot call ordering is now dependent on the connection group ordering, with ungrouped slots being called last.
- Added testcase for slot call ordering.

### 2002-02-14

- Make sure all `shared_ptr` copies are performed only when complete types are available.
- Added test for dead slots.
- Removed use of `scoped_ptr` (it made Borland C++ unhappy).
- Jamfile updates for the latest Jam changes in CVS.
- Validated HTML.

### 2002-01-19

- Refactored slot connection into `signal_base`.
- Revisited exception safety in slot connection routines.
- Updated `slot_call_iterator` to properly cache values even when there are multiple input iterators.
- Changed `signal_base` to use the handle/body idiom via a `shared_ptr`. This enables safe recursive deletion.
- Added a comprehensive connection-tracking test system based on the Boost graph library. See [`random_signal_system.cpp`](../test/random_signal_system.cpp).
- Refactored slot class into a `slot_base` class; connection management code moved into `slot.cpp`.

### 2001-12-28

- Added `slot` class template so that slots may be passed as arguments to non-template functions. (Karl Nelson)
- Updated `signalN` class templates to use the new `slot` class template.
- Tutorial updated to contain information about `slot`.
- `visit_each` documentation added. (Karl Nelson)
- More Borland C++ fixes.

### 2001-12-24

- Update to match `visit_each` framework supported by Boost.Bind
- Signals can be connected to other signals directly.
- Signals can be connected to references to slot function objects (function objects are then not copied).
- Added `argI_type` types to signal classes, and cleaned up the corresponding documentation (thanks to Bill Kempf).
- Document noncopyable requirement (thanks to Bill Kempf).
- "Bindable" changed to "Trackable" (thanks to Peter Dimov).
- Added named slot connections (thanks for Peter Dimov for the suggestion, and Brad King for the push toward a small implementation).
- Trackable rationale documentation.
- Explicitly instantiate what Signals needs within the non-template source.
- Editorial fixes in the tutorial.
- Added examples directory.
- Added `SlotFunction` template parameter to specify the type of object to hold the slot function objects (suggested by Peter Dimov).
- Documentation updates for `signalN` classes.
- Link to all header files within the documentation for those header files.
- Moved all headers except `signal.hpp` into signals subdirectory.
- `return_last_value` renamed to `last_value`.
- Proper documentation for `last_value` class.

### 2001-11-25

- Fixes for MSVC and Borland C++.
- Added Documentation: design rationale &amp; comparisons with other signals &amp; slots implementations.
- Signal connection now meets the strong exception guarantee.
- Jamfile fixes for building the "bindable.cpp" test
- Combined transform_iterator, skip_if_iterator, and input_caching_iterator into a single slot_call_iterator to reduce template depth and compiler confusion.

### 2001-11-18

- Refactoring of signal connection management code.
- Exception safety greatly improved (it is now safe for slots to throw exceptions)
- Uses Boost.Build
- Documentation (reference and tutorial)
- Updated to work with newer versions of Iterator Adaptors

### 2001-07-02

- Initial prototype


[Doug Gregor](http://www.cs.rpi.edu/~gregod)

Last modified: Fri Oct 11 05:41:29 EDT 2002

