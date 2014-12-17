#the Boost Graph Library

- 翻訳元ドキュメント : <http://www.boost.org/doc/libs/1_31_0/libs/graph/doc/table_of_contents.html>


![](http://www.boost.org/doc/libs/1_31_0/libs/graph/doc/bgl-cover.jpg)


##目次

1. BGLへの序章
2. 歴史
3. 刊行物
4. [謝辞](./graph/acknowledgements.md)
5. クイック・ツアー
6. 基本的なグラフ理論の復習
7. チュートリアル
	1. Property Maps
	2. The `adjacency_list` class
8. 例題
	1. ファイル依存関係の例
	2. Kevin Bacon の６次数
	3. Graph Coloring
	4. Sparse Matrix Ordering
9. BGL 拡張
	1. Constructing graph algorithms with BGL
	2. Converting Existing Graphs to BGL
10. Boost Graph インタフェイス
	1. Graph
	2. Incidence Graph
	3. [Bidirectional Graph](./graph/BidirectionalGraph.md)
	4. [Adjacency Graph](./graph/AdjacencyGraph.md)
	5. Vertex List Graph
	6. Edge List Graph
	7. Vertex and Edge List Graph
	8. Mutable Graph
	9. Property Graph
	10. Mutable Property Graph
11. The Property Map Library （専門的にはグラフ・ライブラリの部分ではないが、ここで使用される頻度が高い）
12. ビジタ・コンセプト
	1. [BFS （幅優先探査） Visitor](./graph/BFSVisitor.md)
	2. DFS （深度優先探査） Visitor
	3. Dijkstra Visitor
	4. [Bellman Ford Visitor](./graph/BellmanFordVisitor.md)
	5. Event Visitor
13. EventVisitorList アダプタ
	1. Event Visitor List
	2. [`bfs_visitor`](./graph/bfs_visitor.md)
	3. `dfs_visitor`
	4. `dijkstra_visitor`
	5. [`bellman_visitor`](./graph/bellman_visitor.md)
14. イベント・ビジタ
	1. `predecessor_recorder`
	2. `distance_recorder`
	3. `time_stamper`
	4. `property_writer`
15. グラフ・クラス
	1. [`adjacency_list`](./graph/adjacency_list.md)
	2. [`adjacency_matrix`](./graph/adjacency_matrix.md)
16. グラフ・アダプタ
	1. `subgraph`
	2. `edge_list`
	3. `reverse_graph`
	4. `filtered_graph`
	5. Vector as Graph(アンドキュメント)
	6. Matrix as Graph(アンドキュメント)
	7. Leda Graph(アンドキュメント)
	8. Stanford GraphBase
17. イテレータ・アダプタ
	1. [`adjacency_iterator`](./graph/adjacency_iterator.md)
18. 特性クラス
	1. `graph_traits`
	2. [`adjacency_list_traits`](./graph/adjacency_list_traits.md)
	3. `property_map`
19. アルゴリズム
	1. [`bgl_named_params`](./graph/bgl_named_params.md)
	2. 核となるアルゴリズム・パターン
		1. [`breadth_first_search`](./graph/breadth_first_search.md)
		2. [`breadth_first_visit`](./graph/breadth_first_visit.md)
		3. `depth_first_search`
		4. `depth_first_visit`
		5. `undirected_dfs`
		6. `uniform_cost_search` (非推奨、代わりに Dijkstra を使うこと)
	3. グラフ・アルゴリズム
		1. 最短経路アルゴリズム
			1. `dijkstra_shortest_paths`
			2. [`bellman_ford_shortest_paths`](./graph/bellman_ford_shortest_paths.md)
			3. `dag_shortest_paths`
			4. `johnson_all_pairs_shortest_paths`
		2. 最小全域木アルゴリズム
			1. `kruskal_minimum_spanning_tree`
			2. `prim_minimum_spanning_tree`
		3. `connected_components`
		4. `strong_components`
		5. Incremental Connected Components
			1. `initialize_incremental_components`
			2. `incremental_components`
			3. `same_component`
			4. `component_index`
		6. 最大流アルゴリズム
			1. `edmunds_karp_max_flow`
			2. `push_relabel_max_flow`
		7. `topological_sort`
		8. `transitive_closure`
		9. `copy_graph`
		10. `transpose_graph`
		11. `isomorphism`
		12. `cuthill_mckee_ordering`
		13. `sequential_vertex_coloring`(アンドキュメント)
		14. `minimum_degree_ordering`
20. AT&T Graphviz フォーマット入出力ユーティリティ
	1. `write_graphviz`
	2. `read_graphviz`
21. 補助コンセプト、補助クラス、補助関数
	1. `property`
	2. [ColorValue](./graph/ColorValue.md)
	3. [Buffer](./graph/Buffer.md)
	4. [BasicMatrix](./graph/BasicMatrix.md)
	5. `incident`
	6. `opposite`
	7. [`bandwidth`](./graph/bandwidth.md)
	8. [`ith_bandwidth`](./graph/bandwidth.md)
	9. Tools for random graphs
		10. `random_vertex`
		11. `random_edge`
		12. `generate_random_graph`
		13. `randomize_property`
22. 目標と To-Do 項目
23. トラブルシューティング
24. 既知の問題
25. FAQ
26. BGL Book Errata


***
Copyright © 2000-2001

- [Jeremy Siek](http://www.boost.org/doc/libs/1_31_0/people/jeremy_siek.htm), Indiana University (<jsiek@osl.iu.edu>)
- [Lie-Quan Lee](http://www.boost.org/doc/libs/1_31_0/people/liequan_lee.htm), Indiana University (<llee@cs.indiana.edu>)
- [Andrew Lumsdaine](http://www.osl.iu.edu/~lums), Indiana University (<lums@osl.iu.edu>)

Japanese Translation Copyright (C) 2003 [OKI Miyuki](oki_miyuki@cppll.jp)

オリジナルの、及びこの著作権表示が全ての複製の中に現れる限り、この文書の複製、利用、変更、販売そして配布を認める。このドキュメントは「あるがまま」に提供されており、いかなる明示的、暗黙的保証も行わない。また、いかなる目的に対しても、その利用が適していることを関知しない。

