function [vertices, edges] = u3d_pre_line(ax)
%U3D_PRE_LINE   Preprocess line output to u3d.
%
% usage
%   points = U3D_PRE_LINE
%   points = U3D_PRE_LINE(ax)
%
% optional input
%   ax = axes object handle
%
% output
%   points = position vectors as columns of matrix, as row cell array,
%            for multiple lines
%          = {1 x #lines}
%          = {[3 x #points], ... }
%
% See also FIG2IDTF, U3D_PRE_SURFACE, U3D_PRE_QUIVERGROUP.
%
% File:      u3d_pre_line.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.06.10 - 
% Language:  MATLAB R2012a
% Purpose:   preprocess lineseries children of axes for u3d export
% Copyright: Ioannis Filippidis, 2012-

%% input
if nargin < 1
    sh = findobj('type', 'line');
else
    objs = get(ax, 'Children');
    % using full depth may be advantageous, but nans should then be treated instead
    sh = findobj(objs, 'flat', 'type', 'line');
end

if isempty(sh)
    vertices = [];
    edges = [];
    disp('No lines found.');
    return
end

%% process each line
N = size(sh, 1); % number of lines
vertices = cell(1, N);
edges = cell(1, N);
k = 0;
for i=1:N
    disp(['     Preprocessing line No.', num2str(i) ] );
    h = sh(i, 1);
    
    [curvertices, curedges] = single_line_preprocessor(h);
    
    n = size(curvertices, 2);
    
    vertices(1, k+(1:n) ) = curvertices;
    edges(1, k+(1:n) ) = curedges;
    
    k = k +n;
    
    %vertices{1, i} = curvertices;
    %edges{1, i} = curedges;
end

function [vertices, edges] = single_line_preprocessor(h)

% get defined data-points
X = get(h, 'XData');
Y = get(h, 'YData');
Z = get(h, 'ZData');

% 2d line ?
if isempty(Z)
    Z = zeros(size(X) );
end

v = meshgrid2vec(X, Y, Z);

%vertices = v;
%npnt = size(vertices, 2);
%edges = [1:(npnt-1); 2:npnt]-1;

%% temporary solution to reduces compression problems
v = cut_line_to_pieces(v, 10);

n = size(v, 2);
vertices = cell(1, n);
edges = cell(1, n);
for i=1:n
    curv = v{1, i};
    
    npnt = size(curv, 2);
    curedges = [1:(npnt-1); 2:npnt]-1;
    
    vertices{1, i} = curv;
    edges{1, i} = curedges;
end
