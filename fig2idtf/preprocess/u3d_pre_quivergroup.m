function [vertices, edges] = u3d_pre_quivergroup(ax)
%U3D_PRE_QUIVERGROUP    Preprocess quiver output to u3d.
%
% usage
%   [vertices, edges] = U3D_PRE_QUIVERGROUP
%   [vertices, edges] = U3D_PRE_QUIVERGROUP(ax)
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
    disp('No quivergroups found.');
    return
end

%% process each quivergroup
N = size(sh, 1); % number of quivergroups
vertices = cell(1, N);
edges = cell(1, N);
k = 0;
for i=1:N
    disp(['     Preprocessing quivergroup No.', num2str(i) ] );
    h = sh(i, 1);
    
    [v, lc] = single_quiver_preprocessor(h);
    
    n = size(v, 2);
    
    vertices(1, k+(1:n) ) = v;
    edges(1, k+(1:n) ) = lc;
    
    k = k +n;
    
    %vertices{1, i} = v;
    %edges{1, i} = lc;
end

function [vertices, line_connectivity] = single_quiver_preprocessor(h)
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

m = 2*n;
body_indices = [1:2:m; 2:2:m] -1;

base = [1:2; 2:3];

j = -3;
head_indices = nan(2, 2*n);
for i=1:n
    j = j +3;
    idx = 2*(i-1) +(1:2);
    head_indices(:, idx) = base+j;
end
head_indices = head_indices +nb -1; % shift for proper referencing

disp(['Number of quiver vectors = ', num2str(n) ] )
disp(['Number of body points = ', num2str(m), ' = ', num2str(nb) ] )
disp(['Number of head points = ', num2str(3*n), ' = ', num2str(nh) ] )

vb = [xb; yb; zb];
vh = [xh; yh; zh];

%vertices = [vb, vh];
%line_connectivity = [body_indices, head_indices];

%% temporary way to avoid compression problems
vb = cut_line_to_pieces(vb, 2);
lb = cut_line_to_pieces(body_indices, 1);

vh = cut_line_to_pieces(vh, 3);
lh = cut_line_to_pieces(head_indices, 2);

vertices = [vb, vh];
line_connectivity = [lb, lh];
