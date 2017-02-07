function e3=vectprod(e1,e2)
  // Calcule le produit vectoriel de 2 vecteurs.
  // Calling Sequence
  // e3=vectprod(e1,e2)
  // Parameters
  // e1,e2,e3 : matrices n x 3
  //
  if size(e1,2)*size(e2,2)<>9 then 
    mprintf('vectprod: Wrong input dimensions. Matrix of size (*,3) expected\n');
    abort
  end
  e3(:,1) = e1(:,2).*e2(:,3) - e1(:,3).*e2(:,2);
  e3(:,2) = e1(:,3).*e2(:,1) - e1(:,1).*e2(:,3);
  e3(:,3) = e1(:,1).*e2(:,2) - e1(:,2).*e2(:,1);
endfunction
