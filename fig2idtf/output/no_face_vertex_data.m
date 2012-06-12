function [count] = no_face_vertex_data(fid, faces, points, normals)

str = create_string;

nfaces = size(faces, 1);
npoints = size(points, 1);

strfaces = sprintf('%d %d %d\n', faces.'-1);
strpoints = sprintf('%f %f %f\n', points.');
strnormals = sprintf('%f %f %f\n', normals.');

count = fprintf(fid, str, nfaces, npoints, npoints, ...
                strfaces, strfaces, strpoints, strnormals);

function [str] = create_string
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
               MODEL_NORMAL_COUNT %d
               MODEL_DIFFUSE_COLOR_COUNT 0
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
                    0
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

%}
