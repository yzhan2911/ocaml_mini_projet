open Graph

val init_graph: string graph -> int graph
val transfer_op_value: 'a option ->'a
val find_chemin: int graph -> id -> id -> id list option
val trouve_min: int graph ->id list -> int-> int
val augmenter_flot: int graph -> id list -> int -> int graph
val diminuer_capacite: int graph -> id list -> int -> int graph
val ford_fulkerson: string graph -> id->id-> int graph