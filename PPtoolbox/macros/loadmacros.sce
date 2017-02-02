// permet de charger des bibliothèques de fonctions scilab
mprintf('  load bin  : %s \n',LIBPATH)
path = pwd();
cd(LIBPATH);

adir = dir();
alib = adir(2)(adir(5));
for i = 1:size(alib,1);
  execstr(alib(i)+'lib=lib('''+LIBPATH+'/'+alib(i)+''')');
end
clear dir


for i = 1:size(alib,1)
  lis = who('get');
  lis = lis($:-1:1);
  k = find(lis==alib(i)+'lib');
  n = predef() + 1;
  for j=n:k-1
    execstr('tmp'+lis(j)+'='+lis(j)+';');
    execstr('clear '+lis(j)+';')
    execstr(lis(j)+'=tmp'+lis(j)+';');
    execstr('clear tmp'+lis(j)+';')
  end
  predef(n);
end

cd(path);
clear alib adir lis i k j n ans path