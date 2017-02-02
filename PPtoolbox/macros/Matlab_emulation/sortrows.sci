function [out,k]=sortrows(in)
// sortrows de Matlab.
//
// Calling Sequence
//    [B[,k]] = sortrows(A)
//
// Parameters
// A,B : matrices reelles
//   k : vecteur/matrice des indices initiaux avant le tri, respectivement
//       à chaque colonne: si vecteur X(k)=Y, si matrice A(k(:,i),:)=B(:,i)
//
// Description
// SORTROWS va trier lexicographiquement la matrice par colonne.
// cela revient à permuter les lignes de tel sorte que B(i+1,1) >= B(i,1)
//
// Examples
// A = rand(3,3)
// B = sortrows(A)
// [B,k] = sortrows(A)
//
//
// See also
//  gsort
//  sort
//  
// Authors
//  Pierre Payen (06/2016) ; 
//


  [out,k]=gsort(in,'lr','i');
endfunction
