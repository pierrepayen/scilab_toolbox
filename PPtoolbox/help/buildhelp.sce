//
mprintf('  gen help : %s \n',DOCPATH)

if exists('buildjar') then
  buildjar(SOURCEPATH,DOCPATH,DOCTITLE)
else
  xmltojar(DOCPATH,'[DOC]');
  unix('mv '+DOCPATH+'/../../jar/* '+DOCPATH)
  rmdir(DOCPATH+'/../../jar/','s')
end
