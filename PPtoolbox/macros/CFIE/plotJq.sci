function plotJq(obj,Jq,varargin)
  // Affiche les courants singuliers sur la surface de l'objet.
  //
  // Calling Sequence
  //   plotnormcourant(obj,Jq,[opt_args])
  //
  // Parameters
  // obj : structure msh (cf msh(), msh.sci ) définissant la surface de l'objet
  // Jq : vecteur réel (nelem x 1 )
  // opt_args : arguments optionnels par couple 'key',val
  //
  // Description
  // Affiche sur la surface de l'objet Jq, où Jq est un vecteur contenant par example la
  // norme des courants singuliers au barycentre de chaque maille.
  //
  // Description des arguments optionnels 'key',val
  // <itemizedlist>
  // <listitem><para> 'min' : normalise l'échelle de couleurs de val à max(Jq)</para></listitem>
  // <listitem><para> 'max' : normalise l'échelle de couleurs de min(Jq) à val</para></listitem>
  // <listitem><para> 'titre' : affiche un titre</para></listitem>
  // </itemizedlist>
  //
  // Examples
  // // obj et Jq ont été définis
  // plotnormcourant(obj,Jq);
  // plotnormcourant(obj,Jq,'min',min(Jq)-10,'max',max(Jq)+10,'titre','$J_0$');
  //
  // See also
  // plotVS
  //
  // Authors
  // Pierre PAYEN (07/2016)
  //

  mn = min(Jq)
  mx = max(Jq)
  if argn(2)>2 then
    for i = 1:length(varargin)/2
      key = varargin(2*i-1)
      val = varargin(2*i)
      select key
      case 'min' then
        mn = val
      case 'max' then
        mx = val
      case 'titre' then
        titre = val
      end
    end
  end

  iel = 1:size(Jq,1);

  //    if size(Jq,1)>100 then
  //        iel = floor(linspace(1,size(Jq,1),200));
  //    end

  X = 1/3*(obj.node.x(obj.face.node(iel,1)) + obj.node.x(obj.face.node(iel,2)) + obj.node.x(obj.face.node(iel,3)));
  Y = 1/3*(obj.node.y(obj.face.node(iel,1)) + obj.node.y(obj.face.node(iel,2)) + obj.node.y(obj.face.node(iel,3)));
  Z = 1/3*(obj.node.z(obj.face.node(iel,1)) + obj.node.z(obj.face.node(iel,2)) + obj.node.z(obj.face.node(iel,3)));

  set(gcf(),'color_map',jetcolormap(obj.nface));
  nJq = sqrt(sum(Jq.^2,2));
  Jq2 = obj.edge.mean*Jq./[ nJq nJq nJq ];
  champ3d(X,Y,Z,Jq2(iel,1),Jq2(iel,2),Jq2(iel,3));
  colorbar(min(nJq),max(nJq));
  colorbarlegend('norme L2 du courant')
  trisurf(obj.face.node,obj.node.x,obj.node.y,obj.node.z,'value',nJq)
  set(gce(),'color_mode',-2);
endfunction
