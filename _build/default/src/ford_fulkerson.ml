open Tools
open Graph

let init_graph (graph1:string graph) =  
  let graph_node = clone_nodes graph1 in 
    let list=e_fold graph1 (fun acc arc-> arc::acc ) [] in
    let f gr (arc) = add_arc (add_arc gr arc.src arc.tgt 0)  arc.tgt arc.src (int_of_string arc.lbl) in
      let rec loop gr f list =
        match list with 
         |[]->gr 
         |arc:: rest -> loop (f gr arc) f rest ;
      in
      loop graph_node f list;;  
let transfer_op_value(op:'a option)=
  match op with
  |Some value->value
  |None ->failwith"Pas de valeur" ;;

let find_chemin gr idsrc iddes  = 
        if (node_exists gr idsrc) then
          let rec dfs current_node visited next_node= 
            if (current_node = iddes) then
               List.rev visited
            else 
              let voisin=out_arcs gr current_node in
                let unvisited_voisin = List.filter(fun arc-> arc.lbl!=0 &&not (List.mem arc.tgt visited)) voisin in
                    let new_node_next= List.fold_left(fun acc arc -> arc.tgt :: acc ) next_node unvisited_voisin in 
                      match new_node_next with
                      |[]-> print_string "fini" ;[]
                      |current::rest->print_string "not fini" ; let new_visit=current::visited in
                          dfs current new_visit rest 
          in 
            dfs idsrc [idsrc] []
        else failwith "veuiilez choisir un bon départ" ;;


let trouve_min (gr: 'a graph) (ids: id list) (default_label : 'a )=
      let rec aux min_lbl = function
        | [] | [_] -> min_lbl  (* Retourne le label minimum trouvé *)
        | id1 :: (id2 :: rest) ->  (* Traite chaque paire d'identifiants  *)
          match find_arc gr id1 id2 with
          | Some arc -> aux (min min_lbl arc.lbl) rest
          | None -> failwith"erreur chemin"
      in
      match ids with
      | [] -> default_label (* Si la liste est vide, retourne la valeur par défaut *)
      | _ -> aux default_label ids;;

let augmenter_flot (graph: 'a graph) (ids: id list) (augmentation: 'a )= 
  let rec  update_flot gr = function 
  |[]|[_]-> gr
  |ids::(idn::rest)-> 
      match (find_arc gr ids idn) with
      |None -> failwith "erreur de arc"
      |Some arc -> let new_gr = new_arc gr {arc with lbl=arc.lbl+augmentation} in
      update_flot new_gr rest in
      update_flot graph ids ;;

let diminuer_capacite (graph: 'a graph) (ids: id list) (diminution: 'a )= 
      let rec  update_flot gr = function 
      |[]|[_]-> gr
      |ids::(idn::rest)-> 
          match (find_arc gr ids idn) with
          |None -> failwith "erreur de arc"
          |Some arc -> let new_gr = new_arc gr {arc with lbl=arc.lbl-diminution} in
          update_flot new_gr rest in
          update_flot graph ids ;;

let ford_fulkerson(graph: string graph) (idsrc: id) (iddes: id)=
      let initgr= init_graph graph in
      let rec run  gr ids idd = 
        match find_chemin gr ids idd with
        |[]->print_int 455;gr
        |idlist-> 
          
          let minlbl= trouve_min gr idlist  100 in
                  let grupdate_capa = diminuer_capacite gr idlist minlbl in
                  let grupdate_flot=augmenter_flot grupdate_capa ( List.rev idlist) minlbl in
                  run grupdate_flot ids idd in
          run initgr idsrc iddes;;