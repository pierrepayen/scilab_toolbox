// Génération des *.bin et *.jar
path=pwd();
path=fullpath(path);
exec(path+'/path.sce',-1);
exec(path+'/macros/buildmacros.sce',-1);
exec(path+'/help/buildhelp.sce',-1);

exit();
