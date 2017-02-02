function sRWG=foncbaseRWG()
  // Scruture de gestion des fonctions de base éléments finis Rao-Wilton-Glisson
  // Calling Sequence
  // sRWG=foncbaseRWG()
  // Parameters
  // sRWG : structure à 2 champs de type fonctions : loc,glob
  // Description
  // [phi1,phi2,phi3]=sRWG.loc(obj,iel,x) : prend un objet msh.sci en paramètre,
  // et renvoie les 3 fonctions de bases calculées au point x, relativement à l'élément iel.
  //
  // phi=sRWG.glob(obj,ied,x) : recompose <latex> \phi_l = \sum_{j=1,2}= \epsilon_{nj} \Phi_{nj} </latex>
  // , réecriture globale (enfonction des aretes) des fonctions de bases locales (en fonction des arêtes des éléments).

  sRWG.loc  = foncbaseRWGloc
  sRWG.glob = foncbaseRWGglob
endfunction

function [phi1,phi2,phi3] = foncbaseRWGloc(obj,iel,x)
  // fonction de base Rao Wilton Glisson en x d'un élement iel d'objet (msh.obj). cf Cours A.Bendali
  // Calling Sequence
  //  [phi1,phi2,phi3] = foncbaseRWG (obj,iel,x)
  // Parameters
  // obj: structure msh. voir msh.ci
  // iel: vecteur de taille n d'indices reltifs aux éléments.
  // x: matrice nx3, coordonées des points de l'espace.
  // phi1,phi2,phi3 : matrices nx3, composantes des fonctions de bases locales.
  // Description
  // Soit un objet msh obj. Soit une liste d'élément iel. Soit une liste de points x.
  // alors phi_i(j,k) contient la k-ieme composante du la i-eme fonction de base locale à l'élément iel(j)
  phi1=zeros(length(iel),3);
  phi2=zeros(length(iel),3);
  phi3=zeros(length(iel),3);

  a1 = [obj.node.x(obj.face.node(iel,1)) obj.node.y(obj.face.node(iel,1)) obj.node.z(obj.face.node(iel,1))];
  a2 = [obj.node.x(obj.face.node(iel,2)) obj.node.y(obj.face.node(iel,2)) obj.node.z(obj.face.node(iel,2))];
  a3 = [obj.node.x(obj.face.node(iel,3)) obj.node.y(obj.face.node(iel,3)) obj.node.z(obj.face.node(iel,3))];

  supp=supporttriangle(a1,a2,a3,x);
  
  // supp: vecteur boleen indiquant si x(i) appartient à l'élément iel(i)
  // si oui on fait les calculs

  iel = iel(supp);
  x = x(supp,:)
  n = length(iel);

  if n > 0 then
    a = obj.face.node(iel,:); // indice global des noeuds de l'élément

    xa = matrix(obj.node.x(a),n,3);
    ya = matrix(obj.node.y(a),n,3);
    za = matrix(obj.node.z(a),n,3);

    dxa = diff([xa xa(:,1)],1,'c').^2
    dya = diff([ya ya(:,1)],1,'c').^2
    dza = diff([za za(:,1)],1,'c').^2

    L=sqrt(dxa + dya + dza);
    p = 0.5*L(:,3).*((L(:,2).^2-L(:,1).^2) ./L(:,3).^2 + 1);
    h = sqrt(L(:,2).^2-p.^2);
    rK = h.*L(:,3)/2; // aire de chaque element

    if  obj.loaded<>'__FULL__' then
      disp('foncbaseRWG.sci(35): Stop. Maillage sans info sur arêtes. Utilisez msh.more().');
      abort
    end
    
    connect = obj.face.edge(iel,:)'
    
    b1 = obj.edge.node(abs(connect),:)(3*((1:n)-1)+1,:) // indice global des noeuds de l'arete 1 de l'élément iel
    b2 = obj.edge.node(abs(connect),:)(3*((1:n)-1)+2,:) // indice global des noeuds de l'arete 2 de l'élément iel
    b3 = obj.edge.node(abs(connect),:)(3*((1:n)-1)+3,:) // indice global des noeuds de l'arete 3 de l'élément iel

    aa = matrix(a',3*n,1)
    aa = [ aa aa ]

    bb1 = [b1 b1 b1]
    bb1 = matrix(bb1',2,n*3)'
    bb2 = [b2 b2 b2]
    bb2 = matrix(bb2',2,n*3)'
    bb3 = [b3 b3 b3]
    bb3 = matrix(bb3',2,n*3)'

    a1 = aa(find(sum((aa-bb1)==0,2)==0),1) // indice global du noeud en face de l'arete 1 de l'élément
    a2 = aa(find(sum((aa-bb2)==0,2)==0),1) // indice global du noeud en face de l'arete 2 de l'élément
    a3 = aa(find(sum((aa-bb3)==0,2)==0),1) // indice global du noeud en face de l'arete 3 de l'élément

    phi1(supp,:) = 0.5 ./[rK rK rK].*(x-[obj.node.x(a1) obj.node.y(a1) obj.node.z(a1)]);
    phi2(supp,:) = 0.5 ./[rK rK rK].*(x-[obj.node.x(a2) obj.node.y(a2) obj.node.z(a2)]);
    phi3(supp,:) = 0.5 ./[rK rK rK].*(x-[obj.node.x(a3) obj.node.y(a3) obj.node.z(a3)]);

  end
endfunction

function [phi]=foncbaseRWGglob(obj,ied,x)
  
  c = obj.edge.face(ied,:)
  b = c';
  iel1 = b(sign(b)>0);
  iel2 = -b(sign(b)<0);;

  sRWG = foncbaseRWG()
  [phi11,phi12,phi13] = sRWG.loc(obj,iel1,x)
  phi1=list(phi11,phi12,phi13);
  [phi21,phi22,phi23] = sRWG.loc(obj,iel2,x)
  phi2=list(phi21,phi22,phi23);
  
  ind = modulo(matrix(find(c'),2,length(ied))',3)
  ind(ind==0)=3
  
  for i =1:length(ied)
    phi(i,1:3) = sign(c(i,ind(i,1)))*phi1(ind(i,1))(i,:) + sign(c(i,ind(i,2)))*phi2(ind(i,2))(i,:)
  end
endfunction