#!/bin/bash
echo "------------------ Installation PPtoolbox -----------------------"
USERDIR=$PWD
echo "# Installation dans :" $USERDIR
echo "# Veuillez indiquez le nom de la toolbox:"
echo "  [Par défaut: PPtoolbox]"
read TOOLBOXNAME
TOOLBOXNAME=${TOOLBOXNAME:-PPtoolbox}

echo "# Génération des .bin, .xml, .png, .jar ..."

echo "LIBPATH='$USERDIR/macros'"                  >> $USERDIR/path.sce
echo "DOCPATH='$USERDIR/help'"                    >> $USERDIR/path.sce
echo "DOCTITLE='$TOOLBOXNAME'"                    >> $USERDIR/path.sce
echo "SOURCEPATH='$USERDIR/macros'"               >> $USERDIR/path.sce
scilab -nw -nouserstartup -f builder.sce

echo "# Modification du fichier SCIHOME/scilab.ini"
echo "# pour chargement de la toolbox au démarrage...."

echo "# Recherche du dossier SCIHOME pour fichier scilab.ini"
SCIHOME=`scilab -nwni -nouserstartup -ns -e "disp('SCIHOME='+SCIHOME);exit" | grep "SCIHOME"  | sed s/SCIHOME=// | sed s/\ //g`

echo " SCIHOME = "$SCIHOME
echo "// start $TOOLBOXNAME"                      >> $SCIHOME/scilab.ini
echo "mprintf('"$TOOLBOXNAME":\n');"              >> $SCIHOME/scilab.ini
echo "exec('"$USERDIR"/path.sce',-1);"            >> $SCIHOME/scilab.ini
echo "exec('"$USERDIR"/loader.sce',-1);"          >> $SCIHOME/scilab.ini
echo "clear LIBPATH DOCPATH DOCTITLE SOURCEPATH;" >> $SCIHOME/scilab.ini
echo "// end $TOOLBOXNAME"                        >> $SCIHOME/scilab.ini

echo "# Installation terminée."
exit 0
