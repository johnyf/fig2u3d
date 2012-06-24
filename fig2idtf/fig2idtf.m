function [] = fig2idtf(filename,...
                        surf_vertices, faces, face_vertex_data,...
                        line_vertices, line_edges, line_colors,...
                        pointset_points, pointset_colors)
%FIG2IDTF   Save figure in IDTF format.
%
% usage
%   FIG2IDTF(filename, surf_vertices, faces, face_vertex_data,...
%                      line_vertices, line_edges, line_colors,...
%                      pointset_points, pointset_colors)
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
% reference
%   IDTF (Intermediate Data Text File) Format Description, Version 100,
%   Intel Corporation, 2005, available at:
%       http://u3d.svn.sourceforge.net/viewvc/u3d/releases/Gold12Update/Docs/IntermediateFormat/IDTF%20Format%20Description.pdf
%
% See also FIG2U3D, IDTF2U3D, FIG2PDF3D, U3D_PRE_SURFACE, U3D_PRE_LINE,
%          U3D_PRE_QUIVERGROUP, U3D_PRE_CONTOURGROUP.
%
% File:      fig2idtf.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.06.10 - 
% Language:  MATLAB R2012a
% Purpose:   preprocess lineseries children of axes for u3d export
%
% acknowledgment
%   Based on save_idtf by Alexandre Gramfort.
%   This can be found on the MATLAB Central File Exchange:
%       http://www.mathworks.com/matlabcentral/fileexchange/25383-matlab-mesh-to-pdf-with-3d-interactive-object
%   and is covered by the BSD License.

% depends
%   face_vertex_data_equals_npoints, check_file_extension

face_vertex_data_equals_npoints(filename,...
                                surf_vertices, faces, face_vertex_data,...
                                line_vertices, line_edges, line_colors,...
                                pointset_points, pointset_colors);
%{
%% What is this ?
if fv1 == npoints
    normals = mesh_normals(points, faces);
    
    t = [ones(3,3), -ones(3,3) ];
    nt = max(normals*t, 0);
    a = sum(nt, 2);
    b = repmat(a, 1, 3);
    b = b .*face_vertex_data;
    
    face_vertex_data = 0.7 *face_vertex_data +0.3 *b;
    
    face_vertex_data(face_vertex_data < 0) = 0;
    face_vertex_data(face_vertex_data > 1) = 1;
end

% Hack to avoid to have too many colors to store
face_vertex_data = fix(face_vertex_data*10) ./10;
% face_vertex_data = fix(face_vertex_data*100)./100;
points = points - repmat(mean(points), npoints, 1);
%}
