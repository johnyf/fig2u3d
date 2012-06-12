function [line_resources] = populate_line_resource_str(line_vertices, line_lines, n_resources)
%
% See also FACE_VERTEX_DATA_EQUALS_NPOINTS, VERBATIM.
%
% File:      populate_line_resource_str.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.06.11 - 
% Language:  MATLAB R2012a
% Purpose:   line resource strings
% Copyright: Ioannis Filippidis, 2012-

% depends
%   verbatim

n_lines = size(line_vertices, 2);
line_resources = '';
for i=1:n_lines
    cur_line_points = line_vertices{1, i};
    cur_line_edges = line_lines{1, i};
    
    cur_line_resource = single_line_resource_str(cur_line_points,...
                                         cur_line_edges, i, n_resources);
    
    line_resources = [line_resources, '\n\n', cur_line_resource];
end
%disp(line_resources)

function [line_resource_str] = single_line_resource_str(vertices, edges,...
                                                line_number, n_resources)
line_resource = resource_line_str;

npnt = size(vertices, 2);
nlines = size(edges, 2);

line_position_list = edges;

str_line_position_list = sprintf('%d %d\n', line_position_list);
str_line_normal_list = str_line_position_list;
str_line_shading_list = sprintf('%d\n', zeros(nlines, 1) );

str_model_position_list = sprintf('%1.6f %1.6f %1.6f\n', vertices);
str_normal_list = sprintf('%f %f %f\n', zeros(3, nlines) );

resource_number = n_resources +line_number -1;
model_normal_count = nlines;

line_resource_str = sprintf(line_resource,...
    resource_number, line_number,...
    nlines, npnt, model_normal_count,...
    str_line_position_list, str_line_normal_list, str_line_shading_list,...
    str_model_position_list, str_normal_list);

function [str] = resource_line_str
% resource_number, line_number, line_count, model_position_count,
% model_normal_count,
% line_position_list, line_normal_list, line_shading_list,
% model_position_list, model_normal_list
str = verbatim;
%{

RESOURCE %d {
    RESOURCE_NAME "MyLine%d"
    MODEL_TYPE "LINE_SET"
    LINE_SET {
        LINE_COUNT %d
        MODEL_POSITION_COUNT %d
        MODEL_NORMAL_COUNT %d
        MODEL_DIFFUSE_COLOR_COUNT 0
        MODEL_SPECULAR_COLOR_COUNT 0
        MODEL_TEXTURE_COORD_COUNT 0
        MODEL_SHADING_COUNT 1
        MODEL_SHADING_DESCRIPTION_LIST {
            SHADING_DESCRIPTION 0 {
                TEXTURE_LAYER_COUNT 0
                SHADER_ID 0
            }
        }
        LINE_POSITION_LIST {
            %s
        }
        LINE_NORMAL_LIST {
            %s
        }
        LINE_SHADING_LIST {
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

%}
