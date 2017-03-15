# compose2.cpp
The following code example is taken from the book

[The C++ Standard Library - A Tutorial and Reference](http://www.josuttis.com/libbook/)

by Nicolai M. Josuttis, Addison-Wesley, 1999

[© Copyright](http://www.josuttis.com/libbook/copyright.html) Nicolai M. Josuttis 1999

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <functional>
#include "print.hpp"
#include "compose.hpp"
using namespace std;
using namespace boost;

int main()
{
    vector<int> coll;

    // insert elements from 1 to 9
    for (int i=1; i<=9; ++i) {
        coll.push_back(i);
    }
    PRINT_ELEMENTS(coll);

    // remove all elements that are greater than four and less than seven
    // - retain new end
    vector<int>::iterator pos;
    pos = remove_if (coll.begin(),coll.end(),
                     compose_f_gx_hx(logical_and<bool>(),
                                     bind2nd(greater<int>(),4),
                                     bind2nd(less<int>(),7)));

    // remove ``removed'' elements in coll
    coll.erase(pos,coll.end());

    PRINT_ELEMENTS(coll);
}
```
* print.hpp[link ./print.hpp.md]
* compose.hpp[link ./compose.hpp.md]

