function plotnormcourant(obj,Jq,varargin)
// Affiche les courants singulier sur la surface de l'objet.
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
      titre = '$||J_q||$'
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
        else
          disp('plotnormcourant: arg opt '+key+' non compris')
          abort
        end
      end
    end
  set(gcf(),'color_map',jetcolormap(obj.nface))
  trisurf(obj.face.node,obj.node.x,obj.node.y,obj.node.z,'value',Jq,'min',mn,'max',mx)
  title(titre,'fontsize',3)
endfunction