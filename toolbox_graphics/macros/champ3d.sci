function h=champ3d(x,y,z,fx,fy,fz,varargin)
  // Graphes 3D d'un champ de vecteurs.
  //
  // Calling Sequence
  //   champ3d(x,y,z,fx,fy,fz [,opt_args])
  //   h = champ3d(x,y,z,fx,fy,fz [,'key1',val1][,'key2',val2],...)
  //   h = champ3d(x,y,z,fx,fy,fz,'prop',prop,'nface',nface,'sizefactor',sizefactor,'headcolor',headcolor,'bodycolor',bodycolor,'color_mode',color_mode)
  //   h = champ3d(x,y,z,fx,fy,fz,'headcolor',headcolor,'mode','fast')
  //
  // Parameters
  // h: handle. Coupound 3 x fac3d.
  // x,y,z: vecteurs taille npoints. Coordonnées cartésiennes des points initiaux.
  // fx,fy,fz: vecteurs taille npoints. Composantes cartésiennes des vecteurs.
  // opt_args : arguments optionnels par couple 'key',val 
  //
  // Description
  // champ3d dessine un champ de vecteur en 3D. La tête du vecteur est un polygone régulier 3D et la taille du vecteur est proportionnel à sa norme. Si vous désirez des vecteurs colorés, voir champ3d1. Si le nombre de vecteurs est supérieur à 1000, l'option 'mode','fast' est recommandée.
  // 
  // <itemizedlist>
  // <listitem><para>key = 'prop' : val est un réel entre 0 et 1. Represente la proportion corps/taille totale. 0 pour afficher des cônes, 1 pour des segments de droite. Par défaut, 0.7</para></listitem>
  // <listitem><para>key = 'nface' : val est un entier positif. La tête de fleche est un polyhêdre régulier à nface face Par default, 5.</para></listitem>
  // <listitem><para>key = 'sizefactor' : val est un réel. Permet d'agrandir la taille des vecteurs par rapport à leur taille par default. Par default, 1</para></listitem>
  // <listitem><para>key = 'headcolor' : val est un entier. Permet de définir la couleur de la tête des vecteurs. Par default, -1 (noir).</para></listitem>
  // <listitem><para>key = 'bodycolor' : val est un entier. Permet de définir la couleur du corps des vecteurs. Par default, -1 (noir).</para></listitem>
  // <listitem><para>key = 'mode' : val chaine de caractère. Si val = 'fast', alors les fleches sont des objets 2D (xarrows). Beaucoup plus rapide, mais il n'y plus de profondeur, les têtes de fleches étant toujours plates quelque soit l'orientation. Les options nface,prop,sizefactor et bodycolor sont inutile avec ce mode.</para></listitem>
  // <listitem><para>key = 'color_mode' : val est un entier. Modifie la propriété 'color_mode' de l'entité graphique. Si color_mode = 2, les arêtes sont dessinées. Par défaut, -2</para></listitem>
  // </itemizedlist>
  //
  // <warning>champ3d nécessite trisurf.sci et ortogonalvectors.sci</warning>
  //
  // En mode normal, un vecteur est un ensemble d'objets fac3d : les pointes (cône maillé avec nface triangles), les corps (cylindre maillé avec comme base des polygones réguliers à nface cotés) et les bases (cones et cylindre), polygones à nface cotés. En mode fast, un vecteur est un objet champ, avec une tête (un triangle) et un corps (un trait).
  //
  // Examples
  //      xdel(winsid())
  //      n = 10
  //      x = rand(n,1,'normal');
  //      y = rand(n,1,'normal');
  //      z = rand(n,1,'normal');
  //      fx = sign(x).*x.*x;
  //      fy = sign(y).*y.*y;
  //      fz = sign(z).*z.*z;
  //      champ3d(x,y,z,fx,fy,fz);
  //
  //    // Même données, mais vecteurs dont la tête fait 50% du corps,
  //    // est un tetrahedre à 3 côtés et de couleur bleu avec le corp en rouge et 2 fois plus petit.
  //    champ3d(x,y,z,fx,fy,fz,'headcolor',color('blue'),'bodycolor',color('red'),'prop',0.5,'nface',3,'sizefactor',0.5)
  //
  // See also
  //  champ3d1
  //  x_arrows
  //  champ
  //  champ1
  //
  // Authors
  //  Pierre Payen (07/2016) 
  //
  col=addcolor([0,0,0]);
  prop = 0.7;
  nface = 7;
  headcolor = col;
  bodycolor = col;
  sizefactor = 1;
  sizemax = 0;
  sizemin = 0;
  color_mode = -2;
  fastmode = 0;
  if argn(2)>6 then
    for i = 1:length(varargin)/2
      key = varargin(2*i-1)
      val = varargin(2*i)
      select key
      case 'prop' then
        prop = max(0,min(1,val));
      case 'nface' then
        nface = max(3,floor(val));
      case 'headcolor' then
        headcolor = val;
      case 'sizefactor' then
        sizefactor = val;
      case 'sizemax' then
        sizemax = val;
      case 'sizemin' then
        sizemin = val;
      case 'bodycolor' then
        bodycolor = val;
      case 'color_mode' then
        color_mode = val;
      case 'mode' then
        fastmode = 1
      end
    end
  end

  if fastmode then
    nx = [x';x'+sizefactor*fx'];
    ny = [y';y'+sizefactor*fy'];
    nz = [z';z'+sizefactor*fz'];
    xarrows(nx,ny,nz,-1,headcolor);
    set(gca(),'axes_visible','on');
    set(gca(),'box','hidden_axes');
    set(gca(),'hidden_axis_color',4);
    set(gce(),'clip_state','on');
    return  // <------------------------------------------------- return ici
  end

  nvect = length(x);
  X = matrix(x,nvect,1); // vecteur colonne
  Y = matrix(y,nvect,1);
  Z = matrix(z,nvect,1);
  FX = matrix(fx,nvect,1);
  FY = matrix(fy,nvect,1);
  FZ = matrix(fz,nvect,1);

  p = [X Y Z];
  v = [FX FY FZ];
  
  nv = sqrt(sum(v.^2,2))+%eps/2;
  v = v ./ [nv nv nv];
  nv = sizefactor*nv
  
  if ~sizemin then
    sizemin = min(nv);
  end
  if ~sizemax then
    sizemax = max(nv);
  end
  
  nv = (sizemax - sizemin)*(nv-min(nv))/(max(nv)-min(nv)+%eps/2)+sizemin

  v = [nv nv nv].*v;
  [v1,v2] = orthogonalvectors(v,normalized=1);
  
  tbase = (1-prop)/3 .*ones(v);
  
  n = (0:nface-1);
  xb = matrix(meshgrid(p,n),nface*nvect,3);
  vb = matrix(meshgrid(v,n),nface*nvect,3);
  vb1 = matrix(meshgrid(v1,n),nface*nvect,3);
  vb2 = matrix(meshgrid(v2,n),nface*nvect,3);
  
  tbaseb = matrix(meshgrid(tbase,n),nface*nvect,3);
  indb = matrix(meshgrid(nv,n),nface*nvect,1);

  last = matrix(meshgrid([3*nvect*nface+(1:nvect)]',n),nface*nvect,1);

  cs = meshgrid(cos(n*2*%pi/nface),1:nvect);
  sn = meshgrid(sin(n*2*%pi/nface),1:nvect);

  cb = meshgrid(matrix(cs',nvect*nface,1),1:3)';
  sb = meshgrid(matrix(sn',nvect*nface,1),1:3)';

  xb1 = xb+tbaseb.*(cb.*vb1+sb.*vb2);
  xb2 = xb+prop*vb+tbaseb.*(cb.*vb1+sb.*vb2);
  xb3 = xb+prop*vb+2*tbaseb.*(cb.*vb1+sb.*vb2);
  xx = [xb1;xb2;xb3;p+v];

  nodesbase = 1:3*nface*nvect;
  nodesbase = matrix(nodesbase,nface,3*nvect)';
  nodesbase(nvect+1:2*nvect,1:$)=nodesbase(nvect+1:2*nvect,$:-1:1);
  indbase = matrix([indb; indb; indb ],nface,3*nvect)';
  trisurf(nodesbase,xx(:,1),xx(:,2),xx(:,3),'color',bodycolor);
  e1 = gce();
  e1.hiddencolor=bodycolor;

  nodesbody = [1:nface*nvect;
  nvect*nface+1:2*nvect*nface;
  [nvect*nface+2:2*nvect*nface,nvect*nface+1];
  [2:nface*nvect,1]]

  swap = nface:nface:nvect*nface;
  nodesbody(3,swap)=nodesbody(3,[swap($) swap(1:$-1)]);
  nodesbody(4,swap)=nodesbody(4,[swap($) swap(1:$-1)]);
  trisurf(nodesbody',xx(:,1),xx(:,2),xx(:,3),'color',bodycolor);
  e2 = gce();
  e2.hiddencolor=bodycolor;
  e2.color_mode=color_mode;

  nodeshead = [2*nvect*nface+1:3*nvect*nface;
  last'; // points p+v
  [2*nvect*nface+2:3*nvect*nface,2*nvect*nface+1]];

  nodeshead(3,swap)=nodeshead(3,[swap($) swap(1:$-1)]);
  trisurf(nodeshead',xx(:,1),xx(:,2),xx(:,3),'color',headcolor);
  e3 = gce();
  e3.hiddencolor=headcolor
  e3.color_mode=color_mode
  h=glue([e1,e2,e3])
  
  champ3dparam.nvect = size(x,1);
  champ3dparam.nface = nface;
  champ3dparam.prop = prop;
  champ3dparam.sizefactor = sizefactor;
  champ3dparam.sizemax = sizemax;
  champ3dparam.sizemin = sizemin;
  
  set(h,'user_data',champ3dparam);
  set(gca(),'box','hidden_axes');
  set(gca(),'hidden_axis_color',-1);
endfunction
