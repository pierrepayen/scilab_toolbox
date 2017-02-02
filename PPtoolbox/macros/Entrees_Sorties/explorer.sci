function [PATH,FILE]=explorer(varargin)
// Boite de dialogue pour sélectionner un fichier ou un dossier.
//
// Calling Sequence
//   [PATH,FILE]=explorer([DIR,titre])
//
// Parameters
// PATH : chaine de caractères; nom du dossier/fichier. 
// FILE: chaine de caractères; chemin complet du dossier/fichier.
// DIR: Argument optionnel; chaine de caractères; dossier initial de recherche.
// titre : Argument optionnel;chaine de caractère; titre de la boite de dialogue.
//
// Description
// Crée une boite de dialogue pour sélectionner un fichier ou un dossier et renvoie le chemin jusqu'à ce dernier.
// Pour valider la sélection d'un fichier, il faut naviguer jusqu'à ce fichier et double-cliquer dessus.
// Pour valider la sélection d'un dossier, il faut naviguer jusque dans ce dossier et cliquer sur le bouton.
//
// Examples
// explorer()
// [P,F] = explorer(SCIHOME,'SCIHOME')
//
// See also
//  uigetfile
//  uigetdir
//  filebrowser
//
// Authors
//  Pierre Payen (07/2016) 

if  argn(2)>1 then
  PATH_INIT = varargin(1)
  titre = varargin(2)
elseif argn(2) > 0
  PATH_INIT = varargin(1)
  titre = 'explorer'
else
  PATH_INIT = '.'
  titre = 'explorer'
end
  oldpwd = pwd();
  cd(PATH_INIT);
  FULL_PATH = pathconvert(pwd(),%f,%t,'u');
  DIR_PATH = dirname(FULL_PATH)+'/';
  DIR_NAME = basename(FULL_PATH);

  lsa = sort(ls(FULL_PATH));
  ldir = lsa(isdir(FULL_PATH+'/'+lsa));
  lfile = lsa(~isdir(FULL_PATH+'/'+lsa));
  lsa = ['..';ldir;lfile]
  if size(ldir,1)>0 then
    ldir=ldir+'/'
  end
  lchoix = ['../';ldir;lfile]
  n=x_choose(lchoix,titre,'Choisir le dossier '+DIR_NAME);
  select n
    case 0 then
      PATH = DIR_PATH
      FILE = DIR_NAME
    else
      FILE = lsa(n);
      PATH = DIR_PATH+DIR_NAME+'/'+FILE;
      if isdir(PATH) then
        [PATH,FILE]=explorer(PATH,titre);
      end
    end
  cd(oldpwd)
endfunction
