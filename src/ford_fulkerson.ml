open Tools
open Graph

let init_graph (graph1:string graph) =  
  let graph_node = clone_nodes graph1 in 
    let list=e_fold graph1 (fun acc arc-> arc::acc ) [] in
    let f gr (arc) = add_arc (add_arc gr arc.tgt arc.src  0)  arc.src arc.tgt(int_of_string arc.lbl) in
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

let find_chemin gr idsrc iddes =
  (* Vérifie si le nœud source et le nœud de destination existent *)
  if not (node_exists gr idsrc) then failwith "Veuillez choisir un bon départ";
  if not (node_exists gr iddes) then failwith "Veuillez choisir une bonne destination";

  let rec dfs current_node visited =
    Printf.printf "Visite du noeud: %d\n" current_node;  
    if current_node = iddes then
      (* Chemin trouvé *)
      Some (List.rev (current_node :: visited))
    else
      let voisins = out_arcs gr current_node in
      let unvisited_voisins = List.filter (fun arc ->arc.lbl != 0 && not (List.mem arc.tgt visited)) voisins in

      List.iter (fun arc -> Printf.printf "Arc possible: %d -> %d avec label %s\n" arc.src arc.tgt (string_of_int arc.lbl)) unvisited_voisins;

      (* Parcourt les voisins non visités *)
      match unvisited_voisins with
      | [] -> None  (* Aucun chemin valide trouvé *)
      | _ -> List.fold_left (fun acc arc ->match acc with
          | Some _ as result -> result  (* Chemin déjà trouvé *)
          | None -> dfs arc.tgt (current_node :: visited)
        ) None unvisited_voisins
  in
  dfs idsrc []


let trouve_min (gr: 'a graph) (ids: id list) (default_label: 'a) =
  let rec aux min_lbl = function
    | [] | [_] -> 
        Printf.printf "Label minimum trouvé: %s\n" (string_of_int min_lbl);  
        min_lbl  (* Retourne le label minimum trouvé *)
    | id1 :: (id2 :: rest) ->  
      match find_arc gr id1 id2 with
      | Some arc -> aux (min min_lbl arc.lbl) (id2 :: rest)
      | None -> 
          Printf.printf "Aucun arc trouvé de %d à %d, en utilisant label par défaut.\n" id1 id2;  
          aux min_lbl (id2 :: rest)
  in
  match ids with
  | [] -> default_label
  | _ -> aux default_label ids


let augmenter_flot (graph: 'a graph) (ids: id list) (augmentation: 'a) =
  if augmentation = 1000 then graph else
  let rec update_flot gr = function
    | [] | [_] -> gr
    | id1 :: (id2 :: rest) ->
      let updated_gr = match find_arc gr id1 id2 with
        | None -> failwith "Erreur : arc inexistant"
        | Some arc ->
          let updated_arc = { arc with lbl = arc.lbl + augmentation } in
          new_arc gr updated_arc
      in
      update_flot updated_gr (id2 :: rest)
  in
  update_flot graph ids


 let diminuer_capacite (graph: 'a graph) (ids: id list) (diminution: 'a) =
  let rec update_flot gr = function
    | [] | [_] -> gr
    | id1 :: (id2 :: rest) ->
      let updated_gr = match find_arc gr id1 id2 with
        | None -> failwith "Erreur : arc inexistant"
        | Some arc ->
          if arc.lbl < diminution then
            failwith "Erreur : capacité de l'arc devient négative";
          let updated_arc = { arc with lbl = arc.lbl - diminution } in
          new_arc gr updated_arc
      in
      update_flot updated_gr (id2 :: rest)
  in
  update_flot graph ids



let ford_fulkerson (graph: string graph) (idsrc: id) (iddes: id) =
  let initgr = init_graph graph in
    let rec run gr paths ids idd =
      Printf.printf "Itération\n";  
      match find_chemin gr ids idd with
      | None -> 
          Printf.printf "Plus de chemin trouvé. Terminé.\n";  
          (gr, paths)  
      | Some idlist -> 
          Printf.printf "Chemin trouvé: %s\n" (String.concat " -> " (List.map string_of_int idlist)); 
          let minlbl = trouve_min gr idlist 1000 in
            let grupdate_capa = diminuer_capacite gr idlist minlbl in
              let grupdate_flot = augmenter_flot grupdate_capa (List.rev idlist) minlbl in
                run grupdate_flot (idlist :: paths) ids idd  
    in
      let (final_gr, paths) = run initgr [] idsrc iddes in

      List.iter (fun path -> 
        Printf.printf "Chemin trouvé: %s\n" (String.concat " -> " (List.map string_of_int path))
      ) paths;

  final_gr  
          
          