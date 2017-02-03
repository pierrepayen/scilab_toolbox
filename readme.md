# pierrepayen's scilab toolbox

## Description

Ce dépot contient l'ensemble des macros scilab faitent pendant mon stage de fin d'étude.
Le but était de fournir des outils de visualisations de champs de vecteurs 3D sur des objets maillés par triangles.
En l'absence de macros permettant de fournir des vrais vecteurs en 3D (xarraows, quiver3 n'était que des objets 2D dans un espace 3D.), j'ai décidé de les créer moi-même.


## Contenu
1. `PPtoolbox` : toolbox à proprement parler. Contient les macros et les scripts nécessaires à l'intégration
2. `demo_fonbase.sce` : script qui représente les éléments de Ravaiart-Thomas sur un objet diamant maillé sur 6 éléments triangulaires;
3. `demo_spehrictocart.sce` : script qui représente la convention des coordonnées sphériques utilisées.
4. `pyra-6elt.maila` : fichier de maillage nécessaire à `demo_fonbase.sce` et `PPtoolbox/macros/Elements_finis/`

## Requis
Scilav > v5.5.x
Linux (devellopé/testé seulement sur CentOS 6)

## Projet
* Réecrire ce projet et suivre le standard ATOMS.
* Supprimer les doublons par rapport à d'autres projets/modules.
* Optimiser les codes.

## Installation

`git clone https://github.com/pierrepayen/scilab_toolbox.git && cd scilab_toolbox/PPtoolbox && chmod u+x install.sh uninstall.sh && ./install.sh`

## Test d'installation
Vous pouvez tester l'installation en lancant les scipts `demo_fonbase.sce` et  `demo_spherictocart.sce`.


## Desinstallation

`cd scilab_toolbox/PPtoolbox`

`./uninstall.sh && cd ../.. && rm -rf scilab_toolbox`

Puis suivez-les indications.
## Incompatibilité
* plotlib (S. Mottelet) -> gca() différent
