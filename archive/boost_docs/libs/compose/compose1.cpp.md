# compose1.cpp
The following code example is taken from the book

[The C++ Standard Library - A Tutorial and Reference](http://www.josuttis.com/libbook/)

by Nicolai M. Josuttis, Addison-Wesley, 1999

[© Copyright](http://www.josuttis.com/libbook/copyright.html) Nicolai M. Josuttis 1999

```cpp example
#include <iostream>
#include <vector>
#include <algorithm>
#include <functional>
#include <iterator>
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

    // for each element add 10 and multiply by 5
    transform (coll.begin(),coll.end(),
               ostream_iterator<int>(cout," "),
               compose_f_gx(bind2nd(multiplies<int>(),5),
                            bind2nd(plus<int>(),10)));
    cout << endl;
}
```
* print.hpp[link ./print.hpp.md]
* compose.hpp[link ./compose.hpp.md]

