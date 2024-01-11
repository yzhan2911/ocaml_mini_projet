# Projet Ford-Fulkerson avec OCaml
Yu Zhang 
Yongjia Zeng
Groupe B1

## Description

Ce projet implémente l'algorithme de Ford-Fulkerson pour calculer le flux maximal dans un graphe de réseau en utilisant OCaml. L'objectif principal est de trouver le chemin augmentant qui maximise le flux du nœud source au nœud de destination tout en respectant les capacités des arcs.

## Fonctionnalités

- **Initialisation du Graphe (`init_graph`)** : Cette fonction prépare un graphe pour l'analyse de flux en prenant les nœuds et en initialisant les arcs avec des capacités définies.

- **Trouver un Chemin (`find_chemin`)** : Recherche un chemin possible du nœud source au nœud de destination, en utilisant un algorithme de recherche en profondeur (DFS). La fonction retourne la présence et l'absence de chemins valides.

- **Trouver le Label Minimum (`trouve_min`)** : Détermine le label minimum parmi les arcs d'un chemin donné, nécessaire pour l'augmentation de flux.

- **Augmenter le Flux (`augmenter_flot`)** : Augmente le flux sur un chemin trouvé. Elle est utilisée pour ajouter les flux dans le graphe en fonction des chemins augmentants identifiés.

- **Diminuer la Capacité (`diminuer_capacite`)** : Réduit la capacité des arcs sur un chemin donné.

- **Algorithme Ford-Fulkerson (`ford_fulkerson`)** : Le principale de l'algorithme. Il trouve répétitivement des chemins et met à jour le graphe. L'algorithme s'arrête lorsqu'il n'y a plus de chemin possible.

## Utilisation

- **make pour compiler**
- **graph= "nom de graph" src = "id de noeud source" dst = "id de noeud destinaire" make demo**
