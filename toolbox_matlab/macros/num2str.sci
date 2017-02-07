function str=num2str(var)
// num2str de Matlab
//
// Calling Sequence
//   str = num2str(var)
//
// Parameters
// var: une variable Scilab: scalaire, vecteur, matrice, structure, handle.     
// str: vecteur de chaines de câractères.
//
// Description
// Renvoie la représentation de la valeur var en tant que chaine de charactère.
//
// Examples
// num2str(1:10)
// num2str(%i)
// num2str(ones(3,3))

// See also
//  string
//
// Authors
//  Pierre Payen (06/2016) 
//

  str = string(var);
endfunction
