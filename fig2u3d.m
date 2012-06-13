function [] = fig2u3d(ax, fname, addaxes)
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
%   addaxes = show axes in u3d file (default = 0 (do not show) )
%           = 0 | 1 (do not show/ show, respectively)
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
%   axes_extremal_xyz, takehold, restorehold, quivermd

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

% show axes ?
if nargin < 3
    addaxes = 0;
end

plot_axes(addaxes)

%% export
[surf_vertices, faces, facevertexcdata, surf_renderers] = u3d_pre_surface(ax);
[line_vertices, line_edges, line_colors] = u3d_pre_line(ax);
[quiver_vertices, quiver_edges] = u3d_pre_quivergroup(ax);

quiver_colors = repmat({[0, 0, 1] }, 1, size(quiver_vertices, 2) );

line_vertices = [line_vertices, quiver_vertices];
line_edges = [line_edges, quiver_edges];
line_colors = [line_colors, quiver_colors];

fig2idtf(fname,...
          surf_vertices, faces, facevertexcdata,...
          line_vertices, line_edges, line_colors)

idtf2u3d(fname)

vwsfname = strrep(fname, '.idtf', '.vws');
part_renderers = surf_renderers;
view2vws(ax, vwsfname, part_renderers)

function plot_axes(addaxes)
if addaxes == 0
    return
end

held = takehold(ax);

x0 = [0, 0, 0].';

vx = [1, 0, 0].';
quivermd(ax, x0, vx)

vy = [0, 1, 0].';
quivermd(ax, x0, vy)

[~, dim] = axes_extremal_xyz(ax);
if dim == 3
    vz = [0, 0, 1].';
    quivermd(ax, x0, vz)
end

restorehold(ax, held)
