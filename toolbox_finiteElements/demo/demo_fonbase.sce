// script démo visualisation des fonctions de base aux barycentres
xdel(winsid())
clc
//fic_mail = uigetfile('*.maila','.');
fic_mail = 'pyra-6elt.maila'
nom_mail = basename(fic_mail)
// Initialisation de la structure obj, gestion du maillage; Nécessite msh.sci
mshS = msh();
obj = mshS.init();

// Lecture du ficher et chargement dans la structure obj
disp('Lecture du maillage '+nom_mail)
obj = mshS.read(fic_mail);
obj = mshS.more(obj)
vsize = obj.edge.mean/3
iel = 1:obj.nface // Indice des elements dont on veut connaitre les fonctions de bases
n = length(iel)

// calcul du barycentre des éléments triangulaire
in = obj.face.node(iel,:);
xb = mean([obj.node.x(in(:,1)),obj.node.x(in(:,2)),obj.node.x(in(:,3))],2);
yb = mean([obj.node.y(in(:,1)),obj.node.y(in(:,2)),obj.node.y(in(:,3))],2);
zb = mean([obj.node.z(in(:,1)),obj.node.z(in(:,2)),obj.node.z(in(:,3))],2);


sRT = foncbaseRT()
[phi1,phi2,phi3] = sRT.bary(obj) // on récupère les 3 fonctions de base locales calculée en Xb

figure(100)
subplot(3,1,1)
whitebg w
mshS.plot(obj,'edge',abs(obj.face.edge(iel,:))); // on affiche les numéros des arêtes des éléments considérés
mshS.plot(obj,'node',abs(obj.face.node(iel,:))); // on affiche les numéros des noeuds des éléments considérés
champ3d(xb,yb,zb,phi1(:,1),phi1(:,2),phi1(:,3),'size',vsize) // les couleurs indique la norme réelle des vecteurs 
title('Fonctions de bases de la 1ere arete locale');

subplot(3,1,2)
whitebg w
mshS.plot(obj,'edge',abs(obj.face.edge(iel,:))); // on affiche les numéros des arêtes des éléments considérés
mshS.plot(obj,'node',abs(obj.face.node(iel,:))); // on affiche les numéros des noeuds des éléments considérés
champ3d(xb,yb,zb,phi2(:,1),phi2(:,2),phi2(:,3),'size',vsize) // leur taille sur le graphe vaut vsize
title('Fonctions de bases de la 2ieme arete locale');

subplot(3,1,3)
whitebg w
mshS.plot(obj,'edge',abs(obj.face.edge(iel,:))); // on affiche les numéros des arêtes des éléments considérés
mshS.plot(obj,'node',abs(obj.face.node(iel,:))); // on affiche les numéros des noeuds des éléments considérés
champ3d(xb,yb,zb,phi3(:,1),phi3(:,2),phi3(:,3),'size',vsize)
title('Fonctions de bases de la 3ieme arete locale');

set(gcf(),'figure_size',[338 1100])
