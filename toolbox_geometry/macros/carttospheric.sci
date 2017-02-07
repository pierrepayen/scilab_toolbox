function [r,tet,phi,fr,ftet,fphi,er,etet,ephi]=carttospheric(x,y,z,fx,fy,fz);
    // Passage de coordonnées et composantes sphériques (convention colat-long) à cartésiennes pour un vecteur pour trace dans un graphe.
  // Calling Sequence
  // [r,tet,phi]=carttospheric(x,y,z)
  // [r,tet,phi,fr,ftet,fphi[,er,etet,ephi]]=carttospheric(x,y,z,fx,fy,fz)
  // Parameters
  // x,y,z : vecteur (npt) de réels. Coordonnées du point initial du vecteur.
  // fx,fy,fz : vecteur (npt) réels. Composantes du vecteur sur (ex,ey,ze).
  // r : vecteur (npt) de réels  >= 0
  // tet : vecteur (npt) angle (radian) depuis l'axe 0Z. Appartient à [0,pi[
  // phi : vecteur (npt) angle (radian) depuis le plan x0z. Appartient à [-pi/2,pi/2[
  // fr,ftet,fphi : vecteur (npt) de réels. Composantes du vecteur sur la base (er,etheta,ephi)
  // er,etet,ephi : vecteur (npt) de réels. Projection de la base (er,etet,ephi) sur (ex,ey,ez)
  // Description
  // Le système de coordonnées est colatitude-longitude : tet mesure l'angle entre le point initial et l'axe Oz et phi entre le point et le plan xOz.
  //
  // Soit le vecteur de point initial (x,y,z)(i) de composantes (fx,fy,fz)(i), carttospheric calcule les coordonnées sphériques (r,tet,phi)(i) du point initial, et aussi les composantes sphériques (er,etet,ephi)(i) du vecteur. 
  // On veut tracer ce vecteur. On donc bien besoin de savoir le repère (er,etheta,ephi) à utiliser. C'est pour cela que ces vecteurs sont renvoyés comme des vecteures de R3.
  //
  // Examples
  //    x = [1 0 0]; // on s'attend à avoir r,tet,phi = [1,pi/2,0]
  //    y = [0 1 0]; // on s'attend à avoir r,tet,phi = [1,pi/2,pi/2]
  //    z = [0 0 1]; // on s'attend à avoir r,tet,phi = [1,0,0]
  //  
  //    fx = [1 0 0];  // on s'attend à avoir fr,ftet,fphi = [1,0,0]
  //    fy = [0 1 0];  // on s'attend à avoir fr,ftet,fphi = [1,0,0]
  //    fz = [0 0 1];  // on s'attend à avoir fr,ftet,fphi = [1,0,0]
  //    [r,tet,phi,fr,ftet,fphi]=carttospheric(x,y,z,fx,fy,fz);
  //
  // Authors
  // Pierre Payen
  //
  
  x = matrix(x,length(x),1);
  y = matrix(y,length(y),1);
  z = matrix(z,length(z),1);
  fx = matrix(fx,length(fx),1);
  fy = matrix(fy,length(fy),1);
  fz = matrix(fz,length(fz),1);
  
  if argn(2)<4 then
    fx = zeros(x);
    fy = fx;
    fz = fx;
  end
  
  r = sqrt(x.^2+y.^2+z.^2);
  tet = atan(sqrt(x.^2+y.^2),z);
  phi = atan(y,x);
  
  er = [x y z] ./ [r r r];
  etet = [cos(tet).*cos(phi), cos(tet).*sin(phi), -sin(tet)];
  ephi = [-sin(phi), cos(phi), zeros(phi)];
  
  V = [fx fy fz];
  
  fr   = sum(V.*er,2);
  ftet = sum(V.*etet,2);
  fphi = sum(V.*ephi,2);
endfunction
