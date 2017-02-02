// demo des coordonées sphériques telles qu'utilisée dans spherictocart
// Pierre Payen (09/2016)

figure()
r = 2;
tet = %pi/4;
phi = %pi/4;

er = [1 0 0];
etet = [0 1 0];
ephi = [0 0 1];

[x,y,z,fx,fy,fz] = spherictocart(r,tet,phi,er,etet,ephi);

param3d([0 x],[0 y],[0 z])
xstring3d(x/2,y/2,z/2,'$\huge \rho$')

// repère sphérique
champ3d(x,y,z,fx(1),fy(1),fz(1),'bodycolor',color('blue'),'headcolor',color('blue'),'color_mode',-2)
xstring3d(x+fx(1),y+fy(1),z+fz(1),'$\huge e_r$')
champ3d(x,y,z,fx(2),fy(2),fz(2),'bodycolor',color('red'),'headcolor',color('red'),'color_mode',-2)
xstring3d(x+fx(2),y+fy(2),z+fz(2),'$\huge e_\theta$')
champ3d(x,y,z,fx(3),fy(3),fz(3),'bodycolor',color('green'),'headcolor',color('green'),'color_mode',-2)
xstring3d(x+fx(3),y+fy(3),z+fz(3),'$\huge e_\phi$')

// repère cartésien
champ3d(0,0,0,3,0,0,'prop',0.9)
xstring3d(2.7,0,0,'$\huge e_x$')
champ3d(0,0,0,0,3,0,'prop',0.9)
xstring3d(0,2.7,0,'$\huge e_y$')
champ3d(0,0,0,0,0,3,'prop',0.9)
xstring3d(0,0,2.7,'$\huge e_z$')


param3d([x($) x($)],[y($) y($)],[0 r*sin(tet)])
set(gce(),'line_style',2)
r = r*cos(tet);
tet = %pi/2;
phi = linspace(0,%pi/4,10);

[xp,yp,zp,fxp,fyp,fzp] = spherictocart(r,tet,phi,0,0,0)
param3d(xp,yp,zp)
set(gce(),'line_style',2)
param3d([0 xp($)],[0 yp($)],[0 zp($)])
set(gce(),'line_style',2)
param3d([xp($) xp($)],[yp($) yp($)],[0 zp($)+ r*sin(tet)])
set(gce(),'line_style',2)
xstring3d(mean(xp),mean(yp),mean(zp),'$\huge \phi$')

r = 1;
tet = linspace(0,%pi/4,10);
phi = %pi/4;

[xt,yt,zt,fxt,fyt,fzt] = spherictocart(r,tet,phi,0,0,0)
xstring3d(mean(xt),mean(yt),mean(zt),'$\huge \theta$')
param3d(xt,yt,zt)
set(gce(),'line_style',2)
axis equal
axis off

