function [] = face_vertex_data_equals_nfaces(fid, faces, points,...
                                             normals, face_vertex_data)
[face_vertex_data_unique, ~, face_vertex_data_idx] = ...
                                unique(face_vertex_data, 'rows');
nface_vertex_data_unique = size(face_vertex_data_unique,1);

idx = [0:(nfaces-1)].';
shidx = [0:(nface_vertex_data_unique-1)].';

fprintf(fid, node_resource_list_str, nfaces, npoints, npoints, nface_vertex_data_unique);
fprintf(fid, shading_description_str, [shidx, shidx].');
% stridx = sprintf('%d\n',idx);
str_face_vertex_data_idx = sprintf('%d\n', face_vertex_data_idx-1);
fprintf(fid, mesh_data_str, strfaces, strfaces, str_face_vertex_data_idx,...
                strpoints, strnormals, nface_vertex_data_unique);
fprintf(fid, resource_str, [shidx, shidx, shidx].');
fprintf(fid, resource_list_material_str, nface_vertex_data_unique);
fprintf(fid, resource_material, [shidx, shidx, face_vertex_data_unique]');
fprintf(fid, modifier_shading_str, nface_vertex_data_unique);
fprintf(fid, shader_list_str, [shidx, shidx].');
fprintf(fid, endstr);

function [str] = node_resource_list_str
str = verbatim;
%{
RESOURCE_LIST "MODEL" {
     RESOURCE_COUNT 1
     RESOURCE 0 {
          RESOURCE_NAME "MyMesh"
          MODEL_TYPE "MESH"
          MESH {
               FACE_COUNT %d
               MODEL_POSITION_COUNT %d
               MODEL_NORMAL_COUNT %d
               MODEL_DIFFUSE_COLOR_COUNT 0
               MODEL_SPECULAR_COLOR_COUNT 0
               MODEL_TEXTURE_COORD_COUNT 0
               MODEL_BONE_COUNT 0
               MODEL_SHADING_COUNT %d
               MODEL_SHADING_DESCRIPTION_LIST {

%}

function [str] = shading_description_str
str = verbatim;
%{
            SHADING_DESCRIPTION %d {
                     TEXTURE_LAYER_COUNT 0
                     SHADER_ID %d
                }

%}

function [str] = mesh_data_str
str = verbatim;
%{
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
               MODEL_POSITION_LIST {
                    %s
               }
               MODEL_NORMAL_LIST {
                    %s
               }
          }
     }
}

RESOURCE_LIST "SHADER" {
     RESOURCE_COUNT %d

%}

function [str] = resource_str
str = verbatim;
%{
     RESOURCE %d {
          RESOURCE_NAME "Box01%d"
          SHADER_MATERIAL_NAME "Box01%d"
          SHADER_ACTIVE_TEXTURE_COUNT 0
    }

%}

function [str] = resource_list_material_str
str = verbatim;
%{
}

RESOURCE_LIST "MATERIAL" {
     RESOURCE_COUNT %d

%}

function [str] = modifier_shading_str
str = verbatim;
%{
}

MODIFIER "SHADING" {
     MODIFIER_NAME "Mesh"
     PARAMETERS {
          SHADER_LIST_COUNT %d
          SHADER_LIST_LIST {

%}

function [str] = shader_list_str
str = verbatim;
%{
               SHADER_LIST %d {
                    SHADER_COUNT 1
                    SHADER_NAME_LIST {
                         SHADER 0 NAME: "Box01%d"
                    }
               }

%}

function [str] = resource_material
str = verbatim;
%{
     RESOURCE %d {
          RESOURCE_NAME "Box01%d"
          MATERIAL_AMBIENT 0 0 0
          MATERIAL_DIFFUSE %f %f %f
          MATERIAL_SPECULAR 0.2 0.2 0.2
          MATERIAL_EMISSIVE 0 0 0
          MATERIAL_REFLECTIVITY 0.100000
          MATERIAL_OPACITY 1.000000
     }

%}

function [str] = endstr
str = verbatim;
%{
          }
     }
}

%}
