function [] = fig2idtf(filename,...
                        surf_vertices, faces, face_vertex_data,...
                        line_vertices, line_edges,...
                        quiver_vertices, quiver_edges)
%SAVE_IDTF   Save mesh in IDTF format.
%
% usage
%   SAVE_IDTF(filename, points, faces, face_vertex_data)
%
% input
%   filename = string of filename (including extension)
%   points = matrix of point coordinates
%          = [#points x 3]
%          = [x1, y1, z1;
%             x2, y2, z2;
%             ...
%             xN, yN, zN]
%   faces = matrix of point indices for each vertex of face triangle
%          = [#triangles x 3]
%          = [point1_index, point2_index, point3_index; ;;; ]
%   face_vertex_data = RGB color data for points
%                    = [#points x 3]
%
% See also FIG2U3D, U3D_PRE_SURFACE, U3D_PRE_LINE, U3D_PRE_QUIVERGROUP.
%
% File:      fig2idtf.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.06.10 - 
% Language:  MATLAB R2012a
% Purpose:   preprocess lineseries children of axes for u3d export
% Copyright: 
%
% Original Author: Alexandre Gramfort (2009-04-21)
% Copyright (c)  Alexandre Gramfort. All rights reserved.

% depends
%   face_vertex_data_equals_npoints

if nargin < 4
    face_vertex_data = [];
end

npoints = size(surf_vertices, 1);



% if nface_vertex_data == npoints
%     if 0
%         face_vertex_data_mean = (face_vertex_data(faces(:,1),:)+face_vertex_data(faces(:,2),:)+ ...
%                                 face_vertex_data(faces(:,3),:))/3;
%         xx = face_vertex_data_mean - face_vertex_data(faces(:,1),:); xx = sum(xx.*xx,2);
%         yy = face_vertex_data_mean - face_vertex_data(faces(:,2),:); yy = sum(yy.*yy,2);
%         zz = face_vertex_data_mean - face_vertex_data(faces(:,3),:); zz = sum(zz.*zz,2);
%         [tmp,I] = sort([xx,yy,zz],2);
%         face_vertex_data = face_vertex_data(I(:,2),:);
%         % [tmp,I] = min([xx,yy,zz],[],2);
%         % face_vertex_data = face_vertex_data(I,:);
%     else
%         face_vertex_data = (face_vertex_data(faces(:,1),:)+face_vertex_data(faces(:,2),:)+ ...
%                             face_vertex_data(faces(:,3),:))/3;
%     end
%     nface_vertex_data = nfaces;
% end

fid = fopen(filename, 'w');

disp('# of face vertex data == # points.')
    count = face_vertex_data_equals_npoints(fid,...
                            surf_vertices, faces, face_vertex_data,...
                            line_vertices, line_edges,...
                            quiver_vertices, quiver_edges);
%{
if isempty(face_vertex_data)
    disp('No face vertex data provided.')
    count = no_face_vertex_data(fid, faces, points, normals);
elseif nface_vertex_data == npoints
    disp('# of face vertex data == # points.')
    count = face_vertex_data_equals_npoints(fid, faces, points,...
                                            normals, face_vertex_data, line_points);
else
    disp('# of face vertex data ~= #points.')
    count = face_vertex_data_unequal_npoints(fid, faces, points,...
                                        normals, face_vertex_data);
end
%}

disp(['Number of lines written to IDTF file: ', num2str(count) ] )

fclose(fid);
