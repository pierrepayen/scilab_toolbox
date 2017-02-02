// permet de charger des bibliothèques de fonctions scilab
mprintf('  gen bin : %s \n',SOURCEPATH)

cd(SOURCEPATH);

adir = dir();
alib = adir(2)(adir(5));
for i = 1:size(alib,1);
  genlib(alib(i)+'lib',SOURCEPATH+'/'+alib(i))
end
