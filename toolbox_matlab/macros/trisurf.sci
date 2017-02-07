function trisurf(Nodes,X,Y,Z,varargin)
  // trisurf de Matlab.
  //
  // Calling Sequence
  //    trisurf(nodes,x,y,z [,opt_args])
  //
  // Parameters
  // nodes : matrice réelle taille (nelements x npointpartelement).
  // x,y,z : vecteurs réels taille (npoints)
  // opt_args : arguments optionnels par couple 'key',val 
  //
  // Description
  // Va représenter le maillage defini par les points en x,y,z et les éléments définis par les points nodes.
  // 
  // Details de opt_args:
  // <itemizedlist>
  // <listitem><para>key = 'value' : val est un vecteur de réel taille (nelement).Appliquera une couleur relative à value sur chaque élément. Par défaut , vecteur de 1.</para></listitem>
  // <listitem><para>key = 'min' : val est un réel. Si 'value' est indiqué, appliquera une couleur relative à [min,value] sur chaque élément. Par défaut, %inf.</para></listitem>
  // <listitem><para>key = 'max' : val est un réel. Si 'value' est indiqué, appliquera une couleur relative à [value,max] sur chaque élément. Par défaut, -%inf</para></listitem>
  // <listitem><para>key = 'color' : val est un entier. Appliquera la couleur val sur toute la surface; si 'value' est fournis, ne sert à rien. Par défaut, 2.</para></listitem>
  // </itemizedlist>
  //
  // Examples
  //    nodes = [ 1 2 3; 1 4 2; 1 3 4]
  //    x = [0 0 1 -1 0]'
  //    y = [0 1 0 -1 2]'
  //    z = [0 -1 0 -1 0]'
  //
  //    figure(1)
  //    set(gcf(),'background',-2)
  //    subplot(2,2,1)
  //    // Affichage simple
  //    trisurf(nodes,x,y,z)
  //    
  //    subplot(2,2,2)
  //    // On change la couleur
  //    trisurf(nodes,x,y,z,'color',3)
  //
  //    subplot(2,2,3)
  //    // On change les données, ce qui crée des couleurs spécifique
  //    value = [-1 0 1]
  //    trisurf(nodes,x,y,z,'value',value)
  //    
  //    subplot(2,2,4)
  //    // On change l'échelle, donc les couleurs
  //    trisurf(nodes,x,y,z,'value',value,'max',2)
  //
  // See also
  //  plot3d
  //  
  // Authors
  //  Pierre Payen (06/2016) ; 
  //

  mn = %inf;
  mx = -%inf;
  col = 2 // couleur par défaut
  value = ones(size(Nodes,1),1);
  //arguments optionnels : normalisation sur min max
  if argn(2)>5 then
    for i = 1:length(varargin)/2
      key = varargin(2*i-1)
      val = varargin(2*i)
      select key
      case 'value' then
        value = val
      case 'min' then
        mn = val
      case 'max' then
        mx = val
      case 'color' then
        col = val
      end
    end
  end
  mn = min(mn,min(value));
  mx = max(mx,max(value));

  xf = X(Nodes(1,:));
  yf = Y(Nodes(1,:));
  zf = Z(Nodes(1,:));

  for icell = 2:size(Nodes,1)
    xf = [ xf X(Nodes(icell,:)) ];
    yf = [ yf Y(Nodes(icell,:)) ];
    zf = [ zf Z(Nodes(icell,:)) ];
  end
  c = value
  ncol = 0 // nb valeurs/materiaux differents

  while length(c)>0
    c=c(c~=c(1))
    ncol = ncol + 1
  end

  if (ncol > 1) then
    C = round((ncol-1)*(value-mn)/(mx-mn))+1;
  else
    C = col.*ones(length(value),1) // couleur col partout
  end
  plot3d(xf,yf,list(zf,C))
endfunction
