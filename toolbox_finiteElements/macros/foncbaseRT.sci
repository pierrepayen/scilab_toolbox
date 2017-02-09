function sRT=foncbaseRT()
  // Scruture de gestion des fonctions de base éléments finis Raviar Thomas.
  // Calling Sequence
  // sRT=foncbaseRT()
  // Parameters
  // sRT : structure à 2 champs de type fonctions : bary, J
  // Description
  // [phi1,phi2,phi3]=sRT.bary(obj) : prend un objet msh.sci en parametre, et renvoie les 3 fonctions de bases calculées au barycentre de chaque élément.
  //
  // J=sRT.J(obj,I) : recompose <latex> J = \sum_j \Phi_j I_j </latex> où <latex>\phi_j</latex> est la j-ieme fonction de base associée à l'arête j.
  sRT.bary  = foncbaseRTbary
  sRT.J = JfoncbaseRTbary
endfunction

function [phi1,phi2,phi3] = foncbaseRTbary(obj)
  // fonction base Raviart Thomas
  phi1=zeros(obj.nface,3);
  phi2=zeros(obj.nface,3);
  phi3=zeros(obj.nface,3);

  a1 = [obj.node.x(obj.face.node(:,1)) obj.node.y(obj.face.node(:,1)) obj.node.z(obj.face.node(:,1))];
  a2 = [obj.node.x(obj.face.node(:,2)) obj.node.y(obj.face.node(:,2)) obj.node.z(obj.face.node(:,2))];
  a3 = [obj.node.x(obj.face.node(:,3)) obj.node.y(obj.face.node(:,3)) obj.node.z(obj.face.node(:,3))];

  e1 = a2-a1
  e2 = a3-a1
  
  a = 1/3*[1 1 -2;-2 1 1];
  
  e3 = vectprod(e1,e2);
  g = sqrt(sum(e3.^2,2));

  C = 1 ./sqrt([g g g]);
  phi1 = C.*(a(1,1)*e1 + a(2,1)*e2);
  phi2 = C.*(a(1,2)*e1 + a(2,2)*e2);
  phi3 = C.*(a(1,3)*e1 + a(2,3)*e2);
endfunction

function [J] = JfoncbaseRTbary(obj,I)
  J1=zeros(obj.nface,3);
  J2=zeros(obj.nface,3);
  J3=zeros(obj.nface,3);

  n1 = obj.face.node(:,1)
  n2 = obj.face.node(:,3)
  n3 = obj.face.node(:,2)
  
  a1 = [obj.node.x(n1) obj.node.y(n1) obj.node.z(n1)];
  a2 = [obj.node.x(n2) obj.node.y(n2) obj.node.z(n2)];
  a3 = [obj.node.x(n3) obj.node.y(n3) obj.node.z(n3)];

  e1 = a2-a1
  e2 = a3-a1
  e3 = vectprod(e1,e2);
  g = sqrt(sum(e3.^2,2));

  C = 1 ./[g g g];
  a = 1/3*[1 1 -2;-2 1 1];
  
  c = obj.edge.face;
  c2 = abs(obj.face.edge);
  k1 = c(:,1);
  k2 = c(:,2);
  k3 = c(:,3);

  I1 = sign(k1).*I
  II1 = I1(c2(:,1));
  I2 = sign(k2).*I
  II2 = I2(c2(:,2));
  I3 = sign(k3).*I
  II3 = I3(c2(:,3));

  J1 = C.*[II1 II1 II1].*(a(1,1)*e1 + a(2,1)*e2);
  J2 = C.*[II2 II2 II2].*(a(1,2)*e1 + a(2,2)*e2);
  J3 = C.*[II3 II3 II3].*(a(1,3)*e1 + a(2,3)*e2);

  J = J1+J2+J3;
endfunction
