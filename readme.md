# pierrepayen's scilab toolbox

## Description

Ce dépot contient l'ensemble des macros scilab faitent pendant mon stage de fin d'étude.
Le but était de fournir des outils de visualisations de champs de vecteurs 3D sur des objets maillés par triangles.
En l'absence de macros permettant de fournir des vrais vecteurs en 3D (xarraows, quiver3 n'était que des objets 2D dans un espace 3D.), j'ai décidé de les créer moi-même.

## Requis
Scilav > v5.5.x
Linux (devellopé/testé seulement sur CentOS 6)

## Projet
* Réecrire ce projet et suivre le standard ATOMS.
* Supprimer les doublons par rapport à d'autres projets/modules.
* Optimiser les codes.

## Installation

`git clone https://github.com/pierrepayen/scilab_toolbox.git && cd scilab_toolbox/PPtoolbox && chmod u+x install.sh uninstall.sh && ./install.sh`

## Desinstallation

`cd scilab_toolbox/PPtoolbox`
`./uninstall.sh && cd ../.. && rm -rf scilab_toolbox`

Puis suivez-les indications.
## Incompatibilité
* plotlib (S. Mottelet) -> gca() différent
