function [count] = face_vertex_data_equals_npoints(fid,...
                            surface_vertices, faces, face_vertex_data,...
                            line_vertices, line_edges, line_colors)
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
% Date:      2012.06.10 - 
% Language:  MATLAB R2012a
% Purpose:   export to u3d multiple surfaces, lines, quivergroups
% Copyright: Ioannis Filippidis, 2012-

% depends
%   verbatim, populate_mesh_resource_str, populate_line_resource_str

n_meshes = size(faces, 2);
n_lines = size(line_vertices, 2);

%% nodes
mesh_node = mesh_node_str;
mesh_nodes = '';
for i=1:n_meshes
    cur_mesh_node = sprintf(mesh_node, i, i);
    mesh_nodes = [mesh_nodes, '\n\n', cur_mesh_node];
end
%disp(mesh_nodes)

line_node = line_node_str;
line_nodes = '';
for i=1:n_lines
    cur_line_node = sprintf(line_node, i, i);
    line_nodes = [line_nodes, '\n\n', cur_line_node];
end
%disp(line_nodes)

nodes = [mesh_nodes, '\n', line_nodes];

%% resources
mesh_resources = populate_mesh_resource_str(faces, surface_vertices, face_vertex_data);
n_resources = n_meshes;
line_resources = populate_line_resource_str(line_vertices, line_edges, line_colors, n_resources);

mesh_line_resources = [mesh_resources, '\n', line_resources];

resource_list = resource_list_model_str;
total_resource_number = n_meshes +n_lines;
resources = sprintf(resource_list, total_resource_number,...
                             mesh_line_resources);

%% final
file_info = file_info_str;
other1 = mesh_shader_material_str;
other2 = mesh_shading_str;

shadings = '';
for i=1:n_meshes
    str = sprintf(other2, i);
    shadings = [shadings, str];
end

str = [file_info, '\n', nodes, '\n', resources, '\n', other1, shadings];
count = fprintf(fid, str);


function [str] = file_info_str
str = verbatim;
%{
FILE_FORMAT "IDTF"
FORMAT_VERSION 100
%}

function [str] = mesh_node_str
%mesh_number, mesh_number
str = verbatim;
%{
NODE "MODEL" {
     NODE_NAME "Mesh%d"
     PARENT_LIST {
          PARENT_COUNT 1
          PARENT 0 {
               PARENT_NAME "<NULL>"
               PARENT_TM {
                    1.000000 0.000000 0.000000 0.000000
                    0.000000 1.000000 0.000000 0.000000
                    0.000000 0.000000 1.000000 0.000000
                    0.000000 0.000000 0.000000 1.000000
               }
          }
     }
     RESOURCE_NAME "MyMesh%d"
     MODEL_VISIBILITY "BOTH"
}
%}

function [str] = line_node_str
% line_number, line_number
str = verbatim;
%{
NODE "MODEL" {
     NODE_NAME "Line%d"
     PARENT_LIST {
          PARENT_COUNT 1
          PARENT 0 {
               PARENT_NAME "<NULL>"
               PARENT_TM {
                    1.000000 0.000000 0.000000 0.000000
                    0.000000 1.000000 0.000000 0.000000
                    0.000000 0.000000 1.000000 0.000000
                    0.000000 0.000000 0.000000 1.000000
               }
          }
     }
     RESOURCE_NAME "MyLine%d"
}
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

function [str] = mesh_shader_material_str
str = verbatim;
%{

RESOURCE_LIST "SHADER" {
     RESOURCE_COUNT 1
     RESOURCE 0 {
          RESOURCE_NAME "Box010"
          ATTRIBUTE_USE_VERTEX_COLOR "TRUE"
          SHADER_MATERIAL_NAME "Box010"
          SHADER_ACTIVE_TEXTURE_COUNT 0
     }
}

RESOURCE_LIST "MATERIAL" {
     RESOURCE_COUNT 1
     RESOURCE 0 {
          RESOURCE_NAME "Box010"
          MATERIAL_AMBIENT 0.0 0.0 0.0
          MATERIAL_DIFFUSE 1.0 1.0 1.0
          MATERIAL_SPECULAR 0.0 0.0 0.0
          MATERIAL_EMISSIVE 1.0 1.0 1.0
          MATERIAL_REFLECTIVITY 0.000000
          MATERIAL_OPACITY 1.000000
     }
}

%}

function [str] = mesh_shading_str
str = verbatim;
%{

MODIFIER "SHADING" {
     MODIFIER_NAME "Mesh%d"
     PARAMETERS {
          SHADER_LIST_COUNT 1
          SHADER_LIST_LIST {
               SHADER_LIST 0 {
                    SHADER_COUNT 1
                    SHADER_NAME_LIST {
                         SHADER 0 NAME: "Box010"
                    }
               }
          }
     }
}

%}
