function xstring3d(x,y,z,str,box,fill,fill_color,font_color,alignment)
  // Dessine des chaines de caractères
  // Calling Sequence
  // xstring3d(x,y,z,str)
  // xstring3d(x,y,z,str[,opt_args])
  // xstring3d(x,y,z[,box[,fill[,fill_color[text_color[,alignment]]]]])
  // Parameters
  // x,y,z : coordonnées du texte à afficher. Par défaut, c'est la position du coin inférieur gauche du texte.
  // str : chaine de caractères à afficher.
  // opt_args : argument optionnels par ensemble key=val, où key peut valoir box,fill,fill_color,alignment.
  // Description
  // Va dessiner en (x,y,z) le texte contenu dans str.
  // 
  // Description des arguments optionnels :
  // <itemizedlist>
  // <listitem><para> box = 'on','off' : trace un cadre authour du texte. </para></listitem>
  // <listitem><para> fill = 'on','off' : remplit le cadre si box ='on'</para></listitem>
  // <listitem><para> fill_color = n entier, n représente la couleur à afficher dans la colormap actuelle.</para></listitem>
  // <listitem><para> alignment = 'left','centered' : définit si le texte est placé relativement au coin inférieur gauche, ou alors au centre du point (x,y,z)</para></listitem>
  // </itemizedlist>
  //
  // Examples
  //  n=100
  //  x = rand(n,1);
  //  y = rand(n,1);
  //  z = rand(n,1);
  //  str = string(1:n');
  //  plot3d([0 1],[0 1],[0 1])
  // xstring3d(x,y,z,str)
  // xstring3d(0.5,0.5,0.5,'coucou',box='on',fill='on',alignment='centered')
  // See also
  // xstring
  //
  // Authors
  // Pierre Payen (08/2016)
  //
  

  xstring(x,y,str);
  
  if ~exists('box') then box = "off";end
  if ~exists('alignment') then alignment="off"; end
  if ~exists('fill') then fill="off"; end
  if ~exists('fill_color') then fill_color=-2; end
  if ~exists('font_color') then font_color=-1; end
  
  box=box+strsubst(string(ones(x)),'1','');
  alignment=alignment+strsubst(string(ones(x)),'1','');
  fill=fill+strsubst(string(ones(x)),'1','');
  fill_color=fill_color.*ones(x);
  font_color=font_color.*ones(x);
  
  a = gca()
  compound = a.children(1)
  n = size(compound.children,1)
  if n==0 then  n=1;  end;

  for i = 1:n
    if n == 1
      e = compound
    else
      e = compound.children(n-i+1); // 1er handle string : dernier de la liste str
    end
    e.data= [x(i) y(i) z(i)];
    e.box=box(i);
    e.fill_mode=fill(i);
    e.background=fill_color(i);
    e.text_box_mode=alignment(i);
    e.font_color=font_color(i);
    e.clip_state ='on'
  end
endfunction
