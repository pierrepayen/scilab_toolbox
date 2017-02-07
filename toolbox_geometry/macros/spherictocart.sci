function [x,y,z,fx,fy,fz]=spherictocart(r,tet,phi,fr,ftet,fphi)
  // Passage de coordonnées et composantes cartésiennes à sphériques (convention colat-long) pour un vecteur pour trace dans un graphe
  // Calling Sequence
  // [x,y,z,fx,fy,fz]=sphfrictocart(r,tet,phi,fr,ftet,fphi)
  // Parameters
  // r : vecteur (npt) de réels  >= 0
  // tet : vecteur (npt) angle (radian) depuis l'axe 0Z. Appartient à [0,pi[
  // phi : vecteur (npt) angle (radian) depuis le plan x0z. Appartient à [-pi/2,pi/2[
  // fr,ftet,fphi : vecteur (npt) de réels. Composantes du vecteur sur la base (fr,etheta,fphi)
  // x,y,z : vecteur (npt) de réels. Coordonnées du point initial du vecteur.
  // fx,fy,fz : vecteur (npt) réels. Composantes du vecteur sur (ex,ey,ze).
  // Description
  // Le système de coordonnées est colatitude-longitude : tet mesure l'angle entre le point initial et l'axe Oz et phi entre le point et le plan xOz.
  //
  // Soit le vecteur de point initial (r,tet,phi)(i) de composantes (fr,ftet,fphi)(i), sphfrictocart calcule les coordonnées cartésiennes (x,y,z)(i) du point initial, et aussi les composantes cartésiennes (fx,fy,fz)(i) du vecteur. 
  // Normalement le fait de dire 'un vecteur passe par un point' n'a pas de sens. Mais ici on veut tracer ce vecteur. on donc bien besoin de savoir le repère er,etheta,ephi à utiliser. Cela nécessite de connaitre un point pour calculer r,theta,phi,fr,etheta,fphi, et d'en déduire fx,fy,fz. Sans ce point, tous les vecteurs sont du type r*er.
  //
  //
  // Examples
  //    r = 1;
  //    tet = [0,%pi/2,%pi/2];
  //    phi = [0,0,%pi/2]; // points en (0,0,1) (1,0,0) (0,1,0) dans repère cartésien
  //   
  //    fr = [1 0 0];   // vecteur en fr et point en (0,0,1) donc vecteur en (0,0,1) dans cartésien
  //    ftet = [0 1 0]; // vecteur en ftet et point en (1,0,0) donc vecteur en (0,0,-1) dans cartésien
  //    fphi = [0 0 1]; // vecteur en fphi et point en (0,1,0, donc vecteur en (-1,0,0) dans cartésien
  //    [x,y,z,fx,fy,fz] = spherictocart(r,tet,phi,fr,ftet,fphi);
  //
  
  // Authors
  // Pierre Payen
  //

if argn(2)<4 then
  fr = 0
  fphi = 0
  ftet = 0
end

  r    = matrix(r,length(r),1);
  tet  = matrix(tet,length(tet),1);
  phi  = matrix(phi,length(phi),1);
  fr   = matrix(fr,length(fr),1);
  ftet = matrix(ftet,length(ftet),1);
  fphi = matrix(fphi,length(fphi),1);

  ct = cos(tet);
  st = sin(tet);
  sp = sin(phi);
  cp = cos(phi);

  x = r.*st.*cp;
  y = r.*st.*sp;
  z = r.*ct.*ones(cp);

  fx = fr.*st.*cp + ftet.*ct.*cp - fphi.*sp;
  fy = fr.*st.*sp + ftet.*ct.*sp + fphi.*cp;
  fz = fr.*ct - ftet.*st;

endfunction
