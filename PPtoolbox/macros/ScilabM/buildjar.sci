function buildjar(LIBPATH,DOCPATH,DOCTITLE)
// Depuis un dossier lib/scilab contenant des sous dossiers *.sci, génère la doc en .xml et .jar associée.
//
// Calling Sequence
// buildjar(LIBPATH,DOCPATH,DOCTITLE)
//
// Parameters 
// LIBPATH : chaine de caractères; chemin vers le dossier principal contenant des sous-dossiers contenant des *.sci. 
// DOCPATH : chaine de caractères; chemin vers le dossier principal où enregistrer la doc suivant l'arborescence de LIBPATH.
// DOCTITLE : chaine de caractères; titre de la doc. 
//
// Description
// Etant donné un architecture : 
// <programlisting>
// LIBPATH/
//    |-- dossier_1                   
//    |   |-- fonction_1_1.sci         
//    |   |-- fonction_1_2.sci
//    |-- dossier_2                 
//    |   |-- fonction_2_1.sci   
//    |   |-- fonction_2_2.sci 
//    |   |-- fonction_2_3.sci     
//    |-- dossier_3             
//        |-- fonction_3_1.sci
// </programlisting>
// où chaque fichier *.sci répond aux critères de help_from_sci().
//
// Scilab va générer la donc dans DOCPATH suivant le même modèle en xml, puis en jar.
// <programlisting>
// LIBPATH/                     --> DOCPATH/
//    |-- dossier_1                    |-- dossier_1
//    |   |-- fonction_1_1.sci         |   |-- fonction_1_1.xml
//    |   |-- fonction_1_2.sci         |   |-- fonction_1_2.xml
//    |-- dossier_2                    |-- dossier_2
//    |   |-- fonction_2_1.sci         |   |-- fonction_2_1.xml
//    |   |-- fonction_2_2.sci         |   |-- fonction_2_2.xml
//    |   |-- fonction_2_3.sci         |   |-- fonction_2_3.xml
//    |-- dossier_3                    |-- dossier_3
//        |-- fonction_3_1.sci         |   |-- fonction_3_1.xml
//                                     |-- scilab_fr_FR_help/
//                                     |-- scilab_fr_FR_help.jar
// </programlisting>
//
// See also
// xmltojar
// help_from_sci_fr
// 
// Authors
// Pierre Payen (08/2016)
//



if argn(2)<3 then
 error(39);
end

LIBPATH = fullpath(LIBPATH);
DOCPATH= fullpath(DOCPATH);

path = pwd();
cd(LIBPATH);
unix('echo title = Fonctions > '+DOCPATH+'/CHAPTER');
unix('echo book_title = '+DOCTITLE+' >> '+DOCPATH+'/CHAPTER');
alldoc = dir();
alldir = alldoc(2)(alldoc(5));
for i = 1:size(alldir,1);
  docdir = alldir(i);
  unix('mkdir '+DOCPATH+'/'+docdir);
  cd(DOCPATH+'/'+docdir);
  unix('rm *.xml >& /dev/null');
  
  if exists('help_from_sci_fr')
    help_from_sci_fr(LIBPATH+'/'+docdir,DOCPATH+'/'+docdir);
  else
    help_from_sci(LIBPATH+'/'+docdir,DOCPATH+'/'+docdir);
  end
  
  unix('rm %*.xml >& /dev/null');
  unix('echo title = '+docdir+' > CHAPTER');
  cd(LIBPATH);
end

xmltojar(DOCPATH,'[DOC]');
unix('mv '+DOCPATH+'/../../jar/* '+DOCPATH)
rmdir(DOCPATH+'/../../jar/','s')

cd(path)

endfunction
