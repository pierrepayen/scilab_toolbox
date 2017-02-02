function n = mgetlinenumber(f)
  // Lit un fichier et retourne le nombre de lignes.
  // Calling Sequence
  // n = mgetlinenumber(f)
  // Parameters
  // f : entier ou une chaine de caractère.
  // n : entier
  // Description 
  // Si f est une entier, il doit être le descripteur d'unité logique (renvoyé par mopen)
  //
  // Si f est une chaine de caractères, c'est le chemin vers le fichier.
  // 
  // See also
  // mopen
  // mgetl
  // mseek
  // mtell
  // 
  
  if type(f)==10 then // string : filepath
     fid = mopen(f,'r')
  elseif type(f)==1 & f==int(f) then// file descriptor unit
    fid = f
    t = mtell(fid)
    mseek(0,fid)
  else // wrong arg
    error(36)
  end

  str = mgetl(fid,1)
  k = 0
  while str <> []
    str = mgetl(fid,1)
    k = k+1;
  end

  if type(f)==10 then // string : filepath
      mclose(fid)
  elseif type(f)==1 & f==int(f) then// file descriptor unit
    mseek(t,fid)
  end
  n = k
endfunction
