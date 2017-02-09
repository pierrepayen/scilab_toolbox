function plotcolorbar(mn,mx,varargin)
  // Dessin d'une colorbar sur la totalité de la figure.
  //
  // Calling Sequence
  //   plotcolorbar(mn,mx [,id])
  //
  // Parameters
  // mn: réel. Valeur minimale de la colorbar.
  // mx: réel. Valeur maximale de la colorbar.
  // id: entier. Identifiant de la figure de référence de la colorbar. Par défaut, la dernière figure.
  //
  // Description
  // plotcolorbar va tracer une grande colorbar à droite de la figure courante. Si id est fourni, alors la figure de référence est la id-eme.
  //
  // C'est notamment utile quand on veut une colorbar avec plusieurs subplots.
  //
  // Examples
  //  f=figure()
  //  f.color_map = jetcolormap(32);
  //  f.background=-2
  //  subplot(2,2,1)
  //  plot3d1();
  //  subplot(2,2,2)
  //  plot3d1();
  //  subplot(2,2,3)
  //  plot3d1();
  //  subplot(2,2,4)
  //  plot3d1();
  //  plotcolorbar(-1,1)
  //
  // See also
  //  colorbar
  //
  // Authors
  //  Pierre Payen (07/2016)

  if argn(2)>2
    id = varargin(1)
  else
    f = gcf()
    id = f.figure_id
  end

  f = scf(id)
  w = f.figure_size(1)
  h = f.figure_size(2)
  n = size(f.children,1)
  lastaxes = f.children(1).axes_bounds;

  colorbar(mn,mx)

  f.figure_size(1) = w + 100
  prop = 1 + 100/w
  f.figure_size(2) = h

  axes = f.children(2);
  axes.axes_bounds = lastaxes;
  axes.axes_bounds(3) = 1/prop*axes.axes_bounds(3)
  axes.axes_bounds(1) = 1/prop*axes.axes_bounds(1)

  for i = 3:n+1
    axes = f.children(i);
    axes.axes_bounds(3) = 1/prop*axes.axes_bounds(3)
    axes.axes_bounds(1) = 1/prop*axes.axes_bounds(1)
  end
  cb = f.children(1)
  cb.axes_bounds = [0.9 0.1 0.1 0.8]


endfunction
