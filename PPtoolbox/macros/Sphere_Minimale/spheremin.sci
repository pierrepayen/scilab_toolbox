function sphereminS=spheremin()
  // Structure de gestion pour calcul de sphère minimale (bounding sphere) à un nuage de points 3D/2D. 
  //
  // Calling Sequence
  //   spmin = spheremin()
  //
  // Description
  // Plus qu'une fonction, c'est une structure dont les champs sont des fonctions pour calculer heristiquement (5% -> 20% erreur) le centre & le rayon de la sphère minimale à un nuage de points
  //
  // Tentative d'écriture en POO, mais très imparfait
  //
  // Description des champs de spheremin :
  // <itemizedlist>
  //   <listitem><para>'calc' : structure à 2 champs pour calculer la sphere minimale (le cercle minimal) à un nuage de points 3D (2D)
  //    <itemizedlist>
  //      <listitem><para>'sphere' : [Xc,r] = spmin.calc.sphere(X); Prend une matrice n x 3 et renvoie les coordonnées du centre et le rayo. L'algo utilise fminsearch. Pour un algo plus rapide mais moin précis,  utiliser [Xc,r] = spmin.calc.sphere(X,algo='heuris')</para></listitem>
  //      <listitem><para>'cercle' : [Xc,r] = spmin.calc.cercle(X); Prend une matrice n x 2 et renvoie les coordonnées du centre et le rayo. </para></listitem>
  //    </itemizedlist>
  // </para></listitem>
  // <listitem><para>'plot' : structure à 3 champs pour afficher la sphere (le cercle) et le nuage de points. 
  //    <itemizedlist>
  //      <listitem><para>'sphere' : spmin.plot.sphere(Xc,r); Affiche une sphère caractérisée par son centre Xc et son rayon. </para></listitem>
  //      <listitem><para>'cercle' : spmin.plot.cercle(Xc,r); Affiche un cercle caractérisé par son centre Xc et son rayon.</para></listitem>
  //      <listitem><para>'points' : spmin.plot.points(X[,'style',style][,'color',color]); Affiche un nuage de points, matrice n x 2 ou n x 3</para></listitem>
  //    </itemizedlist>
  //  </para></listitem>
  // </itemizedlist>
  //
  // Examples
  // x = rand(10,1) // vecteur colonne !
  // y = rand(10,1)
  // z = rand(10,1)
  // X = [x,y,z] // matrice n x 3
  // spmin = spheremin() // initialisation de la structure
  // [Xc,r] = spmin.calc.sphere(X)  // calcule la sphere minimale à X 
  //  spmin.plot.sphere(Xc,r) // affiche la sphere 
  //  spmin.plot.points(X) // affiche les points 
  //
  // See also
  //  msh
  //  xarc
  //  plot3d1
  // fminsearch
  //
  // Authors
  //  Pierre Payen (06/2016) 
  //

  sphereminS = struct()
  sphereminS.plot = struct()
  sphereminS.plot.cercle = SM_plotC
  sphereminS.plot.sphere = SM_plotS
  sphereminS.plot.points = SM_plotP
  sphereminS.calc = struct()
  sphereminS.calc.cercle = SM_Bounding_cercle
  sphereminS.calc.sphere = SM_Bounding_sphere
endfunction

function SM_plotC(Xc,r)
  x = Xc(1) - r
  y = Xc(2) + r
  w = 2*r
  h = 2*r
  xarc(x,y,w,h,0,360*64)
endfunction

function SM_plotS(Xc,r)
  deff("[x,y,z]=sphere(alp,tet)",["x=r*cos(alp).*cos(tet)+Xc(1)*ones(tet)";..
  "y=r*cos(alp).*sin(tet)+Xc(2)*ones(tet)";..
  "z=r*sin(alp)+Xc(3)*ones(tet)"]);
  [xx,yy,zz]=eval3dp(sphere,linspace(-%pi/2,%pi/2,25),linspace(0,%pi*2,25));
  plot3d1(xx,yy,zz)
  set(gce(),'color_mode',0)
endfunction

function SM_plotP(X,varargin)

  style = 1
  col = 0
  x = X(:,1)
  y = X(:,2)
  z = X(:,3)
  if argn(2)>1 then
    for i = 1:length(varargin)/2
      key = varargin(2*i-1)
      val = varargin(2*i)
      select key
      case 'style' then
        style = val
      case 'color' then
        col = val
      end
    end
  end

  l = length(x)
  if l == 1 then
    x = [x x]
    y = [y y]
    z = [z z]
  else
    x = matrix(x,1,l)
    y = matrix(y,1,l)
    z = matrix(z,1,l)
  end
  plot3d(x,y,z)
  set(gce(),'mark_mode','on');
  set(gce(),'mark_style',style);
  set(gce(),'mark_foreground',col);
endfunction

function dist=SM_d(x1,x2)
  [m,k]= max(size(x1))
  dist = sqrt(sum((x1-x2).^k,k)) // xi vecteur coordonnées
endfunction

function y=SM_getfarest(p,X)
  r = 0;
  for i=1:size(X,1)
    x = X(i,:)
    dist=SM_d(x,p)
    if dist > r then
      r = dist
      y = x
    end
  end
endfunction

function [Xc,r]=SM_Bounding_cercle(X)
  y = SM_getfarest(X(1,:),X)
  z = SM_getfarest(y,X)
  Xc = 0.5*(y+z)
  r = SM_d(y,Xc)

  for i = 1:size(X,1)
    Xp = X(i,:)
    if SM_d(Xp,Xc) > r
      phi = atan(Xp(2)-Xc(2),Xp(1)-Xc(1))
      sig = sign(Xc - Xp)
      decal = abs(r*[cos(phi) sin(phi)])
      pbc = decal.*sig+Xc
      Xc = 0.5*(Xp+pbc)
      r = sqrt(sum((Xc - Xp).^2,2))
    end
  end
endfunction

function [Xc,r]=SM_Bounding_sphere(X,algo)
  if ~exists('algo') then
    algo = 'optim'
  end
  select algo
  case 'heuris' then
    // algo heuristique Pierre Payen
    // Initialisation : on commence par prendre un point X(1,:). On cherche y le plus loin de X.
    // on cherche z le plus loin de y.
    // la sphère initiale est de centre milieu de y,z et de rayon la distance du centre à y.
    // Algo : On boucle sur les points:
    // ->soit un nouveau point Xp. On calcule d=distance(Xc,Xp).
    //   si d > r, alors on cherche la sphère englobante l'ancienne sphère et le point.
    //   pour cela, on prend la droite passant par Xp et Xc et touchant la sphère en Xs. 
    //   La nouvelle sphère est alors au milieu de Xp et Xs et de rayon dist(Xp,Xs)
    // <-
    // algo 'rapide' (3 sec pour 40 000 points), mais donne des réultats faux si peu de points et géometrie de révolution.
    // pour voir ce problème, essayer avec un petit ensemble de points  (~ 30 ) définissant un cône.
    // dans ces cas, essayer algo=2
    y = SM_getfarest(X(1,:),X)
    z = SM_getfarest(y,X)
    Xc = 0.5*(y+z)
    r = SM_d(y,Xc)
    for i = 1:size(X,1);
      Xp = X(i,:);
      if SM_d(Xp,Xc) > r;
        tet = atan(SM_d(Xp(1:2),Xc(1:2)),Xp(3)-Xc(3));
        phi = atan(Xp(2)-Xc(2),Xp(1)-Xc(1));
        sig = sign(Xc - Xp);
        decal = abs(r*[sin(tet)*cos(phi) sin(tet)*sin(phi) cos(tet)]);
        Xs = decal.*sig+Xc;
        Xc = 0.5*(Xp+Xs);
        r = sqrt(sum((Xc - Xp).^2,2));
      end
    end
  case 'optim' then // minimisation via fminsearch. Si nombre de points > 10 000, risque de problèmes ave stacksize
    function f = costf(X,Xi) // fonction coût, valeur à minimiser
      x = X(1);
      y = X(2);
      z = X(3);
      xi = Xi(:,1);
      yi = Xi(:,2);
      zi = Xi(:,3);
      f = max((x-xi).^2 + (y-yi).^2 + (z-zi).^2);
    endfunction
    try
      [Xc,r] = fminsearch(list(costf,X),mean(X,1));
       r = sqrt(r);
    catch
      mprintf('ERROR: spheremin.calc.sphere(X,algo='''+algo+''') : fminsearch impossible. Essai avec algo=''heuris''\n')
      [Xc,r]=SM_Bounding_sphere(X,algo='heuris')
    end

  end
endfunction
