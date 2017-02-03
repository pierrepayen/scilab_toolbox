#!/bin/bash
ERROR_MSG="uninstall.sh: path.sce introuvable"
ls path.sce >&/dev/null || { echo $ERROR_MSG; exit 1; }

TOOLBOXNAME=`grep DOCTITLE path.sce | sed s/DOCTITLE=// | sed s/\'//g`
echo "# ------------------ Désinstallation $TOOLBOXNAME -----------------------"
echo "# Ce script va supprimer les .bin, .jar et restaurer scilab.ini."
echo "Continuer ? [y/n]"
read choix
choix=${choix:-'y'}

if [ $choix == 'y' ];then
  cd `pwd`
else
  exit 1
fi

echo "# Suppression des .bin, .xml, .jar, path.sce"
/bin/mv help/*.sce .

/bin/rm -r path.sce help/* macros/*/*.bin macros/*/names macros/*/lib

/bin/mv *help.sce help/
echo "# Suppression complète"

echo "# Recherche du dossier SCIHOME pour fichier scilab.ini"
SCIHOME=`scilab -nwni -nouserstartup -ns -e "disp('SCIHOME='+SCIHOME);exit" | grep "SCIHOME" | sed s/SCIHOME=// | sed s/\ //g`
echo " SCIHOME = "$SCIHOME

ERROR_MSG="uninstall.sh: scilab.ini introuvable. La désinstallation peut-être incomplète"
ls $SCIHOME/scilab.ini >&/dev/null || { echo $ERRO_MSG; exit 1; }

echo "# Restauration du fichier scilab.ini ..."
n1=`grep -n "// start $TOOLBOXNAME" $SCIHOME/scilab.ini | sed s/\:.*//`
n2=`grep -n "// end $TOOLBOXNAME" $SCIHOME/scilab.ini | sed s/\:.*//`

n1=${n1:-1}
n2=${n2:-2}

touch scilab.ini.new
if [ $n1 -ne 1 ]; then
  cat $SCIHOME/scilab.ini | sed -n 1,$(($n1-1))p >> scilab.ini.new
fi
cat $SCIHOME/scilab.ini | sed -n $(($n2+1)),'$'p >> scilab.ini.new

mv scilab.ini.new $SCIHOME/scilab.ini
echo "# Restauration complète."

echo "# Désinstallation terminée."
exit 0