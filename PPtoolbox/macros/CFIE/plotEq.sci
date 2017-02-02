function plotEq(tet,phi,Eqtet,Eqphi)
  // Affiche les champs singuliers sur la sphère unité.
  // Calling Sequence
  // plotEq(tet,phi,Eqtet,Eqphi)
  // Parameters
  // tet : vecteur taille n1
  // phi : vecteur taille n2
  // Eqtet : vecteur taille n1*n2 contenant la composante theta de Eq
  // Eqtet : vecteur taille n1*n2 contenant la composante phi de Eq
  
  r=1;
  [tet2,phi2] = meshgrid(tet,phi);
  tet2 = matrix(tet2,length(tet2),1);
  phi2 = matrix(phi2,length(phi2),1);
  [x,y,z,fx,fy,fz] = spherictocart(r,tet2,phi2,0,abs(Eqtet),abs(Eqphi));
  // Les Eq sont normalisés :  |Eq|<1 
  val = sqrt(abs(Eqtet).^2 +abs(Eqphi).^2);
  mn = min(val);
  mx = max(val);
  //set(gcf(),'figure_size',[1000 1000]);
  whitebg('w');
  sphereplot(tet,phi,matrix(val,Mp,Mt)');
  colorbar(mn,mx);
  colorbarlegend('norme L2 du champ')
  champ3d(x,y,z,fx,fy,fz);
endfunction
