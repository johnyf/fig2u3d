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
%   This can be found on the MATLAb Central File Exchange:
%       http://www.mathworks.com/matlabcentral/fileexchange/25383-matlab-mesh-to-pdf-with-3d-interactive-object
%   and is covered by the BSD License.

% depends
%   face_vertex_data_equals_npoints, check_file_extension

if nargin < 4
    face_vertex_data = [];
end

npoints = size(surf_vertices, 1);

idtffile = check_file_extension(filename, '.idtf');
fid = fopen(idtffile, 'w');

disp('# of face vertex data == # points.')
    count = face_vertex_data_equals_npoints(fid,...
                            surf_vertices, faces, face_vertex_data,...
                            line_vertices, line_edges, line_colors,...
                            pointset_points, pointset_colors);
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
