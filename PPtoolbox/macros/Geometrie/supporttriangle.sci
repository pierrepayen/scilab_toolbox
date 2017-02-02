function supp=supporttriangle(a1,a2,a3,x)
  // renvoie l'appartenance de x à un triangle
  // Calling Sequence
  // supp=supporttriangle(obj,iel,x)
  // Parameters
  // obj: structure msh. voir msh.ci
  // iel: vecteur de taille n d'indices.
  // x: matrice nx3, composantes des points.
  // supp : vecteur de taille n de boolléen
  // Description
  // supporttriangle va calculer si le point x(i,:) appartient à au triangle iel(i), tel qu'il est défini par ses neuds obj.face.node(iel,:), dans ce cas supp(i) = %t;
  // See also
  // msh
  
  n = size(x,1)
  supp = (ones(1:n)==ones(1:n))' // on suppose par defaut que l'on est dans le triangle
  
  xa = [a1(:,1) a2(:,1) a3(:,1)];
  ya = [a1(:,2) a2(:,2) a3(:,2)];
  za = [a1(:,3) a2(:,3) a3(:,3)];
  
  // verification de x(i,:) dans le triangle iel(i)
  v = x - [xa(:,1) ya(:,1) za(:,1)]; // vecteur du noeud local 1 à x
  e1 = [xa(:,2) ya(:,2) za(:,2)]-[xa(:,1) ya(:,1) za(:,1)]; // vecteur du noeud local 1 à 2
  e2 = [xa(:,3) ya(:,3) za(:,3)]-[xa(:,1) ya(:,1) za(:,1)]; // vecteur du noeud local 1 à 3
  
  // on va d'abord vérifier que v est dans le plan de e1 e2, si non, supp=0 tout de suite
  e3 = [e1(:,2).*e2(:,3) - e1(:,3).*e2(:,2), e1(:,3).*e2(:,1) - e1(:,1).*e2(:,3),  e1(:,1).*e2(:,2) - e1(:,2).*e2(:,1)]
  ne3 = sqrt(sum(e3.^2,2))+%eps/2
  e3 = e3./[ne3 ne3 ne3] 
  s = sum(v.*e3,2) // produit scalaire
  c = abs(s)<%eps
  supp(~c)=%f // ps non nul :  v n'appartient pas au plan e1,e2
  supp2 = supp(c)
  e1 = e1(c,:)
  e2 = e2(c,:)
  v = v(c,:)
  ps1 = sum(v.*e1,2);
  ps2 = sum(v.*e2,2);
  ps3 = sum(v.*v,2);
  f1 = ps3 ./ps1;
  f2 = ps3 ./ps2;
  supp2 = ((f1+f2>1)|f1<0|f2<0)
  supp(c)=supp2
endfunction
