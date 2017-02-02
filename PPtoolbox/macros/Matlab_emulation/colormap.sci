function colormap(arg,varargin)
// colormap de Matlab
//
// Calling Sequence
//   colormap(arg[ ,opt_arg])
//
// Parameters
// arg: (chaine de caractère) Type de la colormap : 'jet','hot','cool','gray','autumn'.
// opt_arg : n (entier) Nombre de couleurs. Par défaut, 32.  
//
// Description
// Selon arg, va choisir une colormap sur 32 couleurs, sauf si n est fourni, auquel cas, la colormap utilisera n nuances de couleurs. Choix pour arg = 'jet','hot','cool','gray','autumn'. Si arg est different de ces valeurs, la colormap par defaut est utilisée
//
// Examples
// plot3d()
// colormap('hot') 
//
// See also
//  gcf
// jetcolormap
// hotcolormap
//
// Authors
//  Pierre Payen (06/2016) 

  if argn(2)>1 then
    n = varargin(1);
  else
    n = 32;
  end
  select arg
   case 'jet' then
      set(gcf(),'color_map',jetcolormap(n));
    case 'hot' then
      set(gcf(),'color_map',hotcolormap(n));
    case 'cool' then
      set(gcf(),'color_map',coolcolormap(n));
    case 'gray' then
      set(gcf(),'color_map',graycolormap(n));
    case 'autumn' then
      set(gcf(),'color_map',autumncolormap(n));
    else
      set(gcf(),'color_map',get(sdf(),"color_map"));
  end
endfunction
