function [mesh_resources] = populate_mesh_resource_str(f, v, c)
%
% See also FACE_VERTEX_DATA_EQUALS_NPOINTS, MESH_NORMALS, VERBATIM.
%
% File:      populate_mesh_resource_str.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.06.10 - 
% Language:  MATLAB R2012a
% Purpose:   mesh resource strings
% Copyright: Ioannis Filippidis, 2012-

% depends
%   mesh_normals, verbatim

n_meshes = size(f, 2);
mesh_resource = resource_mesh_str;
tmp_mesh_resources = cell(1, n_meshes);
for i=1:n_meshes
    faces = f{1, i};
    points = v{1, i};
    face_vertex_data = c{1, i};
    
    if ~isempty(face_vertex_data) && size(face_vertex_data, 2) ~= 3
        error('IDTF colors should be RGB');
    end
    %nface_vertex_data = size(face_vertex_data, 1);
    
    nfaces = size(faces, 1);
    npoints = size(points, 1);
    
    [face_vertex_data_unique, ~, face_vertex_data_idx] = ...
                                unique(face_vertex_data, 'rows');
    nface_vertex_data_unique = size(face_vertex_data_unique, 1);

    msg = ['nb of colors : ', num2str(nface_vertex_data_unique) ];
    disp(msg);

    
    strfaces = sprintf('%d %d %d\n', faces.'-1);
    strfaces_colors = sprintf('%d %d %d\n', face_vertex_data_idx(faces).'-1);
    strpoints = sprintf('%f %f %f\n', points.');
    
    %normals = mesh_normals(points, faces);
    %strnormals = sprintf('%f %f %f\n', normals.');
    strshading = sprintf('%d\n', zeros(nfaces, 1) );
    strcolors = sprintf('%f %f %f\n', face_vertex_data_unique.');
    
    resource_number = i -1;
    cur_mesh_resource = sprintf(mesh_resource, resource_number, i,...
                nfaces, npoints,...
                nface_vertex_data_unique, strfaces,...
                strshading, strfaces_colors, strpoints, strcolors);
            
    tmp_mesh_resources{1, i} = ['\n\n', cur_mesh_resource];
end
mesh_resources = [tmp_mesh_resources{:} ];
%disp(mesh_resources)

function [str] = resource_mesh_str
% resource_number, mesh_number, face_count, model_position_count,
% model_diffuse_color_count, mesh_face_position_list,
% mesh_face_shading_list, mesh_face_diffuse_color_list,
% model_position_list, model_diffuse_color_list
str = verbatim;
%{
    RESOURCE %d {
          RESOURCE_NAME "MyMesh%d"
          MODEL_TYPE "MESH"
          MESH {
               FACE_COUNT %d
               MODEL_POSITION_COUNT %d
               MODEL_NORMAL_COUNT 0
               MODEL_DIFFUSE_COLOR_COUNT %d
               MODEL_SPECULAR_COLOR_COUNT 0
               MODEL_TEXTURE_COORD_COUNT 0
               MODEL_BONE_COUNT 0
               MODEL_SHADING_COUNT 1
               MODEL_SHADING_DESCRIPTION_LIST {
                    SHADING_DESCRIPTION 0 {
                         TEXTURE_LAYER_COUNT 0
                         SHADER_ID 0
                    }
               }
               MESH_FACE_POSITION_LIST {
                    %s
               }
               MESH_FACE_SHADING_LIST {
                    %s
               }
               MESH_FACE_DIFFUSE_COLOR_LIST {
                    %s
               }
               MODEL_POSITION_LIST {
                    %s
               }
               MODEL_DIFFUSE_COLOR_LIST {
                    %s
               }
          }
     }
%}
