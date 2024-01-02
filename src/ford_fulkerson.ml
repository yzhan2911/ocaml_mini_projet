open Tools
open Graph

let init_graph (graph1:string graph) =  
  let graph_node = clone_nodes graph1 in 
    let list=e_fold graph1 (fun acc arc-> arc::acc ) [] in
    let f gr (arc) = add_arc (add_arc gr arc.src arc.tgt 0)  arc.tgt arc.src (*ici c'est le problem*)(int_of_string arc.lbl) in
      let rec loop gr f list =
        match list with 
         |[]->gr 
         |arc:: rest -> loop (f gr arc) f rest ;
      in
      loop graph_node f list;;  
let transfer_op_value(op:'a option)=
  match op with
  |Some value->value;
  |None ->failwith"Pas de valeur" ;;

let find_chemin gr idsrc iddes  = 
        if (node_exists gr idsrc) then
          let rec dfs current_node visited next_node= 
            if (current_node = iddes) then
              List.rev visited
            else 
              let voisin=out_arcs gr current_node in
                let unvisited_voisin = List.filter(fun arc-> not (List.mem arc.tgt visited)) voisin in
                    let new_node_next= List.fold_left(fun acc arc -> arc.tgt :: acc ) next_node unvisited_voisin in 
                      match new_node_next with
                      |[]-> []
                      |current::rest-> let new_visit=current::visited in
                          dfs current new_visit rest 
          in 
            dfs idsrc [idsrc] []
        else failwith "veuiilez choisir un bon départ" ;;

let trouver_min idlist=
    let rec find_minlbl minlbl =
      match idlist with
      |[]-> minlbl
      |idsrc::idnext::rest-> 
          match (find_arc idsrc idnext ) with
            |None -> assert false
            |Some arc -> let current_min =min minlbl arc.lbl in 
                find_minlbl current_min idnext::rest 
      in
      match idlist with 
        |[]->0
        |_::rest->find_minlbl max_int rest;;


    


             

