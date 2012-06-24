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
%
% acknowledgment
%   Based on save_idtf by Alexandre Gramfort.
%   This can be found on the MATLAB Central File Exchange:
%       http://www.mathworks.com/matlabcentral/fileexchange/25383-matlab-mesh-to-pdf-with-3d-interactive-object
%   and is covered by the BSD License.

% depends
%   mesh_normals, verbatim

n_meshes = size(f, 2);
tmp_mesh_resources = cell(1, n_meshes);
for i=1:n_meshes
    faces = f{1, i};
    points = v{1, i};
    face_vertex_data = c{1, i};
    
    cur_mesh_resource = single_mesh_resource(faces, points, face_vertex_data, i);
            
    tmp_mesh_resources{1, i} = ['\n\n', cur_mesh_resource];
end
mesh_resources = [tmp_mesh_resources{:} ];
%disp(mesh_resources)

function [mesh_resource] = single_mesh_resource(faces, points, face_vertex_data, i)
if ~isempty(face_vertex_data) && size(face_vertex_data, 2) ~= 3
    error('IDTF colors should be RGB');
end    

nfaces = size(faces, 1);
npoints = size(points, 1);
nface_vertex_data = size(face_vertex_data, 1);
resource_number = i -1;

% #cdata == #points ?
if (nface_vertex_data ~= npoints) && (nface_vertex_data ~= 0)
    error('size(cdata, 1) = #points')
end

%% colors
[strfaces_colors, strshading, strcolors, nface_vertex_data_unique] = ...
    prep_colors(faces, face_vertex_data);

strfaces = sprintf('%d %d %d\n', faces.'-1);
strpoints = sprintf('%f %f %f\n', points.');

normals = mesh_normals(points, faces);
strnormals = sprintf('%f %f %f\n', normals.');

mesh_resource = sprintf(resource_mesh_str, resource_number, i,...
            nfaces, npoints, npoints,...
            nface_vertex_data_unique, strfaces, strfaces,...
            strshading, strfaces_colors, strpoints, strnormals, strcolors);

function [strfaces_colors, strshading, strcolors,...
          nface_vertex_data_unique] = prep_colors(faces, face_vertex_data)
% no colors
if isempty(face_vertex_data)
    strfaces_colors = '';
    strshading = '0';
    strcolors = '';
    nface_vertex_data_unique = 0;
    return
end

nfaces = size(faces, 1);

[face_vertex_data_unique, ~, face_vertex_data_idx] = ...
                                unique(face_vertex_data, 'rows');
nface_vertex_data_unique = size(face_vertex_data_unique, 1);
msg = ['Number of colors: ', num2str(nface_vertex_data_unique) ];
disp(msg);

strfaces_colors = sprintf('%d %d %d\n', face_vertex_data_idx(faces).'-1);
strfaces_colors = sprintf(mesh_face_diffuse_color_list, strfaces_colors);

strshading = sprintf('%d\n', zeros(nfaces, 1) );
strcolors = sprintf('%f %f %f 0.5\n', face_vertex_data_unique.');
strcolors = sprintf(model_diffuse_color_list, strcolors);
    
function [str] = resource_mesh_str
% resource_number, mesh_number, face_count, model_position_count,
% model_normal_count,
% model_diffuse_color_count, mesh_face_position_list,
% mesh_face_shading_list, mesh_face_diffuse_color_list,
% model_position_list, model_normal_list, model_diffuse_color_list
str = verbatim;
%{
    RESOURCE %d {
          RESOURCE_NAME "MyMesh%d"
          MODEL_TYPE "MESH"
          MESH {
               FACE_COUNT %d
               MODEL_POSITION_COUNT %d
               MODEL_NORMAL_COUNT %d
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
               MESH_FACE_NORMAL_LIST {
                    %s
               }
               MESH_FACE_SHADING_LIST {
                    %s
               }
               %s
               MODEL_POSITION_LIST {
                    %s
               }
               MODEL_NORMAL_LIST {
                    %s
               }
               %s
          }
     }
%}

function [str] = mesh_face_diffuse_color_list
str = verbatim;
%{
               MESH_FACE_DIFFUSE_COLOR_LIST {
                    %s
               }
%}

function [str] = model_diffuse_color_list
str = verbatim;
%{
               MODEL_DIFFUSE_COLOR_LIST {
                    %s
               }
%}
