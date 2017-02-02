function string_out=strsubst2(string_in,searchStr,replaceStr,flag)
  // Surcharge de strsubst dans le cas où flag == regexp et dans une matrice de chaine de caractère
  // Calling Sequence 
  // string_out = strsubst(string_in, searchStr, replaceStr, [flag])
  // Description
  // Fontionne exactement comme strsubst, mais dans le cas où flag == 'r', le remplacement est effectué sur toutes les occurences et non plus que sur la 1ere.
  // Examples
  // s = 'coucou'
  // form = '/ou/'
  // remp = 'OU'
  // s1 = strsubst(s,form,remp,'r')
  // s2 = strsubst2(s,form,remp,'r')
  //
  // See also
  // strsubst
  // strindex
  // strindex2
  //
  // Used functions
  // strindex2, strsubst
  //
  // Authors
  // Pierre Payen (08/2016)
  //

  if  argn(2) < 4 then
    flag = 's'
  end
  
  string_out=string_in
  ii = strindex2(string_out,searchStr,flag)
  if flag=='r' then
    for i = 1:size(ii) // ligne du vecteur de string
      for j = 1 : length(ii(i)(2:$)) // occurence du symbole dans le cas regexp
        string_out(ii(i)(1)) = strsubst(string_out(ii(i)(1)),searchStr,replaceStr,flag)
      end
    end
  else // pas de regexp
    for i = 1:size(ii) // ligne du vecteur de string
      string_out(ii(i)(1)) = strsubst(string_out(ii(i)(1)),searchStr,replaceStr,flag)
    end
  end
endfunction
