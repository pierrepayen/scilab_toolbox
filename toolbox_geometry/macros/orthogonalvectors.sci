function [V,W]=orthogonalvectors(U,normalized,choice)
  // Renvoie 2 vecteurs orthogonaux arbitraires
  // Calling Sequence
  // [V,W]=orthogonalvectors(U[,'normalized'],[,'cartesian'/'fast'])
  // Parameters
  // U,V,W : matrices de reels taille (n x 3). U(i,j) contient la j ieme coordonées du i ieme vecteur.
  // opt_args : 'normalized', si renseignée, chaque vecteur de V et W sera normalisé à 1. 'cartesian'/'fast' : donne d'autre vecteurs orthogonaux. (voir description)
  //
  // Description
  // Soit une matrice contenant des vecteurs de R3, alors orthogonalvectors(U) renvoie 2 matrices de même taille contenant les composantes deux 2 vecteurs orthogonaux au premier. Les 3 vecteurs forment un trihèdre direct de R3. 
  //
  // Par defaut, ces vecteurs sont ceux de la base sphérique (convention colat-long) : si on considère que u = U(i,:) = nU*e_r. Ainsi v=V(i,:) = nU*e_tet et w=W(i,:) = nU.e_phi
  //
  // Si l'argument optionnel 'cartesian' est fourni, on procède différemment. L'idée est d'être le plus proche du repère cartésien : si u=U(i,:) est selon ex alors v=V(i,:) est de direction ey et w=W(i,:) de direction ez. Si u appartient au plan xOy (axes Ox et Oy exclus), alors v est selon ez, etc.
  //
  // Examples
  // figure()
  //    U = [ 1 0 0; 0 1 0; 0 0 1; 0 0 0; 1 1 0; 1 0 1; 0 1 1; 1 1 1];
  //  
  //    x = 1:size(U,1);
  //    y = zeros(x);
  //    z = zeros(x);
  //  
  //    nU = sqrt(sum(U.^2,2))+%eps;
  //    U = U ./ [nU nU nU];
  //
  //  [V,W] = orthogonalvectors(U,'normalized')
  //  champ3d(x,y,z,U(:,1),U(:,2),U(:,3),'headcolor',2) // vecteurs dont on veut les orthogonaux
  //  champ3d(x,y,z,V(:,1),V(:,2),V(:,3),'headcolor',3) // 1er vecteur orthogonal
  //  champ3d(x,y,z,W(:,1),W(:,2),W(:,3),'headcolor',5) // 2ieme vecteur orthogonal
  //  axis equal
  // 

  if ~exists('normalized') then normalized = 0; end;
  if ~exists('choice') then choice = 'spheric'; end;

  V = zeros(U)
  W = zeros(U)

  nU = sqrt(sum(U.^2,2));
  select choice
  case 'fast'
    V = [-U(:,2)-U(:,3),-U(:,3)+U(:,1),U(:,1)+U(:,2)];
  case 'spheric' then
    // U = nU.er; V = nU.e_theta, W = nU.e_phi
    tet = atan(sqrt(U(:,2).^2+U(:,1).^2),U(:,3));
    phi = atan(U(:,2),U(:,1));
    fx = nU .*cos(tet).*cos(phi);
    fy = nU .*cos(tet).*sin(phi);
    fz = -nU .*sin(tet).*ones(phi);
    V = [fx fy fz];
  case 'cartesian' then
    // pour tout (x,y,z) different de (xa,ya,za), et vérifiant equation
    // (x-xa,y-ya,z-za) est un vecteur normal au vecteur (u1,u2,u3)
    // on essaye de garder une orentation cartésienne : si le vecteur u est colinéaire à Ox, on prend ey comme 1er vecteur othogonal, si le vecteur appartient à un plan xOy, on va prendre ez comme 1er vecteur orthogonal, etc.
    
    u1 = U(:,1) // vecteur
    u2 = U(:,2)
    u3 = U(:,3)
    
    c1 = (u1<>0)
    c2 = (u2<>0)
    c3 = (u3<>0)

    ind1 = find(c1) // axe Ox
    ind2 = find(c2) // axe Oy
    ind3 = find(c3) // axe Oz

    V(ind1,2) = 1
    V(ind1,3) = 0

    V(ind2,1) = 0
    V(ind2,3) = 1

    V(ind3,1) = 1
    V(ind3,2) = 0
    V(ind1,1) = (V(ind1,2).*u2(ind1) + V(ind1,3).*u3(ind1)) ./u1(ind1)
    V(ind2,2) = (V(ind2,1).*u1(ind2) + V(ind2,3).*u3(ind2)) ./u2(ind2)
    V(ind3,3) = (V(ind3,1).*u1(ind3) + V(ind3,2).*u2(ind3)) ./u3(ind3)

    ind1 = find(c1&c2) // plan xOy
    ind2 = find(c2&c3) // plan yOz
    ind3 = find(c3&c1) // plan zOx

    V(ind1,2) = 0
    V(ind1,3) = 1

    V(ind2,1) = 1
    V(ind2,3) = 0

    V(ind3,1) = 0
    V(ind3,2) = 1
    V(ind1,1) = (V(ind1,2).*u2(ind1) + V(ind1,3).*u3(ind1)) ./u1(ind1)
    V(ind2,2) = (V(ind2,1).*u1(ind2) + V(ind2,3).*u3(ind2)) ./u2(ind2)
    V(ind3,3) = (V(ind3,1).*u1(ind3) + V(ind3,2).*u2(ind3)) ./u3(ind3)

    ind1 = find(c1&c2&c3) // pas d'orentation particuliere
    V(ind1,2) = 1
    V(ind1,3) = 1

    V(ind1,1) = (V(ind1,2).*u2(ind1) + V(ind1,3).*u3(ind1)) ./u1(ind1)
  end
  
  // le dernier est obtenu par produit vectoriel
  W = [U(:,2).*V(:,3) - U(:,3).*V(:,2), U(:,3).*V(:,1) - U(:,1).*V(:,3),  U(:,1).*V(:,2) - U(:,2).*V(:,1)]
  
  if normalized then
    nV = sqrt(sum(V.^2,2))+%eps/2;
    nW = sqrt(sum(W.^2,2))+%eps/2;
    V = [nU nU nU].*V ./ [nV nV nV];
    W = [nU nU nU].*W ./ [nW nW nW];
  end
endfunction
