function [vertices, edges, colors] = u3d_pre_contourgroup(ax)
% File:      u3d_pre_contourgroup.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.06.15 - 
% Language:  MATLAB R2012a
% Purpose:   preprocess contourgroup children of axes for u3d export
% Copyright: Ioannis Filippidis, 2012-

% todo
%   filled contourgroups

%% input
if nargin < 1
    sh = findobj('type', 'hggroup');
else
    objs = get(ax, 'Children');
    sh = findobj(objs, 'type', 'hggroup');
end

% hggroup = contourgroup ?
for i=1:size(sh, 1)
    cursh = sh(i, 1);
    
    if ~isprop(cursh, 'ContourMatrix')
        sh(i, 1) = nan;
    end
end

sh(isnan(sh) ) = [];

if isempty(sh)
    vertices = [];
    edges = [];
    colors = [];
    disp('No contourgroups found.');
    return
end

%% process each contourgroup
N = size(sh, 1); % number of quivergroups
vertices = cell(1, N);
edges = cell(1, N);
colors = cell(1, N);
k = 0;
for i=1:N
    disp(['     Preprocessing contourgroup No.', num2str(i) ] );
    h = sh(i, 1);
    
    [v, lc, col] = single_contour_preprocessor(h);
    
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

function [vertices, edges, colors] = single_contour_preprocessor(h)

% filled ?
f = get(h, 'Fill');
if strcmp(f, 'on')
    warning('contour:u3d_pre', 'Filled contourgoup not yet implemented.')
    vertices = {};
    edges = {};
    colors = {};
    return
end

hc = get(h, 'Children');

for i=1:length(hc)
    curhc = hc(i, 1);
    
    % LineColor
    v = get(curhc, 'Vertices').';
    n = size(v, 2) -1;
    v = v(:, 1:n); % get rid of the nans
    v = [v; zeros(1, n) ];
    
    e = [1:n; 2:n, 1] -1;
    
    %facevertexcdata = get(h, 'FaceVertexCData');

    cdata = get(curhc, 'CData');
    siz = size(cdata);
    cmap = colormap;
    nColors = size(cmap, 1);
    cax = caxis;
    idx = ceil( (double(cdata) -cax(1) ) / (cax(2) -cax(1) ) *nColors);
    idx(idx < 1) = 1;
    idx(idx > nColors) = nColors;
    %handle nans in idx
    nanmask = isnan(idx);
    idx(nanmask) = 1; %temporarily replace w/ a valid colormap index
    realcolor = zeros(siz);
    for j = 1:3,
        c = cmap(idx, j);
        c = reshape(c, siz);
        realcolor(:, :, j) = c;
    end

    vertices{1, i} = v;
    edges{1, i} = e;
    colors{1, i} = squeeze(realcolor(1, 1, :) );
end

% LineStyle = {-} | -- | : | -. | none

