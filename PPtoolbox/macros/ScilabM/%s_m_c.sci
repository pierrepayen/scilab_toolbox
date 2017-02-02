function s2=%s_m_c(n,s1)
  // Surcharge de l'opérateur de multiplication entre entier et string
  //
  // Calling Sequence
  // s2 = %s_m_c(n,s1)
  // s2 = n*s1
  //
  // Parameters
  // s1,s2 : chaines de caractères
  // n : entier
  // Description
  // s2 contient la chaine s1 repétée n fois.
  // Examples
  // 10*'a'
  // Used function
  // strsubst
  // blanks
  //
  
  if n<>int(n) then
    error(msprintf(_("%s2: Wrong type for input argument #%d: Integer expected.\n"),"%%c_a_c",1));
      if type(s1)<>10 then
    error(msprintf(_("%s2: Wrong type for input argument #%d: String expected.\n"),"%%c_a_c",2));
  end
  end
  s2 = strsubst(blanks(n),' ',s1)
endfunction
