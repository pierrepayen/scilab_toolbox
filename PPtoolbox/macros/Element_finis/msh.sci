function mshS=msh()
  // Structure de gestion de maillage type Pierre PAYEN
  //
  // Calling Sequence
  // mshS = msh()
  //
  // Parameters 
  // mshS : structure à 4 champs de type 'fonction' scilab.
  //
  // Description
  // Cette fonction renvoie une structure de gestion de maillage
  // Les champs de cette structure sont des fonctions:
  // <itemizedlist>
  // <listitem><para> mshS.init() : Initialise une structure contenant la géometrie d'un maillage vide.</para></listitem>
  // <listitem><para> obj = mshS.read(fic_mail) : Prend en argument un fichier .maila et lit les coordonnées des noeuds et les connectivités éléments-noeuds et renvoie la structure mise à jour.</para></listitem>
  // <listitem><para> obj = mshS.more(obj) : Après read, calcule les connectivités éléments-arêtes , arêtes-noeuds et renvoie la structure mise à jour. Peut être long (30s pour 10 000 élements).</para></listitem>
  // <listitem><para> mshS.plot(obj[,mode[,ind]]) : Affiche le maillage. mode = 'mesh','node','edge','face','all'; permet d'afficher les indices des noeuds,arêtes et/ou éléments, vaut par defaut 'mesh' (objet seul), L'objet est alors affiché en fil de fer pour plus de lisibilité. ind renseigne les indices particulier à afficher.</para></listitem>
  // </itemizedlist>
  //
  // <important> Pour bien fonctionner, msh.sci nécessite Matlab_emulationlib (Pierre Payen) : appel à sort, trisurf etc ...</important>
  //
  // Description des champs de  la structure du maillage en lui même:
  //  <itemizedlist>
  //  <listitem><para> obj.loaded : chaine de caractères; information du degré de chargement du maillage.</para></listitem>
  //  <listitem><para> obj.name : chaine de caractères; nom du maillage.</para></listitem>
  //  <listitem><para> obj.nnode : entier; nombre de noeuds.</para></listitem>
  //  <listitem><para> obj.nface : entier; nombre d'éléments.</para></listitem>
  //  <listitem><para> obj.nnedge : entier; nombre d'arêtes.</para></listitem>
  //  <listitem><para> obj.node : structure à 3 champs; coordonnées des noeuds</para></listitem>
  // <itemizedlist>
  // <listitem><para> obj.node.x : vecteur ( nnode x 1 ); 1er coordonnées des noeuds</para></listitem>
  // <listitem><para> obj.node.y : vecteur ( nnode x 1 ); 2eme coordonnées des noeuds</para></listitem>
  // <listitem><para> obj.node.z : vecteur ( nnode x 1 ); 3eme coordonnées des noeuds</para></listitem>
  // </itemizedlist>
  //  <listitem><para> obj.face : structure à 3 champs; indices des noeuds (face.node) et des aretes(face.edge) composant les éléments,  et le type (face.type) relatif de matériau de l'élement</para></listitem>
  // <itemizedlist>
  // <listitem><para> obj.face.node : vecteur ( nface x 3 ); indices globaux des noeuds locaux aux éléments.</para></listitem>
  // <listitem><para> obj.face.edge : vecteur ( nface x 3 ); indices globaux des arêtes locales aux éléments.</para></listitem>
  // <listitem><para> obj.face.type : vecteur ( nface x 1 ); indices des numéros de matériaux.</para></listitem>
  // </itemizedlist>
  //  <listitem><para> obj.edge : structure à 4 champs; indices des noeuds (edge.node) et des éléments(edge.face) composant les arêtes. Longueurs des artes (edge.len) et l'arêtes maximale (edge.max )</para></listitem>
  // <itemizedlist>
  // <listitem><para> obj.edge.node : vecteur ( nedge x 2 ); indices globaux des noeuds locaux aux arêtes.</para></listitem>
  // <listitem><para> obj.edge.face : vecteur ( nedge x 3 ); indices globaux des éléments locaux aux arêtes.</para></listitem>
  // <listitem><para> obj.face.len : vecteur ( nedge x 1 ); longueurs des arêtes.</para></listitem>
  // <listitem><para> obj.face.mean : réel; longueur moyenne.</para></listitem>
  // </itemizedlist>
  // <listitem><para> obj.sphere: structure optionnelle; Contient position et rayon de la shere englobante. Voir spheremin() </para></listitem>
  // </itemizedlist>
  //
  // Examples
  // fic_mail = uigetfile('*.maila','.');
  // mshS = msh() ; // initialisation de la structure de gestion
  // obj = mshS.init(); // initialisation de la structure de maillage
  // obj = mshS.read(fic_mail); // lit fic_mail et renvoie le maillage
  // obj = mshS.more(obj); // analyse le maillage et renvoie un maillage avec plus d'information
  // nom = obj.name // nom du maillage
  // X = obj.node.x // coordonnées X des noeuds
  // EX1 = obj.node.x(obj.face.node(1,:)) // composante X du 1er noeud de tous les éléments
  // EA10 = obj.face.edge(10,:) // numéros globaux des arêtes de l'élément 10
  // AE10 = obj.edge.face(10,:) // numéros globaux des éléments de l'arête 10
  // figure(1)
  // subplot(2,1,1)
  // mshS.plot(obj)
  // subplot(2,1,2)
  // mshS.plot(obj,'edge',1:10:obj.nedge)
  // See also
  // spheremin
  // trisurf
  //
  // Authors
  // Pierre PAYEN (08/2016)

  mshS = struct()
  mshS.init = msh_init
  mshS.read = msh_read
  mshS.more = msh_more
  mshS.plot = msh_plot
endfunction

function mail = msh_init()
  mail.loaded = '__INIT__';  // si le maillage a été chargé avec msh_read
  mail.name   = '__NONAME__'; //nom du maillage
  mail.nnode   = 0; // nombre de noeuds
  mail.nface   = 0; // nombre d'éléments
  mail.node   = struct(); // structure d'informatiion sur les noeuds. voir msh_read
  mail.face   = struct(); // structure d'informatiion sur les éléments. voir msh_read
  mail.edge   = struct(); // structure d'informatiion sur les arêtes. voir msh_read
  mail.sphere = struct();  // rayon de la sphère minimal englobant le maillage. voir spheremin.sci
endfunction

function mail = msh_read(fic)
  // msh_read(fic) lit fic et extrait un minimum d'information sur les noeuds
  // les arêtes et les elements. voir msh_more() pour extraire un maximum d'info
  // fic     : nom du fichier

  fid = mopen(fic,'r');

  data = mfscanf(fid,'%s %d %d ');
  name = data(1);  mprintf('... Nom : %s\n',name);
  npts = data(2);  mprintf('... Nombre de noeuds : %d\n',npts);
  nelt = data(3);  mprintf('... Nombre d''éléments : %d\n',nelt);

  nodexyz = mfscanf(npts,fid,'%g %g %g %g ');
  x=nodexyz(:,2);
  y=nodexyz(:,3);
  z=nodexyz(:,4);

  ztab = mfscanf(nelt,fid,'%d %d %d %d %d');

  type_elem = ztab(:,2);

  // obtention des noeuds pour chaque élement
  elt(:,1)=ztab(:,3);
  elt(:,2)=ztab(:,4); // intervertion pour orientation anti-horaire pour affichage
  elt(:,3)=ztab(:,5); // dans scilab

  facenode = elt

  mclose(fid);

  face.node = facenode;
  face.type = type_elem;

  node.x = x;
  node.y = y;
  node.z = z;

  mail.name   = name;
  mail.nnode  = npts;
  mail.nface  = nelt;
  mail.face   = face;
  mail.node   = node;
  mail.loaded = '__LOADED__';
endfunction

function obj=msh_more(obj,verbose)
  if (argn(2)==2 & verbose=='verbose') then
    verbose = 1
  else
    verbose = 0
  end
  if obj.loaded ~= '__LOADED__' then // si rien n'est chargé ('__INIT__') ou aretes déjà calculées ('__FULL__')
    return
  end
  mprintf('... Calcul d''informations supplémentaires sur le maillage ...\n')
  nelt = obj.nface

  elt = obj.face.node
  elt(:,2)=obj.face.node(:,3); // CONVENTION : intervertion pour orientation horaire (normale intérieur)
  elt(:,3)=obj.face.node(:,2);
  x = obj.node.x
  y = obj.node.y
  z = obj.node.z
  // obtention des arêtes pour chaque element
  ar1 = [elt(:,1)  elt(:,2)] // 1ere arete
  ar2 = [elt(:,2)  elt(:,3)] // 2eme arete
  ar3 = [elt(:,3)  elt(:,1)] // 3eme arete

  ar = [ar1 ar2 ar3]

  mprintf('... Recherche des noeuds par arête, arêtes par élément, élements par arête ... ')
  // tableau 3*Nelt x 2, avec les 3 arêtes de l'élément 1 puis les 3aretes de
  // l'élément 2 etc
  ark = matrix(ar',2,3*nelt)'
  // edgenode : obtention des arêtes en fonction des noeuds.
  edgenode = ark(1,:) //ajout de la 1er arête a la liste
  // faceedge : pour un élément, identifie ses 3 arêtes
  faceedge=[1]; //ajout de la 1ere arête
  // edgeface: pour une arête, identifie les 2 élements adjacents ! arêtes sont orientés : edge.face(i,1) est l'élément à gauche de l'arete parcourus de edge.node(i,1) à edge.node(i,2). Par corrolaire, edge.face(i,2) est l'élément à gauche de l'artes edge.node(i,2) à edge.node(i,1)
  edgeface = [1]; // ajout du 1er élément
  //  if verbose then
  //     winH = waitbar(0,'Maillage : calcul des arêtes ... ');
  //  end
  M = size(ark,1)
  // on crée un matrice d'adjacence creuse car on ne peut stocker zeros(n,n) si n > 3000
  A = sparse([min(ark(1,:)) max(ark(1,:))],[1],[M,M]) // Contrepartie : perte de performance sur recherche d'arete.
  //  pause
  k=2
  for i = 2:M
    if verbose then
      //waitbar(i/M,winH);
      mprintf('\r... Recherche des noeuds par arête, arêtes par élément, élements par arête ... [ %6.3f %% ]',100*i/M)
    end
    art = ark(i,:)                    // dans la grande liste des arêtes par élément on cherche [i j] et [j i]
    ind = full(A(min(art),max(art))); // on cherche (min(i j),max(i j))

    if ind == 0 then // si elle est nouvelle
      [ij,v,mn] = spget(A);          // on récupère la liste des indices non nuls et leur valeurs
      ij = [ij;[min(art) max(art)]]; // on ajoute l'arete, sachant que A est triangulaire
      v = [v;k];                     // dans la matrice d'adjacence
      A = sparse(ij,v,mn);           // nouvelle matrice d'adjacence
      edgenode = [edgenode ; art]    // on l'ajoute dans la liste des aretes uniques (orientées !)
      faceedge=[faceedge k] // on ajoute à cet élément l'arete
      iloc = modulo(length(faceedge),3);
      iloc = iloc + 3*(iloc==0);
      edgeface(k,iloc) = ceil(i/3)    // puisqu'on a parcouru les aretes dans la grande liste qui découle des éléments, on connait l'élément associé à l'arete qu'on ajoute
      k = k+1         // nombre d'aretes unique
    else
      //      if ind==1 then pause;end;
      faceedge=[faceedge -ind] // on ajoute à cet élément
      iloc = modulo(length(faceedge),3);
      iloc = iloc + 3*(iloc==0);
      edgeface(ind,iloc) = -ceil(i/3) // si on la connait, alors c'est qu'on est sur l'autre élément
    end
  end

  faceedge = matrix(faceedge,3,nelt)'

  nedge = size(edgenode,1)
  mprintf('\r... Recherche des noeuds par arête, arêtes par élément, élements par arête ... FAIT\n')

  edge.x = x(edgenode(:,2)) - x(edgenode(:,1));
  edge.y = y(edgenode(:,2)) - y(edgenode(:,1));
  edge.z = z(edgenode(:,2)) - z(edgenode(:,1));
  Xar = [edge.x, edge.y ,edge.z];

  lar = sum(Xar.^2,2);
  h = mean(sqrt(lar)); // arête de longueur moyenne

  mprintf('... Nombre d''arêtes : %d\n',nedge)
  
  face = obj.face;
  face.edge = faceedge;

  edge.node = edgenode;
  edge.face = edgeface;
  edge.mean = h;

  obj.nedge  = nedge;
  obj.face   = face;
  obj.edge   = edge;
  obj.loaded = '__FULL__'
endfunction

function msh_plot(obj,info,ind)
  if ~exists('info') then info = 'mesh'; end;
  if ~exists('ind') then ind=-1; end;
  elt = obj.face.node;
  x = obj.node.x;
  y = obj.node.y;
  z = obj.node.z;
  col = obj.face.type;

  trisurf(elt,x,y,z,col)
  set(gce(),'color_mode',0) // plus de surface

  select info
  case 'all' then
    msh_plot(obj,'node')
    msh_plot(obj,'face')
    msh_plot(obj,'edge')  
  case 'mesh' then
    set(gce(),'color_mode',2) // surface
  case 'node' then
    if ind==-1 then ind = 1:obj.nnode'; end;
    xstring3d(x(ind),y(ind),z(ind),string(ind),box='on',fill='on',alignment='centered')
    
  case 'face' then
    if ind==-1 then ind = 1:obj.nface'; end;
      X = mean([x(elt(ind,1)) x(elt(ind,2)) x(elt(ind,3))],2);
      Y = mean([y(elt(ind,1)) y(elt(ind,2)) y(elt(ind,3))],2);
      Z = mean([z(elt(ind,1)) z(elt(ind,2)) z(elt(ind,3))],2);
      cm = gcf();
      cm = cm.color_map
      font_color = round(mean(cm(col,:),2))-2
      xstring3d(X,Y,Z,string(ind),box='on',fill='on',fill_color=col,font_color=font_color,alignment='centered')
    
  case 'edge' then
    if obj.loaded=='__FULL__'
      edge = obj.edge.node
      if ind==-1 then ind = 1:obj.nedge'; end;
      X = mean([x(edge(ind,1)) x(edge(ind,2))],2);
      Y = mean([y(edge(ind,1)) y(edge(ind,2))],2);
      Z = mean([z(edge(ind,1)) z(edge(ind,2))],2);
      xstring3d(X,Y,Z,string(ind),box='on',fill='on',fill_color=-1,font_color=-2,alignment='centered')
    end
  end
endfunction
