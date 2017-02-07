function cla()
// cla de Matlab
//
// Calling Sequence
//   cla()
//
// Description
// Supprime les axes du graphique courant.
//
// Examples
// plot2d()
// cla() 
//
// See also
//  gca
//
// Authors
//  Pierre Payen (06/2016) 

  a = gca();
  delete(a.children);
endfunction
