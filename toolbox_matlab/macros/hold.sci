function hold(arg)
// hold de Matlab
//
// Calling Sequence
//   hold(arg)
//   hold arg
//
// Parameters
// arg: chaine de caractère. 'on', 'off'     
//
// Description
// Si arg = 'on', les axes ne seront pas modifiés automatiquement par de
//  nouveaux graphes. Mais ils peuvent l'être manuellement.
// Si arg ='off', annule cet effet.
//
// Examples
// plot3d()
// hold 'on'
// plot2d()
// hold('off')
// plot3d()
//
// See also
//  gca
//
// Authors
//  Pierre Payen (06/2016) 
//

  select arg
  case 'on' then
    set(gca(),'auto_clear','off')
  case 'off' then
    set(gca(),'auto_clear','on')
  end
endfunction
