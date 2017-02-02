function subplot2(m,n,p)
  // Surcharge de subplot pour gérer des subplots étendus sur plusieurs cases.
  // 
  // Calling Sequence
  // subplot(m,n,p)
  // subplot(m,n,[l1,c1,l2,c2])
  //
  // Parameters
  // m,n : entiers. Respectivements nombres de lignes et de colonnes du subplot
  // p : entiers. indice du subplot. Voir subplot.
  // l1,c1,l2,c2 : entiers. Indice du coin supérieur gauche (l1,c1) puis inférieur droit (l2,c2) que vas recouvrir le subplot.
  //
  // Description
  // subplot2 permet d'étendre un subplot sur plusieurs lignes/colonnes ou les deux, en modifiant la propiétés axes_bounds
  //
  // Examples
  // figure
  // subplot(3,2,1)
  // plot2d
  // subplot(3,2,2)
  // histplot
  // subplot2(3,2,[2 1 3 2]) // va prendre les dernières lignes entières
  // param3d
  // See also
  // subplot
  // gca
  
  
  if length(p)>1 then
    l1 = p(1);
    c1 = p(2);
    l2 = p(3);
    c2 = p(4);
    subplot(m,n,n*(l1-1)+c1);
    a=gca();
    a.axes_bounds(3)=a.axes_bounds(3)*(c2-c1+1)
    a.axes_bounds(4)=a.axes_bounds(4)*(l2-l1+1)
  else
    subplot(m,n,p)
  end
endfunction
