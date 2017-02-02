function [ind,which]=strindex2(haystack,needle,flag)
  // Surcharge de strindex pour gérer des vecteurs de chaines de caractères.
  // Calling Sequence
  // ind = strindex(haystack, needle, [flag])
  // [ind, which] = strindex(haystack, needle, [flag])
  // Parameters
  // haystack : vecteur de chaines de caractères. La zone de recherche, effectué ligne par ligne.
  // needle : vecteur de chaines de caractères. Les symboles à rechercher dans haystack.
  // ind :  list de taille (nombre de ligne d'occurence).
  // which :  list de taille (nombre de ligne d'occurence).
  // flag : un caractère. 'r' pour des expressions régulières.
  // Description
  // strindex2 fonctionne comme une surcharge de strindex : 
  // dans ind(:)(1) sont contenus les indices des lignes où le symbole est trouvé et dans ind(:)(2:$) l'index local à la lignede ce symbole. Autrement, strindex(text(ind(i)(1)),'e') == ind(i)(2:$)
  // Et si rien n'est trouvé ind = list()
  // Examples
  // text = ['un texte sur';'plusieurs lignes']
  // ind = strindex2(text,'e')
  // strindex(text(ind(1)(1)),'e') == ind(1)(2:$)
  // See also
  // strindex
  // Authors
  // Pierre Payen (08/2016)
  //
  
  if  argn(2) < 3 then
    flag = 's'
  end
  M = size(haystack,1)
  ind = list()
  which = list()
  for i = 1:M
    [iind,iwhich] = strindex(haystack(i),needle,flag)
    if length(iind)>0
      ind($+1) = [i iind];
      which($+1) = [i iwhich];
    end
  end
endfunction
