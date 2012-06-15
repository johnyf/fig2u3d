function [vertices, edges, colors] = u3d_pre_quivergroup(ax)
%U3D_PRE_QUIVERGROUP    Preprocess quiver output to u3d.
%
% usage
%   [vertices, edges, colors] = U3D_PRE_QUIVERGROUP
%   [vertices, edges, colors] = U3D_PRE_QUIVERGROUP(ax)
%
% optional input
%   ax = axes object handle
%
% output
%   vertices = position vectors as columns of matrix,
%              as row cell array for multiple quivergroups
%          = {1 x quivergroups}
%          = {[3 x #points], ... }
%   edges = line connections between vertices,
%           index in "vertices" of each line's
%           start and end vertices ,
%           as row cell array for multiple quivergroups
%         = {1 x #quivergroups}
%         = {[2 x #lines], ...}
%           where: [2 x #lines] = [start_index1, ...;
%                                  end_index1, ...];
%   colors = RGB colors of quivergroups
%          = {1 x #quivergroups}
%          = {[r, g, b], [r, g, b], ... }
%
% See also FIG2IDTF, U3D_PRE_LINE, U3D_PRE_SURFACE.
%
% File:      u3d_pre_quivergroup.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.06.11 - 
% Language:  MATLAB R2012a
% Purpose:   preprocess quivergroup children of axes for u3d export
% Copyright: Ioannis Filippidis, 2012-

% todo
%   replace body tip point with head tip point,
%   to refer to a common tip point, so that lossy compression gets
%   to affect both body and head in the same way

%% input
if nargin < 1
    sh = findobj('type', 'hggroup');
else
    objs = get(ax, 'Children');
    sh = findobj(objs, 'type', 'hggroup');
end

% hggroup = quivergroup ?
for i=1:size(sh, 1)
    cursh = sh(i, 1);
    
    if ~isprop(cursh, 'ShowArrowHead')
        sh(i, 1) = nan;
    end
end

sh(isnan(sh) ) = [];

if isempty(sh)
    vertices = [];
    edges = [];
    colors = [];
    disp('No quivergroups found.');
    return
end

%% process each quivergroup
N = size(sh, 1); % number of quivergroups
vertices = cell(1, N);
edges = cell(1, N);
colors = cell(1, N);
k = 0;
for i=1:N
    disp(['     Preprocessing quivergroup No.', num2str(i) ] );
    h = sh(i, 1);
    
    [v, lc, col] = single_quiver_preprocessor(h);
    
    n = size(v, 2);
    if n ~= 0
        I = k +(1:n);
        
        vertices(1, I) = v;
        edges(1, I) = lc;
        colors(1, I) = col;
    
        k = k +n;
    end
    
    %vertices{1, i} = v;
    %edges{1, i} = lc;
end

function [vertices, lines, colors] = single_quiver_preprocessor(h)
%% quiver body and head lines
ch = get(h, 'Children');

body_handle = ch(1);
head_handle = ch(2);

xb = get(body_handle, 'XData'); % 2 nan, 2 nan, ...
yb = get(body_handle, 'YData');
zb = get(body_handle, 'ZData');

xh = get(head_handle, 'XData'); % 3 nan, 3 nan, ...
yh = get(head_handle, 'YData');
zh = get(head_handle, 'ZData');

xb(isnan(xb) ) = [];
yb(isnan(yb) ) = [];
zb(isnan(zb) ) = [];

xh(isnan(xh) ) = [];
yh(isnan(yh) ) = [];
zh(isnan(zh) ) = [];

% 2d quiver ?
if isempty(zb)
    disp('2d quivergroup')
    zb = zeros(size(xb) );
    zh = zeros(size(xh) );
end

nb = size(xb, 2);
nh = size(xh, 2);
n = nb /2; % number of quiver vectors

disp(['Number of quiver vectors = ', num2str(n) ] )
disp(['Number of body points = ', num2str(nb) ] )
disp(['Number of head points = ', num2str(3*n), ' = ', num2str(nh) ] )

vb = [xb; yb; zb];
vh = [xh; yh; zh];

%[vertices, lines] = one_line_per_quivergroup(n, vb, vh);

% temporary way to avoid compression problems
[vertices, lines] = chopped_quivergroup(vb, vh);

quiver_color = {get(h, 'Color') };
m = size(vertices, 2);
colors = repmat(quiver_color, 1, m);

function [vertices, lines] = chopped_quivergroup(vb, vh)
vb = cut_line_to_pieces(vb, 2);
vh = cut_line_to_pieces(vh, 3);

nb = size(vb, 2);
body_base = {[1; 2]-1};
lb = repmat(body_base, 1, nb);

nh = size(vh, 2);
head_base = {[1:2; 2:3]-1};
lh = repmat(head_base, 1, nh);

vertices = [vb, vh];
lines = [lb, lh];

function [vertices, lines] = one_line_per_quivergroup(n, vb, vh)
m = 2*n;
body_indices = [1:2:m; 2:2:m] -1;

base = [1:2; 2:3];

j = -3;
head_indices = nan(2, m);
for i=1:n
    j = j +3;
    idx = 2*(i-1) +(1:2);
    head_indices(:, idx) = base+j;
end
head_indices = head_indices +nb -1; % shift for proper referencing

vertices = [vb, vh]; % matrix
lines = [body_indices, head_indices]; % matrix
