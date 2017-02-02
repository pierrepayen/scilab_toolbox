function [out,k]=sort(in,varargin)
// sort à la Matlab.
//
// Calling Sequence
//    [Y[,k]] = sort(X[,opt_args])
//
// Parameters
// X,Y : vecteur ou matrice reel
//   k : vecteur/matrice des indices initiaux avant le tri, respectivement
//       à chaque colonne: si vecteur X(k)=Y, si matrice X(k(:,i),:)=Y(:,i)
//opt_arg : entier optionnels
//
// Description
// Si X est un vecteur, renvoie dans Y le tri croissant de X et dans k
//   les indices initiaux. Si X est une matrice,renvoie la matrice X dont chaque
//   colonne est triée dans l'ordre croissant independemment des autres.
//   si dir = 1, identique à sort(X). Si dir = 2, le tri est effectué sur les lignes
//
// Examples
// X = rand(10,1)
// Y = sort(X)
// A = rand(10,10)
// [B,k] = sort(A)
// C = sort(A,1)
// D = sort(A,2)
//
// See also
//  sortrows
//  gsort
// 
// Authors
//  Pierre Payen (06/2016) ; 
//

  if argn(2)==1 then
    if (size(in,1)==1 | size(in,2)==1) then //vector
      [out,k]=gsort(in,'g','i');
    else  //matrix
      [out,k]=gsort(in,'r','i');
    end
  else
    select varargin(1)
    case 1 then
      [out,k] = gsort(in,'r','i');
    case 2 then
      [out,k] = gsort(in,'c','i');
    end
  end
endfunction
