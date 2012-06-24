function [] = face_vertex_data_equals_npoints(filename,...
                            surface_vertices, faces, face_vertex_data,...
                            line_vertices, line_edges, line_colors,...
                            pointset_points, pointset_colors)
%FACE_VERTEX_DATA_EQUALS_NPOINTS    Export multiple surfaces, lines, quivers.
%
% usage
%   count = face_vertex_data_equals_npoints(fid,...
%                            surface_vertices, faces, face_vertex_data,...
%                            line_vertices, line_edges)
%
% input
%   fid = output file handle
%
%   faces = {1 x #surfaces}
%   surface_vertices = {1 x #surfaceplots}
%   face_vertex_data = {1 x #surfaceplots}
%
%   line_vertices = {1 x #lineseries}
%   line_lines = {1 x #lineseries}
%
%   quiver_vertices = {1 x #quivergroups}
%   quiver_lines = {1 x #quivergroups}
%
% output
%   count = number of lines written to file with handle fid
%
% See also FIG2IDTF.
%
% File:      face_vertex_data_equals_npoints.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.06.10 - 2012.06.14
% Language:  MATLAB R2012a
% Purpose:   export to u3d multiple surfaces, lines, quivergroups
% Copyright: Ioannis Filippidis, 2012-
%
% acknowledgment
%   Based on save_idtf by Alexandre Gramfort.
%   This can be found on the MATLAB Central File Exchange:
%       http://www.mathworks.com/matlabcentral/fileexchange/25383-matlab-mesh-to-pdf-with-3d-interactive-object
%   and is covered by the BSD License.

% depends
%   verbatim, populate_mesh_resource_str, populate_line_resource_str,
%   populate_point_resource_str

n_meshes = size(faces, 2);
n_lines = size(line_vertices, 2);
n_pointsets = size(pointset_points, 2);

%% nodes
nodes = idtf_model_nodes(n_meshes, n_lines, n_pointsets);

%% resources
mesh_resources = populate_mesh_resource_str(faces, surface_vertices, face_vertex_data);
n_resources = n_meshes;
line_resources = populate_line_resource_str(line_vertices, line_edges, line_colors, n_resources);
n_resources = n_resources +n_lines;
point_resources = populate_point_resource_str(pointset_points, pointset_colors, n_resources);

mesh_line_resources = [mesh_resources, line_resources, point_resources];

resource_list = resource_list_model_str;
total_resource_number = n_meshes +n_lines +n_pointsets;
resources = sprintf(resource_list, total_resource_number,...
                             mesh_line_resources);

%% final
file_info = file_info_str;
[shaders, materials, modifiers] = shaders_materials_modifiers(surface_vertices, faces, face_vertex_data);

str = [file_info, nodes, resources, shaders, materials, modifiers];

idtffile = check_file_extension(filename, '.idtf');
fid = fopen(idtffile, 'w');
count = fprintf(fid, str);
fclose(fid);

disp(['Number of lines written to IDTF file: ', num2str(count) ] )

function [str] = file_info_str
str = verbatim;
%{
FILE_FORMAT "IDTF"
FORMAT_VERSION 100

%}

function [str] = resource_list_model_str
% total_node_number, aggregate_string_of_resources
str = verbatim;
%{

RESOURCE_LIST "MODEL" {
     RESOURCE_COUNT %d
     %s
}

%}
