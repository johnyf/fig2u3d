function [str] = str_with_colors
str = verbatim;
%{
FILE_FORMAT "IDTF"
FORMAT_VERSION 100

NODE "MODEL" {
     NODE_NAME "Mesh"
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
     RESOURCE_NAME "MyMesh"
}

RESOURCE_LIST "MODEL" {
     RESOURCE_COUNT 1
     RESOURCE 0 {
          RESOURCE_NAME "MyMesh"
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
}

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

MODIFIER "SHADING" {
     MODIFIER_NAME "Mesh"
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
