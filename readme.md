# pierrepayen's scilab toolbox

## Description

Ce dépot contient l'ensemble des macros scilab faitent pendant mon stage de fin d'étude.
Le but était de fournir des outils de visualisations de champs de vecteurs 3D sur des objets maillés par triangles.
En l'absence de macros permettant de fournir des vrais vecteurs en 3D (xarraows, quiver3 n'était que des objets 2D dans un espace 3D.), j'ai décidé de les créer moi-même.

## Contenu
1. `PPtoolbox` : toolbox à proprement parler. Contient les macros et les scripts nécessaires à l'intégration
2. `demo_fonbase.sce` : script qui représente les éléments de Ravaiart-Thomas sur un objet diamant maillé sur 6 éléments triangulaires;
3. `demo_spherictocart.sce` : script qui représente les coordonnées sphériques utilisées.
4. `pyra-6elt.maila` : fichier de maillage nécessaire à `demo_fonbase.sce` et `PPtoolbox/macros/Elements_finis/`
5. `toolbox_name` : nom d'un module réecrit en mode ATOMS

## Requis
* Scilav > v5.5.1
* Linux, develleoppé/testé seulement sur CentOS 6 en mode 'naïf'
* Testé sur Windows/Linux en mode ATOMS

## Projet
* Réecrire ce projet et suivre le standard ATOMS (~50%).
* Supprimer les doublons par rapport à d'autres projets/modules (0%).
* Optimiser les codes (0%).

## Installation
`git clone https://github.com/pierrepayen/scilab_toolbox.git`

### Installer ma toolbox 'naïve' (slt Linux CentOS, Mint)

```
$ cd chemin/vers/scilab_toolbox/PPtoolbox && chmod u+x install.sh uninstall.sh && ./install.sh
```

La toolbox sera lancé à chaque démarrage, et les macros seront protégés, i.e, faire `clear all` ne les supprime pas de la mémoire.

### Installer dans le style ATOMS

zipper le dossier toolbox_matlab.

Dans Scilab en mode console

```
--> atomsInstall("/chemin/vers/toolbox_matlab.zip");
```

La

## Test d'installation
Vous pouvez tester l'installation en lancant les scipts `demo_fonbase.sce` (toolbox_{finiteElements,matlab,geometry) et  `demo_spherictocart.sce`  (toolbox_{matlab,geometry})


## Desinstallation
### Apres installation naïve
```
$ cd scilab_toolbox/PPtoolbox && ./uninstall.sh 
```

Puis suivez-les indications.

### Après installation ATOMS
Dans la console Scilab
```
--> atomsRemove('toolbox_name');
```

## Incompatibilité
* plotlib (S. Mottelet) -> gca() différent
