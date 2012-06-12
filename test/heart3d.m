% File:      heart3d.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2011.02.07
% Language:  MATLAB, program version: 7.11 (2010b)
% Purpose:   draw 3D heart, export mesh to idft-> convert to u3d-> movie15
% Copyright: Ioannis Filippidis, 2011-

function [fvc] = heart3d
step = 0.05;
[X Y Z] = meshgrid(-3:step:3, -3:step:3, -3:step:3);
F=((-(X.^2).*(Z.^3)-(9/80).*(Y.^2).*(Z.^3))+((X.^2)+(9/4).*(Y.^2)+(Z.^2)-1).^3);
p = patch(isosurface(X,Y,Z,F,0));
set(p,'facecolor','r','EdgeColor','r');
camlight
daspect([1 1 1])
view(3)
axis tight
axis equal

fvc = u3d_pre(p);
fvc.facevertexcdata = flipud(autumn(40944));
% save_idtf('heart3d.idtf',fvc.vertices,fvc.faces,vertexcolors)

% IDTFConverter.exe -input heart3d.idtf -ouput heart3d.u3d
