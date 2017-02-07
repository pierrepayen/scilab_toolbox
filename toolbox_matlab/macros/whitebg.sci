function whitebg(arg)
// whitebg de Matlab
// Calling Sequence
//   whitebg(mode)
// Parameters
//   mode: chaine de caratères. 'w', 'b'
// Description
// Applique une couleur de fond au graphe courant en modifiant les propriétés 'background' et 'hidden_axis_color'
// Si arg = 'w', une couleur blanche est appliquée
//          'b',             noire
// Examples
//  plot3d()
//  whitebg 'w'
// See also
//  gcf
//  gca
// Authors
//  Pierre Payen (06/2016) 
//

  select arg
  case 'w' then
    set(gcf(),'background',-2);
    set(gca(),'hidden_axis_color',-1);
  case 'b' then
    set(gcf(),'background',-1);
    set(gca(),'hidden_axis_color',-2);
  else
    error(44);
  end
endfunction
