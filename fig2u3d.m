function [] = fig2u3d(ax, fname)
%SURF2U3D   Convert plotted surface to U3D file.
%
% usage
%   FIG2U3D
%   fvc = FIG2U3D(ax, fname)
%
% optional input
%   ax = axes object handle to export (default = gca)
%   fname = file name string, e.g. 'myfigure' (default = 'surface')
%           Note: The file extension '.idtf' is appended if omitted
%
% See also FIG2IDTF, IDTF2U3D, VIEW2VWS.
%
% File:      fig2u3d.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.06.10
% Language:  MATLAB R2012a
% Purpose:   convert figure to U3D file format (lines, surfaces)
% Copyright: Ioannis Filippidis, 2012-

% depends
%   u3d_pre_surface, u3d_pre_line, u3d_pre_quivergroup,
%   fig2idtf, idtf2u3d, view2vws

% todo
%   add point set export

%% input
if nargin < 1
    ax = gca;
else
    if ~ishandle(ax)
        ax = gca;
    end
end

% filename provided ?
if nargin < 2
    fname = 'surface.idtf';
end

% fname extension ok ?
if isempty(strfind(fname, '.idtf') )
    fname = [fname, '.idtf'];
end

%% plot axes
add_axes = 0;
if add_axes == 1
    held = takehold(ax);
    
    xax = [0, 0, 0; 1, 0, 0].';
    plotmd(ax, xax)

    yax = [0, 0, 0; 0, 1, 0].';
    plotmd(ax, yax)

    [~, dim] = axes_extremal_xyz(ax);
    if dim == 3
        zax = [0, 0, 0; 0, 0, 1].';
        plotmd(ax, zax)
    end
    
    restorehold(ax, held)
end

%% export
[surf_vertices, faces, facevertexcdata] = u3d_pre_surface(ax);
[line_vertices, line_edges] = u3d_pre_line(ax);
[quiver_vertices, quiver_edges] = u3d_pre_quivergroup(ax);

fig2idtf(fname,...
          surf_vertices, faces, facevertexcdata,...
          line_vertices, line_edges,...
          quiver_vertices, quiver_edges)

idtf2u3d(fname)
view2vws(ax)
