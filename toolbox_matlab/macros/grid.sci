function grid(arg)
// grid de Matlab.
//
// Calling Sequence
//   grid(arg)
//   grid arg 
//
// Parameters
// arg: chaine de caractère. Peut valoir 'on','off','x','y','z'
//
// Description
// Permet d'afficher ou non, une grille sur le graphe courant selon les axes.
// Si arg = 'on', toutes les directions sont prises en compte.
//          'off', aucun axe n'est pris en compte.
//          'x','y','z' seule la direction correspondante est prise en compte.
// Sinon, ne fait rien
//
// Examples
// plot3d()
// grid('on') 
//
// See also
//  gca
//
// Authors
//  Pierre Payen (06/2016) 

  select arg
  case 'on' then
    set(gca(),'grid',[1 1 1]);
  case 'off' then
    set(gca(),'grid',[-1 -1 -1]);
  case 'x' then
    set(gca(),'grid',[1 -1 -1]);
  case 'y' then
    set(gca(),'grid',[-1 1 -1]);
  case 'z' then
    set(gca(),'grid',[-1 -1 1]);
  end
endfunction
