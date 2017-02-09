function sphereplot(tet,phi,val,varargin)
  // Potentiel sur une partie de sphère
  //
  // Calling Sequence
  // sphereplot(theta,phi,P[,opt_args])
  // sphereplot(theta,phi,P[,'min',mn][,'max',mx])
  //
  // Parameters
  // theta : vecteur taille n1. Domaine angulaire par rapport à Oz en radians. [0,pi]
  // phi : vecteur taille n2. Domaine angulaire par rapport à xOz en radians. [0,2pi] ou [-%pi/2,%pi/2]
  // P : matrice réelle n1 x n2. Potentiel P(i,j) aux noeuds theta(i), phi(j).
  // opt_args : arguments optionnels par couple 'key',val
  //
  // Description
  // Trace la sphère dans le domaine (theta,phi) puis collorise les noeuds selon P, 
  // en interpolant les couleurs entre les noeud. 
  // 
  // Description des arguments optionnels
  //
  // key = 'min'; val scalaire. Etalonne les couleurs pour que val soit représenté par la premiere couleur de la colormap.
  // key = 'max'; val scalaire. Etalonne les couleurs pour que val soit représenté par la dernière couleur de la colormap.
  //
  // Examples
  // figure()
  // sphereplot()
  //
  // figure()
  // theta = linspace(%pi/10,%pi/2,10)
  // phi = linspace(0,%pi/7,30)
  // P = rand(length(theta),length(phi),'normal');
  // sphereplot(theta,phi,P)
  //
  // Screenshots
  // <scilab:image> sphereplot(); title('Exemple 1'); </scilab:image>
  // <scilab:image> sphereplot(linspace(%pi/10,%pi/2,10),linspace(0,%pi/7,30),rand(20,30,'normal')); title('Exemple 2'); </scilab:image>
  //
  // See also
  // plot3d
  // eval3d
  //
  // Authors
  // Pierre Payen (08/2016)


  function [x,y,z]=sphere(tet,phi)
    x=sin(tet).*cos(phi);
    y=sin(tet).*sin(phi);
    z=cos(tet).*ones(phi);
  endfunction

  function [x,y,z]=sphere2(tet,phi)
    x=sin(tet)*cos(phi);
    y=sin(tet)*sin(phi);
    z=cos(tet)*ones(phi);
  endfunction

  if argn(2)==0 then
    tet = linspace(0,%pi,30);
    phi = linspace(0,2*%pi,30);
    [x,y,z]=sphere2(tet',phi)
    val = x.*y.*z
    valval = matrix(val,30,30)'  
  end

  mn = min(val)
  mx = max(val)

  if argn(2)>3 then
    for i=1:length(varargin)/2 
      key = varargin((i-1)*2+1)
      kval = varargin(2*i)
      select  key
      case 'min' then
        mn = kval
      case 'max' then
        mx = kval
      end
    end
  end

  tet = matrix(tet,1,length(tet)); // tet : longitude
  phi = matrix(phi,1,length(phi)); // phi : co-latitude
  phi = phi($:-1:1) // invertion à cause orentation eval3d et convention scilab latitude
  [xx,yy,zz]=eval3dp(sphere,tet,phi);

  [x,y,z]=sphere2(tet',phi)
  valval = zeros(xx)

  for i = 1:size(x,1)
    for j = 1:size(x,2)
      valval(xx==x(i,j)&yy==y(i,j)&zz==z(i,j))=val(i,j)
    end
  end

  ncol = length(val);
  ind = floor((ncol-1)*(valval-mn)/(mx-mn+%eps))+1;

  colormap('jet',ncol)
  plot3d(xx,yy,list(zz,ind),flag=[-2,8,4]);
  whitebg w
endfunction
