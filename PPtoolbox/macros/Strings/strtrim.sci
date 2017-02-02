function str_out=strtrim(str_in,chr)
  // Supprime un caractère à droite et à gauche d'une chaine de caractère
  // Calling Sequence
  // str_out=strtrim(str_in,chr)
  // Parameters
  // str_in : chaine de caratères modèle
  // chr : caractère à enlever. Peut-être une chaine de caractère.
  // str_out : chaine de caratères modifiée.
  // Description
  // strtrim va analyser str_in et toutes les occurences de chr au début et à la fin de str_in, mais pas au milieu.
  // Pour cela, voir strsubst
  // Examples
  // str = '$$$ Supprimons les $ aux extrémités$$$'
  // strtrim(str,'$')
  // See also
  // strsubst
  // strsplit
  // Authors
  // Pierre Payen (08/2016)
  //

  c = strsplit(str_in,chr)
  ind = find(c<>'')
  c = c(ind(1):ind($))
  if length(ind)<2 then
    str_out = c(1)
  else
    str_out = strcat([c(1:$-1)+chr;c($)])
  end
endfunction

