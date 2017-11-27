# compose3.cpp
The following code example is taken from the book

[The C++ Standard Library - A Tutorial and Reference](http://www.josuttis.com/libbook/)

by Nicolai M. Josuttis, Addison-Wesley, 1999

[© Copyright](http://www.josuttis.com/libbook/copyright.html) Nicolai M. Josuttis 1999

```cpp example
#include <iostream>
#include <algorithm>
#include <functional>
#include <string>
#include <cctype>
#include "compose.hpp"
using namespace std;
using namespace boost;

int main()
{
    string s("Internationalization");
    string sub("Nation");

    // search substring case insensitive
    string::iterator pos;
    pos = search (s.begin(),s.end(),           // string to search in
                  sub.begin(),sub.end(),       // substring to search
                  compose_f_gx_hy(equal_to<int>(), // compar. criterion
                                  ptr_fun(::toupper),
                                  ptr_fun(::toupper)));

    if (pos != s.end()) {
        cout << "\"" << sub << "\" is part of \"" << s << "\""
             << endl;
    }
}
```
* compose.hpp[link ./compose.hpp.md]

