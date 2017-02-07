function axis(arg)
// axis de Matlab
//
// Calling Sequence
//   axis(arg)
//   axis arg
//
// Parameters
// arg: chaine de caractère. Peut valoir 'equal','on','off'     
//
// Description
// Si arg = 'on', axis affiche les 3 axes et la boite englobante
// Si arg = 'off', axis efface les 3 axes plus la boite englobante
// Si arg = 'equal', axis redimmensionne les axes de façon à avoir une figure isométrique.
//
// Examples
// plot3d()
// axis equal 
//
// See also
//  gca
//
// Authors
//  Pierre Payen (06/2016) 

  select arg
  case 'equal' then
    set(gca(),'isoview','on')
  case 'off" then
    set(gca(),'box','off');
    set(gca(),'axes_visible',['off','off','off']);
  case 'on' then
    set(gca(),'axes_visible',['on','on','on']);
  else
   set(gca(),'isoview','off')
  end
endfunction
