function shading(shading_mode,handle,verbose)
  // shading de Matlab.
  // Calling Sequence
  //    shading shading_mode
  //    shading(shading_mode[,handle][,verbose])
  // Parameters
  // shading_mode :chaine de caractères. 'zheight','interp','flat','flat_Matlab'
  // (optionnel) handle : handle depuis lequel changer le shading (récursif sur ses children). [Par défaut, gcf()];
  // Description
  // Si aucun aurgument n'est passé, ne fait rien.
  // Choix pour shading_mode 
  // <itemizedlist>
  // <listitem><para>'zheight', les couleurs seront proportionneles à la hauteur des points.</para></listitem>
  // <listitem><para>         ' interp', les couleurs sont interpolés pour un rendus plus lisse.</para></listitem>
  // <listitem><para>         ' flat', il n'y a qu'une couleur par element.</para></listitem>
  // </itemizedlist>
  // <warning> Cette fonction ne produit l'effet désiré que sur des objets fac3d ! </warning>
  // Examples
  // figure()
  // Authors
  //  Pierre Payen (06/2016) ; 
  //
  if ~exists('shading_mode') then  shading_mode = 'none'; end;
  if ~exists('handle')       then  handle = gcf();        end;
  if ~exists('verbose')      then  verbose = %f;          end;
  
  select shading_mode
  case 'zheight';
    color_flag = 1
  case 'flat' then
    color_flag = 2
  case 'interp' then
    color_flag = 3
  case 'flat_matlab' then
    color_flag = 4
  else
    color_flag = 0
  end
  
  function goDeeper(handle)
    try
      assert_checkequal(get(handle,'type'),'Fac3d');    
      if shading_mode == 'interp' then // cas où on interpole
        data = get(handle,'data');
        if length(data.color)<>length(data.x) then // cas où color de fac3d uniquement sur face
          elem = 1:size(data.x,2);
          elem = repmat(elem,size(data.x,1),1);
          elem = matrix(elem,length(data.x),1);
          loc = [1:size(data.x,1)]';
          loc = repmat(loc,1,size(data.x,2));
          loc = matrix(loc,length(data.x),1);
          x = matrix(data.x,length(data.x),1);
          y = matrix(data.y,length(data.y),1);
          z = matrix(data.z,length(data.z),1);
          all = [x y z elem loc];
          all = sortrows(all);
          node = all(:,1:3);
          node2 = node;
          fac = all(:,4:5);
          fac2 = fac;
          while size(node2,1)>0 then
            ind = vectorfind(node,node2(1,:));
            node2 = node(max(ind)+1:$,:);
            k = size(data.x,1)*(fac(ind,1)-1)+fac(ind,2);
            c(k) = mean(data.color(fac(ind,1)));
//            pause
        end
          handle.user_data=list('old data.color [shading]',handle.data.color)
          c = matrix(round(c),size(data.x,1),size(data.x,2));
          handle.data.color(1:size(data.x,1),1:size(data.x,2)) = c(1:size(data.x,1),1:size(data.x,2));
        end
      end
      set(handle,'color_flag',color_flag);      
    catch
      if verbose then
        mprintf('ERROR:shading(''%s''). %s (%s)\n',shading_mode,lasterror(),handle.type);
      end
    end
    
    a=handle.children
    for i = 1:size(a,1);
      goDeeper(handle.children(i));
    end
  endfunction
  
  goDeeper(handle);

endfunction
