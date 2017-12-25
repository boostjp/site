# ビルドツール

## インデックス

- [ビルドしたバイナリを実行する](#execute)
- [ディレクトリ構造を保存した状態でインストールを行う](#install-with-saved-directory)


## <a id="execute" href="#execute">ビルドしたバイナリを実行する</a>

bjamでバイナリをビルドした場合、toolsetやvariantによって最終生成物が非常に深い位置に生成される。

これを実行するのはインストールするまで困難であるが、notfileモジュールを使用することで実現できる。

```
import notfile ;
 
project /sample ;
 
exe executable : source.cpp ;
  
actions exec_executable
{
        $(2)
}
 
notfile exec : @exec_executable : /sample//executable ;
explicit exec ;
```
* import notfile ;[color ff0000]
* notfile exec[color ff0000]

explicitルールを指定しないと意図しないタイミングで実行されてしまうので注意されたい。

```
$ cat source.cpp
#include <iostream>
int main()
{
    std::cout << __GNUC__ << "." << __GNUC_MINOR__ << std::endl;
}
$ bjam --toolset=gcc-4.5
...found 9 targets...
...updating 5 targets...
common.mkdir bin
common.mkdir bin/gcc-4.5
common.mkdir bin/gcc-4.5/debug
gcc.compile.c++ bin/gcc-4.5/debug/source.o
gcc.link bin/gcc-4.5/debug/executable
...updated 5 targets...
$ bjam --toolset=gcc-4.6
...found 9 targets...
...updating 4 targets...
common.mkdir bin/gcc-4.6
common.mkdir bin/gcc-4.6/debug
gcc.compile.c++ bin/gcc-4.6/debug/source.o
gcc.link bin/gcc-4.6/debug/executable
...updated 4 targets...
$ bjam --toolset=gcc-4.5 exec
...found 10 targets...
...updating 1 target...
Jamfile</home/boosters>.exec_executable <l./gcc-4.5/debug>exec
4.5
...updated 1 target...
$ bjam --toolset=gcc-4.6 exec
...found 10 targets...
...updating 1 target...
Jamfile</home/boosters>.exec_executable <l./gcc-4.6/debug>exec
4.6
...updated 1 target...
```
* 4.5[color ff0000]
* 4.6[color ff0000]

実行時はビルド時と同じtoolset,variantを指定する必要がある。ビルドされていない場合、ビルドを行ってから実行する。


## <a id="install-with-saved-directory" href="#install-with-saved-directory">ディレクトリ構造を保存した状態でインストールを行う</a>

通常インストールターゲットを定義する際、packageモジュールのinstallルールを用いることが多い。しかし、これはヘッダファイルのディレクトリ構造をデフォルトで保存しない。ヘッダファイルを細かく分けることの多いC++などではこの動作は使いにくい。以下にデフォルトの動作を例示する。

```
# Jamroot.jam
import package ;
import path ;

path-constant project-root : [ path.make ./ ] ;
project /sample ;

explicit install ;
package.install install
  : # requirements
  : # binaries
  : # libraries
  : [ path.glob-tree $(project-root) : *.hpp ]
  ;
```
* import package ;[color ff0000]
* package.install[color ff0000]


```
$ ls -R
.:
Jamroot.jam  sample/

./sample:
detail/  sample.hpp

./sample/detail:
sample1.hpp
$ bjam install --prefix=$HOME/local
...found 10 targets...
...updating 3 targets...
common.mkdir /home/boosters/local/include
common.copy /home/boosters/local/include/sample.hpp
common.copy /home/boosters/local/include/sample1.hpp
...updated 3 targets...
$ ls -R $HOME/local
/home/boosters/local:
include/

/home/boosters/local/include:
sample1.hpp  sample.hpp
$
```
* ./sample:[color ff0000]
* detail/  sample.hpp[color ff0000]
* ./sample/detail:[color ff0000]
* sample1.hpp[color ff0000]
* common.copy /home/boosters/local/include/sample.hpp[color ff0000]
* common.copy /home/boosters/local/include/sample1.hpp[color ff0000]
* /home/boosters/local/include:[color ff0000]
* sample1.hpp  sample.hpp[color ff0000]


これを回避するには`<install-source-root>`を使用すればよい。具体的には以下のようになる。

```
# Jamroot.jam
import package ;
import path ;

path-constant project-root : [ path.make ./ ] ;
project /sample ;

explicit install ;
package.install install
  : <install-source-root>$(project-root)
  : # binaries
  : # libraries
  : [ path.glob-tree $(project-root) : *.hpp ]
  ;
```
* <install-source-root>$(project-root)[color ff0000]


```
$ ls -R
.:
Jamroot.jam  sample/

./sample:
detail/  sample.hpp

./sample/detail:
sample1.hpp
$ bjam install --prefix=$HOME/local
...found 12 targets...
...updating 5 targets...
common.mkdir /home/boosters/local/include
common.mkdir /home/boosters/local/include/sample
common.copy /home/boosters/local/include/sample/sample.hpp
common.mkdir /home/boosters/local/include/sample/detail
common.copy /home/boosters/local/include/sample/detail/sample1.hpp
...updated 5 targets...
$ ls -R $HOME/local
/home/boosters/local:
include/

/home/boosters/local/include:
sample/

/home/boosters/local/include/sample:
detail/  sample.hpp

/home/boosters/local/include/sample/detail:
sample1.hpp
$
```
* common.copy /home/boosters/local/include/sample/sample.hpp[color ff0000]
* common.mkdir /home/boosters/local/include/sample/detail[color ff0000]
* common.copy /home/boosters/local/include/sample/detail/sample1.hpp[color ff0000]
* /home/boosters/local/include/sample:[color ff0000]
* detail/  sample.hpp[color ff0000]
* /home/boosters/local/include/sample/detail:[color ff0000]
* sample1.hpp[color ff0000]


