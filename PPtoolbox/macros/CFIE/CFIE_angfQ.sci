function [tet,phi,Q]=CFIE_angfQ(f,r,tet,phi,angle)
  // Calcule les pas angulaire optimaux en fonction de f,r et du domaine angulaire.
  // Calling Sequence
  // [tet,phi,Q]=CFIE_angfQ(f,r,tet,phi,angle)
  // Parameters
  // f : scalaire; fréquence de l'onde Hz
  // r : scalaire; rayon de la sphere englobante en m
  // tet : vecteur 1x3; domaine angulaire colatitude en degrée
  // phi : vecteur 1x3; domaine angulaire longitude en degrée
  // angle : chaine de caractères; 'tet','phi','keep'
  // Description
  // tet et phi sont des vecteurs lignes à éléments contenant respectivement l'angle de départ, de fin et le pas.
  //
  // Soit Q = 2 + (k*R/pi)^2*DeltaOmega.
  // On va chercher les pas en theta (angle='tet') ou phi (angle ='phi') tel que l'on ai M = nombre d'angle = Q/2
  //
  // Si angle = 'keep', on ne modifie pas les pas, mais on afficher un avertissement, si M > Q/2;
  // 
  //  // Examples
  //   tet = [0,10,1]; // theta de 0 à 10 degrées,pas de 1.
  //   phi = [-5,5,1]; // phi de -5 à 5 degrées,pas de 1.
  //   f = 100E6; // fréquence à 100 MHz
  //   r = 1; // rayon à 1 m
  //   [tet,phi,Q] = CFIE_angfQ(f,r,tet,phi,'keep');
  //   [tet,phi,Q] = CFIE_angfQ(f,r,tet,phi,'tet');
  //   [tet,phi,Q] = CFIE_angfQ(f,r,tet,phi,'phi');
  //

  if argn(2)<5 then
    error(39)
  end
  tetr = %pi/180*tet
  phir = %pi/180*phi
  k = 2*%pi/3E8*f;
  Q = 2 + (k*r/%pi)^2*(tetr(2)-tetr(1))*(phir(2)-phir(1));

  select angle
  case 'tet' then
    M = ceil(1/2*Q);
    Mphi = floor((phi(2)-phi(1))/phi(3));
    Mtet = M/Mphi;
    tet(3) = ceil((tet(2)-tet(1))/Mtet);
  case 'phi' then
    M = ceil(1/2*Q);
    Mtet = floor((tet(2)-tet(1))/tet(3));
    Mphi = M/Mtet;
    phi(3) = ceil((phi(2)-phi(1))/Mphi);
  case 'keep' then
    // On garde les pas tels quel;
    M = floor((phi(2)-phi(1))/phi(3)*(tet(2)-tet(1))/tet(3))
    if M > 0.5*Q then
      warn = ['Pas angulaire trop petit';'M = '+string(M)+' > Q = '+string(Q)];
      messagebox(warn,'CFIE_angfQ','warning');
      disp(warn);
    end
  else
    mprintf('%s : Wrong argument number %d : %s unknown (use ''tet'',''phi'',''keep'')\n','CFIE_angfQ',3,string(angle));
    abort
  end
endfunction
