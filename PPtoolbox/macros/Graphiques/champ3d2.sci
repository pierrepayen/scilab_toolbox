function h=champ3d2(x,y,z,fx,fy,fz,varargin)
  // Graphes 3D d'un champ de vecteurs.
  //
  // Calling Sequence
  //   champ3d2(x,y,z,fx,fy,fz [,opt_args])
  //   h = champ3d2(x,y,z,fx,fy,fz [,'key1',val1][,'key2',val2],...)
  //   h = champ3d2(x,y,z,fx,fy,fz,'prop',prop,'nface',nface,'sizefactor',sizefactor,'headcolor',headcolor,'bodycolor',bodycolor,'color_mode',color_mode)
  //   h = champ3d2(x,y,z,fx,fy,fz,'headcolor',headcolor,'mode','fast')
  //
  // Parameters
  // h: handle. Fac3d.
  // x,y,z: vecteurs taille npoints. Coordonnées cartésiennes des points initiaux.
  // fx,fy,fz: vecteurs taille npoints. Composantes cartésiennes des vecteurs.
  // opt_args : arguments optionnels par couple 'key',val 
  //
  // Description
  // champ3d2 dessine un champ de vecteur en 3D. Le vecteur est un polygone maillé en triangle et la taille du vecteur est proportionnel à sa norme. Si vous désirez des vecteurs colorés, voir champ3d1. Si le nombre de vecteurs est supérieur à 1000, l'option 'mode','fast' est recommandée.
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
  // <warning>champ3d2 nécessite trisurf.sci et ortogonalvectors.sci</warning>
  //
  // En mode normal, un vecteur est un objet fac3d possédant npoints=3*nface+2 où nface est le nombre d'arete sur la base du vecteur.
  //
  // Examples
  // xdel(winsid())
  //    n = 100
  //    x = rand(n,1,'normal');
  //    y = rand(n,1,'normal');
  //    z = rand(n,1,'normal');
  //    fx = sign(x).*x.*x;
  //    fy = sign(y).*y.*y;
  //    fz = sign(z).*z.*z;
  //    champ3d2(x,y,z,fx,fy,fz);
  //
  //    // Même données, mais vecteurs dont la tête fait 50% du corps,
  //    // est un tetrahedre à 3 côtés et de couleur bleu avec le corp en rouge et 2 fois plus petit.
  //    champ3d2(x,y,z,fx,fy,fz,'headcolor',color('blue'),'bodycolor',color('red'),'prop',0.5,'nface',3,'sizefactor',0.5)
  //
  // See also
  //  champ3d21
  //  x_arrows
  //  champ3d
  //  champ3d1
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
  npoints = 3*nface + 2 ;
  nn = 1:npoints
  xb = matrix(meshgrid(p,nn),npoints*nvect,3);
  vb = matrix(meshgrid(v,nn),npoints*nvect,3);

  tbaseb = matrix(meshgrid(tbase,nn),npoints*nvect,3);

  vb1 = matrix(meshgrid(v1,nn),npoints*nvect,3);
  vb2 = matrix(meshgrid(v2,nn),npoints*nvect,3);

  pstart = 1:npoints:(1+npoints*(nvect-1));
  pend = npoints:npoints:npoints*nvect;
  pall = [pstart, pend];
  pmid = 2+nface*2:1:npoints-1;
  pmid = repmat(pmid,1,nvect);
  ind=(0:nvect-1)*npoints;
  indb=matrix(repmat(ind,nface,1),nface*nvect,1)';
  pmid = pmid + indb;

  tbaseb(pall,:) = repmat([0 0 0],2*nvect,1);
  tbaseb(pmid,:) = 2*tbaseb(pmid,:);

  vb1(pall,:) = repmat([0 0 0],2*nvect,1); 
  vb2(pall,:) = repmat([0 0 0],2*nvect,1); 

  cb = repmat([0 repmat(cos(n*2*%pi/nface),1,3) 0]',nvect,3);
  sb = repmat([0 repmat(sin(n*2*%pi/nface),1,3) 0]',nvect,3);

  vprop = repmat([0 zeros(1,nface) prop*ones(1,2*nface) 1]',nvect,3);

  xx = xb+vprop.*vb+tbaseb.*(cb.*vb1+sb.*vb2);

  base = [ones(1,nface);2:nface+1;[3:nface+1,2]]';
  body1 = [2:nface+1;2+nface:2*nface+1;[3:nface+1,2]]';
  body2 = [nface+2:2*nface+1;[nface+3:2*nface+1,nface+2];[3:nface+1,2]]';
  head1 = [nface+2:2*nface+1;2*nface+2:3*nface+1;[2*nface+3:3*nface+1,2*nface+2]]'
  head2 = [nface+2:2*nface+1;[2*nface+3:3*nface+1,2*nface+2];[nface+3:2*nface+1,nface+2]]';
  head3 = [(3*nface+2)*ones(1,nface);[2*nface+3:3*nface+1,2*nface+2];[2*nface+2:3*nface+1]]';
  nodes = [base;body1;body2;head1;head2;head3];

  bodycol = bodycolor*ones(3*nface,1);
  headcol = headcolor*ones(3*nface,1);
  col = repmat([bodycol;headcol],nvect,1);

  nodesb = repmat(nodes,nvect,1);
  indb = repmat(matrix(repmat(ind,6*nface,1),6*nface*nvect,1),1,3);
  nodesb = nodesb + indb
  trisurf(nodesb,xx(:,1),xx(:,2),xx(:,3),'color',col);
  h=gce();
  set(h,'color_mode',color_mode);
  set(h,'hiddencolor',-1);
  champ3dparam.nvect = nvect;
  champ3dparam.nface = nface;
  set(h,'user_data',champ3dparam);
endfunction
