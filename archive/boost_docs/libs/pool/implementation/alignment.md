# アラインメント保証

## 用語

[concepts document](../concepts.md) についてまだ十分理解していないのなら、再読するのがよい。
復習すると、*ブロック*は連続したメモリー塊のひとつであり、固定サイズの*チャンク*に*仕切られ*、あるいは*分離され*ている。
ユーザーが確保、解放するのは、これらの*チャンク*である。

## 大要

個々の `Pool` は、複数のメモリーブロックにまで広がるフリーリストをひとつ持っている。
さらに、`Pool` は確保したメモリーブロックのリンクリストも持っている。
個々のメモリーブロックは、特に指定しなければ、`new[]` を使って確保され、破棄時に解放される。
アラインメントを保証してくれる `new[]` の、まさに使いどころである。

## 概要の証明: アラインメント保証

個々のメモリーブロックは `operator new[]` 経由で POD な型として(はっきり言えば、characterの配列である)確保される。
*POD_size* を確保した character の数としよう。

### 述語1:配列はパディングを持ってはならない

これは以下の引用から言える。

*5.3.3/2* (Expressions::Unary expressions::Sizeof)
"... 配列に適用すると、結果は、配列の全バイト数になる。
これは *n* 個の要素からなる配列のサイズは、要素のサイズの *n* 倍であることを意味する。"

従って、配列内の要素がパディングを含むことはあっても、配列がパディングを含むことはない。

### 述語 2: 任意の `operator new[]` によって character の配列として確保されたメモリーブロック(以後、*the block* と呼ぶ)は、任意の同じか小さいサイズのオブジェクトと適切に境界調整されている。

これは以下による。

- *3.7.3.1/2* (Basic concepts::Storage duration::Dynamic storage duration::Allocation functions)
	"... 返されたポインタは、どのような完全オブジェクト型へのポインタにでも変換して、割り当てられた記憶域内のオブジェクトまたは配列にアクセスするために使用できるよう、適切に境界に整列させられている..."
- *5.3.4/10* (Expressions::Unary expressions::New)
	"`char` と `unsigned char` の配列に関して、*new 式(new-expression)* の結果と割り当て関数によって返されたアドレスの差は、生成されようとしている配列のサイズを超えない任意のオブジェクトの最も厳しいアラインメント(3.9)要求の整数倍である。
	*Note:* 割り当て関数は、任意の型のオブジェクトに対して適切に境界に整列しているポインタを返すものされているため、この配列割り当てに関するオーバーヘッドの強制は、文字型の配列を確保しておき、別の型のオブジェクトを後からそこに配置するという、よく知られた慣用を許容する。"

### 考察: サイズがある実際のオブジェクトの整数倍であるような想像上のオブジェクト型*Element* (ただし、 `sizeof(Element) > POD_size` とする)

そのようなオブジェクトは存在することが*できる*。
そのサイズのひとつのオブジェクトは、"実際の"オブジェクトの配列である。

ブロックは Element に適切に整列している。
これは述語2から直接導かれる。

### 系1:ブロックは要素の配列に適切に整列している

これは述語1、2 および以下の引用から導かれる。

- *3.9/9* (Basic concepts::Types)
	" *object type* は(cv-修飾であってもよい)は関数型、参照型、`void` 型ではない型である。(仕様上、配列型はobject type である) "

### 系2:ポインタ `p` と整数 `i` がある。`p` が、それが指す型に適切に整列しているならば、`p + i` (well-definedのとき)は、その型に適切に整列している。 言い換えると、配列が適切に整列しているならば、その要素も適切に整列している。

この主張を直接支持する標準からの引用はない。
しかしそれは"アラインメント"の意味の共通概念に合致する。

`p + i` が well-defined である条件は *5.7/5* で概略が示されている。
ここで引用はせず、`p` と `p + i` の両者が同じ配列の中を指している、または同じ配列の末尾をひとつ過ぎたところであるとき well-defined であることを記述するに留める。

### `sizeof(Element)` をいくつかの実際のオブジェクト `(T1, T2, T3, ...)` のサイズの最小公倍数であると置く

### *block* をメモリーブロックへのポインタとする。`pe` は `(Element *)block`、 `*pn*` は `(Tn *)block` であるとする

### 系3: `pe + i` が well-defined であるようなすべての整数 `i` について、すべての `n` に対して、`pn + jn` が well-defined であり、 `pe + i` と同じメモリーアドレスを参照するような整数 `jn` が存在する。 メモリーブロックは Element の配列であり、すべての `n` について、`sizeof(Element) % sizeof(Tn) == 0` であるので、Elementsの配列内の個々の要素の境界は `Tn` の配列の個々の要素の境界でもあることが自然に導かれる。 定理: `pe + i` が well-defined であるような、すべての整数 `i` について、アドレス `(pe + i)` はすべての型 `Tn` に適切に整列している

`pe + i` は well-defined であるので、系3より、`pn + jn` は well-defined である。
述語2および系1,2より、それは適切に整列している。

## 定理の使用

上記の証明はブロックからチャンクを切り出すさいのアラインメントに関する要求について当てはまる。
実装では下記の実際のオブジェクトのサイズを使用している。

- 要求されたオブジェクトのサイズ(`requested_size`)。これはユーザーが要求したチャンクのサイズである。
- `void *` (void へのポインタ)。これはチャンク群のを通してフリーリストをインターリーブしているがゆえに。
- `size_type`。個々のメモリーブロックの中に次のブロックのサイズを格納しているがゆえに。

それぞれのブロックは次のブロックへのポインタも含んでいる。
しかしこれは、上記の3つの型へのアラインメント要求を単純にするため、
`void` へのポインタとして保存され必要に応じてキャストされる。

従って、`alloc_size` は上記の3つの型のサイズの最小公倍数として定義される。

## メモリーブロックの概覧

それぞれのメモリーブロックは3つの主要セクションからなる。
最初のセクションは、そこからチャンクが切り出される場所であり、インターリーブされたフリーリストを含んでいる。
第二のセクションは、次のブロックへのポインタであり、第三のセクションは次のブロックのサイズである。

これらのセクションは次のセクションのアラインメントを保証するのに必要なパディングを含むことがある。
最初のセクションのサイズは、`number_of_chunks * lcm(requested_size, sizeof(void *), sizeof(size_type))` である。
第二のセクションのサイズは `lcm(sizeof(void *), sizeof(size_type)` である。
第三のセクションのサイズは `sizeof(size_type)` である。

メモリーブロックの一例を示す。
ここでは `requested_size == sizeof(void *) == sizeof(size_type) == 4` である。

**Table:メモリーブロックは4個のチャンクを含む。配列構造を重ねて表示する。FLP=フリーリストのインターリーブされたポインタ**

| セクション | `size_type` 境界 | `void *` 境界 | `requested_size` 境界 |
|:---:|:---:|:---:|:---:|
| プロセス外メモリー | プロセス外メモリー | プロセス外メモリー | プロセス外メモリー |
| Chunks section (16 bytes) | (4 bytes) | FLP for Chunk 1 (4 bytes) | Chunk 1 (4 bytes) |
| Chunks section (16 bytes) | (4 bytes) | FLP for Chunk 2 (4 bytes) | Chunk 2 (4 bytes) |
| Chunks section (16 bytes) | (4 bytes) | FLP for Chunk 3 (4 bytes) | Chunk 3 (4 bytes) |
| Chunks section (16 bytes) | (4 bytes) | FLP for Chunk 4 (4 bytes) | Chunk 4 (4 bytes) |
| Pointer to next Block (4 bytes) | (4 bytes) | Pointer to next Block (4 bytes) | |
| Size of next Block (4 bytes) | Size of next Block (4 bytes) | | |
| プロセス外メモリー | プロセス外メモリー | プロセス外メモリー | プロセス外メモリー |

パディングがある例を図示する。
この例では `requested_size == 8` and `sizeof(void *) == sizeof(size_type) == 4`

**Table:メモリーブロックは4個のチャンクを含む。配列構造を重ねて示す。FLP=フリーリストのインターリーブされたポインタ**

| Sections | `size_type` alignment | `void *` alignment | `requested_size` alignment |
|:---:|:---:|:---:|:---:|
| Memory not belonging to process | Memory not belonging to process | Memory not belonging to process | Memory not belonging to process |
| Chunks section (32 bytes) | (4 bytes) | FLP for Chunk 1 (4 bytes) | Chunk 1 (8 bytes) |
| Chunks section (32 bytes) | (4 bytes) | (4 bytes) | Chunk 1 (8 bytes) |
| Chunks section (32 bytes) | (4 bytes) | FLP for Chunk 2 (4 bytes) | Chunk 2 (8 bytes) |
| Chunks section (32 bytes) | (4 bytes) | (4 bytes) | Chunk 2 (8 bytes) |
| Chunks section (32 bytes) | (4 bytes) | FLP for Chunk 3 (4 bytes) | Chunk 3 (8 bytes) |
| Chunks section (32 bytes) | (4 bytes) | (4 bytes) | Chunk 3 (8 bytes) |
| Chunks section (32 bytes) | (4 bytes) | FLP for Chunk 4 (4 bytes) | Chunk 4 (8 bytes) |
| Chunks section (32 bytes) | (4 bytes) | (4 bytes) | Chunk 4 (8 bytes) |
| Pointer to next Block (4 bytes) | (4 bytes) | Pointer to next Block (4 bytes) | |
| Size of next Block (4 bytes) | Size of next Block (4 bytes) | | |
| Memory not belonging to process | Memory not belonging to process | Memory not belonging to process | Memory not belonging to process |

最後に、`requested_size` は 7, `sizeof(void *)` は 3, and `sizeof(size_type)` は 5という入り組んだ例をあげ、奇数ばかりの環境であっても最小公倍数がアラインメントを保証するようすを示す。

**Table:Memory block containing 2 chunks, showing overlying array structures**

| Sections | `size_type` alignment | `void *` alignment | `requested_size` alignment |
|:--:|:--:|:--:|:--:|
| プロセス外メモリー | プロセス外メモリー | プロセス外メモリー | プロセス外メモリー |
| Chunks section (210 bytes) | (5 bytes) | Interleaved free list pointer for Chunk 1 (15 bytes; 3 used) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | Interleaved free list pointer for Chunk 1 (15 bytes; 3 used) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | Interleaved free list pointer for Chunk 1 (15 bytes; 3 used) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (15 bytes) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (15 bytes) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (15 bytes) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (15 bytes) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (15 bytes) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (15 bytes) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (15 bytes) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (15 bytes) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (15 bytes) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (15 bytes) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (15 bytes) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (15 bytes) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (15 bytes) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (15 bytes) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (15 bytes) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (15 bytes) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (15 bytes) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (15 bytes) | Chunk 1 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | Interleaved free list pointer for Chunk 2 (15 bytes; 3 used) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | Interleaved free list pointer for Chunk 2 (15 bytes; 3 used) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | Interleaved free list pointer for Chunk 2 (15 bytes; 3 used) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (5 bytes) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (5 bytes) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (5 bytes) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (5 bytes) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (5 bytes) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (5 bytes) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (5 bytes) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (5 bytes) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (5 bytes) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (5 bytes) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (5 bytes) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (5 bytes) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (5 bytes) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (5 bytes) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (5 bytes) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (5 bytes) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (5 bytes) | Chunk 2 (105 bytes; 7 used) |
| Chunks section (210 bytes) | (5 bytes) | (5 bytes) | Chunk 2 (105 bytes; 7 used) |
| 次ブロックへのポインタ (15 bytes; 3 used) | (5 bytes) | 次ブロックへのポインタ (15 bytes; 3 used) | |
| 次ブロックへのポインタ (15 bytes; 3 used) | (5 bytes) | 次ブロックへのポインタ (15 bytes; 3 used) | |
| 次ブロックへのポインタ (15 bytes; 3 used) | (5 bytes) | 次ブロックへのポインタ (15 bytes; 3 used) | |
| 次ブロックのサイズ (5 bytes; 5 used) | 次ブロックのサイズ (5 bytes; 5 used) | | |
| プロセス外メモリー | プロセス外メモリー | プロセス外メモリー | プロセス外メモリー |

## どのように連続したチャンクを扱うか

上記の定理は、チャンクの割り当てにも、インターリーブされているフリーリストのような実装の詳細にも、すべてのアラインメント要求を保証している。
しかしながら、それは必要に応じてパディングを追加しているので、連続したチャンクの割り当ては別の方法で扱わなくてはならない。

上記に似ている配列引数を使用することで、連続した `n` 個の `requested_size` のオブジェクトへの要求を、`m` 個の連続したチャンクへの要求に翻訳できる。
`m` は単純に `ceil(n * requested_size / alloc_size)` であり、`alloc_size` はチャンクの実際のサイズである。
図示する。

これは `requested_size == 1` で `sizeof(void *) == sizeof(size_type) == 4` の場合のメモリーブロックの例である。

**Table:メモリーブロックは 4個のチャンクを含んでいる。`requested_size` は 1**

| Sections | `size_type` alignment | `void *` alignment | `requested_size` alignment |
|:--:|:--:|:--:|:--:|
| Memory not belonging to process | Memory not belonging to process | Memory not belonging to process | Memory not belonging to process |
| Chunks section (16 bytes) | (4 bytes) | FLP to Chunk 2 (4 bytes) | Chunk 1 (4 bytes) |
| Chunks section (16 bytes) | (4 bytes) | FLP to Chunk 3 (4 bytes) | Chunk 2 (4 bytes) |
| Chunks section (16 bytes) | (4 bytes) | FLP to Chunk 4 (4 bytes) | Chunk 3 (4 bytes) |
| Chunks section (16 bytes) | (4 bytes) | FLP to end-of-list (4 bytes) | Chunk 4 (4 bytes) |
| Pointer to next Block (4 bytes) | (4 bytes) | Ptr to end-of-list (4 bytes) | |
| Size of next Block (4 bytes) | 0 (4 bytes) | | |
| Memory not belonging to process | Memory not belonging to process | Memory not belonging to process | Memory not belonging to process |

**Table:ユーザーが 7個の連続した requested_size の要素を要求した後**

| Sections | `size_type` alignment | `void *` alignment | `requested_size` alignment |
|:--:|:--:|:--:|:--:|
| Memory not belonging to process | Memory not belonging to process | Memory not belonging to process | Memory not belonging to process |
| Chunks section (16 bytes) | (4 bytes) | (4 bytes) | 4 bytes in use by program |
| Chunks section (16 bytes) | (4 bytes) | (4 bytes) | 3 bytes in use by program (1 byte unused) |
| Chunks section (16 bytes) | (4 bytes) | FLP to Chunk 4 (4 bytes) | Chunk 3 (4 bytes) |
| Chunks section (16 bytes) | (4 bytes) | FLP to end-of-list (4 bytes) | Chunk 4 (4 bytes) |
| Pointer to next Block (4 bytes) | (4 bytes) | Ptr to end-of-list (4 bytes) | |
| Size of next Block (4 bytes) | 0 (4 bytes) | | |
| Memory not belonging to process | Memory not belonging to process | Memory not belonging to process | Memory not belonging to process |

ユーザーが連続したメモリーを解放したときは、再びチャンクに分けることができる。

連続したチャンクを割り当てるための実装は、二次ではなく線形のアルゴリズムを使っている。
これはフリーリストが順序付けされていなければ連続したチャンクを**発見できないことがある**ことを意味している。
従って連続したチャンクを割り当てることがあるときは、いつも順序付けられたフリーリストを使うことを勧める。
(上記の例でなら、チャンクが順序付けされておらず、チャンク1 がチャンク3 を指し、チャンク3 はチャンク2 を、チャンク2 は、チャンク4 を指しているならば、連続領域割り当てアルゴリズムは、いずれの連続したチャンクをも発見できない)

---

[shammah@voyager.net](mailto:shammah@voyager.net))

This file can be redistributed and/or modified under the terms found in [copyright](../copyright.md)

This software and its documentation is provided "as is" without express or implied warranty, and with no claim as to its suitability for any purpose.

