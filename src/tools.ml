(* Yes, we have to repeat open Graph. *)
open Graph

(* assert false is of type ∀α.α, so the type-checker is happy. *)
let clone_nodes (gr:'a graph) =  n_fold gr new_node empty_graph
let gmap (gr:'a graph) f = 
  let fu aqu arc= new_arc aqu ({arc with lbl = (f arc.lbl)})in
    e_fold gr fu (clone_nodes gr)                    
let add_arc gr src tgt lbl =
  new_arc gr { src = src; tgt = tgt; lbl = lbl }
    

