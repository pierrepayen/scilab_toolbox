function s2=%c_m_s(s1,n)
  // Surcharge de l'opérateur de multiplication entre string et entier
  //
  // Calling Sequence
  // s2 = %c_m_s(s1,n)
  // s2 = s1*n
  //
  // Parameters
  // s1,s2 : chaines de caractères
  // n : entier
  // Description
  // s2 contient la chaine s1 repétée n fois.
  // Examples
  // 'a'*10
  // Used function
  // strsubst
  // blanks
  //
  
  if type(s1)<>10 then
    error(msprintf(_("%s2: Wrong type for input argument #%d: String expected.\n"),"%%c_a_c",1));
  end
  if n<>int(n) then
    error(msprintf(_("%s2: Wrong type for input argument #%d: Integer expected.\n"),"%%c_a_c",2));
  end
  s2 = strsubst(blanks(n),' ',s1)
endfunction
