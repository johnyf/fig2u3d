function [vertices, edges, line_colors] = create_marker_lines(h, type)
% File:      create_marker_lines.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.06.14
% Language:  MATLAB R2012a
% Purpose:   create linesets for markers which are not points
% Copyright: Ioannis Filippidis, 2012-

% depends
%   get_line_xyz

p = get_line_xyz(h);

switch type
    case 'o'
        type = 'circle_marker';
    case 'x'
        type = 'x_marker';
    case '+'
        type = 'plus_marker';
    case '*'
        type = 'star_marker';
    case 'square'
        type = 'square_marker';
    case 'diamond'
        type = 'diamond_marker';
    case 'v'
        type = 'down_triangle_marker';
    case '^'
        type = 'up_triangle_marker';
    case '<'
        type = 'left_triangle_marker';
    case '>'
        type = 'right_triangle_marker';
    case 'pentagram'
        type = 'pentagram_marker';
    case 'hexagram'
        type = 'hexagram_marker';
    otherwise
        error('Unknown marker style.')
end
disp(['      MarkerStyle = ', type] );

dp = diff(p, 1, 2);
d = vnorm(dp);
r = min(d) /6;  % 1/6 minimal distance between consecutive points,
                % used as marker size
[marker_vertices, marker_edges] = feval(type, r);
[vertices, edges] = copy_marker_on_points(marker_vertices, marker_edges, p);

n = size(p, 2);
linecolor = {get(h, 'Color') };
line_colors = repmat(linecolor, 1, n);

function [vertices, edges] = copy_marker_on_points(marker_vertices, marker_edges, p)
n = size(p, 2);
m = size(marker_vertices, 2);

marker_vertices = [marker_vertices; zeros(1, m) ];
vertices = cell(1, n);
edges = cell(1, n);
for i=1:n
    curp = p(:, i);
    
    v = bsxfun(@plus, marker_vertices, curp);
    e = marker_edges;
    
    vertices{1, i} = v;
    edges{1, i} = e;
end

function [vertices, edges] = circle_marker(r)
n = 10;
t = linspace(0, 2*pi, n);
vertices = r *[cos(t); sin(t) ];
edges = [1:n; 2:n, 1] -1;

function [vertices, edges] = x_marker(r)
vertices = r *[-1, 1; -1, -1; 1, -1; 1, 1].';
edges = [1, 3; 2, 4].' -1;

function [vertices, edges] = plus_marker(r)
vertices = r *[-1, 0; 1, 0; 0, -1; 0, 1].';
edges = [1, 2; 3, 4].' -1;

function [vertices, edges] = star_marker(r)
vertices = r *[-1, 0; -1, -1; 0, -1; 1, -1; 1, 0; 1, 1; 0, 1; -1, 1].';
edges = [1, 5; 2, 6; 3, 7; 4, 8].' -1;

function [vertices, edges] = square_marker(r)
vertices = r *[-1, 1; -1, -1; 1, -1; 1, 1].';
edges = [1, 2; 2, 3; 3, 4; 4, 1].' -1;

function [vertices, edges] = diamond_marker(r)
vertices = r *[-1, 0; 1, 0; 0, -1; 0, 1].';
edges = [1, 3; 3, 2; 2, 4; 4, 1].' -1;

function [vertices, edges] = down_triangle_marker(r)
vertices = r *[-1, 0; 0, -1; 1, 0].';
edges = [1, 2; 2, 3].' -1;

function [vertices, edges] = up_triangle_marker(r)
vertices = r *[-1, 0; 0, 1; 1, 0].';
edges = [1, 2; 2, 3].' -1;

function [vertices, edges] = left_triangle_marker(r)
vertices = r *[0, -1; 1, 0; 0, 1].';
edges = [1, 2; 2, 3].' -1;

function [vertices, edges] = right_triangle_marker(r)
vertices = r *[0, -1; -1, 0; 0, 1].';
edges = [1, 2; 2, 3].' -1;

function [vertices, edges] = pentagram_marker(r)
r = r /100;
vertices = r *[0, 85; 75, 75; 100, 10; 125, 75;
               200, 85; 150, 125; 160, 190; 100, 150;
               40, 190; 50, 125; 0, 85].';
edges = [1:10, 11; 2:11, 1] -1;

function [vertices, edges] = hexagram_marker(r)
r1 = r;
r2 = r1 /2;

n = 7;
t = linspace(0, 2*pi, n);
x1 = r1 *[cos(t); sin(t) ];

t2 = t +pi /n;
x2 = r2 *[cos(t2); sin(t2) ];

m = 2 *n;
x(:, 1:2:m) = x1;
x(:, 2:2:m) = x2;

vertices = x;
edges = [1:m; 2:m, 1] -1;
