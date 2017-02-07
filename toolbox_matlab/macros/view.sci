function view(theta,phi)
// view de Matlab
//
// Calling Sequence
//   view(theta,phi)
//
// Parameters
//   theta: reel dans [ 0, 180 [
//   phi: reel dans [ 0, 360 [
//
// Description
//  Oriente le point du vue du graphique courant dans les coordonnées sphériques (theta,phi) en degrée.
//
// Examples
// plot3d()
//  view(0,-90)
//
// See also
//  gca
//
// Authors
//  Pierre Payen (06/2016) 
//
  set(gca(),"rotation_angles",[theta phi]); 
endfunction
