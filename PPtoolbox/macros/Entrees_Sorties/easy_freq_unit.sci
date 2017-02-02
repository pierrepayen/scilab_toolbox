function [ff,unit]=easy_freq_unit(f)
// Fonction de conversion Hz -> kHz ; MHz ; Ghz
//
// Calling Sequence
// [ff,unit] = easy_freq_unit(f)
//
// Parameters
// f : réel, fréquence en Hz de l'onde
// ff : réel, fréquence entre 1 et 100
// unit : chaine de caractères, unité de la fréquence 'Hz','kHz','MHz','GHz'
//
//  Description
// Prend comme paramètre un réel, la fréquence attendue en hertz et la renvoie dans une unité plus lisible.
// ff est la valeur comprise dans ]0,1000] et unit vaut Hz,kHz etc.

  strHz = ['Hz' 'kHz' 'MHz' 'GHz'];
  if (f <> 0)
    n = 3*floor(log10(f)/3);
    n = min(n,12);
    ff = f*10^(-n);
  else
    n = 1;
    ff = f;
  end
  unit = strHz(floor(n/3)+1);
endfunction
